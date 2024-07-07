watchtiles = {}
watch2tiles = {}
watch3tiles = {}
findingwatchtiles = false
findingwatch2tiles = false
findingwatch3tiles = false

condlist["watched"] = function(params, checkedconds, checkedconds_, cdata)
    if findingwatchtiles then
        return false, checkedconds
    end

    findallwatch()

    for k, l in pairs(watchtiles) do
        if seenbycode(cdata, l) then
            return true, checkedconds
        end
    end
    return false, checkedconds
end

condlist["watched2"] = function(params, checkedconds, checkedconds_, cdata)
    if findingwatch2tiles then
        return false, checkedconds
    end

    findallwatch2()

    for k, l in pairs(watch2tiles) do
        if seenbycode(cdata, l) then
            return true, checkedconds
        end
    end
    return false, checkedconds
end

condlist["watched3"] = function(params, checkedconds, checkedconds_, cdata)
    if findingwatch3tiles then
        return false, checkedconds
    end

    findallwatch3()

    for k, l in pairs(watch3tiles) do
        if seenbycode(cdata, l) then
            return true, checkedconds
        end
    end
    return false, checkedconds
end

function findallwatch()
    if findingwatchtiles then
        return nil --NO EXTRA-LONG COMMENTS HERE
    end
    findingwatchtiles = true
    local positions = {}
    local ids = {}
    ids, emptys = findallfeature(nil, "is", "watch")
    if (ids == nil) then
        ids = {}
    end
    if (emptys == nil) then
        emptys = {}
    end
    if (#ids ~= 0) then
        for i, v in pairs(ids) do
            if (v == 1) then
                -- table.insert(positions,{"level"})
            elseif (v == 2) then

            else
                local unit = mmf.newObject(v)
                table.insert(positions, { unit.values[XPOS], unit.values[YPOS], unit.fixed, unit.values[DIR] })
            end
        end
    end
    if (#emptys ~= 0) then
        for i, v in pairs(emptys) do
            for i2, v2 in pairs(v) do
                table.insert(positions, { i2 % roomsizex, i2 // roomsizex, 2, fixedrandom(0, 3) })
            end
        end
    end
    watchtiles = positions
    findingwatchtiles = false
end

function findallwatch2()
    if findingwatchtiles then
        return nil --ditto
    end
    findingwatch2tiles = true
    local positions = {}
    local ids = {}
    ids, emptys = findallfeature(nil, "is", "watch2")
    if (ids == nil) then
        ids = {}
    end
    if (emptys == nil) then
        emptys = {}
    end
    if (#ids ~= 0) then
        for i, v in pairs(ids) do
            if (v == 1) then
                -- table.insert(positions,{"level"})
            elseif (v == 2) then

            else
                local unit = mmf.newObject(v)
                table.insert(positions, { unit.values[XPOS], unit.values[YPOS], unit.fixed, unit.values[DIR] })
            end
        end
    end
    if (#emptys ~= 0) then
        for i, v in pairs(emptys) do
            for i2, v2 in pairs(v) do
                table.insert(positions, { i2 % roomsizex, i2 // roomsizex, 2, fixedrandom(0, 3) })
            end
        end
    end
    watch2tiles = positions
    findingwatch2tiles = false
end

function findallwatch3()
    if findingwatchtiles then
        return nil
    end
    findingwatch3tiles = true
    local positions = {}
    local ids = {}
    ids, emptys = findallfeature(nil, "is", "watch3")
    if (ids == nil) then
        ids = {}
    end
    if (emptys == nil) then
        emptys = {}
    end
    if (#ids ~= 0) then
        for i, v in pairs(ids) do
            if (v == 1) then
                -- table.insert(positions,{"level"})
            elseif (v == 2) then

            else
                local unit = mmf.newObject(v)
                table.insert(positions, { unit.values[XPOS], unit.values[YPOS], unit.fixed, unit.values[DIR] })
            end
        end
    end
    if (#emptys ~= 0) then
        for i, v in pairs(emptys) do
            for i2, v2 in pairs(v) do
                table.insert(positions, { i2 % roomsizex, i2 // roomsizex, 2, fixedrandom(0, 3) })
            end
        end
    end
    watch3tiles = positions
    findingwatch3tiles = false
end

function seenbycode(watcheddata, watcherdata)
    local x = 0
    local y = 0
    local dir = {}
    if (watcherdata[3] ~= 2) then
        local unit = mmf.newObject(watcherdata[3])
        x = unit.values[XPOS]
        y = unit.values[YPOS]
        dir = ndirs[unit.values[DIR] + 1]
    else
        x = watcherdata[1]
        y = watcherdata[2]
        dir = ndirs[watcherdata[4] + 1]
    end
    if (dir[1] == 0) and (dir[2] == 0) then
        return false
    end
    local ox = dir[1]
    local oy = dir[2]
    local dest_x = watcheddata.x
    local dest_y = watcheddata.y
    local passed = false

    if ((oy == 0) and (y == dest_y)) or ((ox == 0) and (x == dest_x)) then

        if (dest_x > x) and (ox == 1) and (oy == 0) then
            while true do
                x = x + ox
                y = y + oy
                if (x == dest_x) then
                    passed = true
                    break
                end
                if ((x > roomsizex) or (x < 0)) then
                    return false
                end
            end
        elseif (dest_x < x) and (ox == -1) and (oy == 0) then
            while true do
                x = x + ox
                y = y + oy
                if (x == dest_x) then
                    passed = true
                    break
                end
                if ((x > roomsizex) or (x < 0)) then
                    return false
                end
            end
        elseif (dest_y > y) and (ox == 0) and (oy == 1) then
            while true do
                x = x + ox
                y = y + oy
                if (y == dest_y) then
                    passed = true
                    break
                end
                if ((y > roomsizey) or (y < 0)) then
                    return false
                end
            end
        elseif (dest_y < y) and (ox == 0) and (oy == -1) then
            while true do
                x = x + ox
                y = y + oy
                if (y == dest_y) then
                    passed = true
                    break
                end
                if ((y > roomsizey) or (y < 0)) then
                    return false
                end
            end
        else
            return false
        end
    else
        return false
    end

    return passed

end