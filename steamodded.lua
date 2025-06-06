BUMod.current_mod = SMODS.current_mod

SMODS.Atlas({
	key = "modicon",
	path = "icon.png",
	px = 48,
	py = 48,
})

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
	SMODS.Atlas({
		key = "Voucher",
		px = 71,
		py = 95,
		path = "Vouchers.png",
		atlas_table = "ASSET_ATLAS",
		raw_key = true,
	})
	SMODS.Atlas({
		key = "Booster",
		px = 71,
		py = 95,
		path = "boosters.png",
		atlas_table = "ASSET_ATLAS",
		raw_key = true,
	})
	SMODS.Atlas({
		key = "tags",
		px = 34,
		py = 34,
		path = "tags.png",
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
				hc_default = true,
			},
		},
	})
end

BUMod.current_mod.credits_tab = function()
	local code_contributors = {}
	for _, contributor in ipairs(BUMod.CREDITS.CODE_CONTRIBUTORS) do
		table.insert(code_contributors, {
			n = G.UIT.R,
			config = { padding = 0.025 },
			nodes = {
				{
					n = G.UIT.T,
					config = {
						text = contributor.text .. " ",
						scale = 0.3,
						colour = G.C.UI.TEXT_LIGHT,
						align = "cm",
					},
				},
				{
					n = G.UIT.T,
					config = {
						text = contributor.name,
						scale = 0.3,
						colour = G.C.ORANGE,
						align = "cm",
					},
				},
			},
		})
	end
	local art_contributors = {}
	for _, contributor in ipairs(BUMod.CREDITS.ART_CONTRIBUTORS) do
		table.insert(art_contributors, {
			n = G.UIT.R,
			config = { padding = 0.025 },
			nodes = {
				{
					n = G.UIT.T,
					config = {
						text = contributor.name,
						scale = 0.3,
						colour = G.C.MONEY,
						align = "cm",
					},
				},
				{
					n = G.UIT.T,
					config = {
						text = " - ",
						scale = 0.3,
						colour = G.C.UI.TEXT_LIGHT,
						align = "cm",
					},
				},
				{
					n = G.UIT.T,
					config = {
						text = contributor.text,
						scale = 0.3,
						colour = G.C.UI.TEXT_LIGHT,
						align = "cm",
					},
				},
			},
		})
	end

	return {
		n = G.UIT.ROOT,
		config = {
			align = "cm",
			padding = 0.05,
			colour = G.C.CLEAR,
		},
		nodes = {
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "cm",
				},
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = DynaText({
								string = "Balatro University Mod",
								colours = { G.C.MONEY },
								shadow = true,
								scale = 0.8,
								float = true,
								spacing = 5,
							}),
						},
					},
				},
			},
			{
				n = G.UIT.R,
				config = { minh = 0.15 },
			},
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "cm",
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = "Special for DrSpectred",
							shadow = true,
							scale = 0.45,
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
				},
			},
			{
				n = G.UIT.R,
				config = { minh = 0.25 },
			},
			{
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.R,
						nodes = {
							{
								n = G.UIT.R,
								config = {
									padding = 0.2,
									colour = G.C.BLACK,
									r = 0.05,
									minw = 6.65,
									align = "m",
								},
								nodes = {
									{
										n = G.UIT.R,
										config = {
											align = "cm",
										},
										nodes = {
											{
												n = G.UIT.T,
												config = {
													text = "Code contributors",
													scale = 0.45,
													colour = G.C.UI.TEXT_LIGHT,
													align = "cm",
												},
											},
										},
									},
									{
										n = G.UIT.R,
										config = {
											align = "cm",
										},
										nodes = code_contributors,
									},
								},
							},
						},
					},
					{
						n = G.UIT.R,
						config = { minh = 0.15 },
					},
					{
						n = G.UIT.R,
						nodes = {
							{
								n = G.UIT.R,
								config = {
									padding = 0.2,
									colour = G.C.BLACK,
									r = 0.05,
									minw = 6.65,
									align = "m",
								},
								nodes = {
									{
										n = G.UIT.R,
										config = {
											align = "cm",
										},
										nodes = {
											{
												n = G.UIT.T,
												config = {
													text = "Art contributors",
													scale = 0.45,
													colour = G.C.UI.TEXT_LIGHT,
													align = "cm",
												},
											},
										},
									},
									{
										n = G.UIT.R,
										config = {
											align = "cm",
										},
										nodes = {
											{
												n = G.UIT.C,
												config = { align = "cm" },
												nodes = art_contributors,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}
end
