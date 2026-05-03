# Arena Replay Modernization 5.5.7

## Date
2026-05-03

## Subsystem
mod-arena-replay copied-instance clone playback

## Context
Copied replay maps, replay objects, camera viewpoint, and clone visibility were largely working. The remaining test failures were: newly recorded replays still loaded with `hasAppearance=0`, all clones fell back to the generic display, Dalaran Sewers waterfall timing fired too early/too predictably, and replay teardown left the viewer floating with fly/no-gravity state still active.

## Changes
- Added early actor appearance capture during live arena join and live actor sampling.
- Preserved previously captured actor appearance snapshots during final save instead of clearing them at end-of-match.
- Added snapshot side reconciliation after winner/loser actor tracks are finalized.
- Added APPEARANCE_CAPTURE / APPEARANCE_PERSIST / APPEARANCE_LOAD diagnostics.
- Updated Dalaran Sewers replay water timing to use a deterministic replay-seeded 30-60 second warning delay, 5 second warning, 30 second active duration, and repeat scheduling.
- Hardened replay viewer movement restoration by clearing spectator state before movement restoration and removing replay movement flags where available.
- Added config documentation for appearance capture, Dalaran water live-like timing, and restore safety knobs.

## Expected Results
Newly recorded replays should log appearance capture during the arena and persist nonzero snapshot counts. Fresh replay playback should show `hasAppearance=1` and `CLONE_DISPLAY source=snapshot` once snapshots are captured and loaded. Dalaran water should no longer fire on a fixed 45 second one-shot cycle. Replay exit should make a stronger attempt to clear fly/no-gravity/hover state.

## Status
Patch prepared for compile/test pass. If the viewer still floats, inspect core-specific movement APIs or GM/fly state interactions next.
