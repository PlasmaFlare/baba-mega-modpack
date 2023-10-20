-- OVERRIDE: add ECHO particles (monkey patching goes brrr)
local effects_old = effects
effects = function(timer) 
	effects_old(timer)
	-- EDIT: Add ECHO particles
	local echornd = math.random(2,3)
	doeffect(timer,nil,"echo","glow",1,5,20,{0,echornd},"reducedlvl")
	doeffect(timer,nil,"echo","glow",1,5,100,{0,1},"reducedlvl")
end

-- OVERRIDE: add "reducedlvl" special rule to make LEVEL IS ECHO less grating

--[[ @Merge: doeffect() was merged ]]
