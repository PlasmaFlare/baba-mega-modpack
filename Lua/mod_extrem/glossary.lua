-- Support for the Word Glossary
if keys.IS_WORD_GLOSSARY_PRESENT then
    keys.WORD_GLOSSARY_FUNCS.register_author("Extrem", nil, "$4,2Extrem <3")

    keys.WORD_GLOSSARY_FUNCS.add_entries_to_word_glossary({
        {
            name = "infinite_loop",
            thumbnail_obj = "text_crash",
            display_name = "crash",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[If anything has this property, then it will trigger an infinite loop screen.]],
        },
        {
            name = "survive_level_destruction",
            thumbnail_obj = "text_eternal",
            display_name = "survive level destruction",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[Properties that let objects survive level destruction.
    
Eternal is only for infinite loops, whilst secure works for everything.]],
            display_sprites = { "text_eternal", "text_secure" }
        },
        {
            name = "draw",
            thumbnail_obj = "text_draw",
            display_name = "draw",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[A verb that only accepts letters as the last argument.

Doing "paper draw a" turns paper into a text_a.

This does not accept multiletters.]],
        },
        {
            name = "jot",
            thumbnail_obj = "text_jot",
            display_name = "jot",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[A verb that only accepts letters as the last argument.

Doing "paper jot a" makes paper drop a text_a when it is destroyed.

This does not accept multiletters.]],
        },
        {
            name = "type",
            thumbnail_obj = "text_type",
            display_name = "type",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[A verb that only accepts letters as the last argument.

Doing "paper type a" makes paper spawn a text_a every turn, like make.

This does not accept multiletters.]],
        },
        {
            name = "watch",
            thumbnail_obj = "text_watch",
            display_name = "watch",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[Anything in front of an object that is watch(NUMBER) is "watched(NUMBER)".]],
            display_sprites = { "text_watch", "text_watch2", "text_watch3" }
        },
        {
            name = "watched",
            thumbnail_obj = "text_watched",
            display_name = "watched",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[See "watch".]],
            display_sprites = { "text_watched", "text_watched2", "text_watched3" }
        },
        {
            name = "feeling_prefixes",
            thumbnail_obj = "text_hidden",
            display_name = "feeling prefixes",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[A load of prefixes that return true if an object has a property.

- Hidden is true for hide
- Petted is true for pet
- Static is true for still
- sleepy is true for sleep
- shiny is true for best
- curious is true for wonder]],
            display_sprites = { "text_hidden", "text_petted", "text_static", "text_sleepy", "text_shiny", "text_curious" }
        },
        {
            name = "toxic",
            thumbnail_obj = "text_toxic",
            display_name = "toxic",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[A destruction based property that destroys anything on it that doesn't have the "alkali" property.]],
        },
        {
            name = "alkali",
            thumbnail_obj = "text_alkali",
            display_name = "alkali",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[See "toxic".]],
        },
        {
            name = "as",
            thumbnail_obj = "text_as",
            display_name = "as",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[A condition that is like feeling, but accepts nouns.
    
Using write will make "as text" be true.]],
        },
        {
            name = "tenses",
            thumbnail_obj = "text_pastprop",
            display_name = "tenses",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[Properties for the three different tenses.
    
Past makes past tense verbs work and future makes future tense verbs work.
    
Present does nothing by itself, but making something "not present" causes level destruction.]],
            display_sprites = { "text_pastprop", "text_present", "text_future" }
        },
        {
            name = "tense_verbs",
            thumbnail_obj = "text_was",
            display_name = "past/future tense verbs",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[See "past".]],
            display_sprites = { "text_was", "text_had", "text_made", "text_wrote", "text_ate", "text_feared", "text_mimicked", "text_followed", "text_willbe", "text_willhave", "text_willmake", "text_willwrite", "text_willeat", "text_willfear", "text_willmimic", "text_willfollow" }
        },
        {
            name = "willbehave",
            thumbnail_obj = "text_will",
            display_name = "future tense multiletters",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[Multiletters that are meant to spell the "will be" and "will have" verbs.]],
            display_sprites = { "text_will", "text_be", "text_have" }
        },
        {
            name = "keep",
            thumbnail_obj = "text_keep",
            display_name = "keep",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[A prefix that makes a rule persist into the next level.]],
        },
        {
            name = "spin",
            thumbnail_obj = "text_spinright",
            display_name = "spin",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[Turn-like properties that turn until facing the direction of the arrow.]],
            display_sprites = { "text_spinright", "text_spindown", "text_spinleft", "text_spinup", "text_despinright", "text_despindown", "text_despinleft", "text_despinup" }
        },
        {
            name = "act",
            thumbnail_obj = "text_act",
            display_name = "act",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[A verb that does nothing on it's own, but turns into "is" when mimicked.]],
        },
        {
            name = "perform",
            thumbnail_obj = "text_perform",
            display_name = "perform",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[A variant of "mimic" that only mimics "act" rules.]],
        },
        {
            name = "infect",
            thumbnail_obj = "text_infect",
            display_name = "infect",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[Objects that are "infect" become everything that is "virus".]],
            display_sprites = { "text_infect", "text_virus" }
        },
        {
            name = "you+",
            thumbnail_obj = "text_youplus",
            display_name = "you+",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[A variant of "you" that has stacking movement. Objects with you+ still interact with "win" and "defeat" objects.]],
        },
        {
            name = "puppet",
            thumbnail_obj = "text_puppet",
            display_name = "puppet",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[A variant of "you" that doesn't turn. Objects with puppet still interact with "win" and "defeat" objects.]],
        },
        {
            name = "volt",
            thumbnail_obj = "text_volt",
            display_name = "volt",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[A variant of toxic that stacks.
    
- Objects with less instances of volt are destroyed by objects with more.
- Objects with the same amount of instances of volt ignore eachother.]],
        },
        {
            name = "refers",
            thumbnail_obj = "text_refers",
            display_name = "refers",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[An infix condition that is intended to be used on "text".
    
Doing "text refers baba is best" makes the text refering to baba be "best".
If you do "(OBJECT) refers (object)" then it acts the same as "(object) feeling word".]],
        },
        {
            name = "numbers",
            thumbnail_obj = "text_one",
            display_name = "numbers",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[A group of prefixes that are true if exactly that amount of the object is present within the level.]],
            display_sprites = { "text_one", "text_two", "text_three", "text_four", "text_five" }
        },
        {
            name = "equal",
            thumbnail_obj = "text_equal",
            display_name = "equal",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[An infix condition that is true if there is an equal amount of objects.]],
        },
        {
            name = "greater_than",
            thumbnail_obj = "text_greaterthan",
            display_name = "greater than",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[An infix condition that is true if there is a higher amount of objects than the other parameter(s).]],
        },
        {
            name = "less_than",
            thumbnail_obj = "text_lessthan",
            display_name = "less than",
            author = "Extrem",
            group = "$4,2Extrem's $5,4Mods",
            description = [[An infix condition that is true if there is a lower amount of objects than the other parameter(s).]],
        },
    })
end