--!strict
--[[
	Общий раннер анимаций. Раньше Spring / MoveFrame / CurrencyPopup
	каждый писал свой Heartbeat + elapsed + Disconnect.

	Соединение кладётся в janitor агрегата по ключу `key`:
	  * повторный запуск с тем же ключом отменяет предыдущую анимацию;
	  * при Destroy агрегата анимация останавливается сама.
]]

local RunService = game:GetService("RunService")

local TypedAggregates = require(script.Parent.Parent.Types.TypedAggregates)

local Animator = {}

function Animator.Run(
	host: TypedAggregates.IEffectHost,
	key: string,
	duration: number,
	onStep: (alpha: number, elapsed: number) -> (),
	onComplete: (() -> ())?
)
	local janitor = host._janitor

	if janitor == nil then return end

	-- нулевая/отрицательная длительность: сразу в конечное состояние
	-- (раньше тут было деление на 0)
	if duration <= 0 then
		janitor:Remove(key)
		onStep(1, 0)
		if onComplete then onComplete() end
		return
	end

	local elapsed = 0

	-- PreRender - клиентский аналог RenderStepped, обновляем UI до отрисовки кадра
	janitor:Add(
		RunService.PreRender:Connect(function(dt: number)
			elapsed += dt
			local alpha = math.min(elapsed / duration, 1)

			onStep(alpha, elapsed)

			if alpha >= 1 then
				janitor:Remove(key) -- отключает это же соединение
				if onComplete then onComplete() end
			end
		end),
		"Disconnect",
		key
	)
end

return Animator
