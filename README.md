# This is a module for ![logo](https://raw.githubusercontent.com/azerothcore/azerothcore.github.io/master/images/logo-github.png) AzerothCore

## mod-arena-replay

# ![mod-arena-replay](https://github.com/azerothcore/mod-arena-replay/blob/main/icon.png?raw=true)

The arena replay module allows you to watch a replay of rated arena games (I think it can be modified to Replay BGs and Raid instances as well).

You can see a little bit of how the module works here:
https://www.youtube.com/watch?v=7z0RA6Dsm9s

### Known issue

it's not 100% done yet because if a player tries to watch a Replay of a game that he was in, the replay acts weirdly. Words of the guy who updated the module:
"try spectating as a player who wasn't involved in the arena
I need to change it so that it uses new duplicate players instead of"

### Usage

`.npc add 98500`

![image](https://github.com/user-attachments/assets/221b2304-218e-4a7b-a7c3-0cf07388319d)


### Credits

- Romain-P ([original author](https://gist.github.com/Romain-P/069749c3acced35f4b0ae6841cb94e79))
- thomasjteachey
- Laasker
- Helias


## RTG modernization notes

This branch adds a new **Replay Actor Spectate** layer. It does not yet spawn fully remapped clone units, but it records per-combatant actor tracks and uses them to drive a spectator follow camera that auto-cycles targets. That makes self-watch dramatically safer than the legacy packet-only camera path and moves the module closer to a future full clone-target implementation.

### New replay data
- `winnerActorTrack`
- `loserActorTrack`

### New config
- `ArenaReplay.ActorSpectate.Enable`
- `ArenaReplay.ActorSpectate.AutoCycleMs`
- `ArenaReplay.ActorSpectate.FollowDistance`
- `ArenaReplay.ActorSpectate.FollowHeight`
- `ArenaReplay.ActorSpectate.StartOnWinnerTeam`
- `ArenaReplay.ActorSpectate.StartOnSelfWhenParticipant`

### Important limitation
This is **clone-target spectating scaffolding**, not the final cloned-actor / GUID-remap engine. The camera now follows recorded participant tracks instead of relying only on winner/loser POV anchor tracks, but it still does not spawn fully remapped duplicate units yet.


## RTG clone-replay blueprint (prototype 1)

### Goal
Move replay playback away from placeholder goblin / packet-only viewing and toward replay-only participant clones.

### Architecture
1. **Recording layer**
   - keep packet capture
   - keep actor movement tracks
   - now also snapshot each participant `displayId`
2. **Prototype clone layer**
   - spawn replay-only creature clones from a dedicated world template entry
   - apply recorded display IDs to those clones
   - move clones using recorded actor frames
3. **Camera layer**
   - spectator camera follows the selected replay clone when clone mode is enabled
4. **Future layer (not in prototype 1)**
   - gear snapshots
   - aura state snapshots
   - packet GUID remap so spell visuals target clone GUIDs instead of historical player GUIDs

### What prototype 1 does
- spawns one replay creature per recorded actor
- uses the recorded player display ID where available
- replays movement from recorded actor tracks
- keeps existing packet playback intact for compatibility
- keeps existing HUD / actor-follow logic intact

### What prototype 1 does not do yet
- no gear appearance cloning yet
- no true spell/aura GUID remap yet
- no fake Player objects
- no equipment packet synthesis yet

### Setup requirements
Run the module world SQL so entry `98501` exists, then copy the new config block from `arena_replay.conf.dist`.

### Safe test plan
1. apply world + character SQL
2. rebuild module
3. record a fresh arena replay after the update
4. watch that new replay on a character that was **not** in the match
5. confirm clone bodies spawn and move
6. test self-watch next

Freshly recorded replays will benefit most because actor tracks now persist recorded display IDs.
