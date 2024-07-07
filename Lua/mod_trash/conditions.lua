function getprops(name)
	local options = {}
	local result = {}

	if (featureindex[name] ~= nil) then
		for i,rules in ipairs(featureindex[name]) do
			local rule = rules[1]
			local conds = rules[2]

			if (conds[1] ~= "never") then
				if (rule[1] == name) and (rule[2] == "is") then
					table.insert(result, {rule[3],conds})
				end
			end
		end
	end

	if (#result > 0) then
		return result
	else
		return {}
	end
end

condlist.sensing = function(params,checkedconds,checkedconds_,cdata)
		local allfound = 0
		local alreadyfound = {}

		local unitid,x,y,surrounds = cdata.unitid,cdata.x,cdata.y,cdata.surrounds

		local tileid = x + y * roomsizex

		if (unitid ~= 2) then
			if (#params > 0) then
				for a,b in ipairs(params) do
					local pname = b
					local pnot = false
					if (string.sub(b, 1, 4) == "not ") then
						pnot = true
						pname = string.sub(b, 5)
					end

					local bcode = b .. "_" .. tostring(a)

					if (string.sub(pname, 1, 5) == "group") then
						return false,checkedconds
					end

					if (unitid ~= 1) then
						if ((pname ~= "empty") and (b ~= "level")) or ((b == "level") and (alreadyfound[1] ~= nil)) then
							if (unitmap[tileid] ~= nil) then
								for c,d in ipairs(unitmap[tileid]) do
									if (d ~= unitid) and (alreadyfound[d] == nil) then
										local unit = mmf.newObject(d)
										local name_ = getname(unit)

										if (alreadyfound[bcode] == nil) then
											if (pnot == false) then

												local props = getprops(name_)

												for e, f in ipairs(props) do
													if f[1] == pname then
														if checkedconds[tostring(f[2])] == nil then
															checkedconds[tostring(f[2])] = 1
															if testcond(f[2], d, nil, nil, nil, nil, checkedconds) then
																alreadyfound[bcode] = 1
																alreadyfound[d] = 1
																allfound = allfound + 1
																break
															end
														end
													end

												end
											else
												if (not hasfeature(name_, "is", pname, d ,nil,nil, checkedconds)) and (name_ ~= "text") then
													alreadyfound[bcode] = 1
													alreadyfound[d] = 1
													allfound = allfound + 1
												end
											end
										end
									end
								end
							else
								print("unitmap is nil at " .. tostring(x) .. ", " .. tostring(y) .. " for object " .. tostring(name) .. " (" .. tostring(unitid) .. ")!")
							end
						elseif (pname == "empty") then
							if (pnot == false) then
								return false,checkedconds
							else
								if (unitmap[tileid] ~= nil) then
									for c,d in ipairs(unitmap[tileid]) do
										if (d ~= unitid) and (alreadyfound[d] == nil) then
											alreadyfound[bcode] = 1
											alreadyfound[d] = 1
											allfound = allfound + 1
										end
									end
								end
							end
						elseif (b == "level") and (alreadyfound[bcode] == nil) and (alreadyfound[1] == nil) then
							alreadyfound[bcode] = 1
							alreadyfound[1] = 1
							allfound = allfound + 1
						end
					else
						local ulist = false

						if (b ~= "empty") and (b ~= "level") then
							if (pnot == false) then
								if (unitlists[b] ~= nil) and (#unitlists[b] > 0) and (alreadyfound[bcode] == nil) then
									for c,d in ipairs(unitlists[b]) do
										if (alreadyfound[d] == nil) then
											alreadyfound[bcode] = 1
											alreadyfound[d] = 1
											ulist = true
											break
										end
									end
								end
							else
								for c,d in pairs(unitlists) do
									local tested = false

									if (c ~= pname) and (#d > 0) then
										for e,f in ipairs(d) do
											if (alreadyfound[f] == nil) and (alreadyfound[bcode] == nil) then
												alreadyfound[bcode] = 1
												alreadyfound[f] = 1
												ulist = true
												tested = true
												break
											end
										end
									end

									if tested then
										break
									end
								end
							end
						elseif (b == "empty") then
							local empties = findempty()

							if (#empties > 0) then
								for c,d in ipairs(empties) do
									if (alreadyfound[d] == nil) and (alreadyfound[bcode] == nil) then
										alreadyfound[bcode] = 1
										alreadyfound[d] = 1
										ulist = true
										break
									end
								end
							end
						elseif (b == "level") then
							for c,unit in ipairs(units) do
								if (unit.className == "level") and (alreadyfound[unit.fixed] == nil) and (alreadyfound[bcode] == nil) then
									alreadyfound[bcode] = 1
									alreadyfound[unit.fixed] = 1
									ulist = true
									break
								end
							end
						end

						if (b ~= "text") and (ulist == false) then
							if (surrounds["o"] ~= nil) then
								for c,d in ipairs(surrounds["o"]) do
									if (pnot == false) then
										if hasfeature(name_, "is", pname, d ,nil,nil, checkedconds) and (alreadyfound[bcode] == nil) then
											alreadyfound[bcode] = 1
											ulist = true
										end
									else
										if hasfeature(name_, "is", pname, d ,nil,nil, checkedconds) and (alreadyfound[bcode] == nil) then
											alreadyfound[bcode] = 1
											ulist = true
										end
									end
								end
							end
						end

						if ulist or (b == "text") then
							alreadyfound[bcode] = 1
							allfound = allfound + 1
						end
					end
				end
			else
				print("no parameters given!")
				return false,checkedconds
			end
		else
			for a,b in ipairs(params) do
				local bcode = b .. "_" .. tostring(a)

				if (b == "level") and (alreadyfound[bcode] == nil) then
					alreadyfound[bcode] = 1
					allfound = allfound + 1
				else
					return false,checkedconds
				end
			end
		end

		return (allfound == #params),checkedconds
	end
