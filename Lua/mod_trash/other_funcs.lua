function findwastefeature(id)
	local options = {}
	local result = {}

		for i,rules in ipairs(featureindex["waste"]) do
			local rule = rules[1]
			local conds = rules[2]

			if (conds[1] ~= "never") then
				local baserule = {rule[1],rule[2],rule[3]}
				table.insert(options, {baserule,conds})
			end
		end

	for i,rules in ipairs(options) do
		local words = {}
		local baserule = rules[1]

		for a,b in ipairs(baserule) do
			table.insert(words, b)
		end

		if testcond(rules[2], id) then
			table.insert(result, baserule[3])
		end

	end


		return result

end
