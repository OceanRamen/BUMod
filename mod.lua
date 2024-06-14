Mod = {}
function initMod()
	local lovely = require("lovely")
	local nativefs = require("nativefs")
	assert(load(nativefs.read(lovely.mod_dir .. "/BUMod/main.lua")))()
	assert(load(nativefs.read(lovely.mod_dir .. "/BUMod/language_handler.lua")))()
end

function initAssets()
	local lovely = require("lovely")
	local nativefs = require("nativefs")
	assert(load(nativefs.read(lovely.mod_dir .. "/BUMod/assets/2x/test.lua")))() -- test.lua: print("HELLO FROM TEST.LUA")
	--  OUTPUT: "HELLO FROM TEST.LUA"
	print(nativefs.getDirectoryItems(lovely.mod_dir .. "/BUMod/assets/2x/"))
	local assets = {
		{
			name = "Joker",
			path = lovely.mod_dir .. "/BUMod/assets/" .. G.SETTINGS.GRAPHICS.texture_scaling .. "x/Jokers.png",
			px = 71,
			py = 95,
		},
	}
	G.ASSET_ATLAS = G.ASSET_ATLAS or {}

	for i = 1, #assets do
		local asset = assets[i]
		local path = asset.path
		print("Loading asset from path:", path)

		if not nativefs.getInfo(path) then
			print("Error: Path does not exist:", path)
		end

		local success, image =
			pcall(love.graphics.newImage, path, { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })
		if success then
			G.ASSET_ATLAS[asset.name] = {
				name = asset.name,
				image = image,
				type = asset.type,
				px = asset.px,
				py = asset.py,
			}
		else
			print("Error loading image:", image)
		end
	end
end
