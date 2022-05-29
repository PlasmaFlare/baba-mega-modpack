local str = debug.getinfo(1).source:sub(2)
local dir = str:match("(.*/)")

local load_order = {
    "!add_words.lua",
	"!settings.lua",
	"!utils.lua",
	"blocks.lua",
	"conditions.lua",
	"convert.lua",
	"map.lua",
	"movement.lua",
	"syntax.lua",
	"tools.lua",
	"undo.lua"
}

for _, file in ipairs(load_order) do
    print("[Mega Modpack] Loading "..file)
    dofile(dir..file)
end