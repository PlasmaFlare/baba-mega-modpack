local str = debug.getinfo(1).source:sub(2)
local dir = str:match("(.*/)")

local load_order = {
    "blocks.lua",
	"clears.lua",
	"conditions.lua",
	"convert.lua",
	"features.lua",
	"glossary.lua",
	"glyph.lua",
	"load.lua",
	"map.lua",
	"mapcursor.lua",
	"metadata.lua",
	"rules.lua",
	"syntax.lua",
	"tools.lua",
	"undo.lua"
}

for _, file in ipairs(load_order) do
    print("[Mega Modpack] Loading "..file)
    dofile(dir..file)
end