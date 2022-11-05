

function displaysigntext(x,y,ignore)
	if (ignore ~= nil) and ignore then
		return false
	end
	
	for i=-1,1 do
		for j=-1,1 do
			if (i == 0) or (j == 0) then
				local tileid = (x + i) + (y + j) * roomsizex
				
				if (unitmap[tileid] ~= nil) then
					local stuff = findfeatureat(nil,"is","you",x + i,y + j)
					
					if (stuff ~= nil) then
						return true
					elseif (featureindex["3d"] ~= nil) then
						stuff = findfeatureat(nil,"is","3d",x + i,y + j)
						
						if (stuff ~= nil) then
							return true
						end
					elseif (featureindex["you2"] ~= nil) then
						stuff = findfeatureat(nil,"is","you2",x + i,y + j)
						
						if (stuff ~= nil) then
							return true
						end
					elseif (featureindex["alive"] ~= nil) then
						stuff = findfeatureat(nil,"is","alive",x + i,y + j)
						
						if (stuff ~= nil) then
							return true
						end
					end
				end
			end
		end
	end
	
	return false
end

function uplevel()
	local id = #leveltree
	local parentid = #leveltree - 1
	
	local oldlevel = generaldata.strings[CURRLEVEL]
	generaldata2.strings[PREVIOUSLEVEL] = oldlevel
	MF_store("save",generaldata.strings[WORLD],"Previous",oldlevel)
	latestleveldetails = {lnum = -1, ltype = -1}
	
	if (id == 0) then
		MF_alert("Already at map root")
		
		if (generaldata.strings[WORLD] ~= generaldata.strings[BASEWORLD]) and (editor.values[INEDITOR] == 0) then
			MF_end_single()
			MF_credits(1)
		end
	end
	
	if (parentid > 1) then
		generaldata.strings[PARENT] = leveltree[parentid - 1]
	else
		generaldata.strings[PARENT] = ""
	end
	
	if (id > 1) then
		generaldata.strings[CURRLEVEL] = leveltree[parentid]
	else
		generaldata.strings[CURRLEVEL] = ""
	end
	
	table.remove(leveltree, id)
	table.remove(leveltree_id, id)
	
	--this is the only line i added to this function for visit
	visit_fullsurrounds = ""

	return oldlevel
end