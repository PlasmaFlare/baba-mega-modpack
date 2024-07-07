-- Support for the Word Glossary
if keys.IS_WORD_GLOSSARY_PRESENT then
    keys.WORD_GLOSSARY_FUNCS.register_author("Mathguy", nil, "$1,3Mathguy")

    keys.WORD_GLOSSARY_FUNCS.add_entries_to_word_glossary({
        {
            name = "symbol",
            thumbnail_obj = "text_symbol",
            display_name = "symbol",
            author = "Mathguy",
            group = "$1,3Glyph",
            description = [[Objects with this property parse as their glyph counterpart.]],
            display_sprites = { "text_symbol" },
        },
        {
            name = "Inscribe",
            thumbnail_obj = "text_inscribe",
            display_name = "symbol",
            author = "Mathguy",
            group = "$1,3Glyph",
            description = [[Similar to write, it transforms objects into the glyph counterpart of the target.]],
            display_sprites = { "text_inscribe" },
        },
        {
            name = "become",
            thumbnail_obj = "text_become",
            display_name = "become",
            author = "Mathguy",
            group = "$1,3Glyph",
            description = [[converts the first object into the second object.
ignores X IS X rules and can transform an object into itself.
LEVEL BECOME LEVEL is not an allowed statement.
]],
            display_sprites = { "text_become" },
        },
        {
            name = "gglyphmeta",
            thumbnail_obj = "glyph_metaglyph",
            display_name = "glyph_metaglyph",
            author = "Mathguy",
            group = "$1,3Glyph",
            description = [[Any glyph next to this glyph will act as a noun that refers to it's own glyph.]],
            display_sprites = { "glyph_metaglyph" },
        },
        {
            name = "gtextmeta",
            thumbnail_obj = "glyph_metatext",
            display_name = "glyph_metatext",
            author = "Mathguy",
            group = "$1,3Glyph",
            description = [[Any glyph next to this glyph will act as a noun that refers to it's text counterpart.
Example: glyph_baba -> text_baba, glyph_is -> text_is]],
            display_sprites = { "glyph_metatext" },
        },
        {
            name = "glyph",
            thumbnail_obj = "glyph_baba",
            display_name = "Glyphs",
            author = "Mathguy",
            group = "$1,3Glyph",
            description = [[Similar to text in that when arranged in certain ways rules are formed.
Parsing rules regarding glyphs vary form that of text.]],
            display_sprites = { "glyph_baba", "glyph_you", "glyph_flag", "glyph_win" },
        },
    })
end