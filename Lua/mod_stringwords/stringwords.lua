removeatleastone = true
removealltext_s = false
-- Set to true if you want to remove all text_'s instead of only 1

-- @Merge: Word Glossary Mod support
if keys.IS_WORD_GLOSSARY_PRESENT then
	keys.WORD_GLOSSARY_FUNCS.register_author("Wrecking Games", {3,4} )
	keys.WORD_GLOSSARY_FUNCS.add_entries_to_word_glossary({
		{
			name = "starts",
			author = "Wrecking Games",
			group = "Stringwords",
			description =
			[[True if the first letter of the target's name is the provided letter.

            Ex: "All starts B is blue" makes baba blue.

            If the target is "level", the condition checks the level's name for the provided letter.]],
		},
		{
			name = "contain",
			author = "Wrecking Games",
			group = "Stringwords",
			description =
			[[True if any of the letters in the target's name is the provided letter.

            Ex: "All contain a is green" makes flag green.

            If the target is "level", the condition checks the level's name for the provided letter.]],
		},
		{
			name = "ends",
			author = "Wrecking Games",
			group = "Stringwords",
			description =
			[[True if the last letter of the target's name is the provided letter.

            Ex: "All ends E is yellow" makes keke blue.

            If the target is "level", the condition checks the level's name for the provided letter.]],
		},
	})
end



local function get_match_times(str, subs)
	local result = 0
	for i in string.gmatch(str, subs) do
		result = result + 1
	end
	return result
end

local function bool_xor(a, b)
	if a then return not b end
	return b
end

letters_for_stringwords = {"text_","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0","ba","ab","sharp","flat"}
--Add entries to this table if you want other 2-letter words with text type 5 to appear in starts

table.insert(editor_objlist_order, "text_starts")


editor_objlist["text_starts"] =
{
	name = "text_starts",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","text_condition","text_special","stringwords"},
	tiling = -1,
	type = 7,
	argtype = {0,2,8},
	customobjects = letters_for_stringwords,
	layer = 20,
	colour = {0, 1},
	colour_active = {0, 3},
}

table.insert(editor_objlist_order, "text_contain")


editor_objlist["text_contain"] =
{
	name = "text_contain",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","text_condition","text_special","stringwords"},
	tiling = -1,
	type = 7,
	argtype = {0,2,8},
	customobjects = letters_for_stringwords,
	layer = 20,
	colour = {0, 1},
	colour_active = {0, 3},
}

table.insert(editor_objlist_order, "text_ends")


editor_objlist["text_ends"] =
{
	name = "text_ends",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","text_condition","text_special","stringwords"},
	tiling = -1,
	type = 7,
	argtype = {0,2,8},
	customobjects = letters_for_stringwords,
	layer = 20,
	colour = {0, 1},
	colour_active = {0, 3},
}

formatobjlist()


condlist.starts = function(params,_,_,cdata)
	local unitid = cdata.unitid
  local unit = {}
  local name = "empty"
   if (unitid ~= 0) and (unitid ~= 1) and (unitid ~= 2) and (unitid ~= nil) then
	   unit = mmf.newObject(unitid)
  	 name = unit.strings[UNITNAME]
		 if unit.strings[U_LEVELNAME] ~= nil and unit.strings[U_LEVELNAME] ~= "" and unit.strings[U_LEVELNAME] then
			 name = unit.strings[U_LEVELNAME]
		 end
   elseif unitid == 1 then
		 --name = "level"
		 name = generaldata.strings[LEVELNAME]
   elseif unitid ~= 2 then
     return false -- What?
   end

	local dof = true
	if string.sub(name, 1,5) == "text_" and removeatleastone then
		name = string.sub(name, 6, #name)
	elseif string.sub(name, 1,6) == "glyph_" and removeatleastone then
		name = string.sub(name, 7, #name)
	end
	if removealltext_s then
		name = string.gsub(name, "text_", "")
		name = string.gsub(name, "glyph_", "")
	end
	for i, j in ipairs(params) do
		local pnot = false
		local jname = j
		if string.sub(j,1,4) == "not " then
			pnot = true
			jname = string.sub(j,5)
		end

		local is_param_this, raycast_units, _, this_count, this_unitid = parse_this_param_and_get_raycast_units(j)
		local ray_unit_is_empty = is_param_this and raycast_units[2] -- <-- this last condition checks if empty is a raycast unit
		if is_param_this then
			local found_match = false
			if ray_unit_is_empty then
				if string.sub(name, 0, string.len("empty")) == "empty" then
					found_match = true
				end
			else
				for ray_unitid, _ in pairs(raycast_units) do 
					local ray_unit = mmf.newObject(ray_unitid)
					local ray_name = ray_unit.strings[UNITNAME]
					if string.sub(ray_name, 1,5) == "text_" and removeatleastone then
						ray_name = string.sub(ray_name, 6, #ray_name)
					elseif string.sub(ray_name, 1,6) == "glyph_" and removeatleastone then
						ray_name = string.sub(ray_name, 7, #ray_name)
					end
					if string.sub(name, 0, string.len(ray_name)) == ray_name then
						found_match = true
					end
				end
			end

			if not pnot then
				if not found_match then
					dof = false
				end
			else
				if found_match then
					dof = false
				end
			end
		else
			if not pnot then
				if string.sub(name, 0, string.len(jname)) ~= jname then
					dof = false
				end
			else
				if string.sub(name, 0, string.len(jname)) == jname then
					dof = false
				end
			end
		end
	end
	return dof
end

condlist.contain = function(params,_,_,cdata)
	local unitid = cdata.unitid
  local unit = {}
  local name = "empty"
   if (unitid ~= 0) and (unitid ~= 1) and (unitid ~= 2) and (unitid ~= nil) then
     unit = mmf.newObject(unitid)
     name = unit.strings[UNITNAME]
		 if unit.strings[U_LEVELNAME] ~= nil and unit.strings[U_LEVELNAME] ~= "" and unit.strings[U_LEVELNAME] then
			 name = unit.strings[U_LEVELNAME]
		 end
   elseif unitid == 1 then
		 --name = "level"
		 name = generaldata.strings[LEVELNAME]
   elseif unitid ~= 2 then
     return false -- What?
   end


	local dof = true
	if string.sub(name, 1,5) == "text_" and removeatleastone then
		name = string.sub(name, 6, #name)
	elseif string.sub(name, 1,6) == "glyph_" and removeatleastone then
		name = string.sub(name, 7, #name)
	end
	if removealltext_s then
		name = string.gsub(name, "text_", "")
		name = string.gsub(name, "glyph_", "")
	end
	local count_table = {}
	for i, j in ipairs(params) do
		local pnot = false
		local jname = j
		if string.sub(j,1,4) == "not " then
			pnot = true
		end
		local is_param_this, raycast_units, _, this_count, this_unitid = parse_this_param_and_get_raycast_units(j)
		local ray_unit_is_empty = is_param_this and raycast_units[2] -- <-- this last condition checks if empty is a raycast unit
		if is_param_this then
			if ray_unit_is_empty then
				local ray_name = "empty"
				if pnot then
					ray_name = "not "..ray_name
				end
				if count_table[ray_name] == nil then
					count_table[ray_name] = 1
				else
					count_table[ray_name] = count_table[ray_name] + 1
				end
			else
				for ray_unitid, _ in pairs(raycast_units) do
					local ray_unit = mmf.newObject(ray_unitid)
					local ray_name = ray_unit.strings[UNITNAME]
					if string.sub(ray_name, 1,5) == "text_" and removeatleastone then
						ray_name = string.sub(ray_name, 6, #ray_name)
					elseif string.sub(ray_name, 1,6) == "glyph_" and removeatleastone then
						ray_name = string.sub(ray_name, 7, #ray_name)
					end
					if pnot then
						ray_name = "not "..ray_name
					end
					if count_table[ray_name] == nil then
						count_table[ray_name] = 1
					else
						count_table[ray_name] = count_table[ray_name] + 1
					end
				end
			end
		else
			if count_table[jname] == nil then
				count_table[jname] = 1
			else
				count_table[jname] = count_table[jname] + 1
			end
		end
	end
	for pname, count in pairs(count_table) do
		local pnot = false
		if string.sub(pname,1,4) == "not " then
			pnot = true
			pname = string.sub(pname,5)
		end
		if not bool_xor(pnot, (get_match_times(name, pname) >= count)) then
			dof = false
		end
	end
	return dof
end

condlist.ends = function(params,_,_,cdata)
	local unitid = cdata.unitid
  local unit = {}
  local name = "empty"
   if (unitid ~= 0) and (unitid ~= 1) and (unitid ~= 2) and (unitid ~= nil) then
     unit = mmf.newObject(unitid)
     name = unit.strings[UNITNAME]
		 if unit.strings[U_LEVELNAME] ~= nil and unit.strings[U_LEVELNAME] ~= "" and unit.strings[U_LEVELNAME] then
			 name = unit.strings[U_LEVELNAME]
		 end
   elseif unitid == 1 then
     --name = "level"
		 name = generaldata.strings[LEVELNAME]
   elseif unitid ~= 2 then
     return false -- What?
   end

	local dof = true
	if string.sub(name, 1,5) == "text_" and removeatleastone then
		name = string.sub(name, 6, #name)
	elseif string.sub(name, 1,6) == "glyph_" and removeatleastone then
		name = string.sub(name, 7, #name)
	end
	if removealltext_s then
		name = string.gsub(name, "text_", "")
		name = string.gsub(name, "glyph_", "")
	end
	for i, j in ipairs(params) do

		local pnot = false
		local jname = j
		if string.sub(j,1,4) == "not " then
			pnot = true
			jname = string.sub(j,5)
		end

		local is_param_this, raycast_units, _, this_count, this_unitid = parse_this_param_and_get_raycast_units(j)
		local ray_unit_is_empty = is_param_this and raycast_units[2] -- <-- this last condition checks if empty is a raycast unit
		if is_param_this then
			local found_match = false
			if ray_unit_is_empty then
				if string.sub(name, -string.len("empty")) == "empty" then
					found_match = true
				end
			else
				for ray_unitid, _ in pairs(raycast_units) do 
					local ray_unit = mmf.newObject(ray_unitid)
					local ray_name = ray_unit.strings[UNITNAME]
					if string.sub(ray_name, 1,5) == "text_" and removeatleastone then
						ray_name = string.sub(ray_name, 6, #ray_name)
					elseif string.sub(ray_name, 1,6) == "glyph_" and removeatleastone then
						ray_name = string.sub(ray_name, 7, #ray_name)
					end
					if string.sub(name, -string.len(ray_name)) == ray_name then
						found_match = true
					end
				end
			end

			if not pnot then
				if not found_match then
					dof = false
				end
			else
				if found_match then
					dof = false
				end
			end
		else
			if not pnot then
				if string.sub(name, -string.len(jname)) ~= jname then
					dof = false
				end
			else
				if string.sub(name, -string.len(jname)) == jname then
					dof = false
				end
			end
		end
	end
	return dof
end
