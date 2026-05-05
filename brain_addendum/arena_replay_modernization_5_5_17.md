# Arena Replay Modernization 5.5.17 — Synthetic UNIT real-test readiness

## Context
The 5.5.16 synthetic emitter introduced safe replay-owned UNIT visuals, but its first fake GUIDs were low/player-shaped values and its display path still preferred captured player display IDs. That was not ideal for a first real Option C test because player-shaped GUIDs can be interpreted like player/self identities and raw player display IDs on non-player UNIT visuals can still render as pale or broken bodies.

## Changes
- Synthetic replay actor GUIDs now use a real 3.3.5 UNIT/Creature-style high GUID layout: `0xF130 | entry | lowGuid`.
- Added `ArenaReplay.ActorVisual.SyntheticReplayPacketEmitter.GuidLowBase` for session-local low-guid allocation.
- Added synthetic display controls:
  - `UsePlayerDisplayIds = 0` by default.
  - `UseNpcRaceFallbackDisplays = 1` by default.
  - `UseShapeshiftDisplays = 1` by default.
- Synthetic UNIT test visuals now favor stable textured fallback displays instead of raw player display IDs.
- Added `[RTG][REPLAY][SYNTHETIC_DISPLAY]` logging so each actor reports its chosen display and source.

## Expected test result
Backend 2 should now be safe enough for a real smoke test:
- no raw recorded packets
- no creature clones
- no player-shaped replay GUIDs
- replay-owned UNIT visuals with safe GUIDs
- deterministic create/move/destroy lifecycle
- visible fallback actors, even if not yet exact player armor

## Known limitation
This is still a synthetic UNIT emitter, not a true synthetic PLAYER-object emitter. Exact player armor/customization remains a later milestone.
