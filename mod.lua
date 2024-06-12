Mod = {}
function initMod()
	local lovely = require("lovely")
	local nativefs = require("nativefs")
	assert(load(nativefs.read(lovely.mod_dir .. "/BUMod/main.lua")))()
	assert(load(nativefs.read(lovely.mod_dir .. "/BUMod/language_handler.lua")))()
end
