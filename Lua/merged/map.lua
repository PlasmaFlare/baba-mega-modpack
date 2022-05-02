

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