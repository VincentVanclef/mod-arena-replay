# Arena Replay Modernization 5.5.16 — Synthetic UNIT Visual Emitter Pass

## Chapter
5.5.16

## Date
2026-05-04

## Subsystem
mod-arena-replay / copied-map replay viewer / Option C synthetic visual backend

## Context
The previous 5.5.15 pass established the synthetic replay backend foundation. It disabled raw recorded packet playback by default, disabled creature actor clones, created originalGuid -> fake visualGuid planning, and kept the viewer GUID separate from replay actor identity.

## Situation
The next required step is a first visible synthetic packet layer that does not replay raw self/control packets and does not spawn creature actor clones. This pass introduces control-safe UNIT create/movement packets for replay actors using replay-only fake visual GUIDs.

## Implementation
- Added synthetic replay visual session tracking for created visual GUIDs, movement cadence, create/move counters, and teardown destroy state.
- Added first-pass synthetic UNIT packet builders:
  - `SMSG_UPDATE_OBJECT` create packet using `UPDATETYPE_CREATE_OBJECT2`.
  - `SMSG_UPDATE_OBJECT` movement packet using a minimal non-living position block.
  - `SMSG_UPDATE_OBJECT` out-of-range cleanup packet on teardown.
- Added stable low-range fake visual GUID generation for replay actors.
- Added synthetic actor creation after backend planning.
- Added synthetic actor movement synchronization during replay playback.
- Added synthetic visual destroy before replay teardown/return cleanup.
- Added configuration documentation and defaults for synthetic UNIT visual packet emission.

## Safety Doctrine
This pass intentionally emits `TYPEID_UNIT`, not `TYPEID_PLAYER`. The first visible synthetic layer is display-only and control-safe; it must not become the viewer client's active mover or controlled character. Raw recorded packets remain disabled for backend 2.

## Expected Logs
- `[RTG][REPLAY][SYNTHETIC_BACKEND]`
- `[RTG][REPLAY][SYNTHETIC_GUID_MAP]`
- `[RTG][REPLAY][SYNTHETIC_ACTOR_PLAN]`
- `[RTG][REPLAY][SYNTHETIC_ACTOR_CREATE]`
- `[RTG][REPLAY][SYNTHETIC_CREATE_SUMMARY]`
- `[RTG][REPLAY][SYNTHETIC_ACTOR_SYNC]` when verbose actor debugging is active
- `[RTG][REPLAY][SYNTHETIC_DESTROY]`

## Known Limitations
- This is not full player-object reconstruction yet.
- First-pass synthetic actors are UNIT visuals, so they may not render full player equipment/customization like true player objects.
- Movement uses safe position updates, not active player movement or spline movement yet.
- Later passes should evolve from UNIT visuals toward opcode-safe synthetic player-object create/update packets once the unit-layer safety is confirmed.

## Status
Implemented as the first visible Option C synthetic replay emitter step.
