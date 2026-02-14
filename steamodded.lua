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
	for _, definition in ipairs(BUMod.CARDS) do
		local atlas = SMODS.Atlas({
			key = definition.key,
			px = definition.px or 71,
			py = definition.py or 95,
			atlas_table = "ASSET_ATLAS",
			path = definition.path,
		})
		for index, key in ipairs(definition.keys) do
			local x = index - 1
			local y = math.floor((index - 1) / (definition.line_size or math.huge))
			if definition.line_size then
				x = x % definition.line_size
			end
			SMODS[definition.set]:take_ownership(key, {
				atlas = atlas.key,
				pos = {
					x = x,
					y = y,
				},
			})
		end
	end
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

local random_cards = {
	"j_ring_master",
	"j_space",
	"j_duo",
	"j_family",
	"j_idol",
	"j_turtle_bean",
	"j_trading",
	"j_troubadour",
	"j_vampire",
	"j_rocket",
	"j_banner",
	"j_hit_the_road",
	"j_cloud_9",
	"j_fibonacci",
	"j_lucky_cat",
	"j_joker",
	"j_lusty_joker",
	"j_smiley",
	"j_photograph",
	"j_runner",
	"c_hanged_man",
	"v_hone",
}

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
		local text_lines = contributor.text
		if type(text_lines) == "string" then
			text_lines = { text_lines }
		end
		for i, line in ipairs(text_lines) do
			table.insert(art_contributors, {
				n = G.UIT.R,
				config = { padding = 0.025 },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = contributor.name,
							scale = 0.3,
							colour = i == 1 and G.C.MONEY or G.C.CLEAR,
							align = "cm",
						},
					},
					{
						n = G.UIT.T,
						config = {
							text = " - ",
							scale = 0.3,
							colour = i == 1 and G.C.UI.TEXT_LIGHT or G.C.CLEAR,
							align = "cm",
						},
					},
					{
						n = G.UIT.T,
						config = {
							text = line,
							scale = 0.3,
							colour = G.C.UI.TEXT_LIGHT,
							align = "cm",
						},
					},
				},
			})
		end
	end

	local doc_card_area = CardArea(0, 0, G.CARD_W, G.CARD_H, {
		highlight_limit = 0,
		type = "title",
		card_limit = 1,
	})
	local doc_card = Card(0, 0, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS.j_scholar)
	doc_card:set_edition({ negative = true }, true, true)
	doc_card_area:emplace(doc_card)
	function doc_card:hover()
		Moveable.hover(self)
	end

	local random_card_area = CardArea(0, 0, G.CARD_W, G.CARD_H, {
		highlight_limit = 0,
		type = "title",
		card_limit = 1,
	})

	local random_index = math.random(#random_cards)
	local random_card = Card(0, 0, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[random_cards[random_index]])
	random_card_area:emplace(random_card)
	function random_card:click()
		random_index = random_index + 1
		if random_index > #random_cards then
			random_index = 1
		end
		local new_center = G.P_CENTERS[random_cards[random_index]]
		self:set_ability(new_center, true, true)
		G.E_MANAGER:add_event(Event({
			func = function()
				self:juice_up(0.05, 0.05)
				return true
			end,
		}))
		Moveable.click(self)
	end
	function random_card:hover()
		Moveable.hover(self)
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
						n = G.UIT.C,
						nodes = {
							{
								n = G.UIT.O,
								config = {
									object = doc_card_area,
								},
							},
						},
					},
					{
						n = G.UIT.C,
						config = { minw = 0.1 },
					},
					{
						n = G.UIT.C,
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm" },
								nodes = {
									{
										n = G.UIT.R,
										config = { align = "cm" },
										nodes = {
											{
												n = G.UIT.R,
												config = {
													padding = 0.2,
													colour = G.C.BLACK,
													r = 0.05,
													minw = 6.65,
													align = "cm",
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
										config = { align = "cm" },
										nodes = {
											{
												n = G.UIT.R,
												config = {
													padding = 0.2,
													colour = G.C.BLACK,
													r = 0.05,
													minw = 6.65,
													align = "cm",
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
					},
					{
						n = G.UIT.C,
						config = { minw = 0.1 },
					},
					{
						n = G.UIT.C,
						nodes = {
							{
								n = G.UIT.O,
								config = {
									object = random_card_area,
								},
							},
						},
					},
				},
			},
		},
	}
end

SMODS.Language({
	key = "bu",
	label = "BalaUni",
})
SMODS.Language({
	key = "bu_gay",
	label = "BalaUni*",
})
