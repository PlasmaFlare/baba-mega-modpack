condlist["hidden"] = function(params, checkedconds, checkedconds_, cdata)

    local params = { "hide" }
    local allfound = 0
    local alreadyfound = {}
    local name, unitid, x, y, limit = cdata.name, cdata.unitid, cdata.x, cdata.y, cdata.limit
    if (#params > 0) then
        for a, b in ipairs(params) do
            local pname = b
            local pnot = false
            if (string.sub(b, 1, 4) == "not ") then
                pnot = true
                pname = string.sub(b, 5)
            end

            local bcode = b .. "_" .. tostring(a)

            if (featureindex[name] ~= nil) then
                for c, d in ipairs(featureindex[name]) do
                    local drule = d[1]
                    local dconds = d[2]

                    if (checkedconds[tostring(dconds)] == nil) then
                        if (pnot == false) then
                            if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] == b) then
                                checkedconds[tostring(dconds)] = 1

                                if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                    alreadyfound[bcode] = 1
                                    allfound = allfound + 1
                                    break
                                end
                            end
                        else
                            if (string.sub(drule[3], 1, 4) ~= "not ") then
                                local obj = unitreference["text_" .. drule[3]]

                                if (obj ~= nil) then
                                    local objtype = getactualdata_objlist(obj, "type")

                                    if (objtype == 2) then
                                        if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] ~= pname) then
                                            checkedconds[tostring(dconds)] = 1

                                            if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                                alreadyfound[bcode] = 1
                                                allfound = allfound + 1
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        return false, checkedconds, true
    end

    --MF_alert(tostring(cdata.debugname) .. ", " .. tostring(allfound) .. ", " .. tostring(#params))

    return (allfound == #params), checkedconds, true
end

condlist["petted"] = function(params, checkedconds, checkedconds_, cdata)

    local params = { "pet" }
    local allfound = 0
    local alreadyfound = {}
    local name, unitid, x, y, limit = cdata.name, cdata.unitid, cdata.x, cdata.y, cdata.limit
    if (#params > 0) then
        for a, b in ipairs(params) do
            local pname = b
            local pnot = false
            if (string.sub(b, 1, 4) == "not ") then
                pnot = true
                pname = string.sub(b, 5)
            end

            local bcode = b .. "_" .. tostring(a)

            if (featureindex[name] ~= nil) then
                for c, d in ipairs(featureindex[name]) do
                    local drule = d[1]
                    local dconds = d[2]

                    if (checkedconds[tostring(dconds)] == nil) then
                        if (pnot == false) then
                            if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] == b) then
                                checkedconds[tostring(dconds)] = 1

                                if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                    alreadyfound[bcode] = 1
                                    allfound = allfound + 1
                                    break
                                end
                            end
                        else
                            if (string.sub(drule[3], 1, 4) ~= "not ") then
                                local obj = unitreference["text_" .. drule[3]]

                                if (obj ~= nil) then
                                    local objtype = getactualdata_objlist(obj, "type")

                                    if (objtype == 2) then
                                        if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] ~= pname) then
                                            checkedconds[tostring(dconds)] = 1

                                            if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                                alreadyfound[bcode] = 1
                                                allfound = allfound + 1
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        return false, checkedconds, true
    end

    --MF_alert(tostring(cdata.debugname) .. ", " .. tostring(allfound) .. ", " .. tostring(#params))

    return (allfound == #params), checkedconds, true
end

condlist["static"] = function(params, checkedconds, checkedconds_, cdata)

    local params = { "still" }
    local allfound = 0
    local alreadyfound = {}
    local name, unitid, x, y, limit = cdata.name, cdata.unitid, cdata.x, cdata.y, cdata.limit
    if (#params > 0) then
        for a, b in ipairs(params) do
            local pname = b
            local pnot = false
            if (string.sub(b, 1, 4) == "not ") then
                pnot = true
                pname = string.sub(b, 5)
            end

            local bcode = b .. "_" .. tostring(a)

            if (featureindex[name] ~= nil) then
                for c, d in ipairs(featureindex[name]) do
                    local drule = d[1]
                    local dconds = d[2]

                    if (checkedconds[tostring(dconds)] == nil) then
                        if (pnot == false) then
                            if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] == b) then
                                checkedconds[tostring(dconds)] = 1

                                if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                    alreadyfound[bcode] = 1
                                    allfound = allfound + 1
                                    break
                                end
                            end
                        else
                            if (string.sub(drule[3], 1, 4) ~= "not ") then
                                local obj = unitreference["text_" .. drule[3]]

                                if (obj ~= nil) then
                                    local objtype = getactualdata_objlist(obj, "type")

                                    if (objtype == 2) then
                                        if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] ~= pname) then
                                            checkedconds[tostring(dconds)] = 1

                                            if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                                alreadyfound[bcode] = 1
                                                allfound = allfound + 1
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        return false, checkedconds, true
    end

    --MF_alert(tostring(cdata.debugname) .. ", " .. tostring(allfound) .. ", " .. tostring(#params))

    return (allfound == #params), checkedconds, true
end

condlist["sleepy"] = function(params, checkedconds, checkedconds_, cdata)

    local params = { "sleep" }
    local allfound = 0
    local alreadyfound = {}
    local name, unitid, x, y, limit = cdata.name, cdata.unitid, cdata.x, cdata.y, cdata.limit
    if (#params > 0) then
        for a, b in ipairs(params) do
            local pname = b
            local pnot = false
            if (string.sub(b, 1, 4) == "not ") then
                pnot = true
                pname = string.sub(b, 5)
            end

            local bcode = b .. "_" .. tostring(a)

            if (featureindex[name] ~= nil) then
                for c, d in ipairs(featureindex[name]) do
                    local drule = d[1]
                    local dconds = d[2]

                    if (checkedconds[tostring(dconds)] == nil) then
                        if (pnot == false) then
                            if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] == b) then
                                checkedconds[tostring(dconds)] = 1

                                if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                    alreadyfound[bcode] = 1
                                    allfound = allfound + 1
                                    break
                                end
                            end
                        else
                            if (string.sub(drule[3], 1, 4) ~= "not ") then
                                local obj = unitreference["text_" .. drule[3]]

                                if (obj ~= nil) then
                                    local objtype = getactualdata_objlist(obj, "type")

                                    if (objtype == 2) then
                                        if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] ~= pname) then
                                            checkedconds[tostring(dconds)] = 1

                                            if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                                alreadyfound[bcode] = 1
                                                allfound = allfound + 1
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        return false, checkedconds, true
    end

    --MF_alert(tostring(cdata.debugname) .. ", " .. tostring(allfound) .. ", " .. tostring(#params))

    return (allfound == #params), checkedconds, true
end
condlist["shiny"] = function(params, checkedconds, checkedconds_, cdata)

    local params = { "best" }
    local allfound = 0
    local alreadyfound = {}
    local name, unitid, x, y, limit = cdata.name, cdata.unitid, cdata.x, cdata.y, cdata.limit
    if (#params > 0) then
        for a, b in ipairs(params) do
            local pname = b
            local pnot = false
            if (string.sub(b, 1, 4) == "not ") then
                pnot = true
                pname = string.sub(b, 5)
            end

            local bcode = b .. "_" .. tostring(a)

            if (featureindex[name] ~= nil) then
                for c, d in ipairs(featureindex[name]) do
                    local drule = d[1]
                    local dconds = d[2]

                    if (checkedconds[tostring(dconds)] == nil) then
                        if (pnot == false) then
                            if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] == b) then
                                checkedconds[tostring(dconds)] = 1

                                if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                    alreadyfound[bcode] = 1
                                    allfound = allfound + 1
                                    break
                                end
                            end
                        else
                            if (string.sub(drule[3], 1, 4) ~= "not ") then
                                local obj = unitreference["text_" .. drule[3]]

                                if (obj ~= nil) then
                                    local objtype = getactualdata_objlist(obj, "type")

                                    if (objtype == 2) then
                                        if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] ~= pname) then
                                            checkedconds[tostring(dconds)] = 1

                                            if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                                alreadyfound[bcode] = 1
                                                allfound = allfound + 1
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        return false, checkedconds, true
    end

    --MF_alert(tostring(cdata.debugname) .. ", " .. tostring(allfound) .. ", " .. tostring(#params))

    return (allfound == #params), checkedconds, true
end

condlist["curious"] = function(params, checkedconds, checkedconds_, cdata)

    local params = { "wonder" }
    local allfound = 0
    local alreadyfound = {}
    local name, unitid, x, y, limit = cdata.name, cdata.unitid, cdata.x, cdata.y, cdata.limit
    if (#params > 0) then
        for a, b in ipairs(params) do
            local pname = b
            local pnot = false
            if (string.sub(b, 1, 4) == "not ") then
                pnot = true
                pname = string.sub(b, 5)
            end

            local bcode = b .. "_" .. tostring(a)

            if (featureindex[name] ~= nil) then
                for c, d in ipairs(featureindex[name]) do
                    local drule = d[1]
                    local dconds = d[2]

                    if (checkedconds[tostring(dconds)] == nil) then
                        if (pnot == false) then
                            if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] == b) then
                                checkedconds[tostring(dconds)] = 1

                                if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                    alreadyfound[bcode] = 1
                                    allfound = allfound + 1
                                    break
                                end
                            end
                        else
                            if (string.sub(drule[3], 1, 4) ~= "not ") then
                                local obj = unitreference["text_" .. drule[3]]

                                if (obj ~= nil) then
                                    local objtype = getactualdata_objlist(obj, "type")

                                    if (objtype == 2) then
                                        if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] ~= pname) then
                                            checkedconds[tostring(dconds)] = 1

                                            if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                                alreadyfound[bcode] = 1
                                                allfound = allfound + 1
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        return false, checkedconds, true
    end

    --MF_alert(tostring(cdata.debugname) .. ", " .. tostring(allfound) .. ", " .. tostring(#params))

    return (allfound == #params), checkedconds, true
end

condlist["golden"] = function(params, checkedconds, checkedconds_, cdata)

    local params = { "gold" }
    local allfound = 0
    local alreadyfound = {}
    local name, unitid, x, y, limit = cdata.name, cdata.unitid, cdata.x, cdata.y, cdata.limit
    if (#params > 0) then
        for a, b in ipairs(params) do
            local pname = b
            local pnot = false
            if (string.sub(b, 1, 4) == "not ") then
                pnot = true
                pname = string.sub(b, 5)
            end

            local bcode = b .. "_" .. tostring(a)

            if (featureindex[name] ~= nil) then
                for c, d in ipairs(featureindex[name]) do
                    local drule = d[1]
                    local dconds = d[2]

                    if (checkedconds[tostring(dconds)] == nil) then
                        if (pnot == false) then
                            if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] == b) then
                                checkedconds[tostring(dconds)] = 1

                                if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                    alreadyfound[bcode] = 1
                                    allfound = allfound + 1
                                    break
                                end
                            end
                        else
                            if (string.sub(drule[3], 1, 4) ~= "not ") then
                                local obj = unitreference["text_" .. drule[3]]

                                if (obj ~= nil) then
                                    local objtype = getactualdata_objlist(obj, "type")

                                    if (objtype == 2) then
                                        if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] ~= pname) then
                                            checkedconds[tostring(dconds)] = 1

                                            if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                                alreadyfound[bcode] = 1
                                                allfound = allfound + 1
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        return false, checkedconds, true
    end

    --MF_alert(tostring(cdata.debugname) .. ", " .. tostring(allfound) .. ", " .. tostring(#params))

    return (allfound == #params), checkedconds, true
end

condlist["feelspast"] = function(params, checkedconds, checkedconds_, cdata)

    local params = { "pastprop" } --@mods (past x extrem)
    local allfound = 0
    local alreadyfound = {}
    local name, unitid, x, y, limit = cdata.name, cdata.unitid, cdata.x, cdata.y, cdata.limit
    if (#params > 0) then
        for a, b in ipairs(params) do
            local pname = b
            local pnot = false
            if (string.sub(b, 1, 4) == "not ") then
                pnot = true
                pname = string.sub(b, 5)
            end

            local bcode = b .. "_" .. tostring(a)

            if (featureindex[name] ~= nil) then
                for c, d in ipairs(featureindex[name]) do
                    local drule = d[1]
                    local dconds = d[2]

                    if (checkedconds[tostring(dconds)] == nil) then
                        if (pnot == false) then
                            if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] == b) then
                                checkedconds[tostring(dconds)] = 1

                                if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                    alreadyfound[bcode] = 1
                                    allfound = allfound + 1
                                    break
                                end
                            end
                        else
                            if (string.sub(drule[3], 1, 4) ~= "not ") then
                                local obj = unitreference["text_" .. drule[3]]

                                if (obj ~= nil) then
                                    local objtype = getactualdata_objlist(obj, "type")

                                    if (objtype == 2) then
                                        if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] ~= pname) then
                                            checkedconds[tostring(dconds)] = 1

                                            if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                                alreadyfound[bcode] = 1
                                                allfound = allfound + 1
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        return false, checkedconds, true
    end

    --MF_alert(tostring(cdata.debugname) .. ", " .. tostring(allfound) .. ", " .. tostring(#params))

    return (allfound == #params), checkedconds, true
end

condlist["feelsfuture"] = function(params, checkedconds, checkedconds_, cdata)

    local params = { "future" }
    local allfound = 0
    local alreadyfound = {}
    local name, unitid, x, y, limit = cdata.name, cdata.unitid, cdata.x, cdata.y, cdata.limit
    if (#params > 0) then
        for a, b in ipairs(params) do
            local pname = b
            local pnot = false
            if (string.sub(b, 1, 4) == "not ") then
                pnot = true
                pname = string.sub(b, 5)
            end

            local bcode = b .. "_" .. tostring(a)

            if (featureindex[name] ~= nil) then
                for c, d in ipairs(featureindex[name]) do
                    local drule = d[1]
                    local dconds = d[2]

                    if (checkedconds[tostring(dconds)] == nil) then
                        if (pnot == false) then
                            if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] == b) then
                                checkedconds[tostring(dconds)] = 1

                                if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                    alreadyfound[bcode] = 1
                                    allfound = allfound + 1
                                    break
                                end
                            end
                        else
                            if (string.sub(drule[3], 1, 4) ~= "not ") then
                                local obj = unitreference["text_" .. drule[3]]

                                if (obj ~= nil) then
                                    local objtype = getactualdata_objlist(obj, "type")

                                    if (objtype == 2) then
                                        if (drule[1] == name) and ((drule[2] == "is") or (drule[2] == "feel")) and (drule[3] ~= pname) then
                                            checkedconds[tostring(dconds)] = 1

                                            if (alreadyfound[bcode] == nil) and testcond(dconds, unitid, x, y, nil, limit, checkedconds) then
                                                alreadyfound[bcode] = 1
                                                allfound = allfound + 1
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        return false, checkedconds, true
    end

    --MF_alert(tostring(cdata.debugname) .. ", " .. tostring(allfound) .. ", " .. tostring(#params))

    return (allfound == #params), checkedconds, true
end