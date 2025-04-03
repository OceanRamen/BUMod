if Malverk then
	local textures_to_load = {
		{
			key = "joker_scholar_drspectred",
			path = "single_jokers/j_scholar.png",
			set = "Joker",
			keys = { "j_scholar" },
			loc_txt = {
				name = "Scholar DrSpectred",
				text = { "Replace Scholar with DrSpectred" },
			},
		},
		{
			key = "joker_showman_chip",
			path = "single_jokers/j_ring_master.png",
			set = "Joker",
			keys = { "j_ring_master" },
			loc_txt = {
				name = "Showman Chip",
				text = { "Replace Showman with Chip" },
			},
		},
		{
			key = "joker_space_zaino",
			path = "single_jokers/j_space.png",
			set = "Joker",
			keys = { "j_space" },
			loc_txt = {
				name = "Spaceman Zaino",
				text = { "Replace Spaceman with Zaino" },
			},
		},
	}

	local result_keys = {}
	for _, definition in ipairs(textures_to_load) do
		table.insert(result_keys, "bumod_" .. definition.key)
		AltTexture(definition)
	end

	local pack = TexturePack({
		key = "bu_textures",
		textures = result_keys,
		loc_txt = {
			name = "BUMod",
			text = { "Balatro University", "themed Jokers" },
		},
	})

	local create_texture_card_ref = create_texture_card
	function create_texture_card(area, texture_pack)
		local card = create_texture_card_ref(area, texture_pack)
		if texture_pack == pack.key then
			card:set_edition({ negative = true }, true)
		end
		return card
	end
else
	SMODS.Atlas({
		key = "Joker",
		px = 71,
		py = 95,
		path = "Jokers.png",
		atlas_table = "ASSET_ATLAS",
		raw_key = true,
	})
end
