# Arena Replay modernization addendum 5.3.0

## Theme
Arena-only replay hardening focused on deterministic playback, safer teardown, and stronger actor-track validation.

## Delivered in this pass
- Tightened replay HUD gating so replay-only UI traffic only emits for the owning active replay session.
- Restricted watcher HUD state to viewers attached to the same replay session.
- Sanitized and de-duplicated replay actor tracks more aggressively.
- Forced immediate actor camera application when POV selection changes.
- Dropped unsafe client-origin opcodes from legacy replay playback streams.
- Rejected obviously oversized replay packet payloads during deserialization.
- Tuned arena-only playback pacing to gentler packet and camera cadence defaults.
- Simplified replay exit toward one safe battleground leave path with anchor fallback only when needed.

## Why this matters
The replay system was failing in three player-visible ways: actor switching did not feel authoritative, replay shutdown was unstable, and older replay payloads were trusted too much. This pass hardens those surfaces without pretending the module already has a full clone-renderer.

## Testing targets
- `.rtgreplay next` and `.rtgreplay prev` should visibly re-anchor to a new actor immediately.
- Replay watcher HUD should no longer count unrelated viewers.
- Replay end should be cleaner and less crash-prone.
- Legacy replays with unsafe packets should fail safer instead of replaying invalid client-origin payloads.
