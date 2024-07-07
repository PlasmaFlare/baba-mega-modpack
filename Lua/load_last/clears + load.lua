-- Both now clear FULLUNITLIST.
-- This now uses an insertion technique so I don't have to update these functions.
local oldclearunits = clearunits
function clearunits(restore_)
	fullunitlist = {}
	oldclearunits(restore_)
end
local oldinit = init
function init(tilemapid,roomsizex_,roomsizey_,tilesize_,Xoffset_,Yoffset_,generaldataid,generaldataid2,generaldataid3,generaldataid4,generaldataid5,spritedataid,vardataid,screenw_,screenh_)
	fullunitlist = {}
	oldinit(tilemapid,roomsizex_,roomsizey_,tilesize_,Xoffset_,Yoffset_,generaldataid,generaldataid2,generaldataid3,generaldataid4,generaldataid5,spritedataid,vardataid,screenw_,screenh_)
	unitreference["level"] = "level" -- fix stupid bug
end
