local str = debug.getinfo(1).source:sub(2)
local dir = str:match("(.*/)")

local load_order = {
    "!settings.lua",
	"blocks.lua",
	"conditions.lua",
	"defines + misc.lua",
	"glossary.lua",
	"metaunmeta.lua",
	"rules.lua",
	"syntax.lua",
	"text_ prefix.lua",
	"tools.lua",
}

for _, file in ipairs(load_order) do
    print("[Mega Modpack] Loading "..file)
    dofile(dir..file)
end