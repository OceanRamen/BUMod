local lovely = require("lovely")
local nativefs = require("nativefs")
Mod = {}
Mod.INITIALIZED = true
Mod.VER = "BU v1.0.1-alpha"
Mod.PATH = nil
Mod.UPDATE = true

local mod_dir = lovely.mod_dir -- Cache the base directory
local found = false
local search_str = "bumod"

for _, item in ipairs(nativefs.getDirectoryItems(mod_dir)) do
	local itemPath = mod_dir .. "/" .. item
	-- Check if the item is a directory and contains the search string
	if nativefs.getInfo(itemPath, "directory") and string.lower(item):find(search_str) then
		Mod.PATH = itemPath
		found = true
		break
	end
end

-- Raise an error if the directory wasn't found
if not found then
	error("ERROR: Unable to locate BuMod directory.")
end

-- Local function to load modules, handling errors gracefully
local function loadModule(path)
	local lovely = require("lovely")
	local nativefs = require("nativefs")
	local filePath = Mod.PATH .. path
	local fileContent = nativefs.read(filePath)
	if fileContent then
		local success, err = pcall(load(fileContent))
		if not success then
			print(("Error loading module %s: %s"):format(path, err))
		end
	else
		print(("Failed to read module file at %s"):format(filePath))
	end
end

-- Initializes game modifications
function InitMod()
	loadModule("/language_handler.lua")
end

function InitAssets()
	local lovely = require("lovely")
	local nativefs = require("nativefs")
	local asset = {
		name = "Joker",
		path = Mod.PATH .. "/assets/" .. G.SETTINGS.GRAPHICS.texture_scaling .. "x/Jokers.png",
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
