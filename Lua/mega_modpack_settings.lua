local mega_modpack_version = "1.1.0"
local mega_modpack_name = string.format("Mega Modpack V%s - by Plasmaflare", mega_modpack_version)
local mega_modpack_name_with_color = string.format("Mega Modpack V%s - by $1,4Plasma$3,4flare$0,3", mega_modpack_version)

local mod_list = {
    {name = "Plasma's Modpack", author = "Plasmaflare", color={4,4}},
    {name = "Patashu's Modpack", author = "Patashu", color={3,1}},
    {name = "Persist", author = "Randomizer", color={0,3}},
    {name = "Past", author = "Emily (Aka. EvanEMV)", color={3,1}},
    {name = "Stringwords", author = "Wrecking Games", color={3,4}},
    {name = "Word Salad", author = "Huebird", color={2,1}},
}

local function setfenv(fn, env)
    local i = 1
    while true do
    local name = debug.getupvalue(fn, i)
    if name == "_ENV" then
        debug.upvaluejoin(fn, i, (function()
        return env
        end), 1)
        break
    elseif not name then
        break
    end

    i = i + 1
    end

    return fn
end

local function restore_original_levelpack_menufunc()
    local new_env = {}
    setmetatable(new_env, {__index = _G})

    local f, err = loadfile("Data/Editor/editor_menudata.lua")
    assert(f, err)
    setfenv(f, new_env)
    local status, err = pcall(f)
    assert(status, err)

    for k,v in pairs(new_env) do
        print(k)
    end

    menufuncs.level.enter = new_env.menufuncs.level.enter
end
restore_original_levelpack_menufunc()

local function make_plasma_button(buttonfunc, name, buttonid, label, x, y, selected, tooltip)
    local width = (#label + 4) * baba_font_consts.total_letter_w
    local scale = width / baba_font_consts.button_w
    local final_x = x + width / 2
    createbutton(buttonfunc,final_x,y,2,scale,1,label,name,3,2,buttonid, nil, selected, tooltip)
end

local function write_settings_header(title, c1, c2, name)
    local c1_str = tostring(c1)
    local c2_str = tostring(c2)
    writetext(title, -1, screenw * 0.5, f_tilesize, name, true)
    writetext("$"..c1_str..","..c2_str.."---------------------------------------------------------------------------------$0,3", -1, 20, f_tilesize * 2, name)
    writetext("$"..c1_str..","..c2_str.."---------------------------------------------------------------------------------$0,3", -1, 20, screenh - f_tilesize * 2, name)
end

local function read_setting(section, setting_data)
    local value = MF_read("world",section,setting_data.name)
    if #value == 0 then
        value = setting_data.default
    end
    return value
end

local function display_modpack_setting_button()
    local buttonstring = "Mega Modpack Settings"
    local x = screenw-( (#buttonstring + 5) * baba_font_consts.total_letter_w)
    local y = f_tilesize * 1.5
    make_plasma_button("mega_modpack_settings", "level", menufuncs.level.button, buttonstring, x, y, false)
end
display_modpack_setting_button()

local old_level_func = menufuncs.level.enter
menufuncs.level.enter = function(...)
    old_level_func(...)
    display_modpack_setting_button()
end

menufuncs.mega_modpack_settings = {
    button = "MegaModpackSettings",
    escbutton = "mega_mod_return",
    slide = {1,0},
    enter = function(parent,name,buttonid,extra)
        MF_letterclear("leveltext")
        MF_cursorvisible(0) -- Letting this be off until Hempuli fixes "escbutton" field not working

        write_settings_header("Mega Modpack Settings", 0, 3, name)

        
        -- Render sub-settings buttons
        local item_x = screenw * 0.1
        local item_y = f_tilesize
        createbutton("mega_mod_return",screenw * 0.15,item_y,2,8,1,langtext("return"),name,3,2,buttonid)

        -- Render sub-settings buttons
        item_y = item_y + f_tilesize * 3        
        make_plasma_button("pfsettings", name, buttonid, "Plasma Modpack Settings", item_x,item_y, false)
        item_y = item_y + f_tilesize * 2
        make_plasma_button("patashu_settings", name, buttonid, "Patashu's Modpack Settings", item_x,item_y, false)
        item_y = item_y + f_tilesize * 2
        make_plasma_button("word_salad_settings", name, buttonid, "Word Salad Settings", item_x,item_y, false)
        item_y = item_y + f_tilesize * 2


        item_x = screenw * 0.5
        item_y = f_tilesize * 4
        writetext("Full list of mods and their authors:", -1, item_x, item_y, name)

        for _, mod_info in ipairs(mod_list) do
            item_y = item_y + f_tilesize
            writetext(string.format("$0,2♄ %s - $%d,%d%s$0,3", mod_info.name, mod_info.color[1], mod_info.color[2], mod_info.author), -1, item_x, item_y, name)
        end
        item_y = item_y + f_tilesize * 2
        writetext("...Damn, that's a lot of mods.", -1, item_x, item_y, name)

        -- make_plasma_button("metatextsettings", name, buttonid, "Metatext Settings", screenw * 0.15,item_y, false)

        local version_x = screenw-(#mega_modpack_name * 10) - 20
        local version_y = screenh - f_tilesize
        writetext(mega_modpack_name_with_color, -1, version_x, version_y, name)
    end
}
buttonclick_list["mega_modpack_settings"] = function()
    MF_menubackground(true)
    changemenu("mega_modpack_settings")
end
buttonclick_list["mega_mod_return"] = function()
    MF_menubackground(false)
    changemenu("level")
end
buttonclick_list["pfreturn"] = function()
    changemenu("mega_modpack_settings")
end

buttonclick_list["patashu_settings"] = function()
    changemenu("patashu_settings")
end

buttonclick_list["word_salad_settings"] = function()
    changemenu("word_salad_settings")
end



--[[ PATASHU SETTINGS ]]
local patashu_settings = {
    very_drunk = {
        name = "very_drunk",
        display = "Very drunk",
        default = 1,
        buttonfunc = "patashudrunk",
        tooltip = "If true, MOONWALK and related properties (DRUNK, DRUNKER, SKIP) apply to PUSH, PULL, SHIFT, YEET and more. Defaults to true"
    },
    float_breaks_sticky = {
        name = "float_breaks_sticky",
        display = "Float breaks sticky",
        default = 1,
        buttonfunc = "patashufloatsticky",
        tooltip = "If true, two things at different float values can't stick together. Defaults to true"
    },
    very_sticky = {
        name = "very_sticky",
        display = "Very sticky",
        default = 0,
        buttonfunc = "patashusticky",
        tooltip = "If true, two things with different names can stick together. Defaults to false"
    },
}
local patashu_settings_order = {"very_drunk", "float_breaks_sticky", "very_sticky"}
local patashu_settings_section = "Patashu's Mods"

menufuncs.patashu_settings = {
    button = "PatashuModpackSettings",
    escbutton = "mega_return",
    slide = {1,0},
    enter = function(parent,name,buttonid,extra)
        MF_letterclear("leveltext")
        MF_cursorvisible(0) -- Letting this be off until Hempuli fixes "escbutton" field not working

        write_settings_header("$3,1Patashu's$0,3 Modpack Settings", 3, 1, name)

        local item_x = screenw * 0.1
        local item_y = f_tilesize
        createbutton("pfreturn",screenw * 0.15,item_y,2,8,1,langtext("return"),name,3,2,buttonid)
        item_y = item_y + f_tilesize * 3 

        for _, setting_name in ipairs(patashu_settings_order) do
            local data = patashu_settings[setting_name]
            local toggle = read_setting(patashu_settings_section, data)
            local togglevalue, color = gettoggle(toggle)
            make_plasma_button(data.buttonfunc, name, buttonid, data.display, item_x, item_y, togglevalue, data.tooltip)
            
            item_y = item_y + f_tilesize * 2
        end
    end
}

for setting_name, data in pairs(patashu_settings) do
    buttonclick_list[data.buttonfunc] = function()
        local toggle = read_setting(patashu_settings_section, data)
        local togglevalue, color = gettoggle(toggle)

        if togglevalue == 1 then
            togglevalue = 0
        else
            togglevalue = 1
        end
        MF_store("world", patashu_settings_section, setting_name, togglevalue)

        local buttons = MF_getbutton(data.buttonfunc)
        for i,unitid in ipairs(buttons) do
            updatebuttoncolour(unitid, togglevalue)
        end
    end
end

--[[ WORD SALAD SETTINGS ]]
local word_salad_settings = {
    music_when_only_vessels = {
        name = "music_when_only_vessels",
        display = "Music when only vessels",
        default = 0,
        buttonfunc = "ws_musicOnOnlyVessels",
        tooltip = "If true, the music will still play when there are only vessels on the level"
    },
    do_hop_particles = {
        name = "do_hop_particles",
        display = "Do hop particles",
        default = 1,
        buttonfunc = "ws_hopParticles",
        tooltip = "If true, objects that are HOP will spawn some particles after a successful jump"
    },
}

local word_salad_settings_order = {"music_when_only_vessels", "do_hop_particles"}
local word_salad_settings_section = "Word Salad"

menufuncs.word_salad_settings = {
    button = "WordSaladSettings",
    escbutton = "pfreturn",
    slide = {1,0},
    enter = function(parent,name,buttonid,extra)
        MF_letterclear("leveltext")
        MF_cursorvisible(0) -- Letting this be off until Hempuli fixes "escbutton" field not working

        write_settings_header("$2,1Word Salad$0,3 Settings", 2, 1, name)

        local item_x = screenw * 0.1
        local item_y = f_tilesize
        createbutton("pfreturn",screenw * 0.15,item_y,2,8,1,langtext("return"),name,3,2,buttonid)
        item_y = item_y + f_tilesize * 3 

        for _, setting_name in ipairs(word_salad_settings_order) do
            local data = word_salad_settings[setting_name]
            local toggle = read_setting(word_salad_settings_section, data)
            local togglevalue, color = gettoggle(toggle)
            make_plasma_button(data.buttonfunc, name, buttonid, data.display, item_x, item_y, togglevalue, data.tooltip)
            
            item_y = item_y + f_tilesize * 2
        end
    end
}

for setting_name, data in pairs(word_salad_settings) do
    buttonclick_list[data.buttonfunc] = function()
        local toggle = read_setting(word_salad_settings_section, data)
        local togglevalue, color = gettoggle(toggle)

        if togglevalue == 1 then
            togglevalue = 0
        else
            togglevalue = 1
        end
        MF_store("world", word_salad_settings_section, setting_name, togglevalue)

        local buttons = MF_getbutton(data.buttonfunc)
        for i,unitid in ipairs(buttons) do
            updatebuttoncolour(unitid, togglevalue)
        end
    end
end

table.insert(mod_hook_functions["level_start"], 
    function()
        for setting_name, data in pairs(patashu_settings) do
            local value = read_setting(patashu_settings_section, data)
            local togglevalue = gettoggle(value)

            if setting_name == "very_drunk" then
                very_drunk = togglevalue == 1
            elseif setting_name == "float_breaks_sticky" then
                float_breaks_sticky = togglevalue == 1
            elseif setting_name == "very_sticky" then
                very_sticky = togglevalue == 1
            end

        end

        for setting_name, data in pairs(word_salad_settings) do
            local value = read_setting(word_salad_settings_section, data)
            local togglevalue = gettoggle(value)

            if setting_name == "music_when_only_vessels" then
                MUSIC_WHEN_ONLY_VESSELS = togglevalue == 1
            elseif setting_name == "do_hop_particles" then
                DO_HOP_PARTICLES = togglevalue == 1
            end

        end
    end
)