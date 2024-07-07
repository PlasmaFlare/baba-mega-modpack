function statusblock(ids, undoing_, noturn_)
    local checkthese = {}
    local undoing = undoing_ or false
    local noturn = noturn_ or false

    --MF_alert("Statusblock called")

    generaldata5.values[AUTO_ON] = 0

    if (featureindex["level"] ~= nil) then
        local auto_on = hasfeature_count("level", "is", "auto", 1)

        if (auto_on ~= nil) then
            generaldata5.values[AUTO_ON] = auto_on
        end
    end

    if (ids == nil) then
        checkthese = units
    else
        for i, v in ipairs(ids) do
            local vunit = mmf.newObject(v)
            table.insert(checkthese, vunit)
        end
    end

    if (undoing == false) then
        brokenblock(checkthese)
    end

    for i, unit in pairs(checkthese) do
        -- METATEXT
        local name = getname(unit)

        if (undoing == false) then
            local ur = hasfeature_count(name, "is", "right", unit.fixed)
            local uu = hasfeature_count(name, "is", "up", unit.fixed)
            local ul = hasfeature_count(name, "is", "left", unit.fixed)
            local ud = hasfeature_count(name, "is", "down", unit.fixed)

            local turn = {}
            local deturn = {}

            if (featureindex["turn"] ~= nil) or (featureindex["spinright"] ~= nil) or (featureindex["spinup"] ~= nil) or (featureindex["spinleft"] ~= nil) or (featureindex["spindown"] ~= nil) then
                if (featureindex["turn"] ~= nil) then
                    for a, b in ipairs(featureindex["turn"]) do
                        local rule = b[1]
                        local conds = b[2]

                        if (rule[1] == name) and (rule[2] == "is") and (rule[3] == "turn") then
                            table.insert(turn, { rule[2], conds })
                        end
                    end
                end

                if (featureindex["spinright"] ~= nil) then
                    for c, d in ipairs(featureindex["spinright"]) do
                        local rule = d[1]
                        local conds = d[2]

                        if (unit.values[DIR] ~= 0) then
                            if (rule[1] == name) and (rule[2] == "is") and (rule[3] == "spinright") then
                                table.insert(turn, { rule[2], conds })
                            end
                        end
                    end
                end
                if (featureindex["spinup"] ~= nil) then
                    for c, d in ipairs(featureindex["spinup"]) do
                        local rule = d[1]
                        local conds = d[2]

                        if (unit.values[DIR] ~= 1) then
                            if (rule[1] == name) and (rule[2] == "is") and (rule[3] == "spinup") then
                                table.insert(turn, { rule[2], conds })
                            end
                        end
                    end
                end
                if (featureindex["spinleft"] ~= nil) then
                    for c, d in ipairs(featureindex["spinleft"]) do
                        local rule = d[1]
                        local conds = d[2]

                        if (unit.values[DIR] ~= 2) then
                            if (rule[1] == name) and (rule[2] == "is") and (rule[3] == "spinleft") then
                                table.insert(turn, { rule[2], conds })
                            end
                        end
                    end
                end
                if (featureindex["spindown"] ~= nil) then
                    for c, d in ipairs(featureindex["spindown"]) do
                        local rule = d[1]
                        local conds = d[2]

                        if (unit.values[DIR] ~= 3) then
                            if (rule[1] == name) and (rule[2] == "is") and (rule[3] == "spindown") then
                                table.insert(turn, { rule[2], conds })
                            end
                        end
                    end
                end
            end

            if (featureindex["deturn"] ~= nil) or (featureindex["despinright"] ~= nil) or (featureindex["despinup"] ~= nil) or (featureindex["despinleft"] ~= nil) or (featureindex["despindown"] ~= nil) then
                if (featureindex["deturn"] ~= nil) then
                    for a, b in ipairs(featureindex["deturn"]) do
                        local rule = b[1]
                        local conds = b[2]

                        if (rule[1] == name) and (rule[2] == "is") and (rule[3] == "deturn") then
                            table.insert(deturn, { rule[2], conds })
                        end
                    end
                end

                if (featureindex["despinright"] ~= nil) then
                    for c, d in ipairs(featureindex["despinright"]) do
                        local rule = d[1]
                        local conds = d[2]

                        if (unit.values[DIR] ~= 0) then
                            if (rule[1] == name) and (rule[2] == "is") and (rule[3] == "despinright") then
                                table.insert(deturn, { rule[2], conds })
                            end
                        end
                    end
                end
                if (featureindex["despinup"] ~= nil) then
                    for c, d in ipairs(featureindex["despinup"]) do
                        local rule = d[1]
                        local conds = d[2]

                        if (unit.values[DIR] ~= 1) then
                            if (rule[1] == name) and (rule[2] == "is") and (rule[3] == "despinup") then
                                table.insert(deturn, { rule[2], conds })
                            end
                        end
                    end
                end
                if (featureindex["despinleft"] ~= nil) then
                    for c, d in ipairs(featureindex["despinleft"]) do
                        local rule = d[1]
                        local conds = d[2]

                        if (unit.values[DIR] ~= 2) then
                            if (rule[1] == name) and (rule[2] == "is") and (rule[3] == "despinleft") then
                                table.insert(deturn, { rule[2], conds })
                            end
                        end
                    end
                end
                if (featureindex["despindown"] ~= nil) then
                    for c, d in ipairs(featureindex["despindown"]) do
                        local rule = d[1]
                        local conds = d[2]

                        if (unit.values[DIR] ~= 3) then
                            if (rule[1] == name) and (rule[2] == "is") and (rule[3] == "despindown") then
                                table.insert(deturn, { rule[2], conds })
                            end
                        end
                    end
                end
            end

            if (issleep(unit.fixed) == false) then
                local currdir = unit.values[DIR]
                local fdir = currdir

                if (noturn == false) and ((ur > 0) or (uu > 0) or (ul > 0) or (ud > 0)) then
                    if (ur > uu) and (ur > ul) and (ur > ud) then
                        fdir = 0
                    elseif (uu > ur) and (uu > ul) and (uu > ud) then
                        fdir = 1
                    elseif (ul > ur) and (ul > uu) and (ul > ud) then
                        fdir = 2
                    elseif (ud > ur) and (ud > ul) and (ud > uu) then
                        fdir = 3
                    elseif (currdir == 3) then
                        if (ul > 0) and (ul >= uu) and (ul >= ur) then
                            fdir = 2
                        elseif (uu > 0) and (uu > ul) and (uu >= ur) then
                            fdir = 1
                        elseif (ur > 0) and (ur > ul) and (ur > uu) then
                            fdir = 0
                        end
                    elseif (currdir == 2) then
                        if (uu > 0) and (uu >= ur) and (uu >= ul) then
                            fdir = 1
                        elseif (ur > 0) and (ur > uu) and (ur >= ud) then
                            fdir = 0
                        elseif (ud > 0) and (ud > ur) and (ud > uu) then
                            fdir = 3
                        end
                    elseif (currdir == 1) then
                        if (ur > 0) and (ur >= ul) and (ur >= ud) then
                            fdir = 0
                        elseif (ud > 0) and (ud > ur) and (ud >= ul) then
                            fdir = 3
                        elseif (ul > 0) and (ul > ur) and (ul > ud) then
                            fdir = 2
                        end
                    elseif (currdir == 0) then
                        if (ud > 0) and (ud >= ul) and (ud >= uu) then
                            fdir = 3
                        elseif (ul > 0) and (ul > ud) and (ul >= uu) then
                            fdir = 2
                        elseif (uu > 0) and (uu > ud) and (uu > ul) then
                            fdir = 1
                        end
                    end

                    --MF_alert(tostring(currdir) .. ", " .. tostring(fdir))

                    if (fdir ~= currdir) then
                        updatedir(unit.fixed, fdir)
                        currdir = fdir
                    end
                end

                if ((turn ~= nil) or (deturn ~= nil)) and (undoing == false) and (noturn == false) then
                    local x, y = unit.values[XPOS], unit.values[YPOS]
                    local turns = 0
                    local deturns = 0

                    if (turn ~= nil) then
                        for a, b in ipairs(turn) do
                            if testcond(b[2], unit.fixed, x, y) then
                                turns = turns + 1
                            end
                        end
                    end

                    if (deturn ~= nil) then
                        for a, b in ipairs(deturn) do
                            if testcond(b[2], unit.fixed, x, y) then
                                deturns = deturns + 1
                            end
                        end
                    end

                    if (turns >= deturns) then
                        turns = turns - deturns
                        deturns = 0
                    end

                    if (deturns >= turns) then
                        deturns = deturns - turns
                        turns = 0
                    end

                    if (turns > 0) then
                        for d = 1, turns do
                            currdir = ((currdir + 4) - 1) % 4
                        end

                        updatedir(unit.fixed, currdir)
                    end

                    if (deturns > 0) then
                        for d = 1, deturns do
                            currdir = ((currdir + 4) + 1) % 4
                        end

                        updatedir(unit.fixed, currdir)
                    end
                end
            end

            if (generaldata.values[MODE] == 0) then
                if (featureindex["back"] ~= nil) then
                    local isback = hasfeature(name, "is", "back", unit.fixed)

                    if (isback == nil) and (unit.back_init ~= 0) then
                        addundo({ "backset", name, unit.values[ID], unit.back_init })
                        unit.back_init = 0
                    end

                    if (isback ~= nil) and (unit.back_init == 0) then
                        addundo({ "backset", name, unit.values[ID], 0 })
                        unit.back_init = #undobuffer + 1
                    end
                elseif (unit.back_init ~= 0) then
                    addundo({ "backset", name, unit.values[ID], unit.back_init })
                    unit.back_init = 0
                end
            end
        end

        local oldfloat = unit.values[FLOAT]
        local newfloat = 0
        if (unit.values[FLOAT] < 2) and (generaldata.values[MODE] == 0) then
            unit.values[FLOAT] = 0
        end

        local isfloat = hasfeature(name, "is", "float", unit.fixed)

        if (isfloat ~= nil) and (generaldata.values[MODE] == 0) then
            unit.values[FLOAT] = 1
            newfloat = 1
        end

        if (undoing == false) then
            if (oldfloat ~= newfloat) and (generaldata.values[MODE] == 0) and (generaldata2.values[ENDINGGOING] == 0) then
                addaction(unit.fixed, { "dofloat", oldfloat, newfloat, unit.values[ID], unit.fixed, name })
            end
        end
    end
end
