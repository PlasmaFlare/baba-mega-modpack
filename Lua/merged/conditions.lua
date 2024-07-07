

condlist.on = function(params,checkedconds,checkedconds_,cdata)
	local allfound = 0
	local alreadyfound = {}
	
	local unitid,x,y,surrounds = cdata.unitid,cdata.x,cdata.y,cdata.surrounds
	
	local tileid = x + y * roomsizex
	
	if (unitid ~= 2) then
		if (#params > 0) then
			for a,b in ipairs(params) do
				local pname = b
				local metaparam = false
				if (string.sub(pname, 1, 6) == "glyph_") or (string.sub(pname, 1, 5) == "text_") then
					metaparam = true
				end
				local pnot = false
				if (string.sub(b, 1, 4) == "not ") then
					pnot = true
					pname = string.sub(b, 5)
				end

				local is_param_this, raycast_units, _, this_count = parse_this_param_and_get_raycast_units(pname)
				
				local bcode = b .. "_" .. tostring(a)
				
				if (string.sub(pname, 1, 5) == "group") then
					return false,checkedconds
				end
				
				if (unitid ~= 1) then
					if ((pname ~= "empty") and (b ~= "level")) or ((b == "level") and (alreadyfound[1] ~= nil)) then
						if (unitmap[tileid] ~= nil) then
							for c,d in ipairs(unitmap[tileid]) do
								if (d ~= unitid) and (alreadyfound[d] == nil) then
									local unit = mmf.newObject(d)
									local name_ = getname(unit,pname,pnot)
									if metaparam then
										name_ = unit.strings[UNITNAME]
									end
									
									if (pnot == false) then
										if is_param_this then
											if raycast_units[d] and alreadyfound[bcode] == nil then
												alreadyfound[bcode] = 1
												alreadyfound[d] = 1
												allfound = allfound + 1
											end
										elseif (name_ == pname) and (alreadyfound[bcode] == nil) then
											alreadyfound[bcode] = 1
											alreadyfound[d] = 1
											allfound = allfound + 1
										end
									else
										if is_param_this then
											if raycast_units and not raycast_units[d] and alreadyfound[bcode] == nil and name_ ~= "text" then
												alreadyfound[bcode] = 1
												alreadyfound[d] = 1
												allfound = allfound + 1
											end
										elseif (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
											alreadyfound[bcode] = 1
											alreadyfound[d] = 1
											allfound = allfound + 1
										end
									end
								end
							end
						else
							print("unitmap is nil at " .. tostring(x) .. ", " .. tostring(y) .. " for object " .. tostring(name) .. " (" .. tostring(unitid) .. ")!")
						end
					elseif (pname == "empty") then
						if (pnot == false) then
							return false,checkedconds
						else
							if (unitmap[tileid] ~= nil) then
								for c,d in ipairs(unitmap[tileid]) do
									if (d ~= unitid) and (alreadyfound[d] == nil) then
										alreadyfound[bcode] = 1
										alreadyfound[d] = 1
										allfound = allfound + 1
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
					
					if is_param_this then
						if this_count > 0 then
							ulist = true
						end
					elseif (b ~= "empty") and (b ~= "level") then
						if (pnot == false) then
							if (unitlists[b] ~= nil) and (#unitlists[b] > 0) and (alreadyfound[bcode] == nil) then
								for c,d in ipairs(unitlists[b]) do
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
								
								if (c ~= pname) and (#d > 0) then
									for e,f in ipairs(d) do
										if (alreadyfound[f] == nil) and (alreadyfound[bcode] == nil) then
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
					elseif (b == "level") then
						for c,unit in ipairs(units) do
							if (unit.className == "level") and (alreadyfound[unit.fixed] == nil) and (alreadyfound[bcode] == nil) then
								alreadyfound[bcode] = 1
								alreadyfound[unit.fixed] = 1
								ulist = true
								break
							end
						end
					end
					
					if (b ~= "text") and (ulist == false) then
						if (surrounds["o"] ~= nil) then
							for c,d in ipairs(surrounds["o"]) do
								if (pnot == false) then
									if d ~= "-" and (d == pname or (pname == "glyph" and string.sub(d,1,6) == "glyph_") or (pname == "text" and string.sub(d,1,5) == "text_") or ("meta" .. getmetalevel(d) == pname)) and (alreadyfound[bcode] == nil) then
										alreadyfound[bcode] = 1
										ulist = true
									end
								else
									if d ~= pname and (((pname ~= "text" or string.sub(d,1,5) ~= "text_") and (pname ~= "glyph" or string.sub(d,1,6) ~= "glyph_") and string.sub(pname,1,5) ~= "text_" and string.sub(pname,1,4) ~= "meta") or (string.sub(pname,1,5) == "text_" and string.sub(d,1,5) == "text_") or ("meta"..getmetalevel(d) ~= pname and (metatext_includenoun or getmetalevel(d) >= 0))) and (alreadyfound[bcode] == nil) then
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
	else
		for a,b in ipairs(params) do
			local bcode = b .. "_" .. tostring(a)
			
			if (b == "level") and (alreadyfound[bcode] == nil) then
				alreadyfound[bcode] = 1
				allfound = allfound + 1
			else
				return false,checkedconds
			end
		end
	end
	
	return (allfound == #params),checkedconds
end

condlist.near = function(params,checkedconds,checkedconds_,cdata)
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

			local is_param_this, raycast_units, raycast_tileids, this_count = parse_this_param_and_get_raycast_units(pname)
			local ray_unit_is_empty = is_param_this and raycast_units[2] -- <-- this last condition checks if empty is a raycast unit
			
			if (unitid ~= 1) then
				if (b ~= "level") or ((b == "level") and (alreadyfound[1] ~= nil)) then
					for g=-1,1 do
						for h=-1,1 do
							if (pname ~= "empty") and not ray_unit_is_empty then
								local tileid = (x + g) + (y + h) * roomsizex
								if (unitmap[tileid] ~= nil) then
									for c,d in ipairs(unitmap[tileid]) do
										if (d ~= unitid) and (alreadyfound[d] == nil) then
											local unit = mmf.newObject(d)
											local name_ = getname(unit, pname, pnot)

											if (pnot == false) then
												if is_param_this then
													if raycast_units[d] and alreadyfound[bcode] == nil then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												elseif (name_ == pname) and (alreadyfound[bcode] == nil) then
													alreadyfound[bcode] = 1
													alreadyfound[d] = 1
													allfound = allfound + 1
												end
											else
												if is_param_this then
													if not raycast_units[d] and alreadyfound[bcode] == nil and name_ ~= "text" then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												elseif (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
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
						
								local tileid = (x + g) + (y + h) * roomsizex
								local l = map[0]
								local tile = l:get_x(x + g,y + h)
								
								local tcode = tostring(tileid) .. "e"
								
								if ((unitmap[tileid] == nil) or (#unitmap[tileid] == 0)) and (tile == 255) and (alreadyfound[tcode] == nil) then 
									nearempty = true
								end
								
								if (g == 0) and (h == 0) then
									if (unitid == 2) then
										if (pnot == false) then
											nearempty = false
										end
									elseif (unitid ~= 1) and pnot then
										if (unitmap[tileid] == nil) or (#unitmap[tileid] <= 1) then
											nearempty = true
										end
									end
								end

								-- added "not pnot" since being near "not empty" means near any nonempty object
								if nearempty and not pnot and ray_unit_is_empty and raycast_tileids[tileid] == nil then
									nearempty = false
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
				elseif (b == "level") and (alreadyfound[bcode] == nil) and (alreadyfound[1] == nil) then
					alreadyfound[bcode] = 1
					alreadyfound[1] = 1
					allfound = allfound + 1
				end
			else
				local ulist = false
			
				if is_param_this then
					if this_count > 0 then
						ulist = true
					end
				elseif (b ~= "empty") and (b ~= "level") then
					if (pnot == false) then
						if (unitlists[pname] ~= nil) and (#unitlists[pname] > 0) then
							for c,d in ipairs(unitlists[pname]) do
								if (alreadyfound[d] == nil) and (alreadyfound[bcode] == nil) then
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
							
							if (c ~= pname) and (#d > 0) then
								for e,f in ipairs(d) do
									if (alreadyfound[f] == nil) and (alreadyfound[bcode] == nil) then
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
					for e,f in pairs(surrounds) do
						if (e ~= "dir") then
							for c,d in ipairs(f) do
								if (pnot == false) then
									if (ulist == false) and d ~= "-" and (d == pname or (pname == "glyph" and string.sub(d,1,6) == "glyph_") or (pname == "text" and string.sub(d,1,5) == "text_") or ("meta" .. getmetalevel(d) == pname)) and (alreadyfound[bcode] == nil) then
										alreadyfound[bcode] = 1
										ulist = true
									end
								else
									if (ulist == false) and d ~= pname and (((pname ~= "text" or string.sub(d,1,5) ~= "text_") and (pname ~= "glyph" or string.sub(d,1,6) ~= "glyph_") and string.sub(pname,1,5) ~= "text_" and string.sub(pname,1,4) ~= "meta") or (string.sub(pname,1,5) == "text_" and string.sub(d,1,5) == "text_") or ("meta"..getmetalevel(d) ~= pname and (metatext_includenoun or getmetalevel(d) >= 0))) and (alreadyfound[bcode] == nil) then
										alreadyfound[bcode] = 1
										ulist = true
									end
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

condlist.nextto = function(params,checkedconds,checkedconds_,cdata)
	local allfound = 0
	local alreadyfound = {}
	
	local unitid,x,y,surrounds = cdata.unitid,cdata.x,cdata.y,cdata.surrounds
	
	if (#params > 0) then
		for a,b in ipairs(params) do
			local pname = b
			local metaparam = false
			if (string.sub(pname, 1, 6) == "glyph_") or (string.sub(pname, 1, 5) == "text_") then
				metaparam = true
			end
			local pnot = false
			if (string.sub(b, 1, 4) == "not ") then
				pnot = true
				pname = string.sub(b, 5)
			end
			
			local bcode = b .. "_" .. tostring(a)
			
			if (string.sub(pname, 1, 5) == "group") then
				return false,checkedconds
			end

			local is_param_this, raycast_units, _, this_count = parse_this_param_and_get_raycast_units(pname)
			
			if (unitid ~= 1) then
				if (b ~= "level") or ((b == "level") and (alreadyfound[1] ~= nil)) then
					for g=-1,1 do
						for h=-1,1 do
							if ((h ~= 0) and (g == 0)) or ((h == 0) and (g ~= 0)) then
								if (pname ~= "empty") then
									local tileid = (x + g) + (y + h) * roomsizex
									if (unitmap[tileid] ~= nil) then
										for c,d in ipairs(unitmap[tileid]) do
											if (d ~= unitid) and (alreadyfound[d] == nil) then
												local unit = mmf.newObject(d)
												local name_ = getname(unit,pname,pnot)
												if metaparam then
													name_ = unit.strings[UNITNAME]
												end
												
												if (pnot == false) then
													if is_param_this then
														if raycast_units and raycast_units[d] and alreadyfound[bcode] == nil then
															alreadyfound[bcode] = 1
															alreadyfound[d] = 1
															allfound = allfound + 1
														end
													elseif (name_ == pname) and (alreadyfound[bcode] == nil) then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												else
													if is_param_this then
														if raycast_units and not raycast_units[d] and alreadyfound[bcode] == nil and name_ ~= "text" then
															alreadyfound[bcode] = 1
															alreadyfound[d] = 1
															allfound = allfound + 1
														end
													elseif (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
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
							
									local tileid = (x + g) + (y + h) * roomsizex
									local l = map[0]
									local tile = l:get_x(x + g,y + h)
									
									local tcode = tostring(tileid) .. "e"
									
									if ((unitmap[tileid] == nil) or (#unitmap[tileid] == 0)) and (tile == 255) and (alreadyfound[tcode] == nil) then 
										nearempty = true
									end
									
									if (g == 0) and (h == 0) then
										if (unitid == 2) then
											if (pnot == false) then
												nearempty = false
											end
										elseif (unitid ~= 1) and pnot then
											if (unitmap[tileid] == nil) or (#unitmap[tileid] <= 1) then
												nearempty = true
											end
										end
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
			
				if is_param_this then
					if this_count > 0 then
						ulist = true
					end
				elseif (b ~= "empty") and (b ~= "level") then
					if (pnot == false) then
						if (unitlists[pname] ~= nil) and (#unitlists[pname] > 0) then
							for c,d in ipairs(unitlists[pname]) do
								if (alreadyfound[d] == nil) and (alreadyfound[bcode] == nil) then
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
							
							if (c ~= pname) and (#d > 0) then
								for e,f in ipairs(d) do
									if (alreadyfound[f] == nil) and (alreadyfound[bcode] == nil) then
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
					for e,f in pairs(surrounds) do
						if (e ~= "dir") and (e ~= "o") then
							for c,d in ipairs(f) do
								if (pnot == false) then
									if (ulist == false) and d ~= "-" and (d == pname or (pname == "glyph" and string.sub(d,1,6) == "glyph_") or (pname == "text" and string.sub(d,1,5) == "text_") or ("meta" .. getmetalevel(d) == pname)) and (alreadyfound[bcode] == nil) then
										alreadyfound[bcode] = 1
										ulist = true
									end
								else
									if (ulist == false) and d ~= pname and (((pname ~= "text" or string.sub(d,1,5) ~= "text_") and (pname ~= "glyph" or string.sub(d,1,6) ~= "glyph_") and string.sub(pname,1,5) ~= "text_" and string.sub(pname,1,4) ~= "meta") or (string.sub(pname,1,5) == "text_" and string.sub(d,1,5) == "text_") or ("meta"..getmetalevel(d) ~= pname and (metatext_includenoun or getmetalevel(d) >= 0))) and (alreadyfound[bcode] == nil) then
										alreadyfound[bcode] = 1
										ulist = true
									end
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

condlist.facing = function(params,checkedconds,checkedconds_,cdata)
	local allfound = 0
	local alreadyfound = {}
	
	local unitid,x,y,dir,extras,surrounds,conds = cdata.unitid,cdata.x,cdata.y,cdata.dir,cdata.extras,cdata.surrounds,tostring(cdata.conds)

	if (unitid == 2) and ((checkedconds_ == nil) or (checkedconds_[conds] == nil)) then
		dir = emptydir(x,y,checkedconds)
	end
	
	local ndrs = ndirs[dir+1]
	local ox = ndrs[1]
	local oy = ndrs[2]
	
	local tileid = (x + ox) + (y + oy) * roomsizex
	
	if (#params > 0) and (dir ~= 4) then
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

			local is_param_this, raycast_units, raycast_tileids = parse_this_param_and_get_raycast_units(pname)
			local ray_unit_is_empty = is_param_this and raycast_units[2] -- <-- this last condition checks if empty is a 
			
			if (unitid ~= 1) then
				if not ray_unit_is_empty and (((pname ~= "empty") and (b ~= "level")) or ((b == "level") and (alreadyfound[1] ~= nil))) then
					if (stringintable(pname, extras) == false) then
						if (unitmap[tileid] ~= nil) then
							for c,d in ipairs(unitmap[tileid]) do
								if (d ~= unitid) and (alreadyfound[d] == nil) then
									local unit = mmf.newObject(d)
									local name_ = getname(unit,pname,pnot)
									
									if (pnot == false) then
										if is_param_this then
											if raycast_units and raycast_units[d] and alreadyfound[bcode] == nil then
												alreadyfound[bcode] = 1
												alreadyfound[d] = 1
												allfound = allfound + 1
											end
										elseif (name_ == pname) and (alreadyfound[bcode] == nil) then
											alreadyfound[bcode] = 1
											alreadyfound[d] = 1
											allfound = allfound + 1
										end
									else
										if is_param_this then
											if raycast_units and not raycast_units[d] and alreadyfound[bcode] == nil and name_ ~= "text" then
												alreadyfound[bcode] = 1
												alreadyfound[d] = 1
												allfound = allfound + 1
											end
										elseif (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
											alreadyfound[bcode] = 1
											alreadyfound[d] = 1
											allfound = allfound + 1
										end
									end
								end
							end
						end
					else
						if (pnot == false) then
							if ((pname == "right") and (dir == 0)) or ((pname == "up") and (dir == 1)) or ((pname == "left") and (dir == 2)) or ((pname == "down") and (dir == 3)) then
								if (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									allfound = allfound + 1
								end
							end
						else
							if ((pname == "right") and (dir ~= 0)) or ((pname == "up") and (dir ~= 1)) or ((pname == "left") and (dir ~= 2)) or ((pname == "down") and (dir ~= 3)) then
								if (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									allfound = allfound + 1
								end
							end
						end
					end
				elseif (pname == "empty" or ray_unit_is_empty) then
					local l = map[0]
					local tile = l:get_x(x + ox,y + oy)
					
					if (pnot == false) then
						local this_cond = not ray_unit_is_empty or (ray_unit_is_empty and raycast_tileids[tileid])
						if ((unitmap[tileid] == nil) or (#unitmap[tileid] == 0)) and (tile == 255) and this_cond then
							if (alreadyfound[bcode] == nil) then
								alreadyfound[bcode] = 1
								allfound = allfound + 1
							end
						end
					else
						if ((unitmap[tileid] ~= nil) and (#unitmap[tileid] > 0)) or (tile ~= 255) then
							if (alreadyfound[bcode] == nil) then
								alreadyfound[bcode] = 1
								allfound = allfound + 1
							end
						end
					end
				elseif (b == "level") and (alreadyfound[bcode] == nil) and (alreadyfound[1] == nil) then
					alreadyfound[bcode] = 1
					alreadyfound[1] = 1
					allfound = allfound + 1
				end
			else
				local dirids = {"r","u","l","d"}
				local dirid = dirids[dir + 1]
				
				if (surrounds[dirid] ~= nil) then
					for c,d in ipairs(surrounds[dirid]) do
						if (pnot == false) then
							if d ~= "-" and (d == pname or (pname == "glyph" and string.sub(d,1,6) == "glyph_") or (pname == "text" and string.sub(d,1,5) == "text_") or ("meta" .. getmetalevel(d) == pname)) and (alreadyfound[bcode] == nil) then
								alreadyfound[bcode] = 1
								allfound = allfound + 1
							end
						else
							if d ~= pname and (((pname ~= "text" or string.sub(d,1,5) ~= "text_") and (pname ~= "glyph" or string.sub(d,1,6) ~= "glyph_") and string.sub(pname,1,5) ~= "text_" and string.sub(pname,1,4) ~= "meta") or (string.sub(pname,1,5) == "text_" and string.sub(d,1,5) == "text_") or ("meta"..getmetalevel(d) ~= pname and (metatext_includenoun or getmetalevel(d) >= 0))) and (alreadyfound[bcode] == nil) then
								alreadyfound[bcode] = 1
								allfound = allfound + 1
							end
						end
					end
				end
			end
		end
	else
		--print("no parameters given!")
		return false,checkedconds
	end
	
	return (allfound == #params),checkedconds
end

condlist.seeing = function(params,checkedconds,checkedconds_,cdata)
	local allfound = 0
	local alreadyfound = {}
	local targets = {}
	
	local unitid,x,y,dir,conds,surrounds = cdata.unitid,cdata.x,cdata.y,cdata.dir,tostring(cdata.conds),cdata.surrounds
	
	if (unitid == 2) then
		dir = emptydir(x,y)
	end
	
	local ndrs = ndirs[dir+1]
	local ox = ndrs[1]
	local oy = ndrs[2]
	
	local nx,ny = x,y
	local tileid = (x + ox) + (y + oy) * roomsizex
	local solid = 0
	
	if (checkedconds_ ~= nil) and (checkedconds_[tostring(conds) .. "_s_"] ~= nil) then
		return false,checkedconds,true
	end
	
	if (#params > 0) and (dir ~= 4) then
		while (solid == 0) and inbounds(nx,ny,1) do
			nx = nx + ox
			ny = ny + oy
			
			tileid = nx + ny * roomsizex
			
			if inbounds(nx,ny,1) then
				if (unitmap[tileid] ~= nil) then
					if (#unitmap[tileid] > 0) then
						local detected = false
						
						for a,b in ipairs(unitmap[tileid]) do
							local unit = mmf.newObject(b)
							local name_ = getname(unit,pname,pnot)
							
							if (hasfeature(name_,"is","hide",b,nx,ny,checkedconds) == nil) then
								table.insert(targets, {b, name_})
								detected = true
							end
						end
						
						if (detected == false) then
							table.insert(targets, {2, "empty"})
						end
					else
						table.insert(targets, {2, "empty"})
					end
				else
					table.insert(targets, {2, "empty"})
				end
				
				solid = simplecheck(nx,ny,true,checkedconds)
			else
				solid = 1
			end
		end
		
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

			local is_param_this, raycast_units = parse_this_param_and_get_raycast_units(pname)
			
			if (unitid ~= 1) then
				if ((pname ~= "empty") and (b ~= "level")) or ((b == "level") and (alreadyfound[1] ~= nil)) then
					for c,d_ in ipairs(targets) do
						local d = d_[1]
						
						if (d ~= unitid) and (alreadyfound[d] == nil) and (d ~= 2) then
							local name_ = d_[2]
							
							if (pnot == false) then
								if is_param_this then
									if raycast_units[d] and alreadyfound[bcode] == nil then
										alreadyfound[bcode] = 1
										alreadyfound[d] = 1
										allfound = allfound + 1
									end
								elseif (name_ == pname) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									alreadyfound[d] = 1
									allfound = allfound + 1
								end
							else
								if is_param_this then
									if raycast_units and not raycast_units[d] and alreadyfound[bcode] == nil and name_ ~= "text" then
										alreadyfound[bcode] = 1
										alreadyfound[d] = 1
										allfound = allfound + 1
									end
								elseif (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
									alreadyfound[bcode] = 1
									alreadyfound[d] = 1
									allfound = allfound + 1
								end
							end
						end
					end
				elseif (pname == "empty") then
					for c,d_ in ipairs(targets) do
						local d = d_[1]
						
						if (d == 2) then
							if (pnot == false) then
								if (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									alreadyfound[d] = 1
									allfound = allfound + 1
								end
							else
								if (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									alreadyfound[d] = 1
									allfound = allfound + 1
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
				local dirids = {"r","u","l","d"}
				local dirid = dirids[dir + 1]
				
				if (surrounds[dirid] ~= nil) then
					for c,d in ipairs(surrounds[dirid]) do
						if (pnot == false) then
							if d ~= "-" and (d == pname or (pname == "glyph" and string.sub(d,1,6) == "glyph_") or (pname == "text" and string.sub(d,1,5) == "text_") or ("meta" .. getmetalevel(d) == pname)) and (alreadyfound[bcode] == nil) then
								alreadyfound[bcode] = 1
								allfound = allfound + 1
							end
						else
							if d ~= pname and (((pname ~= "text" or string.sub(d,1,5) ~= "text_") and (pname ~= "glyph" or string.sub(d,1,6) ~= "glyph_") and string.sub(pname,1,5) ~= "text_" and string.sub(pname,1,4) ~= "meta") or (string.sub(pname,1,5) == "text_" and string.sub(d,1,5) == "text_") or ("meta"..getmetalevel(d) ~= pname and (metatext_includenoun or getmetalevel(d) >= 0))) and (alreadyfound[bcode] == nil) then
								alreadyfound[bcode] = 1
								allfound = allfound + 1
							end
						end
					end
				end
			end
		end
	elseif (#params == 0) then
		print("no parameters given!")
		return false,checkedconds,true
	else
		return false,checkedconds,true
	end
	
	return (allfound == #params),checkedconds,true
end

condlist.without = function(params,checkedconds,checkedconds_,cdata)
	local allfound = 0
	local alreadyfound = {}
	local unitcount = {}
	
	local name,unitid,notcond = cdata.name,cdata.unitid,cdata.notcond
			
	if (#params > 0) then
		for a,b in ipairs(params) do
			if (unitcount[b] == nil) then
				unitcount[b] = 0
			end
			
			unitcount[b] = unitcount[b] + 1
		end
		
		if (unitcount["level"] ~= nil) and (unitcount["level"] > 0) then
			unitcount["level"] = unitcount["level"] - 1
		end
			
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
			
			local is_param_this, raycast_units, _, count = parse_this_param_and_get_raycast_units(pname)
			if is_param_this then
				if count == 0 or (count > 0 and raycast_units[unitid]) then
					alreadyfound[bcode] = 1
					allfound = allfound + 1
				end
			elseif ((b ~= "level") and (b ~= "empty")) or ((b == "level") and (unitcount["level"] > 0)) then
				if (pnot == false) then
					if (alreadyfound[bcode] == nil) then
						if (unitlists[b] == nil) or (#unitlists[b] == 0) and (alreadyfound[bcode] == nil) then
							alreadyfound[bcode] = 1
							allfound = allfound + 1
						elseif (unitlists[b] ~= nil) and (#unitlists[b] > 0) then
							local found = false
							
							if (b ~= name) and (b ~= "text" or string.sub(name,1,5) ~= "text_") and ("meta" .. getmetalevel(name) ~= b) then
								if (#unitlists[b] < unitcount[b]) then
									found = true
								end
							else
								if (#unitlists[b] < unitcount[b] + 1) then
									found = true
								end
							end
							
							if found then
								alreadyfound[bcode] = 1
								allfound = allfound + 1
							end
						end
					end
				else
					local foundunits = 0
					local targetcount = unitcount[b]
					
					for c,d in pairs(unitlists) do
						if (c ~= pname) and (#unitlists[c] > 0) and (
						(findnoun(c,nlist.short) == false and string.sub(pname,1,5) ~= "text_" and string.sub(pname,1,4) ~= "meta")
						or (string.sub(pname,1,5) == "text_" and string.sub(c,1,5) == "text_")
						or (string.sub(pname,1,4) == "meta" and string.sub(c,1,4) == "meta" and (metatext_includenoun or c ~= "meta-1"))
						) then
							for e,f in ipairs(d) do
								if (f ~= unitid) and (alreadyfound[f] == nil) then
									alreadyfound[f] = 1
									foundunits = foundunits + 1
									
									if (foundunits >= targetcount) then
										break
									end
								end
							end
						end
						
						if (foundunits >= targetcount) then
							break
						end
					end
					
					if (foundunits < targetcount) and (alreadyfound[bcode] == nil) then
						alreadyfound[bcode] = 1
						allfound = allfound + 1
					end
				end
			elseif (b == "empty") then
				local empties = findempty()
				
				if (name ~= "empty") then
					if (#empties < unitcount[b]) and (alreadyfound[bcode] == nil) then
						alreadyfound[bcode] = 1
						allfound = allfound + 1
					end
				else
					if (#empties < unitcount[b] + 1) and (alreadyfound[bcode] == nil) then
						alreadyfound[bcode] = 1
						allfound = allfound + 1
					end
				end
			elseif (b == "level") then
				allfound = -99
				break
			end
		end
	else
		print("no parameters given!")
		return false,checkedconds
	end

	if notcond then
		return (allfound > 0),checkedconds
	end
			
	return (allfound == #params),checkedconds
end

condlist.above = function(params,checkedconds,checkedconds_,cdata)
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

			local is_param_this, raycast_units, raycast_tileids, this_count = parse_this_param_and_get_raycast_units(pname)
			local ray_unit_is_empty = is_param_this and raycast_units[2]
			
			if (unitid ~= 1) then
				if (b ~= "level") or ((b == "level") and (alreadyfound[1] ~= nil)) then
					if (dist >= 1) then
						for g=1,dist do
							if (pname ~= "empty") and not ray_unit_is_empty then
								local tileid = x + (y + g) * roomsizex
								if (unitmap[tileid] ~= nil) then
									for c,d in ipairs(unitmap[tileid]) do
										if (d ~= unitid) and (alreadyfound[d] == nil) then
											local unit = mmf.newObject(d)
											local name_ = getname(unit,pname,pnot)
											
											if (pnot == false) then
												if is_param_this then
													if raycast_units and raycast_units[d] and alreadyfound[bcode] == nil then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												elseif (name_ == pname) and (alreadyfound[bcode] == nil) then
													alreadyfound[bcode] = 1
													alreadyfound[d] = 1
													allfound = allfound + 1
												end
											else
												if is_param_this then
													if raycast_units and not raycast_units[d] and alreadyfound[bcode] == nil and name_ ~= "text" then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												elseif (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
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
						
								local tileid = x + (y + g) * roomsizex
								local l = map[0]
								local tile = l:get_x(x,y + g)
								
								local tcode = tostring(tileid) .. "e"
								
								if ((unitmap[tileid] == nil) or (#unitmap[tileid] == 0)) and (tile == 255) and (alreadyfound[tcode] == nil) then 
									nearempty = true
								end

								if nearempty and ray_unit_is_empty and raycast_tileids[tileid] == nil and not pnot then
									nearempty = false
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
				elseif (b == "level") and (alreadyfound[bcode] == nil) and (alreadyfound[1] == nil) then
					alreadyfound[bcode] = 1
					alreadyfound[1] = 1
					allfound = allfound + 1
				end
			else
				local ulist = false
			
				if is_param_this then
					if this_count > 0 then
						ulist = true
					end
				elseif (b ~= "empty") and (b ~= "level") then
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
								if (ulist == false) and d ~= "-" and (d == pname or (pname == "glyph" and string.sub(d,1,6) == "glyph_") or (pname == "text" and string.sub(d,1,5) == "text_") or ("meta" .. getmetalevel(d) == pname)) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									ulist = true
								end
							else
								if (ulist == false) and d ~= pname and (((pname ~= "text" or string.sub(d,1,5) ~= "text_") or (pname == "glyph" and string.sub(d,1,6) == "glyph_") and string.sub(pname,1,5) ~= "text_" and string.sub(pname,1,4) ~= "meta") or (string.sub(pname,1,5) == "text_" and string.sub(d,1,5) == "text_") or ("meta"..getmetalevel(d) ~= pname and (metatext_includenoun or getmetalevel(d) >= 0))) and (alreadyfound[bcode] == nil) then
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

condlist.below = function(params,checkedconds,checkedconds_,cdata)
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

			local is_param_this, raycast_units, raycast_tileids, this_count = parse_this_param_and_get_raycast_units(pname)
			local ray_unit_is_empty = is_param_this and raycast_units[2] -- <-- this last condition checks if empty is a raycast unit
			
			if (unitid ~= 1) then
				if (b ~= "level") or ((b == "level") and (alreadyfound[1] ~= nil)) then
					if (y > 1) then
						for g=1,dist do
							if (pname ~= "empty") and not ray_unit_is_empty then
								local tileid = x + (y - g) * roomsizex
								if (unitmap[tileid] ~= nil) then
									for c,d in ipairs(unitmap[tileid]) do
										if (d ~= unitid) and (alreadyfound[d] == nil) then
											local unit = mmf.newObject(d)
											local name_ = getname(unit,pname,pnot)
											
											if (pnot == false) then
												if is_param_this then
													if raycast_units and raycast_units[d] and alreadyfound[bcode] == nil then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												elseif (name_ == pname) and (alreadyfound[bcode] == nil) then
													alreadyfound[bcode] = 1
													alreadyfound[d] = 1
													allfound = allfound + 1
												end
											else
												if is_param_this then
													if raycast_units and not raycast_units[d] and alreadyfound[bcode] == nil and name_ ~= "text" then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												elseif (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
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
						
								local tileid = x + (y - g) * roomsizex
								local l = map[0]
								local tile = l:get_x(x,y - g)
								
								local tcode = tostring(tileid) .. "e"
								
								if ((unitmap[tileid] == nil) or (#unitmap[tileid] == 0)) and (tile == 255) and (alreadyfound[tcode] == nil) then 
									nearempty = true
								end

								if nearempty and ray_unit_is_empty and raycast_tileids[tileid] == nil and not pnot then
									nearempty = false
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
				elseif (b == "level") and (alreadyfound[bcode] == nil) and (alreadyfound[1] == nil) then
					alreadyfound[bcode] = 1
					alreadyfound[1] = 1
					allfound = allfound + 1
				end
			else
				local ulist = false
			
				if is_param_this then
					if this_count > 0 then
						ulist = true
					end
				elseif (b ~= "empty") and (b ~= "level") then
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
								if (ulist == false) and d ~= "-" and (d == pname or (pname == "glyph" and string.sub(d,1,6) == "glyph_") or (pname == "text" and string.sub(d,1,5) == "text_") or ("meta" .. getmetalevel(d) == pname)) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									ulist = true
								end
							else
								if (ulist == false) and d ~= pname and (((pname ~= "text" or string.sub(d,1,5) ~= "text_") and (pname ~= "glyph" or string.sub(d,1,6) ~= "glyph_") and string.sub(pname,1,5) ~= "text_" and string.sub(pname,1,4) ~= "meta") or (string.sub(pname,1,5) == "text_" and string.sub(d,1,5) == "text_") or ("meta"..getmetalevel(d) ~= pname and (metatext_includenoun or getmetalevel(d) >= 0))) and (alreadyfound[bcode] == nil) then
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

condlist.besideright = function(params,checkedconds,checkedconds_,cdata)
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

			local is_param_this, raycast_units, raycast_tileids, this_count = parse_this_param_and_get_raycast_units(pname)
			local ray_unit_is_empty = is_param_this and raycast_units[2] -- <-- this last condition checks if empty is a raycast unit
			
			if (unitid ~= 1) then
				if (b ~= "level") or ((b == "level") and (alreadyfound[1] ~= nil)) then
					if (x > 1) then
						for g=1,dist do
							if (pname ~= "empty") and not ray_unit_is_empty then
								local tileid = (x - g) + y * roomsizex
								if (unitmap[tileid] ~= nil) then
									for c,d in ipairs(unitmap[tileid]) do
										if (d ~= unitid) and (alreadyfound[d] == nil) then
											local unit = mmf.newObject(d)
											local name_ = getname(unit,pname,pnot)
											
											if (pnot == false) then
												if is_param_this then
													if raycast_units and raycast_units[d] and alreadyfound[bcode] == nil then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												elseif (name_ == pname) and (alreadyfound[bcode] == nil) then
													alreadyfound[bcode] = 1
													alreadyfound[d] = 1
													allfound = allfound + 1
												end
											else
												if is_param_this then
													if raycast_units and not raycast_units[d] and alreadyfound[bcode] == nil and name_ ~= "text" then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												elseif (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
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
						
								local tileid = (x - g) + y * roomsizex
								local l = map[0]
								local tile = l:get_x(x - g,y)
								
								local tcode = tostring(tileid) .. "e"
								
								if ((unitmap[tileid] == nil) or (#unitmap[tileid] == 0)) and (tile == 255) and (alreadyfound[tcode] == nil) then 
									nearempty = true
								end

								if nearempty and ray_unit_is_empty and raycast_tileids[tileid] == nil then
									nearempty = false
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
				elseif (b == "level") and (alreadyfound[bcode] == nil) and (alreadyfound[1] == nil) then
					alreadyfound[bcode] = 1
					alreadyfound[1] = 1
					allfound = allfound + 1
				end
			else
				local ulist = false
			
				if is_param_this then
					if this_count > 0 then
						ulist = true
					end
				elseif (b ~= "empty") and (b ~= "level") then
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
								if (ulist == false) and d ~= "-" and (d == pname or (pname == "text" and string.sub(d,1,5) == "text_") or (pname == "glyph" and string.sub(d,1,6) == "glyph_") or ("meta" .. getmetalevel(d) == pname)) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									ulist = true
								end
							else
								if (ulist == false) and d ~= pname and (((pname ~= "text" or string.sub(d,1,5) ~= "text_") and (pname ~= "glyph" or string.sub(d,1,6) ~= "glyph_") and string.sub(pname,1,5) ~= "text_" and string.sub(pname,1,4) ~= "meta") or (string.sub(pname,1,5) == "text_" and string.sub(d,1,5) == "text_") or ("meta"..getmetalevel(d) ~= pname and (metatext_includenoun or getmetalevel(d) >= 0))) and (alreadyfound[bcode] == nil) then
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

condlist.besideleft = function(params,checkedconds,checkedconds_,cdata)
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

			local is_param_this, raycast_units, raycast_tileids, this_count = parse_this_param_and_get_raycast_units(pname)
			local ray_unit_is_empty = is_param_this and raycast_units[2] -- <-- this last condition checks if empty is a raycast unit
			
			if (unitid ~= 1) then
				if (b ~= "level") or ((b == "level") and (alreadyfound[1] ~= nil)) then
					if (dist >= 1) then
						for g=1,dist do
							if (pname ~= "empty") and not ray_unit_is_empty then
								local tileid = (x + g) + y * roomsizex
								if (unitmap[tileid] ~= nil) then
									for c,d in ipairs(unitmap[tileid]) do
										if (d ~= unitid) and (alreadyfound[d] == nil) then
											local unit = mmf.newObject(d)
											local name_ = getname(unit,pname,pnot)
											
											if (pnot == false) then
												if is_param_this then
													if raycast_units and raycast_units[d] and alreadyfound[bcode] == nil then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												elseif (name_ == pname) and (alreadyfound[bcode] == nil) then
													alreadyfound[bcode] = 1
													alreadyfound[d] = 1
													allfound = allfound + 1
												end
											else
												if is_param_this then
													if raycast_units and not raycast_units[d] and alreadyfound[bcode] == nil and name_ ~= "text" then
														alreadyfound[bcode] = 1
														alreadyfound[d] = 1
														allfound = allfound + 1
													end
												elseif (name_ ~= pname) and (alreadyfound[bcode] == nil) and (name_ ~= "text") then
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
						
								local tileid = (x + g) + y * roomsizex
								local l = map[0]
								local tile = l:get_x(x + g,y)
								
								local tcode = tostring(tileid) .. "e"
								
								if ((unitmap[tileid] == nil) or (#unitmap[tileid] == 0)) and (alreadyfound[tcode] == nil) then 
									nearempty = true
								end

								if nearempty and ray_unit_is_empty and raycast_tileids[tileid] == nil then
									nearempty = false
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
				elseif (b == "level") and (alreadyfound[bcode] == nil) and (alreadyfound[1] == nil) then
					alreadyfound[bcode] = 1
					alreadyfound[1] = 1
					allfound = allfound + 1
				end
			else
				local ulist = false
			
				if is_param_this then
					if this_count > 0 then
						ulist = true
					end
				elseif (b ~= "empty") and (b ~= "level") then
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
								if (ulist == false) and d ~= "-" and (d == pname or (pname == "text" and string.sub(d,1,5) == "text_") or (pname == "glyph" and string.sub(d,1,6) == "glyph_") or ("meta" .. getmetalevel(d) == pname)) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									ulist = true
								end
							else
								if (ulist == false) and d ~= pname and (((pname ~= "text" or string.sub(d,1,5) ~= "text_") and (pname ~= "glyph" or string.sub(d,1,6) ~= "glyph_") and string.sub(pname,1,5) ~= "text_" and string.sub(pname,1,4) ~= "meta") or (string.sub(pname,1,5) == "text_" and string.sub(d,1,5) == "text_") or ("meta"..getmetalevel(d) ~= pname and (metatext_includenoun or getmetalevel(d) >= 0))) and (alreadyfound[bcode] == nil) then
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

condlist.feeling = function(params,checkedconds,checkedconds_,cdata)
	local allfound = 0
	local alreadyfound = {}
	local name,unitid,x,y,limit = cdata.name,cdata.unitid,cdata.x,cdata.y,cdata.limit
	
	if (#params > 0) then
		for a,b in ipairs(params) do
			local pname = b
			local pnot = false
			if (string.sub(b, 1, 4) == "not ") then
				pnot = true
				pname = string.sub(b, 5)
			end
			
			local bcode = b .. "_" .. tostring(a)
			local prev_GLOBAL_checking_stable = GLOBAL_checking_stable
			
			-- @mods(this) - special case to handle THIS pointing to a property
			local raycast_objects, found_letterwords = parse_this_param_and_get_raycast_infix_units(pname, "feeling")
			local raycast_props = {}
			for _, raycast_object in ipairs(raycast_objects) do
				local ray_unitid = plasma_utils.parse_object(raycast_object)
				local text_name = get_turning_text_interpretation(ray_unitid)
				raycast_props[text_name] = true
			end
			for _, letterword in ipairs(found_letterwords) do
				local word = letterword[1]
				if (string.len(word) > 5) and (string.sub(word, 1, 5) == "text_") then
                    word = string.sub(letterword[1], 6)
                end
				raycast_props[word] = true
			end
			
			if (featureindex[name] ~= nil) then
				for c,d in ipairs(featureindex[name]) do
					local drule = d[1]
					local dconds = d[2]
					
					if (checkedconds[tostring(dconds)] == nil) then
						if (pnot == false) then
							if (drule[1] == name) and (drule[2] == "is") and (drule[3] == b or raycast_props[drule[3]]) then
								checkedconds[tostring(dconds)] = 1
								
								--@mods(stable) special case with "feeling stable". Need this global set to true to refer to
								-- featureindex instead of the object's stablerules. Also, save the state of the global before setting to true
								local prev_GLOBAL_checking_stable = GLOBAL_checking_stable
								if b == "stable" then
									GLOBAL_checking_stable = true
								end
								if (alreadyfound[bcode] == nil) and testcond(dconds,unitid,x,y,nil,limit,checkedconds) then
									alreadyfound[bcode] = 1
									allfound = allfound + 1
									break
								end
							end
						else
							if (string.sub(drule[3], 1, 4) ~= "not ") then
								local obj = unitreference["text_" .. drule[3]]
								
								if (obj ~= nil) then
									local objtype = getactualdata_objlist(obj,"type")
									
									if (objtype == 2) then
										if drule[3] == "stable" then
											GLOBAL_checking_stable = true
										end
										if (drule[1] == name) and (drule[2] == "is") and (drule[3] ~= pname) then
											checkedconds[tostring(dconds)] = 1
											
											if (alreadyfound[bcode] == nil) and testcond(dconds,unitid,x,y,nil,limit,checkedconds) then
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
			GLOBAL_checking_stable = prev_GLOBAL_checking_stable
		end
	else
		return false,checkedconds,true
	end
	
	return (allfound == #params),checkedconds,true
end

condlist.powered = function(params,checkedconds,checkedconds_,cdata) --To correctly handle TEXT IS POWER and META# IS POWER
	local found = false
	local x,y,limit,subtype,conds = cdata.x,cdata.y,cdata.limit,cdata.subtype,tostring(cdata.conds)
	local fullname = "power" .. subtype
	
	if (poweredstatus[fullname] ~= nil) then
		found = poweredstatus[fullname]
		-- MF_alert("Old solution: " .. tostring(found) .. " " .. fullname)
	elseif (featureindex[fullname] ~= nil) then
		for c,d in ipairs(featureindex[fullname]) do
			local drule = d[1]
			local dconds = d[2]
			
			if (checkedconds[tostring(dconds)] == nil) then
				if (string.sub(drule[1], 1, 4) ~= "not ") and (drule[2] == "is") and (drule[3] == fullname) then
					if (drule[1] ~= "empty") and (drule[1] ~= "level") and (drule[1] ~= "text") and (string.sub(drule[1],1,4) ~= "meta") then -- the changed line
						if (unitlists[drule[1]] ~= nil) then
							checkedconds[tostring(dconds)] = 1
							
							for e,f in ipairs(unitlists[drule[1]]) do
								if testcond(dconds,f,x,y,nil,limit,checkedconds) then
									found = true
									break
								end
							end
						end
					elseif (drule[1] == "empty") then
						local empties = findempty(dconds,true)
						
						if (#empties > 0) then
							found = true
						end
					elseif (drule[1] == "level") and testcond(dconds,1,x,y,nil,limit,checkedconds) then
						found = true
					end
				end
			end
			
			if found then
				break
			end
		end
		
		-- MF_alert("New solution: " .. tostring(found) .. " " .. fullname)
	end
	
	checkedconds = checkedconds_ or {[tostring(conds)] = 1}
	
	if (checkedconds_ == nil) and (poweredstatus[fullname] == nil) then
		-- MF_alert("Status set: " .. tostring(found) .. " " .. fullname)
		poweredstatus[fullname] = found
	end
	
	return found,checkedconds,true
end

function testcond(conds,unitid,x_,y_,autofail_,limit_,checkedconds_,ignorebroken_,subgroup_)
	local result = true

	local orhandling = false
	local orresult = false

	local x,y,name,dir,broken = 0,0,"",4,0
	local surrounds = {}
	local autofail = autofail_ or {}
	local limit = limit_ or 0

	limit = limit + 1
	if (limit > 80) then
		HACK_INFINITY = 200
		destroylevel("infinity")
		return
	end

	local checkedconds = {}
	local ignorebroken = ignorebroken_ or false
	local subgroup = subgroup_ or {}

	if (checkedconds_ ~= nil) then
		for i,v in pairs(checkedconds_) do
			checkedconds[i] = v
		end
	end

	if (#features == 0) then
		return false
	end

	-- 0 = bug, 1 = level, 2 = empty

	if (unitid ~= 0) and (unitid ~= 1) and (unitid ~= 2) and (unitid ~= nil) then
		local unit = mmf.newObject(unitid)
		x = unit.values[XPOS]
		y = unit.values[YPOS]
		name = unit.strings[UNITNAME]
		dir = unit.values[DIR]
		broken = unit.broken or 0

		--[[ Remove to support metatext
		if (unit.strings[UNITTYPE] == "text") then
			name = "text"
		end]]--
	elseif (unitid == 2) then
		x = x_
		y = y_
		name = "empty"
		broken = 0

		if (featureindex["broken"] ~= nil) and (ignorebroken == false) and (checkedconds[tostring(conds)] == nil) then
			checkedconds[tostring(conds)] = 1
			broken = isitbroken("empty",2,x,y,checkedconds)
		end
	elseif (unitid == 1) then
		name = "level"
		surrounds = parsesurrounds()
		dir = tonumber(surrounds.dir) or 4
		broken = 0

		if (featureindex["broken"] ~= nil) and (ignorebroken == false) and (checkedconds[tostring(conds)] == nil) then
			checkedconds[tostring(conds)] = 1
			broken = isitbroken("level",1,x,y,checkedconds)
		end
	end

	checkedconds[tostring(conds)] = 1
	checkedconds[tostring(conds) .. "_s_"] = 1

	if (unitid == 0) or (unitid == nil) then
		print("WARNING!! Unitid is " .. tostring(unitid))
	end

	if ignorebroken then
		broken = 0
	end

	if (broken == 1) then
		result = false
	end

	if (conds ~= nil) and ((broken == nil) or (broken == 0)) then
		if (#conds > 0) then
			local valid = false

			for i,cond in ipairs(conds) do
				local condtype = cond[1]
				local params_ = cond[2]
				local params = {}

				local extras = {}

				if (string.sub(condtype, 1, 1) == "(") then
					condtype = string.sub(condtype, 2)
					orhandling = true
					orresult = false
				end

				if (string.sub(condtype, -1) == ")") then
					condtype = string.sub(condtype, 1, string.len(condtype) - 1)
				end

				local basecondtype = string.sub(condtype, 1, 4)
				local notcond = false

				if (basecondtype == "not ") then
					basecondtype = string.sub(condtype, 5)
					notcond = true
				else
					basecondtype = condtype
				end

				if (condtype ~= "never") then
					local condname = unitreference["text_" .. basecondtype]

					local conddata = conditions[condname] or {}
					if (conddata.argextra ~= nil) then
						extras = conddata.argextra
					end
				end

				for a,b in ipairs(autofail) do
					if (condtype == b) then
						result = false
						valid = true
					end
				end

				if (result == false) and valid then
					break
				end

				if (params_ ~= nil) then
					local handlegroup = false

					for a,b in ipairs(params_) do
						--[[ Test most specific to least specific
						NOUN -> (NOT) META# -> NOT NOUN+TEXT
						]]
						if (string.sub(b, 1, 4) == "not ") or b == "text" then
							table.insert(params, b)
						elseif (string.sub(b, 1, 4) == "meta") or (string.sub(b, 1, 8) == "not meta") then
							local insert = #params
							if insert < 2 then
								local param = params[1] or ""
								if param ~= "text" and (string.sub(param, 1, 4) ~= "not ") then
									table.insert(params, b)
								else
									table.insert(params, 1, b)
								end
							else
								while insert > 1 do
									local param = params[insert]
									if param ~= "text" and (string.sub(param, 1, 4) ~= "not ") then
										break
									end
									insert = insert - 1
								end
								table.insert(params, insert + 1, b)
							end
						else
							table.insert(params, 1, b)
						end

						if (string.sub(b, 1, 5) == "group") or (string.sub(b, 1, 9) == "not group") then
							handlegroup = true
						end
					end

					local removegroup = {}
					local removegroupoffset = 0

					if handlegroup then
						local plimit = #params

						for a=1,plimit do
							local b = params[a]
							local mem = subgroup_
							local notnoun = false

							if (string.sub(b, 1, 5) == "group") then
								if (mem == nil) then
									mem = findgroup(b,false,limit,checkedconds,metatext_fixquirks)
								end
								table.insert(removegroup, a)
							elseif (string.sub(b, 1, 9) == "not group") then
								notnoun = true

								if (mem == nil) then
									mem = findgroup(string.sub(b, 5),true,limit,checkedconds,metatext_fixquirks)
								else
									local memfound = {}

									for c,d in ipairs(mem) do
										memfound[d] = 1
									end

									mem = {}

									for c,mat in pairs(objectlist) do
										if (memfound[c] == nil) and (findnoun(c,nlist.short) == false) then
											table.insert(mem, c)
										end
									end
								end
								table.insert(removegroup, a)
							end

							if (mem ~= nil) then
								for c,d in ipairs(mem) do
									if notnoun or d == "text" then
										table.insert(params, d)
									elseif (string.sub(d, 1, 4) == "meta") then
										local insert = #params
										if insert < 2 then
											local param = params[1] or ""
											if param ~= "text" and (string.sub(param, 1, 4) ~= "not ") then
												table.insert(params, d)
											else
												table.insert(params, 1, d)
											end
										else
											while insert > 1 do
												local param = params[insert]
												if param ~= "text" and (string.sub(param, 1, 4) ~= "not ") then
													break
												end
												insert = insert - 1
											end
											table.insert(params, insert + 1, d)
										end
									else
										table.insert(params, 1, d)
										removegroupoffset = removegroupoffset - 1
									end
								end
							end

							if (mem == nil) or (#mem == 0) then
								table.insert(params, "_NONE_")
								break
							end
						end

						for a,b in ipairs(removegroup) do
							table.remove(params, b - removegroupoffset)
							removegroupoffset = removegroupoffset + 1
						end
					end
				end

				local condsubtype = ""

				if (string.sub(basecondtype, 1, 7) == "powered") then
					for a,b in pairs(condlist) do
						if (#basecondtype > #a) and (string.sub(basecondtype, 1, #a) == a) then
							condsubtype = string.sub(basecondtype, #a + 1)
							basecondtype = string.sub(basecondtype, 1, #a)
							break
						end
					end
				end

				if (condlist[basecondtype] ~= nil) then
					valid = true

					local cfunc = condlist[basecondtype]
					local subresult = true
					local ccc = false
					local cdata = {name = name, x = x, y = y, unitid = unitid, dir = dir, extras = extras, limit = limit, conds = conds, subtype = condsubtype, i = i, surrounds = surrounds, notcond = notcond, debugname = cond[1]}
					subresult,checkedconds,ccc = cfunc(params,checkedconds,checkedconds_,cdata)
					local clearcconds = ccc or false
					
					if notcond then
						subresult = not subresult
					end
					
					if subresult and clearcconds then
						checkedconds = {}
						
						if (checkedconds_ ~= nil) then
							for i,v in pairs(checkedconds_) do
								checkedconds[i] = v
							end
						end
						
						checkedconds[tostring(conds)] = 1
						checkedconds[tostring(conds) .. "_s_"] = 1
					end

					if (subresult == false) then
						if (orhandling == false) then
							result = false
							break
						end
					elseif orhandling then
						orresult = true
					end
				else
					MF_alert("condtype " .. tostring(condtype) .. " doesn't exist?")
					result = false
					break
				end

				if (string.sub(cond[1], -1) == ")") then
					orhandling = false

					if (orresult == false) then
						result = false
						break
					else
						result = true
					end
				end
			end

			if (valid == false) then
				MF_alert("invalid condition!")
				result = true

				for a,b in ipairs(conds) do
					MF_alert(tostring(b[1]))
				end
			end
		end
	end

	return result
end