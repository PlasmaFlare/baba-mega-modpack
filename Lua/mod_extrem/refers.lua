condlist['refers'] = function(params, checkedconds, checkedconds_, cdata)
    for i, j in pairs(params) do
        local pname = j
        local is_param_this, raycast_units, _, this_count = parse_this_param_and_get_raycast_units(pname)
        local _params = pname
        local unitname = mmf.newObject(cdata.unitid).strings[UNITNAME]
        if not is_param_this then
            if (string.sub(unitname, 1, 5) == "text_") then
                if (string.sub(unitname, 6) == _params) then
                    return true, checkedconds
                end
            elseif (string.sub(unitname, 1, 6) == "glyph_") then
                if (string.sub(unitname, 7) == _params) then
                    return true, checkedconds
                end
            end
        else
            for ray_unitid, _ in pairs(raycast_units) do
                local ray_unit = mmf.newObject(ray_unitid)
                local ray_name = ray_unit.strings[UNITNAME]
                if (string.sub(ray_name, 1, 5) == "text_") then
                    if (string.sub(ray_name, 6) == _params) then
                        return true, checkedconds
                    end
                elseif (string.sub(ray_name, 1, 6) == "glyph_") then
                    if (string.sub(ray_name, 7) == _params) then
                        return true, checkedconds
                    end
                end
            end
        end

        if hasfeature(unitname, "is", "word", cdata.unitid) and (unitname == _params) then
            return true, checkedconds
        end
    end
    return false, checkedconds
end