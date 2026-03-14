# Arena Replay modernization addendum 5.2.0

## Theme
Push arena replay toward a persistent player replay library rather than a raw match-id lookup tool.

## Delivered in this pass
- Added personal **My recent matches** browser surface.
- Added personal **Recently watched** replay history surface.
- Added `character_recently_watched_replays` persistence table.
- Added cleanup path for stale watch-history rows.
- Added configurable replay browser limits and retention windows.
- Hardened favorite saves with duplicate-safe inserts.

## Why this matters
This moves the module closer to the desired Apex-style user flow:
1. player finishes a match
2. replay exists in a discoverable personal history
3. player can reopen it repeatedly
4. player can promote it to favorites for long-term retention

## Next logical modernization targets
- direct per-match detail page before launch
- timeline metadata (duration / timestamp / bracket / map / watched count)
- named camera perspectives and actor cycling UI hints
- optional scoreboard/Lua overlay for replay HUD state
- replay share / copy-match-id conveniences through scoreboard services
