local lovely = require("lovely")
local nativefs = require("nativefs")

function update_file()
	-- Load both localization files
	local loc1 = assert(loadstring(Mod.lang_BU()))()
	local loc2 = assert(loadstring(love.filesystem.read("localization/" .. "en-us" .. ".lua")))()

	-- Function to recursively add missing keys from source to target
	local function add_missing_keys(target, source)
		for key, value in pairs(source) do
			if type(value) == "table" then
				-- If the key exists in target and is a table, recursively check it
				if type(target[key]) == "table" then
					add_missing_keys(target[key], value)
				else
					-- If the key is missing or not a table, add the entire table from source
					target[key] = value
				end
			else
				-- If the key is missing or not a table, add the value from source
				if target[key] == nil then
					target[key] = value
				end
			end
		end
	end

	-- Add missing keys from loc2 to loc1
	add_missing_keys(loc1, loc2)

	-- Save the updated localization file
	local file = io.open(Mod.PATH .. "/Languages/BU.lua", "w")
	assert(file)
	local function serialize_table(tbl, indent)
		local result = ""
		indent = indent or ""
		local next_indent = indent .. "  "
		result = result .. "{\n"
		for k, v in pairs(tbl) do
			local key = type(k) == "string" and string.format("%q", k) or k
			if type(v) == "table" then
				result = result .. next_indent .. "[" .. key .. "] = " .. serialize_table(v, next_indent) .. ",\n"
			else
				local value = type(v) == "string" and string.format("%q", v) or tostring(v)
				result = result .. next_indent .. "[" .. key .. "] = " .. value .. ",\n"
			end
		end
		result = result .. indent .. "}"
		return result
	end

	file:write("return " .. serialize_table(loc1))
	return loc1
end

function Mod.lang_BU()
	if Mod.UPDATE == true then
		Mod.UPDATE = false
		update_file()
	end
	return nativefs.read(Mod.PATH .. "/Languages/BU.lua")
end

local setLangRef = Game.set_language
function Game:set_language()
	setLangRef(self)
	local buLanguage = {
		font = self.FONTS[1],
		label = "Balatro Uni",
		key = "bu",
		beta = nil,
		button = "Language Feedback",
		warning = {
			"This language is still in Beta.",
			"Click again to confirm",
		},
	}
	self.LANGUAGES["bu"] = buLanguage

	self.LANG = self.LANGUAGES[self.SETTINGS.language] or self.LANGUAGES["en-us"]

	local localization = love.filesystem.getInfo("localization/" .. G.SETTINGS.language .. ".lua")
	if G.SETTINGS.language == "BU" then
		self.localization = assert(loadstring(Mod.lang_BU()))()
		init_localization()
	end
	if localization ~= nil and G.SETTINGS.language ~= "BU" then
		self.localization = assert(loadstring(love.filesystem.read("localization/" .. G.SETTINGS.language .. ".lua")))()
		init_localization()
	end
end
