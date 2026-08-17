--!strict
--[[
	gen-di-registry.luau

	Порт gen-di-registry.cjs. Запускается через Lune (не внутри Roblox):
		lune run gen-di-registry

	Отличие от TS-версии: вместо ES-import генерируем require(script.Parent...) —
	цепочка Parent считается сравнением путей на диске (fromDir = папка сгенерированного
	файла = его script.Parent в рантайме, toFile = абсолютный путь до *Token.luau).

	NB: имена функций @lune/fs (readDir/isDir/writeFile/writeDir) даны по актуальной на
	момент написания версии Lune — если у тебя другая версия и что-то не совпадёт по
	имени, это единственное, что может потребовать правки.
]]

local fs = require("@lune/fs")
local process = require("@lune/process")

type Target = {
	providersRoot: string,
	outFile: string,
	typeName: string,
}

-- process.cwd в Lune — строка с уже добавленным / на конце
local PROJECT_ROOT = (process.cwd :: string):gsub("/+$", "")

local targets: { Target } = {
	{
		providersRoot = "src/server/DI/ServerProviders",
		outFile = "src/server/DI/Generated/ServerRegistry.luau",
		typeName = "ServerRegistry",
	},
	{
		providersRoot = "src/shared/DI/SharedProviders",
		outFile = "src/shared/DI/Generated/SharedRegistry.luau",
		typeName = "SharedRegistry",
	},
	{
		providersRoot = "src/shared/DI/ClientProviders",
		outFile = "src/shared/DI/Generated/ClientRegistry.luau",
		typeName = "ClientRegistry",
	},
}

--============================================================
-- Пути: Lune не даёt path-модуль, join/split — ручные, через "/"
--============================================================

local function joinPath(...: string): string
	local nonEmpty = {}
	for _, part in { ... } do
		if part ~= "" then table.insert(nonEmpty, (part:gsub("/+$", ""))) end
	end
	return table.concat(nonEmpty, "/")
end

local function splitPath(p: string): { string }
	local parts = {}
	for part in p:gmatch("[^/]+") do
		table.insert(parts, part)
	end
	return parts
end

--============================================================
-- Обход директории в поисках *Token.luau (аналог walkForTokens из .cjs)
--============================================================

local function walkForTokens(dir: string, base: string): { string }
	local results = {}

	for _, name in fs.readDir(dir) do
		local fullPath = joinPath(dir, name)
		local relPath = base == "" and name or joinPath(base, name)

		if fs.isDir(fullPath) then
			for _, found in walkForTokens(fullPath, relPath) do
				table.insert(results, found)
			end
		elseif name:match("Token%.luau$") then
			table.insert(results, relPath)
		end
	end

	return results
end

--============================================================
-- PascalCase: kebab/snake -> Pascal, уже-капс куски не трогаем (аналог pascal() из .cjs)
--============================================================

local function pascal(input: string): string
	local out = {}
	for piece in input:gmatch("[^%-_]+") do
		if piece == piece:upper() then
			table.insert(out, piece)
		else
			table.insert(out, piece:sub(1, 1):upper() .. piece:sub(2))
		end
	end
	return table.concat(out)
end

--============================================================
-- Дерево реестра (аналог setTree из .cjs)
--============================================================

local function setTree(tree: { [string]: any }, pathParts: { string }, alias: string)
	local current = tree

	for i = 1, #pathParts - 1 do
		local key = pathParts[i]
		if typeof(current[key]) ~= "table" then current[key] = {} end
		current = current[key]
	end

	local leafKey = pathParts[#pathParts]
	if current[leafKey] ~= nil then error(`Duplicate registry path: {table.concat(pathParts, ".")}`) end
	current[leafKey] = alias
end

--============================================================
-- Печать дерева как Luau-таблицы (аналог emitObject из .cjs)
--============================================================

local function emitObject(tree: { [string]: any }, indent: number): string
	local pad = string.rep("\t", indent)

	local keys = {}
	for key in tree do
		table.insert(keys, key)
	end
	table.sort(keys)

	local lines = {}
	for _, key in keys do
		local value = tree[key]
		if typeof(value) == "string" then
			table.insert(lines, pad .. "\t" .. key .. " = " .. value .. ",")
		else
			table.insert(lines, pad .. "\t" .. key .. " = " .. emitObject(value, indent + 1) .. ",")
		end
	end

	return "{\n" .. table.concat(lines, "\n") .. "\n" .. pad .. "}"
end

--============================================================
-- require(script.Parent...) цепочка: fromDir = папка итогового файла (его script.Parent),
-- toFile = абсолютный путь до *Token.luau. Та же логика, что при ручном расчёте раньше:
-- script.Parent эквивалентен fromDir, поэтому "Parent" повторяется (ups + 1) раз.
--============================================================

local function requireChain(fromDir: string, toFile: string): string
	local toNoExt = (toFile:gsub("%.luau$", ""))

	local fromParts = splitPath(fromDir)
	local toParts = splitPath(toNoExt)

	local common = 0
	while common < #fromParts and common < #toParts and fromParts[common + 1] == toParts[common + 1] do
		common += 1
	end

	local ups = #fromParts - common

	local segs = { "script" }
	for _ = 1, ups + 1 do
		table.insert(segs, "Parent")
	end
	for i = common + 1, #toParts do
		table.insert(segs, toParts[i])
	end

	return table.concat(segs, ".")
end

--============================================================
-- Основной цикл
--============================================================

for _, target in targets do
	local providersRootAbs = joinPath(PROJECT_ROOT, target.providersRoot)

	if not fs.isDir(providersRootAbs) then continue end

	local outAbs = joinPath(PROJECT_ROOT, target.outFile)
	local outDirAbs = outAbs:match("^(.*)/[^/]+$")
	assert(outDirAbs, `DI codegen: не удалось вычислить папку для {outAbs}`)

	local tokenFiles = walkForTokens(providersRootAbs, "")
	table.sort(tokenFiles)

	local tree: { [string]: any } = {}
	local requireLines = {}
	local idx = 0

	for _, tokenRelPath in tokenFiles do
		local tokenFileAbs = joinPath(providersRootAbs, tokenRelPath)
		local chain = requireChain(outDirAbs, tokenFileAbs)

		local alias = "__token" .. tostring(idx)
		idx += 1
		-- .token — потому что *Token.luau возвращает { token = ... }, а не голый токен
		table.insert(requireLines, `local {alias} = require({chain}).token`)

		local parts = splitPath(tokenRelPath)
		if #parts < 2 then continue end

		-- все сегменты пути КРОМЕ папки-провайдера и самого файла токена,
		-- с фильтрацией "Singletons" — она всё равно жёстко прописывается ниже
		local categories = {}
		for i = 1, #parts - 2 do
			local part = pascal(parts[i])
			if part:lower() ~= "singletons" then table.insert(categories, part) end
		end

		local leafFile = parts[#parts]
		local leaf = pascal((leafFile:gsub("Token%.luau$", "")))

		local fullPath = { "Singletons" }
		for _, category in categories do
			table.insert(fullPath, category)
		end
		table.insert(fullPath, leaf)

		setTree(tree, fullPath, alias)
	end

	local contentParts = {
		"--!strict",
		"--[[ AUTO-GENERATED by gen-di-registry.luau. DO NOT EDIT. ]]",
		"",
		table.concat(requireLines, "\n"),
		"",
		"return " .. emitObject(tree, 0),
		"",
	}

	fs.writeDir(outDirAbs)
	fs.writeFile(outAbs, table.concat(contentParts, "\n"))

	print(`DI codegen: {target.typeName} -> {target.outFile} ({idx} токенов)`)
end
