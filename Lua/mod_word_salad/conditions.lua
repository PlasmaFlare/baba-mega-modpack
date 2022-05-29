-- SINFUL: true if the object previously destroyed something
condlist.sinful = function(params,_,_,cdata)
	local unitid = cdata.unitid
	if unitid == 2 then -- EMPTY doesn't store karma
		return false
	elseif unitid == 1 then -- LEVEL: check level karma
		return (levelKarma == true)
	end
	local unit = mmf.newObject(unitid)
	if unit.karma then
		return true
	end
	return false
end