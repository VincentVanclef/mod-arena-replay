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


## RTG modernization pass: replay library / Apex-style history

This update pushes the module closer to a persistent replay library instead of a one-off replay launcher.

### Added
- **My recent matches** browser entry so players can reopen their own recent replay-eligible games without remembering IDs.
- **Recently watched** browser entry backed by a dedicated characters DB table.
- Automatic **watch history upsert** every time a replay is opened.
- `INSERT IGNORE` protection for saved favorites so duplicate saves do not spam errors.
- Configurable browser list sizing and history retention.
- Cleanup for orphaned recently watched rows when old replay rows are removed.

### New characters DB file
- `data/sql/db-characters/replayarena_recently_watched.sql`

### New/updated config keys
- `ArenaReplay.Library.BrowseLimit`
- `ArenaReplay.Library.RecentMatchesDays`
- `ArenaReplay.Library.RecentlyWatched.Enable`
- `ArenaReplay.Library.RecentlyWatched.RetentionDays`

### Practical result
Players now get a more modern replay flow:
- play match
- replay gets recorded
- reopen it from **My recent matches**
- rewatch it later from **Recently watched**
- optionally keep it forever in **My favorite matches**

That gives you a much better foundation for the “Apex replay” feel where a replay can stay part of a player’s personal library instead of being a temporary curiosity.
