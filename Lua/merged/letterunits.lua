

function formlettermap()
	letterunits_map = {}

	local lettermap = {}
	local letterunitlist = {}
	
	if ((#letterunits > 0) or (#echounits > 0)) then
		for i,unitid in ipairs(letterunits) do
			local unit = mmf.newObject(unitid)

			if (unit.values[TYPE] == 5 or (unit.values[TYPE] == 4 and unit.strings[UNITNAME] == "text_text_")) and (unit.flags[DEAD] == false) then
				local valid = true
				if metatext_textisword and (#wordunits > 0) then
					valid = false
					for c, d in ipairs(wordunits) do
						if (unitid == d[1]) and testcond(d[2], d[1]) then
							valid = true
							break
						end
					end
				end
				if valid then
					local x,y = unit.values[XPOS],unit.values[YPOS]
					--Check for Nuh Uh! here
					if (gettilenegated(x,y) == false) then
						local tileid = x + y * roomsizex

						local name = string.sub(unit.strings[UNITNAME], 6)

						if (lettermap[tileid] == nil) then
							lettermap[tileid] = {}
						end

					table.insert(lettermap[tileid], { name, unitid })
					end
				end
			end
		end
		
		-- Possibly add letters from ECHO stuff
		for i,unitid in ipairs(echounits) do
			local unit = mmf.newObject(unitid[1])
			local matching_texts = ws_getTextDataFromEchoMap(unit.strings[UNITNAME])
			-- Get all text objects on the same tile and remove them (to prevent repeated texts)
			local x,y = unit.values[XPOS], unit.values[YPOS]
			local tileid = x + y * roomsizex
			-- Add letters from other tiles
			for _,text_data in ipairs(matching_texts) do
				if ((text_data[3] ~= tileid) and (text_data[2] == 5)) then
					if (lettermap[tileid] == nil) then
						lettermap[tileid] = {}
					end
				
					table.insert(lettermap[tileid], {text_data[1], unitid[1]})
				end
			end
		end
		
		for tileid,v in pairs(lettermap) do
			local x = math.floor(tileid % roomsizex)
			local y = math.floor(tileid / roomsizex)

			local ux, uy = x, y - 1
			local lx, ly = x - 1, y
			local dx, dy = x, y + 1
			local rx, ry = x + 1, y
			
			local tidr = rx + ry * roomsizex
			local tidu = ux + uy * roomsizex
			local tidl = lx + ly * roomsizex
			local tidd = dx + dy * roomsizex
			
			local continuer = false
			local continued = false
			
			if (lettermap[tidr] ~= nil) then
				continuer = true
			end
			
			if (lettermap[tidd] ~= nil) then
				continued = true
			end
			
			if (#cobjects > 0) then
				for a, b in ipairs(v) do
					local n = b[1]
					if (cobjects[n] ~= nil) then
						continuer = true
						continued = true
						break
					end
				end
			end
			
			if (lettermap[tidl] == nil) and continuer then
				letterunitlist = formletterunits(x, y, lettermap, 1, letterunitlist)
			end
			
			if (lettermap[tidu] == nil) and continued then
				letterunitlist = formletterunits(x, y, lettermap, 2, letterunitlist)
			end
		end
		
		if (unitreference["text_play"] ~= nil) then
			letterunitlist = cullnotes(letterunitlist)
		end
		
		for i, v in ipairs(letterunitlist) do
			local x = v[3]
			local y = v[4]
			local w = v[6]
			local dir = v[5]
			
			local dr = dirs[dir]
			local ox, oy = dr[1], dr[2]
			
			--[[
			MF_debug(x,y,1)
			MF_alert("In database: " .. v[1] .. ", dir " .. tostring(v[5]))
      ]]
			--
			
			local tileid = x + y * roomsizex
			
			if (letterunits_map[tileid] == nil) then
				letterunits_map[tileid] = {}
			end
			
			table.insert(letterunits_map[tileid], { v[1], v[2], v[3], v[4], v[5], v[6], v[7] })
			
			if (w > 1) then
				local endtileid = (x + ox * (w - 1)) + (y + oy * (w - 1)) * roomsizex
				
				if (letterunits_map[endtileid] == nil) then
					letterunits_map[endtileid] = {}
				end
				
				table.insert(letterunits_map[endtileid], { v[1], v[2], v[3], v[4], v[5], v[6], v[7] })
			end
		end
	end
end

function findletterwords(word_, wordpos_, subword_, mainbranch_)
	local word = word_
	local subword = subword_
	local wordpos = wordpos_ or 0
	local mainbranch = true
	local found = false
	local foundsub = false
	local fullwords = {}
	local fullwords_c = {}
	local newbranches = {}

	if (mainbranch_ ~= nil) then
		mainbranch = mainbranch_
	end

	local result = {}

	if (string.len(word) > 1) then
		for i, v in pairs(unitreference) do
			local name = i

			if (string.len(name) > 5) and (string.sub(name, 1, 5) == "text_") then
				name = string.sub(name, 6)
			end

			if (string.len(word) <= string.len(name)) and (string.sub(name, 1, string.len(word)) == word) then
				if (string.len(word) == string.len(name)) then
					table.insert(fullwords, { name, 0 })
					found = true
				else
					found = true
				end
			end

			if (wordpos > 0) and (string.len(word) >= 2) and mainbranch then
				if (string.len(name) >= string.len(subword)) and (string.sub(name, 1, string.len(subword)) == subword) then
					--[[
					if (subword == name) then
						table.insert(fullwords, { name, wordpos + 1 })
						foundsub = true
					else
						table.insert(newbranches, { subword, wordpos })
						foundsub = true
					end
					--]]


					table.insert(newbranches, { subword, wordpos })
					foundsub = true
				end
			end
		end
	end

	if (string.len(word) > 0) then
		for c, d in pairs(cobjects) do
			if (c ~= 1) and (string.len(tostring(c)) > 0) then
				local name = c

				if (string.len(name) > 5) and (string.sub(name, 1, 5) == "text_") then
					name = string.sub(name, 6)
				end

				if (string.len(word) <= string.len(name)) and (string.sub(name, 1, string.len(word)) == word) then
					if (string.len(word) == string.len(name)) then
						table.insert(fullwords_c, { name, 0 })
						found = true
					else
						found = true
					end
				end

				if (wordpos > 0) and (string.len(word) >= 2) and mainbranch then
					if (string.len(name) >= string.len(subword)) and (string.sub(name, 1, string.len(subword)) == subword) then
						table.insert(newbranches, { subword, wordpos })
						foundsub = true
					end
				end
			end
		end
	end

	if (string.len(word) <= 1) then
		found = true
	end

	if (#fullwords > 0) then
		for i, v in ipairs(fullwords) do
			local text = v[1]
			local textpos = v[2]
			local alttext = "text_" .. text

			local name_base = unitreference[text]
			local name_general = objectpalette[text]
			local altname_base = unitreference[alttext]
			local altname_general = objectpalette[alttext]

			local realname = altname_general
			local realname_general = name_general

			if (generaldata.strings[WORLD] == generaldata.strings[BASEWORLD]) then
				realname = altname_base
				realname_general = name_base
			end

			if (realname ~= nil) then
				local name = getactualdata_objlist(realname, "name")
				local wtype = getactualdata_objlist(realname, "type")

				if string.sub(name, -5) ~= "text_" and ((name == text) or (name == alttext)) then
					if (wtype ~= 5) then
						if (realname_general ~= nil) then
							objectlist[text] = 1
						elseif (((text == "all") or (text == "empty")) and (realname ~= nil)) then
							objectlist[text] = 1
						end

						table.insert(result, { name, wtype, textpos })
					end
				end
			end
		end
	end

	if (#fullwords_c > 0) then
		for i, v in ipairs(fullwords_c) do
			if (word == v[1]) then
				table.insert(result, { v[1], 8, v[2] })
			end
		end
	end

	return found, result, newbranches
end