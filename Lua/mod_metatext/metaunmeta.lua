-- This is an optional file that adds two new objects. It is not needed for the mod to work.

-- Adds object to editor.
table.insert(editor_objlist_order,"text_meta")
table.insert(editor_objlist_order,"text_unmeta")
table.insert(editor_objlist_order,"text_meta-1")
table.insert(editor_objlist_order,"text_meta0")
table.insert(editor_objlist_order,"text_meta1")
table.insert(editor_objlist_order,"text_meta2")
table.insert(editor_objlist_order,"text_meta3")
editor_objlist["text_meta"] = {
  name = "text_meta",
  sprite_in_root = false,
  unittype = "text",
  tags = {"text_quality","text_special", "metatext"},
  tiling = -1,
  type = 2,
  layer = 20,
  colour = {4, 0},
  colour_active = {4, 1},
}
editor_objlist["text_unmeta"] = {
  name = "text_unmeta",
  sprite_in_root = false,
  unittype = "text",
  tags = {"text_quality","text_special", "metatext"},
  tiling = -1,
  type = 2,
  layer = 20,
  colour = {3, 0},
  colour_active = {3, 1},
}
editor_objlist["text_meta-1"] = {
  name = "text_meta-1",
  sprite_in_root = false,
  unittype = "text",
  tags = {"text_special","abstract", "metatext"},
  tiling = -1,
  type = 0,
  layer = 20,
  colour = {4, 1},
  colour_active = {4, 2},
}
editor_objlist["text_meta0"] = {
  name = "text_meta0",
  sprite_in_root = false,
  unittype = "text",
  tags = {"text_special","abstract", "metatext"},
  tiling = -1,
  type = 0,
  layer = 20,
  colour = {3, 0},
  colour_active = {3, 1},
}
editor_objlist["text_meta1"] = {
  name = "text_meta1",
  sprite_in_root = false,
  unittype = "text",
  tags = {"text_special","abstract", "metatext"},
  tiling = -1,
  type = 0,
  layer = 20,
  colour = {3, 0},
  colour_active = {3, 1},
}
editor_objlist["text_meta2"] = {
  name = "text_meta2",
  sprite_in_root = false,
  unittype = "text",
  tags = {"text_special","abstract", "metatext"},
  tiling = -1,
  type = 0,
  layer = 20,
  colour = {3, 0},
  colour_active = {3, 1},
}
editor_objlist["text_meta3"] = {
  name = "text_meta3",
  sprite_in_root = false,
  unittype = "text",
  tags = {"text_special","abstract", "metatext"},
  tiling = -1,
  type = 0,
  layer = 20,
  colour = {3, 0},
  colour_active = {3, 1},
}
formatobjlist()

-- Disables if X IS X, like REVERT.

--[[ @Merge: postrules() was merged ]]


-- Implementation.

--[[ @Merge: conversion() was merged ]]

