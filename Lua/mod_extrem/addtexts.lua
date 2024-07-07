local extra_word_names =
{
    spinright = "spin (right,right)",
    spinleft = "spin (right,left)",
    spinup = "spin (right,up)",
    spindown = "spin (right,down)",
    despinright = "spin (left,right)",
    despinleft = "spin (left,left)",
    despinup = "spin (left,up)",
    despindown = "spin (left,down)",
    greaterthan = "greater than",
    lessthan = "less than",
}

for k,v in ipairs(extra_word_names) do
    word_names[k] = v
end

function addtext(name, type, col, acol, customobjs, arg, root)
    local inroot = root or false
    table.insert(editor_objlist_order, "text_" .. name)

    editor_objlist["text_" .. name] = {
        name = "text_" .. name,
        sprite_in_root = inroot,
        unittype = "text",
        tags = { "" },
        tiling = -1,
        type = type,
        argtype = arg or {},
        layer = 20,
        colour = col,
        colour_active = acol,
        customobjects = customobjs or {},
    }
end

function addwatchpair(name, col, acol)
    table.insert(editor_objlist_order, "text_watch" .. name)
    table.insert(editor_objlist_order, "text_watched" .. name)

    editor_objlist["text_watch" .. name] = {
        name = "text_watch" .. name,
        sprite_in_root = false,
        unittype = "text",
        tags = { "" },
        tiling = -1,
        type = 2,
        layer = 20,
        colour = col,
        colour_active = acol,
        pairedwith = "text_watched" .. name,
    }
    editor_objlist["text_watched" .. name] = {
        name = "text_watched" .. name,
        sprite_in_root = false,
        unittype = "text",
        tags = { "" },
        tiling = -1,
        type = 3,
        layer = 20,
        colour = col,
        colour_active = acol,
        pairedwith = "text_watch" .. name
    }
end

function addobj(objname, c, ac, tiling, c2, sprite)
    local objc = c2 or ac
    local sprite = sprite or objname

    table.insert(editor_objlist_order, objname)
    table.insert(editor_objlist_order, "text_" .. objname)

    editor_objlist[objname] = {
        name = objname,
        sprite_in_root = false,
        unittype = "object",
        tags = { "" },
        tiling = tiling,
        type = 0,
        layer = 15,
        colour = objc,
        sprite = sprite
    }
    editor_objlist["text_" .. objname] = {
        name = "text_" .. objname,
        sprite_in_root = false,
        unittype = "text",
        tags = { "" },
        tiling = -1,
        type = 0,
        layer = 20,
        colour = c,
        colour_active = ac,
        sprite = "text_" .. sprite
    }
end

addobj("buffer", { 0, 1 }, { 0, 3 }, 4)
addobj("bsod",{4,3},{3,3},-1)
addobj("fan", { 4, 0 }, { 4, 1 }, 4)
addobj("puzzle", { 4, 0 }, { 4, 2 }, -1)
addobj("pyramid", { 6, 1 }, { 3, 4 }, -1)
addobj("elec", { 6, 1 }, { 2, 4 }, 1)
addobj("candle", { 2, 2 }, { 2, 3 }, -1)
addobj("music", { 1, 2 }, { 1, 4 }, -1)
addobj("blabla", { 4, 0 }, { 4, 1 }, 0, { 0, 3 })
addobj("hi!", { 6, 1 }, { 6, 2 }, 0, { 6, 2 }, "hi")
addobj("bye?", { 1, 0 }, { 4, 0 }, 0, { 4, 0 }, "bye")

addtext("crash", 2, { 2, 1 }, { 2, 2 })
addtext("eternal", 2, { 1, 3 }, { 1, 4 })
addtext("secure", 2, { 1, 3 }, { 1, 4 })

local letters = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" }

addtext("draw", 1, { 0, 1 }, { 0, 3 }, letters, { 8 })
addtext("jot", 1, { 0, 1 }, { 0, 3 }, letters, { 8 })
addtext("type", 1, { 0, 1 }, { 0, 3 }, letters, { 8 })

addwatchpair("", { 2, 1 }, { 2, 2 })
addwatchpair("2", { 2, 2 }, { 2, 3 })
addwatchpair("3", { 6, 1 }, { 2, 4 })

addtext("hidden", 3, { 3, 2 }, { 3, 3 })
addtext("petted", 3, { 3, 1 }, { 4, 2 })
addtext("static", 3, { 2, 1 }, { 2, 2 })
addtext("sleepy", 3, { 1, 3 }, { 1, 4 })
addtext("shiny", 3, { 6, 1 }, { 2, 4 })
addtext("curious", 3, { 0, 1 }, { 0, 3 })

addtext("toxic", 2, { 5, 1 }, { 5, 4 })
addtext("alkali", 2, { 4, 1 }, { 4, 2 })

addtext("as", 7, { 0, 1 }, { 0, 3 }, {}, { 0 })

addtext("pastprop", 2, { 3, 3 }, { 4, 4 })
addtext("present", 2, { 5, 1 }, { 5, 4 })
addtext("future", 2, { 6, 1 }, { 2, 4 })

addtext("was", 1, { 0, 1 }, { 0, 3 }, {}, { 0, 2 })
addtext("had", 1, { 0, 1 }, { 0, 3 }, {}, { 0 })
addtext("made", 1, { 0, 1 }, { 0, 3 }, {}, { 0 })
addtext("wrote", 1, { 0, 1 }, { 0, 3 }, {}, { 0, 2 })
addtext("ate", 1, { 2, 1 }, { 2, 2 }, {}, { 0 })
addtext("feared", 1, { 2, 1 }, { 2, 2 }, {}, { 0 })
addtext("mimicked", 1, { 2, 1 }, { 2, 2 }, {}, { 0 })
addtext("followed", 1, { 5, 1 }, { 5, 3 }, {}, { 0 })
addtext("acted", 1, { 3, 3 }, { 4, 4 }, {}, { 0, 2 })
addtext("performed", 1, { 3, 0 }, { 3, 1 }, {}, { 0 })
addtext("drew", 1, { 0, 1 }, { 0, 3 }, letters, { 8 })
addtext("jotted", 1, { 0, 1 }, { 0, 3 }, letters, { 8 })
addtext("typed", 1, { 0, 1 }, { 0, 3 }, letters, { 8 })

addtext("will", 5, { 0, 1 }, { 0, 3 })
addtext("be", 5, { 0, 1 }, { 0, 3 })
addtext("have", 5, { 0, 1 }, { 0, 3 })

addtext("willbe", 1, { 0, 1 }, { 0, 3 }, {}, { 0, 2 })
addtext("willhave", 1, { 0, 1 }, { 0, 3 }, {}, { 0 })
addtext("willmake", 1, { 0, 1 }, { 0, 3 }, {}, { 0 })
addtext("willwrite", 1, { 0, 1 }, { 0, 3 }, {}, { 0, 2 })
addtext("willeat", 1, { 2, 1 }, { 2, 2 }, {}, { 0 })
addtext("willfear", 1, { 2, 1 }, { 2, 2 }, {}, { 0 })
addtext("willmimic", 1, { 2, 1 }, { 2, 2 }, {}, { 0 })
addtext("willfollow", 1, { 5, 1 }, { 5, 3 }, {}, { 0 })
addtext("willact", 1, { 3, 3 }, { 4, 4 }, {}, { 0, 2 })
addtext("willperform", 1, { 3, 0 }, { 3, 1 }, {}, { 0 })
addtext("willdraw", 1, { 0, 1 }, { 0, 3 }, letters, { 8 })
addtext("willjot", 1, { 0, 1 }, { 0, 3 }, letters, { 8 })
addtext("willtype", 1, { 0, 1 }, { 0, 3 }, letters, { 8 })

addtext("keep", 3, { 3, 0 }, { 3, 1 })

addtext("spindown", 2, { 4, 3 }, { 3, 2 })
addtext("spinright", 2, { 4, 3 }, { 3, 2 })
addtext("spinup", 2, { 4, 3 }, { 3, 2 })
addtext("spinleft", 2, { 4, 3 }, { 3, 2 })
addtext("despindown", 2, { 4, 3 }, { 3, 2 })
addtext("despinright", 2, { 4, 3 }, { 3, 2 })
addtext("despinup", 2, { 4, 3 }, { 3, 2 })
addtext("despinleft", 2, { 4, 3 }, { 3, 2 })

addtext("act", 1, { 3, 3 }, { 4, 4 }, {}, { 0, 2 })
addtext("perform", 1, { 3, 0 }, { 3, 1 }, {}, { 0 })

addtext("infect", 2, { 2, 1 }, { 2, 2 })
addtext("virus", 2, { 3, 3 }, { 4, 4 })

addtext("youplus", 2, { 4, 0 }, { 4, 1 })
addtext("puppet", 2, { 3, 0 }, { 3, 1 })

addtext("volt", 2, { 6, 1 }, { 2, 4 })

addtext("refers", 7, { 0, 1 }, { 0, 3 }, {}, { 0, 2 })

addtext("one", 3, { 2, 1 }, { 2, 2 })
addtext("two", 3, { 5, 1 }, { 5, 3 })
addtext("three", 3, { 3, 0 }, { 3, 1 })
addtext("four", 3, { 1, 3 }, { 1, 4 })
addtext("five", 3, { 6, 1 }, { 2, 4 })
addtext("equal", 7, { 0, 1 }, { 0, 3 }, {}, { 0 })
addtext("lessthan", 7, { 0, 1 }, { 0, 3 }, {}, { 0 })
addtext("greaterthan", 7, { 0, 1 }, { 0, 3 }, {}, { 0 })

formatobjlist()