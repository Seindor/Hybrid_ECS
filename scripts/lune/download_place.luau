local net = require("@lune/net")
local roblox = require("@lune/roblox")
local config = require("./config")
local fs = require("@lune/fs")

local function downloadPlaceAsset(placeId)
	local cookie = roblox.getAuthCookie()
	assert(cookie, "Failed to get auth cookie")

	local result = net.request({
		url = "https://assetdelivery.roblox.com/v1/asset/",
		headers = {
			Cookie = cookie,
		},
		query = {
			id = tostring(placeId),
		},
	})

	assert(result.ok, result.body)

	return result.body
end

local content = downloadPlaceAsset(config.GLOBAL_CONFIG.DEV_PLACE_ID)
fs.writeFile(`./temp/{config.GLOBAL_CONFIG.ORIGIN_NAME}.rbxl`, content)

--[[ 
^ lune script gets the selected file via assets
then we use syncback with yet another project.json so that we can access config and info files (prob a syncback or config dir)
then we copy these files into already existing ones (ones in the src)
-- ^ this method should be used to build project

-- but i still do need a method to use serve -- < serve will be used only in a local build file

so the overall structure will look like this
1. lune script to clone assets and config
2. use syncback to get config + assets and place them into a temp file
3. when the file has been updated, clone (syncback) the updated files into a regular src dir
4. then use start default serve on the built file
5. whenever ready do the steps 1-3 again (prob make it a proper command) and use upload to upload build file onto the real place
]]
