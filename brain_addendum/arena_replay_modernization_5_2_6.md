# Arena Replay Modernization 5.2.6

## Intent
Stabilize replay viewing around four live issues:
- older replay crash risk
- replay UI spam
- POV switching reliability
- replay viewer hide / cleanup discipline

## Files touched
- `src/ArenaReplay.cpp`
- `README.md`

## Functional changes
- sanitize loaded replay actor tracks before playback
- treat POV selection as a playable-actor operation instead of a raw track-count operation
- gate replay HUD traffic to active replay sessions only
- deduplicate watcher HUD payloads so unchanged watcher counts stop spamming chat/addon parsing
- enforce hidden spectator display state during playback, including an invisible local display override
- add short replay warmup before packet playback to reduce old-replay client load races
- strengthen replay cleanup flags so stale sessions are less likely to leak UI/control state

## Notes
This is still not a clone-renderer pass. It hardens the hidden spectator-anchor model and reduces unsafe legacy behavior while staying within the current code architecture.
