--If true, MOONWALK and related properties (DRUNK, DRUNKER, SKIP) apply to PUSH, PULL, SHIFT and YEET in addition to basically everything else. Defaults to true.
very_drunk = true
--If true, two things at different float values can't stick together. Defaults to true.
float_breaks_sticky = true
--If true, two things with different names can stick together. Defaults to false.
very_sticky = false

print("Start of !init.lua")

function apply_patashu_settings(settings_dict)
	for setting_name, value in pairs(settings_dict) do
		if setting_name == "very_drunk" then
			very_drunk = value
		elseif setting_name == "float_breaks_sticky" then
			float_breaks_sticky = value
		elseif setting_name == "very_sticky" then
			very_sticky = value
		end
	end
end

table.insert(objlistdata.alltags, "patashu")

table.insert(editor_objlist_order, "text_slip")
editor_objlist["text_slip"] = {
	name = "text_slip",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_slide")
editor_objlist["text_slide"] = {
	name = "text_slide",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_hates")
editor_objlist["text_hates"] = {
	name = "text_hates",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {5, 0},
	colour_active = {5, 1},
}

table.insert(editor_objlist_order, "text_likes")
editor_objlist["text_likes"] = {
	name = "text_likes",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {5, 0},
	colour_active = {5, 1},
}

table.insert(editor_objlist_order, "text_sidekick")
editor_objlist["text_sidekick"] = {
	name = "text_sidekick",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {6, 0},
	colour_active = {6, 1},
}

table.insert(editor_objlist_order, "text_lazy")
editor_objlist["text_lazy"] = {
	name = "text_lazy",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {6, 1},
	colour_active = {6, 2},
}

table.insert(editor_objlist_order, "text_moonwalk")
editor_objlist["text_moonwalk"] = {
	name = "text_moonwalk",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_drunk")
editor_objlist["text_drunk"] = {
	name = "text_drunk",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_drunker")
editor_objlist["text_drunker"] = {
	name = "text_drunker",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_skip")
editor_objlist["text_skip"] = {
	name = "text_skip",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_tall")
editor_objlist["text_tall"] = {
	name = "text_tall",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {0, 0},
	colour_active = {0, 1},
}

table.insert(editor_objlist_order, "text_oneway")
editor_objlist["text_oneway"] = {
	name = "text_oneway",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_copy")
editor_objlist["text_copy"] = {
	name = "text_copy",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {2, 1},
	colour_active = {2, 2},
}

table.insert(editor_objlist_order, "text_reset")
editor_objlist["text_reset"] = {
	name = "text_reset",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {3, 0},
	colour_active = {3, 1},
	layer = 20,
}

table.insert(editor_objlist_order, "text_noundo")
editor_objlist["text_noundo"] = {
	name = "text_noundo",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {5, 2},
	colour_active = {5, 3},
}

table.insert(editor_objlist_order, "text_noreset")
editor_objlist["text_noreset"] = {
	name = "text_noreset",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {5, 2},
	colour_active = {5, 3},
}

table.insert(editor_objlist_order, "text_stops")
editor_objlist["text_stops"] = {
	name = "text_stops",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {5, 0},
	colour_active = {5, 1},
}

table.insert(editor_objlist_order, "text_pushes")
editor_objlist["text_pushes"] = {
	name = "text_pushes",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {6, 0},
	colour_active = {6, 1},
}

table.insert(editor_objlist_order, "text_pulls")
editor_objlist["text_pulls"] = {
	name = "text_pulls",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {6, 1},
	colour_active = {6, 2},
}

table.insert(editor_objlist_order, "text_sinks")
editor_objlist["text_sinks"] = {
	name = "text_sinks",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {1, 2},
	colour_active = {1, 3},
}

table.insert(editor_objlist_order, "text_defeats")
editor_objlist["text_defeats"] = {
	name = "text_defeats",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {2, 0},
	colour_active = {2, 1},
}

table.insert(editor_objlist_order, "text_opens")
editor_objlist["text_opens"] = {
	name = "text_opens",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {6, 1},
	colour_active = {2, 4},
}

table.insert(editor_objlist_order, "text_shifts")
editor_objlist["text_shifts"] = {
	name = "text_shifts",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {1, 2},
	colour_active = {1, 3},
}

--[[table.insert(editor_objlist_order, "text_teles")
editor_objlist["text_teles"] = {
	name = "text_teles",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {1, 2},
	colour_active = {1, 4},
}]]

table.insert(editor_objlist_order, "text_swaps")
editor_objlist["text_swaps"] = {
	name = "text_swaps",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {3, 0},
	colour_active = {3, 1},
}

table.insert(editor_objlist_order, "text_melts")
editor_objlist["text_melts"] = {
	name = "text_melts",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	operatortype = "verb",
	colour = {2, 2},
	colour_active = {2, 3},
}

table.insert(editor_objlist_order, "text_topple")
editor_objlist["text_topple"] = {
	name = "text_topple",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {3, 0},
	colour_active = {3, 1},
}

table.insert(editor_objlist_order, "text_zoom")
editor_objlist["text_zoom"] = {
	name = "text_zoom",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {0, 2},
	colour_active = {0, 3},
}

table.insert(editor_objlist_order, "text_yeet")
editor_objlist["text_yeet"] = {
	name = "text_yeet",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	layer = 20,
	colour = {0, 2},
	colour_active = {0, 3},
}

table.insert(editor_objlist_order, "text_launch")
editor_objlist["text_launch"] = {
	name = "text_launch",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 2},
	colour_active = {1, 3},
}

table.insert(editor_objlist_order, "text_sticky")
editor_objlist["text_sticky"] = {
	name = "text_sticky",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_quality", "patashu"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {6, 1},
	colour_active = {2, 4},
}

table.insert(editor_objlist_order, "text_print")
editor_objlist["text_print"] = {
	name = "text_print",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	argtype = {0, 2},
	layer = 20,
	colour = {0, 2},
	colour_active = {0, 3},
}

table.insert(editor_objlist_order, "text_scrawl")
editor_objlist["text_scrawl"] = {
	name = "text_scrawl",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "text_verb", "patashu"},
	tiling = -1,
	type = 1,
	argtype = {0, 2},
	layer = 20,
	colour = {0, 2},
	colour_active = {0, 3},
}

formatobjlist()

print("End of !init.lua")