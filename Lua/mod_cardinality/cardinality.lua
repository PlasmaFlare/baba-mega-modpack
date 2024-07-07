
condlist["north"] = function(params,checkedconds,checkedconds_,cdata)
	local allfound = 0
	local alreadyfound = {}
	local unitid,x,y,surrounds = cdata.unitid,cdata.x,cdata.y,cdata.surrounds
	
	if (#params > 0) then
		for a,b in ipairs(params) do
			local pname = b
			local pnot = false
			if (string.sub(b, 1, 4) == "not ") then
				pnot = true
				pname = string.sub(b, 5)
			end
			
			local bcode = b .. "_" .. tostring(a)
			
			if (string.sub(pname, 1, 5) == "group") then
				return false,checkedconds
			end
			
			
			local dist = roomsizey - y - 2
			
			if (unitid ~= 1) then
				if (b ~= "level") or ((b == "level") and (alreadyfound[1] ~= nil)) then
					if (dist >= 1) then
						for g=0,roomsizex do
							for h=1,dist do
								if (pname ~= "empty") then
									local tileid =  g + (y + h) * roomsizex
									if (unitmap[tileid] ~= nil) then
										for c,d in ipairs(unitmap[tileid]) do
											if (d ~= unitid) and (alreadyfound[d] == nil) then
												local unit = mmf.newObject(d)
												local name_ = getname(unit,pname,pnot)
												
												if (pnot == false) then
													if (name_ == pname) and (alreadyfound[bcode] == nil) then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												else
													if (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												end
											end
										end
									end
								else
									local nearempty = false
							
									local tileid = g + (y + h) * roomsizex
									local l = map[0]
									local tile = l:get_x(g,y + h)
									
									local tcode = tostring(tileid) .. "e"
									
									if ((unitmap[tileid] == nil) or (#unitmap[tileid] == 0)) and (tile == 255) and (alreadyfound[tcode] == nil) then 
										nearempty = true
									end
									
									if (pnot == false) then
										if nearempty and (alreadyfound[bcode] == nil) then
											alreadyfound[bcode] = 1
											alreadyfound[tcode] = 1
											allfound = allfound + 1
										end
									else
										if (nearempty == false) and (alreadyfound[bcode] == nil) then
											alreadyfound[bcode] = 1
											alreadyfound[tcode] = 1
											allfound = allfound + 1
										end
									end
								end
							end
						end
					end
				elseif (b == "level") and (alreadyfound[bcode] == nil) and (alreadyfound[1] == nil) then
					alreadyfound[bcode] = 1
					alreadyfound[1] = 1
					allfound = allfound + 1
				end
			else
				local ulist = false
			
				if (b ~= "empty") and (b ~= "level") then
					if (pnot == false) then
						if (unitlists[pname] ~= nil) and (#unitlists[pname] > 0) and (alreadyfound[bcode] == nil) then
							for c,d in ipairs(unitlists[pname]) do
								if (alreadyfound[d] == nil) then
									alreadyfound[bcode] = 1
									alreadyfound[d] = 1
									ulist = true
									break
								end
							end
						end
					else
						for c,d in pairs(unitlists) do
							local tested = false
							
							if (c ~= pname) and (#d > 0) and (alreadyfound[bcode] == nil) then
								for e,f in ipairs(d) do
									if (alreadyfound[f] == nil) then
										alreadyfound[bcode] = 1
										alreadyfound[f] = 1
										ulist = true
										tested = true
										break
									end
								end
							end
							
							if tested then
								break
							end
						end
					end
				elseif (b == "empty") then
					local empties = findempty()
					
					if (#empties > 0) and (alreadyfound[bcode] == nil) then
						for c,d in ipairs(unitlists[pname]) do
							if (alreadyfound[d] == nil) then
								alreadyfound[bcode] = 1
								alreadyfound[d] = 1
								ulist = true
								break
							end
						end
					end
				end
				
				if (b ~= "text") and (ulist == false) then
					if (surrounds.d ~= nil) then
						for c,d in ipairs(surrounds.d) do
							if (pnot == false) then
								if (ulist == false) and (d == pname) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									ulist = true
								end
							else
								if (ulist == false) and (d ~= pname) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									ulist = true
								end
							end
						end
					end
				end
				
				if ulist or (b == "text") then
					alreadyfound[bcode] = 1
					allfound = allfound + 1
				end
			end
		end
	else
		print("no parameters given!")
		return false,checkedconds
	end

	return (allfound == #params),checkedconds
end

condlist["south"] = function(params,checkedconds,checkedconds_,cdata)
	local allfound = 0
	local alreadyfound = {}
	local unitid,x,y,surrounds = cdata.unitid,cdata.x,cdata.y,cdata.surrounds
	
	if (#params > 0) then
		for a,b in ipairs(params) do
			local pname = b
			local pnot = false
			if (string.sub(b, 1, 4) == "not ") then
				pnot = true
				pname = string.sub(b, 5)
			end
			
			local bcode = b .. "_" .. tostring(a)
			
			if (string.sub(pname, 1, 5) == "group") then
				return false,checkedconds
			end
			
			local dist = (y - 1)
			
			if (unitid ~= 1) then
				if (b ~= "level") or ((b == "level") and (alreadyfound[1] ~= nil)) then
					if (y > 1) then
						for g = 0, roomsizex do
							for h = 1,dist do
								if (pname ~= "empty") then
									local tileid = g + (y - h) * roomsizex
									if (unitmap[tileid] ~= nil) then
										for c,d in ipairs(unitmap[tileid]) do
											if (d ~= unitid) and (alreadyfound[d] == nil) then
												local unit = mmf.newObject(d)
												local name_ = getname(unit,pname,pnot)
												
												if (pnot == false) then
													if (name_ == pname) and (alreadyfound[bcode] == nil) then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												else
													if (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												end
											end
										end
									end
								else
									local nearempty = false
							
									local tileid = g + (y - h) * roomsizex
									local l = map[0]
									local tile = l:get_x(g,y - h)
									
									local tcode = tostring(tileid) .. "e"
									
									if ((unitmap[tileid] == nil) or (#unitmap[tileid] == 0)) and (tile == 255) and (alreadyfound[tcode] == nil) then 
										nearempty = true
									end
									
									if (pnot == false) then
										if nearempty and (alreadyfound[bcode] == nil) then
											alreadyfound[bcode] = 1
											alreadyfound[tcode] = 1
											allfound = allfound + 1
										end
									else
										if (nearempty == false) and (alreadyfound[bcode] == nil) then
											alreadyfound[bcode] = 1
											alreadyfound[tcode] = 1
											allfound = allfound + 1
										end
									end
								end
							end
						end
					end
				elseif (b == "level") and (alreadyfound[bcode] == nil) and (alreadyfound[1] == nil) then
					alreadyfound[bcode] = 1
					alreadyfound[1] = 1
					allfound = allfound + 1
				end
			else
				local ulist = false
			
				if (b ~= "empty") and (b ~= "level") then
					if (pnot == false) then
						if (unitlists[pname] ~= nil) and (#unitlists[pname] > 0) and (alreadyfound[bcode] == nil) then
							for c,d in ipairs(unitlists[pname]) do
								if (alreadyfound[d] == nil) then
									alreadyfound[bcode] = 1
									alreadyfound[d] = 1
									ulist = true
									break
								end
							end
						end
					else
						for c,d in pairs(unitlists) do
							local tested = false
							
							if (c ~= pname) and (#d > 0) and (alreadyfound[bcode] == nil) then
								for e,f in ipairs(d) do
									if (alreadyfound[f] == nil) then
										alreadyfound[bcode] = 1
										alreadyfound[f] = 1
										ulist = true
										tested = true
										break
									end
								end
							end
							
							if tested then
								break
							end
						end
					end
				elseif (b == "empty") then
					local empties = findempty()
					
					if (#empties > 0) then
						for c,d in ipairs(empties) do
							if (alreadyfound[d] == nil) and (alreadyfound[bcode] == nil) then
								alreadyfound[bcode] = 1
								alreadyfound[d] = 1
								ulist = true
								break
							end
						end
					end
				end
				
				if (b ~= "text") and (ulist == false) then
					if (surrounds.u ~= nil) then
						for c,d in ipairs(surrounds.u) do
							if (pnot == false) then
								if (ulist == false) and (d == pname) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									ulist = true
								end
							else
								if (ulist == false) and (d ~= pname) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									ulist = true
								end
							end
						end
					end
				end
				
				if ulist or (b == "text") then
					alreadyfound[bcode] = 1
					allfound = allfound + 1
				end
			end
		end
	else
		print("no parameters given!")
		return false,checkedconds
	end

	return (allfound == #params),checkedconds
end

condlist["east"] = function(params,checkedconds,checkedconds_,cdata)
	local allfound = 0
	local alreadyfound = {}
	local unitid,x,y,surrounds = cdata.unitid,cdata.x,cdata.y,cdata.surrounds
	
	if (#params > 0) then
		for a,b in ipairs(params) do
			local pname = b
			local pnot = false
			if (string.sub(b, 1, 4) == "not ") then
				pnot = true
				pname = string.sub(b, 5)
			end
			
			local bcode = b .. "_" .. tostring(a)
			
			if (string.sub(pname, 1, 5) == "group") then
				return false,checkedconds
			end
			
			local dist = (x - 1)
			
			if (unitid ~= 1) then
				if (b ~= "level") or ((b == "level") and (alreadyfound[1] ~= nil)) then
					if (x > 1) then
						for g=1,dist do
							for h = 0, roomsizey do
								if (pname ~= "empty") then
									local tileid = (x - g) + h * roomsizex
									if (unitmap[tileid] ~= nil) then
										for c,d in ipairs(unitmap[tileid]) do
											if (d ~= unitid) and (alreadyfound[d] == nil) then
												local unit = mmf.newObject(d)
												local name_ = getname(unit,pname,pnot)
												
												if (pnot == false) then
													if (name_ == pname) and (alreadyfound[bcode] == nil) then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												else
													if (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												end
											end
										end
									end
								else
									local nearempty = false
							
									local tileid = (x - g) + h * roomsizex
									local l = map[0]
									local tile = l:get_x(x - g,h)
									
									local tcode = tostring(tileid) .. "e"
									
									if ((unitmap[tileid] == nil) or (#unitmap[tileid] == 0)) and (tile == 255) and (alreadyfound[tcode] == nil) then 
										nearempty = true
									end
									
									if (pnot == false) then
										if nearempty and (alreadyfound[bcode] == nil) then
											alreadyfound[bcode] = 1
											alreadyfound[tcode] = 1
											allfound = allfound + 1
										end
									else
										if (nearempty == false) and (alreadyfound[bcode] == nil) then
											alreadyfound[bcode] = 1
											alreadyfound[tcode] = 1
											allfound = allfound + 1
										end
									end
								end
							end
						end
					end
				elseif (b == "level") and (alreadyfound[bcode] == nil) and (alreadyfound[1] == nil) then
					alreadyfound[bcode] = 1
					alreadyfound[1] = 1
					allfound = allfound + 1
				end
			else
				local ulist = false
			
				if (b ~= "empty") and (b ~= "level") then
					if (pnot == false) then
						if (unitlists[pname] ~= nil) and (#unitlists[pname] > 0) and (alreadyfound[bcode] == nil) then
							for c,d in ipairs(unitlists[pname]) do
								if (alreadyfound[d] == nil) then
									alreadyfound[bcode] = 1
									alreadyfound[d] = 1
									ulist = true
									break
								end
							end
						end
					else
						for c,d in pairs(unitlists) do
							local tested = false
							
							if (c ~= pname) and (#d > 0) and (alreadyfound[bcode] == nil) then
								for e,f in ipairs(d) do
									if (alreadyfound[f] == nil) then
										alreadyfound[bcode] = 1
										alreadyfound[f] = 1
										ulist = true
										tested = true
										break
									end
								end
							end
							
							if tested then
								break
							end
						end
					end
				elseif (b == "empty") then
					local empties = findempty()
					
					if (#empties > 0) then
						for c,d in ipairs(empties) do
							if (alreadyfound[d] == nil) and (alreadyfound[bcode] == nil) then
								alreadyfound[bcode] = 1
								alreadyfound[d] = 1
								ulist = true
								break
							end
						end
					end
				end
				
				if (b ~= "text") and (ulist == false) then
					if (surrounds.l ~= nil) then
						for c,d in ipairs(surrounds.l) do
							if (pnot == false) then
								if (ulist == false) and (d == pname) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									ulist = true
								end
							else
								if (ulist == false) and (d ~= pname) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									ulist = true
								end
							end
						end
					end
				end
				
				if ulist or (b == "text") then
					alreadyfound[bcode] = 1
					allfound = allfound + 1
				end
			end
		end
	else
		print("no parameters given!")
		return false,checkedconds
	end

	return (allfound == #params),checkedconds
end

condlist["west"] = function(params,checkedconds,checkedconds_,cdata)
	local allfound = 0
	local alreadyfound = {}
	local unitid,x,y,surrounds = cdata.unitid,cdata.x,cdata.y,cdata.surrounds
	
	if (#params > 0) then
		for a,b in ipairs(params) do
			local pname = b
			local pnot = false
			if (string.sub(b, 1, 4) == "not ") then
				pnot = true
				pname = string.sub(b, 5)
			end
			
			local bcode = b .. "_" .. tostring(a)
			
			if (string.sub(pname, 1, 5) == "group") then
				return false,checkedconds
			end
			
			local dist = roomsizex - x - 2
			
			if (unitid ~= 1) then
				if (b ~= "level") or ((b == "level") and (alreadyfound[1] ~= nil)) then
					if (dist >= 1) then
						for g=1,dist do
							for h = 0,roomsizey do
								if (pname ~= "empty") then
									local tileid = (x + g) + h * roomsizex
									if (unitmap[tileid] ~= nil) then
										for c,d in ipairs(unitmap[tileid]) do
											if (d ~= unitid) and (alreadyfound[d] == nil) then
												local unit = mmf.newObject(d)
												local name_ = getname(unit,pname,pnot)
												
												if (pnot == false) then
													if (name_ == pname) and (alreadyfound[bcode] == nil) then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												else
													if (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												end
											end
										end
									end
								else
									local nearempty = false
							
									local tileid = (x + g) + h * roomsizex
									local l = map[0]
									local tile = l:get_x(x + g, h)
									
									local tcode = tostring(tileid) .. "e"
									
									if ((unitmap[tileid] == nil) or (#unitmap[tileid] == 0)) and (alreadyfound[tcode] == nil) then 
										nearempty = true
									end
									
									if (pnot == false) then
										if nearempty and (alreadyfound[bcode] == nil) then
											alreadyfound[bcode] = 1
											alreadyfound[tcode] = 1
											allfound = allfound + 1
										end
									else
										if (nearempty == false) and (alreadyfound[bcode] == nil) then
											alreadyfound[bcode] = 1
											alreadyfound[tcode] = 1
											allfound = allfound + 1
										end
									end
								end
							end
						end
					end
				elseif (b == "level") and (alreadyfound[bcode] == nil) and (alreadyfound[1] == nil) then
					alreadyfound[bcode] = 1
					alreadyfound[1] = 1
					allfound = allfound + 1
				end
			else
				local ulist = false
			
				if (b ~= "empty") and (b ~= "level") then
					if (pnot == false) then
						if (unitlists[pname] ~= nil) and (#unitlists[pname] > 0) and (alreadyfound[bcode] == nil) then
							for c,d in ipairs(unitlists[pname]) do
								if (alreadyfound[d] == nil) then
									alreadyfound[bcode] = 1
									alreadyfound[d] = 1
									ulist = true
									break
								end
							end
						end
					else
						for c,d in pairs(unitlists) do
							local tested = false
							
							if (c ~= pname) and (#d > 0) and (alreadyfound[bcode] == nil) then
								for e,f in ipairs(d) do
									if (alreadyfound[f] == nil) then
										alreadyfound[bcode] = 1
										alreadyfound[f] = 1
										ulist = true
										tested = true
										break
									end
								end
							end
							
							if tested then
								break
							end
						end
					end
				elseif (b == "empty") then
					local empties = findempty()
					
					if (#empties > 0) and (alreadyfound[bcode] == nil) then
						for c,d in ipairs(unitlists[pname]) do
							if (alreadyfound[d] == nil) then
								alreadyfound[bcode] = 1
								alreadyfound[d] = 1
								ulist = true
								break
							end
						end
					end
				end
				
				if (b ~= "text") and (ulist == false) then
					if (surrounds.r ~= nil) then
						for c,d in ipairs(surrounds.r) do
							if (pnot == false) then
								if (ulist == false) and (d == pname) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									ulist = true
								end
							else
								if (ulist == false) and (d ~= pname) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									ulist = true
								end
							end
						end
					end
				end
				
				if ulist or (b == "text") then
					alreadyfound[bcode] = 1
					allfound = allfound + 1
				end
			end
		end
	else
		print("no parameters given!")
		return false,checkedconds
	end

	return (allfound == #params),checkedconds
end


table.insert(editor_objlist_order, "text_north")
editor_objlist["text_north"] = {
	name = "text_north",
	sprite_in_root = false,
	unittype = "text",
	tags = {"cardinal"},
	tiling = -1,
	type = 7,
	layer = 20,
	colour = {5, 3},
	colour_active = {5, 4},
}

table.insert(editor_objlist_order, "text_south")
editor_objlist["text_south"] = {
	name = "text_south",
	sprite_in_root = false,
	unittype = "text",
	tags = {"cardinal"},
	tiling = -1,
	type = 7,
	layer = 20,
	colour = {5, 3},
	colour_active = {5, 4},
}

table.insert(editor_objlist_order, "text_east")
editor_objlist["text_east"] = {
	name = "text_east",
	sprite_in_root = false,
	unittype = "text",
	tags = {"cardinal"},
	tiling = -1,
	type = 7,
	layer = 20,
	colour = {5, 3},
	colour_active = {5, 4},
}

table.insert(editor_objlist_order, "text_west")
editor_objlist["text_west"] = {
	name = "text_west",
	sprite_in_root = false,
	unittype = "text",
	tags = {"cardinal"},
	tiling = -1,
	type = 7,
	layer = 20,
	colour = {5, 3},
	colour_active = {5, 4},
}

formatobjlist()