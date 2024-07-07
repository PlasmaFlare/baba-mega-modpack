local layers = 3
local meta_objs = {}
for num = 1, layers do
    table.insert(objlistdata.alltags, "metatext (" .. num .. ")")
    for i, v in pairs(editor_objlist_order) do
        if string.sub(v, 1, 5) == "text_" then
            local data = editor_objlist_reference[v]
            if data ~= nil then
                v = editor_objlist[data]
                local thissprite = nil
                if v.sprite == nil then v.sprite = v.name end
                if v.sprite ~= nil then
                    thissprite = v.sprite
                    if MF_findsprite(string.rep("text_", num) .. v.sprite .. "_0_1.png", false) then
                        thissprite = string.rep("text_", num) .. v.sprite
                    end
                end
                local new = {
                    name = string.rep("text_", num) .. v.name,
                    sprite = thissprite,
                    sprite_in_root = false,
                    unittype = "text",
                    tags = { "text", "abstract", "metatext (" .. num .. ")" },
                    tiling = v.tiling,
                    type = 0,
                    layer = v.layer,
                    colour = v.colour,
                    colour_active = v.colour_active,
                }
                table.insert(meta_objs, new)
            end
        end
    end
end

for i, v in ipairs(meta_objs) do
    table.insert(editor_objlist_order, v.name)
    editor_objlist[v.name] = v
end

formatobjlist()
