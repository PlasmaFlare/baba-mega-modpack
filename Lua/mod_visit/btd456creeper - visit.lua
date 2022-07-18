VISIT_INNERLEVELID = 10

table.insert(editor_objlist_order, "text_visit")

editor_objlist["text_visit"] = 
{
	name = "text_visit",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {0, 2},
	colour_active = {0, 3},
}

formatobjlist()

function dovisit(visitdir)
	if visitdir == 4 then
		visitdir = math.random(0,3)
	end
	if visitdir == 0 then
		visitdir = "r"
	end
	if visitdir == 1 then
		visitdir = "u"
	end
	if visitdir == 2 then
		visitdir = "l"
	end
	if visitdir == 3 then
		visitdir = "d"
	end

	local fullsurrounds = MF_parsestring(generaldata2.strings[LEVELSURROUNDS])
	local stage = 0
	local levelfound

	for i,v in ipairs(fullsurrounds) do
		if v == "levelseparator" then
			stage = 1
		elseif stage == 1 then
			if v == generaldata.strings[VISIT_INNERLEVELID] then
				stage = 2
			else
				stage = 0
			end
		elseif stage == 2 then
			stage = 3
		elseif stage == 3 then
			stage = 4
		elseif stage == 4 and v == visitdir then
			stage = 5
		elseif stage == 5 then
			if v == "u" or v == "l" or v == "d" or v == "dr" then
				break
			elseif tonumber(v) ~= nil then
				levelfound = v
				break
			end
		end
	end

	if levelfound and editor.values[E_INEDITOR] == 0 then
		for i,v in ipairs(fullsurrounds) do
			if v == "levelseparator" and fullsurrounds[i+1] == levelfound then
				findpersists() -- @Merge(Visit x Persist): support for persisting objects via visit
				
				uplevel()
				sublevel(fullsurrounds[i+2],tonumber(fullsurrounds[i+3]),tonumber(fullsurrounds[i+4]))
				generaldata.strings[VISIT_INNERLEVELID] = levelfound
				generaldata.values[TRANSITIONREASON] = 9
				generaldata.values[IGNORE] = 1
				generaldata3.values[STOPTRANSITION] = 1
				generaldata2.values[UNLOCK] = 0
				generaldata2.values[UNLOCKTIMER] = 0
				MF_loop("transition",1)
				break
			end
		end
	else
		destroylevel()
	end
end


--[[ @Merge: getlevelsurrounds() was merged ]]



--[[ @Merge: parsesurrounds() was merged ]]



--[[ @Merge: block() was merged ]]



--[[ @Merge: levelblock() was merged ]]



--[[ @Merge: effects() was merged ]]



--[[ @Merge: doeffect() was merged ]]



--[[ @Merge: changemenu() was merged ]]
