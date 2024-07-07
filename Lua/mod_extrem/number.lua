condlist["one"] = function(params, checkedconds, checkedconds_, cdata)
    local pass = true
    local unitname = mmf.newObject(cdata.unitid).strings[UNITNAME]

    pass = testcond({ { "without", { unitname } } }, cdata.unitid)

    return pass, checkedconds, true
end

condlist["two"] = function(params, checkedconds, checkedconds_, cdata)
    local pass = false
    local unitname = mmf.newObject(cdata.unitid).strings[UNITNAME]

    if #unitlists[unitname] == 2 then
        pass = true
    end

    return pass, checkedconds, true
end

condlist["three"] = function(params, checkedconds, checkedconds_, cdata)
    local pass = false
    local unitname = mmf.newObject(cdata.unitid).strings[UNITNAME]

    if #unitlists[unitname] == 3 then
        pass = true
    end

    return pass, checkedconds, true
end

condlist["four"] = function(params, checkedconds, checkedconds_, cdata)
    local pass = false
    local unitname = mmf.newObject(cdata.unitid).strings[UNITNAME]

    if #unitlists[unitname] == 4 then
        pass = true
    end

    return pass, checkedconds, true
end

condlist["five"] = function(params, checkedconds, checkedconds_, cdata)
    local pass = false
    local unitname = mmf.newObject(cdata.unitid).strings[UNITNAME]

    if #unitlists[unitname] == 5 then
        pass = true
    end

    return pass, checkedconds, true
end

condlist["equal"] = function(params, checkedconds, checkedconds_, cdata)
    local pass = true
    local unitname = mmf.newObject(cdata.unitid).strings[UNITNAME]

    for a, b in ipairs(params) do
        if #unitlists[unitname] ~= count_object(b) then
            pass = false
            break
        end
    end

    return pass, checkedconds, true
end

condlist["greaterthan"] = function(params, checkedconds, checkedconds_, cdata)
    local pass = true
    local unitname = mmf.newObject(cdata.unitid).strings[UNITNAME]

    for a, b in ipairs(params) do
        if #unitlists[unitname] < count_object(b) then
            pass = false
            break
        end
    end

    return pass, checkedconds, true
end

condlist["lessthan"] = function(params, checkedconds, checkedconds_, cdata)
    local pass = true
    local unitname = mmf.newObject(cdata.unitid).strings[UNITNAME]

    for a, b in ipairs(params) do
        if #unitlists[unitname] > count_object(b) then
            pass = false
            break
        end
    end

    return pass, checkedconds, true
end

--TODO: metatext support
function count_object(name)
    local result = 0
    for k,v in pairs(units) do
        if (getname(v, name) == name) then
            result = result + 1
        end
    end
    return result
end