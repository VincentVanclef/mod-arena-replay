# Arena Replay Modernization 5.5.9

## Chapter
5.5.9 — Inline Appearance Persistence and Flightless Spectator Parking

## Context
Copied-instance clone playback now enters replay maps, spawns replay arena objects, hides the viewer body, and shows both teams as clone bindings. The latest tests showed actor appearance capture firing during join/sample/save, but playback still loaded `snapshotCount=0`, forcing every clone to fall back to the configured display. Tests also showed the spectator shell could still leave the viewer with `canFly=1` after teardown.

## Changes
- Added optional inline `actorAppearanceSnapshots` storage on `character_arena_replays` so appearance data is saved with the replay row itself instead of depending only on the side table and replay id timing.
- Added serialization/deserialization for actor appearance snapshots and load-time merge with the existing side table.
- Added schema detection for the inline column and clear logs for inline schema/load/persist behavior.
- Added a fallback replay id lookup by match metadata before side-table persistence, so `LAST_INSERT_ID()` connection timing failures no longer silently skip side-table snapshot persistence.
- Updated spectator shell parking and fixed camera fallback to respect `ArenaReplay.SpectatorShell.UseFlightForParking = 0`, avoiding replay-created fly/no-gravity/hover flags during normal clone-mode viewing.
- Added a character DB update to add the inline snapshot column.

## Expected Proof
Fresh replay save should log snapshot capture, inline persist/save availability, and either side-table persistence with a valid replay id or inline snapshot availability. Playback should log `APPEARANCE_LOAD_INLINE snapshotCount > 0` and clones should use `source=snapshot` instead of `source=fallback`.

## Notes
Old replays without inline or side-table snapshots will still use generic fallback displays. New tests must use a freshly recorded match after this patch and after the character DB update has been applied.
