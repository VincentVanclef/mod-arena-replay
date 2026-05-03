# Arena Replay Modernization 5.5.6 - Clone Display Fallbacks and Restore Verification

Subsystem: mod-arena-replay / copied replay maps / clone visibility / spectator restore

## Context

Clone prewarm and visibility audit proved that all actor bindings existed and both teams were present on the copied replay map, but every clone was counted as `invisibleDisplay`. The failure was display-level, not actor selection or team filtering. Missing appearance snapshots left clones on the clone creature template display, and that template can be invisible.

Replay exit also showed `canFly=1` after restore, meaning spectator-shell movement flags needed a harder verification step after cleanup and return.

## Changes

- Split actor clone summoning from camera anchor summoning.
- Added visible actor fallback display resolution under `ArenaReplay.CloneScene.FallbackDisplay.*`.
- Reworked clone appearance application so missing snapshots always receive a visible display.
- Added clone template invisibility detection and display repair logs.
- Kept spectator-shell invisible display out of actor fallback display resolution.
- Added `STATE_RESTORE_VERIFY` logging after replay state restore and force-clears fly, gravity, hover, spectator, visibility, display, and client control state.

## Healthy Signals

`CLONE_VISIBILITY_AUDIT` should move from `invisibleDisplay=6` to `invisibleDisplay=0` with visible counts matching team bindings.

`STATE_RESTORE_VERIFY` should report `hidden=0`, `canFly=0`, `disableGravity=0`, `hover=0`, and `clientControl=1`.
