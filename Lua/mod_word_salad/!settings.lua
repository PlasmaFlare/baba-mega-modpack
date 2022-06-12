-- If true, the music will still play when there are only vessels on the level
MUSIC_WHEN_ONLY_VESSELS = false

-- If true, objects that are HOP will spawn some particles after a successful jump
DO_HOP_PARTICLES = true

function apply_word_salad_settings(settings_dict)
    for setting_name, value in pairs(settings_dict) do
        if setting_name == "music_when_only_vessels" then
            MUSIC_WHEN_ONLY_VESSELS = value
        elseif setting_name == "do_hop_particles" then
            DO_HOP_PARTICLES = value
        end
    end
end