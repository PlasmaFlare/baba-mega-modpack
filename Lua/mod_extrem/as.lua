condlist["as"] = function(params, checkedconds, checkedconds_, cdata) --TODO: metatext merge

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

            local bcode = b .. "#$%^" .. tostring(a)

            if (featureindex[name] ~= nil) then
                for c, d in ipairs(featureindex[name]) do
                    local drule = d[1]
                    local dconds = d[2]

                    if (checkedconds[tostring(dconds)] == nil) then
                        if (pnot == false) then
                            if (drule[1] == name) and (((drule[2] == "is") or (drule[2] == "become") and (drule[3] == b
                                    or ((drule[3] == "text" or drule[3] == "glyph") and b == drule[3] .. "_" .. name)))
                                    or (drule[2] == "is" and drule[3] == "meta" and b == "text_" .. name)
                                    or (drule[2] == "is" and drule[3] == "unmeta" and string.sub(name,1,5) == "text_" and b == string.sub(name,6))
                                    or ((b == "text" or b == "text_" .. drule[3]) and (drule[2] == "write" or drule[2] == "draw"))
                                    or ((b == "glyph" or b == "glyph_" .. drule[3]) and (drule[2] == "inscribe"))) then
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
                                        if (drule[1] == name) and (((drule[2] == "is") or (drule[2] == "become")) and (drule[3] ~= pname)) or ((pname == "text") and (drule[2] == "write")) then
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
