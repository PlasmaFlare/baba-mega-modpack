

function command(key,player_,keyid,keyid2)
	--[[ 
		@mods(turning text) - Override reason: fixes a bug where if "level is auto" "baba is you" "bird is you2 (down)", pressing "S" will make both baba and bird move down. (Only bird should move down)
		@mods(past) - Override reason: handles direct keyids, turns off during past turns, and add keys.
	 ]]
	if doingpast == false then
		redokeys = {}
	end
	amundoing = false
	if keyid == nil then
		keyid = -1
	if (keys[key] ~= nil) then
		keyid = keys[key]
	else
		print("no such key")
		return
	end
	end
	
	local player = 1
	if (player_ ~= nil) then
		player = player_
	end
	
	do_mod_hook("command_given", {key,player})
	
	if (keyid <= 4) then
		if (generaldata5.values[AUTO_ON] == 0) or doingpast then
			local drs = ndirs[keyid+1]
			local ox = drs[1]
			local oy = drs[2]
			local dir = keyid
			
			last_key = keyid
			
			if (auto_dir[player] == nil) then
				auto_dir[player] = 4
			end
			
			auto_dir[player] = keyid
			
			if (spritedata.values[VISION] == 1) and (dir == 3) then
				if (#units > 0) then
					changevisiontarget()
				end
				movecommand(ox,oy,dir,player,nil,true)
				MF_update()
        		past_addkey(dir,player,keyid2)
			else
				movecommand(ox,oy,dir,player,keyid2)
				MF_update()
        		past_addkey(dir,player,keyid2)
			end
		else
			if (auto_dir[player] == nil) then
				auto_dir[player] = 4
			end
			
			auto_dir[player] = keyid
			
			if (auto_dir[1] == nil) and (featureindex["you2"] == nil) 
				and featureindex["you2right"] == nil 
				and featureindex["you2left"] == nil 
				and featureindex["you2up"] == nil 
				and featureindex["you2down"] == nil 
				and featureindex["vessel2"] == nil -- Added check for VESSEL2 here
				then
				auto_dir[1] = keyid
			end
		end
		--@mods(past x patashu) - if we hit a reset object during a past replay, don't handle reset here. Handle it in
		--the past mod. Need to do so since it uses the "always" modhook
		if doreset and not doingpast then
			resetlevel()
			MF_update()
		else
			resetmoves = math.max(0, resetmoves - 1)
		end
	end
	
	if (hasfeature("level","is","noreset",1) == nil) then
		if (keyid == 5) then
			MF_restart(false)

			-- @Question: do we want to not call this here? For reference, this was commented out in Version 463 in an attempt 
			-- to fix the restart modhook firing even when you say no to the restart prompt
			-- do_mod_hook("level_restart", {})
		elseif (keyid == 8) then
			MF_restart(true)
			-- do_mod_hook("level_restart", {})
		end
	end
	
	dolog(key)

	-- @mods(past)
	if (generaldata5.values[AUTO_ON] <= 0) or doingpast then
		dopast()
	end
end

function setunitmap()
	unitmap = {}
	unittypeshere = {}
	local delthese = {}
	
	local limit = 6
		
	if (generaldata.strings[WORLD] == generaldata.strings[BASEWORLD]) and ((generaldata.strings[CURRLEVEL] == "89level") or (generaldata.strings[CURRLEVEL] == "33level")) then
		limit = 3
	end
	
	if (generaldata.strings[WORLD] == "baba_m") and ((generaldata.strings[CURRLEVEL] == "89level") or (generaldata.strings[CURRLEVEL] == "33level")) then
		limit = 2
	end
	
	for i,unit in ipairs(units) do
		local tileid = unit.values[XPOS] + unit.values[YPOS] * roomsizex
		local valid = true
		
		--print(tostring(unit.values[XPOS]) .. ", " .. tostring(unit.values[YPOS]) .. ", " .. unit.strings[UNITNAME])
		
		if (unitmap[tileid] == nil) then
			unitmap[tileid] = {}
			unittypeshere[tileid] = {}
		end
		
		local uth = unittypeshere[tileid]
		local name = unit.strings[UNITNAME]
		
		if (uth[name] == nil) then
			uth[name] = 0
		end
		
		if (uth[name] < limit) then
			uth[name] = uth[name] + 1
		elseif (string.len(unit.strings[U_LEVELFILE]) == 0) then
			table.insert(delthese, unit)
			valid = false
		end
		
		if valid then
			table.insert(unitmap[tileid], unit.fixed)
		end
	end
	
	for i,unit in ipairs(delthese) do
		local x,y,dir,unitname = unit.values[XPOS],unit.values[YPOS],unit.values[DIR],unit.strings[UNITNAME]
		addundo({"remove",unitname,x,y,dir,unit.values[ID],unit.values[ID],unit.strings[U_LEVELFILE],unit.strings[U_LEVELNAME],unit.values[VISUALLEVEL],unit.values[COMPLETED],unit.values[VISUALSTYLE],unit.flags[MAPLEVEL],unit.strings[COLOUR],unit.strings[CLEARCOLOUR],unit.followed,unit.back_init,unit.originalname,unit.strings[UNITSIGNTEXT],false,unit.fixed,unit.karma}) -- EDIT: keep karma after undoing
		delunit(unit.fixed)
		MF_remove(unit.fixed)
	end
end

function command_auto()
	-- @mods(past)
	if doingpast == false then
		redokeys = {}
	end
	amundoing = false

	local moving = false
	local firstp = -1
	local secondp = -1

	if (auto_dir[1] ~= nil) then
		firstp = auto_dir[1]
		moving = true
	else
		firstp = 4
		moving = true
	end

	if (auto_dir[2] ~= nil) then
		secondp = auto_dir[2]
		moving = true
	else
		secondp = 4
		moving = true
	end

	do_mod_hook("turn_auto", {firstp,secondp,moving})

	if moving and (generaldata5.values[AUTO_ON] > 0) and not doingpast then
		for i=1,generaldata5.values[AUTO_ON] do
			if (firstp ~= 4) then
				last_key = firstp
			elseif (secondp ~= 4) then
				last_key = secondp
			else
				last_key = 4
			end

			local drs = ndirs[firstp+1]
			local ox = drs[1]
			local oy = drs[2]
			local dir = firstp

			if (spritedata.values[VISION] == 1) and (dir == 3) then
				if (#units > 0) then
					changevisiontarget()
				end
				movecommand(ox,oy,dir,3,secondp,true)
			else
				movecommand(ox,oy,dir,3,secondp)
			end
		end

		MF_update()
    	past_addkey(dir,3,secondp)
	end

	auto_dir = {}
  	if (generaldata5.values[AUTO_ON] > 0) and not doingpast then
		dopast()
	end
end

function addunit(id,undoing_,levelstart_)
	local unitid = #units + 1
	
	units[unitid] = {}
	units[unitid] = mmf.newObject(id)
	
	local unit = units[unitid]
	local undoing = undoing_ or false
	local levelstart = levelstart_ or false
	
	getmetadata(unit)
	
	local truename = unit.className
	
	if (changes[truename] ~= nil) then
		dochanges(id)
	end
	
	if (unit.values[ID] == -1) then
		unit.values[ID] = newid()
	end

	if (unit.values[XPOS] > 0) and (unit.values[YPOS] > 0) then
		addunitmap(id,unit.values[XPOS],unit.values[YPOS],unit.strings[UNITNAME])
	end
	
	if (unit.values[TILING] == 1) then
		table.insert(tiledunits, unit.fixed)
	end
	
	if (unit.values[TILING] > 1) then
		table.insert(animunits, unit.fixed)
	end
	
	local name = getname(unit)
	local name_ = unit.strings[NAME]
	local name__ = unit.strings[UNITNAME]
	unit.originalname = unit.strings[UNITNAME]
	
	if (unitlists[name] == nil) then
		unitlists[name] = {}
	end
	
	if (string.sub(name_, 1, 5) == "text_") then
		unit.flags[META] = true
	end
	
	table.insert(unitlists[name], unit.fixed)
	
	if (name ~= name__) then
		if (unitlists[name__] == nil) then
			unitlists[name__] = {}
		end
		table.insert(unitlists[name__], unit.fixed)
	end

	-- Fixes sprites
	if fullunitlist == nil then
		fullunitlist = {}
	elseif fullunitlist[name__] ~= nil and string.sub(fullunitlist[name__],1,3) == "fix" then
		local root = false
		local sprite = string.sub(fullunitlist[name__],4)
		if string.sub(fullunitlist[name__],1,7) == "fixroot" then
			root = true
			sprite = string.sub(fullunitlist[name__],8)
		end
		MF_changesprite(unit.fixed, sprite, root)
		fullunitlist[name__] = 1
	end

	if (unit.strings[UNITTYPE] ~= "text") or ((unit.strings[UNITTYPE] == "text") and (unit.values[TYPE] == 0)) then
		objectlist[name_] = 1
		fullunitlist[name_] = 1
	end
	local validglyph = false
	if gl_isnoun(name__) then
		validglyph = true
	end
	if (string.sub(name__, 1, 6) == "glyph_") and validglyph then
		objectlist[string.sub(name__, 7)] = 1
		fullunitlist[string.sub(name__, 7)] = 1 --@Merge (metatext x glyph): added this line since metatext also uses fullunitlist.
	end

	-- Adds units to meta# unitlist
	local level = getmetalevel(name__)
	if level >= -1 then
		if (unitlists["meta" .. level] == nil) then
			unitlists["meta" .. level] = {}
		end
		table.insert(unitlists["meta" .. level], unit.fixed)
	end
	fullunitlist[name__] = 1

	if (unit.strings[UNITTYPE] == "text") then
		table.insert(codeunits, unit.fixed)
		updatecode = 1

		if (unit.values[TYPE] == 0) then
			local matname = string.sub(unit.strings[UNITNAME], 6)
			if (unitlists[matname] == nil) then
				unitlists[matname] = {}
			end
		elseif (unit.values[TYPE] == 5 or (unit.values[TYPE] == 4 and unit.strings[UNITNAME] == "text_text_")) then
			table.insert(letterunits, unit.fixed)
		end
	end
	
    if (string.sub(name__, 1, 6) == "glyph_") then
		table.insert(glyphunits, unit.fixed)
		local matname = string.sub(unit.strings[UNITNAME], 7)
			if (unitlists[matname] == nil) then
				unitlists[matname] = {}
			end
        updatecode = 1
	end

	unit.colour = {}
	
	if (unit.strings[UNITNAME] ~= "level") and (unit.className ~= "specialobject") then
		local cc1,cc2 = setcolour(unit.fixed)
		unit.colour = {cc1,cc2}
	end
	
	unit.back_init = 0
	unit.broken = 0
	
	if (unit.className ~= "path") and (unit.className ~= "specialobject") then
		statusblock({id},undoing)
		MF_animframe(id,math.random(0,2))
	end
	
	unit.active = false
	unit.new = true
	unit.colours = {}
	unit.currcolour = 0
	unit.followed = -1
	unit.holder = 0
	unit.xpos = unit.values[XPOS]
	unit.ypos = unit.values[YPOS]
	
	if (spritedata.values[VISION] == 1) and (undoing == false) then
		local hasvision = hasfeature(name,"is","3d",id,unit.values[XPOS],unit.values[YPOS])
		if (hasvision ~= nil) then
			table.insert(visiontargets, id)
		elseif (spritedata.values[CAMTARGET] == unit.values[ID]) then
			visionmode(0,0,nil,{unit.values[XPOS],unit.values[YPOS],unit.values[DIR]})
		end
	end
	
	if (spritedata.values[VISION] == 1) and (spritedata.values[CAMTARGET] ~= unit.values[ID]) then
		if (unit.values[ZLAYER] <= 15) then
			if (unit.values[ZLAYER] > 10) then
				setupvision_wall(unit.fixed)
			end
			
			MF_setupvision_single(unit.fixed)
		end
	end
	
	if generaldata.flags[LOGGING] and (generaldata.flags[RESTARTED] == false) then
		if levelstart then
			dolog("init_object","event",unit.strings[UNITNAME] .. ":" .. tostring(unit.values[XPOS]) .. ":" .. tostring(unit.values[YPOS]))
		elseif (undoing == false) then
			dolog("new_object","event",unit.strings[UNITNAME] .. ":" .. tostring(unit.values[XPOS]) .. ":" .. tostring(unit.values[YPOS]))
		end
	end
end

function createall(matdata,x_,y_,id_,dolevels_,leveldata_)
	local all = {}
	local empty = false
	local dolevels = dolevels_ or false
	
	local leveldata = leveldata_ or {}
	
	if (x_ == nil) and (y_ == nil) and (id_ == nil) then
		if (matdata[1] ~= "empty") and (findnoun(matdata[1],nlist.brief) == false) then
			all = findall(matdata)
		elseif (matdata[1] == "empty") then
			all = findempty(matdata[2])
			empty = true
		end
	end
	local test = {}
	
	if (x_ ~= nil) and (y_ ~= nil) and (id_ ~= nil) then
		local check = findtype(matdata,x_,y_,id_)
		
		if (#check > 0) then
			for i,v in ipairs(check) do
				if (v ~= 0) then
					table.insert(test, v)
				end
			end
		end
	end
	
	if (#all > 0) then
		for i,v in ipairs(all) do
			table.insert(test, v)
		end
	end
	
	if (dolevels == false) then
		local delthese = {}
		
		if (#test > 0) then
			for i,v in ipairs(test) do
				if (empty == false) then
					local vunit = mmf.newObject(v)
					local x,y,dir = vunit.values[XPOS],vunit.values[YPOS],vunit.values[DIR]
					
					if (vunit.flags[CONVERTED] == false) then
						for b,unit in pairs(objectlist) do
							if (findnoun(b) == false) and (b ~= matdata[1]) then
								local protect = hasfeature(matdata[1],"is","not " .. b,v,x,y)
								
								if (protect == nil) then
									local mat = findtype({b},x,y,v)
									--local tmat = findtext(x,y)
									
									if (#mat == 0) then
										local nunitid,ningameid = create(b,x,y,dir,nil,nil,nil,nil,leveldata)
										addundo({"convert",matdata[1],mat,ningameid,vunit.values[ID],x,y,dir})
										
										if (matdata[1] == "text") or (string.sub(matdata[1],1,6) == "glyph_") or (string.sub(matdata[1],1,5) == "text_") or (matdata[1] == "level") or (matdata[1] == "glyph") then
											table.insert(delthese, v)
										end
									end
								end
							end
						end
					end
				else
					local x = v % roomsizex
					local y = math.floor(v / roomsizex)
					local dir = emptydir(x,y)
					
					if (dir == 4) then
						dir = fixedrandom(0,3)
					end
					
					local blocked = {}
					
					local valid = true
					if (emptydata[v] ~= nil) then
						if (emptydata[v]["conv"] ~= nil) and emptydata[v]["conv"] then
							valid = false
						end
					end
					
					if valid then
						if (featureindex["empty"] ~= nil) then
							for i,rules in ipairs(featureindex["empty"]) do
								local rule = rules[1]
								local conds = rules[2]
								
								if (rule[1] == "empty") and (rule[2] == "is") and (string.sub(rule[3], 1, 4) == "not ") then
									if testcond(conds,1,x,y) then
										local target = string.sub(rule[3], 5)
										blocked[target] = 1
									end
								end
							end
						end
						
						if (blocked["all"] == nil) then
							for b,mat in pairs(objectlist) do
								if (findnoun(b) == false) and (blocked[b] == nil)  then
									local nunitid,ningameid = create(b,x,y,dir,nil,nil,nil,nil,leveldata)
									addundo({"convert",matdata[1],mat,ningameid,2,x,y,dir})
								end
							end
						end
					end
				end
			end
		end
		
		for a,b in ipairs(delthese) do
			delete(b)
		end
	end
	
	if (matdata[1] == "level") and dolevels then
		local blocked = {}
		
		if (featureindex["level"] ~= nil) then
			for i,rules in ipairs(featureindex["level"]) do
				local rule = rules[1]
				local conds = rules[2]
				
				if (rule[1] == "level") and (rule[2] == "is") and (string.sub(rule[3], 1, 4) == "not ") then
					if testcond(conds,1,x,y) then
						local target = string.sub(rule[3], 5)
						blocked[target] = 1
					end
				end
			end
		end
		
		if (blocked["all"] == nil) and ((matdata[2] == nil) or testcond(matdata[2],1)) then
			for b,unit in pairs(objectlist) do
				if (findnoun(b,nlist.brief) == false) and (b ~= "empty") and (b ~= "level") and (blocked[target] == nil) then
					table.insert(levelconversions, {b, {}})
				end
			end
		end
	end
end