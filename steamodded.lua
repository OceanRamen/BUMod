if Malverk then
	local result_keys = {}
	for _, definition in ipairs(BUMod.CARDS) do
		table.insert(result_keys, "bumod_" .. definition.key)
		AltTexture(definition)
	end

	local pack = TexturePack({
		key = "bu_textures",
		textures = result_keys,
		loc_txt = {
			name = "BUMod",
			text = { "Balatro University", "themed cards" },
		},
	})

	local create_texture_card_ref = create_texture_card
	function create_texture_card(area, texture_pack)
		local card = create_texture_card_ref(area, texture_pack)
		if texture_pack == pack.key then
			card:set_edition({ negative = true }, true, true)
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
	SMODS.Atlas({
		key = "Tarot",
		px = 71,
		py = 95,
		path = "Tarots.png",
		atlas_table = "ASSET_ATLAS",
		raw_key = true,
	})
end

for _, asset in ipairs(BUMod.COLLABS) do
	local lc_atlas = SMODS.Atlas({
		key = asset.key .. "_1",
		path = "collabs/" .. asset.key .. "_1.png",
		px = 71,
		py = 95,
		atlas_table = "ASSET_ATLAS",
	})
	local hc_atlas = SMODS.Atlas({
		key = asset.key .. "_2",
		px = 71,
		py = 95,
		path = "collabs/" .. asset.key .. "_2.png",
		atlas_table = "ASSET_ATLAS",
	})
	SMODS.DeckSkin({
		key = asset.key,
		suit = asset.suit,
		loc_txt = asset.loc_txt,
		palettes = {
			{
				key = "lc",
				ranks = { "Jack", "Queen", "King" },
				display_ranks = { "Jack", "Queen", "King" },
				pos_style = "collab",
				atlas = lc_atlas.key,
			},
			{
				key = "hc",
				ranks = { "Jack", "Queen", "King" },
				display_ranks = { "Jack", "Queen", "King" },
				pos_style = "collab",
				atlas = hc_atlas.key,
			},
		},
	})
end
