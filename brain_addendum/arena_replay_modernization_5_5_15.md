# Arena Replay Modernization 5.5.15

Date: 2026-05-04
Subsystem: mod-arena-replay copied-map playback / actor visual backend

## Context

Packet-stream playback proved that real recorded packets can show real-looking player bodies, but it also proved that raw packet replay is unsafe as the final visual layer. Recorded packets can carry self, active-mover, and control state, which caused viewer-body artifacts, incorrect mover warnings, and client crashes when replay actors collided with the live viewer session.

## Change

This pass establishes the first safe foundation for Option C: `synthetic_replay_packet_emitter`.

`ArenaReplay.ActorVisual.Backend = 2` is now the default backend. It does not send raw recorded packets and does not spawn creature actor clones. Instead, it creates a stable per-session replay visual identity plan:

- `originalGuid` remains the actor GUID from the recorded match.
- `visualGuid` is a fake replay-only GUID planned for future opcode-safe visual packets.
- `viewerGuid` remains the logged-in character watching the replay and is never reused for replay actors.

## Implementation notes

Added backend planning logs:

- `[RTG][REPLAY][SYNTHETIC_BACKEND]`
- `[RTG][REPLAY][SYNTHETIC_GUID_MAP]`
- `[RTG][REPLAY][SYNTHETIC_ACTOR_PLAN]`
- `[RTG][REPLAY][SYNTHETIC_SCENE]`

Backend 2 is intentionally foundation-only in this pass. It logs all actor appearance/equipment/frame inputs required for the future synthetic packet emitter, but it does not yet emit player create/update packets.

## Safety decisions

- Raw recorded-packet playback now only activates when `ArenaReplay.ActorVisual.Backend = 3` and `ArenaReplay.ActorVisual.RecordedPacketStream.Enable = 1`.
- Backend 2 ignores stale `RecordedPacketStream.Enable` values so active configs cannot accidentally force unsafe raw replay packets.
- Clone mode is disabled for all non-creature backends.
- Replay timeline completion for synthetic mode is based on actor-frame duration, not raw packet drain.

## Expected behavior

With backend 2 selected, playback should safely enter copied replay maps, spawn replay arena objects, hide/park the viewer shell, bind HUD/camera, and produce synthetic planning logs. Full visible replay actors are expected in the next backend pass when opcode-safe synthetic create/update packets are implemented.

## Status

Foundation complete. Next pass should build the first safe synthetic actor object create/update packet using the planned fake visual GUIDs.
