
--[[ @Merge: addunit() was merged ]]



--[[ @Merge: createall() was merged ]]


function createall_single(unitid,conds,x_,y_,id_,dolevels_,leveldata_)
	local all = {}
	local empty = false
	local dolevels = dolevels_ or false
	local delthis = false
	
	local leveldata = leveldata_ or {}
	
	local vunit
	local x,y,dir,name,id = x_,y_,4,"",id_
	
	if (unitid ~= 2) then
		vunit = mmf.newObject(unitid)
		x,y,dir,id = vunit.values[XPOS],vunit.values[YPOS],vunit.values[DIR],vunit.values[ID]
		name = getname(vunit)
	else
		name = "empty"
		dir = emptydir(x,y)
		if (dir == 4) then
			dir = fixedrandom(0,3)
		end
	end
	
	for b,unit in pairs(objectlist) do
		if (findnoun(b) == false) and (b ~= name) then
			local protect = hasfeature(name,"is","not " .. b,unitid,x,y)
			
			if (protect == nil) then
				local mat = findtype({b},x,y,unitid)
				--local tmat = findtext(x,y)
				
				if (#mat == 0) then
					local nunitid,ningameid = create(b,x,y,dir,nil,nil,nil,nil,leveldata)
					addundo({"convert",name,mat,ningameid,id,x,y,dir})
					
					local nunit = mmf.newObject(nunitid)
					
					if (unitid ~= 2) then
						nunit.originalname = vunit.originalname
					else
						nunit.originalname = "empty"
					end
					
					if (name == "text") or (name == "level") or (name =="glyph") then
						delthis = true
					end
				end
			end
		end
	end
	
	if (name == "level") and dolevels then
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
		
		if (blocked["all"] == nil) and ((conds == nil) or testcond(conds,1)) then
			for b,unit in pairs(objectlist) do
				if (findnoun(b,nlist.brief) == false) and (b ~= "empty") and (b ~= "level") and (blocked[target] == nil) then
					table.insert(levelconversions, {b, {}})
				end
			end
		end
	end
	
	return delthis
end