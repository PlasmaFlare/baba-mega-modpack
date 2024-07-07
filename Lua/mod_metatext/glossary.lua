if keys.IS_WORD_GLOSSARY_PRESENT then
    keys.WORD_GLOSSARY_FUNCS.register_author("Emily", nil, "$1,4Emily")
    keys.WORD_GLOSSARY_FUNCS.add_entries_to_word_glossary({
        -- A more customized word entry for directional you. This has a custom thumbnail, a custom title (display_name), and 4 display sprites for showing the 4 different directions of directional you when viewing the word entry in-game.
        {
            name = "metatext",
            thumbnail_obj = "text_text_baba",
            display_name = "Metatext",
            author = "Emily",
            display_sprites = {"text_text_baba"},
            description = [[Metatext is text that refers to other text.
For example, Baba metatext refers to the text that refers to Baba.
So it's essentially modifying one kind of text block.]],
        },
        {
            name = "metaprefix",
            thumbnail_obj = "text_text",
            display_name = "text_ Prefix",
            author = "Emily",
            display_sprites = {"text_textpre"},
            description = [[This prefix goes before any word, parsing it as metatext. Make TEXT_ BABA IS YOU to make the piece of text that refers to BABA be YOU!
It's kind of like TEXT REFERS but not exactly the same when it comes to turning props.]],
        },
        {
            name = "metaunmeta",
            thumbnail_obj = "text_meta",
            display_name = "META / UNMETA",
            author = "Emily",
            display_sprites = {"text_meta","text_unmeta"},
            description = [[These properties change the meta level of text/objects:
META raises the meta level. ROCK is changed to TEXT_ROCK, TEXT_ROCK is changed to TEXT_TEXT_ROCK, etc.
UNMETA lowers the meta level. TEXT_TEXT_ROCK becomes TEXT_ROCK and TEXT_ROCK becomes ROCK.
Texts that don't have an associated object won't be changed.
These are considered transformations, so NOUN IS NOUN will disable them.]],
        },
        {
            name = "metax",
            thumbnail_obj = "text_meta1",
            display_name = "META(Number)",
            author = "Emily",
            display_sprites = {"text_meta-1","text_meta0","text_meta1","text_meta2"},
            description = [[These special nouns refer to a specific level of metatext:
META-1 refers to objects such as 'baba' and 'rock'
META0 refers to text such as 'text_baba' and 'text_is'
META1 refers to level 1 metatext such as 'text_text_baba'...
and so on. While this only adds up to META3 to the editor, upper levels such as META4 should work as intended.]],
        },
    })
end
