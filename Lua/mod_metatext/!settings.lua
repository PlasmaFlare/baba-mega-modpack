--[[ This file is named this way to make sure it runs first.
Obviously, this is ripping off- I mean, INSPIRED by Plasmaflare's.]]

-- Function to see if the meta and unmeta file is included.
local function check_meta_existence()
  if editor_objlist["text_meta"] == nil then
    return true
  end
  return false
end

-- Set up the settings.
metatext_settings_list = {
  fix_quirks = {
    buttonfunc = "mtxt_quirks", --The button func.
    boolean = true, -- If the two values are True and False, set this to True.
    default = true, -- The default value.
    name = "Fix issues with parity", -- Name that shows up in the menu.
    tooltip = "Forces vanilla behavior when using TEXT/META# IS TELE and TEXT IS GROUP.", --Tooltip.
  },
  overlay_style = {
    buttonfunc = "mtxt_overlay", --The button func.
    options = { --Name of available options. Value is set as a number.
      "None",
      "Wrong sprite",
      "Always",
    },
    default = 0, -- The default value.
    name = "Metatext Overlay", -- Name that shows up in the menu.
    tooltip = "Displays a number in the top right corner of metatext.", --Tooltip.
    tooltip_extra = { -- Additional info for each option.
      "This option disables this feature.",
      "This option enables this feature if the sprite used does not match.",
      "This option always enables this feature.",
    },
  },
  text_word = {
    buttonfunc = "mtxt_word", --The button func.
    boolean = true, -- If the two values are True and False, set this to True.
    default = false, -- The default value.
    name = "Text Is Word", -- Name that shows up in the menu.
    tooltip = "Makes TEXT IS WORD a base rule, and breaking it makes text not parse.", --Tooltip.
  },
  is_nometa = {
    buttonfunc = "mtxt_isnometa", --The button func.
    boolean = true, -- If the two values are True and False, set this to True.
    default = false, -- The default value.
    name = "'Metatext is text' disables transform", -- Name that shows up in the menu.
    tooltip = "Makes METATEXT IS TEXT disables transformation for the object instead of meta-fying it.", --Tooltip.
  },
  hasmake_nometa = {
    buttonfunc = "mtxt_othnometa", --The button func.
    boolean = true, -- If the two values are True and False, set this to True.
    default = false, -- The default value.
    name = "'Metatext has/make/become text' refers to text word", -- Name that shows up in the menu.
    tooltip = "Makes METATEXT HAS/MAKE/BECOME TEXT refer to the 'text' word instead of the text referring to it.", --Tooltip.
  },
  auto_gen = {
    buttonfunc = "mtxt_autogen", --The button func.
    options = { --Name of available options. Value is set as a number.
      "Never",
      "Try correct sprite",
      "Force correct sprite",
      "Always same sprite",
    },
    default = 0, -- The default value.
    name = "Automatically generate metatext", -- Name that shows up in the menu.
    tooltip = "Creates more metatext if it does not exist.", --Tooltip.
    tooltip_extra = { -- Additional info for each option.
      "This option disables this feature.",
      "This option enables this feature and tries to use the appropriate sprite.",
      "This option enables this feature, but only if the right sprite exists.",
      "This option enables this feature, and always uses the original sprite.",
    },
    disable = check_meta_existence -- Will disable if this function retures true
  },
  better_disp = {
    buttonfunc = "mtxt_betterdisp", --The button func.
    boolean = true, -- If the two values are True and False, set this to True.
    default = true, -- The default value.
    name = "Better Overlay Display", -- Name that shows up in the menu.
    tooltip = "Makes overlay display now include the glyph prefixes.", --Tooltip.
  },
  include_noun = {
    buttonfunc = "mtxt_include", --The button func.
    boolean = true, -- If the two values are True and False, set this to True.
    default = false, -- The default value.
    name = "NOT META(x) includes META-1", -- Name that shows up in the menu.
    tooltip = "Makes META-1 included in NOT META# (Unless it's NOT META-1, of course).", --Tooltip.
  },
}
metatext_settings_order = {
  "fix_quirks",
  "text_word",
  "is_nometa",
  "hasmake_nometa",
  "overlay_style",
  "auto_gen",
  "include_noun",
  "better_disp",
}

-- Adds the setting button.
function settingbutton()
  if generaldata.values[MODE] == 5 then --So it doesn't run when you start the pack outside of the editor
    createbutton("metatext_settings",40,30,0,2,2,"","level",3,2,menufuncs.level.button,false,false,"Metatext Mod Settings",bicons.cog)
  end
end

-- @Merge: commented out since we want it to show in mega modpack settings
-- -- Add the button. It's done the same way Plasma did it.
-- if old_menu_level_enter == nil then
--   old_menu_level_enter = menufuncs.level.enter
-- end
-- -- @Merge(injection)
-- menufuncs.level.enter = function(...)
--   settingbutton()
--   old_menu_level_enter(...)
-- end
-- settingbutton() -- This doesn't work the first time for some reason, so we have to do this.

-- The menu
menufuncs.metatext_settings = {
  button = "mtxt_settings",
  escbutton = "mtxt_return",
  slide = {1,0},
  enter =
    function(parent,name,buttonid)
      MF_letterclear("leveltext")

      local dynamic_structure = {}

      local x = screenw * 0.5
      local y = 1.5 * f_tilesize
      writetext("$4,1Metatext Mod Settings",0,x,y,"settingsmenu",true,2)
      y = y + f_tilesize

      for i,setname in ipairs(metatext_settings_order) do
        local data = metatext_settings_list[setname]
        local disabled = false
        if data.disable ~= nil then
          disabled = data.disable()
        end
        writetext(data.name,0,30,y,"settingsmenu",false,1)
        y = y + f_tilesize
        if data.boolean == true then
          local butx = 60
          local selected = get_setting(setname,true) or 0
          local width = getdynamicbuttonwidth(langtext("yes"))
          local thisx = butx + ((#langtext("yes")/2)-1.5) * 10
          createbutton(data.buttonfunc .. "_0",thisx,y,2,width,1,langtext("yes"),name,3,2,buttonid,disabled,selected,data.tooltip,nil,true)
          butx = thisx + 55 + (#langtext("yes")/2+1) * 10
          width = getdynamicbuttonwidth(langtext("no"))
          thisx = butx + ((#langtext("no")/2)-1.5) * 10
          createbutton(data.buttonfunc .. "_1",thisx,y,2,width,1,langtext("no"),name,3,2,buttonid,disabled,(selected + 1) % 2,data.tooltip,nil,true)
          table.insert(dynamic_structure,{{data.buttonfunc .. "_0"},{data.buttonfunc .. "_1"}})
        else
          local dynamic_structure_row = {}
          local value = get_setting(setname) or -1
          local butx = 60
          for i,option in ipairs(data.options) do
            local width = getdynamicbuttonwidth(option)
            local thisx = butx + ((#option/2)-1.5) * 10
            local tooltip = data.tooltip .. " " .. data.tooltip_extra[i]
            local selected = 0
            if value == i - 1 then
              selected = 1
            end
            createbutton(data.buttonfunc .. "_" .. i-1,thisx,y,2,width,1,option,name,3,2,buttonid,disabled,selected,tooltip,nil,true)
            butx = thisx + 55 + (#option/2+1) * 10
            table.insert(dynamic_structure_row, {data.buttonfunc .. "_" .. i-1})
          end
          table.insert(dynamic_structure,dynamic_structure_row)
        end
        y = y + f_tilesize
      end

      createbutton("mtxt_return",x,y,2,18,1,langtext("return"),name,3,2,buttonid)
      table.insert(dynamic_structure,{{"mtxt_return"}})

      buildmenustructure(dynamic_structure)
    end,
  leave =
    function(parent,name,buttonid)
      MF_letterclear("settingsmenu")
    end,
}

function get_setting(setting,raw)
  local value = tonumber(MF_read("world","Metatext Mod",setting))
  if value ~= nil then
    if (not raw) and metatext_settings_list[setting].boolean == true then
      if tonumber(value) == 0 then
        return false
      else
        return true
      end
    else
      return tonumber(value)
    end
  else
    if metatext_settings_list[setting] ~= nil then
      if raw and metatext_settings_list[setting].boolean then
        if metatext_settings_list[setting].default == true then
          return 1
        else
          return 0
        end
      else
        return metatext_settings_list[setting].default
      end
    else
      error(setting .. " not defined!")
    end
  end
end

buttonclick_list["metatext_settings"] = function()
  changemenu("metatext_settings")
end
buttonclick_list["mtxt_return"] = function()
  changemenu("level")
end
for setname,data in pairs(metatext_settings_list) do
  if data.boolean == true then
    buttonclick_list[data.buttonfunc .. "_0"] = function()
      MF_store("world","Metatext Mod",setname,1)
      local buttons = MF_getbutton(data.buttonfunc .. "_0")
    	if (#buttons > 0) then
    		for i,v in ipairs(buttons) do
    			updatebuttoncolour(v,1)
    		end
    	end
      buttons = MF_getbutton(data.buttonfunc .. "_1")
    	if (#buttons > 0) then
    		for i,v in ipairs(buttons) do
          updatebuttoncolour(v,0)
    		end
    	end
    end
    buttonclick_list[data.buttonfunc .. "_1"] = function()
      MF_store("world","Metatext Mod",setname,0)
      local buttons = MF_getbutton(data.buttonfunc .. "_0")
      if (#buttons > 0) then
    		for i,v in ipairs(buttons) do
    			updatebuttoncolour(v,0)
    		end
    	end
      buttons = MF_getbutton(data.buttonfunc .. "_1")
    	if (#buttons > 0) then
    		for i,v in ipairs(buttons) do
          updatebuttoncolour(v,1)
    		end
    	end
    end
  else
    for i,option in ipairs(data.options) do
      buttonclick_list[data.buttonfunc .. "_" .. i-1] = function()
        MF_store("world","Metatext Mod",setname,i-1)
        for num,othoption in ipairs(data.options) do
          local buttons = MF_getbutton(data.buttonfunc .. "_" .. num-1)
          if (#buttons > 0) then
            for a,v in ipairs(buttons) do
              if num == i then
                updatebuttoncolour(v,1)
              else
                updatebuttoncolour(v,0)
              end
            end
          end
        end
      end
    end
  end
end
