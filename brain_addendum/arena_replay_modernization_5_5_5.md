# Arena Replay Modernization 5.5.5 - Clone Mode Timeline Authority

Subsystem: mod-arena-replay / copied replay maps / clone timeline / packet filtering

## Context

Copied replay maps can now be entered, replay arena objects spawn, and the camera path is stable enough to watch. The next visible problem was that clone-mode replay still behaved partly like raw packet replay: viewers could sit through pre-match dead air, gates could be open during that empty period, and recorded object packets could recreate one visible side while the opposite team only existed as invisible actor tracks.

## Changes

- Added clone-mode timeline normalization around the first playable actor frame.
- Added clone-mode defaults under `ArenaReplay.Playback.CloneMode.*`.
- Added clone prewarm logging for every playable actor clone on both teams.
- Added clone visibility audit logging after clone scene build.
- Made gate, buff, Dalaran, and Ring timers relative to clone-mode match-open time.
- Filtered recorded object update, compressed update, destroy-object, despawn, and movement packets by default in clone mode.
- Parked the live viewer body at a fixed holding point with hidden, no-gravity, movement-locked, invisible-display guards.
- Changed actor camera application so a bound camera anchor moves by itself; the real viewer body is not teleported per actor frame.

## Architecture Contract

Copied-instance clone replay is authoritative from module-owned state:

- actor tracks drive clone movement
- replay objects drive gates, buffs, and arena machinery
- camera anchor or fixed overview drives view
- recorded world-object packets do not own player/gameobject visuals
- live viewer body stays hidden and parked

Future fixes for one-team visibility or pre-match timing should start with `SCENE_TIMELINE`, `CLONE_PREWARM`, `CLONE_VISIBILITY_AUDIT`, and `SCENE_READY` logs before touching map data or battleground systems.
