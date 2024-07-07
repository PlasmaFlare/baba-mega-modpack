-- Returns a string with colour from a string without colour.
function colourstring(text_, display_, custom)
    local text = text_ or ""
    local display = display_ or text
    local result = ""
    if string.sub(text, 1, 4) == "not " and custom == nil then
        local n1, n2 = getpalcolour("text_not", "active")
        if n1 ~= 0 or n2 ~= 3 then
            result = "$" .. n1 .. "," .. n2 .. "not "
        else
            result = "not "
        end
        text = string.sub(text, 5)
        display = string.sub(display, 5)
    end
    local c1, c2 = getpalcolour("text_" .. text, "active", true)
    while string.sub(text, 1, 5) == "text_" and custom == nil and c1 == nil do
        local n1, n2 = getpalcolour("text_text_", "active")
        if n1 ~= 0 or n2 ~= 3 or result ~= nil then
            result = result .. "$" .. n1 .. "," .. n2 .. "text_"
        else
            result = "text_"
        end
        text = string.sub(text, 6)
        display = string.sub(display, 6)
        c1, c2 = getpalcolour("text_" .. text, "active", true)
    end
    if c1 == nil then
        c1, c2 = 0, 3
    end
    local insert = custom or display
    -- metatext display
    if true then
        local textcount = 0
        insert, textcount = string.gsub(insert, "text_", "")
        if insert == "" then
            insert = "text_"
            textcount = textcount - 1
        end
        if textcount > 0 then
            insert = insert .. "(" .. textcount .. ")"
        end
    end
    if (c1 ~= 0 or c2 ~= 3) then
        result = result .. "$" .. c1 .. "," .. c2 .. insert .. "$0,3"
    elseif result ~= "" then
        result = result .. "$0,3" .. insert
    else
        result = insert
    end
    return result
end

-- Returns the colour of the name entered from the object palette.
function getpalcolour(object, value_, checkexist)
    local name = ""
    if unitreference[object] ~= nil then
        name = unitreference[object]
    elseif objectpalette[object] ~= nil then
        name = objectpalette[object]
    end
    if #name > 0 then
        local unitinfo = tileslist[name]

        local defaultcolour = colours.default

        local value = value_ or "colour"

        if (objectcolours[name] ~= nil) then
            local c = objectcolours[name]

            if (c[value] ~= nil) then
                local cc = c[value]
                return cc[1], cc[2]
            elseif (value == "colour") or (unitinfo == nil) or (unitinfo[value] == nil) then
                if (c.colour ~= nil) then
                    local cc = c.colour
                    return cc[1], cc[2]
                end
            end
        end

        if (unitinfo == nil) then
            return defaultcolour[1], defaultcolour[2]
        else
            if (unitinfo[value] == nil) then
                if (unitinfo.colour == nil) then
                    return defaultcolour[1], defaultcolour[2]
                else
                    local colour = unitinfo.colour
                    return colour[1], colour[2]
                end
            else
                local colour = unitinfo[value]
                return colour[1], colour[2]
            end
        end

        return defaultcolour[1], defaultcolour[2]
    end
    if checkexist then
        return nil
    end
    return 0, 3
end


-- Haha, I lied. This file has more than just the hints.
spookmode = false


-- Adds the NOT property
table.insert(editor_objlist_order, "text_delete")
word_names["delete"] = "$2,2Not"
editor_objlist["text_delete"] = {
    name = "text_delete",
    unittype = "text",
    sprite_in_root = false,
    sprite = "text_not_prop",
    tags = { "text", "text_quality" },
    tiling = -1,
    type = 2,
    layer = 20,
    colour = { 2, 1 },
    colour_active = { 2, 2 },
}

formatobjlist()

-- implementation
function dodelete()
    local restart = false

    if featureindex["delete"] ~= nil then
        local alreadydone = {}
        for a, rule in ipairs(featureindex["delete"]) do
            local target = rule[1][1]
            local conds = rule[2]

            if rule[1][2] == "is" then

                local newdeadstatus = conds_to_string(conds)

                local dead = get_dead_status(target)
                local minusdead, found = string.gsub(dead, newdeadstatus, "")

                if target ~= "$2,2NOT FOUND$0,3" and string.sub(target, 1, 4) ~= "not " and (conds[1] == nil or conds[1][1] ~= "never") and alreadydone[target] == nil and dead ~= "yes" then
                    alreadydone[target] = 1
                    if newdeadstatus ~= "yes" then
                        MF_store("world", "deadunits", target, minusdead .. newdeadstatus)
                    else
                        MF_store("world", "deadunits", target, 1)
                    end
                    restart = true
                end

            end
        end
    end
    if featureindex["not delete"] ~= nil then
        local alreadydone = {}
        for a, rule in ipairs(featureindex["not delete"]) do
            local target = rule[1][1]
            local conds = rule[2]

            if rule[1][2] == "is" then

                local noninvertstatus = conds_to_string(conds)
                local newdeadstatus = conds_to_string(conds, true)

                local dead = get_dead_status(target)
                local minusdead, found = string.gsub(dead, noninvertstatus, "")
                if minusdead == "yes" or newdeadstatus == "" then
                    minusdead = ""
                end

                if target ~= "$2,2NOT FOUND$0,3" and string.sub(target, 1, 4) ~= "not " and (conds[1] == nil or conds[1][1] ~= "never") and alreadydone[target] == nil and dead ~= "" then
                    if target == "all" then
                        for _, v in pairs(allobjectslist) do
                            alreadydone[v] = 1
                            MF_store("world", "deadunits", v, minusdead .. newdeadstatus)
                        end
                    end
                    alreadydone[target] = 1
                    MF_store("world", "deadunits", target, minusdead .. newdeadstatus)

                    restart = true

                end

            end
        end
    end

    if restart then
        MF_restart(true)
    end
end
table.insert(mod_hook_functions["turn_end"], dodelete)

function table.copy(object)
    local function _copy(object)
        local new_table = {}
        for k, v in pairs(object) do
            new_table[k] = v
        end

        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end


-- also implementation
function rekill()
    allobjectslist = table.copy(objectlist)
    local delthese = {}
    local killed = false
    local doerror = false
    for i, unit in ipairs(units) do
        local name = getname(unit)

        local dead = get_dead_status(name)
        local referdead = get_dead_status(unit.strings[NAME])

        local dokill = false
        local dotextglitch = false

        if dead == "yes" then
            dokill = true
        elseif dead ~= "" then
            local conds = string_to_conds(dead)
            if conds ~= nil then
                dokill = testcond(conds, unit.fixed) -- FIX THIS
            else
                dokill = true
            end
        elseif referdead == "yes" then
            dotextglitch = true
        end

        if dokill then
            if MF_keydown("v") and editor.values[INEDITOR] == 1 then
                MF_store("world", "deadunits", name, 0)
            else
                if dead == "yes" then
                    objectlist[name] = nil
                end
                table.insert(delthese, unit.fixed)
                killed = true
                local firsttime = MF_read("world", "deadunits", "firsttime")
            end
        elseif dotextglitch then
            if MF_keydown("v") and editor.values[INEDITOR] == 1 then
                MF_store("world", "deadunits", unit.strings[NAME], 0)
            else
                objectlist[unit.strings[NAME]] = nil
                MF_changesprite(unit.fixed, "text_glitch", false)
                killed = true
            end
        end
    end
    if MF_keydown("v") and editor.values[INEDITOR] == 1 then
        MF_store("world", "deadunits", "firsttime", 0)
    end

    handledels(delthese, false)
    undobuffer = {}
    updatecode = 1
    code(true)
    if killed then
        spookmode = true
    else
        spookmode = false
    end
end
table.insert(mod_hook_functions["level_start"], rekill)

table.insert(mod_hook_functions["always"], function()
    if spookmode and generaldata2.strings[MUSIC] ~= "erased" then
        generaldata2.strings[MUSIC] = "erased"
        generaldata2.strings[OLDMUSIC] = "erased"
        MF_playmusic("erased",1,1,1)
    end
end)
-- modify rules that contain dead units
local old_addoption = addoption
function addoption(option,conds_,ids,visible,notrule,tags_,visualonly_)
    local target = option[1]
    local effect = option[3]
    local notpref = false
    local notpref2 = false
    if effect == "delete" or effect == "not delete" then
        return old_addoption(option,conds_,ids,visible,notrule,tags_,visualonly_)
    elseif string.sub(target, 1, 4) == "not " then
        target = string.sub(target, 5)
        notpref = true
    end
    if string.sub(effect, 1, 4) == "not " then
        effect = string.sub(effect, 5)
        notpref2 = true
    end

    local dead = get_dead_status(target)
    local dead2 = get_dead_status(effect)

    for a, cond in ipairs(conds_) do
        for b, param in ipairs(cond[2]) do
            if string.sub(param, 1, 4) == "not " then
                param = string.sub(param, 5)
            end

            local paramdead = get_dead_status(param)

            if paramdead == "yes" then
                conds_[a][2][b] = "$2,2NOT FOUND$0,3"
            end
        end
    end
    if dead == "yes" then
        option[1] = "$2,2NOT FOUND$0,3"
        visualonly_ = true
        if notpref then
            option[1] = "not "..option[1]
        end
    end
    if dead2 == "yes" then
        option[3] = "$2,2NOT FOUND$0,3"
        visualonly_ = true
        if notpref2 then
            option[3] = "not "..option[3]
        end
    end
    return old_addoption(option,conds_,ids,visible,notrule,tags_,visualonly_)
end

function get_dead_status(object)
    local dead = MF_read("world", "deadunits", object)
    if tonumber(dead) == 1 then
        return "yes"
    elseif tonumber(dead) == 0 or dead == "" then
        return ""
    end
    return dead
end


-- convert conditions into a string for storage
function conds_to_string(conds_, invert)
    local conds = conds_ or {}
    if invert then
        conds = invertconds(conds_)
    end
    local string = ""
    for a, cond in ipairs(conds) do
        if cond[1] == "never" then
            return ""
        end
        string = cond[1] .. "\t"
        for b, param in ipairs(cond[2]) do
            string = string .. param .. "\t"
        end
        string = string .. "\n"
    end
    if string == "" then
        return "yes"
    end
    return string
end

-- convert string into conditions
function string_to_conds(string)
    local conds = {}
    if string == "" then
        return nil
    end
    local currcond = ""
    local currparam = ""
    local params = {}
    local doingparam = false
    for i = 1, string.len(string) do
        local letter = string.sub(string, i, i)
        if doingparam then
            if letter == "\t" then
                table.insert(params, currparam)
                currparam = ""
            elseif letter == "\n" then
                if currcond ~= "" then
                    table.insert(conds, { currcond, params })
                end
                currcond = ""
                currparam = ""
                params = {}
            else
                currparam = currparam .. letter
            end
        else
            if letter == "\t" then
                doingparam = true
            else
                currcond = currcond .. letter
            end
        end
    end
    if currparam ~= "" then
        table.insert(params, currparam)
        currparam = ""
    end
    if currcond ~= "" then
        table.insert(conds, { currcond, params })
        currcond = ""
    end
    return conds
end

if keys.IS_WORD_GLOSSARY_PRESENT then
    keys.WORD_GLOSSARY_FUNCS.register_author("Emily", nil, "$1,4Emily")
    keys.WORD_GLOSSARY_FUNCS.add_entries_to_word_glossary({
        -- A more customized word entry for directional you. This has a custom thumbnail, a custom title (display_name), and 4 display sprites for showing the 4 different directions of directional you when viewing the word entry in-game.
        {
            name = "delete",
            thumbnail_obj = "text_delete",
            display_name = "NOT property",
            author = "Emily",
            description = [[When X is delete, the level immediately restarts (ignoring NORESET),
             EVERY instance of X is removed, and every rule containing X is considered invalid.
             When X is not delete, if X is removed via DELETE, the level immediately restarts (ignoring NORESET),
             EVERY instance of X is added back, and every rule containing X is no longer considered invalid.]],
        },
    })
end
