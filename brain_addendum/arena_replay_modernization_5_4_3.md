# ArenaReplay modernization 5.4.3 — replay attach-state gate + Great Sea entry fix

## Problem observed
Replay startup was still executing clone-scene build, viewpoint binding, and first actor apply on the same path that queued the spectator into the replay battleground. In live testing this produced a race where arena coordinates were applied while the viewer was still on the source world map, causing Great Sea/fatigue teleports, abyss falls, and locked spectator-shell recovery states.

## Changes made
- Added an explicit replay attach-state gate to the active replay session.
- Delayed clone-scene build, viewpoint bind, HUD POV sync, and first actor apply until the viewer is fully attached to the replay battleground map and instance.
- Added new replay diagnostics:
  - `[RTG][REPLAY][ATTACH_WAIT]`
  - `[RTG][REPLAY][ATTACH_OK]`
  - `[RTG][REPLAY][ATTACH_TIMEOUT]`
- Added a guarded timeout path that tears the replay down instead of continuing to drive camera/apply logic against the wrong map context.
- Removed the stale hardcoded replay surrogate clone entry constant so clone-scene behavior stays config-backed.

## Why this matters
This pass converts replay entry from a fire-and-forget teleport sequence into a state machine with a real map-attach barrier. That barrier is now the owner of replay startup. Only after attach succeeds do replay operations begin.

## Remaining focus after this pass
- Validate that attach timeout returns players cleanly to anchor instead of leaving them in a spectator shell.
- Continue hardening replay teardown if any residual no-jump / canFly state remains after failed joins.
- Keep clone-scene work strictly downstream of attach success so future camera or actor changes cannot reintroduce the Great Sea regression.
