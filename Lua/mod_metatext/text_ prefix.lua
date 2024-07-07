-- This is an optional file that adds a new object. It is not needed for the mod to work.

-- Adds object to editor.
table.insert(editor_objlist_order,"text_text_")
editor_objlist["text_text_"] = {
  name = "text_text_",
  sprite_in_root = false,
  sprite = "text_textpre",
  unittype = "text",
  tags = {"text_special","abstract", "metatext"},
  tiling = -1,
  type = 4,
  layer = 20,
  colour = {4, 0},
  colour_active = {4, 1},
}
formatobjlist()

-- Parsing + functionality.

--[[ @Merge: docode() was merged ]]

--[[ Hempuli implemented a wonderful new system that makes rule parsing more efficient...
but that means every rule needs to have a noun. Modifies this to detect the prefix and claim there's a noun.]]--

--[[ @Merge: calculatesentences() was merged ]]

