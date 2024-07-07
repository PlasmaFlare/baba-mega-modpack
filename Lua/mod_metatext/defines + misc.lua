-- Use the in-game menu now.

table.insert(mod_hook_functions["level_start"], function()
	metatext_fixquirks = get_setting("fix_quirks") --[[Set this to FALSE to:
Make TEXT/META# IS TELE link text units of the same type together rather than all text units included.
(Removed as of v469) Make TEXT IS MORE allow text units to grow into other text units as long as they are not the same type.
Make TEXT/META# IS GROUP, NOUN HAS/MAKE/BECOME GROUP make NOUN HAS/MAKE/BECOME every text included.
Make TEXT/META# IS GROUP, NOUN NEAR GROUP force noun to be near every text included.]]

	metatext_overlaystyle = get_setting("overlay_style", true) --[[Has 3 options:
0 disables this feature.
1 enables overlay if the "meta level" (the amount of times "text_" appears in the name excluding
if the name ends with "text_") does not match the name of the object.
Anything else always enables the overlay.]]

	metatext_textisword = get_setting("text_word") --Makes TEXT IS WORD a default rule, and breaking it will make text not parse.

	metatext_istextnometa = get_setting("is_nometa") --[[Makes METATEXT IS TEXT not turn the text object into it's metatext
counterpart, instead making it not transform.
Not recommended to set to TRUE if you are not using the Meta/Unmeta addon.]]

	metatext_hasmaketextnometa = get_setting("hasmake_nometa") --[[Makes METATEXT HAS/MAKE TEXT not make the text object have/make
it's metatext counterpart. Since you can't make Has/Make Meta/Unmeta, this is really only useful for
consistency I guess.]]

	metatext_autogenerate = get_setting("auto_gen", true) --[[Tries to add more metatext to the object palette if it does not exist.
Can only add up to 35 additional objects. REQUIRES metaunmeta.lua.
Comes with the following options:
0 disables this feature.
1 tries to use the correct sprite, if it exists. Otherwise, it uses the default.
2 is like 1, but if the sprite doesn't exist, it won't generate.
Anything else always uses the default sprite. If you choose this, you're gonna want the overlay on.
Note that if the nonexistant text is available in the editor object list, that will be referenced instead.]]

	metatext_includenoun = get_setting("include_noun") --Includes nouns in NOT META#.

	metatext_glyph_display = get_setting("better_disp")
end
)

-- New function, checks if rule relies on certain noun. Based off of hasfeature()
function checkiftextrule(rule1, rule2, rule3, unitid, findtextrule_, findtag_)
	local findtag = "text"
	local findtextrule = false
	if findtextrule_ ~= nil then
		findtextrule = findtextrule_
	end
	if findtag_ ~= nil then
		findtag = findtag_
	end
	if (featureindex[rule3] ~= nil) and (rule2 ~= nil) and (rule1 ~= nil) then
		for i, rules in ipairs(featureindex[rule3]) do
			local rule = rules[1]
			local conds = rules[2]
			local tags = rules[4]
			local foundtag = false
			for num, tag in pairs(tags) do
				if tag == findtag then
					foundtag = true
					break
				end
			end

			if (conds[1] ~= "never") and (foundtag == findtextrule) then
				if (rule[1] == rule1) and (rule[2] == rule2) and (rule[3] == rule3) then
					if testcond(conds, unitid) then
						return findtextrule
					end
				end
			end
		end
	end
	return (not findtextrule)
end

-- New function that writes the meta level of an object in the top right corner, if enabled.
function writemetalevel()
	if metatext_overlaystyle ~= 0 and not (generaldata.values[MODE] == 5) then
		MF_letterclear("metaoverlay")
		for id, unit in pairs(units) do
			local unitname = unit.strings[UNITNAME]

			local _, textmetalevel = string.gsub(unitname, "text_", "text_")
			local _, glyphmetalevel = string.gsub(unitname, "glyph_", "glyph_")

			if textmetalevel + glyphmetalevel >= 2 and unit.values[TYPE] == 0 and unit.visible then
				local metalevel = getmetalevel(unitname)
				local show = true
				if metatext_overlaystyle == 1 then
					local c = changes[unit.className] or {}
					if c.image == nil then
						show = false
					else
						local imetalevel = getmetalevel(c.image)
						if imetalevel == metalevel then
							show = false
						end
					end
				end
				if show then
					-- imagine flag: print pink T text
					if metatext_glyph_display then
						local color = textoverlaycolor(unit, {4,1}, {4,2})
						local sequenceText, sequenceGlyph = makemetastring(unitname)
						writetext(sequenceText:sub(2), unit.fixed, (8 * unit.scaleX),
								-(6 * unit.scaleY), "metaoverlay", true,
								1, true, color)

						--imagine flag: print blue lambda text. I had to flip it over which was crazy but looks amazing
						local color = textoverlaycolor(unit, {3,3}, {1,4})
						local _, glyphflip = writetext(sequenceGlyph:sub(2), unit.fixed, (8 * unit.scaleX),
								-(6 * unit.scaleY), "metaoverlay", true,
								1, true, color)
						for _, table in ipairs(glyphflip) do
							mmf.newObject(table[1]).angle = 180
						end
					else
						writetext(getmetalevel(getname(unit)), unit.fixed, (8 * unit.scaleX),
								-(6 * unit.scaleY), "metaoverlay", true,
								1, true, color)
					end
				end
			end
		end
	end
end

function textoverlaycolor(unit, maincolor, backcolor)
	local textcolor = maincolor
	local unitcolor1, unitcolor2 = getcolour(unit.fixed)
	if unit.colours ~= nil and #unit.colours > 0 then
		for z, c in pairs(unit.colours) do
			unitcolor1, unitcolor2 = c[1], c[2]
			if textcolor[1] == tonumber(unitcolor1) and textcolor[2] == tonumber(unitcolor2) then
				textcolor = backcolor
			end
		end
	else
		if unit.active == true or generaldata.values[MODE] == 5 then
			unitcolor1, unitcolor2 = getcolour(unit.fixed, "active")
		end
		if textcolor[1] == tonumber(unitcolor1) and textcolor[2] == tonumber(unitcolor2) then
			textcolor = backcolor
		end
	end
	return textcolor
end

table.insert(mod_hook_functions["always"], writemetalevel)

-- Allows TEXT_ to also act as a letter, and enables TEXT IS WORD behavior with letters if enabled

--[[ @Merge: formlettermap() was merged ]]


-- Fix a bug where TEXT_ spells itself, causing rule duplication
-- unfortunately, that means TEXT_ cannot be spelled with letters

--[[ @Merge: findletterwords() was merged ]]


-- Try to add more metatext if it doesn't exist.
function tryautogenerate(want, have)
	if objectpalette[want] ~= nil then return true end
	if want == "text_" or want == "glyph_" then
		return false -- fix silly edgecase
	elseif metatext_autogenerate ~= 0 then
		if editor_objlist_reference[want] ~= nil then
			local data = editor_objlist[editor_objlist_reference[want]]
			local root = data.sprite_in_root
			if root == nil then
				root = true
			end
			local colour = data.colour
			local active = data.colour_active
			local colourasstring = colour[1] .. "," .. colour[2]
			local activeasstring = "0,0"
			if active ~= nil then
				activeasstring = active[1] .. "," .. active[2]
			end
			local new =
			{
				want,
				data.sprite or data.name,
				colourasstring,
				data.tiling,
				data.type or 0,
				data.unittype,
				activeasstring,
				root,
				data.layer or 10,
				nil,
			}
			local target = "120"
			while target ~= "156" do
				local done = true
				for objname, data in pairs(objectpalette) do
					if data == "object" .. target then
						done = false
						target = tostring(tonumber(target) + 1)
						while string.len(target) < 3 do
							target = "0" .. target
						end
					end
				end
				if done then break end
			end
			if target == "156" then
				return false
			else
				savechange("object" .. target, new, nil, true)
				dochanges_full("object" .. target)
				objectpalette[want] = "object" .. target
				objectlist[want] = 1
				if root == true then
					fullunitlist[want] = "fixroot" .. (data.sprite or data.name)
				else
					fullunitlist[want] = "fix" .. (data.sprite or data.name)
				end
				return true
			end
		elseif have == nil then
			local test = want
			local count = 0
			if objectpalette["text_" .. test] == nil then
				while objectpalette[test] == nil do
					if string.sub(test, 1, 5) == "text_" then
						test = string.sub(test, 6)
						count = count + 1
					elseif string.sub(test,1,6) == "glyph_" then
						test = string.sub(test, 7)
						count = count + 1
					else
						local lowestlevel = "text_" .. test
						if lowestlevel == "text_" then
							lowestlevel = "text_text_"
						end
						local SAFETY = 0
						while (not getmat_text(lowestlevel)) and SAFETY < 1000 do
							lowestlevel = "text_" .. lowestlevel
							SAFETY = SAFETY + 1
						end
						-- this shouldn't happen, but just in case
						if SAFETY >= 1000 then
							return false
						end
						have = lowestlevel
						break
					end
				end
				if have == nil then
					have = test
				end
			else
				have = "text_" .. test
			end
		end
		if (string.sub(have,1,5) ~= "text_") and (string.sub(have,1,6) ~= "glyph_") then
			have = "text_" .. have
		end
		print("Trying to generate " .. want .. " from " .. have .. ".")
		local realname = objectpalette[have]
		local root = getactualdata_objlist(realname, "sprite_in_root")
		local colour = getactualdata_objlist(realname, "colour")
		local active = getactualdata_objlist(realname, "active")
		if colour == nil then
			return false
		end
		local sprite = getactualdata_objlist(realname, "sprite", true) or getactualdata_objlist(realname, "name")
		local colourasstring = colour[1] .. "," .. colour[2]
		local activeasstring = "0,0"
		if active ~= nil then
			activeasstring = active[1] .. "," .. active[2]
		end
		local type = getactualdata_objlist(realname, "unittype")
		if (string.sub(want,1,5) == "text_") then
			type = "text"
		elseif (string.sub(want,1,6) == "glyph_") then
			type = "object"
		end
		local new =
		{
			want,
			sprite,
			colourasstring,
			getactualdata_objlist(realname, "tiling"),
			0,
			type,
			activeasstring,
			root,
			getactualdata_objlist(realname, "layer"),
			nil,
		}
		if metatext_autogenerate == 1 or metatext_autogenerate == 2 then
			local spritewanted = ""
			if string.sub(want,1,6) == "glyph_" then
				spritewanted = "glyph_" .. string.gsub(string.gsub(sprite, "text_", ""),"glyph_","")
			elseif string.sub(want,1,5) == "text_" then
				spritewanted = "text_" .. string.gsub(string.gsub(sprite, "text_", ""),"glyph_","")
			end
			if MF_findsprite(spritewanted .. "_0_1.png", false) or MF_findsprite(spritewanted .. "_0_1.png", true) then
				sprite = spritewanted
				new[2] = sprite
				root = MF_findsprite(spritewanted .. "_0_1.png", true)
				new[8] = root
			elseif metatext_autogenerate == 2 then
				return false
			end
		end
		local target = "120"
		while target ~= "156" do
			local done = true
			for objname, data in pairs(objectpalette) do
				if data == "object" .. target then
					done = false
					target = tostring(tonumber(target) + 1)
					while string.len(target) < 3 do
						target = "0" .. target
					end
				end
			end
			if done then break end
		end
		if target == "156" then
			return false
		else
			savechange("object" .. target, new, nil, true)
			dochanges_full("object" .. target)
			objectpalette[want] = "object" .. target
			objectlist[want] = 1
			if root == true then
				fullunitlist[want] = "fixroot" .. sprite
			else
				fullunitlist[want] = "fix" .. sprite
			end
			return true
		end
	end
	return false
end

-- Allows metatext to be named in editor.
if old_editor_trynamechange == nil then
	old_editor_trynamechange = editor_trynamechange
end
-- @Merge(injection)
function editor_trynamechange(object,newname_,fixed,objlistid,oldname_)
	local valid = true

	local newname = newname_ or "error"
	local oldname = oldname_ or "error"
	local checking = true

	if (newname:sub(1,1) == "$") then -- support for raw rename mod
		return old_editor_trynamechange(object,newname_,fixed,objlistid,oldname_)
	end

	newname = string.gsub(newname, "_", "UNDERDASH")
	newname = string.gsub(newname, "%W", "")
	newname = string.gsub(newname, "UNDERDASH", "_")

	while checking do
		checking = false

		for a,obj in pairs(editor_currobjlist) do
			if (obj.name == newname) then
				checking = true

				if (tonumber(string.sub(obj.name, -1)) ~= nil) then
					local num = tonumber(string.sub(obj.name, -1)) + 1

					newname = string.sub(newname, 1, string.len(newname)-1) .. tostring(num)
				else
					newname = newname .. "2"
				end
			end
		end
	end

	if (#newname == 0) or (newname == "level") or (newname == "text_crash") or (newname == "text_error") or (newname == "crash") or (newname == "error") or (newname == "text_never") or (newname == "never") or (newname == "text_") then
		valid = false
	end

	if (string.find(newname, "#") ~= nil) then
		valid = false
	end

	MF_alert("Trying to change name: " .. object .. ", " .. newname .. ", " .. tostring(valid))

	if valid then
		savechange(object,{newname},fixed)
		MF_updateobjlistname_hack(objlistid,newname)

		-- we're gonna change every layer
		local textlessName, metalevel = string.gsub(oldname, "text_", "")
		if string.sub(oldname, -5) == "text_" then
			metalevel = metalevel - 1
			textlessName = "text_"..textlessName
		end
		newname = string.gsub(newname, "text_", "", metalevel)
		
		for i,v in ipairs(editor_currobjlist) do
			--[[if (v.object == object) then -- idk what this does, I'm just gonna disable this
				v.name = newname
			end]]

			local nTextlessName, nMetalevel = string.gsub(v.name, "text_", "")
			if string.sub(v.name, -5) == "text_" then
				nMetalevel = nMetalevel - 1
				nTextlessName = "text_"..nTextlessName
			end

			if (nTextlessName == textlessName) then
				local tOldname = v.name
				v.name = string.rep("text_",nMetalevel) .. newname
				local vid = MF_create(v.object)
				savechange(v.object,{v.name},vid)
				MF_cleanremove(vid)

				MF_alert("Found " .. tOldname .. ", changing to " .. v.name)

				MF_updateobjlistname_byname(tOldname,v.name)
			end
		end
	end

	return valid
end

-- Fix issue with FEAR.

--[[ @Merge: getunitverbtargets() was merged ]]


-- This fixes this really weird bug where the game tries to convert particles and text.
olddoconvert = doconvert
-- @Merge(injection)
function doconvert(data, extrarule_)
	local unitid = data[1]
	if unitid ~= 2 then
		local unit = mmf.newObject(unitid)
		if unit.strings[UNITNAME] == "" then
			return
		end
	end
	olddoconvert(data, extrarule_)
end

--[[ Gets the meta level of a string
(times "text_" appears, minus 1, minus 1 again if the string ends with "text_")
Examples:
"baba" = -1
"text_baba" = 0
"text_text_baba" = 1
"text_text_" = 0
"text_text_text_" = 1
]]
--flag imagine
function getmetalevel(string)
	local _, textmetalevel = string.gsub(string, "text_", "text_")
	local _, glyphmetalevel = string.gsub(string, "glyph_", "glyph_")
	local metalevel = glyphmetalevel + textmetalevel
	if string.sub(string, -5) == "text_" or string.sub(string, -6) == "glyph_" then
		metalevel = metalevel - 1
	end
	metalevel = metalevel - 1
	return metalevel
end

function makemetastring(string)
	local namestring = string
	local sequenceText = ""
	local sequenceGlyph = ""
	while true do
		if namestring:sub(1,5) == "text_" and #namestring > 5 then
			sequenceText = sequenceText.."T"
			sequenceGlyph = sequenceGlyph.." "
			namestring = namestring.gsub(namestring, "text_", "", 1)
		elseif namestring:sub(1,6) == "glyph_" and #namestring > 6 then
			sequenceText = sequenceText.." "
			sequenceGlyph = sequenceGlyph.."V"
			namestring = namestring.gsub(namestring, "glyph_", "", 1)
		else
			return sequenceText, sequenceGlyph
		end
	end
end

-- Remove lines that include "text" rules if rule1 starts with "text_".

--[[ @Merge: hasfeature() was merged ]]


-- Fix issue with TEXT MAKE TEXT

--[[ @Merge: getunitswithverb() was merged ]]

