toreplace = { "is", "eat", "make", "has", "fear", "follow", "write", "mimic", "was", "ate", "made", "had", "feared", "followed", "wrote", "mimicked", "willbe", "willhave", "willmake", "willfollow", "willwrite", "willeat", "willfear", "willmimic", "drew", "jotted", "typed", "acted", "performed", "willdraw", "willjot", "willtype", "willact", "willperform" }
replacewith = { "is", "eat", "make", "has", "fear", "follow", "write", "mimic", "is", "eat", "make", "has", "fear", "follow", "write", "mimic", "is", "has", "make", "follow", "write", "eat", "fear", "mimic", "draw", "jot", "type", "act", "perform", "draw", "jot", "type", "act", "perform" }
tense = { "present", "present", "present", "present", "present", "present", "present", "present", "past", "past", "past", "past", "past", "past", "past", "past", "future", "future", "future", "future", "future", "future", "future", "future", "past", "past", "past", "past", "past", "future", "future", "future", "future", "future" }
pasttense = { "was", "ate", "made", "had", "feared", "followed", "wrote", "mimicked", "drew", "jotted", "typed", "acted", "performed" }
presenttense = { "is", "eat", "made", "has", "fear", "follow", "write", "mimic", "draw", "jot", "type", "act", "perform" }
futuretense = { "will be", "will eat", "will make", "will have", "will fear", "will follow", "will write", "will mimic", "will draw", "will jot", "will type", "will act", "will perform" }

function codecheck(unitid,ox,oy,cdir_,ignore_end_,wordunitresult_,echounitresult_)
	--[[ 
		@mods(turning text) - Override reason: provide a hook to reinterpret turning text names based on their direction
	 ]]
	local unit = mmf.newObject(unitid)
	local ux,uy = unit.values[XPOS],unit.values[YPOS]
	local x = unit.values[XPOS] + ox
	local y = unit.values[YPOS] + oy
	local result = {}
	local letters = false
	local justletters = false
	local cdir = cdir_ or 0
	local wordunitresult = wordunitresult_ or {}
	local echounitresult = echounitresult_ or {} -- EDIT: add echounitresult var
	
	local ignore_end = false
	if (ignore_end_ ~= nil) then
		ignore_end = ignore_end_
	end

	if (cdir == 0) then
		MF_alert("CODECHECK - CDIR == 0 - why??")
	end
	local tileid = x + y * roomsizex
	
	if (unitmap[tileid] ~= nil) then
		for i,b in ipairs(unitmap[tileid]) do
			local v = mmf.newObject(b)
			local w = 1
			
			if (v.values[TYPE] ~= 5) and (v.flags[DEAD] == false) then
				if (v.strings[UNITTYPE] == "text") and not metatext_textisword then
					
					--Check for Nuh Uh! here
                    if (gettilenegated(x,y) == false) then
						--@Turning text: reinterpret the meaning of the turning text by replacing its parsed name with an existing name
						local v_name = get_turning_text_interpretation(b)
					
						--@ Turning text
						table.insert(result, {{b}, w, v_name, v.values[TYPE], cdir})
					end
				else
					if (#wordunits > 0) then
						local valid = false
						
						if (wordunitresult[b] ~= nil) and (wordunitresult[b] == 1) then
							valid = true
						elseif (wordunitresult[b] == nil) then
							for c,d in ipairs(wordunits) do
								if (b == d[1]) and testcond(d[2],d[1]) then
									valid = true
									break
								end
							end
						end
						
						if valid then
							if (gettilenegated(x,y) == false) then
								if metatext_textisword then
									table.insert(result, {{b}, w, v.strings[NAME], v.values[TYPE], cdir})
								elseif not isglyph(v) then
									table.insert(result, {{b}, w, v.strings[UNITNAME], v.values[TYPE], cdir})
								else
									table.insert(result, {{b}, w, "glyph", 0, cdir})
								end
							end
						end
					end
					-- EDIT: read ECHO units as text (get the echo unit name, read the values from the echomap, remove overlapping texts)
					if (#echounits > 0) then
						local valid = false
						
						-- Find valid ECHO units
						if (echounitresult[b] ~= nil) and (echounitresult[b] == 1) then
							valid = true
						elseif (echounitresult[b] == nil) then
							for c,d in ipairs(echounits) do
								if (b == d[1]) and testcond(d[2],d[1]) then
									valid = true
									break
								end
							end
						end
						
						if valid then
							-- Get all matching text objects from the echo map
							local matching_texts = ws_getTextDataFromEchoMap(v.strings[UNITNAME])
							--[[ 
							if (matching_texts[1] ~= nil) then
								local first_rulepair = matching_texts[1]
								timedmessage("word: "..first_rulepair[1], 10, 2)
								timedmessage("type: "..first_rulepair[2], 10, 3)
							end 
							--]]
							-- Get all text objects on the same tile and remove them (to prevent repeated texts)
							local this_x = v.values[XPOS]
							local this_y = v.values[YPOS]
							local this_tileid = this_x + this_y * roomsizex
							-- For each remaining text, insert in the table same, but v.strings[UNITNAME] is the text name; v.values[TYPE] is the type of that text
							for _,text_data in ipairs(matching_texts) do
								if (text_data[3] ~= this_tileid) and not gettilenegated(this_x, this_y) then
									local unitidtable = {b}
									local text_name = nil
									if text_data.echotext_unitid == nil then
										-- @Merge(Word Salad x Plasma): in cases where the unit overlapping unit isn't present, just use the provided name. This can happen when ENTERing a level with LEVEL IS ECHO with a text on the level itself
										text_name = text_data[1]
									else
										text_name = get_turning_text_interpretation(text_data.echotext_unitid)
										unitidtable.echotext = text_data.echotext_unitid --@Merge(Word Salad x Plasma): store extra data on unitid of the text being used through echo. (See other comment that uses unitidtable.echotext for why we're doing this)
									end
									table.insert(result, {unitidtable, w, text_name, text_data[2], cdir}) -- @Merge: handle turning text with ECHO
								end
							end
						end
					end
				end
			else
				justletters = true
			end
		end
	end
	
	if (letterunits_map[tileid] ~= nil) then
		for i,v in ipairs(letterunits_map[tileid]) do
			local unitids = v[7]
			local width = v[6]
			local word = v[1]
			local wtype = v[2]
			local dir = v[5]
			
			if (string.len(word) > 5) and (string.sub(word, 1, 5) == "text_") then
            	word = string.sub(v[1], 6)
			end
			
			local valid = true
			if ignore_end and ((x ~= v[3]) or (y ~= v[4])) and (width > 1) then
				valid = false
			end
			
			if (cdir ~= 0) and (width > 1) then
				if ((cdir == 1) and (ux > v[3]) and (ux < v[3] + width)) or ((cdir == 2) and (uy > v[4]) and (uy < v[4] + width)) then
					valid = false
				end
			end
			
			--MF_alert(word .. ", " .. tostring(valid) .. ", " .. tostring(dir) .. ", " .. tostring(cdir))
			
			if (dir == cdir) and valid then
                --Nuh Uh! is NOT checked here, because letters are weird.
                --Instead, for letters, it should be checked in formlettermap().
				table.insert(result, {unitids, width, word, wtype, dir})
				letters = true
			end
		end
	end
	
	return result,letters,justletters
end

function calculatesentences(unitid,x,y,dir,a,b,c,br_calling_calculatesentences_branch)
	--[[ 
		@mods(omni text) - Override reason: extract the branching sentences and build the full 
			sentences with lhs + branching sentence texts.
	 ]]
	local drs = dirs[dir]
	local ox,oy = drs[1],drs[2]
	
	local finals = {}
	local sentences = {}
	local sentence_ids = {}
	local firstwords = {}
	
	local sents = {}
	local done = false
	local verbfound = false
	local objfound = false
	local starting = true
	
	local step = 0
	local rstep = 0
	local combo = {}
	local variantshere = {}
	local totalvariants = 1
	local maxpos = 0
	local prevsharedtype = -1
	local prevmaxw = 1
	local currw = 0
	
	local limiter = 5000
	
	local combospots = {}
	
	local unit = mmf.newObject(unitid)

	local branches = {} -- keep track of which points in the sentence parsing we parse vertically
	local found_branch_on_last_word = false -- flag for detecting if the tail end of a sentence parsed in one direction continues perpendicularly without branching
	local br_and_text_with_split_parsing = {} -- List of branching ands with next text in both directions. Used to determine which sentences to potentially eliminate in docode.

	local br_dir = get_perp_direction(dir)
	local br_dir_vec = dirs[br_dir]

	-- @mods(metatext) - This is set to true if we found "text_" in the results of the current call to codecheck().
	-- This handles the sentence "text_ is is red" not parsing due to a recent optimization of hempuli introduced in version 461
	local found_text_ = false
	
	local done = false
	-- @Phase 1 - Go through units sequentially and build array of slots. Each slot contains a record of a text unit. So each slot can have stacked text.
	-- Also record combo information to use in phase 2.
	while (done == false) and (totalvariants < limiter) do
		local words,letters,jletters = codecheck(unitid,ox*rstep,oy*rstep,dir,true)
		
		--MF_alert(tostring(unitid) .. ", " .. unit.strings[UNITNAME] .. ", " .. tostring(#words))
		
		step = step + 1
		rstep = rstep + 1
		
		if (totalvariants >= limiter) then
			MF_alert("Level destroyed - too many variants A")
			destroylevel("toocomplex")
			return nil
		end
		
		if (totalvariants < limiter) then
			local sharedtype = -1
			local maxw = 1
			
			if (#words > 0) then
				local br_text_count = 0
				sents[step] = {}
				
				local branching_texts = {}

				for i,v in ipairs(words) do
					--unitids, width, word, wtype, dir
					
					--MF_alert("Step " .. tostring(step) .. ", word " .. v[3] .. " here, " .. tostring(v[2]))
					
					if (sharedtype == -1) then
						sharedtype = v[4]
					elseif (v[4] ~= sharedtype) then
						sharedtype = -2
					end
					
					if (v[4] == 1) then
						verbfound = true
					end
					
					if v[4] == 4 and is_str_special_prefix(v[3]) then
						found_text_ = true
					end
					
					if (v[4] == 0) or (v[4] == 4 and is_str_special_prefix(v[3])) then
						objfound = true
					end
				
					if starting and ((v[4] == 0) or (v[4] == 3) or (v[4] == 4) or name_is_branching_text(v[3], true, true)) then
						starting = false
					end

					local text_name = v[3]
					if name_is_branching_text(text_name) then
						-- Gather all branching texts to do the perp calculatesentences on
						table.insert(branching_texts, v)

						-- initialize every branching text to not use sentence elimination by default
						local br_unitid = v[1][1]
						local br_unit = mmf.newObject(br_unitid)
						br_and_text_with_split_parsing[br_unitid] = nil
					end

					local add_to_sents = true
					if name_is_branching_text(text_name, false, true) then
						--[[ 
							@mod(Omni text) - prevent pivot text specifically from being added to sents since we want parsing to stop in the current direction
							and start parsing in the perp direction (which is handled by submitting a branch for br_process_branches()). We do it this way instead
							of changing direction of parsing overall since we want to account for stacked texts. If pivot_is and some other normal text
						 ]]
						add_to_sents = false
					end

					if add_to_sents then
						--@Merge(Word Salad x Plasma): Echotext represents the unitid of the text on an ECHO object that gets used to form this sentence. Insert into
						-- sents a word entry that contains the echotext unitid instead of the ECHO unit. This is so that get_target_unitid_from_rule() and get_property_unitid_from_rule()
						-- from th_testcond_this.lua can properly work with ECHO.
						if v[1].echotext ~= nil then
							v = plasma_utils.deep_copy_table(v)
							v[1][1] = v[1].echotext
							v[1].echotext = nil
						end

						table.insert(sents[step], v)
						maxw = math.max(maxw, v[2])

						if (v[2] > 1) then
							currw = math.max(currw, v[2] + 1)
						end
					end
				end
				
				if (sharedtype >= 0) and (prevsharedtype >= 0) and (#words > 0) and (maxw == 1) and (prevmaxw == 1) and (currw == 0) and not br_calling_calculatesentences_branch and not found_text_ then
					if ((sharedtype == 0) and (prevsharedtype == 0)) or ((sharedtype == 1) and (prevsharedtype == 1)) or ((sharedtype == 2) and (prevsharedtype == 2)) or ((sharedtype == 0) and (prevsharedtype == 2)) then
						done = true
						sents[step] = nil
						--MF_alert("added " .. words[1][3])
						table.insert(firstwords, {words[1][1], dir, words[1][2], words[1][3], words[1][4], {}})
					end
				end

				currw = math.max(currw - 1, 0)
				
				prevsharedtype = sharedtype
				prevmaxw = maxw
				
				if (done == false) then
					if starting and not br_calling_calculatesentences_branch then
						sents[step] = nil
						step = step - 1
					else
						for i,v in ipairs(words) do
							local text_name = v[3]
							if name_is_branching_text(text_name, false, true) then
								br_text_count = br_text_count + 1
							end
						end
						if #words ~= br_text_count then
							totalvariants = totalvariants * (#words - br_text_count)
						end
						variantshere[step] = #words - br_text_count
						combo[step] = 1
					
						if (totalvariants >= limiter) then
							MF_alert("Level destroyed - too many variants B")
							destroylevel("toocomplex")
							return nil
						end
						
						if (#words - br_text_count > 1) then
							combospots[#combospots + 1] = step
						end
						
						if (totalvariants > #finals) then
							local limitdiff = totalvariants - #finals
							for i=1,limitdiff do
								table.insert(finals, {})
							end
						end
						
						-- Get a test unit id from branching texts to use in codecheck. (Used to "step" perpendicularly)
						local test_br_unitid = nil
						if #branching_texts > 0 then
							test_br_unitid = branching_texts[1][1][1]
						end
		
						found_branch_on_last_word = false
						if br_dir_vec and test_br_unitid then
							-- Step perpendicularly. If there's text there, record essential information needed to parse that branch.
							local br_x = x + ox*step + br_dir_vec[1]
							local br_y = y + oy*step + br_dir_vec[2]
							local br_tileid = br_x + br_y * roomsizex
							local br_words, br_letters, br_justletters = codecheck(test_br_unitid, br_dir_vec[1], br_dir_vec[2], br_dir, true)
							
		
							if #br_words > 0 then
								local br_firstwords = {}
		
								--@cleanup: Normally we shouldn't need to record an entire list of firstwords, 
								-- but weirdly enough, directly recording the first element and using it in the later codecheck that steps perpendicularly
								-- causes a stack overflow error for some reason... Note that this was during setting br_unit.br_detected_splitted_parsing flag
								--  inside a unit object. Could that be the reason?
								for _, word in ipairs(br_words) do
									table.insert(br_firstwords, word[1][1])
								end
								for _, br_text in ipairs(branching_texts) do
									if name_is_branching_and(br_text[3]) then
										local br_unitid = br_text[1][1]
										local br_unit = mmf.newObject(br_unitid)
										br_and_text_with_split_parsing[br_unitid] = true
									end
								end

								local lhs_word_slots = {}
								for s = 1, step-1 do
									local words = {}
									lhs_word_slots[s] = {}
									for _, word in ipairs(sents[s]) do
										local width = word[2]
										if s + width <= step then
											table.insert(words, word)
										end
									end
									lhs_word_slots[s] = words
								end
								local t = {
									lhs_word_slots = lhs_word_slots,
									branching_texts = branching_texts,
									step_index = step, 
									x = br_x,
									y = br_y,
									firstwords = br_firstwords,
									num_combospots = #combospots
								}

								if BRANCHING_TEXT_LOGGING then 
									print("inserting branch..") 
								end
								table.insert(branches, t)
								found_branch_on_last_word = true
							end
						end
					end

					if br_text_count == #words then
						done = true
					end
				end
			else
				--MF_alert("Step " .. tostring(step) .. ", no words here, " .. tostring(letters) .. ", " .. tostring(jletters))
				
				if jletters then
					variantshere[step] = 0
					sents[step] = {}
					combo[step] = 0
					
					if starting and not br_calling_calculatesentences_branch then
						sents[step] = nil
						step = step - 1
					end
				else
					if found_branch_on_last_word then
						-- If the last word is a branching_and with a perp branch but no parallel branch, treat this perp branch as if it was directly appended
						-- to the parallel sentence
						local branch_on_last_word = branches[#branches]
						for _, br_text in ipairs(branch_on_last_word.branching_texts) do
							if name_is_branching_and(br_text[3]) then
								local br_unitid = br_text[1][1]
								local br_unit = mmf.newObject(br_unitid)
								br_and_text_with_split_parsing[br_unitid] = nil
							end
						end

						-- We process this branch first in this case since it appends to the original parallel sentences
						table.remove(branches, #branches)
						table.insert(branches, 1, branch_on_last_word)
					end
					done = true
				end
			end
		end
	end
	-- @End Phase 1
	
	--MF_alert(tostring(step) .. ", " .. tostring(totalvariants))
	
	if (totalvariants >= limiter) then
		MF_alert("Level destroyed - too many variants C")
		destroylevel("toocomplex")
		return nil
	end
	
	if (#branches == 0 and not br_calling_calculatesentences_branch) then
		if (verbfound == false) or (step < 3) or (objfound == false) then
			return {},{},0,0,{},firstwords,{},{}
		end
	end
	
	maxpos = step
	
	local combostep = 0
	
	-- @Phase 2 - Go through array of slots and extract every word permutation as a sentence. This takes into account stacked text and outputs all possible sentences with the stacked text
	for i=1,totalvariants do
		step = 1
		sentences[i] = {}
		sentence_ids[i] = ""
		
		while (step < maxpos) do
			local c = combo[step]
			
			if (c ~= nil) then
				if (c > 0) then
					local s = sents[step]
					local word = s[c]
					
					local w = word[2]
					
					--MF_alert(tostring(i) .. ", step " .. tostring(step) .. ": " .. word[3] .. ", " .. tostring(#word[1]) .. ", " .. tostring(w))
					local text_name = parse_branching_text(word[3])
					if text_name == "and" then
						text_name = word[3]
					end
					table.insert(sentences[i], {text_name, word[4], word[1], word[2]})
					sentence_ids[i] = sentence_ids[i] .. tostring(c - 1)
					
					step = step + w
				else
					break
				end
			else
				MF_alert("c is nil, " .. tostring(step))
				break
			end
		end
		
		if (#combospots > 0) then
			combostep = 0
			
			local targetstep = combospots[combostep + 1]
			
			combo[targetstep] = combo[targetstep] + 1
			
			while (combo[targetstep] > variantshere[targetstep]) do
				combo[targetstep] = 1
				
				combostep = (combostep + 1) % #combospots
				
				targetstep = combospots[combostep + 1]
				
				combo[targetstep] = combo[targetstep] + 1
			end
		end
	end
	-- @End Phase 2

	-- br_per_sentence_data.branching_sentence_start_index = #sentences -- Record the starting index in the table "sentences" where branching sentences start

	-- local merged_sentences = {} 
	-- local merged_sentence_ids = {} 
	-- local merged_totalvariants = 0
	local merged_sentences, merged_sentence_ids, merged_totalvariants, merged_maxpos, merged_br_and_text_with_split_parsing, br_sentence_metadata = br_process_branches(branches, br_dir, found_branch_on_last_word, limiter)

	if merged_sentences == nil then
		-- Oh no! A too complex!
		return nil
	end
	plasma_utils.debug_assert(#merged_sentences == merged_totalvariants, "#merged_sentences: "..tostring(#merged_sentences).. " != merged_totalvariants:"..tostring(merged_totalvariants))
	plasma_utils.debug_assert(#merged_sentence_ids == merged_totalvariants, "#merged_sentence_ids: "..tostring(#merged_sentence_ids).. " != merged_totalvariants:"..tostring(merged_totalvariants))

	if found_branch_on_last_word and #merged_sentences > 0 then
		sentences = {}
		finals = {}
		sentence_ids = {}
		if merged_totalvariants > 0 then
			totalvariants = merged_totalvariants
		end
		maxpos = merged_maxpos
	else
		if merged_totalvariants > 0 then
			totalvariants = totalvariants + merged_totalvariants
		end
		maxpos = math.max(maxpos, merged_maxpos)
	end
		
	if (totalvariants >= limiter) then
		MF_alert("Level destroyed - too many variants F")
		destroylevel("toocomplex")
		return nil
	end

	local sentence_metadata = {}
	for _, sentence in ipairs(sentences) do
		local branching_points_bitfield = {}
		for _, word in ipairs(sentence) do
			table.insert(branching_points_bitfield, false) -- @TODO: this might be used for fixing something related to pivot text. Look into this
		end
		-- @TODO: this metadata might be useful for getting sentence elimination to work post 420d
		table.insert(sentence_metadata, {
			branching_points_bitfield = branching_points_bitfield
		})
	end
	for _, metadata in ipairs(br_sentence_metadata) do
		table.insert(sentence_metadata, metadata)
	end

	for _, merged_sent in ipairs(merged_sentences) do
		table.insert(sentences, merged_sent)
		table.insert(finals, {})
	end
	for _, merged_sent_id in ipairs(merged_sentence_ids) do
		table.insert(sentence_ids, merged_sent_id)
	end
	for unitid, _ in pairs(merged_br_and_text_with_split_parsing) do
		br_and_text_with_split_parsing[unitid] = true
	end
	
	--[[
	MF_alert(tostring(totalvariants) .. ", " .. tostring(#sentences))
	for i,v in ipairs(sentences) do
		local text = ""
		
		for a,b in ipairs(v) do
			text = text .. b[1] .. " "
		end
		
		MF_alert(text)
	end
	]]--
	
	return sentences,finals,maxpos,totalvariants,sentence_ids,firstwords,br_and_text_with_split_parsing, sentence_metadata
end

function is_str_special_prefix(str) return (str == "text_") or (str == "glyph_") end

function docode(firstwords)
	--[[ 
		@mods(omni text) - Override reason: main implementation of omni text + calculate
			sentences. Mainly prevents sentence duplication from branching ands, along with other things
		@mods(filler text) - Override reason: main implementation of filler text. Literally skip over 
			parsing when detected text type of 11
	 ]]
	local donefirstwords = {}
	local existingfinals = {}
	local limiter = 0

	--[[ @omni-text no_firstword_br_text: 
		A list of omni texts that should not, in any circumstances, be processed as a firstword, starting from the moment it was recorded
		in this table. There are two main cases where an omni text gets inserted:
			Case 1: if the current firstword is an omni text. 
				- once an omni text has been processed as a firstword, it cannot be processed as a firstword again (regardless of parsing direction)
			Case 2: If the omni text has proven to be part of a valid sentence
				- This is a more complex reason that deals with the nature of split parsing. More details are explained in the next comment
	 ]]
	local no_firstword_br_text = {}

	--[[ @omni-text Deferred Firstwords:
		This table mostly leverages no_firstword_br_text to do the actual dup sentence cancellation. However, its main function is to defer processing any
		firstwords that are also omni texts. Any deferred firstwords will be readded to the firstword queue (the variable is just called "firstwords" but I'll
		refer it as a queue) once the queue is empty.

		Why do we need this table? It mainly has to do with Case 2 for adding to no_firstword_br_text. Imagine you have this text layout:
			
			baba omni_on keke is you
				   me
				   is
				  push 

		The two initial firstwords will be "baba" parsed horizontally and "omni_on" parsed vertically. Without deferred_firstwords, if "omni_on" gets processed 
		first, it will bypass the omni_on to get "keke is you" and "me is push". Then "baba" is processed as a firstword to get "baba on keke is you" and
		"baba on me is push". 
		
		So you get four sentences, but doesn't it feel weird that it spits out "keke is you" and "me is push"? 
		In comparison, if you had "baba on keke is you", you wouldn't expect it to be parsed as both "baba on keke is you" and "keke is you". deferred_firstwords deals with a similar issue for omni text.

		Although we cannot fully control which firstwords should be processed first (unless you want to port most of the parsing code just for this purpose),
		we could still control which would be processed *last*. In the above example, if we defer processing of the "omni_on" firstword and let the "baba" firstword
		process, by Case 2 "omni_on" will be added to no_firstword_br_text. Then when we try to process the deferred "omni_on" firstword, it will be stopped
		since no_firstword_br_text has it. Therefore we removed a duplicated sentence.
	 ]]
	local deferred_firstwords = {}

	--[[ 
		While no_firstword_br_text and deferred_firstwords deal with dup sentence cancellation on the front end (through firstwords), these variables deal with it
		on the tail end. Consider this example:

			baba is you omni_and lonely
						    push

		Now "lonely" isn't in correct syntax, but the parser works by extracting consecutive texts and seperating each combination into their own array. THEN afterwards
		it runs each sentence through the syntax checker. Omni text works similar, but it extracts it by split parsing. So the above example gets split into:

			baba is you and lonely -> baba is you
			baba is you and push -> baba is you and push

		One thing to note is that syntax checker is designed to extract valid sub sentences within junk text. So a text layout like "push push baba is you push push"
		will still yield "baba is you", discarding the "push"es as junk text. With this in mind, the sentence to the right of the arrows shows the sentence after
		running through the syntax checker.

		See the problem? It's weird for the single "baba is you" to be parsed from the text layout. It's similar to the problem presented in the previous comment, but
		this time its on the tail end of the sentence. We can't actively prevent the "baba is you and lonely" from being run through the syntax checker. 
		But we CAN eliminate it AFTER the syntax checker.

		The basic idea is to remove extra texts from the end of an "incomplete" sentence until we detect a "dangling and". A dangling and is simply an "and" at the end of a sentence. 
		We detect dangling and's specifically because if you want to extend a "complete" sentence, you have to start by adding "and" first. This code
		keeps track of any dangling and sentences with the key of calculatesentences id + lhs sentid before last omni "and". But the protocol is this:
			- If a "full sentence" (sentence without dangling and) has calculatesentences id + lhs sentid combo, the slot with that id combo will be labeled as "disabled"
				- if the slot already has a dangling and sentence, delete the dangling and sentence and override the slot to be disabled
			- If a dangling and sentence tries to add itself to a slot that's disabled OR occupied, remove the sentence
		This protocol tries to account for the tree-like parsing that occurs in omni text
	 ]]
	local deferred_dang_and_addoptions = {}
	local branch_elimination_tracker = {} -- calculateSentID -> { LHS Sent id -> (-1 = disabled | dang_sent_id)}
	local calc_sent_id = 0 -- Id representing each call to calculatesentences()
	local curr_dang_and_sent_id = 0  -- Id representing each dangling and sentence that was parsed
	
	if (#firstwords > 0) then
		for k,unitdata in ipairs(firstwords) do
			if (type(unitdata[1]) == "number") then
				timedmessage("Old rule format detected. Please replace modified .lua files to ensure functionality.")
			end

			local unitids = unitdata[1]
			local unitid = unitids[1]
			local dir = unitdata[2]
			local width = unitdata[3]
			local word = unitdata[4]
			local wtype = unitdata[5]
			local existing = unitdata[6] or {}
			local existing_wordid = unitdata[7] or 1
			local existing_id = unitdata[8] or ""
			local existing_br_and_text_with_split_parsing = unitdata[9] or {}
			local existing_br_sentence_metadata = unitdata[10] or {}
			local is_deferred_sentence = unitdata[50] or false -- @TODO: uggh I hate having to set an arbitrary index for this
			local curr_calc_sent_id = unitdata[11] or calc_sent_id

			if BRANCHING_TEXT_LOGGING then
				print("-- next firstword --")
			end

			if (string.sub(word, 1, 5) == "text_") then
				word = string.sub(word, 6)
			end
			
			local unit = mmf.newObject(unitid)
			local x,y = unit.values[XPOS],unit.values[YPOS]
			local tileid_id = x + y * roomsizex
			local unique_id = tostring(tileid_id) .. "_" .. existing_id

			if name_is_branching_text(unit.strings[NAME], true, false) then
				existing_id = convert_to_old_sent_id(existing_id)
				unique_id = tostring(tileid_id) .. "_" .. existing_id
			end
			
			--MF_alert("Testing " .. word .. ": " .. tostring(donefirstwords[unique_id]) .. ", " .. tostring(dir) .. ", " .. tostring(unitid) .. ", " .. tostring(unique_id))
			
			limiter = limiter + 1
			
			if (limiter > 5000) then
				MF_alert("Level destroyed - firstwords run too many times")
				destroylevel("toocomplex")
				return
			end
			
			--[[
			MF_alert("Current unique id: " .. tostring(unique_id))
			
			if (donefirstwords[unique_id] ~= nil) and (donefirstwords[unique_id][dir] ~= nil) then
				MF_alert("Already used: " .. tostring(unitid) .. ", " .. tostring(unique_id))
			end
			]]--
			if BRANCHING_TEXT_LOGGING then 
				print("firstword: "..unit.strings[NAME].." | word index: "..existing_wordid.." | deferred: "..tostring(is_deferred_sentence).. " | Sentence Id: "..unique_id .. " | dir: ".. tostring(dir))
			end
			
			local deferred = false
			if name_is_branching_text(unit.strings[NAME], true, false) and not is_deferred_sentence then
				deferred = true
				unitdata[50] = true
				if BRANCHING_TEXT_LOGGING then 
					print("Deferred firstword!! Word: "..unit.strings[NAME])
				end
				table.insert(deferred_firstwords, unitdata)
			else
				if existing_br_sentence_metadata.branching_points_bitfield then
					if existing_br_sentence_metadata.branching_points_bitfield[existing_wordid] then
						dir = get_perp_direction(dir)
					end
				end
	
				if name_is_branching_text(unit.strings[NAME], true, false) then
					existing_id = convert_to_old_sent_id(existing_id)
					unique_id = tostring(tileid_id) .. "_" .. existing_id
				end

				if BRANCHING_TEXT_LOGGING then 
					if not ((donefirstwords[unique_id] == nil) or ((donefirstwords[unique_id] ~= nil) and (donefirstwords[unique_id][dir] == nil))) then
						print("sent id cancellation!! Unique id: "..unique_id.. " x:"..x.." y:"..y.." dir:"..dir.." Word: "..unit.strings[NAME])
						for _, v in ipairs(existing) do
							print(v[1])
						end	
					end
					if no_firstword_br_text[unitid] then
						print("no_firstword_br_text!! Word: "..unit.strings[NAME])
					end
				end
			end
			
			if (not deferred and not no_firstword_br_text[unitid]) and ((donefirstwords[unique_id] == nil) or ((donefirstwords[unique_id] ~= nil) and (donefirstwords[unique_id][dir] == nil)) and (limiter < 5000)) then
				local ox,oy = 0,0
				local name = word

				local drs = dirs[dir]
				ox = drs[1]
				oy = drs[2]
				
				if (donefirstwords[unique_id] == nil) then
					donefirstwords[unique_id] = {}
				end
				
				donefirstwords[unique_id][dir] = 1
				if name_is_branching_text(name, true, false) then
					no_firstword_br_text[unitid] = true
				end
								
				local sentences = {}
				local finals = {}
				local maxlen = 0
				local variations = 1
				local sent_ids = {}
				local newfirstwords = {}
				local br_and_text_with_split_parsing = {}
				local br_sentence_metadata = {}

				local sents_that_might_be_removed = {}
				local and_index = 0
				local and_unitid_to_index = {}

				if (#existing == 0) then
					sentences,finals,maxlen,variations,sent_ids,newfirstwords,br_and_text_with_split_parsing,br_sentence_metadata = calculatesentences(unitid,x,y,dir)

					-- @mods(omni text)This is here to handle a too complex situation. The same code is further below just to mostly 
					-- match the main game code
					if (sentences == nil) then
						return
					end

					curr_calc_sent_id = calc_sent_id
					calc_sent_id = calc_sent_id + 1

					if BRANCHING_TEXT_LOGGING then 
						print("==== "..dir.." variations: "..variations)
					end
					for i, sent in ipairs(sentences) do
						if BRANCHING_TEXT_LOGGING then 
							print("---")
							print("sent id:"..sent_ids[i])
							for _, word in ipairs(sent) do
								print(word[1])
							end
						end
						
						--[[ 
							@omni-text: this deals with the optimization introduced in 421d where calculatesentences() skips texts that would "obviously" not start a sentence.
							(Ex: "push", "facing" and "has" cannot start a sentence.) The optimization would've skipped the omni text, preventing it from being counted as
							a firstword and and its sentence deferred (see the purpose of variables deferred_firstwords and no_firstword_br_text). To solve this, 
							calculatesentences() was modified so that it doesn't skip omni texts, even though it would be counted as an "obvious" text that would not start a sentence.
							calculatesentences() would then output sentences that start with omni texts at the beginning, if found. When that happens, we defer the overall sentence.
							]]
						local word = sent[1]
						local start_word_unitid = word[3][1]
						local u = mmf.newObject(start_word_unitid)
						if start_word_unitid ~= unitid and name_is_branching_text(u.strings[NAME], true, false) then
							local deferred_firstword = {word[3], dir, word[4], word[1], word[2], sent, 1, sent_ids[i], br_and_text_with_split_parsing, br_sentence_metadata[i], curr_calc_sent_id}
							deferred_firstword[50] = true
							table.insert(deferred_firstwords, deferred_firstword)

							if BRANCHING_TEXT_LOGGING then 
								print("deferred above sentence from calc sentences")
							end

							sentences[i] = {}
						end
					end
					plasma_utils.debug_assert(#sentences == variations, "#sentences: "..tostring(#sentences).." != totalvariations: "..tostring(variations))
				else
					sentences[1] = existing
					maxlen = 3
					finals[1] = {}
					sent_ids = {existing_id}
					br_and_text_with_split_parsing = existing_br_and_text_with_split_parsing --@TODO: do we still need this?
					br_sentence_metadata = existing_br_sentence_metadata

					if BRANCHING_TEXT_LOGGING then 
						print("---existing- dir: "..dir.." sent id:".. existing_id)
						for _, word in ipairs(existing) do
							print(word[1])
						end
					end
				end				

				if (sentences == nil) then
					return
				end

				if (#newfirstwords > 0) then
					for i,v in ipairs(newfirstwords) do
						table.insert(firstwords, v)
					end
				end

				local finals_with_dangling_ands = {} -- list of indexes in finals with dangling branching ands
				
				--[[
				-- BIG DEBUG MESS
				if (variations > 0) then
					for i=1,variations do
						local dsent = ""
						local currsent = sentences[i]
						
						for a,b in ipairs(currsent) do
							dsent = dsent .. b[1] .. " "
						end
						
						MF_alert(tostring(k) .. ": Variant " .. tostring(i) .. ": " .. dsent)
					end
				end
				]]--
				
				if (maxlen > 2) then
					for i=1,variations do
						local current = finals[i]
						local letterword = ""
						local stage = 0
						local prevstage = 0
						local tileids = {}
						
						local notids = {}
						local notwidth = 0
						local notslot = 0
						
						local stage3reached = false
						local stage2reached = false
						local doingcond = false
						local nocondsafterthis = false
						local condsafeand = false
						
						local firstrealword = false
						local letterword_prevstage = 0
						local letterword_firstid = 0
						
						local currtiletype = 0
						local prevtiletype = 0
						
						local prevsafewordid = 0
						local prevsafewordtype = 0
						
						local stop = false
						
						local prefix = "" --How many "text_"s are being used.
						local tryasnoun = 0 --Which id we're going to use as type 0
						local gottagoback = false --True if we need to restart parsing

						local sent = sentences[i]
						local sent_id = sent_ids[i]
						
						local thissent = ""
						
						local j = 0
						local last_branching_and_wordid = existing_wordid
						local do_branching_and_sentence_elimination = false
						for wordid=existing_wordid,#sent do
							j = j + 1
						
							local s = sent[wordid]
							local nexts = sent[wordid + 1] or {-1, -1, {-1}, 1}
							
							prevtiletype = currtiletype
							
							local tilename = s[1]
							local tiletype = s[2]
							local tileid = s[3][1]
							local tilewidth = s[4]
							
							local wordtile = false
							
							currtiletype = tiletype
							
							thissent = thissent .. tilename .. "," .. tostring(wordid) .. "  "
							
							for a,b in ipairs(s[3]) do
								table.insert(tileids, b)
							end
							
							--[[
								0 = objekti
								1 = verbi
								2 = quality
								3 = alkusana (LONELY)
								4 = Not/Text_
								5 = letter
								6 = And
								7 = ehtosana
								8 = customobject
							]]--
							
							if tiletype == 4 and (is_str_special_prefix(tilename)) and tryasnoun ~= wordid then --text_ logic starts here
								if tryasnoun == 0 then --If this is the first
									if wordid + 1 <= #sent then
										if stage ~= 3 and not stage2reached then --False after infix conditions and verbs
											local phase = 0
											for fwordid=wordid + 1,#sent do --Now we start looking into the future
												if (sent[fwordid][2] ~= 4 or not is_str_special_prefix(sent[fwordid][1])) or (phase == 1 and is_str_special_prefix(sent[fwordid][1])) then --If this isn't a text_, unless we already encountered a noun.
													if phase == 0 then --Move onto next phase if this is the first time
														phase = 1
													elseif (sent[fwordid][2] ~= 1 and sent[fwordid][2] ~= 6 and sent[fwordid][2] ~= 7 and sent[fwordid][2] ~= 4 and sent[fwordid][2] ~= pf_filler_text_type) then --Checks if this won't parse
                            							phase = 0
														break
													elseif sent[fwordid][2] ~= 4 then --stop if we know it will parse
														prefix = tilename .. prefix
                            							phase = 0
														break
													end
												elseif phase == 0 then --If we ran into a text_ first, we're gonna try it as a noun
													tryasnoun = fwordid
												end
											end
										if phase == 1 then
											prefix = tilename .. prefix
										elseif tryasnoun ~= 0 and prefix == "" then
												phase = 0
												for fwordid=wordid + 1,#sent do
													if (sent[fwordid][2] ~= 4 or not is_str_special_prefix(sent[fwordid][1])) or (phase == 1 and is_str_special_prefix(sent[fwordid][1])) or (tryasnoun == fwordid) then
														if phase == 0 then
															phase = 1
														elseif (sent[fwordid][2] ~= 1 and sent[fwordid][2] ~= 6 and sent[fwordid][2] ~= 7) then
															tiletype = 9
															break
														else
															prefix = tilename .. prefix
															break
														end
													end
												end
											else
												if prefix == "" then
													tiletype = 9
												end
												tryasnoun = 0
											end
										else
											for fwordid=wordid + 1,#sent do
												if (sent[fwordid][2] ~= 4 or not is_str_special_prefix(sent[fwordid][1])) then
													gottagoback = true
													prefix = tilename .. prefix
													break
												elseif fwordid == #sent then
													prefix = tilename .. prefix
													tryasnoun = fwordid
													break
												end
											end
										end
									end
								else
									prefix = tilename .. prefix --stack
								end
							elseif prefix ~= "" then --Parse this word as a noun
								tiletype = 0
								currtiletype = 0
								tryasnoun = 0

								-- @mods(metatext x plasma) - If "text_" is involved, make sure that the word to be text_'ed is interpreted literally
								local tileobj = mmf.newObject(tileid)
								tilename = tileobj.strings[NAME]

								if objectlist[prefix .. tilename] == nil and objectpalette[prefix .. tilename] ~= nil then
									objectlist[prefix .. tilename] = 1
								end
								prefix = ""
							end
							-- @filler text
							if (tiletype == pf_filler_text_type) then
								stop = false
							else
							if (tiletype ~= 5) then
								if (stage == 0) then
									if (tiletype == 0) then
										prevstage = stage
										stage = 2
									elseif (tiletype == 3) then
										prevstage = stage
										stage = 1
									elseif (tiletype ~= 4) then
										prevstage = stage
										stage = -1
										stop = true
									end
								elseif (stage == 1) then
									if (tiletype == 0) then
										prevstage = stage
										stage = 2
									elseif (tiletype == 6) then
										prevstage = stage
										stage = 6
									elseif (tiletype ~= 4) then
										prevstage = stage
										stage = -1
										stop = true
									end
								elseif (stage == 2) then
									if (wordid ~= #sent) then
										if (tiletype == 1) and (prevtiletype ~= 4) and ((prevstage ~= 4) or doingcond or (stage3reached == false)) then
											stage2reached = true
											doingcond = false
											prevstage = stage
											nocondsafterthis = true
											stage = 3
										elseif (tiletype == 7) and (stage2reached == false) and (nocondsafterthis == false) and ((doingcond == false) or (prevstage ~= 4)) then
											doingcond = true
											prevstage = stage
											stage = 3
										elseif (tiletype == 6) and (prevtiletype ~= 4) then
											prevstage = stage
											stage = 4
										elseif (tiletype ~= 4) then
											prevstage = stage
											stage = -1
											stop = true
										end
									else
										stage = -1
										stop = true
									end
								elseif (stage == 3) then
									stage3reached = true
									
									if (tiletype == 0) or (tiletype == 2) or (tiletype == 8) then
										prevstage = stage
										stage = 5
									elseif (tiletype ~= 4) then
										stage = -1
										stop = true
									end
								elseif (stage == 4) then
									if (wordid <= #sent) then
										if (tiletype == 0) or ((tiletype == 2) and stage3reached) or ((tiletype == 8) and stage3reached) then
											prevstage = stage
											stage = 2
										elseif ((tiletype == 1) and stage3reached) and (doingcond == false) and (prevtiletype ~= 4) then
											stage2reached = true
											nocondsafterthis = true
											prevstage = stage
											stage = 3
										elseif (tiletype == 7) and (nocondsafterthis == false) and ((prevtiletype ~= 6) or ((prevtiletype == 6) and doingcond)) then
											doingcond = true
											stage2reached = true
											prevstage = stage
											stage = 3
										elseif (tiletype ~= 4) then
											prevstage = stage
											stage = -1
											stop = true
										end
									else
										stage = -1
										stop = true
									end
								elseif (stage == 5) then
									if (wordid ~= #sent) then
										if (tiletype == 1) and doingcond and (prevtiletype ~= 4) then
											stage2reached = true
											doingcond = false
											prevstage = stage
											nocondsafterthis = true
											stage = 3
										elseif (tiletype == 6) and (prevtiletype ~= 4) then
											prevstage = stage
											stage = 4
										elseif (tiletype ~= 4) then
											prevstage = stage
											stage = -1
											stop = true
										end
									else
										stage = -1
										stop = true
									end
								elseif (stage == 6) then
									if (tiletype == 3) then
										prevstage = stage
										stage = 1
									elseif (tiletype ~= 4) then
										prevstage = stage
										stage = -1
										stop = true
									end
								end
							end
							end
							
							if stage3reached and not stop and name_is_branching_and(tilename, true, false) then
								local br_and_unit = mmf.newObject(tileid)
								if br_and_text_with_split_parsing[tileid] then
									do_branching_and_sentence_elimination = true
									last_branching_and_wordid = wordid
								end
							end
							
							if (stage > 0) then
								firstrealword = true
							end
							
							if (tiletype == 4) then
								if (#notids == 0) or (prevtiletype == 0) then
									notids = s[3]
									notwidth = tilewidth
									notslot = wordid
								end
							else
								if (stop == false) and (tiletype ~= 0) and (tiletype ~= pf_filler_text_type) then
									notids = {}
									notwidth = 0
									notslot = 0
								end
							end
							
							if (prevtiletype ~= 4 and prevtiletype ~= pf_filler_text_type) and (wordid > existing_wordid) then
								prevsafewordid = wordid - 1
								prevsafewordtype = prevtiletype
							end
							
							if (prevtiletype == 4) and (tiletype == 6) then
								stop = true
								stage = -1
							end
							
							--MF_alert(tilename .. ", " .. tostring(wordid) .. ", " .. tostring(stage) .. ", " .. tostring(#sent) .. ", " .. tostring(tiletype) .. ", " .. tostring(prevtiletype) .. ", " .. tostring(stop) .. ", " .. name .. ", " .. tostring(i))
							
							--MF_alert(tostring(k) .. "_" .. tostring(i) .. "_" .. tostring(wordid) .. ": " .. tilename .. ", " .. tostring(tiletype) .. ", " .. tostring(stop) .. ", " .. tostring(stage) .. ", " .. tostring(letterword_firstid).. ", " .. tostring(prevtiletype))
							
							if (stop == false) then
								local subsent_id = string.sub(sent_id, (wordid - existing_wordid)+1)
								current.sent = sent
								table.insert(current, {tilename, tiletype, tileids, tilewidth, wordid, subsent_id})
								tileids = {}
								
								if (wordid == #sent) and (#current >= 3) and (j > 1) then
									subsent_id = tostring(tileid_id) .. "_" .. string.sub(sent_id, 1, j) .. "_" .. tostring(dir)
									--MF_alert("Checking finals: " .. subsent_id .. ", " .. tostring(existingfinals[subsent_id]))
									if (existingfinals[subsent_id] == nil) then
										existingfinals[subsent_id] = 1
									else
										finals[i] = {}
									end
								end
							else
								for a=1,#s[3] do
									if (#tileids > 0) then
										table.remove(tileids, #tileids)
									end
								end
								
								if (tiletype == 0) and (prevtiletype == 0) and (#notids > 0) and not gottagoback then
									notids = {}
									notwidth = 0
								end
								
								if (#current >= 3) and (j > 1) then
									local subsent_id = tostring(tileid_id) .. "_" .. string.sub(sent_id, 1, j-1) .. "_" .. tostring(dir)
									--MF_alert("Checking finals: " .. subsent_id .. ", " .. tostring(existingfinals[subsent_id]))
									if (existingfinals[subsent_id] == nil) then
										existingfinals[subsent_id] = 1
									else
										finals[i] = {}
									end
								end
								
								if (wordid < #sent) then
									if (wordid > existing_wordid) then
										if (#notids > 0) and firstrealword and (notslot > 1) and ((tiletype ~= 7) or ((tiletype == 7) and (prevtiletype == 0))) and ((tiletype ~= 1) or ((tiletype == 1) and (prevtiletype == 0))) then
											-- MF_alert(tostring(notslot) .. ", not -> A, " .. unique_id .. ", " .. sent_id)
											local subsent_id = string.sub(sent_id, (notslot - existing_wordid)+1)
											table.insert(firstwords, {notids, dir, notwidth, "not", 4, sent, notslot, subsent_id, br_and_text_with_split_parsing, br_sentence_metadata[i], curr_calc_sent_id})
											
											if (nexts[2] ~= nil) and ((nexts[2] == 0) or (nexts[2] == 3) or (nexts[2] == 4)) and (tiletype ~= 3) then
												-- MF_alert(tostring(wordid) .. ", " .. tilename .. " -> B, " .. unique_id .. ", " .. sent_id)
												subsent_id = string.sub(sent_id, j)
												table.insert(firstwords, {s[3], dir, tilewidth, tilename, tiletype, sent, wordid, subsent_id, br_and_text_with_split_parsing, br_sentence_metadata[i], curr_calc_sent_id})
											end
										else
											if (prevtiletype == 0) and ((tiletype == 1) or (tiletype == 7)) then
												-- MF_alert(tostring(wordid-1) .. ", " .. sent[wordid - 1][1] .. " -> C, " .. unique_id .. ", " .. sent_id)
												local subsent_id = string.sub(sent_id, wordid - existing_wordid)
												table.insert(firstwords, {sent[wordid - 1][3], dir, tilewidth, tilename, tiletype, sent, wordid-1, subsent_id, br_and_text_with_split_parsing, br_sentence_metadata[i], curr_calc_sent_id})
											elseif (prevsafewordtype == 0) and (prevsafewordid > 0) and (prevtiletype == 4) and (tiletype ~= 1) and (tiletype ~= 2) then
												-- MF_alert(tostring(prevsafewordid) .. ", " .. sent[prevsafewordid][1] .. " -> D, " .. unique_id .. ", " .. sent_id)
												local subsent_id = string.sub(sent_id, (prevsafewordid - existing_wordid)+1)
												table.insert(firstwords, {sent[prevsafewordid][3], dir, tilewidth, tilename, tiletype, sent, prevsafewordid, subsent_id, br_and_text_with_split_parsing, br_sentence_metadata[i], curr_calc_sent_id})
											elseif (prevsafewordtype == 0) and (prevsafewordid > 0) and (prevtiletype == pf_filler_text_type) and ((tiletype == 1) or (tiletype == 7)) then
												-- MF_alert(tostring(prevsafewordid) .. ", " .. sent[prevsafewordid][1] .. " -> D, " .. unique_id .. ", " .. sent_id)
												local subsent_id = string.sub(sent_id, (prevsafewordid - existing_wordid)+1)
												table.insert(firstwords, {sent[prevsafewordid][3], dir, tilewidth, tilename, tiletype, sent, prevsafewordid, subsent_id, br_and_text_with_split_parsing, br_sentence_metadata[i], curr_calc_sent_id})
											else
												-- MF_alert(tostring(wordid) .. ", " .. tilename .. " -> E, " .. unique_id .. ", " .. sent_id)
												local subsent_id = string.sub(sent_id, j)
												table.insert(firstwords, {s[3], dir, tilewidth, tilename, tiletype, sent, wordid, subsent_id, br_and_text_with_split_parsing, br_sentence_metadata[i], curr_calc_sent_id})
											end
										end
										
										break
									elseif (wordid == existing_wordid) then
										if (nexts[3][1] ~= -1) then
											-- MF_alert(tostring(wordid+1) .. ", " .. nexts[1] .. " -> F, " .. unique_id .. ", " .. sent_id)
											local subsent_id = string.sub(sent_id, j+1)
											table.insert(firstwords, {nexts[3], dir, nexts[4], nexts[1], nexts[2], sent, wordid+1, subsent_id, br_and_text_with_split_parsing, br_sentence_metadata[i], curr_calc_sent_id})
										end
										
										break
									end
								elseif gottagoback then
									gottagoback = false
									-- MF_alert(tostring(notslot) .. ", not -> A, " .. unique_id .. ", " .. sent_id)
									local subsent_id = string.sub(sent_id, (notslot - existing_wordid)+1)
									if notids[1] ~= nil then
										table.insert(firstwords, {notids, dir, notwidth, "not", 4, sent, notslot, subsent_id})
									end
								end
							end
						end

						if do_branching_and_sentence_elimination then
							local lhs_sent_id = ""
							for p = 1, existing_wordid-1 do
								lhs_sent_id = lhs_sent_id.."*"
							end
							lhs_sent_id = lhs_sent_id..string.sub(sent_id, 1, last_branching_and_wordid-existing_wordid+1)

							if BRANCHING_TEXT_LOGGING then
								print("--do_branching_and_sentence_elimination on this sentence--")
								for _, word in ipairs(current) do
									print(word[1])
								end
							end
							-- eliminate any extra verbs and nots
							for i=1,#current do
								local word = current[#current]
								local wordtype = word[2]
								local remove = false
								if wordtype == 4 or wordtype == 1 or wordtype == 7 then
									remove = true
								elseif wordtype == 2 then
									-- Special case where "baba is you and has stop" is somehow parsed fully
									-- instead of removing the "has stop" because of invalid syntax
									local prev_word = current[#current-1]
									if prev_word then
										local word_name = parse_branching_text(prev_word[1])
										print("test: "..word_name)
										if word_name ~= "is" and word_name ~= "and" and word_name ~= "not" then
											remove = true
										end
									end
								end

								if remove then
									table.remove(current, #current)
								else
									break
								end
							end

							-- If the sentence has a dangling and, then the entry for the tracker will be the index of this sentence.
							-- If the sentence is full, then the entry will be -1, indicating a disabled lhs_sent_id
							local is_dangling_and_sent = current[#current][2] == 6
							
							if not branch_elimination_tracker[curr_calc_sent_id] then
								branch_elimination_tracker[curr_calc_sent_id] = {}
							end
							if not branch_elimination_tracker[curr_calc_sent_id][lhs_sent_id] then
								-- Current slot is empty
								if is_dangling_and_sent then
									-- If dangling and sentence, add its entry to the tracker, BUT also save its ids so that
									-- we can defer processing it until after all firstwords have finished processing
									branch_elimination_tracker[curr_calc_sent_id][lhs_sent_id] = curr_dang_and_sent_id
									finals_with_dangling_ands[i] = {
										calc_sent_id = curr_calc_sent_id,
										lhs_sent_id = lhs_sent_id,
										dang_and_sent_id = curr_dang_and_sent_id,
									}
									curr_dang_and_sent_id = curr_dang_and_sent_id + 1
								else
									branch_elimination_tracker[curr_calc_sent_id][lhs_sent_id] = -1
								end
							else
								local curr_entry = branch_elimination_tracker[curr_calc_sent_id][lhs_sent_id]
								if curr_entry == -1 and is_dangling_and_sent then
									-- A full sentence with the same lhs has already been added. Remove the dangling and sentence.
									finals[i] = {}
								elseif curr_entry ~= -1 and not is_dangling_and_sent then
									-- Override the curr dangling and sent id. After processing all firstwords, the deferred dangling and
									-- sentences will look at the tracker to find that their entry has been deleted. So delete the sentence.
									branch_elimination_tracker[curr_calc_sent_id][lhs_sent_id] = -1
								end
							end
						end
					end
				end
				
				if (#finals > 0) then
					for i,sentence in ipairs(finals) do
						local group_objects = {}
						local group_targets = {}
						local group_conds = {}
						
						local group = group_objects
						local stage = 0
						
						local prefix = ""
						
						local allowedwords = {0}
						local allowedwords_extra = {}
						
						local testing = ""
						
						local extraids = {}
						local extraids_current = ""
						local extraids_ifvalid = {}
						
						local valid = true

						if (#sentence >= 3) then
							if (#finals > 1) then
								for a,b in ipairs(finals) do
									if (#b == #sentence) and (a > i) then
										local identical = true
										
										for c,d in ipairs(b) do
											local currids = d[3]
											local equivids = sentence[c][3] or {}
											
											for e,f in ipairs(currids) do
												--MF_alert(tostring(a) .. ": " .. tostring(f) .. ", " .. tostring(equivids[e]))
												if (f ~= equivids[e]) then
													identical = false
												end
											end
										end
										
										if identical then
											--MF_alert(sentence[1][1] .. ", " .. sentence[2][1] .. ", " .. sentence[3][1] .. " (" .. tostring(i) .. ") is identical to " .. b[1][1] .. ", " .. b[2][1] .. ", " .. b[3][1] .. " (" .. tostring(a) .. ")")
											valid = false
										end
									end
								end
							end
						else
							valid = false
						end
						
						if valid then
							local is_dangling_and = finals_with_dangling_ands[i] ~= nil
							local addoption_buffer = {}
							if is_dangling_and then
								table.insert(deferred_dang_and_addoptions, {
									addoption_calls = addoption_buffer,
									tracker_ids = finals_with_dangling_ands[i],
								})
							end

							for index,wdata in ipairs(sentence) do
								local wname = wdata[1]
								local wtype = wdata[2]
								local wid = wdata[3]

								-- Record all branching text that is part of a valid sentence
								for _, unitid in ipairs(wid) do
									local unit = mmf.newObject(unitid)
									if name_is_branching_text(unit.strings[NAME], true, false) and (wtype == 6 or wtype == 7 or wtype == 1) and (stage == 0 or stage == 7) then
										no_firstword_br_text[unitid] = true

										if BRANCHING_TEXT_LOGGING then
											print("Adding no_firstword_br_text: "..unit.strings[NAME])
										end
									end
								end
								
								--The Glitch override starts here.
								if checkglitchrule(wid) then
									spreadglitches(sentence)
								end
								--Glitch override ends here. (That was fast.)
								
								testing = testing .. wname .. " "
								
								local wcategory = -1
								
								if (wtype == 1) or (wtype == 3) or (wtype == 7) then
									wcategory = 1
								elseif (wtype ~= 4) and (wtype ~= 6) and (wtype ~= pf_filler_text_type) then
									wcategory = 0
								else
									table.insert(extraids_ifvalid, {prefix .. wname, wtype, wid})
									extraids_current = wname
									if is_str_special_prefix(wname) then
										extraids_current = "text_butnoun"
									end
								end
								
								if (wcategory == 0) then
									local allowed = false
									
									for a,b in ipairs(allowedwords) do
										if (b == wtype) then
											allowed = true
											break
										end
									end
									
									if (allowed == false) then
										local wname_pnoun = is_name_text_this(wname)
										for a,b in ipairs(allowedwords_extra) do
											if (wname == b) then
												allowed = true
												break
											end

											-- @mods(THIS) - need to use is_name_text_this() to account for "this" being a prefix for all pnouns
											if wname_pnoun and wname_pnoun == is_name_text_this(b) then
												allowed = true
												break
											end
										end
									end
									
									if allowed then
										table.insert(group, {prefix .. wname, wtype, wid})
									else
										local sent = sentence.sent
										local wordid = wdata[5]
										local subsent_id = wdata[6]
										table.insert(firstwords, {{wid[1]}, dir, 1, wname, wtype, sent, wordid, subsent_id, br_and_text_with_split_parsing, br_sentence_metadata[i], curr_calc_sent_id})
										break
									end
								elseif (wcategory == 1) then
									if (index < #sentence) then
										allowedwords = {0}
										allowedwords_extra = {}
										local realname = ""
										local testunit = mmf.newObject(wid[1])
										if name_is_branching_text(testunit.strings[NAME]) then
											realname = unitreference["text_"..testunit.strings[NAME]]
											if name_is_branching_text_with_special_unitreference(testunit.strings[NAME]) then
												realname = unitreference["text_"..wname]
											else
												realname = unitreference["text_"..testunit.strings[NAME]]
											end
										elseif is_turning_text(testunit.strings[NAME]) then
											realname = unitreference["text_" .. testunit.strings[NAME]]
										else
											realname = unitreference["text_" .. wname]
										end
										local cargtype = false
										local cargextra = false
										
										local argtype = {0}
										local argextra = {}
										
										if (changes[realname] ~= nil) then
											local wchanges = changes[realname]
											
											if (wchanges.argtype ~= nil) then
												argtype = wchanges.argtype
												cargtype = true
											end
											
											if (wchanges.argextra ~= nil) then
												argextra = wchanges.argextra
												cargextra = true
											end
										end
										
										if (cargtype == false) or (cargextra == false) then
											local wvalues = tileslist[realname] or {}
											
											if (cargtype == false) then
												argtype = wvalues.argtype or {0}
											end
											
											if (cargextra == false) then
												argextra = wvalues.argextra or {}
											end
										end
										
										--MF_alert(wname .. ", " .. tostring(realname) .. ", " .. "text_" .. wname)
										
										if (realname == nil) then
											MF_alert("No object found for " .. wname .. "!")
											valid = false
											break
										else
											if (wtype == 1) then
												allowedwords = argtype
												allowedwords_extra = argextra --@mods(this) - needed for special cases of pnoun parsing
												
												stage = 1
												local target = {prefix .. wname, wtype, wid}
												table.insert(group_targets, {target, {}})
												local sid = #group_targets
												group = group_targets[sid][2]
												
												newcondgroup = 1
											elseif (wtype == 3) then
												allowedwords = {0}
												allowedwords_extra = argextra
												local cond = {prefix .. wname, wtype, wid}
												table.insert(group_conds, {cond, {}})
											elseif (wtype == 7) then
												allowedwords = argtype
												allowedwords_extra = argextra
												
												stage = 2
												local cond = {prefix .. wname, wtype, wid}
												table.insert(group_conds, {cond, {}})
												local sid = #group_conds
												group = group_conds[sid][2]
											end
										end
									end
								end
								
								if (wtype == 4) then
									if is_str_special_prefix(wname) then
										prefix = prefix .. wname
									else
										if (prefix == "not ") then
											prefix = ""
										else
											prefix = "not "
										end
									end
								elseif (wtype ~= pf_filler_text_type) then
									prefix = ""
								end
								
								if (wname ~= extraids_current) and (string.len(extraids_current) > 0) and (wtype ~= 4) then
									for a,extraids_valid in ipairs(extraids_ifvalid) do
										table.insert(extraids, {prefix .. extraids_valid[1], extraids_valid[2], extraids_valid[3]})
									end
									
									extraids_ifvalid = {}
									extraids_current = ""
								end
							end
							--MF_alert("Testing: " .. testing)
							
							if generaldata.flags[LOGGING] then
								rulelog(sentence, testing)
							end
							
							local conds = {}
							local condids = {}
							for c,group_cond in ipairs(group_conds) do
								local rule_cond = group_cond[1][1]
								--table.insert(condids, group_cond[1][3])
								
								condids = copytable(condids, group_cond[1][3])
								
								table.insert(conds, {rule_cond,{}})
								local condgroup = conds[#conds][2]
								
								for e,condword in ipairs(group_cond[2]) do
									local rule_condword = condword[1]
									--table.insert(condids, condword[3])
									
									condids = copytable(condids, condword[3])
									
									table.insert(condgroup, rule_condword)
								end
							end
							
							for c,group_object in ipairs(group_objects) do
								local rule_object = group_object[1]
								
								for d,group_target in ipairs(group_targets) do
									local rule_verb = group_target[1][1]
									
									for e,target in ipairs(group_target[2]) do
										local rule_target = target[1]
										
										local finalconds = {}
										for g,finalcond in ipairs(conds) do
											table.insert(finalconds, {finalcond[1], finalcond[2]})
										end
										
										local rule = {rule_object,rule_verb,rule_target}
										
										local ids = {}
										ids = copytable(ids, group_object[3])
										ids = copytable(ids, group_target[1][3])
										ids = copytable(ids, target[3])

										pf_rule_metadata_index:register_rule(rule, group_object[3], group_target[1][3], target[3])

										for g,h in ipairs(extraids) do
											ids = copytable(ids, h[3])
										end
										
										for g,h in ipairs(condids) do
											ids = copytable(ids, h)
										end

										if is_dangling_and then
											table.insert(addoption_buffer, {rule=rule,finalconds=finalconds,ids=ids})
										else
											addoption(rule,finalconds,ids)
										end
									end
								end
							end
						end
					end
				end
			end

			-- If there are no more firstwords needed to be processed but we have deferred firstwords, add them back in
			if k == #firstwords then
				for _, deferred_firstword in ipairs(deferred_firstwords) do
					table.insert(firstwords, deferred_firstword)
				end
				deferred_firstwords = {}
			end	
		end
	end

	-- At the VERY END, go through all deferred dangling and sentences and check if the tracker still holds their dang_sent_id.
	-- If so, call addoption with the saved parameters. If not, the sentence is implicitly deleted. 
	for _, data in ipairs(deferred_dang_and_addoptions) do
		local dang_sent_id = data.tracker_ids.dang_and_sent_id
		if branch_elimination_tracker[data.tracker_ids.calc_sent_id][data.tracker_ids.lhs_sent_id] == dang_sent_id then
			for _, call in ipairs(data.addoption_calls) do
				addoption(call.rule,call.finalconds,call.ids)

				if BRANCHING_TEXT_LOGGING then
					print("Adding danging and sentence!")
				end
			end
		end
	end
end

function addoption(option,conds_,ids,visible,notrule,tags_,visualonly_)
	--[[ 
		@mods(this) - Override reason: hook for registering any pnoun rules in th_text_this.lua.
			Also, prevent a few things that addoption usually does when adding a pnoun rule. These include processing
			"not THIS is X" and displaying the rule in the pause menu.
	 ]]
	 --MF_alert(option[1] .. ", " .. option[2] .. ", " .. option[3])

	local visual = true
	local visualonly = false
	
	if (visible ~= nil) then
		visual = visible
	end
	if visualonly_ ~= nil then
		visualonly = visualonly_
		if visualonly == true and visual == false then
			return
		end
	end
	
	local conds = {}
	
	if (conds_ ~= nil) then
		conds = conds_
	else
		MF_alert("nil conditions in rule: " .. option[1] .. ", " .. option[2] .. ", " .. option[3])
	end
	local tags = tags_ or {}
	local shownrule = nil

	--[[
		@Merge(glyph x metatext): disable glyph mod's implementation of metatext. Metatext mod has the system all figured out.

		Also, the 'option[1] = "text"' causes the game to stack overflow. Metatext mod's way of treating text_text is similar to "all" where
		the rule containing "text" is expanded to all text object types (with a few exceptions). For instance if "text is push", the rule will expand to:
			- text_baba is push
			- text_is is push
			- text_you is push
			- text_push is push
			(etc)
		This causes a nested addoption() call with the above subrules that happens within the block of code that starts with:
			'if target == "text" and fullunitlist ~= nil then'
		But with the 'option[1] = "text"', the subrules change to target ALL of text instead of the specific text object
		(Eg: "text_baba is push" -> "text is push"). Therefore, it causes infinite calls to addoption().
	 ]]
	-- if (string.sub(option[1], 1, 5) == "text_") then
	-- 	shownrule = copyrule({option, conds, ids, tags})
	-- 	table.insert(conds, {"references", {" " .. string.sub(option[1], 6)}})
	-- 	option[1] = "text"
	-- else
	--[[
	if (string.sub(option[1], 1, 6) == "glyph_") then
		print(option[1], option[2], option[3])
		shownrule = copyrule({option, conds, ids, tags})
		table.insert(conds, {"references", {" " .. string.sub(option[1], 7)}})
		option[1] = "glyph"
	end
	-- if (string.sub(option[1], 1, 5) == "not text_") then
	-- 	shownrule = copyrule({option, conds, ids, tags})
	-- 	option[1] = "all"
	-- else
	if (string.sub(option[1], 1, 6) == "not glyph_") then
		shownrule = copyrule({option, conds, ids, tags})
		option[1] = "glyph"
	end
	-- if ((option[1] == "text") or (option[3] == option[1])) and (string.sub(option[3], 1, 5) == "text_") and (option[2] == "is") then
	-- 	local newconds = {}
	-- 	newconds = copyconds(newconds, conds)
	-- 	addoption({option[3], "is", "text"}, newconds,ids,false,notrule,tags_)
	-- else
	if ((option[1] == "glyph") or (option[3] == option[1])) and (string.sub(option[3], 1, 6) == "glyph_") and (option[2] == "is") then
		local newconds = {}
		newconds = copyconds(newconds, conds)
		addoption({option[3], "is", "glyph"}, newconds,ids,false,notrule,tags_)
	end

	if (option[1] == "level") and (option[2] == "become") and (option[3] == "level") then
		shownrule = copyrule({option, conds, ids, tags})
		table.insert(conds, {"never", {}})

	end
	--]]
	if (#option == 3) then

		local rule = {option,conds,ids,tags}
		local allow_add_to_featureindex, is_pnoun_target, is_pnoun_effect, is_pnoun_rule = scan_added_feature_for_pnoun_rule(rule, visual)
		if not allow_add_to_featureindex then
			return
		end

		for i, v in pairs(toreplace) do
			if option[2] == toreplace[i] then
				if tense[i] ~= "present" then
					option[2] = replacewith[i]
					table.insert(conds, { "feels" .. tense[i], {} })
					if (featureindex[replacewith[i]] == nil) then
						featureindex[replacewith[i]] = {}
					end
					table.insert(featureindex[replacewith[i]], rule)
				end
			end
		end

		if disable_text_metatext then
			option[1] = trueidentity(option[1])
			option[3] = trueidentity(option[3])
		end

		local target = option[1]
		local verb = option[2]
		local effect = option[3]

		-- EDIT: EXTREMELY HORRIBLE HACKY WAY TO IMPLEMENT AMBIENT @update: hopefully it doesn't mess w/ metatext
		if (target == "ambient") then
			target = ws_ambientObject
			option[1] = ws_ambientObject
		elseif (target == "not ambient") then
			target = "not "..ws_ambientObject
		end

		if (effect == "ambient") then
			effect = ws_ambientObject
			option[3] = ws_ambientObject
		elseif (effect == "not ambient") then
			effect = "not "..ws_ambientObject
		end

		local foundtag = false
		if metatext_fixquirks then
			for num,tag in pairs(tags) do
				if tag == "text" or (string.sub(tag,1,4) == "meta" and tag ~= "meta-1") then
					foundtag = true
					break
				end
			end
		end
		if foundtag or (metatext_hasmaketextnometa and (string.sub(target,1,5) == "text_" or string.sub(target,1,4) == "meta")) then
			if effect == "text" then
				if verb == "is" and foundtag then
					effect = target
				elseif verb == "has" or verb == "become" then
					effect = "text_text"
				elseif verb == "make" then
					visualonly = true
				end
			elseif effect == "not text" then
				if verb == "is" and foundtag then
					effect = "not " .. target
				elseif verb == "has" or verb == "become" then
					effect = "not text_text"
				elseif verb == "make" then
					visualonly = true
				end
			elseif string.sub(effect,1,5) == "group" or string.sub(effect,1,9) == "not group" then
				if (verb == "has" or verb == "make" or verb == "become") and foundtag then
					return
				end
			end
			rule = {{target,verb,effect},conds,ids,tags}
		end
		local foundtag = false
		if metatext_fixquirks then
			for num,tag in pairs(tags) do
				if tag == "glyph" then
					foundtag = true
					break
				end
			end
		end
		if foundtag then
			if effect == "glyph" then
				if verb == "is" and foundtag then
					effect = target
				elseif verb == "has" or verb == "become" then
					effect = "glyph_glyph"
				elseif verb == "make" then
					visualonly = true
				end
			elseif effect == "not glyph" then
				if verb == "is" and foundtag then
					effect = "not " .. target
				elseif verb == "has" or verb == "become" then
					effect = "not glyph_glyph"
				elseif verb == "make" then
					visualonly = true
				end
			elseif string.sub(effect,1,5) == "group" or string.sub(effect,1,9) == "not group" then
				if (verb == "has" or verb == "make" or verb == "become") and foundtag then
					return
				end
			end
			rule = {{target,verb,effect},conds,ids,tags}
		end
		if metatext_istextnometa and (effect == "text" or effect == "not text") and verb == "is" and (string.sub(target,1,5) == "text_" or string.sub(target,1,4) == "meta") then
			if effect == "text" then
				effect = target
			else
				effect = "not " .. target
			end
			rule = {{target,verb,effect},conds,ids,tags}
		elseif metatext_istextnometa and (effect == "glyph" or effect == "not glyph") and verb == "is" and (string.sub(target,1,6) == "glyph_") then
			if effect == "glyph" then
				effect = target
			else
				effect = "not " .. target
			end
			rule = {{target,verb,effect},conds,ids,tags}
		elseif ((string.sub(effect, 1, 4) == "meta") or (string.sub(effect, 1, 8) == "not meta")) and (verb == "is" or verb == "become") then
			local isnot = (string.sub(effect,1,8) == "not meta")
			local level = string.sub(effect,5)
			if isnot then
				level = string.sub(effect,9)
			end
			if tonumber(level) ~= nil and tonumber(level) >= -1 then
				local metalevel = getmetalevel(target)
				if metalevel == tonumber(level) and (findnoun(target,nlist.brief) == false and target ~= "text") then
					effect = target
					if isnot then
						effect = "not " .. target
					end
					rule = {{target,verb,effect},conds,ids,tags}
				end
			end
		end
		if not visualonly then
			table.insert(features, rule)
		end
	
		if (featureindex[effect] == nil) and not visualonly then
			featureindex[effect] = {}
		end
		
		if (featureindex[target] == nil) and not visualonly then
			featureindex[target] = {}
		end
		
		if (featureindex[verb] == nil) and not visualonly then
			featureindex[verb] = {}
		end
		
		if not visualonly then
			table.insert(featureindex[effect], rule)
			table.insert(featureindex[verb], rule)
		end
		
		if (target ~= effect) and not visualonly then
			table.insert(featureindex[target], rule)
		end
		
		if visual and not is_pnoun_rule then
			local originalrule = {option,conds,ids,tags}
			local visualrule = copyrule(originalrule)
			if (shownrule == nil) then
				table.insert(visualfeatures, visualrule)
			else
				table.insert(visualfeatures, shownrule)
			end
			if visualonly then
				return
			end
		end

		-- @mods(this) - prevent populating the featureindex with pnoun rules. Each pnoun isn't an object, but a reference to an object.
		if is_pnoun_effect then
			featureindex[effect] = {}
		end
		if is_pnoun_target then
			featureindex[target] = {}
		end
		
		local groupcond = false
		
		if (string.sub(target, 1, 5) == "group") or (string.sub(effect, 1, 5) == "group" and (verb ~= "write" or not foundtag)) or (string.sub(target, 1, 9) == "not group") or (string.sub(effect, 1, 9) == "not group") then
			groupcond = true
		end
		
		if (notrule ~= nil) then
			local notrule_effect = notrule[1]
			local notrule_id = notrule[2]
			
			if (notfeatures[notrule_effect] == nil) then
				notfeatures[notrule_effect] = {}
			end
			
			local nr_e = notfeatures[notrule_effect]
			
			if (nr_e[notrule_id] == nil) then
				nr_e[notrule_id] = {}
			end
			
			local nr_i = nr_e[notrule_id]
			
			table.insert(nr_i, rule)
		end
		
		if (#conds > 0) then
			local addedto = {}

			-- @mods(stable) - remove when confident that stablerules not having ids won't hinder get_this_parms_in_conds
			local isstable = false
			for _, tag in ipairs(tags) do
				if tag == "stable" then
					isstable = true
					break
				end
			end
			local this_params_in_conds = get_this_parms_in_conds(conds, ids)
			if isstable then
				plasma_utils.debug_assert(#this_params_in_conds == 0, "for stablerule, #this_params_in_conds == "..tostring(#this_params_in_conds))
			end
			
			for i,cond in ipairs(conds) do
				local condname = cond[1]
				if (string.sub(condname, 1, 4) == "not ") then
					condname = string.sub(condname, 5)
				end
				
				if (condfeatureindex[condname] == nil) then
					condfeatureindex[condname] = {}
				end
				
				if (addedto[condname] == nil) then
					table.insert(condfeatureindex[condname], rule)
					addedto[condname] = 1
				end
				
				if (cond[2] ~= nil and condname ~= "stable") then
					if (#cond[2] > 0) then
						local newconds = {}
						
						--alreadyused[target] = 1
						
						for a,b in ipairs(cond[2]) do
							local alreadyused = {}
							
							local this_param_name, this_param_id = parse_this_param(b)
							if this_param_name and not pf_raycast_bank:is_valid_ray_id(this_param_id) then
								local this_unitid = this_params_in_conds[cond][a]

								local is_param_this_formatted,_,_,_,this_param_id = parse_this_param_and_get_raycast_units(b)
								if not is_param_this_formatted and not pf_raycast_bank:is_valid_ray_id(this_param_id) then
									register_pnoun_in_cond(this_unitid, condname)
									local param_id = convert_this_unit_to_param_id(this_unitid)
									table.insert(newconds, make_this_param(b, param_id))
								else
									table.insert(newconds, b)
								end
							elseif (b ~= "all") and (b ~= "not all") then
								alreadyused[b] = 1
								table.insert(newconds, b)
							elseif (b == "all") then
								for a,mat in pairs(objectlist) do
									if (alreadyused[a] == nil) and (findnoun(a,nlist.short) == false) then
										table.insert(newconds, a)
										alreadyused[a] = 1
									end
								end
							elseif (b == "not all") then
								table.insert(newconds, "empty")
								table.insert(newconds, "text")
								table.insert(newconds, "glyph")
							end
							
							if (string.sub(b, 1, 5) == "group") or (string.sub(b, 1, 9) == "not group") then
								groupcond = true
							end
						end
						
						cond[2] = newconds
					end
				end
			end
		end

		-- @mods(this) - prevent any pnouns from being a "member" of a group. Pnouns aren't objects, but references to objects/
		-- This was needed because "THIS is group is group" generates the subrule "THIS is THIS", which cannot be processed since
		-- the second THIS doesn't have a unitid.
		if groupcond and not is_pnoun_target then
			table.insert(groupfeatures, rule)
		end

		local targetnot = string.sub(target, 1, 4)
		local targetnot_ = string.sub(target, 5)
		
		-- @mods(this) - odd but mininal way to prevent "not this is X" from applying X to everything but a theoretical "this" object
		if is_pnoun_rule then
			targetnot = ""
			targetnot_ = ""
		end
		
		if (targetnot == "not ") and (objectlist[targetnot_] ~= nil) and (string.sub(targetnot_, 1, 5) ~= "group") and (string.sub(effect, 1, 5) ~= "group") and (string.sub(effect, 1, 9) ~= "not group") or (((string.sub(effect, 1, 5) == "group") or (string.sub(effect, 1, 9) == "not group")) and (targetnot_ == "all")) then
			if (targetnot_ ~= "all") then
				if (string.sub(targetnot_, 1, 5) == "text_") then
					for i,mat in pairs(fullunitlist) do
						if (i ~= targetnot_) and (string.sub(i, 1, 5) == "text_") then
							local rule = {i,verb,effect}
							local newconds = {}
							for a,b in ipairs(conds) do
								table.insert(newconds, b)
							end
							addoption(rule,newconds,ids,false,{effect,#featureindex[effect]},tags)
						end
					end
				elseif (string.sub(targetnot_, 1, 6) == "glyph_") then
					for i,mat in pairs(fullunitlist) do
						if (i ~= targetnot_) and (string.sub(i, 1, 6) == "glyph_") then
							local rule = {i,verb,effect}
							local newconds = {}
							for a,b in ipairs(conds) do
								table.insert(newconds, b)
							end
							addoption(rule,newconds,ids,false,{effect,#featureindex[effect]},tags)
						end
					end
				elseif string.sub(targetnot_, 1, 4) == "meta" then
					local level = string.sub(targetnot_, 5)
					if tonumber(level) == nil then
						level = -2
					end
					local donelevel = {}
					donelevel[tonumber(level)] = 1
					if not metatext_includenoun then
						donelevel[-1] = 1
					end
					for i,mat in pairs(fullunitlist) do
						local metalevel = getmetalevel(i)
						if donelevel[metalevel] == nil and (findnoun(i,nil,true) == false) then
							donelevel[metalevel] = 1
							local rule = {"meta"..metalevel,verb,effect}
							local newconds = {}
							for a,b in ipairs(conds) do
								table.insert(newconds, b)
							end
							addoption(rule,newconds,ids,false,{effect,#featureindex[effect]},tags)
						end
					end
				else
				for i,mat in pairs(objectlist) do
					if (i ~= targetnot_) and (findnoun(i) == false) then
						local rule = {i,verb,effect}
						local newconds = {}
						for a,b in ipairs(conds) do
							table.insert(newconds, b)
						end
						addoption(rule,newconds,ids,false,{effect,#featureindex[effect]},tags)
					end
				end
				end
			else
				local mats = {"empty","text", "glyph"}
				
				for m,i in pairs(mats) do
					local rule = {i,verb,effect}
					local newconds = {}
					for a,b in ipairs(conds) do
						table.insert(newconds, b)
					end
					addoption(rule,newconds,ids,false,{effect,#featureindex[effect]},tags)
				end
			end
		end
		if target == "text" and fullunitlist ~= nil then
			for a,b in pairs(fullunitlist) do -- fullunitlist contains all units, is new
				if (string.sub(a, 1, 5) == "text_") then
					local newconds = {}
					local newtags = {}
					local stop = false

					for c,d in ipairs(conds) do
						table.insert(newconds, d)
					end

					for c,d in ipairs(tags) do
						table.insert(newtags, d)
					end

					table.insert(newtags, "text")

					local newword1 = a
					local newword2 = verb
					local newword3 = effect
					if objectlist[a] == nil then
						objectlist[a] = 1
					end
					if newword3 == "text" then
						if newword2 == "is" then
							newword3 = newword1
						elseif newword2 == "has" or newword2 == "become" then
							newword3 = "text_text"
						elseif newword2 == "make" then
							stop = true
						end
					elseif newword3 == "not text" then
						if newword2 == "is" then
							newword3 = "not " .. newword1
						elseif newword2 == "has" or newword2 == "become" then
							newword3 = "not text_text"
						elseif newword2 == "make" then
							stop = true
						end
					elseif string.sub(newword3,1,5) == "group" or string.sub(newword3,1,9) == "not group" then
						if newword2 == "become" or newword2 == "has" or newword2 == "make" then
							stop = true
						end
					end

					local newrule = {newword1, newword2, newword3}
					if not stop then
						addoption(newrule,newconds,ids,false,nil,newtags)
					end
				end
			end
			if (verb == "mimic" or verb == "perform") and (effect == "text" or string.sub(effect,1,4) == "meta") then --@mods (metatext x extrem)
				for a,b in pairs(fullunitlist) do -- fullunitlist contains all units, is new
					if (string.sub(a, 1, 5) == "text_") then
						local stop = false
						local newconds = {}
						local newtags = {}

						for c,d in ipairs(conds) do
							table.insert(newconds, d)
						end

						for c,d in ipairs(tags) do
							if d == "dontadd" then
								stop = true
								break
							end
							table.insert(newtags, d)
						end

						table.insert(newtags, "visualmimic")
						table.insert(newtags, "verbtext")

						local newword1 = target
						local newword2 = verb
						local newword3 = a

						local newrule = {newword1, newword2, newword3}
						if not stop then
							addoption(newrule,newconds,ids,false,nil,newtags)
						end
					end
				end
			end
		elseif target == "glyph" and fullunitlist ~= nil then
			for a,b in pairs(fullunitlist) do -- fullunitlist contains all units, is new
				if (string.sub(a, 1, 6) == "glyph_") then
					local newconds = {}
					local newtags = {}
					local stop = false

					for c,d in ipairs(conds) do
						table.insert(newconds, d)
					end

					for c,d in ipairs(tags) do
						table.insert(newtags, d)
					end

					table.insert(newtags, "glyph")

					local newword1 = a
					local newword2 = verb
					local newword3 = effect
					if objectlist[a] == nil then
						objectlist[a] = 1
					end
					if newword3 == "glyph" then
						if newword2 == "is" then
							newword3 = newword1
						elseif newword2 == "has" or newword2 == "become" then
							newword3 = "glyph_glyph"
						elseif newword2 == "make" then
							stop = true
						end
					elseif newword3 == "not glyph" then
						if newword2 == "is" then
							newword3 = "not " .. newword1
						elseif newword2 == "has" or newword2 == "become" then
							newword3 = "not glyph_glyph"
						elseif newword2 == "make" then
							stop = true
						end
					elseif string.sub(newword3,1,5) == "group" or string.sub(newword3,1,9) == "not group" then
						if newword2 == "become" or newword2 == "has" or newword2 == "make" then
							stop = true
						end
					end

					local newrule = {newword1, newword2, newword3}
					if not stop then
						addoption(newrule,newconds,ids,false,nil,newtags)
					end
				end
			end
			if (verb == "mimic" or verb == "perform") and (effect == "glyph") then
				for a,b in pairs(fullunitlist) do -- fullunitlist contains all units, is new
					if (string.sub(a, 1, 6) == "glyph_") then
						local stop = false
						local newconds = {}
						local newtags = {}

						for c,d in ipairs(conds) do
							table.insert(newconds, d)
						end

						for c,d in ipairs(tags) do
							if d == "dontadd" then
								stop = true
								break
							end
							table.insert(newtags, d)
						end

						table.insert(newtags, "visualmimic")
						table.insert(newtags, "verbglyph")

						local newword1 = target
						local newword2 = verb
						local newword3 = a

						local newrule = {newword1, newword2, newword3}
						if not stop then
							addoption(newrule,newconds,ids,false,nil,newtags)
						end
					end
				end
			end
		elseif string.sub(target,1,4) == "meta" and fullunitlist ~= nil then
			local level = string.sub(target,5)
			if tonumber(level) ~= nil and tonumber(level) >= -1 then
				for a,b in pairs(fullunitlist) do -- fullunitlist contains all units, is new
					local metalevel = getmetalevel(a)
					if metalevel == tonumber(level) and (findnoun(a,nil,true) == false) then
						local newconds = {}
						local newtags = {}
						local stop = false

						for c,d in ipairs(conds) do
							table.insert(newconds, d)
						end

						for c,d in ipairs(tags) do
							table.insert(newtags, d)
						end

						table.insert(newtags, target)

						local newword1 = a
						local newword2 = verb
						local newword3 = effect
						if newword3 == "text" and metalevel >= 0 then
							if newword2 == "is" then
								newword3 = newword1
							elseif newword2 == "has" or newword2 == "become" then
								newword3 = "text_text"
							elseif newword2 == "make" then
								stop = true
							end
						elseif newword3 == "not text" and metalevel >= 0 then
							if newword2 == "is" then
								newword3 = "not " .. newword1
							elseif newword2 == "has" or newword2 == "become" then
								newword3 = "not text_text"
							elseif newword2 == "make" then
								stop = true
							end
						elseif newword3 == target then
							if newword2 == "is" or newword2 == "become" or newword2 == "has" then
								newword3 = newword1
							elseif newword2 == "make" then
								stop = true
							end
						elseif newword3 == "not " .. target then
							if newword2 == "is" or newword2 == "become" or newword2 == "has" then
								newword3 = "not " .. newword1
							elseif newword2 == "make" then
								stop = true
							end
						elseif string.sub(newword3,1,5) == "group" or string.sub(newword3,1,9) == "not group" then
							if newword2 == "become" or newword2 == "has" or newword2 == "make" then
								stop = true
							end
						end

						local newrule = {newword1, newword2, newword3}
						if not stop then
							addoption(newrule,newconds,ids,false,nil,newtags)
						end
					end
				end
			end
			if (verb == "mimic" or verb == "perform") and (effect == "text" or string.sub(effect,1,4) == "meta") then
				if tonumber(level) ~= nil and tonumber(level) >= -1 then
					for a,b in pairs(fullunitlist) do -- fullunitlist contains all units, is new
						local metalevel = getmetalevel(a)
						if metalevel == tonumber(level) and (findnoun(a,nil,true) == false) then
							local newconds = {}
							local newtags = {}
							local stop = false

							for c,d in ipairs(conds) do
								table.insert(newconds, d)
							end

							for c,d in ipairs(tags) do
								if d == "dontadd" then
									stop = true
									break
								end
								table.insert(newtags, d)
							end

							table.insert(newtags, "visualmimic")
							table.insert(newtags, "verbtext")
							table.insert(newtags, "verbmeta" .. level)

							local newword1 = target
							local newword2 = verb
							local newword3 = a

							local newrule = {newword1, newword2, newword3}
							if not stop then
								addoption(newrule,newconds,ids,false,nil,newtags)
							end
						end
					end
				end
				if effect ~= "text" then
					local newconds = {}
					local newtags = {}

					for c,d in ipairs(conds) do
						table.insert(newconds, d)
					end

					for c,d in ipairs(tags) do
						table.insert(newtags, d)
					end

					table.insert(newtags, "visualmimic")
					table.insert(newtags, "dontadd")
					table.insert(newtags, "verbtext")
					table.insert(newtags, "verbmeta" .. level)

					local newword1 = target
					local newword2 = verb
					local newword3 = "text"

					local newrule = {newword1, newword2, newword3}
					addoption(newrule,newconds,ids,false,nil,newtags)
				end
			end
		elseif (effect == "text" or effect == "not text") and (targetnot ~= "not ") and verb ~= "is" and verb ~= "become" and verb ~= "make" and verb ~= "has" and verb ~= "write" then
			for a,b in pairs(fullunitlist) do -- fullunitlist contains all units, is new
				if (string.sub(a, 1, 5) == "text_") then
					local stop = false
					local newconds = {}
					local newtags = {}

					for c,d in ipairs(conds) do
						table.insert(newconds, d)
					end

					for c,d in ipairs(tags) do
						if d == "dontadd" then
							stop = true
							break
						end
						table.insert(newtags, d)
					end

					table.insert(newtags, "verbtext")

					local newword1 = target
					local newword2 = verb
					local newword3 = a
					if effect == "not text" then
						newword3 = "not " .. a
					end

					local newrule = {newword1, newword2, newword3}
					if not stop then
						addoption(newrule,newconds,ids,false,nil,newtags)
					end
				end
			end
		elseif (effect == "glyph" or effect == "not glyph") and (targetnot ~= "not ") and verb ~= "is" and verb ~= "become" and verb ~= "make" and verb ~= "has" and verb ~= "write" then
			for a,b in pairs(fullunitlist) do -- fullunitlist contains all units, is new
				if (string.sub(a, 1, 6) == "glyph_") then
					local stop = false
					local newconds = {}
					local newtags = {}

					for c,d in ipairs(conds) do
						table.insert(newconds, d)
					end

					for c,d in ipairs(tags) do
						if d == "dontadd" then
							stop = true
							break
						end
						table.insert(newtags, d)
					end

					table.insert(newtags, "verbglyph")

					local newword1 = target
					local newword2 = verb
					local newword3 = a
					if effect == "not glyph" then
						newword3 = "not " .. a
					end

					local newrule = {newword1, newword2, newword3}
					if not stop then
						addoption(newrule,newconds,ids,false,nil,newtags)
					end
				end
			end
		elseif ((string.sub(effect,1,4) == "meta" or string.sub(effect,1,8) == "not meta")) and (targetnot ~= "not ") and verb ~= "is" and verb ~= "become" and verb ~= "make" and verb ~= "has" and verb ~= "write" then
			local isnot = (string.sub(effect,1,8) == "not meta")
			local level = string.sub(effect,5)
			if isnot then
				level = string.sub(effect,9)
			end
			if tonumber(level) ~= nil and tonumber(level) >= -1 then
				for a,b in pairs(fullunitlist) do -- fullunitlist contains all units, is new
					local metalevel = getmetalevel(a)
					if metalevel == tonumber(level) and (findnoun(a,nil,true) == false) then
						local newconds = {}
						local newtags = {}

						for c,d in ipairs(conds) do
							table.insert(newconds, d)
						end

						for c,d in ipairs(tags) do
							table.insert(newtags, d)
						end

						table.insert(newtags, "verbtext")
						table.insert(newtags, "verbmeta" .. level)

						local newword1 = target
						local newword2 = verb
						local newword3 = a
						if objectlist[a] == nil then
							objectlist[a] = 1
						end
						if isnot then
							newword3 = "not " .. a
						end

						local newrule = {newword1, newword2, newword3}
						addoption(newrule,newconds,ids,false,nil,newtags)
					end
				end
			end
			if (verb == "mimic" or verb == "perform") and isnot == false then
				local newconds = {}
				local newtags = {}

				for c,d in ipairs(conds) do
					table.insert(newconds, d)
				end

				for c,d in ipairs(tags) do
					table.insert(newtags, d)
				end

				table.insert(newtags, "dontadd")
				table.insert(newtags, "verbtext")
				table.insert(newtags, "verbmeta" .. level)

				local newword1 = target
				local newword2 = verb
				local newword3 = "text"
				if fullunitlist["text"] == nil then
					fullunitlist["text"] = 1
				end

				local newrule = {newword1, newword2, newword3}
				addoption(newrule,newconds,ids,false,nil,newtags)
			end
		end
	end
end

function code(alreadyrun_)
	--[[ 
		@mods(this) - Override reason: provide hook for do_subrule_pnouns
		@mods(omni text) - Override reason: when checking for the first round of firstwords, we need to adjust which spaces to check for pivot text to be an initial firstword
		@mods(stable) - Override reason: provide hook for update_stable_state()
    	@mods(guard) - Injection reaon: provide a guard checkpoint
	 ]]
	local playrulesound = false
	local alreadyrun = alreadyrun_ or false
	poweredstatus = {}

    if this_mod_has_this_text() then
		if this_mod_globals.undoed_after_called then
            updatecode = 1 -- Just set updatecode = 1. No need to perform checks when we are undoing. (I think)
		elseif updatecode == 0 and not turning_text_mod_globals.tt_executing_code then
            -- print("check_updatecode_status_from_raycasting: ", check_updatecode_status_from_raycasting())
            if check_updatecode_status_from_raycasting() then
                updatecode = 1
            end
		end
	end

	if not alreadyrun then
		update_stable_state()
	end
    -- print("running code() with updatecode = ", updatecode)

	if (updatecode == 1) then
		HACK_INFINITY = HACK_INFINITY + 1
		--MF_alert("code being updated!")
		
		if generaldata.flags[LOGGING] then
			logrulelist.new = {}
		end
		
		MF_removeblockeffect(0)
		wordrelatedunits = {}
		
		do_mod_hook("rule_update",{alreadyrun})
		
		if (HACK_INFINITY < 200) then
			if metatext_textisword then
				addbaserule("text","is","word")
			end
			local checkthese = {}
			local wordidentifier = ""
			local echoidentifier = ""
			wordunits,wordidentifier,wordrelatedunits = findwordunits()
			echounits,echoidentifier,echorelatedunits = ws_findechounits()
			symbolunits,symbolidentifier,symbolrelatedunits = findsymbolunits()
			local wordunitresult = {}
			local echounitresult = {}
			
			if (#wordunits > 0) then
				for i,v in ipairs(wordunits) do
					if testcond(v[2],v[1]) then
						wordunitresult[v[1]] = 1
						table.insert(checkthese, v[1])
					else
						wordunitresult[v[1]] = 0
					end
				end
			end
			
			if (#echounits > 0) then -- Check {unitid, conditions} pairs for ECHO ?
				for _,v in ipairs(echounits) do
					if testcond(v[2],v[1]) then
						echounitresult[v[1]] = 1
						table.insert(checkthese, v[1])
					else
						echounitresult[v[1]] = 0
					end
				end
			end
			
			features = {}
			featureindex = {}
			condfeatureindex = {}
			visualfeatures = {}
			notfeatures = {}
			groupfeatures = {}

			pf_rule_metadata_index:reset()

			local firstwords = {}
			local alreadyused = {}

			do_mod_hook("rule_baserules")
			for i,v in ipairs(baserulelist) do
				addbaserule(v[1],v[2],v[3],v[4])
			end
			if metatext_textisword then
				addbaserule("text","is","word")
			end

			--add persistent rules to base rules
			for level,levelrules in pairs(persistbaserules) do
				if level ~= generaldata.strings[CURRLEVEL] then
					for j,w in ipairs(levelrules) do
						addbaserule(w[1],w[2],w[3])
					end
				end
			end
			
			-- @mods(turning text) - weirdchamp thing to do. This tries to prevent the immensive lag spike when you have turning_dir and a rectangle of letters in one level
			if not turning_text_mod_globals.tt_executing_code then
				formlettermap()
			end
			
			if (#codeunits > 0) then
				for i,v in ipairs(codeunits) do
					if metatext_textisword then
						setcolour(v)
					else
					table.insert(checkthese, v)
				end
			end
			end
			
			if (#checkthese > 0) or (#letterunits > 0) or (#glyphunits > 0) then
				for iid,unitid in ipairs(checkthese) do
					local unit = mmf.newObject(unitid)
					local x,y = unit.values[XPOS],unit.values[YPOS]
					local ox,oy,nox,noy = 0,0
					local tileid = x + y * roomsizex

					setcolour(unit.fixed)
					
					if (alreadyused[tileid] == nil) and (unit.values[TYPE] ~= 5) and (unit.flags[DEAD] == false) then
						for i=1,2 do
							--[[
								@mods(omni text) - If its pivot text, forward direction should be perpendicular 
								Context: A firstword is a starting text object where the game starts extracting sentences. It determines these set of texts through a simple criteria:
									1. The space behind it does not contain any texts
									2. The space in front of it contains at least one text
								("front" and "behind" are relative to the current parsing direction, which can either be right or down)
								If we are checking on a pivot text for firstword eligibility, instead of checking in opposite directions, we have to check in perpendicular directions
							 ]]
							local forward_dir = i
							-- print("perp: "..unit.strings[NAME])
							if name_is_branching_text(unit.strings[NAME], false, true) then
								forward_dir = get_perp_direction(i)
							end

							local drs = dirs[i+2]
							local ndrs = dirs[forward_dir]
							ox = drs[1]
							oy = drs[2]
							nox = ndrs[1]
							noy = ndrs[2]
							
							--MF_alert("Doing firstwords check for " .. unit.strings[UNITNAME] .. ", dir " .. tostring(i))
							
							local hm = codecheck(unitid,ox,oy,i,nil,wordunitresult,echounitresult)
							local hm2 = codecheck(unitid,nox,noy,forward_dir,nil,wordunitresult,echounitresult)
							
							if (#hm == 0) and (#hm2 > 0) then
								--MF_alert("Added " .. unit.strings[UNITNAME] .. " to firstwords, dir " .. tostring(i))
								
								if not isglyph(unit) then	
									table.insert(firstwords, {{unitid}, i, 1, unit.strings[UNITNAME], unit.values[TYPE], {}})
								else
									table.insert(firstwords, {{unitid}, i, 1, "glyph", 0, {}})
								end
								
								if (alreadyused[tileid] == nil) then
									alreadyused[tileid] = {}
								end
								
								alreadyused[tileid][i] = 1
							end
						end
					end
				end
				
				--table.insert(checkthese, {unit.strings[UNITNAME], unit.values[TYPE], unit.values[XPOS], unit.values[YPOS], 0, 1, {unitid})
				
				for a,b in pairs(letterunits_map) do
					for iid,data in ipairs(b) do
						local x,y,i = data[3],data[4],data[5]
						local unitids = data[7]
						local width = data[6]
						local word,wtype = data[1],data[2]
						
						local unitid = unitids[1]
						
						local tileid = x + y * roomsizex
						
						if (alreadyused[tileid] == nil) or ((alreadyused[tileid] ~= nil) and (alreadyused[tileid][i] == nil)) then
							local drs = dirs[i+2]
							local ndrs = dirs[i]
							ox = drs[1]
							oy = drs[2]
							nox = ndrs[1] * width
							noy = ndrs[2] * width
							
							local hm = codecheck(unitid,ox,oy,i)
							local hm2 = codecheck(unitid,nox,noy,i)
							
							if (#hm == 0) and (#hm2 > 0) then
								-- MF_alert(word .. ", " .. tostring(width))
								
								table.insert(firstwords, {unitids, i, width, word, wtype, {}})
								
								if (alreadyused[tileid] == nil) then
									alreadyused[tileid] = {}
								end
								
								alreadyused[tileid][i] = 1
							end
						end
					end
				end
				
				if BRANCHING_TEXT_LOGGING then
					print("<<<<<<<<<<<<<start>")
				end

				local check = doglyphs(symbolunits)
				docode(firstwords,wordunits)
				if BRANCHING_TEXT_LOGGING then
					print("<<<<<<<<<<<<<end>")
				end
				do_subrule_pnouns()
				subrules()
				grouprules()
				getallrouters()
				getallofflines()
				playrulesound = postrules(alreadyrun)
				updatecode = 0

				if check == "stop" then
					return
				end

				local newwordunits,newwordidentifier,wordrelatedunits = findwordunits()
				local stable_state_updated = update_stable_state(alreadyrun)
				local _,newechoidentifier,echorelatedunits = ws_findechounits()
				local newsymbolunits,newsymbolidentifier,newsymbolrelatedunits = findsymbolunits()
				
				--MF_alert("ID comparison: " .. newwordidentifier .. " - " .. wordidentifier)
				
				--@mods(stable) - handles the case where this run of code() caused the stablestate to update. In this case, rerun code()
				if (newwordidentifier ~= wordidentifier) or (newechoidentifier ~= echoidentifier) or (stable_state_updated) then
					updatecode = 1
					code(true)
				elseif (newsymbolidentifier ~= symbolidentifier) then
					updatecode = 1
					code(true)
				else
					--domaprotation()
				end
			elseif metatext_textisword then
				updatecode = 0

				local newwordunits,newwordidentifier,wordrelatedunits = findwordunits()

				--MF_alert("ID comparison: " .. newwordidentifier .. " - " .. wordidentifier)

				if (newwordidentifier ~= wordidentifier) then
					updatecode = 1
					code(true)
				else
					--domaprotation()
				end
			end
		else
			MF_alert("Level destroyed - code() run too many times")
			destroylevel("infinity")
			return
		end
		
		if (alreadyrun == false) then
			effects_decors()

			if (featureindex["broken"] ~= nil) then
				brokenblock(checkthese)
			end
			
			if (featureindex["3d"] ~= nil) then
				updatevisiontargets()
			end
			
			if generaldata.flags[LOGGING] then
				updatelogrules()
			end
		end

		do_mod_hook("rule_update_after",{alreadyrun})
	end
	
	if (alreadyrun == false) then
		local rulesoundshort = ""
		alreadyrun = true
		if playrulesound and (generaldata5.values[LEVEL_DISABLERULEEFFECT] == 0) then
			local pmult,sound = checkeffecthistory("rule")
			rulesoundshort = sound
			local rulename = "rule" .. tostring(math.random(1,5)) .. rulesoundshort
			MF_playsound(rulename)
		end
	end

	guard_checkpoint("code")
end

function findwordunits()
	--[[ 
		@mods(this) - Override reason: make "this is word" and "not this is word" work
		@mods(stable) - Override reason: change findall() call to convey "I just want to get all wordunits"
	 ]]
	local result = {}
	local alreadydone = {}
	local checkrecursion = {}
	local related = {}
	
	local identifier = ""
	local fullid = {}
	
	if (featureindex["word"] ~= nil) then
		for i,v in ipairs(featureindex["word"]) do
			local rule = v[1]
			local conds = v[2]
			local ids = v[3]
			
			local name = rule[1]
			local subid = ""
			
			if (rule[2] == "is") then
				if ((fullunitlist[name] ~= nil) or ((name == "glyph") and (#glyphunits > -1))) and (findnoun(name,nlist.short,true) == false) and (metatext_textisword or string.sub(name,1,5) ~= "text_") and (alreadydone[name] == nil) then
					-- @mods(stable) originally it was "findall({name, {}})". But we are assuming that passing nil conds = don't test conditions.
					local these = findall({name})
					alreadydone[name] = 1
					
					if (#these > 0) then
						for a,b in ipairs(these) do
							local bunit = mmf.newObject(b)
							local unitname = ""
							if name == "text" then
								unitname = bunit.strings[UNITNAME]
							else
								unitname = name
							end
							local valid = true
							
							if (featureindex["broken"] ~= nil) then
								if (hasfeature(getname(bunit),"is","broken",b,bunit.values[XPOS],bunit.values[YPOS]) ~= nil) then
									valid = false
								end
							end
							
							if valid then
								table.insert(result, {b, conds})
								subid = subid .. unitname
								-- LISÄÄ TÄHÄN LISÄÄ DATAA
							end
						end
					end
				end
				
				if (#subid > 0) then
					for a,b in ipairs(conds) do
						local condtype = b[1]
						local params = b[2] or {}
						
						subid = subid .. condtype
						
						if (#params > 0) then
							for c,d in ipairs(params) do
								subid = subid .. tostring(d)
								
								related = findunits(d,related,conds)
							end
						end
					end
				end
				
				table.insert(fullid, subid)
				
				--MF_alert("Going through " .. name)
				
				if (#ids > 0) then
					if (#ids[1] == 1) then
						local firstunit = mmf.newObject(ids[1][1])
						
						local notname = name
						if (string.sub(name, 1, 4) == "not ") then
							notname = string.sub(name, 5)
						end
						
						if (firstunit.strings[UNITNAME] ~= "text_" .. name) and (firstunit.strings[UNITNAME] ~= "text_" .. notname) then
							--MF_alert("Checking recursion for " .. name)
							table.insert(checkrecursion, {name, i})
						end
					end
				else
					MF_alert("No ids listed in Word-related rule! rules.lua line 1302 - this needs fixing asap (related to grouprules line 1118)")
				end
			end
		end
		
		table.sort(fullid)
		for i,v in ipairs(fullid) do
			-- MF_alert("Adding " .. v .. " to id")
			identifier = identifier .. v
		end
		
		--MF_alert("Identifier: " .. identifier)
		
		for a,checkname_ in ipairs(checkrecursion) do
			local found = false
			
			local checkname = checkname_[1]
			
			local b = checkname
			if (string.sub(b, 1, 4) == "not ") then
				b = string.sub(checkname, 5)
			end
			
			for i,v in ipairs(featureindex["word"]) do
				local rule = v[1]
				local ids = v[3]
				local tags = v[4]
				
				-- Gotta change this to prevent some false infinite loops
				if (rule[1] == b) or ((rule[1] == "glyph") and (string.sub(b, 1, 6) == "glyph_")) or (rule[1] == "all" and string.sub(b,1,5) ~= "text_") or ((rule[1] ~= b) and (string.sub(rule[1], 1, 4) == "not ") and string.sub(b,1,5) ~= "text_") or ((rule[1] == "text" or rule[1] == "not all") and string.sub(b,1,5) == "text_") or ((rule[1] ~= b) and (string.sub(rule[1], 1, 9) == "not text_") and string.sub(b,1,5) == "text_")
				or ("meta"..getmetalevel(b) == rule[1]) or ("not meta"..getmetalevel(b) ~= rule[1] and (metatext_includenoun or string.sub(b,1,5) == "text_")) then
					for c,g in ipairs(ids) do
						for a,d in ipairs(g) do
							local idunit = mmf.newObject(d)
							
							-- Tässä pitäisi testata myös Group!
							if (idunit.strings[UNITNAME] == "text_" .. rule[1]) or ((idunit.strings[UNITNAME] == "glyph_" .. rule[1]) and (tags[1] == "glyphrule")) or ((idunit.strings[UNITNAME] == rule[1]) and (tags[1] == "glyphrule")) or ((rule[1] == "all") and (rule[1] ~= "glyph")) then
								--MF_alert("Matching objects - found")
								found = true
							elseif (string.sub(rule[1], 1, 5) == "group") then
								--MF_alert("Group - found")
								found = true
							elseif (rule[1] ~= checkname) and (((string.sub(rule[1], 1, 3) == "not") and (rule[1] ~= "glyph")) or ((rule[1] == "not all") and (rule[1] == "glyph"))) then
								--MF_alert("Not Object - found")
								found = true
							elseif idunit.strings[UNITNAME] == "text_this" then
								-- Note: this could match any "this is word" or "not this is word" rules. But we handle the raycast buisness in testcond
								found = true
							elseif (idunit.strings[UNITNAME] == "text_text_") then
								found = true
							end
						end
					end
					
					for c,g in ipairs(tags) do
						if (g == "mimic") then
							found = true
						end
					end
				end
			end
			
			if (found == false) then
				--MF_alert("Wordunit status for " .. b .. " is unstable!")
				identifier = "null"
				wordunits = {}
				
				for i,v in pairs(featureindex["word"]) do
					local rule = v[1]
					local ids = v[3]
					
					--MF_alert("Checking to disable: " .. rule[1] .. " " .. ", not " .. b)
					
					if (rule[1] == b) or (rule[1] == "not " .. b) then
						v[2] = {{"never",{}}}
					end
				end
				
				if (string.sub(checkname, 1, 4) == "not ") then
					local notrules_word = notfeatures["word"]
					local notrules_id = checkname_[2]
					local disablethese = notrules_word[notrules_id]
					
					for i,v in ipairs(disablethese) do
						v[2] = {{"never",{}}}
					end
				end
			end
		end
	end
	
	--MF_alert("Current id (end): " .. identifier)
	
	return result,identifier,related
end

function postrules(alreadyrun_)
	--[[ 
		@mods(this) - Override reason: add rule puff effects for "X is this"
		@mods(stable) - Override reason: "X is not Y" and "X is X" directly modifies rules in the featureindex. We don't want that to happen for stablerules 
				(look for instances of has_stable_tag() )
	 ]]

	local scary = findfeature(nil, "is", "scary") --@mods (extrem)
	local scared = findfeature(nil, "is", "scared")
	if scary ~= nil and scared ~= nil then
		for a, b in ipairs(scary) do
			for c, d in ipairs(scared) do
				local ids = b[3]
				if d[3] ~= nil then
					for e, f in ipairs(d[3]) do
						table.insert(ids, f)
					end
				end
				addoption({ d[1][1], "fear", b[1][1] }, {}, ids, false, {})
			end
		end
	end

	local protects = {}
	local newruleids = {}
	local ruleeffectlimiter = {}
	local playrulesound = false
	local alreadyrun = alreadyrun_ or false
	
	for i,unit in ipairs(units) do
		--@mods(past)
		if unit.active == false and doingpast == false then
			remove_donepast_unit(unit)
		end
		
		unit.active = false
	end
	
	local limit = #features
	
	for i,rules in ipairs(features) do
		if (i <= limit) then
			local rule = rules[1]
			local conds = rules[2]
			local ids = rules[3]
			local tags = rules[4]
			
			if (rule[1] == rule[3]) and (rule[2] == "is") then
				table.insert(protects, i)
			end
			
			if (ids ~= nil) then
				local works = true
				local idlist = {}
				local effectsok = false

				local is_stable = false
				for _,tag in ipairs(tags) do
					if tag == "stable" then
						is_stable = true
						break
					end
				end
				
				if (#ids > 0 and not is_stable) then
					for a,b in ipairs(ids) do
						table.insert(idlist, b)
					end
				end
				
				if (#idlist > 0) and works then
					for a,d in ipairs(idlist) do
						for c,b in ipairs(d) do
							if (b ~= 0) then
								local bunit = mmf.newObject(b)
								
								if (bunit.strings[UNITTYPE] == "text") or (string.sub(bunit.strings[UNITNAME], 1, 6) == "glyph_") then
									bunit.active = true
									setcolour(b,"active")
								end

								--@mods(past)
								if amundoing or keyssofar == nil or #keyssofar < 1 then
									add_donepast_unit(bunit)
								end

								newruleids[b] = 1
								
								if (ruleids[b] == nil) and (#undobuffer > 1) and (alreadyrun == false) and (generaldata5.values[LEVEL_DISABLERULEEFFECT] == 0) then
									if (ruleeffectlimiter[b] == nil) then
										local x,y = bunit.values[XPOS],bunit.values[YPOS]
										local c1,c2 = getcolour(b,"active")
										--MF_alert(b)
										MF_particles_for_unit("bling",x,y,5,c1,c2,1,1,b)
										ruleeffectlimiter[b] = 1
									end
									
									if (rule[2] ~= "play") then
										playrulesound = true
									end
								end
							end
						end
					end
				elseif (#idlist > 0) and (works == false) then
					for a,visualrules in pairs(visualfeatures) do
						local vrule = visualrules[1]
						local same = comparerules(rule,vrule)
						
						if same then
							table.remove(visualfeatures, a)
						end
					end
				end
			end

			local rulenot = 0
			local neweffect = ""
			
			local nothere = string.sub(rule[3], 1, 4)
			
			if (nothere == "not ") then
				rulenot = 1
				neweffect = string.sub(rule[3], 5)
			end
			
			if (rulenot == 1) then
				local newconds,crashy = invertconds(conds,nil,rule[3])
				
				local newbaserule = {rule[1],rule[2],neweffect}
				
				local target = rule[1]
				local verb = rule[2]
				
				local targetlists = {}
				table.insert(targetlists, target)
				
				if (verb == "is") and (neweffect == "text") and (featureindex["write"] ~= nil) then
					table.insert(targetlists, "write")
				end

				-- @mods(stable) - to handle cases of "X is X" and "X is not Y" directly modifying the featureindex with conditions,
				-- the general rule is this: Normal features can only modify other normal features. Stable features can only modify other stable features.
				-- There cannot be a crisscross between normal and stable features. - 3/6/22
				-- Update: we allow one exception. If "X is not stable" is a stablerule, it should cancel out the normal rule "X is stable"
				local not_rule_has_stable_tag = has_stable_tag(tags)
				if (verb == "is") and (neweffect == "glyph") and (featureindex["inscribe"] ~= nil) then
					table.insert(targetlists, "inscribe")
				end
				
				for e,g in ipairs(targetlists) do
					for a,b in ipairs(featureindex[g]) do
						local same = comparerules(newbaserule,b[1])
						local target_rule_has_stable_tag = has_stable_tag(b[4])
						
						if (same or ((g == "inscribe") and (target == b[1][1]) and (b[1][2] == "inscribe")) or ((g == "write") and (target == b[1][1]) and (b[1][2] == "write")) or ((((neweffect == "text") and (string.sub(b[1][3], 1, 5)=="text_")) or ((neweffect == "glyph") and (string.sub(b[1][3], 1, 6)=="glyph_"))) and (target == b[1][1]) and (verb == b[1][2]))) and (not_rule_has_stable_tag == target_rule_has_stable_tag or newbaserule == "stable") then
							--MF_alert(rule[1] .. ", " .. rule[2] .. ", " .. neweffect .. ": " .. b[1][1] .. ", " .. b[1][2] .. ", " .. b[1][3])
							local theseconds = b[2]
							
							if (#newconds > 0) then
								if (newconds[1] ~= "never") then
									for c,d in ipairs(newconds) do
										table.insert(theseconds, d)
									end
								else
									theseconds = {"never",{}}
								end
							end
							
							if crashy then
								addoption({rule[1],"is","crash"},theseconds,ids,false,nil,rules[4])
							end
							
							b[2] = theseconds
						end
					end
				end
			end
		end
	end

	for unitid, _ in pairs(this_mod_globals.active_this_property_text) do
		local unit = mmf.newObject(unitid)
		unit.active = true
        setcolour(unitid,"active")
        newruleids[unitid] = 1
        if (ruleids[unitid] == nil) and (#undobuffer > 1) and (alreadyrun == false) and (generaldata5.values[LEVEL_DISABLERULEEFFECT] == 0) then
            if (ruleeffectlimiter[unitid] == nil) then
                local x,y = unit.values[XPOS],unit.values[YPOS]
                local c1,c2 = getcolour(unitid,"active")
                MF_particles_for_unit("bling",x,y,5,c1,c2,1,1,unitid)
                ruleeffectlimiter[unitid] = 1
            end
            
            playrulesound = true
		end
	end
	
	if (#protects > 0) then
		for i,v in ipairs(protects) do
			local rule = features[v]
			
			local baserule = rule[1]
			local conds = rule[2]
			
			local target = baserule[1]
			
			local newconds = {{"never",{}}}
			
			if (conds[1] ~= "never") then
				if (#conds > 0) then
					newconds = {}
					
					for a,b in ipairs(conds) do
						local condword = b[1]
						local condgroup = {}
						
						if (string.sub(condword, 1, 1) == "(") then
							condword = string.sub(condword, 2)
						end
						
						if (string.sub(condword, -1) == ")") then
							condword = string.sub(condword, 1, #condword - 1)
						end
						
						local newcondword = "not " .. condword
						
						if (string.sub(condword, 1, 3) == "not") then
							newcondword = string.sub(condword, 5)
						end
						
						if (a == 1) then
							newcondword = "(" .. newcondword
						end
						
						if (a == #conds) then
							newcondword = newcondword .. ")"
						end
						
						if (b[2] ~= nil) then
							for c,d in ipairs(b[2]) do
								table.insert(condgroup, d)
							end
						end
						
						table.insert(newconds, {newcondword, condgroup})
					end
				end		
			
				-- @mods(stable) - to handle cases of "X is X" and "X is not Y" directly modifying the featureindex with conditions,
				-- the general rule is this: Normal features can only modify other normal features. Stable features can only modify other stable features.
				-- There cannot be a crisscross between normal and stable features. - 3/6/22
				local protect_rule_has_stable_tag = has_stable_tag(rule[4])
				if (featureindex[target] ~= nil) then
					for a,rules in ipairs(featureindex[target]) do
						local targetrule = rules[1]
						local targetconds = rules[2]
						local object = targetrule[3]

						local target_rule_has_stable_tag = has_stable_tag(rules[4])
						
						if (targetrule[1] == target) --@Merge: omg beeeeg if block
						  and (((targetrule[2] == "is") and (target ~= object)) 
						  	  or ((targetrule[2] == "inscribe") and (string.sub(object, 1, 4) ~= "not "))
						  	  or ((targetrule[2] == "write") and (string.sub(object, 1, 4) ~= "not ")))
						  and ((getmat(object) ~= nil)
						  	  or (object == "revert")
						  	  or ((targetrule[2] == "inscribe") and (string.sub(object, 1, 4) ~= "not "))
						  	  or ((targetrule[2] == "write") and (string.sub(object, 1, 4) ~= "not "))
							  or (object == "meta")
							  or (object == "unmeta"))
						  and (string.sub(object, 1, 5) ~= "group") 
						  	  and (protect_rule_has_stable_tag == target_rule_has_stable_tag)
						  then
								
							if (#newconds > 0) then
								if (newconds[1] == "never") then
									targetconds = {}
								end
								
								for c,d in ipairs(newconds) do
									table.insert(targetconds, d)
								end
							end
							
							rules[2] = targetconds
						end
					end
				end
			end
		end
	end
	
	ruleids = newruleids
	
	if (spritedata.values[VISION] == 0) then
		ruleblockeffect()
	end
	
	return playrulesound
end

function subrules()
	--@mods(stable) - Override reason, prevent copied rules from becoming a stablerule (by excluding the "stable" tag)
	local mimicprotects = {}
	
	if (featureindex["all"] ~= nil) then
		for k,rules in ipairs(featureindex["all"]) do
			local rule = rules[1]
			local conds = rules[2]
			local ids = rules[3]
			local tags = rules[4]
			
			if (rule[3] == "all") then
				if (rule[2] ~= "is") then
					local nconds = {}
					
					if (featureindex["not all"] ~= nil) then
						for a,prules in ipairs(featureindex["not all"]) do
							local prule = prules[1]
							local pconds = prules[2]
							
							if (prule[1] == rule[1]) and (prule[2] == rule[2]) and (prule[3] == "not all") then
								local ipconds = invertconds(pconds)
								
								for c,d in ipairs(ipconds) do
									table.insert(nconds, d)
								end
							end
						end
					end
					
					for i,mat in pairs(objectlist) do
						if (findnoun(i) == false) then
							local newrule = {rule[1],rule[2],i}
							local newconds = {}
							for a,b in ipairs(conds) do
								table.insert(newconds, b)
							end
							for a,b in ipairs(nconds) do
								table.insert(newconds, b)
							end
							addoption(newrule,newconds,ids,false,nil,tags)
						end
					end
				end
			end

			if (rule[1] == "all") and (string.sub(rule[3], 1, 4) ~= "not ") then
				local nconds = {}
				
				if (featureindex["not all"] ~= nil) then
					for a,prules in ipairs(featureindex["not all"]) do
						local prule = prules[1]
						local pconds = prules[2]
						
						if (prule[1] == rule[1]) and (prule[2] == rule[2]) and (prule[3] == "not " .. rule[3]) then
							local ipconds = invertconds(pconds)
							
							if crashy_ then
								crashy = true
							end
							
							for c,d in ipairs(ipconds) do
								table.insert(nconds, d)
							end
						end
					end
				end
				
				for i,mat in pairs(objectlist) do
					if (findnoun(i) == false) then
						local newrule = {i,rule[2],rule[3]}
						local newconds = {}
						for a,b in ipairs(conds) do
							table.insert(newconds, b)
						end
						for a,b in ipairs(nconds) do
							table.insert(newconds, b)
						end
						addoption(newrule,newconds,ids,false,nil,tags)
					end
				end
			end
			
			if (rule[1] == "all") and (string.sub(rule[3], 1, 4) == "not ") then
				for i,mat in pairs(objectlist) do
					if (findnoun(i) == false) then
						local newrule = {i,rule[2],rule[3]}
						local newconds = {}
						for a,b in ipairs(conds) do
							table.insert(newconds, b)
						end
						addoption(newrule,newconds,ids,false,nil,tags)
					end
				end
			end
		end
	end
	
	if (featureindex["mimic"] ~= nil) or (featureindex["perform"] ~= nil) then
		local mimiclikes = {} --@mods(extrem)

		if featureindex["mimic"] ~= nil then
			for a, rules in ipairs(featureindex["mimic"]) do
				table.insert(mimiclikes, rules)
			end
		elseif featureindex["perform"] ~= nil then
			for a, rules in ipairs(featureindex["perform"]) do
				table.insert(mimiclikes, rules)
			end
		end

		for i, rules in ipairs(mimiclikes) do
			local rule = rules[1]
			local conds = rules[2]
			local tags = rules[4]
			
			--@mods(stable), @mods(extrem)
			if (rule[2] == "act") then
				rule[2] = "is"
			end

			if (rule[2] == "mimic") or (rule[2] == "perform") then
				local object = rule[1]
				local target = rule[3]
				
				local isnot = false
				
				if (string.sub(target, 1, 4) == "not ") then
					target = string.sub(target, 5)
					isnot = true
				end
				
				if isnot then
					if (mimicprotects[object] == nil) then
						mimicprotects[object] = {}
					end
					
					table.insert(mimicprotects[object], {target, conds, rule[3]})
				end
			end
		end
	end
	
	local limiter = 0
	local limit = 250

	if (featureindex["mimic"] ~= nil) or (featureindex["perform"] ~= nil) then
		--@mods(extrem)
		local mimiclikes = {}

		if featureindex["mimic"] ~= nil then
			for a, rules in ipairs(featureindex["mimic"]) do
				table.insert(mimiclikes, rules)
			end
		elseif featureindex["perform"] ~= nil then
			for a, rules in ipairs(featureindex["perform"]) do
				table.insert(mimiclikes, rules)
			end
		end

		for i, rules in ipairs(mimiclikes) do
			local visualonly = false
			local rule = rules[1]
			local conds = rules[2]
			local tags = rules[4]
			local visual = true
			local verbpair = {}
			for i,v in ipairs(tags) do
				if v == "text" or string.sub(v,1,4) == "meta" then --there's some metatext stuff here, hopefully won't cause problems
					visual = false
				elseif v == "visualmimic" then
					visualonly = true
				elseif string.sub(v,1,4) == "verb" then
					verbpair[string.sub(v,5)] = 1
				end
			end

			--[[ 
				@mods(THIS): basegame MIMIC doesn't copy the text ids of "X mimic Y" to its subrules.
				It's needed in THIS for the following:
				- If "THIS mimic X is blue", then the subrule generated is "THIS is blue".
				- In order to process "THIS is blue", we need the unitid of the THIS text to figure out where to start raycasting.
				- But since the unitid of THIS wasn't copied over to the subrule, we cannot process "THIS is blue"
			]]
			local mimic_ids = rules[3]

			if (rule[2] == "act") then
				rule[2] = "is"
			end

			if (rule[2] == "mimic") or (rule[2] == "perform") then
				local object = rule[1]
				local target = rule[3]
				local mprotects = mimicprotects[object] or {}
				local extraconds = {}
				
				local valid = true
				if object == "text" or string.sub(object,1,4) == "meta" then
					visualonly = true
				end
				
				if (string.sub(target, 1, 4) == "not ") then
					valid = false
				end
				
				for a,b in ipairs(mprotects) do
					if (b[1] == target) then
						local pconds = b[2]
						
						if (#pconds == 0) then
							valid = false
						else
							local newconds = invertconds(pconds)
							
							for c,d in ipairs(newconds) do
								table.insert(extraconds, d)
							end
						end
					end
				end
				
				local copythese = {}
				
				if valid then
					if (getmat(object,true) ~= nil) and (getmat(target,true) ~= nil) then
						if (featureindex[target] ~= nil) then
							copythese = featureindex[target]
						end
					end
				
					for a,b in ipairs(copythese) do
						local trule = b[1]
						local tconds = b[2]
						local ids = b[3]
						local ttags = b[4]
						
						local valid = true
						for c,d in ipairs(ttags) do
							if (d == "mimic") or verbpair[d] ~= nil or (string.sub(d,1,4) == "verb") then
								valid = false
								break
							end
						end

						if (rule[2] == "perform") and (trule[2] ~= "act") then
							valid = false
						end

						if (trule[1] == target) and (trule[2] ~= "mimic") and (trule[2] ~= "perform") and valid then
							local newconds = {}
							local newids = {}
							local newtags = {}
							local has_stable_cond = false
							
							for c,d in ipairs(tconds) do
								table.insert(newconds, d)
							end
							
							for c,d in ipairs(conds) do
								if d[1] == "stable" then
									has_stable_cond = true
								end
								table.insert(newconds, d)
							end
							
							for c,d in ipairs(extraconds) do
								table.insert(newconds, d)
							end

							-- TODO: this system is definetly jank and might need to be reworked
							if #mimic_ids >= 3 then -- If we are using a normal mimic rule, the text unitids will be at least 3
								-- To allow compatability with th_testcond_this.lua functions, insert text unit ids in this order (X = mimic rule, Y = other rule):
								-- 		(noun of X) (verb of X) (property of X) (noun of Y) (verb of Y) (property of Y) (condition params for Y...) (condition params for X...)
								for c,d in ipairs(mimic_ids) do
									table.insert(newids, d)

									if c == 3 then
										for e,f in ipairs(ids) do
											table.insert(newids, f)
										end		
									end
								end
							else
								-- If the mimic rule has no text unitids, then it should be either a baserule or stablerule
								assert(#mimic_ids == 0) -- Assuming it's impossible for a rule to be formed with 1 or 2 texts
								for e,f in ipairs(ids) do
									table.insert(newids, f)
								end
							end
							
							for c,d in ipairs(ttags) do
								table.insert(newtags, d)
							end
							
							for c,d in ipairs(tags) do
								--@mods(stable) - do not make the new mimiced rule be a stablerule. This can happen if "X mimic Y" is a stablerule
								if d ~= "stable" then
									table.insert(newtags, d)
								end
							end
							
							table.insert(newtags, "mimic")
							
							local newword1 = object
							local newword2 = trule[2]
							local newword3 = trule[3]

							if (newword2 == "act") then
								newword2 = "is"
							end

							local newrule = {newword1, newword2, newword3}
							
							limiter = limiter + 1

							if has_stable_cond then
								addoption(newrule,newconds,newids,false,nil,newtags,visualonly)
							else
								addoption(newrule,newconds,newids,visual,nil,newtags,visualonly)
							end

							if STABLE_LOGGING then
								local conds_str = ""
								for _, cond in ipairs(newconds) do
									conds_str = conds_str.." "..cond[1]
								end

								print("adding mimiced rule: ", newword1, newword2, newword3)
								print("conds:", conds_str)
								local t = "'X mimic Y' tags:"
								for _,tag in ipairs(tags) do
									t = t.. " "..tag
								end
								t= t.." | mimiced rule tags:"
								for _,tag in ipairs(newtags) do
									t = t.. " "..tag
								end
								print(t)
							end
							
							if (limiter > limit) then
								MF_alert("Level destroyed - mimic happened too many times!")
								destroylevel("toocomplex")
								return
							end
						end
					end
				end
			end
		end
	end
end

function addbaserule(rule1,rule2,rule3,conds_,iskept_)
	local conds = conds_ or {}
	local rule = {rule1,rule2,rule3}
	local tag = {"base"}
	if iskept_ then tag = {"keep","base"} end

	addoption(rule,conds,{},false,nil,tag)
end

function grouprules()
	groupmembers = {}
	local groupmembers_quick = {}

	local isgroup = {}
	local isnotgroup = {}
	local xgroup = {}
	local xnotgroup = {}
	local groupx = {}
	local notgroupx = {}
	local groupxgroup = {}
	local groupxgroup_diffname = {}
	local groupisnotgroup = {}
	local notgroupisgroup = {}

	local evilrecursion = false
	local notgroupisgroup_diffname = {}

	local memberships = {}

	local combined = {}

	for i,v in ipairs(groupfeatures) do
		local rule = v[1]
		local conds = v[2]

		local type_isgroup = false
		local type_isnotgroup = false
		local type_xgroup = false
		local type_xnotgroup = false
		local type_groupx = false
		local type_notgroupx = false
		local type_recursive = false

		local groupname1 = ""
		local groupname2 = ""

		if (string.sub(rule[1], 1, 5) == "group") then
			type_groupx = true
			groupname1 = rule[1]
		elseif (string.sub(rule[1], 1, 9) == "not group") then
			type_notgroupx = true
			groupname1 = string.sub(rule[1], 5)
		end

		if (string.sub(rule[3], 1, 5) == "group") then
			type_xgroup = true
			groupname2 = rule[3]

			if (rule[2] == "is") then
				type_isgroup = true
			end
		elseif (string.sub(rule[3], 1, 9) == "not group") then
			type_xnotgroup = true
			groupname2 = string.sub(rule[3], 5)

			if (rule[2] == "is") then
				type_isnotgroup = true
			end
		end

		if (conds ~= nil) and (#conds > 0) then
			for a,cond in ipairs(conds) do
				local params = cond[2] or {}
				for c,param in ipairs(params) do
					if (string.sub(param, 1, 5) == "group") or (string.sub(param, 1, 9) == "not group") then
						type_recursive = true
						break
					end
				end
			end
		end

		if type_isgroup then
			if (type_groupx == false) and (type_notgroupx == false) then
				table.insert(isgroup, {v, type_recursive})

				if (memberships[rule[3]] == nil) then
					memberships[rule[3]] = {}
				end

				if (memberships[rule[3]][rule[1]] == nil) then
					memberships[rule[3]][rule[1]] = {}
				end

				table.insert(memberships[rule[3]][rule[1]], {v, type_recursive})
			elseif (type_notgroupx == false) then
				if (groupname1 == groupname2) then
					table.insert(groupxgroup, {v, type_recursive})
				else
					table.insert(groupxgroup_diffname, {v, type_recursive})
				end
			else
				if (groupname1 == groupname2) then
					table.insert(notgroupisgroup, {v, type_recursive})
				else
					evilrecursion = true
					table.insert(notgroupisgroup_diffname, {v, type_recursive})
				end
			end
		elseif type_xgroup then
			if (type_groupx == false) and (type_notgroupx == false) then
				table.insert(xgroup, {v, type_recursive})
			else
				table.insert(groupxgroup, {v, type_recursive})
			end
		elseif type_isnotgroup then
			if (type_groupx == false) and (type_notgroupx == false) then
				if (isnotgroup[rule[1]] == nil) then
					isnotgroup[rule[1]] = {}
				end

				table.insert(isnotgroup[rule[1]], {v, type_recursive})

				if (xnotgroup[rule[1]] == nil) then
					xnotgroup[rule[1]] = {}
				end

				table.insert(xnotgroup[rule[1]], {v, type_recursive})
			elseif (type_notgroupx == false) then
				if (groupname1 == groupname2) then
					table.insert(groupisnotgroup, {v, type_recursive})
				else
					table.insert(groupxgroup_diffname, {v, type_recursive})
				end
			else
				if (groupname1 == groupname2) then
					table.insert(groupxgroup, {v, type_recursive})
				else
					evilrecursion = true
					table.insert(notgroupisgroup_diffname, {v, type_recursive})
				end
			end
		elseif type_xnotgroup then
			if (xnotgroup[rule[1]] == nil) then
				xnotgroup[rule[1]] = {}
			end

			table.insert(xnotgroup[rule[1]], {v, type_recursive})
		elseif type_groupx then
			table.insert(groupx, {v, type_recursive})
		elseif type_notgroupx then
			table.insert(notgroupx, {v, type_recursive})
		end
	end

	local diffname_done = false
	local diffname_used = {}

	while (diffname_done == false) do
		diffname_done = true

		for i,v_ in ipairs(groupxgroup_diffname) do
			if (diffname_used[i] == nil) then
				local v = v_[1]
				local recursion = v_[2] or false

				local rule = v[1]
				local conds = v[2]
				local ids = v[3]
				local tags = v[4]

				local gn1 = rule[1]
				local gn2 = rule[3]

				local notrule = false
				if (string.sub(gn2, 1, 4) == "not ") then
					notrule = true
				end

				local newconds = {}
				newconds = copyconds(newconds,conds)

				for a,b_ in ipairs(isgroup) do
					local b = b_[1]
					local brec = b_[2] or recursion or false
					local grule = b[1]
					local gconds = b[2]
					local gtags = b[4]

					if (grule[3] == gn1) then
						diffname_used[i] = 1
						diffname_done = false

						newconds = copyconds(newconds,gconds)

						local newrule = {grule[1],"is",gn2}
						local newtags = concatenate(tags,gtags)

						if (notrule == false) then
							table.insert(isgroup, {{newrule,newconds,ids,newtags}, brec})
						else
							if (isnotgroup[grule[1]] == nil) then
								isnotgroup[grule[1]] = {}
							end

							table.insert(isnotgroup[grule[1]], {{newrule,newconds,ids,newtags}, brec})
						end
					end
				end
			end
		end
	end

	if evilrecursion then
		diffname_done = false
		local evilrec_id = ""
		local evilrec_id_base = ""
		local evilrec_memberships_base = {}
		local evilrec_memberships_quick = {}

		local evilrec_limit = 0

		for i,v in pairs(memberships) do
			evilrec_id_base = evilrec_id_base .. i
			for a,b in pairs(v) do
				evilrec_id_base = evilrec_id_base .. a

				if (evilrec_memberships_quick[i] == nil) then
					evilrec_memberships_quick[i] = {}
				end

				evilrec_memberships_quick[i][a] = b

				if (evilrec_memberships_base[i] == nil) then
					evilrec_memberships_base[i] = {}
				end

				evilrec_memberships_base[i][a] = b
			end
		end

		evilrec_id = evilrec_id_base

		while (diffname_done == false) and (evilrec_limit < 10) do
			local foundmembers = {}
			local foundid = evilrec_id_base

			for i,v in pairs(evilrec_memberships_base) do
				foundid = foundid .. i
				for a,b in pairs(v) do
					foundid = foundid .. a
				end
			end

			for i,v_ in ipairs(notgroupisgroup_diffname) do
				local v = v_[1]
				local recursion = v_[2] or false

				local rule = v[1]
				local conds = v[2]
				local ids = v[3]
				local tags = v[4]

				local notrule = false
				local gn1 = string.sub(rule[1], 5)
				local gn2 = rule[3]

				if (string.sub(gn2, 1, 4) == "not ") then
					notrule = true
					gn2 = string.sub(gn2, 5)
				end

				if (foundmembers[gn2] == nil) then
					foundmembers[gn2] = {}
				end

				for a,b in pairs(objectlist) do
					if (findnoun(a) == false) and ((evilrec_memberships_quick[gn1] == nil) or ((evilrec_memberships_quick[gn1] ~= nil) and (evilrec_memberships_quick[gn1][a] == nil))) then
						if (foundmembers[gn2][a] == nil) then
							foundmembers[gn2][a] = {}
						end

						table.insert(foundmembers[gn2][a], {v, recursion})
					end
				end
			end

			for i,v in pairs(foundmembers) do
				foundid = foundid .. i
				for a,b in pairs(v) do
					foundid = foundid .. a
				end
			end

			-- MF_alert(foundid .. " == " .. evilrec_id)

			if (foundid == evilrec_id) then
				diffname_done = true

				for i,v in pairs(foundmembers) do
					for a,d in pairs(v) do
						for c,b_ in ipairs(d) do
							local b = b_[1]
							local brule = b[1]
							local rec = b_[2] or false

							local newrule = {a,"is",brule[3]}
							local newconds = {}
							newconds = copyconds(newconds,b[2])
							local newids = concatenate(b[3])
							local newtags = concatenate(b[4])

							if (string.sub(brule[3], 1, 4) ~= "not ") then
								table.insert(isgroup, {{newrule,newconds,newids,newtags}, rec})
							else
								if (isnotgroup[a] == nil) then
									isnotgroup[a] = {}
								end

								table.insert(isnotgroup[a], {{newrule,newconds,newids,newtags}, rec})
							end
						end
					end
				end
			else
				evilrec_memberships_quick = {}
				evilrec_id = foundid

				for i,v in pairs(evilrec_memberships_base) do
					evilrec_memberships_quick[i] = {}

					for a,b in pairs(v) do
						evilrec_memberships_quick[i][a] = b
					end
				end

				for i,v in pairs(foundmembers) do
					evilrec_memberships_quick[i] = {}

					for a,b in pairs(v) do
						evilrec_memberships_quick[i][a] = b
					end
				end

				evilrec_limit = evilrec_limit + 1
			end
		end

		if (evilrec_limit >= 10) then
			HACK_INFINITY = 200
			destroylevel("infinity")
			return
		end
	end

	memberships = {}

	for i,v_ in ipairs(isgroup) do
		local v = v_[1]
		local recursion = v_[2] or false

		local rule = v[1]
		local conds = v[2]
		local ids = v[3]
		local tags = v[4]

		local name_ = rule[1]
		local namelist = {}

		if (string.sub(name_, 1, 4) ~= "not ") and (metatext_fixquirks or (name_ ~= "text" and string.sub(name_,1,4) ~= "meta")) then
			namelist = {name_}
		elseif (name_ ~= "not all") and (metatext_fixquirks or (name_ ~= "text" and string.sub(name_,1,4) ~= "meta")) then
			if string.sub(name_, 5, 9) == "text_" then --Exceptions for NOT METATEXT and NOT META#
				for a,b in pairs(fullunitlist) do
					if (string.sub(a, 1, 5) == "text_") and (a ~= string.sub(name_, 5)) then
						table.insert(namelist, a)
					end
				end
			elseif string.sub(name_, 5, 8) == "meta" then
				local level = string.sub(name_, 9)
				if tonumber(level) == nil then
					level = -2
				end
				for a,b in pairs(fullunitlist) do
					local metalevel = getmetalevel(a)
					if metalevel ~= tonumber(level) and (findnoun(a,nil,true) == false) and (metatext_includenoun or metalevel >= 0) then
						timedmessage(a,0,#namelist)
						table.insert(namelist, a)
					end
				end
			else
				for a,b in pairs(objectlist) do
					if (findnoun(a) == false) and (a ~= string.sub(name_, 5)) then
						table.insert(namelist, a)
					end
				end
			end
		end

		for index,name in ipairs(namelist) do
			local never = false

			local prevents = {}

			if (isnotgroup[name] ~= nil) then
				for a,b_ in ipairs(isnotgroup[name]) do
					local b = b_[1]
					local brule = b[1]

					local grouptype = string.sub(brule[3], 5)

					if (grouptype == rule[3]) then
						recursion = b_[2] or recursion
						local pconds,crashy,neverfound = invertconds(b[2])

						if (neverfound == false) then
							for a,cond in ipairs(pconds) do
								table.insert(prevents, cond)
							end
						else
							never = true
							break
						end
					end
				end
			end

			if (never == false) then
				local fconds = {}
				fconds = copyconds(fconds,conds)
				fconds = copyconds(fconds,prevents)

				table.insert(groupmembers, {name,fconds,rule[3],recursion,v[4]})

				if (groupmembers_quick[name .. "_" .. rule[3]] == nil) then
					groupmembers_quick[name .. "_" .. rule[3]] = {}
				end

				table.insert(groupmembers_quick[name .. "_" .. rule[3]], {name,fconds,rule[3],recursion})

				if (memberships[rule[3]] == nil) then
					memberships[rule[3]] = {}
				end

				table.insert(memberships[rule[3]], {name,fconds,v[4]})

				for a,b_ in ipairs(groupx) do
					local b = b_[1]
					recursion = b_[2] or recursion

					local grule = b[1]
					local gconds = b[2]
					local gids = b[3]
					local gtags = b[4]

					if (grule[1] == rule[3]) then
						local newrule = {name,grule[2],grule[3]}
						local newconds = {}
						local newids = concatenate(ids,gids)
						local newtags = concatenate(tags,gtags)

						newconds = copyconds(newconds,conds)
						newconds = copyconds(newconds,gconds)

						if (#prevents == 0) and name_ ~= "text" and string.sub(name_,1,4) ~= "meta" then
							table.insert(combined, {newrule,newconds,newids,newtags})
						elseif name_ ~= "text" and string.sub(name_,1,4) ~= "meta" then
							newconds = copyconds(newconds,prevents)
							table.insert(combined, {newrule,newconds,newids,newtags})
						end
					end
				end
			end
		end
	end

	for i,v_ in ipairs(groupxgroup) do
		local v = v_[1]
		local recursion = v_[2] or false

		local rule = v[1]
		local conds = v[2]
		local ids = v[3]
		local tags = v[4]

		local gn1 = rule[1]
		local gn2 = rule[3]

		local never = false

		local notrule = false
		if (string.sub(gn1, 1, 4) == "not ") then
			notrule = true
			gn1 = string.sub(gn1, 5)
		end

		local prevents = {}
		if (xnotgroup[gn1] ~= nil) then
			for a,b_ in ipairs(xnotgroup[gn1]) do
				local b = b_[1]
				local brule = b[1]

				if (brule[1] == rule[1]) and (brule[2] == rule[2]) and (brule[3] == "not " .. rule[3]) then
					recursion = b_[2] or recursion

					local pconds,crashy,neverfound = invertconds(b[2])

					if (neverfound == false) then
						for a,cond in ipairs(pconds) do
							table.insert(prevents, cond)
						end
					else
						never = true
						break
					end
				end
			end
		end

		if (never == false) then
			local team1 = {}
			local team2 = {}

			if (notrule == false) then
				if (memberships[gn1] ~= nil) then
					for a,b in ipairs(memberships[gn1]) do
						table.insert(team1, b)
					end
				end
			else
				local ignorethese = {}

				if (memberships[gn1] ~= nil) then
					for a,b in ipairs(memberships[gn1]) do
						ignorethese[b[1]] = 1

						local iconds,icrash,inever = invertconds(b[2])

						if (inever == false) then
							table.insert(team1, {b[1],iconds,b[3]})
						end
					end
				end

				for a,b in pairs(objectlist) do
					if (findnoun(a) == false) and (ignorethese[a] == nil) then
						table.insert(team1, {a})
					end
				end
			end

			if (memberships[gn2] ~= nil) then
				for a,b in ipairs(memberships[gn2]) do
					table.insert(team2, b)
				end
			end

			for a,b in ipairs(team1) do
				for c,d in ipairs(team2) do
					local newrule = {b[1],rule[2],d[1]}
					local newconds = {}
					newconds = copyconds(newconds,conds)

					if (b[2] ~= nil) then
						newconds = copyconds(newconds,b[2])
					end

					if (d[2] ~= nil) then
						newconds = copyconds(newconds,d[2])
					end

					if (#prevents > 0) then
						newconds = copyconds(newconds,prevents)
					end

					local newids = concatenate(ids)
					local newtags = concatenate(tags)

					table.insert(combined, {newrule,newconds,newids,newtags})
				end
			end
		end
	end

	if (#notgroupx > 0) then
		for name,v in pairs(objectlist) do
			if (findnoun(name) == false) then
				for a,b_ in ipairs(notgroupx) do
					local b = b_[1]
					local recursion = b_[2] or false

					local rule = b[1]
					local conds = b[2]
					local ids = b[3]
					local tags = b[4]

					local newconds = {}
					newconds = copyconds(newconds,conds)

					local groupname = string.sub(rule[1], 5)
					local valid = true

					if (groupmembers_quick[name .. "_" .. groupname] ~= nil) then
						for c,d in ipairs(groupmembers_quick[name .. "_" .. groupname]) do
							recursion = d[4] or recursion

							local iconds,icrash,inever = invertconds(d[2])
							newconds = copyconds(newconds,iconds)

							if inever then
								valid = false
								break
							end
						end
					end

					if valid then
						local newrule = {name,rule[2],rule[3]}
						local newids = {}
						local newtags = {}
						newids = concatenate(newids,ids)
						newtags = concatenate(newtags,tags)

						table.insert(combined, {newrule,newconds,newids,newtags})
					end
				end
			end
		end
	end

	for i,v_ in ipairs(xgroup) do
		local v = v_[1]
		local recursion = v_[2] or false

		local rule = v[1]
		local conds = v[2]
		local ids = v[3]
		local tags = v[4]

		if (string.sub(rule[1], 1, 5) ~= "group") and (string.sub(rule[1], 1, 9) ~= "not group") and (rule[2] ~= "is") then
			local team2 = {}

			if (memberships[rule[3]] ~= nil) then
				for a,b in ipairs(memberships[rule[3]]) do
					local foundtag = false
					if metatext_fixquirks and (rule[2] == "become" or rule[2] == "has" or rule[2] == "make" or rule[2] == "write") and b[1] ~= "text" and string.sub(b[1],1,4) ~= "meta" then
						for num,tag in ipairs(b[3]) do
							if tag == "text" or string.sub(tag,1,4) == "meta" then
								foundtag = true
								break
							end
						end
					elseif (b[1] == "text" or string.sub(b[1],1,4) == "meta") and (rule[2] ~= "become" and rule[2] ~= "has" and rule[2] ~= "make" and rule[2] ~= "write") then
						foundtag = true
					end
					if not foundtag then
						table.insert(team2, b)
					end
				end
			end

			for a,b in ipairs(team2) do
				local newrule = {rule[1],rule[2],b[1]}
				local newconds = {}
				newconds = copyconds(newconds,conds)

				if (b[2] ~= nil) then
					newconds = copyconds(newconds,b[2])
				end

				local newids = concatenate(ids)
				local newtags = concatenate(tags)

				table.insert(combined, {newrule,newconds,newids,newtags})
			end
		end
	end

	for i,k in pairs(xnotgroup) do
		for c,v_ in ipairs(k) do
			local v = v_[1]
			local recursion = v_[2] or false

			local rule = v[1]
			local conds = v[2]
			local ids = v[3]
			local tags = v[4]

			if (string.sub(rule[1], 1, 5) ~= "group") and (string.sub(rule[1], 1, 9) ~= "not group") and (rule[2] ~= "is") then
				local team2 = {}

				local gn2 = string.sub(rule[3], 5)

				if (memberships[gn2] ~= nil) then
					for a,b in ipairs(memberships[gn2]) do
						table.insert(team2, b)
					end
				end

				for a,b in ipairs(team2) do
					local newrule = {rule[1],rule[2],"not " .. b[1]}
					local newconds = {}
					newconds = copyconds(newconds,conds)

					if (b[2] ~= nil) then
						newconds = copyconds(newconds,b[2])
					end

					local newids = concatenate(ids)
					local newtags = concatenate(tags)

					table.insert(combined, {newrule,newconds,newids,newtags})
				end
			end
		end
	end

	for i,v_ in ipairs(groupisnotgroup) do
		local v = v_[1]
		local recursion = v_[2] or false

		local rule = v[1]
		local conds = v[2]
		local ids = v[3]
		local tags = v[4]

		local team1 = {}

		if (memberships[rule[1]] ~= nil) then
			for a,b in ipairs(memberships[rule[1]]) do
				table.insert(team1, b)
			end
		end

		for a,b in ipairs(team1) do
			local newrule = {b[1],"is","crash"}
			local newconds = {}
			newconds = copyconds(newconds,conds)

			if (b[2] ~= nil) then
				newconds = copyconds(newconds,b[2])
			end

			local newids = concatenate(ids)
			local newtags = concatenate(tags)

			table.insert(combined, {newrule,newconds,newids,newtags})
		end
	end

	for i,v_ in ipairs(notgroupisgroup) do
		local v = v_[1]
		local recursion = v_[2] or false

		local rule = v[1]
		local conds = v[2]
		local ids = v[3]
		local tags = v[4]

		local team1 = {}

		local gn1 = string.sub(rule[1], 5)

		local ignorethese = {}

		if (memberships[gn1] ~= nil) then
			for a,b in ipairs(memberships[gn1]) do
				ignorethese[b[1]] = 1

				local iconds,icrash,inever = invertconds(b[2])

				if (inever == false) then
					table.insert(team1, {b[1],iconds})
				end
			end
		end

		for a,b in pairs(objectlist) do
			if (findnoun(a) == false) and (ignorethese[a] == nil) then
				table.insert(team1, {a})
			end
		end

		for a,b in ipairs(team1) do
			local newrule = {b[1],"is","crash"}
			local newconds = {}
			newconds = copyconds(newconds,conds)

			if (b[2] ~= nil) then
				newconds = copyconds(newconds,b[2])
			end

			local newids = concatenate(ids)
			local newtags = concatenate(tags)

			table.insert(combined, {newrule,newconds,newids,newtags})
		end
	end

	for i,v in ipairs(combined) do
		addoption(v[1],v[2],v[3],false,nil,v[4])
	end
end
function ruleblockeffect()
	local handled = {}
	
	for i,rules in pairs(features) do
		local rule = rules[1]
		local conds = rules[2]
		local ids = rules[3]
		local tags = rules[4]
		local blocked = false
		local glyphrule = false
		if (tags[1] == "glyphrule") then
			glyphrule = true	
		end
		
		for a,b in ipairs(conds) do
			if (b[1] == "never") then
				blocked = true
				break
			end
		end
		
		--MF_alert(rule[1] .. " " .. rule[2] .. " " .. rule[3] .. ": " .. tostring(blocked))
		
		if blocked then
			for a,d in ipairs(ids) do
				for c,b in ipairs(d) do
					if (handled[b] == nil) and not glyphrule then
						local runit = mmf.newObject(b)
						
						local blockid = MF_create("Ingame_blocked")
						local bunit = mmf.newObject(blockid)
						
						bunit.x = runit.x
						bunit.y = runit.y
						
						bunit.values[XPOS] = runit.values[XPOS]
						bunit.values[YPOS] = runit.values[YPOS]
						bunit.layer = 1
						bunit.values[ZLAYER] = 20
						bunit.values[TYPE] = b
						
						bunit.scaleX = spritedata.values[TILEMULT] * generaldata2.values[ZOOM]
						bunit.scaleY = spritedata.values[TILEMULT] * generaldata2.values[ZOOM]
						
						bunit.visible = runit.visible
						
						local c1,c2 = getuicolour("blocked")
						MF_setcolour(blockid,c1,c2)
						
						handled[b] = 2
					elseif (handled[b] == nil) then
						local runit = mmf.newObject(b)
						MF_setcolour(b,0,1)

						local blockid = MF_create("Ingame_blocked")
						local bunit = mmf.newObject(blockid)
						
						bunit.x = runit.x
						bunit.y = runit.y
						
						bunit.values[XPOS] = runit.values[XPOS]
						bunit.values[YPOS] = runit.values[YPOS]
						bunit.layer = 1
						bunit.values[ZLAYER] = 20
						bunit.values[TYPE] = b
						
						bunit.scaleX = spritedata.values[TILEMULT] * generaldata2.values[ZOOM]
						bunit.scaleY = spritedata.values[TILEMULT] * generaldata2.values[ZOOM]
						
						bunit.visible = runit.visible
						
						local c1,c2 = getuicolour("blocked")
						MF_setcolour(blockid,0,0)
						
						handled[b] = 2
					end
				end
			end
		else
			for a,d in ipairs(ids) do
				for c,b in ipairs(d) do
					if (handled[b] == nil) then
						handled[b] = 1
					elseif (handled[b] == 2) then
						MF_removeblockeffect(b)
						if glyphrule then
							local runit = mmf.newObject(b)
							local name = getname(runit,"glyph")
							if name == "glyph" then
								setcolour(b, "active")
							else
								setcolour(b)
							end
						end
					end
				end
			end
		end
	end
end