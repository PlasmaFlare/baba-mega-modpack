local str = debug.getinfo(1).source:sub(2)
local dir = str:match("(.*/)")

local load_order = {
    "blocks.lua",
	"clears.lua",
	"conditions.lua",
	"convert.lua",
	"editor_objectlist_func.lua",
	"effects.lua",
	"features.lua",
	"map.lua",
	"mapcursor.lua",
	"movement.lua",
	"rules.lua",
	"syntax.lua",
	"tools.lua",
	"undo.lua"
}

for _, file in ipairs(load_order) do
    print("[Mega Modpack] Loading "..file)
    dofile(dir..file)
end