table.insert(editor_objlist_order, "text_trash")


editor_objlist["text_trash"] =
{
	name = "text_trash",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","text_verb","text_special"},
	tiling = -1,
	type = 1,
  argtype = {2},
	layer = 20,
	colour = {2, 1},
	colour_active = {2, 2},
}



table.insert(editor_objlist_order, "text_waste")


editor_objlist["text_waste"] =
{
	name = "text_waste",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","text_verb","text_special"},
	tiling = -1,
	type = 1,
  argtype = {2},
	layer = 20,
	colour = {6, 1},
	colour_active = {2, 4},
}

table.insert(editor_objlist_order, "text_build")


editor_objlist["text_build"] =
{
	name = "text_build",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","text_verb","text_special"},
	tiling = -1,
	type = 1,
  argtype = {2},
	layer = 20,
	colour = {5, 2},
	colour_active = {5, 3},
}

table.insert(editor_objlist_order, "text_sensing")


editor_objlist["text_sensing"] =
{
	name = "text_sensing",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","text_verb","text_special"},
	tiling = -1,
	type = 7,
  argtype = {2},
	layer = 20,
	colour = {0, 1},
	colour_active = {0, 3},
}

formatobjlist()
