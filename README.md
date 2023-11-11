# Baba Is You - The MEGA MODPACK

<sub>~~(Yes I know a totally inspired name. I couldn't think of another name for this abomination)~~<sub>

This...... is a big one. A **BIG** modpack that merges several (curated) Baba Is You mods from various people into one GIANT (mostly working) MODPACK.

## But first, a (serious) disclaimer...
The Mega Modpack was done more for experimental reasons compared to [my main modpack](https://github.com/PlasmaFlare/plasma-baba-mods). As such, I am not as motivated to maintain the Mega Modpack when it comes to fixing all bugs and odd behaviors between mods. Therefore, expect there to be many bugs here and there. This is what you get when you try to combine code from different independent authors, without the luxury of coordinating between said authors like in an organized company.

When it comes to deciding which mods to merge, there will be several restrictions to prevent myself from being overwhelmed. Please note that if I didn't include your mod, it's **not** because I hate it. It's because adding more mods to this huge modpack can increase the risk for more bugs and add more tedium when maintaining the code. I have to be careful in choosing interesting mods that don't render the modpack too difficult to manage.

## Alright, serious time over! Where are the goods?!
### [Download the modpack in the Releases Section!](https://github.com/PlasmaFlare/baba-mega-modpack/releases)

**Compatable Baba version: 478f on PC**

The main version currently includes these mods (author handles are from discord):
- [Plasma's Modpack](https://github.com/PlasmaFlare/plasma-baba-mods) - By PlasmaFlare (@plasmaflare)
- [Patashu's Modpack](https://github.com/Patashu/Baba-is-You-Pata-Redux-Mods) - By Patashu (@patashu)
- Persist (From the levelpack "Persistence") - By Randomizer (@randomizer)
- Past - By Emily (@emilyemmi)
- Stringwords (STARTS/CONTAINS/ENDS) - By Wrecking Games (@wreckinggames)
- Word Salad (ALIVE/VESSEL/VESSEL2/KARMA/SINFUL/HOP) - By Huebaba (@huebird.)
- Visit - By Btd456Creeper (@btd456creeper)

# How to install
1. This modpack only works when you install into a levelpack. Pick an existing levelpack or create a new levelpack in the baba editor. (From baba title: `Level Editor -> Edit Levelpacks -> Create a new levelpack`)
    - Note that when installing a mod into a levelpack, the mod will only take effect within the levelpack itself.
2. Close the game and navigate to `<Baba game directory>\Data\Worlds\<world folder>`
    - If you created a new levelpack, `<world folder>` will most likely be named something like `63World`. To determine which folder is your levelpack, look in each folder for a `world_data.txt` file. Inside it, look for whatever you named your levelpack under `[General]`.
3. Edit `world_data.txt` and add `mods=1` underneath the `[General]` section.
    - `mods` will not be seen if you haven't configured your levelpack to enable modding.
4. Copy both `Lua` and `Sprites` folder to the levelpack folder. This should add the contents of `Sprites` to the one in the levelpack folder and also create (or update) the `Lua` folder in the levelpack.
5. And thats it! You can start baba again and navigate to the levelpack and start playing around.

# Where do I report bugs?
Feel free to submit an issue to this Github repository to report bugs.

If you are on the [Baba Is You Discord](https://discord.gg/GGbUUse), you can also report bugs in [#mega-modpack-bugs](https://discord.com/channels/556333985882439680/971375736713773076), which is a thread of #asset-is-make. You can also report bugs in #asset-is-make, but I recommend the first channel just to avoid spamming the other channels.

# Pending mods I'm looking to merge

### [Metatext Mod](https://github.com/EvanEMV/Baba-Is-You---Metatext-Mod) - By @EmilyEmmi
(Update 10/20/23)
I made good progress on this, and managed to get a working version done! However, I'm also considering to merge the glyph mod in. Since both metatext mod and glyph mod have significant changes to the codebase, there are prone to bugs and conflicts between mods. My plan currently is to release a beta version of the modpack with glyph + metatext in the Baba Is You discord. Then fix any bugs that arise as best as I can before releasing it officially. **However**, if there's any issues with the merge that is too much for me to handle in the long-term, there might be a change in plans. We'll see.

(Update 11/4/22)
Looks like Hempuli hasn't posted much updates on Baba Is You. So I'm *slightly* more inclined to proceed with adding the Metatext mod. However, after some initial investigations on the merge process, it looks like merging the metatext mod might be tricker than I thought. So I'm still hesitant to officially add the metatext mod to the main branch. But I'll see what I can do.

As of 5/1/22, Hempuli expressed thoughts of implementing metatext officially. And he even worked on an initial prototype last Baba stream. It is unknown if he will follow through with this, since I suspect there might be a lot of refactoring involved. If Hempuli doesn't follow through, then I'll add the mod as normal. Otherwise, I'll have to see how the metatext mod responds after Hempuli implements metatext officially.

### Glyph Mod - By @Mathguy24
(See most recent update under Metatext Mod)

# Changelog
- **1.3.2** (11/10/23)
  - [Persist x Word Salad] Support keeping PERSIST objects when entering a level with LEVEL IS ENTER.
  - [Word Salad x Plasma] Fixed error from moving a pointer noun on an ECHO object.
  - [Word Salad] Fixed KARMA/SINFUL status acting inconsistently after undoing a destruction.
  - [Word Salad] Fixed error from edge case involving LEVEL IS ECHO meta mechanic
  - [BTD456CREEPER] Update Glitch mod to 1.0.2
  - [Word Salad] Forgot to add "Word Salad" tag to ECHO
  - [Patashu] Added more tags for each added object.
  - [Btdcreeper] Offset mod 1.1 update
    - "Level Is Offset" now visually moves the outerlevel
    - Fixed a niche bug where the interaction with Locked/Still would be handled incorrectly in some cases
  - [Plasma] Update to 1.5.15
- **1.3.1** (10/23/23)
  - [WORD SALAD] Fixed ECHO plainly not working
  - Fixed erroring when selecting a level (oops bad echo merge)
  - [BTD456CREEPER] Updated glitch mod to 1.0.1
  - [BTD456CREEPER] Added "Glitch is BLOCK" as a baserule
  - [WORD SALAD] Updated to 1.4, which adds interactions with "LEVEL IS ENTER" and enables ECHO compatability with letters
  - [BTD456CREEPER x PLASMA and WORD SALAD] Support for edge cases involving nuhuh cancelling interactions involving ECHO and pointer nouns
- **1.3.0** (10/20/23)
  - [PLASMA] Updated for Plasma modpack version 1.5.14 ([See details here](https://github.com/PlasmaFlare/plasma-baba-mods/releases/tag/1.5.14))
  - [WORD SALAD] Updated to latest version that adds ECHO, ENTER, VEHICLE, REPENT, and HOPS
  - Added Local mod from Mathguy!
  - Added Btd456Creeper's mods: Glitch, Offset, and Nuhuh!
    - Also added Turning variants of Nuhuh and Offset
- **1.2.4** (7/15/23)
  - [PLASMA] Updated for Plasma modpack version 1.5.13 ([See details here](https://github.com/PlasmaFlare/plasma-baba-mods/releases/tag/1.5.13))
  - [VISIT] Updated to 1.2.4
    - "Fixed a bug where Visiting would be checked multiple times, causing a You And You object to Visit across two levels and "skip" the one in the middle"
- **1.2.3** (3/4/23)
  - Updated for Baba version 476
  - Fixed gui buttons not working after 476 update
  - [Plasma]: Updated to 1.5.12
- **1.2.2** (11/4/22)
  - [VISIT] Updated to 1.2.3. This should fix not being able to chain multiple visits.
- **1.2.1** (11/2/22)
  - Updated for Baba Version 473
  - [PLASMA] Update to 1.5.11
  - [VISIT] Updated to 1.2.2
  - [PERSIST] Fixed persisted objects going off-grid when level height is at certain values
  - [PATASHU] Fixed "LEVEL SHIFTS X" not working
  - [PAST] Fixed infinite past replay case when using a transformed text in a past rule
  - [PAST] Updated text display for past replay to show pause and fast forward controls
  - Added a dumb sound effect
- **1.2.0** (7/18/22)
  - Added Visit mod!
  - [VISIT x PERSIST] Support for persisting objects via Visit
  - [PERSIST] Fixed visual bug where persisted objects do not update sprites on start
  - [PLASMA] Update to 1.5.10
- **1.1.2** (6/17/22)
  - Fixed most modpack settings not properly applying
- **1.1.1** (6/12/22)
  - Updated for Baba version 469
  - [PLASMA] Updated for Plasma modpack version 1.5.8 ([See details here](https://github.com/PlasmaFlare/plasma-baba-mods/releases/tag/1.5.8))
  - [PLASMA] Fixed directional you not working properly
  - [WORD SALAD] LEVEL interactions with win/defeat didn't work due to a typo
  - [WORD SALAD] Fixed Karma status incorrectly updating on WEAK object when overlapped
  - [WORD SALAD x PATASHU] Implemented Karma system for OPENS/MELTS/DEFEATS/SINKS
  - [PERSIST] Added a modpack setting that toggles allowing the effects of PERSIST in the editor (If you win a level while having persist objects, those persist objects will carry over to the next level you play in the levelpack)
  - Added a "Restore Default Settings" button for each mod menu in the mega modpack settings.
  - Fixed "Level is you" + "orb is bonus" not working
  - Removed a bunch of unused sprites from Patashu's modpack
    - This should also fix "text_reverse" sprite showing incorrectly
- **1.1.0** (5/29/22)
  - Updated for Baba version 468C
  - [PLASMA] Updated for Plasma modpack version 1.5.7 ([See details here](https://github.com/PlasmaFlare/plasma-baba-mods/releases/tag/1.5.7))
  - [PLASMA] Fixed lua error from undoing a stableunit that was destroyed
  - [WORD SALAD] Updated Word Salad to include `karma`, `sinful`, and `hop`!
  - [WORD SALAD] Added a Word Salad settings menu the mega modpack settings
  - [PLASMA x PERSIST] Special handling of `stable` + `persist`
  - [PAST x PATASHU] If `reset` is triggered during a past replay, the replay stops and the level is reset
  - [PAST] Fixed negation not working with past rules (Ex: `past baba is not you`)