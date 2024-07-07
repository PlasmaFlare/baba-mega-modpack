disable_toometa = true
disable_text_metatext = false
enable_functional_glyph_text_ = true

text_and_glyph = {
	text_metatext = "text_text_",
	text_metaglyph = "text_glyph_",
	glyph_text_ = "glyph_metatext",
	glyph_glyph_ = "glyph_metaglyph",
}

function trueidentity(name)
	if text_and_glyph[name] ~= nil then
		return text_and_glyph[name]
	end
	return name
end

glyphunits = {}
verbargtypes = {
	glyph_become = {0,3},
	glyph_write = {0,2,3},
	glyph_has = {0,3},
	glyph_is = {0,2,3},
	glyph_inscribe = {0,2,3},
	glyph_eat = {0,3},
	glyph_make = {0,3}
}
verbargextras = {
	glyph_become = {},
	glyph_write = {},
	glyph_has = {},
	glyph_is = {},
	glyph_inscribe = {},
	glyph_eat = {},
	glyph_make = {}
}
infixargtypes = {
	glyph_feeling = {2},
	glyph_near = {0, 3},
	glyph_on = {0, 3},
	glyph_nextto = {0,3}
}
infixargextras = {
	glyph_feeling = {},
	glyph_near = {},
	glyph_on = {},
	glyph_nextto = {}
}
glyphnear = {{0,1}, {1,0}, {0,-1}, {-1,0}}
glyphtypes = {
	baba = 0,
	glyph = 0,
	flag = 0,
	keke = 0,
	it = 0,
	text = 0,
	all = 0,
	wall = 0,
	skull = 0,
	empty = 0,
	level = 0,
	me = 0,
	fofo = 0,
	water = 0,
	badbad = 0,
	jiji = 0,
	box = 0,
	lava = 0,
	bog = 0,
	key = 0,
	door = 0,
	hedge = 0,
	belt = 0,
	rock = 0,
	boat = 0,
	toometa = 0,
	line = 0,
	arrow = 0,
	cursor = 0,
	sign = 0,
	tile = 0,
	grass = 0,
	robot = 0,
	monster = 0,
	eye = 0,
	jelly = 0,
	cliff = 0,
	love = 0,
	cheese = 0,
	orb = 0,
	ghost = 0,
	hand = 0,
	arm = 0,
	circle = 0,
	square = 0,
	donut = 0,
	cake = 0,
	gem = 0,
	pipe = 0,
	triangle = 0,
	glyph_metatext = 0,
	burger = 0,
	foot = 0,
	spike = 0,
	sun = 0,
	star = 0,
	moon = 0,
	win = 2,
	you = 2,
	bonus = 2,
	defeat = 2,
	stop = 2,
	sink = 2,
	float = 2,
	push = 2,
	still = 2,
	you2 = 2,
	tele = 2,
	shut = 2,
	open = 2,
	pull = 2,
	melt = 2,
	hot = 2,
	turn = 2,
	deturn = 2,
	shift = 2,
	move = 2,
	weak = 2,
	word = 2,
	swap = 2,
	hide = 2,
	symbol = 2,
	red = 2,
	select = 2,
	more = 2,
	chill = 2,
	revert = 2,
	createall = 2,
	up = 2,
	down = 2,
	left = 2,
	right = 2,
	best = 2,
	fallright = 2,
	fallleft = 2,
	fallup = 2,
	falldown = 2,
	power = 2,
	auto = 2,
	blue = 2,
	safe = 2,
	crash = 2,
	lockedleft = 2,
	lockedright = 2,
	lockedup = 2,
	lockeddown = 2,
	sleep = 2,
	become = 1,
	write = 1,
	has = 1,
	is = 1,
	inscribe = 1,
	eat = 1,
	make = 1,
	lonely = 7,
	powered = 7,
	seldom = 7,
	near = 8,
	on = 8,
	nextto = 8,
	feeling = 8,
	metaglyph = 5,
	metatext = 5,
	group = 3,
	group2 = 3,
	group3 = 3,
}
glyphtypes["3d"] = 2
glyphtypes["end"] = 2
glyphtypes["not"] = 4
glyphtypes["and"] = 6
glyphtypes["_NONE_"] = 3
propsurroundings = {}
nounsurroundings = {}
surroundings = {}
infixsurroundings = {}
infixsurroundingsids = {}
metaglyphdata = {}
tilemetaglyphdata = {}
negatetable = {}
symbolmap = {}
metaindicators = {}
metatextindicators = {}

nounandparam = {}
propandparam = {}
bothandparam = {}
properbothandparam = {}
prefixandparam = {}

nearbysave = {}

--[[ 
	@Merge: A few changes to sprite names:
	- "text_meta" => "text_metaglyph"
	- "glyph_meta" => "glyph_metaglyph"

	Reason for this is the metatext mod has its own "text_meta". "glyph_meta" also had to be renamed to keep the behavior of this arrangement:
		glyph_metatext glyph_meta glyph_is glyph_win
	Where this arrangement targets "text_meta" to be win.
 ]]

table.insert(editor_objlist_order, "text_glyph")
table.insert(editor_objlist_order, "text_inscribe")
table.insert(editor_objlist_order, "text_symbol")
table.insert(editor_objlist_order, "text_metaglyph")
table.insert(editor_objlist_order, "text_metatext")
table.insert(editor_objlist_order, "text_become")
table.insert(editor_objlist_order, "glyph_glyph")
table.insert(editor_objlist_order, "glyph_baba")
table.insert(editor_objlist_order, "glyph_flag")
table.insert(editor_objlist_order, "glyph_keke")
table.insert(editor_objlist_order, "glyph_it")
table.insert(editor_objlist_order, "glyph_text")
table.insert(editor_objlist_order, "glyph_all")
table.insert(editor_objlist_order, "glyph_wall")
table.insert(editor_objlist_order, "glyph_skull")
table.insert(editor_objlist_order, "glyph_empty")
table.insert(editor_objlist_order, "glyph_level")
table.insert(editor_objlist_order, "glyph_me")
table.insert(editor_objlist_order, "glyph_fofo")
table.insert(editor_objlist_order, "glyph_water")
table.insert(editor_objlist_order, "glyph_badbad")
table.insert(editor_objlist_order, "glyph_jiji")
table.insert(editor_objlist_order, "glyph_box")
table.insert(editor_objlist_order, "glyph_lava")
table.insert(editor_objlist_order, "glyph_bog")
table.insert(editor_objlist_order, "glyph_door")
table.insert(editor_objlist_order, "glyph_key")
table.insert(editor_objlist_order, "glyph_hedge")
table.insert(editor_objlist_order, "glyph_belt")
table.insert(editor_objlist_order, "glyph_rock")
table.insert(editor_objlist_order, "glyph_boat")
table.insert(editor_objlist_order, "glyph_toometa")
table.insert(editor_objlist_order, "glyph_line")
table.insert(editor_objlist_order, "glyph_arrow")
table.insert(editor_objlist_order, "glyph_cursor")
table.insert(editor_objlist_order, "glyph_sign")
table.insert(editor_objlist_order, "glyph_tile")
table.insert(editor_objlist_order, "glyph_grass")
table.insert(editor_objlist_order, "glyph_robot")
table.insert(editor_objlist_order, "glyph_monster")
table.insert(editor_objlist_order, "glyph_eye")
table.insert(editor_objlist_order, "glyph_jelly")
table.insert(editor_objlist_order, "glyph_cliff")
table.insert(editor_objlist_order, "glyph_love")
table.insert(editor_objlist_order, "glyph_cheese")
table.insert(editor_objlist_order, "glyph_orb")
table.insert(editor_objlist_order, "glyph_ghost")
table.insert(editor_objlist_order, "glyph_arm")
table.insert(editor_objlist_order, "glyph_hand")
table.insert(editor_objlist_order, "glyph_circle")
table.insert(editor_objlist_order, "glyph_square")
table.insert(editor_objlist_order, "glyph_donut")
table.insert(editor_objlist_order, "glyph_cake")
table.insert(editor_objlist_order, "glyph_gem")
table.insert(editor_objlist_order, "glyph_pipe")
table.insert(editor_objlist_order, "glyph_triangle")
table.insert(editor_objlist_order, "glyph_burger")
table.insert(editor_objlist_order, "glyph_foot")
table.insert(editor_objlist_order, "glyph_sun")
table.insert(editor_objlist_order, "glyph_spike")
table.insert(editor_objlist_order, "glyph_star")
table.insert(editor_objlist_order, "glyph_moon")
table.insert(editor_objlist_order, "glyph_win")
table.insert(editor_objlist_order, "glyph_not")
table.insert(editor_objlist_order, "glyph_you")
table.insert(editor_objlist_order, "glyph_bonus")
table.insert(editor_objlist_order, "glyph_defeat")
table.insert(editor_objlist_order, "glyph_stop")
table.insert(editor_objlist_order, "glyph_sink")
table.insert(editor_objlist_order, "glyph_float")
table.insert(editor_objlist_order, "glyph_push")
table.insert(editor_objlist_order, "glyph_still")
table.insert(editor_objlist_order, "glyph_you2")
table.insert(editor_objlist_order, "glyph_tele")
table.insert(editor_objlist_order, "glyph_shut")
table.insert(editor_objlist_order, "glyph_open")
table.insert(editor_objlist_order, "glyph_pull")
table.insert(editor_objlist_order, "glyph_3d")
table.insert(editor_objlist_order, "glyph_melt")
table.insert(editor_objlist_order, "glyph_hot")
table.insert(editor_objlist_order, "glyph_turn")
table.insert(editor_objlist_order, "glyph_deturn")
table.insert(editor_objlist_order, "glyph_shift")
table.insert(editor_objlist_order, "glyph_move")
table.insert(editor_objlist_order, "glyph_weak")
table.insert(editor_objlist_order, "glyph_word")
table.insert(editor_objlist_order, "glyph_swap")
table.insert(editor_objlist_order, "glyph_hide")
table.insert(editor_objlist_order, "glyph_symbol")
table.insert(editor_objlist_order, "glyph_red")
table.insert(editor_objlist_order, "glyph_select")
table.insert(editor_objlist_order, "glyph_more")
table.insert(editor_objlist_order, "glyph_chill")
table.insert(editor_objlist_order, "glyph_revert")
table.insert(editor_objlist_order, "glyph_createall")
table.insert(editor_objlist_order, "glyph_end")
table.insert(editor_objlist_order, "glyph_up")
table.insert(editor_objlist_order, "glyph_down")
table.insert(editor_objlist_order, "glyph_left")
table.insert(editor_objlist_order, "glyph_right")
table.insert(editor_objlist_order, "glyph_best")
table.insert(editor_objlist_order, "glyph_fallright")
table.insert(editor_objlist_order, "glyph_fallleft")
table.insert(editor_objlist_order, "glyph_fallup")
table.insert(editor_objlist_order, "glyph_falldown")
table.insert(editor_objlist_order, "glyph_power")
table.insert(editor_objlist_order, "glyph_auto")
table.insert(editor_objlist_order, "glyph_blue")
table.insert(editor_objlist_order, "glyph_safe")
table.insert(editor_objlist_order, "glyph_crash")
table.insert(editor_objlist_order, "glyph_lockedup")
table.insert(editor_objlist_order, "glyph_lockeddown")
table.insert(editor_objlist_order, "glyph_lockedleft")
table.insert(editor_objlist_order, "glyph_lockedright")
table.insert(editor_objlist_order, "glyph_sleep")
table.insert(editor_objlist_order, "glyph_lonely")
table.insert(editor_objlist_order, "glyph_powered")
table.insert(editor_objlist_order, "glyph_seldom")
table.insert(editor_objlist_order, "glyph_near")
table.insert(editor_objlist_order, "glyph_on")
table.insert(editor_objlist_order, "glyph_nextto")
table.insert(editor_objlist_order, "glyph_feeling")
table.insert(editor_objlist_order, "glyph_become")
table.insert(editor_objlist_order, "glyph_has")
table.insert(editor_objlist_order, "glyph_write")
table.insert(editor_objlist_order, "glyph_is")
table.insert(editor_objlist_order, "glyph_inscribe")
table.insert(editor_objlist_order, "glyph_eat")
table.insert(editor_objlist_order, "glyph_make")
table.insert(editor_objlist_order, "glyph_and")
table.insert(editor_objlist_order, "glyph_metaglyph")
table.insert(editor_objlist_order, "glyph_metatext")
table.insert(editor_objlist_order, "glyph_group")
table.insert(editor_objlist_order, "glyph_group2")
table.insert(editor_objlist_order, "glyph__NONE_")
table.insert(editor_objlist_order, "glyph_group3")
table.insert(editor_objlist_order, "toometa")
table.insert(editor_objlist_order, "text_toometa")
table.insert(editor_objlist_order, "text_glyph_")
table.insert(editor_objlist_order, "glyph_text_")
table.insert(editor_objlist_order, "glyph_glyph_")

editor_objlist["text_glyph"] =
{
	name = "text_glyph",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 20,
	colour = {3, 2},
	colour_active = {3, 3},
}

editor_objlist["text_glyph_"] =
{
	name = "text_glyph_",
	sprite = "text_glyphpre",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","abstract", "glyph"},
	tiling = -1,
	type = 4,
	layer = 20,
	colour = {3, 2},
	colour_active = {3, 3},
}

editor_objlist["glyph_text_"] =
{
	name = "glyph_text_",
	sprite = "glyph_textpre",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 1},
	colour_active = {4, 1},
}

editor_objlist["glyph_glyph_"] =
{
	name = "glyph_glyph_",
	sprite = "glyph_glyphpre",
	sprite_in_root = false,
	unittype = "object",
	tags = {"text","abstract", "glyph"},
	tiling = -1,
	type = 4,
	layer = 1,
	colour = {3, 3},
	colour_active = {3, 3},
}

editor_objlist["text_symbol"] =
{
	name = "text_symbol",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","abstract", "glyph"},
	tiling = -1,
	type = 2,
	layer = 20,
	colour = {1, 1},
	colour_active = {4, 3},
}

editor_objlist["glyph_glyph"] =
{
	name = "glyph_glyph",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 2},
	colour_active = {3, 3},
}
editor_objlist["glyph_it"] =
{
	name = "glyph_it",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 2},
	colour_active = {1, 4},
}


editor_objlist["glyph_baba"] =
{
	name = "glyph_baba",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_not"] =
{
	name = "glyph_not",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 2,
	colour = {2, 1},
	colour_active = {2, 2},
}

editor_objlist["glyph_you"] =
{
	name = "glyph_you",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 0},
	colour_active = {4, 1},
}

editor_objlist["glyph_bonus"] =
{
	name = "glyph_bonus",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 0},
	colour_active = {4, 1},
}

editor_objlist["glyph_win"] =
{
	name = "glyph_win",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {2, 4},
}


editor_objlist["glyph_flag"] =
{
	name = "glyph_flag",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {2, 4},
}

editor_objlist["glyph_text"] =
{
	name = "glyph_text",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 0},
	colour_active = {4, 1},
}

editor_objlist["glyph_keke"] =
{
	name = "glyph_keke",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 1},
	colour_active = {2, 2},
}

editor_objlist["glyph_all"] =
{
	name = "glyph_all",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_become"] =
{
	name = "glyph_become",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = 0,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_write"] =
{
	name = "glyph_write",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = 0,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_defeat"] =
{
	name = "glyph_defeat",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 0},
	colour_active = {2, 1},
}

editor_objlist["glyph_stop"] =
{
	name = "glyph_stop",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 0},
	colour_active = {2, 1},
}

editor_objlist["glyph_wall"] =
{
	name = "glyph_wall",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 1},
	colour_active = {0, 1},
}


editor_objlist["glyph_sink"] =
{
	name = "glyph_sink",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 2},
	colour_active = {1, 3},
}

editor_objlist["glyph_float"] =
{
	name = "glyph_float",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 2},
	colour_active = {1, 4},
}

editor_objlist["glyph_push"] =
{
	name = "glyph_push",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 0},
	colour_active = {6, 1},
}

editor_objlist["glyph_skull"] =
{
	name = "glyph_skull",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 0},
	colour_active = {2, 1},
	sprite = "glyph_skull"
}
editor_objlist["glyph_and"] =
{
	name = "glyph_and",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 2},
	colour_active = {0, 3},
}
editor_objlist["glyph_empty"] =
{
	name = "glyph_empty",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}
editor_objlist["glyph_level"] =
{
	name = "glyph_level",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 0},
	colour_active = {4, 1},
}
editor_objlist["glyph_still"] =
{
	name = "glyph_still",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 0},
	colour_active = {2, 1},
}
editor_objlist["glyph_you2"] =
{
	name = "glyph_you2",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 0},
	colour_active = {4, 1},
}
editor_objlist["glyph_metaglyph"] =
{
	name = "glyph_metaglyph",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 3},
	colour_active = {4, 4},
}
editor_objlist["glyph_metatext"] =
{
	name = "glyph_metatext",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 1},
	colour_active = {4, 2},
}
editor_objlist["glyph_me"] =
{
	name = "glyph_me",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 0},
	colour_active = {3, 1},
}
editor_objlist["glyph_fofo"] =
{
	name = "glyph_fofo",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 1},
	colour_active = {5, 2},
}

editor_objlist["glyph_water"] =
{
	name = "glyph_water",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 2},
	colour_active = {1, 3},
}

editor_objlist["glyph_badbad"] =
{
	name = "glyph_badbad",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 3},
	colour_active = {1, 4},
}

editor_objlist["glyph_group"] =
{
	name = "glyph_group",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 2},
	colour_active = {3, 3},
}

editor_objlist["glyph_tele"] =
{
	name = "glyph_tele",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 2},
	colour_active = {1, 4},
}

editor_objlist["glyph_jiji"] =
{
	name = "glyph_jiji",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 2},
	colour_active = {2, 3},
}

editor_objlist["glyph_box"] =
{
	name = "glyph_box",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 0},
	colour_active = {6, 1},
}

editor_objlist["glyph_shut"] =
{
	name = "glyph_shut",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 1},
	colour_active = {2, 2},
}

editor_objlist["glyph_open"] =
{
	name = "glyph_open",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {2, 4},
}

editor_objlist["glyph_lava"] =
{
	name = "glyph_lava",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 2},
	colour_active = {2, 3},
}

editor_objlist["glyph_bog"] =
{
	name = "glyph_bog",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 1},
	colour_active = {5, 3},
}


editor_objlist["glyph_pull"] =
{
	name = "glyph_pull",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {6, 2},
}

editor_objlist["glyph_3d"] =
{
	name = "glyph_3d",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 0},
	colour_active = {4, 1},
}

editor_objlist["glyph_melt"] =
{
	name = "glyph_melt",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 2},
	colour_active = {1, 3},
}

editor_objlist["glyph_hot"] =
{
	name = "glyph_hot",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 2},
	colour_active = {2, 3},
}

editor_objlist["glyph_key"] =
{
	name = "glyph_key",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {2, 4},
	sprite = "glyph_key"
}

editor_objlist["glyph_door"] =
{
	name = "glyph_door",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 1},
	colour_active = {2, 2},
}

editor_objlist["glyph_hedge"] =
{
	name = "glyph_hedge",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 0},
	colour_active = {5, 1},
}

editor_objlist["glyph_lonely"] =
{
	name = "glyph_lonely",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 1},
	colour_active = {2, 2},
}

editor_objlist["glyph_near"] =
{
	name = "glyph_near",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_turn"] =
{
	name = "glyph_turn",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 2},
	colour_active = {1, 4},
}

editor_objlist["glyph_deturn"] =
{
	name = "glyph_deturn",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 2},
	colour_active = {1, 4},
}

editor_objlist["glyph_shift"] =
{
	name = "glyph_shift",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 2},
	colour_active = {1, 3},
}

editor_objlist["glyph_move"] =
{
	name = "glyph_move",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 1},
	colour_active = {5, 3},
}

editor_objlist["glyph_weak"] =
{
	name = "glyph_weak",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 1},
	colour_active = {1, 2},
}

editor_objlist["glyph_belt"] =
{
	name = "glyph_belt",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 2},
	colour_active = {1, 3},
}

-- write

editor_objlist["glyph_rock"] =
{
	name = "glyph_rock",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 0},
	colour_active = {6, 1},
}

editor_objlist["glyph_has"] =
{
	name = "glyph_has",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = 0,
	type = 0,
	layer = 1,
	colour = {6, 0},
	colour_active = {6, 1},
}

editor_objlist["glyph_word"] =
{
	name = "glyph_word",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_group2"] =
{
	name = "glyph_group2",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 1},
	colour_active = {2, 2},
}

editor_objlist["glyph_boat"] =
{
	name = "glyph_boat",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {6, 2},
}

editor_objlist["toometa"] =
{
	name = "toometa",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 3},
}

editor_objlist["text_toometa"] =
{
	name = "text_toometa",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_toometa"] =
{
	name = "glyph_toometa",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_line"] =
{
	name = "glyph_line",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_arrow"] =
{
	name = "glyph_arrow",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 1},
	colour_active = {5, 2},
}

editor_objlist["glyph_cursor"] =
{
	name = "glyph_cursor",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 0},
	colour_active = {4, 2},
}

editor_objlist["glyph_sign"] =
{
	name = "glyph_sign",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {6, 2},
}

editor_objlist["glyph_tile"] =
{
	name = "glyph_tile",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 1},
	colour_active = {0, 1},
}

editor_objlist["glyph_grass"] =
{
	name = "glyph_grass",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 1},
	colour_active = {5, 3},
}

editor_objlist["glyph_robot"] =
{
	name = "glyph_robot",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 1},
	colour_active = {0, 1},
}

editor_objlist["glyph_monster"] =
{
	name = "glyph_monster",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 0},
	colour_active = {4, 1},
}

editor_objlist["glyph_eye"] =
{
	name = "glyph_eye",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 1},
	colour_active = {4, 2},
}

editor_objlist["glyph_jelly"] =
{
	name = "glyph_jelly",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 3},
	colour_active = {1, 4},
}

editor_objlist["glyph_cliff"] =
{
	name = "glyph_cliff",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 0},
	colour_active = {6, 2},
}

editor_objlist["glyph_swap"] =
{
	name = "glyph_swap",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 0},
	colour_active = {3, 1},
}

editor_objlist["glyph_hide"] =
{
	name = "glyph_hide",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 2},
	colour_active = {3, 3},
}

editor_objlist["glyph_is"] =
{
	name = "glyph_is",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = 0,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}
editor_objlist["glyph_symbol"] =
{
	name = "glyph_symbol",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 1},
	colour_active = {4, 3},
}

editor_objlist["text_inscribe"] =
{
	name = "text_inscribe",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text","abstract", "glyph"},
	tiling = -1,
	type = 1,
	layer = 1,
	argtype = {0,2},
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_red"] =
{
	name = "glyph_red",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 1},
	colour_active = {2, 2},
}

editor_objlist["glyph_on"] =
{
	name = "glyph_on",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_nextto"] =
{
	name = "glyph_nextto",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_select"] =
{
	name = "glyph_select",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 3},
	colour_active = {2, 4},
}

editor_objlist["glyph_love"] =
{
	name = "glyph_love",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 1},
	colour_active = {4, 2},
}

editor_objlist["glyph_more"] =
{
	name = "glyph_more",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 0},
	colour_active = {4, 1},
}

editor_objlist["glyph_inscribe"] =
{
	name = "glyph_inscribe",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract", "glyph"},
	tiling = 0,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 2},
}

editor_objlist["text_metaglyph"] =
{
	name = "text_metaglyph",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "abstract", "glyph"},
	tiling = -1,
	type = -1,
	layer = 20,
	colour = {3, 2},
	colour_active = {3, 3},
}

editor_objlist["text_metatext"] =
{
	name = "text_metatext",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "abstract", "glyph"},
	tiling = -1,
	type = -1,
	layer = 20,
	colour = {4, 0},
	colour_active = {4, 1},
}

editor_objlist["text_become"] =
{
	name = "text_become",
	sprite_in_root = false,
	unittype = "text",
	tags = {"text", "abstract", "glyph"},
	tiling = -1,
	type = 1,
	layer = 20,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_feeling"] =
{
	name = "glyph_feeling",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {2, 4},
}

editor_objlist["glyph_cheese"] =
{
	name = "glyph_cheese",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {2, 4},
}

editor_objlist["glyph_eat"] =
{
	name = "glyph_eat",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = 0,
	type = 0,
	layer = 1,
	colour = {0, 0},
	colour_active = {0, 1},
}

editor_objlist["glyph_orb"] =
{
	name = "glyph_orb",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 0},
	colour_active = {4, 1},
}

editor_objlist["glyph_chill"] =
{
	name = "glyph_chill",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 2},
	colour_active = {3, 3},
}

editor_objlist["glyph_revert"] =
{
	name = "glyph_revert",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 2},
	colour_active = {2, 3},
}

editor_objlist["glyph_createall"] =
{
	name = "glyph_createall",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 20,
	colour = {2, 2},
	colour_active = {2, 3},
	sprite = "glyph_all"
}

editor_objlist["glyph__NONE_"] =
{
	name = "glyph__NONE_",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 2},
	colour_active = {3, 3},
}

editor_objlist["glyph_end"] =
{
	name = "glyph_end",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_ghost"] =
{
	name = "glyph_ghost",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 1},
	colour_active = {4, 2},
}

editor_objlist["glyph_up"] =
{
	name = "glyph_up",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 3},
	colour_active = {1, 4},
}

editor_objlist["glyph_down"] =
{
	name = "glyph_down",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 3},
	colour_active = {1, 4},
}

editor_objlist["glyph_right"] =
{
	name = "glyph_right",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 3},
	colour_active = {1, 4},
}

editor_objlist["glyph_left"] =
{
	name = "glyph_left",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 3},
	colour_active = {1, 4},
}

editor_objlist["glyph_best"] =
{
	name = "glyph_best",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 3},
	colour_active = {2, 4},
}

editor_objlist["glyph_fallright"] =
{
	name = "glyph_fallright",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 1},
	colour_active = {5, 3},
}

editor_objlist["glyph_fallleft"] =
{
	name = "glyph_fallleft",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 1},
	colour_active = {5, 3},
}

editor_objlist["glyph_fallup"] =
{
	name = "glyph_fallup",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 1},
	colour_active = {5, 3},
}

editor_objlist["glyph_falldown"] =
{
	name = "glyph_falldown",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 1},
	colour_active = {5, 3},
}

editor_objlist["glyph_make"] =
{
	name = "glyph_make",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = 0,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 2},
}

editor_objlist["glyph_power"] =
{
	name = "glyph_power",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {2, 4},
}

editor_objlist["glyph_powered"] =
{
	name = "glyph_powered",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {2, 4},
}

editor_objlist["glyph_arm"] =
{
	name = "glyph_arm",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 0},
	colour_active = {3, 1},
}

editor_objlist["glyph_hand"] =
{
	name = "glyph_hand",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 0},
	colour_active = {3, 1},
}

editor_objlist["glyph_circle"] =
{
	name = "glyph_circle",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 1},
	colour_active = {5, 3},
}

editor_objlist["glyph_square"] =
{
	name = "glyph_square",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 0},
	colour_active = {4, 1},
}

editor_objlist["glyph_donut"] =
{
	name = "glyph_donut",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 1},
	colour_active = {4, 2},
}

editor_objlist["glyph_cake"] =
{
	name = "glyph_cake",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 1},
	colour_active = {4, 2},
}

editor_objlist["glyph_group3"] =
{
	name = "glyph_group3",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {5, 2},
	colour_active = {5, 3},
}

editor_objlist["glyph_gem"] =
{
	name = "glyph_gem",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 1},
	colour_active = {4, 2},
}

editor_objlist["glyph_pipe"] =
{
	name = "glyph_pipe",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 1},
	colour_active = {0, 1},
}

editor_objlist["glyph_auto"] =
{
	name = "glyph_auto",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 0},
	colour_active = {4, 1},
}

editor_objlist["glyph_triangle"] =
{
	name = "glyph_triangle",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 2},
	colour_active = {3, 3},
}

editor_objlist["glyph_blue"] =
{
	name = "glyph_blue",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 2},
	colour_active = {3, 3},
	sprite = "glyph_red",
}

editor_objlist["glyph_safe"] =
{
	name = "glyph_safe",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {0, 1},
	colour_active = {0, 3},
}

editor_objlist["glyph_burger"] =
{
	name = "glyph_burger",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {2, 3},
}

editor_objlist["glyph_foot"] =
{
	name = "glyph_foot",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 0},
	colour_active = {3, 1},
}

editor_objlist["glyph_crash"] =
{
	name = "glyph_crash",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 0},
	colour_active = {4, 1},
}

editor_objlist["glyph_sun"] =
{
	name = "glyph_sun",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {2, 3},
	colour_active = {2, 4},
}

editor_objlist["glyph_spike"] =
{
	name = "glyph_spike",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {1, 1},
	colour_active = {0, 1},
}

editor_objlist["glyph_star"] =
{
	name = "glyph_star",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {2, 4},
}

editor_objlist["glyph_moon"] =
{
	name = "glyph_moon",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {6, 1},
	colour_active = {2, 4},
}

editor_objlist["glyph_lockedright"] =
{
	name = "glyph_lockedright",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 1},
	colour_active = {4, 2},
}

editor_objlist["glyph_lockedleft"] =
{
	name = "glyph_lockedleft",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 1},
	colour_active = {4, 2},
}

editor_objlist["glyph_lockedup"] =
{
	name = "glyph_lockedup",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 1},
	colour_active = {4, 2},
}

editor_objlist["glyph_lockeddown"] =
{
	name = "glyph_lockeddown",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 1},
	colour_active = {4, 2},
}

editor_objlist["glyph_seldom"] =
{
	name = "glyph_seldom",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {3, 2},
	colour_active = {3, 3},
}

editor_objlist["glyph_sleep"] =
{
	name = "glyph_sleep",
	sprite_in_root = false,
	unittype = "object",
	tags = {"abstract"},
	tiling = -1,
	type = 0,
	layer = 1,
	colour = {4, 3},
	colour_active = {3, 2},
}

formatobjlist()

--@Merge: locally declare functions to prevent from polluting global namespace
local foundreference,foundbasereference,referencestext,referencesglyph,isnoun,isprop,isverb,isglyphnot,isglyphand,isgroupglyph,isglyphmeta,isprefix,isinfix,donegateglyph,makenegatetable,metaprefix,matchglyphtype,nearbyglyphs,getandparams,getinfixparams,getnounandparams,getpropandparams,getbothandparams,getproperbothandparams,getprefixandparams,determinemetaglyphs,concatglyphtables,getunitfromid

local function get_meta_connected(meta_prefix,name)
	return meta_prefix .. string.sub(name, 7)
end

local function get_name_with_glyph_text_(unit)
	local result = unit.strings[UNITNAME]
	if not enable_functional_glyph_text_ or (result == "glyph_text_" or result == "glyph_glyph_" ) then
		return result
	end
	local pref = ""
	if string.sub(result,1,5) == "text_" then
		pref = "text_"
		result = string.sub(result,6)
	elseif string.sub(result,1,6) == "glyph_" then
		pref = "glyph_"
		result = string.sub(result,7)
	end
	local glayer, tlayer = 0, 0
	local x,y = unit.values[XPOS], unit.values[YPOS]
	if (unitmap[x + y * roomsizex] ~= nil) and (inbounds(x, y)) then
		for _,v in pairs(unitmap[x + y * roomsizex]) do
			local metaunit = getunitfromid(v)
			local name = metaunit.strings[UNITNAME]
			if unit ~= metaunit then
				if (name == "glyph_text_") then
					tlayer = tlayer + 1
				elseif (name == "glyph_glyph_") then
					glayer = glayer + 1
				end
			end
		end
	end
	return pref .. string.rep("glyph_",glayer) .. string.rep("text_",tlayer) .. result
end

local function getmetas(x,y)
	local metas = {}
	local metatexts = {}
	for i,j in pairs(glyphnear) do
		if (unitmap[(x + j[1]) + (y + j[2]) * roomsizex] ~= nil) and inbounds(x + j[1], y + j[2]) then
			for i2,v2 in pairs(unitmap[(x + j[1]) + (y + j[2]) * roomsizex]) do
				local unit = getunitfromid(v2)
				local name = get_name_with_glyph_text_(unit)
				if (name == "glyph_metatext") then
					table.insert(metatexts, v2)
				elseif (name == "glyph_metaglyph") then
					table.insert(metas, v2)
				end
			end
		end
	end
	if #metas == 0 then
		return metatexts
	else
		return metas
	end
end

function toometafunc(name)
	if disable_toometa then return false end
	if (string.sub(name,1,5) == "text_") then
		local basefound = foundbasereference(name)
		local textfound = foundreference(name)
		if (textfound ~= 1) and (basefound == 1) then
			return true
		end
	elseif (string.sub(name,1,6) == "glyph_") then
		local basefound = foundbasereference(name)
		local glyphfound = foundreference(name)
		if (glyphfound ~= 1) and (basefound == 1) then
			return true
		end
	end
	return false
end

function foundreference(name)
	if (name == "text") or (name == "glyph") then
		return 1
	end
	if (string.sub(name,1,5) == "text_") then
		if getmat_text(name) then
			return 1
		end
		return 0
	elseif (string.sub(name,1,6) == "glyph_") then
		if (unitreference[name] ~= nil) then
				return 1
			end
		-- if unitreference[name] ~= nil then
		-- 	return 1
		-- end
		return 0
	else
		return objectlist[name]
	end
end

function foundbasereference(name)
	local base = name
	if (string.sub(base,1,5) == "text_") or (string.sub(base,1,6) == "glyph_") then
		if (string.sub(base,1,5) == "text_") then
			base = string.sub(base, 6)
		elseif (string.sub(base,1,6) == "glyph_") then
			base = string.sub(base, 7)
		end
	end
	return foundreference(base)
end

condlist['references'] = function(params,checkedconds,checkedconds_,cdata)
	if (cdata.unitid == 1) or (cdata.unitid == 2) then
		return false
	end
	local unit = mmf.newObject(cdata.unitid)
	if (unit  == nil) then
		return false
	end
	local unitname = unit.strings[UNITNAME]
	params[1] = string.sub(params[1], 2)
	-- if (string.sub(unitname, 1, 5) == "text_") then
	-- 	return (string.sub(unitname, 6) == params[1]), checkedconds
	-- end --@Merge(glyph x metatext): disable glyph mod's implementation of metatext. Metatext mod has the system all figured out
	if (string.sub(unitname, 1, 6) == "glyph_") then
		return (string.sub(unitname, 7) == params[1]), checkedconds
	end
	return false, checkedconds
end



function referencestext(unit, param)
	local unitname = get_name_with_glyph_text_(unit)
	if (string.sub(unitname, 1, 5) == "text_") then
		return (string.sub(unitname, 6) == params[1]), checkedconds
	end
	return false, checkedconds
end

function referencesglyph(unit, param)
	local unitname = get_name_with_glyph_text_(unit)
	if (string.sub(unitname, 1, 6) == "glyph_") then
		return (string.sub(unitname, 7) == params[1]), checkedconds
	end
	return false, checkedconds
end

function isnoun(input_string, id)
	if string.sub(input_string,1,6) ~= "glyph_" then
		return false
	end
	if (metaglyphdata[id] ~= 0) and (metaglyphdata[id] ~= nil) then
		return true
	end

	-- for i,j in pairs(glyphnouns) do
	--     if ("glyph_" .. j == input_string) or ("glyph_glyph_" .. j == input_string) or ("glyph_text_" .. j == input_string) or ("glyph_not " .. j == input_string) or ("glyph_glyph_not " .. j == input_string) or ("glyph_text_not " .. j == input_string) then
	--         return true
	--     end
	-- end
	if (string.sub(input_string,1,12) == "glyph_glyph_" and input_string ~= "glyph_glyph_") or
			(string.sub(input_string,1,11) == "glyph_text_" and input_string ~= "glyph_text_") then
		return true
	end
	if (glyphtypes[string.sub(input_string,7)] == 0) or ((string.sub(input_string,1,10) == "glyph_not ") and (glyphtypes[string.sub(input_string,11)] == 0)) then
		return true
	end
	return false
end

function isprop(input_string, id)
	if string.sub(input_string,1,6) ~= "glyph_" then
		return false
	end
	if (metaglyphdata[id] ~= 0) and (metaglyphdata[id] ~= nil) then
		return false
	end
	-- for i,j in pairs(glyphprops) do
	--     if ("glyph_" .. j == input_string) or ("glyph_not " .. j == input_string) then
	--         return true
	--     end
	-- end
	if (glyphtypes[string.sub(input_string,7)] == 2) or ((string.sub(input_string,1,10) == "glyph_not ") and (glyphtypes[string.sub(input_string,11)] == 2)) then
		return true
	end
	return false
end

function isverb(input_string, id)
	if string.sub(input_string,1,6) ~= "glyph_" then
		return false
	end
	if (metaglyphdata[id] == 1) then
		return false
	end
	-- for i,j in pairs(glyphverbs) do
	--     if ("glyph_" .. j == input_string) then
	--         return true
	--     end
	-- end
	if (glyphtypes[string.sub(input_string,7)] == 1) then
		return true
	end
	return false
end

function isglyphnot(input_string, id)
	if string.sub(input_string,1,6) ~= "glyph_" then
		return false
	end
	if (metaglyphdata[id] ~= 0) and (metaglyphdata[id] ~= nil) then
		return false
	end
	return (input_string == "glyph_not")
end

function isglyphand(input_string, id)
	if string.sub(input_string,1,6) ~= "glyph_" then
		return false
	end
	if (metaglyphdata[id] ~= 0) and (metaglyphdata[id] ~= nil) then
		return false
	end
	return (input_string == "glyph_and")
end

function isgroupglyph(input_string, id)
	if string.sub(input_string,1,6) ~= "glyph_" then
		return false
	end
	if (metaglyphdata[id] ~= 0) and (metaglyphdata[id] ~= nil) then
		return false
	end
	return (string.sub(input_string, 1, 11) == "glyph_group") or (glyphtypes[string.sub(input_string,7)] == 3) or ((string.sub(input_string,1,10) == "glyph_not ") and (glyphtypes[string.sub(input_string,11)] == 3))
end

function isglyphmeta(input_string, id)
	if string.sub(input_string,1,6) ~= "glyph_" then
		return false
	end
	return (input_string == "glyph_metaglyph") or (input_string == "glyph_metatext")
end

function isprefix(input_string, id)
	if string.sub(input_string,1,6) ~= "glyph_" then
		return false
	end
	if (metaglyphdata[id] ~= 0) and (metaglyphdata[id] ~= nil) then
		return false
	end
	-- for i,j in pairs(glyphprefixes) do
	--     if ("glyph_" .. j == input_string) or ("glyph_not " .. j == input_string) then
	--         return true
	--     end
	-- end
	if (glyphtypes[string.sub(input_string,7)] == 7) or ((string.sub(input_string,1,10) == "glyph_not ") and (glyphtypes[string.sub(input_string,11)] == 7)) then
		return true
	end
    return false
end

function isinfix(input_string, id)
	if string.sub(input_string,1,6) ~= "glyph_" then
		return false
	end
	if (metaglyphdata[id] ~= 0) and (metaglyphdata[id] ~= nil) then
		return false
	end
	-- for i,j in pairs(glyphinfixes) do
	--     if ("glyph_" .. j == input_string) or ("glyph_not " .. j == input_string) then
	--         return true
	--     end
	-- end
	if (glyphtypes[string.sub(input_string,7)] == 8) or ((string.sub(input_string,1,10) == "glyph_not ") and (glyphtypes[string.sub(input_string,11)] == 8)) then
		return true
	end
	return false
end

function donegateglyph(x, y)
    return (negatetable[x + y * roomsizex] == true)
end

function makenegatetable()
	if unitlists["glyph_not"] ~= nil then
		for i, j in pairs(unitlists["glyph_not"]) do
			local unit = mmf.newObject(j)
			if isglyphnot("glyph_not", j) then
				local x, y = unit.values[XPOS], unit.values[YPOS]
				local tileid = x + y *roomsizex
				if negatetable[tileid] == nil then
					negatetable[tileid] = true
				else
					negatetable[tileid] = not negatetable[tileid]
				end
			end
		end
	end
end

function metaprefix(x, y)
	local is_meta = false
	local is_text = false
	local im_done = false
	if (tilemetaglyphdata[x + y * roomsizex] ~= nil) then
		if tilemetaglyphdata[x + y * roomsizex] == 1 then
			return "glyph_"
		elseif tilemetaglyphdata[x + y * roomsizex] == 2 then
			return "text_"
		elseif tilemetaglyphdata[x + y * roomsizex] == 0 then
			return ""
		end
	end
	for i,j in pairs(glyphnear) do
		if (unitmap[(x + j[1]) + (y + j[2]) * roomsizex] ~= nil) and inbounds(x + j[1], y + j[2]) then
			for i2,v2 in pairs(unitmap[(x + j[1]) + (y + j[2]) * roomsizex]) do
				local unit = getunitfromid(v2)
				local name = get_name_with_glyph_text_(unit)
				if (name == "glyph_metatext") then
					is_text = true
					break
				elseif (name == "glyph_metaglyph") then
					is_meta = true
					im_done = true
					break
				end
			end
			if im_done then
				break
			end
		end
	end
	if is_meta then
		tilemetaglyphdata[x + y * roomsizex] = 1
		return "glyph_"
	elseif is_text then
		tilemetaglyphdata[x + y * roomsizex] = 2
		return "text_"
	else
		tilemetaglyphdata[x + y * roomsizex] = 0
		return ""
	end
end
-- Types
-- Noun - 0
-- Verb - 1
-- Property - 2
-- Group - 3
-- Not - 4
-- Meta - 5
-- And - 6
-- Prefix - 7
-- Infix - 8
function matchglyphtype(input_string, id, glyphtypes0, glyphextras)
	for i, j in pairs(glyphextras) do
		if ("glyph_" .. j == input_string) then
			return true
		end
	end
	for i,glyphtype in pairs(glyphtypes0) do
		if (glyphtype == 0) then
			if isnoun(input_string, id) then
				return true
			end
		elseif (glyphtype == 1) then
			if isverb(input_string, id) then
				return true
			end
		elseif (glyphtype == 2) then
			if isprop(input_string, id) then
				return true
			end
		elseif (glyphtype == 3) then
			if isgroupglyph(input_string, id) then
				return true
			end
		elseif (glyphtype == 4) then
			if isglyphnot(input_string, id) then
				return true
			end
		elseif (glyphtype == 5) then
			if isglyphmeta(input_string, id) then
				return true
			end
		elseif (glyphtype == 6) then
			if isglyphand(input_string, id) then
				return true
			end
		elseif (glyphtype == 7) then
			if isprefix(input_string, id) then
				return true
			end
		elseif (glyphtype == 8) then
			if isinfix(input_string, id) then
				return true
			end
		end

	end
	return false
end

function nearbyglyphs(x, y, base_id)
	if nearbysave[x + y * roomsizex] ~= nil then
		return nearbysave[x + y * roomsizex]
	end
    local return_table = {
		noun = {},
		prop = {},
		glyphnot = {},
		verb = {},
		glyphand = {},
		group = {},
		prefix = {},
		infix = {},
	}
    for i,j in pairs(glyphnear) do
		if (unitmap[(x + j[1]) + (y + j[2]) * roomsizex] ~= nil) and inbounds(x + j[1], y + j[2]) then
            local sub_result = {
				noun = {},
				prop = {},
				glyphnot = {},
				verb = {},
				glyphand = {},
				group = {},
				prefix = {},
				infix = {},
			}
            for i2, j2 in pairs(unitmap[(x + j[1]) + (y + j[2]) * roomsizex]) do
                local unit = getunitfromid(j2)
                local name = get_name_with_glyph_text_(unit)
				local dir = ndirs[unit.values[DIR]+1]
                if (getname(unit, "glyph") == "glyph") then
                    if isprop(name, j2) then
                        table.insert(sub_result["prop"], {string.sub(name, 7), j2})
					elseif isnoun(name, j2) then
                        table.insert(sub_result["noun"], {string.sub(name, 7), j2})
					elseif isgroupglyph(name, j2) then
                        table.insert(sub_result["group"], {string.sub(name, 7), j2})
					elseif isglyphnot(name, j2) then
                        table.insert(sub_result["glyphnot"], {string.sub(name, 7), j2})
					elseif isprefix(name, j2) then
                        table.insert(sub_result["prefix"], {string.sub(name, 7), j2, {}})
					elseif isinfix(name, j2) then
                        table.insert(sub_result["infix"], {string.sub(name, 7), j2, infixsurroundings[j2]})
					elseif isglyphand(name, j2) then
                        table.insert(sub_result["glyphand"], {string.sub(name, 7), j2, x +j[1], y + j[2]})

					elseif isverb(name, j2) then
						local away = false
						if ((j[1] == dir[1]) and (j[2] == dir[2])) then
							away = true
						end
						if (#verbargtypes[name] == 0) then
							away = false
						end
						local objects = {}
						if away then
							if (unitmap[(x + 2 * j[1]) + (y + 2 * j[2]) * roomsizex] ~= nil) then
								for i3, j3 in pairs(unitmap[(x + 2 * j[1]) + (y + 2 * j[2]) * roomsizex]) do
									local unit2 = getunitfromid(j3)
									local name2 = get_name_with_glyph_text_(unit2)
									local glyphtypes = matchglyphtype(name2, j3, verbargtypes[name], verbargextras[name])
									if (glyphtypes or isgroupglyph(name2, j3)) and isglyph(unit2) then
										if donegateglyph(x + 2 * j[1], y + 2 * j[2]) then
											table.insert(objects, {"not " ..string.sub( name2, 7), j3})
										else
											table.insert(objects, {string.sub(name2, 7), j3})
										end
									end
								end
							end
						end
						table.insert(sub_result["verb"], {string.sub(name, 7), j2, away, objects})
					end
				end
            end
            if donegateglyph(x+ j[1], y + j[2]) then
                for i2, j2 in pairs(sub_result["prop"]) do
                    sub_result["prop"][i2][1] = "not " .. sub_result["prop"][i2][1]
                end
                for i2, j2 in pairs(sub_result["noun"]) do
                    sub_result["noun"][i2][1] = "not " .. sub_result["noun"][i2][1]
                end
                for i2, j2 in pairs(sub_result["group"]) do
                    sub_result["group"][i2][1] = "not " .. sub_result["group"][i2][1]
                end
                for i2, j2 in pairs(sub_result["prefix"]) do
                    sub_result["prefix"][i2][1] = "not " .. sub_result["prefix"][i2][1]
                end
                for i2, j2 in pairs(sub_result["infix"]) do
                    sub_result["infix"][i2][1] = "not " .. sub_result["infix"][i2][1]
                end
            end
            for i2, j2 in pairs(sub_result["noun"]) do
                table.insert(return_table["noun"], j2)
            end
            for i2, j2 in pairs(sub_result["group"]) do
                table.insert(return_table["group"], j2)
            end
            for i2, j2 in pairs(sub_result["prop"]) do
                table.insert(return_table["prop"], j2)
            end
            for i2, j2 in pairs(sub_result["glyphnot"]) do
                table.insert(return_table["glyphnot"], j2)
            end
            for i2, j2 in pairs(sub_result["verb"]) do
                table.insert(return_table["verb"], j2)
            end
            for i2, j2 in pairs(sub_result["glyphand"]) do
                table.insert(return_table["glyphand"], j2)
            end
            for i2, j2 in pairs(sub_result["prefix"]) do
                table.insert(return_table["prefix"], j2)
            end
            for i2, j2 in pairs(sub_result["infix"]) do
                table.insert(return_table["infix"], j2)
            end
        end
    end
	nearbysave[x + y * roomsizex] = return_table
	return return_table
end

function getandparams(base_id, x, y, evaluate_, id)
	local return_table = {}
	local evaluate = evaluate_ or true
	if evaluate then
		for i,j in pairs(glyphnear) do
			if (unitmap[(x + j[1]) + (y + j[2]) * roomsizex] ~= nil) and inbounds(x + j[1], y + j[2]) then
				for i2,v2 in pairs(unitmap[(x + j[1]) + (y + j[2]) * roomsizex]) do
					if (v2 == base_id) then
						goto continue
					end
					local unit = getunitfromid(v2)
					local name = get_name_with_glyph_text_(unit)
					local meta_prefix = metaprefix(x + j[1], y +j[2])
					local currmetas = getmetas(x + j[1], y +j[2])
					if isnoun(name, v2) or isprop(name, v2) or isgroupglyph(name, v2) or isprefix(name, v2) or isinfix(name, v2) then
						if donegateglyph(x + j[1], y +j[2]) and (meta_prefix == "") then
							table.insert(return_table, {"not " .. string.sub(name, 7),v2,currmetas})
						elseif (meta_prefix ~= "") then
							table.insert(return_table, {get_meta_connected(meta_prefix,name),v2,currmetas})
						else
							table.insert(return_table, {string.sub(name, 7),v2,currmetas})

						end
					end
					::continue::
				end
			end
		end
	else
		for i, j in pairs(surroundings[id]) do
			if (j[2] ~= base_id) then
				table.insert(return_table, j)
			end
		end
	end
	return return_table
end

function getinfixparams(infix_name, base_id, x, y, evaluate_, id)
	local return_table = {}
	local return_table2 = {}
	local evaluate = evaluate_
	if (evalute == nil) then
		evaluate = 1
	end
	if (evaluate_ == nil) then
		for i,j in pairs(glyphnear) do
			if (unitmap[(x + j[1]) + (y + j[2]) * roomsizex] ~= nil) and inbounds(x + j[1], y + j[2]) then
				for i2,v2 in pairs(unitmap[(x + j[1]) + (y + j[2]) * roomsizex]) do
					if (v2 == base_id) then
						goto continue
					end
					local unit = getunitfromid(v2)
					local name = get_name_with_glyph_text_(unit)
					local meta_prefix = metaprefix(x + j[1], y +j[2])
					if matchglyphtype(name, v2, infixargtypes[infix_name], infixargextras[infix_name]) then
						if donegateglyph(x + j[1], y +j[2]) and (meta_prefix == "") then
							table.insert(return_table, "not " .. string.sub(name, 7))
						elseif (meta_prefix ~= "") then
							table.insert(return_table, get_meta_connected(meta_prefix,name))
						else
							table.insert(return_table, string.sub(name, 7))
						end
						table.insert(return_table2, v2)
					end
					::continue::
				end
			end
		end
		return return_table, return_table2
	else
		for i, j in pairs(infixsurroundingsids[id]) do
			if (j ~= base_id) then
				table.insert(return_table, infixsurroundings[id][i])
				table.insert(return_table2, j)
			end
		end
		return return_table, return_table2
	end
end

local function getnounandparamstile(x, y, id)
	local return_table = {}
	if nounandparam[x + y * roomsizex] == nil then
		local return_table2 = {}
		for i,j in pairs(glyphnear) do
			local currmetas = getmetas(x + j[1], y + j[2])
			if (unitmap[(x + j[1]) + (y + j[2]) * roomsizex] ~= nil) and inbounds(x + j[1], y + j[2]) then
				for i2,v2 in pairs(unitmap[(x + j[1]) + (y + j[2]) * roomsizex]) do
					local unit = getunitfromid(v2)
					local name = get_name_with_glyph_text_(unit)
					local meta_prefix = metaprefix(x + j[1], y +j[2])
					if isnoun(name, v2) then
						if donegateglyph(x + j[1], y+ j[2]) and (meta_prefix == "") then
							table.insert(return_table, {"not " ..string.sub(name, 7),v2, currmetas})
							table.insert(return_table2, {"not " ..string.sub(name, 7),v2, currmetas})
						elseif (meta_prefix ~= "") then
							table.insert(return_table, {get_meta_connected(meta_prefix,name),v2, currmetas})
							table.insert(return_table2, {get_meta_connected(meta_prefix,name),v2, currmetas})
						else
							table.insert(return_table, {string.sub(name, 7),v2, currmetas})
							table.insert(return_table2, {string.sub(name, 7),v2, currmetas})
						end
					end
					if isglyphand(name, v2) then
						for i3,j3 in pairs(getandparams(nil, x + j[1], y + j[2], false, v2)) do
							if isnoun("glyph_" .. j3[1], j3[2]) or isgroupglyph("glyph_" .. j3[1], j3[2]) then
								table.insert(return_table2, j3)
								if j3[2] ~= id then
									table.insert(return_table, j3)
								end
							end
						end
					end
				end
			end
		end
		nounandparam[x + y * roomsizex] = return_table2
	else
		for i,j in pairs(nounandparam[x + y * roomsizex]) do
			if j[2] ~= id then
				table.insert(return_table, j)
			end
		end
	end
	return return_table
end

function getnounandparams(x, y, id)
	local return_table = getnounandparamstile(x, y, id)
	local noun = getunitfromid(id)
	local am_i_meta = metaprefix(x, y)
	local currmetas = getmetas(x, y)
	if donegateglyph(x, y) and (am_i_meta == "") then
		table.insert(return_table, {"not " .. string.sub(get_name_with_glyph_text_(noun), 7),id, currmetas})
	elseif (am_i_meta ~= "") then
		table.insert(return_table, {am_i_meta .. string.sub(get_name_with_glyph_text_(noun), 7),id, currmetas})
	else
		table.insert(return_table, {string.sub(get_name_with_glyph_text_(noun), 7),id, currmetas})
	end
	return return_table
end

function getpropandparams(x, y, id)
	local return_table = {}
	local prop = getunitfromid(id)
	local currmetas = getmetas(x, y)
	if donegateglyph(x, y) then
		table.insert(return_table, {"not " .. string.sub(get_name_with_glyph_text_(prop), 7),id, currmetas})
	else
		table.insert(return_table, {string.sub(get_name_with_glyph_text_(prop), 7),id, currmetas})
	end
	for i,j in pairs(glyphnear) do
		currmetas = getmetas(x + j[1], y + j[2])
		if (unitmap[(x + j[1]) + (y + j[2]) * roomsizex] ~= nil) and inbounds(x + j[1], y + j[2]) then
			for i2,v2 in pairs(unitmap[(x + j[1]) + (y + j[2]) * roomsizex]) do
				local unit = getunitfromid(v2)
				local name = get_name_with_glyph_text_(unit)
				if isprop(name, v2) or isgroupglyph(name,v2) then
					if donegateglyph(x + j[1], y+ j[2]) then
						table.insert(return_table, {"not " ..string.sub(name, 7),v2, currmetas})
					else
						table.insert(return_table, {string.sub(name, 7),v2, currmetas})
					end
				end
				if isglyphand(name, v2) then
					for i3,j3 in pairs(getandparams(id, x + j[1], y + j[2], false, v2)) do
						if isprop("glyph_" .. j3[1], j3[2]) or isgroupglyph("glyph_" .. j3[1], j3[2]) then
							table.insert(return_table, j3)
						end
					end
				end
			end
		end
	end
	return return_table
end

function getbothandparams(x, y, id)
	local return_table = {}
	local group = getunitfromid(id)
	local currmetas = getmetas(x, y)
	if donegateglyph(x, y) then
		table.insert(return_table, {"not " .. string.sub(get_name_with_glyph_text_(group), 7),id, currmetas})
	else
		table.insert(return_table, {string.sub(get_name_with_glyph_text_(group), 7),id, currmetas})
	end
	for i,j in pairs(glyphnear) do
		if (unitmap[(x + j[1]) + (y + j[2]) * roomsizex] ~= nil) and inbounds(x + j[1], y + j[2]) then
			for i2,v2 in pairs(unitmap[(x + j[1]) + (y + j[2]) * roomsizex]) do
				local unit = getunitfromid(v2)
				local name = get_name_with_glyph_text_(unit)
				if isglyphand(name, v2) then
					for i3,j3 in pairs(getandparams(id, x + j[1], y + j[2], false, v2)) do
						if isgroupglyph("glyph_" .. j3[1], j3[2]) or isnoun("glyph_" .. j3[1], j3[2]) or isprop("glyph_" .. j3[1], j3[2]) then
							table.insert(return_table, j3)
						end
					end
				end
			end
		end
	end
	return return_table
end

local function getproperbothandparamstile(x, y, id)
	local return_table = {}
	local noun = getunitfromid(id)
	local amnoun = isnoun(get_name_with_glyph_text_(noun))
	local trueid = 0
	if amnoun then
		trueid = (x + y * roomsizex) + ((roomsizex + 3) * (roomsizey + 3))
	else
		trueid = (x + y * roomsizex)
	end
	if properbothandparam[trueid] == nil then
		local return_table2 = {}

		for i,j in pairs(glyphnear) do
			local currmetas = getmetas(x + j[1], y + j[2])
			if (unitmap[(x + j[1]) + (y + j[2]) * roomsizex] ~= nil) and inbounds(x + j[1], y + j[2]) then
				for i2,v2 in pairs(unitmap[(x + j[1]) + (y + j[2]) * roomsizex]) do
					local unit = getunitfromid(v2)
					local name = get_name_with_glyph_text_(unit)
					local meta_prefix = metaprefix(x + j[1], y +j[2])
					if (isnoun(name, v2) and amnoun) or (isprop(name, v2) and not amnoun) then
						if donegateglyph(x + j[1], y+ j[2]) and (meta_prefix == "") then
							table.insert(return_table, {"not " ..string.sub(name, 7),v2, currmetas})
							table.insert(return_table2, {"not " ..string.sub(name, 7),v2, currmetas})
						elseif (meta_prefix ~= "") then
							table.insert(return_table, {get_meta_connected(meta_prefix,name),v2, currmetas})
							table.insert(return_table2, {get_meta_connected(meta_prefix,name),v2, currmetas})
						else
							table.insert(return_table, {string.sub(name, 7),v2, currmetas})
							table.insert(return_table2, {string.sub(name, 7),v2, currmetas})
						end
					end
					if isglyphand(name, v2) then
						for i3,j3 in pairs(getandparams(nil, x + j[1], y + j[2], false, v2)) do
							if isnoun("glyph_" .. j3[1], j3[2]) or isprop("glyph_" .. j3[1], j3[2]) or isgroupglyph("glyph_" .. j3[1], j3[2]) then
								table.insert(return_table2, j3)
								if (j3[2] ~= id) then
									table.insert(return_table, j3)
								end
							end
						end
					end
				end
			end
		end
		properbothandparam[trueid] = return_table2
	else
		for i,j in pairs(properbothandparam[trueid]) do
			if j[2] ~= id then
				table.insert(return_table, j)
			end
		end
	end
	return return_table
end

function getproperbothandparams(x, y, id)
	local return_table = getproperbothandparamstile(x, y, id)
	local noun = getunitfromid(id)
	local am_i_meta = metaprefix(x, y)
	local currmetas = getmetas(x, y)
	if donegateglyph(x, y) and (am_i_meta == "") then
		table.insert(return_table, {"not " .. string.sub(get_name_with_glyph_text_(noun), 7),id,currmetas})
	elseif (am_i_meta ~= "") then
		table.insert(return_table, {am_i_meta .. string.sub(get_name_with_glyph_text_(noun), 7),id,currmetas})
	else
		table.insert(return_table, {string.sub(get_name_with_glyph_text_(noun), 7),id,currmetas})
	end
	return return_table
end

function getprefixandparams(x, y, id)
	local return_table = {}
	local noun = getunitfromid(id)
	if donegateglyph(x, y) then
		table.insert(return_table, {"not " .. string.sub(get_name_with_glyph_text_(noun), 7),id})
	else
		table.insert(return_table, {string.sub(get_name_with_glyph_text_(noun), 7),id})
	end
	for i,j in pairs(glyphnear) do
		if (unitmap[(x + j[1]) + (y + j[2]) * roomsizex] ~= nil) and inbounds(x + j[1], y + j[2]) then
			for i2,v2 in pairs(unitmap[(x + j[1]) + (y + j[2]) * roomsizex]) do
				local unit = getunitfromid(v2)
				local name = get_name_with_glyph_text_(unit)
				if isprefix(name, v2) or isinfix(name, v2) then
					if donegateglyph(x + j[1], y+ j[2]) then
						table.insert(return_table, {"not " ..string.sub(name, 7),v2})
					else
						table.insert(return_table, {string.sub(name, 7),v2})
					end
				end
				if isglyphand(name, v2) then
					for i3,j3 in pairs(getandparams(id, x + j[1], y + j[2], false, v2)) do
						if isprefix("glyph_" .. j3[1], j3[2]) or isinfix( "glyph_" .. j3[1], j3[2]) then
							table.insert(return_table, j3)
						end
					end
				end
			end
		end
	end
	return return_table
end

function resetallmetaglyph()

end

function determinemetaglyphs(glyphtable)
	for i, j in pairs(glyphtable) do
		local unit = getunitfromid(j)
		local x, y = unit.values[XPOS], unit.values[YPOS]
		local prefix = metaprefix(x, y)
		if (prefix == "glyph_") then
			metaglyphdata[j] = 1
			tilemetaglyphdata[x + y * roomsizex] = 1
		elseif (prefix == "text_") then
			metaglyphdata[j] = 2
			tilemetaglyphdata[x + y * roomsizex] = 2
		else
			metaglyphdata[j] = 0
			tilemetaglyphdata[x + y * roomsizex] = 0
		end

	end
end

function concatglyphtables(t1, t2)
	local t3 = {}
	local includedgroups
	for i, j in pairs(t1) do
		table.insert(t3, j)
	end
	for i, j in pairs(t2) do
		table.insert(t3, j)
	end
	return t3
end

function getunitfromid(unitid)
	if (symbolmap[unitid] ~= nil) then
		return symbolmap[unitid]
	else
		return mmf.newObject(unitid)
	end
end

function doglyphs(symbols)
    local rules = {}
	local conds = {}
    local ids = {}
	local newglyphunits = {}
	metaglyphdata = {}
	surroundings = {}
	nounsurroundings = {}
	propsurroundings = {}
	infixsurroundings = {}
	infixsurroundingsids = {}
	negatetable = {}
	symbolmap = {}
	local rulecount = 0
	nounandparam = {}
	propandparam = {}
	bothandparam = {}
	properbothandparam = {}
	prefixandparam = {}
	tilemetaglyphdata = {}
	nearbysave = {}
	newglyphunits = copytable(newglyphunits, glyphunits)[1]
	for i, j in pairs(symbols) do
		if testcond(j[2],j[1]) then
			local unit = mmf.newObject(j[1])
			if unit ~= nil and not isglyph(unit) then
				local x, y, dir = unit.values[XPOS], unit.values[YPOS], unit.values[DIR]
				local unitname = getname(unit)
				local unittable = {}
				unittable.values = {}
				unittable.strings = {}
				unittable.fixed = j[1]
				unittable.values[XPOS] = x
				unittable.values[YPOS] = y
				unittable.values[DIR] = dir
				unittable.x = unit.x
				unittable.y = unit.y
				unittable.visible = unit.visible
				unittable.strings[UNITNAME] = "glyph_" .. unitname
				symbolmap[j[1]] =  unittable
				table.insert(newglyphunits, j[1])
			end
		end
	end
	determinemetaglyphs(newglyphunits)
	makenegatetable()
	local complexindex = 0
	for i,v in pairs(newglyphunits) do
        local unit = getunitfromid(v)
		setcolour(unit.fixed)
        local name = get_name_with_glyph_text_(unit)
        local x = unit.values[XPOS]
        local y = unit.values[YPOS]
		if isglyphand(name, v) then
			surroundings[v] = getandparams(nil, x, y)
		end
		
	end
	for i, v in pairs(newglyphunits) do
        local unit = getunitfromid(v)
        local name = get_name_with_glyph_text_(unit)
        local x = unit.values[XPOS]
        local y = unit.values[YPOS]
		if isinfix(name, v) then
			infixsurroundings[v], infixsurroundingsids[v] = getinfixparams(name, nil, x, y)
		end
		if isprefix(name, v) then
			infixsurroundings[v] = {}
			infixsurroundingsids[v] = {}
		end
	end
	for i,v in pairs(newglyphunits) do
        local unit = getunitfromid(v)
        local name = get_name_with_glyph_text_(unit)
        local x = unit.values[XPOS]
        local y = unit.values[YPOS]
		if isnoun(name, v) then
			local nouns = getnounandparams(x, y, v)
			local both = getproperbothandparams(x, y, v)
			surroundings[v] = both
			nounsurroundings[v] = nouns
			complexindex = complexindex + #both
		end
		if isprop(name, v) then
			local props = getpropandparams(x, y, v)
			local both = getproperbothandparams(x, y, v)
			surroundings[v] = both
			propsurroundings[v] = props
			complexindex = complexindex + #both
		end
		if isgroupglyph(name, v) then
			local nouns = getnounandparams(x, y, v)
			local props = getpropandparams(x, y, v)
			local both = getbothandparams(x, y, v)
			surroundings[v] = both
			propsurroundings[v] = props
			nounsurroundings[v] = nouns
			complexindex = complexindex + #both
		end
		if isprefix(name, v) then
			surroundings[v] = getprefixandparams(x, y, v)
		end
		if isinfix(name, v) then
			surroundings[v] = getprefixandparams(x, y, v)
		end
	end

    for i,v in pairs(newglyphunits) do
        local unit = getunitfromid(v)
        local name = get_name_with_glyph_text_(unit)
        if isnoun(name, v) or isgroupglyph(name, v) then
            local x = unit.values[XPOS]
            local y = unit.values[YPOS]
			local negation = donegateglyph(x, y)
			local nearglyphs = nearbyglyphs(x, y, v)
			local andextras = nounsurroundings[v]
			local basicsubconds = {}
			local condids = {}
            for i2, v2 in pairs(nearglyphs["prefix"]) do
				for i3, v3 in pairs(surroundings[v2[2]]) do
					local doprefix = isprefix("glyph_" .. v3[1])
					local doinfix = isinfix("glyph_" .. v3[1])
					if (basicsubconds[v3[1]] == nil) then
						if doinfix then
							basicsubconds[v3[1]] = {}
						elseif doprefix then
							basicsubconds[v3[1]] = 0
						end
					end
					if doinfix then
						local table1, table2 = getinfixparams("glyph_" .. v3[1], v, nil, nil, 2,v3[2])
						if #table1 > 0 then
							table.insert(basicsubconds[v3[1]], table1)
							for i4, v4 in pairs(table2) do
								table.insert(condids, v4)
							end
							if #table1 > 0 then
								table.insert(condids, v3[2])
							elseif #basicsubconds[v3[1]] == 0 then
								basicsubconds[v3[1]] = nil
							end
						end
					elseif doprefix then
						basicsubconds[v3[1]] = basicsubconds[v3[1]] + 1
						table.insert(condids, v3[2])
					end
				end
            end
            for i2, v2 in pairs(nearglyphs["infix"]) do
				local firstinfix = true
				for i3, v3 in pairs(surroundings[v2[2]]) do
					local doprefix = isprefix("glyph_" .. v3[1])
					local doinfix = isinfix("glyph_" .. v3[1])
					if (basicsubconds[v3[1]] == nil) then
						if doinfix then
							basicsubconds[v3[1]] = {}
						elseif doprefix then
							basicsubconds[v3[1]] = 0
						end
					end
					if doinfix then
						local table1, table2 = 0,0
						if firstinfix then
							table1, table2 = getinfixparams("glyph_" .. v3[1], v, nil, nil, 2,v3[2])
						else
							table1, table2 = getinfixparams("glyph_" .. v3[1], nil, nil, nil, 2,v3[2])
						end
						if #table1 > 0 then
							table.insert(basicsubconds[v3[1]], table1)
							for i4, v4 in pairs(table2) do
								table.insert(condids, v4)
							end
							if #table1 > 0 then
								table.insert(condids, v3[2])
							elseif #basicsubconds[v3[1]] == 0 then
								basicsubconds[v3[1]] = nil
							end
						elseif firstinfix then
							break
						end
					elseif doprefix then
						basicsubconds[v3[1]] = basicsubconds[v3[1]] + 1
						table.insert(condids, v3[2])
					end
					firstinfix = false
				end
            end
			local subconds = {}
			for i2, v2 in pairs(basicsubconds) do
				if isinfix("glyph_" .. i2) then
					for i3, v3 in pairs(v2) do
						table.insert(subconds, {i2, v3})
					end
				elseif isprefix("glyph_" .. i2) then
					for z=1,v2 do
						table.insert(subconds, {i2, {}})
					end
				end
			end
            for i2, v2 in pairs(nearglyphs["prop"]) do
				propextras = propsurroundings[v2[2]]
				for i3, v3 in pairs(andextras) do
					for i4, v4 in pairs(propextras) do
						if v4[2] ~= v3[2] then
							rulecount = rulecount + 1
							table.insert(rules, {v3[1], "is", v4[1]})
							local currentids = {{v3[2]}, {v4[2]}}
							for i5, v5 in pairs(condids) do
								table.insert(currentids, {v5})
							end
							for i5, v5 in pairs(v3[3]) do
								table.insert(currentids, {v5})
							end
							table.insert(ids, currentids)
							table.insert(conds, subconds)
						end
						if rulecount > 3000 then
							destroylevel("toocomplex")
							return "stop"
						end
					end
				end
            end
            for i2, v2 in pairs(nearglyphs["group"]) do
				local propextras = propsurroundings[v2[2]]
				for i3, v3 in pairs(andextras) do
					for i4, v4 in pairs(propextras) do
						if v4[2] ~= v then
							rulecount = rulecount + 1
							table.insert(rules, {v3[1], "is", v4[1]})
							local currentids = {{v3[2]}, {v4[2]}}
							for i5, v5 in pairs(condids) do
								table.insert(currentids, {v5})
							end
							for i5, v5 in pairs(v3[3]) do
								table.insert(currentids, {v5})
							end
							table.insert(ids, currentids)
							table.insert(conds, subconds)
						end
						if rulecount > 3000 then
							destroylevel("toocomplex")
							return "stop"
						end
					end
				end
            end
            for i2, v2 in pairs(nearglyphs["verb"]) do
                if v2[3] then
					for i3, v3 in pairs(v2[4]) do
						propextras = {}
						local hasprop = false
						local hasnoun = false
						for i,j in pairs(verbargtypes["glyph_" .. v2[1]]) do
							if (j == 0) then
								hasnoun = true
							elseif (j == 2) then
								hasprop = true
							end
						end
						if (#verbargextras["glyph_" .. v2[1]] > 0) then
							propextras = surroundings[v3[2]]
							for i4, v4 in pairs(andextras) do		
								for i5, v5 in pairs(propextras) do
									if matchglyphtype("glyph_" .. v5[1], v5[2], verbargtypes["glyph_" .. v2[1]], verbargextras["glyph_" .. v2[1]]) then
										rulecount = rulecount + 1
										table.insert(rules, {v4[1], v2[1], v5[1], false})
										local currentids = {{v4[2]}, {v5[2]}, {v2[2]}}
										for i6, v6 in pairs(condids) do
											table.insert(currentids, {v6})
										end
										for i6, v6 in pairs(v4[3]) do
											table.insert(currentids, {v6})
										end
										for i6, v6 in pairs(v5[3]) do
											table.insert(currentids, {v6})
										end
										table.insert(ids, currentids)
										table.insert(conds, subconds)
									end
									if rulecount > 3000 then
										destroylevel("toocomplex")
										return "stop"
									end
								end
							end
						else
							if hasnoun and not hasprop then
								propextras = nounsurroundings[v3[2]]
							elseif not hasnoun and hasprop then
								propextras = propsurroundings[v3[2]]
							elseif hasnoun and hasprop then
								propextras = surroundings[v3[2]]
							end
							for i4, v4 in pairs(andextras) do		
								for i5, v5 in pairs(propextras) do
									if matchglyphtype("glyph_" .. v5[1], v5[2], verbargtypes["glyph_" .. v2[1]], verbargextras["glyph_" .. v2[1]]) then
										rulecount = rulecount + 1
										table.insert(rules, {v4[1], v2[1], v5[1], false})
										local currentids = {{v4[2]}, {v5[2]}, {v2[2]}}
										for i6, v6 in pairs(condids) do
											table.insert(currentids, {v6})
										end
										for i6, v6 in pairs(v4[3]) do
											table.insert(currentids, {v6})
										end
										for i6, v6 in pairs(v5[3]) do
											table.insert(currentids, {v6})
										end
										table.insert(ids, currentids)
										table.insert(conds, subconds)
									end
									if rulecount > 3000 then
										destroylevel("toocomplex")
										return "stop"
									end
								end
							end
						end
					end
				end
            end
        end
    end
	if (rulecount > 3000) then
		destroylevel("toocomplex")
		return "stop"
	end
    for i, v in pairs(rules) do
		if (string.sub(v[1],1,6) == "glyph_") then
			addoption({v[1], v[2], v[3]}, copyconds({}, conds[i]), ids[i], nil, nil, {"glyphrule", "metaglyph", v[1]})
		elseif string.sub(v[1],1,5) == "text_" then
			addoption({v[1], v[2], v[3]}, copyconds({}, conds[i]), ids[i], nil, nil, {"glyphrule", "metatext", "glyph_" .. string.sub(v[1],6)})
		else
			addoption({v[1], v[2], v[3]}, copyconds({}, conds[i]), ids[i], nil, nil, {"glyphrule"})
		end
    end
end

function isglyph(unit, unitname_)
	if (unit == nil) then
		return false
	end
	local unitname = unitname_
	if (unitname_ == nil) then
		unitname = unit.strings[UNITNAME]
	end
    return (string.sub(unitname,1, 6) == "glyph_")
end



table.insert(nlist.full, "glyph")
table.insert(nlist.short, "glyph")
table.insert(nlist.objects, "glyph")

--[[ NO BAD DON'T
for i,j in pairs(glyphtypes) do
	table.insert(nlist.full, "glyph_" .. i)
	table.insert(nlist.short, "glyph_" .. i)
	table.insert(nlist.objects, "glyph_" .. i)
end
--]]

function findsymbolunits()
	local result = {}
	local alreadydone = {}
	local checkrecursion = {}
	local related = {}
	
	local identifier = ""
	local fullid = {}
	
	if (featureindex["symbol"] ~= nil) then
		for i,v in ipairs(featureindex["symbol"]) do
			local rule = v[1]
			local conds = v[2]
			local ids = v[3]
			
			local name = rule[1]
			local subid = ""
			
			if (rule[2] == "is") then
				if ((objectlist[name] ~= nil) or ((name == "text") and (#glyphunits > -1))) and (name ~= "glyph") and (alreadydone[name] == nil) then
					local these = findall({name,{}})
					alreadydone[name] = 1
					
					if (#these > 0) then
						for a,b in ipairs(these) do
							local bunit = mmf.newObject(b)
							local unitname = ""
							if (name == "glyph") then
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
						
						if (firstunit.strings[UNITNAME] ~= "text_" .. name) and (firstunit.strings[UNITNAME] ~= "text_" .. notname) and (firstunit.strings[UNITNAME] ~= "glyph_" .. name) and (firstunit.strings[UNITNAME] ~= "glyph_" .. notname) then
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
			
			for i,v in ipairs(featureindex["symbol"]) do
				local rule = v[1]
				local ids = v[3]
				local tags = v[4]
				
				if (rule[1] == b) or ((rule[1] == "glyph") and (string.sub(b, 1, 6) == "glyph_")) or (rule[1] == "all") or ((rule[1] ~= b) and (string.sub(rule[1], 1, 3) == "not")) and (rule[3] == "symbol") then
					for c,g in ipairs(ids) do
						for a,d in ipairs(g) do
							local idunit = mmf.newObject(d)
							local start = rule[1]
							if tags[2] == "metaglyph" then
								start = tags[3]
							elseif tags[2] == "metatext" then
								start = tags[3]
							end

							-- Tässä pitäisi testata myös Group!
							if (((tags[2] == "metatext") or (tags[2] == "metaglyph")) and (idunit.strings[UNITNAME] == start)) or ((idunit.strings[UNITNAME] == "text_" .. start) and (tags[1] ~= "glyphrule")) or (idunit.strings[UNITNAME] == "glyph_" .. start) or ((idunit.strings[UNITNAME] == start) and (tags[1] ~= "glyphrule")) or ((start == "all") and (name ~= "text")) then
								--MF_alert("Matching objects - found")
								found = true
							elseif (string.sub(start, 1, 5) == "group") then
								--MF_alert("Group - found")
								found = true
							elseif (start ~= checkname) and (((string.sub(start, 1, 3) == "not") and (start ~= "text")) or ((start == "not all") and (start == "text"))) then
								--MF_alert("Not Object - found")
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
				identifier = "null"
				symbolunits = {}
				
				for i,v in pairs(featureindex["symbol"]) do
					local rule = v[1]
					local ids = v[3]
					
					--MF_alert("Checking to disable: " .. rule[1] .. " " .. ", not " .. b)
					
					if (rule[1] == b) or (rule[1] == "not " .. b) then
						v[2] = {{"never",{}}}
					end
				end
				
				if (string.sub(checkname, 1, 4) == "not ") then
					local notrules_symbol = notfeatures["symbol"]
					local notrules_id = checkname_[2]
					local disablethese = notrules_symbol[notrules_id]
					
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

function checksymbolchanges(unitid,unitname)
	if (#symbolunits > 0) then
		for i,v in ipairs(symbolunits) do
			if (v[1] == unitid) then
				updatecode = 1
				return
			end
		end
	end
	
	if (#symbolrelatedunits > 0) then
		for i,v in ipairs(symbolrelatedunits) do
			if (v[1] == unitid) then
				updatecode = 1
				return
			end
		end
	end
end

gl_isnoun = isnoun

function add_glyph_using_text(name)
	local textname = "text_" .. name
	local textdata = editor_objlist[textname]
	if textdata == nil then
		error("Glyph was attempted to be added before it's text was added")
		return false
	end

	local type = textdata.type

	if type == 5 then
		error("Attempting to add a letter glyph - glyphs don't have letters")
		return false
	end
	if type == 7 then type = 8
	elseif type == 3 then type = 7 end
	if string.sub(name,1,5) == "group" then type = 3 end

	local glyph_data = {
		name = "glyph_"..name,
		sprite_in_root = false,
		unittype = "object",
		tags = {"abstract", "glyph"},
		tiling = -1,
		type = 0,
		layer = 1,
		colour = textdata.colour,
		colour_active = textdata.colour_active,
	}
	glyphtypes[name] = type
	if type == 1 then -- verb
		verbargtypes["glyph_" .. name] = textdata.argtype
		verbargextras["glyph_" .. name] = textdata.argextra or {}
	elseif type == 8 then
		infixargtypes["glyph_" .. name] = textdata.argtype
		infixargextras["glyph_" .. name] = textdata.argextra or {}
	end
	table.insert(editor_objlist_order, "glyph_" .. name)
	editor_objlist["glyph_" .. name] = glyph_data
	return true
end