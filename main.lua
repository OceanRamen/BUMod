local lovely = require("lovely")
local nativefs = require("nativefs")

BUMod = {}
BUMod.INITIALIZED = true
BUMod.VER = "v1.1.0-beta"
BUMod.PATH = nil
BUMod.UPDATE = true

local mod_dir = lovely.mod_dir -- Cache the base directory
local found = false
local search_str = "bumod"

for _, item in ipairs(nativefs.getDirectoryItems(mod_dir)) do
	local itemPath = mod_dir .. "/" .. item
	-- Check if the item is a directory and contains the search string
	if nativefs.getInfo(itemPath, "directory") and string.lower(item):find(search_str) then
		BUMod.PATH = itemPath
		found = true
		break
	end
end

-- Raise an error if the directory wasn't found
if not found then
	error("ERROR: Unable to locate BuMod directory.")
end

--- @generic T
--- @generic S
--- @param target T
--- @param source S
--- @param ... any
--- @return T | S
function BUMod.table_merge(target, source, ...)
	assert(type(target) == "table", "Target is not a table")
	local tables_to_merge = { source, ... }
	if #tables_to_merge == 0 then
		return target
	end

	for k, t in ipairs(tables_to_merge) do
		assert(type(t) == "table", string.format("Expected a table as parameter %d", k))
	end

	for i = 1, #tables_to_merge do
		local from = tables_to_merge[i]
		for k, v in pairs(from) do
			if type(v) == "table" then
				if v.__override then
					v.__override = nil
					target[k] = v
				else
					target[k] = target[k] or {}
					target[k] = BUMod.table_merge(target[k], v)
				end
			else
				target[k] = v
			end
		end
	end

	return target
end

function BUMod.get_localization()
	return assert(loadstring(nativefs.read(BUMod.PATH .. "/localization/bu.lua")))()
end

function BUMod.setup_language()
	G.LANGUAGES["bu"] = {
		font = 1,
		label = "Balatro Uni",
		key = "bu",
		beta = nil,
		button = "Language Feedback",
		warning = {
			"This language is still in Beta.",
			"Click again to confirm",
		},
	}
end

local game_set_language_ref = Game.set_language
function Game:set_language(...)
	-- Store initially loaded language
	BUMod.language_buffer = G.SETTINGS.language

	-- Load english localization if BU is selected
	if G.SETTINGS.language == "bu" then
		G.SETTINGS.language = "en-us"
	end

	return game_set_language_ref(self, ...)
end

local init_localization_ref = init_localization
function init_localization(...)
	-- If initially loaded language is BU, select it
	if BUMod.language_buffer == "bu" then
		G.SETTINGS.language = "bu"
		G.LANG = G.LANGUAGES["bu"]
	end
	BUMod.language_buffer = nil

	-- If current language is BU, apply it
	if G.SETTINGS.language == "bu" then
		G.localization = BUMod.table_merge({}, G.localization, BUMod.get_localization())
	end
	return init_localization_ref(...)
end

function BUMod.setup_sprites()
	-- Don't do anything if SMODS present
	if SMODS and SMODS.can_load then
		return
	end

	local asset = {
		name = "Joker",
		path = BUMod.PATH .. "/assets/" .. G.SETTINGS.GRAPHICS.texture_scaling .. "x/Jokers.png",
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
