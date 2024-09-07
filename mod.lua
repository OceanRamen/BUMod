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
	local asset = {
		name = "Joker",
		path = lovely.mod_dir .. "/BUMod/assets/" .. G.SETTINGS.GRAPHICS.texture_scaling .. "x/Jokers.png",
		px = 71,
		py = 95,
	}

	local file_data =
		assert(nativefs.newFileData(asset.path), ("Failed to collect file data for Atlas %s"):format(asset.name))
	local image_data =
		assert(love.image.newImageData(file_data), ("Failed to initialize image data for Atlas %s"):format(asset.name))
	local image = love.graphics.newImage(image_data, { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })

	G.ASSET_ATLAS[asset.name] = {
		name = asset.name,
		image = image,
		type = asset.type,
		px = asset.px,
		py = asset.py,
	}
end
