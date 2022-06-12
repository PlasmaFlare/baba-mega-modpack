--[[ ========== OVERRIDDEN FUNCTIONS ==========

tools.lua ok
-- isgone(): add check for ALIVE
-- delete(): keep karma after undoing

undo.lua
-- undo(): add "levelkarma" and "unitkarma" events, keep karma when undoing destruction/conversion

syntax.lua ok
-- command(): add check for VESSEL2
-- setunitmap(): keep karma after undoing

map.lua ok
-- displaysigntext(): add check for ALIVE

convert.lua
-- doconvert(): keep karma after a conversion or when undoing

movement.lua
-- movecommand(): add checks for VESSEL and VESSEL2, set karma when a weak object moves into an obstacle, implement HOP for direct movements
-- move(): add karma for OPEN/SHUT and EAT
-- trypush(): add HOP for pushable objects
-- dopush(): add karma for when a WEAK object is pushed into an obstacle, add HOP for pushable objects

blocks.lua ok
-- moveblock(): keep karma after undoing
-- block(): add check for ALIVE, set karma for destructions by overlap or BOOM
-- levelblock(): add check for ALIVE, set level karma for destructions
-- findplayer(): add check for ALIVE and VESSEL

-- ========== OVERRIDDEN FUNCTIONS ==========]]


-- Reset the karma of the outer level
table.insert(mod_hook_functions["level_start"],
    function()
        levelKarma = false
	end
)


-- Checks if the given property is a "player" property
function ws_isPlayerProp(property)
	return property == "you" or property == "you2" or property == "3d" or property == "alive"
end


-- Checks if the level is a "player"
function ws_isLevelPlayer(i,j)
	if (i == nil) or (j == nil) then
		return (hasfeature("level","is","you",1) ~= nil) or (hasfeature("level","is","you2",1) ~= nil) or (hasfeature("level","is","3d",1) ~= nil) or (hasfeature("level","is","alive",1) ~= nil)
	else
		return (hasfeature("level","is","you",1,i,j) ~= nil) or (hasfeature("level","is","you2",1,i,j) ~= nil) or (hasfeature("level","is","3d",1,i,j) ~= nil) or (hasfeature("level","is","alive",1,i,j) ~= nil)
	end
end


-- Returns all the features that match a "player" property
function ws_findPlayers()
	local yous = findfeature(nil,"is","you") or {}
	local yous2 = findfeature(nil,"is","you2")
	local yous3 = findfeature(nil,"is","3d")
	local yous4 = findfeature(nil,"is","alive") -- Added check for ALIVE

	if (yous2 ~= nil) then
		for _,v in ipairs(yous2) do
			table.insert(yous, v)
		end
	end

	if (yous3 ~= nil) then
		for _,v in ipairs(yous3) do
			table.insert(yous, v)
		end
	end

	if (yous4 ~= nil) then -- Add ALIVE entities to "yous"
		for _,v in ipairs(yous4) do
			table.insert(yous, v)
		end
	end
	
	return yous
end


-- Checks if empty should be considered a player
function ws_areTherePlayerEmpties()
	return (#findallfeature("empty","is","you") > 0) or (#findallfeature("empty","is","you2") > 0) or (#findallfeature("empty","is","3d") > 0) or (#findallfeature("empty","is","alive") > 0)
end


-- Returns all the features of the type "level is you-id" or "level is vessel-id"
function ws_findLevelVessel(id_)
	local levelmove
	local id = id_ or ""
	
	levelmove = findfeature("level","is","you"..id) or {}
	local levelvessel = findfeature("level","is","vessel"..id)
	if (levelvessel ~= nil) then
		for i,v in ipairs(levelvessel) do
			table.insert(levelmove, v)
		end
	end
	
	return levelmove
end


-- Returns all the features of the type "x/empty is you-id" or "x/empty is vessel-id"
function ws_findVessels(id_)
	local players = {}
	local empty = {}
	local id = id_ or ""
	
	players,empty = findallfeature(nil,"is","you"..id)
	local vessels,emptyvessels = findallfeature(nil,"is","vessel"..id)
	if (vessels ~= nil) then
		for i,v in ipairs(vessels) do
			table.insert(players, v)
		end
		for i,v in ipairs(emptyvessels) do
			table.insert(empty, v)
		end
	end
	
	return players,empty
end


-- Returns all the features at a certain position that are "players"
function ws_findplayerfeatureat(x,y)
	local result = findfeatureat(nil,"is","you",x,y) or {}
	local you2 = findfeatureat(nil,"is","you2",x,y) or {}
	local you3 = findfeatureat(nil,"is","3d",x,y) or {}
	local you4 = findfeatureat(nil,"is","alive",x,y) or {}

	for _,v in ipairs(you2) do
		table.insert(result, v)
	end

	for _,v in ipairs(you3) do
		table.insert(result, v)
	end

	for _,v in ipairs(you4) do
		table.insert(result, v)
	end

	return result
end


-- Sets the level karma to true and adds it to the undo queue, if it wasn't already true
function ws_setLevelKarma()
	if (levelKarma ~= true) then
		levelKarma = true
		addundo({"levelkarma"})
	end
end


-- Sets the karma of an object to true and adds it to the undo queue, if it wasn't already true
function ws_setKarma(unitid)
	local unit = mmf.newObject(unitid)
	if (unit.karma ~= true) then
		unit.karma = true
		addundo({"unitkarma",unit.values[ID]})
	end
end


--[[ Apply karma to destroyer tiles: 
PARAMS
	x, y: position of the victim
	reason: why the destroyer killed something (eg "melt", "weak", "bonus" etc)
	victimid: the unitid of the object that got destroyed
]]
-- Do we even need to pass/return delthese, removalshort and removalsound? Seems to work ¯\_(ツ)_/¯
function ws_karma(x, y, reason, victimid, delthese, removalshort, removalsound)
	if reason == "melt" then
		local hotfeatures = findfeatureat(nil,"is","hot",x,y)
		for _,hotid in ipairs(hotfeatures) do
			if floating(hotid,victimid,x,y) then -- Only the lavas on the same float level of the melted object are evil
				delthese,removalshort,removalsound = ws_setKarmaOrDestroy(x,y,hotid,delthese,removalshort,removalsound)
			end
		end
	elseif reason == "weak" then
		local others = findallhere(x,y) -- Get all the other overlapping items
		for _,otherid in ipairs(others) do
			if floating(otherid,victimid,x,y) and otherid ~= victimid then
				delthese,removalshort,removalsound = ws_setKarmaOrDestroy(x,y,otherid,delthese,removalshort,removalsound)
			end
		end
	elseif reason == "defeat" then
		local defeatfeatures = findfeatureat(nil,"is","defeat",x,y)
		for _,defeatid in ipairs(defeatfeatures) do
			if floating(defeatid,victimid,x,y) then -- Only the skulls on the same float level of the defeated object are evil
				delthese,removalshort,removalsound = ws_setKarmaOrDestroy(x,y,defeatid,delthese,removalshort,removalsound)
			end
		end
	elseif reason == "bonus" then
		local playerfeatures = ws_findplayerfeatureat(x,y) --(find all the features that are you, you2, 3d, alive)
		for _,playerid in ipairs(playerfeatures) do
			if floating(playerid,victimid,x,y) then
				delthese,removalshort,removalsound = ws_setKarmaOrDestroy(x,y,playerid,delthese,removalshort,removalsound)
			end
		end
	elseif reason == "sink" then -- Object got sinked by something that is SINK
		local sinkfeatures = findfeatureat(nil,"is","sink",x,y)
		for _,sinkid in ipairs(sinkfeatures) do
			if floating(sinkid,victimid,x,y) then -- Only the skulls on the same float level of the defeated object are evil
				delthese,removalshort,removalsound = ws_setKarmaOrDestroy(x,y,sinkid,delthese,removalshort,removalsound)
			end
		end
	elseif reason == "sink2" then -- Object that is SINK got sinked by something else
		-- @mods(word salad x plasma) - rewrote this entire section since guard allows units to still survive while not being "safe".
		local others = findallhere(x,y) -- Get all the other overlapping items
		for _,otherid in ipairs(others) do
			if otherid ~= victimid and floating(otherid,victimid,x,y) then -- Only scan objects that aren't the victim with the same float level
				if is_unit_guarded(otherid) or issafe(otherid) then -- Objects that survive (either through SAFE or GUARD) after the sink action are evil
					ws_setKarma(otherid)
				end
			end
		end
		-- local sinkerfeatures = findfeatureat(nil,"is","safe",x,y) -- Only the survived items are to blame
		-- for _,sinkerid in ipairs(sinkerfeatures) do
		-- 	if floating(sinkerid,victimid,x,y) then -- Only the skulls on the same float level of the defeated object are evil
		-- 		ws_setKarma(sinkerid) -- The sinker is safe, we can directly set its karma
		-- 	end
		-- end
	end
	return delthese, removalshort, removalsound
end


--[[ Destroy tiles by karma, or sets the karma flag
-- x, y: pos of the tile
-- karmaid: id of the unit to destroy
-- delthese: list of unitids to destroy (passed by reference? do we need to return it?)
]]
function ws_setKarmaOrDestroy(x, y, karmaid, delthese, removalshort, removalsound)
	local karmaunit = mmf.newObject(karmaid)
	print("ws_setKarmaOrDestroy for unit", plasma_utils.unitstring(karmaid))
	if hasfeature(getname(karmaunit), "is", "karma", karmaid) and (issafe(karmaid) == false) then
		local pmult,sound = checkeffecthistory("karma")
		MF_particles("unlock",x,y,5 * pmult,2,2,1,1)
		removalshort = sound
		removalsound = 1
		generaldata.values[SHAKE] = 4
		table.insert(delthese, karmaid)

		--[[ 
			@mods(word_salad x plasma) - The below line wasn't added in the original word salad since at this point in the
			code, the karma unit is set to be destroyed. Why bother updating the karma status when the unit will be destroyed?
			Guard however can "rescue" the karma unit from actually being destroyed, meaning the karma unit is in
			delthese but the unit survives. So we still need to update the unit's karma status.
		]]
		if is_unit_guarded(karmaid) then
			ws_setKarma(karmaid)
		end
	else
		ws_setKarma(karmaid)
	end
	return delthese, removalshort, removalsound
end