--First things first: global constants!
--These control where offsets are stored in undo data for the "remove" undo type.
--Changing these may help resolve some conflicts with other mods.
--These two values should be different, and both greater than or equal to 20.
--@Merge: originally these two were 20 and 21. But patashu mods also uses 20 and 21 in its undo data. So changing these globals to different values
XOFFSETUNDOLINE = 22
YOFFSETUNDOLINE = 23

--@Merge: local forward declarations to avoid polluting the namespace
local getoffsetrules
local gettrueoffset
local getunitswithoffset

--The meat of the mod: Update objects' positions based on their offsets.
local function updateoffsets()
	--Offsetting must happen simultaneously, so calculate all offsets first, THEN apply them all at once.
	local poschanges = {}
	local somethingchanged = false
	for i,unit in ipairs(units) do
		local truexoffset,trueyoffset = gettrueoffset(unit)
		local rulexoffset,ruleyoffset = getoffsetrules(unit)

		poschanges[unit] = {rulexoffset - truexoffset, ruleyoffset - trueyoffset}
	end

	for unit,change in pairs(poschanges) do
		local xchange = change[1]
		local ychange = change[2]
		local unitid = unit.fixed
		local unitname = getname(unit)
		if ((xchange ~= 0) or (ychange ~= 0)) then
			if not (((xchange > 0) and cantmove(unitname,unitid,0)) --lockedright
			or ((ychange < 0) and cantmove(unitname,unitid,1)) --lockedup
			or ((xchange < 0) and cantmove(unitname,unitid,2)) --lockedleft
			or ((ychange > 0) and cantmove(unitname,unitid,3))) --lockeddown
			then
				somethingchanged = true
				addundo({"offset",unit.values[ID],unit.xoffset,unit.yoffset})
				unit.xoffset = unit.xoffset + xchange
				unit.yoffset = unit.yoffset + ychange
				update(unitid,unit.values[XPOS] + xchange,unit.values[YPOS] + ychange)
			end
		end
	end

	if somethingchanged then
		updatecode = 1
		code(true)
	end
end

--Patch to code to update offsets whenever the rules are checked, unless an undo happened.
oldcode = code
function code(alreadyrun_)
	oldcode(alreadyrun_)
	if (HACK_INFINITY < 200) and not undoing then
		updateoffsets()
	end
end


--Check if an undo happened (see above) using a global variable.
table.insert(mod_hook_functions["undoed"],
	function()
		undoing = true
	end
)

--completely normal patch to diceblock created by a very sane person
--The undoed_after modhook doesn't work because code() is called AFTER it.
--But according to PlasmaFlare's lovely modding guide, diceblock, a deprecated function,
--is called at the very end of every undo, so it can be used to reset the "undoing" variable.
olddiceblock = diceblock
function diceblock()
	olddiceblock()
	undoing = false
end

--Function to get what an object's offset "should be" based on its Offset rules.
--An object's actual offset might vary from this due to Still and Locked cancelling Offset.
function getoffsetrules(unit)
	local unitid = unit.fixed
	local name = getname(unit)
	local x = unit.values[XPOS]
	local y = unit.values[YPOS]

	local offsettotalx = hasfeature_count(name, "is", "offsetright", unitid, x, y) - hasfeature_count(name, "is", "offsetleft", unitid, x, y)
	local offsettotaly = hasfeature_count(name, "is", "offsetdown", unitid, x, y) - hasfeature_count(name, "is", "offsetup", unitid, x, y)

	return offsettotalx,offsettotaly
end

--Function to get an object's actual offset from its original location.
--This takes Still and Locked into account.
function gettrueoffset(unit)
	if not (unit.xoffset and unit.yoffset) then
		unit.xoffset = 0
		unit.yoffset = 0
	end

	return unit.xoffset,unit.yoffset
end

--Function to get every unit with an Offset rule.
--This makes coding easier because there are four directions and each one has to be checked individually.
--I might not actually use this oh no
function getunitswithoffset()
	local unitswithoffset = getunitswitheffect("offsetright")

	for i,v in ipairs(getunitswitheffect("offsetup")) do
		table.insert(unitswithoffset, v)
	end

	for i,v in ipairs(getunitswitheffect("offsetleft")) do
		table.insert(unitswithoffset, v)
	end
	
	for i,v in ipairs(getunitswitheffect("offsetdown")) do
		table.insert(unitswithoffset, v)
	end

	--Remove duplicates (can happen if an object has multiple Offset rules in different directions)
	local unitswithoffsetnodupes = {}
	local dupes = {}
	for i,v in ipairs(unitswithoffset) do
		if not dupes[v] then
			table.insert(unitswithoffsetnodupes, v)
			dupes[v] = true
		end
	end

	return unitswithoffsetnodupes
end

--Undo stuff! Since offsets are stored in object memory, that information has to be
--stored somewhere when the object is destroyed, so it can be brought back by undoing.

--Patch to addundo to add a destroyed object's offsets to the line of undo data, if applicable.
oldaddundo = addundo
function addundo(line,uid_)
	local ename = line[1]
	if (ename == "remove") then
		local unit = mmf.newObject(getunitid(line[6]))
		line[XOFFSETUNDOLINE] = unit.xoffset
		line[YOFFSETUNDOLINE] = unit.yoffset
	end
	oldaddundo(line,uid_)
end


--Override to undo to put the offset data back on an object when its destruction is undone,
--as well as to add a new undo data type to handle when an object's offset changes.

--[[ @Merge: undo() was merged ]]


--add the offset texts
table.insert(editor_objlist_order, "text_offsetdown")
editor_objlist["text_offsetdown"] = 
{
	name = "text_offsetdown",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "btd456creeper mods", "arrow properties"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_offsetright")
editor_objlist["text_offsetright"] = 
{
	name = "text_offsetright",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "btd456creeper mods", "arrow properties"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_offsetup")
editor_objlist["text_offsetup"] = 
{
	name = "text_offsetup",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "btd456creeper mods", "arrow properties"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

table.insert(editor_objlist_order, "text_offsetleft")
editor_objlist["text_offsetleft"] = 
{
	name = "text_offsetleft",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "btd456creeper mods", "arrow properties"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

--@Merge (offset x plasma): add turning offset
table.insert(editor_objlist_order, "text_turning_offset")
editor_objlist["text_turning_offset"] = 
{
	name = "text_turning_offset",
	sprite_in_root = false,
	unittype = "text",
	tags = {"turning text", "text", "btd456creeper mods", "arrow properties"},
	tiling = 0,
	type = 2,
	layer = 20,
	colour = {1, 3},
	colour_active = {1, 4},
}

formatobjlist()

word_names["offsetright"] = "offset (right)"
word_names["offsetup"] = "offset (up)"
word_names["offsetleft"] = "offset (left)"
word_names["offsetdown"] = "offset (down)"