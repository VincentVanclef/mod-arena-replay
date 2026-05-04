# Arena Replay Modernization 5.5.12 — Packet Stream Capture Safety

Date: 2026-05-04
Subsystem: mod-arena-replay / copied-instance recorded packet playback

## Context

The previous packet-stream pivot removed creature actor clones from the default visual path. Testing showed that the recorded packet backend produced real-looking packet actors, but it still had two major faults:

- only one team was reliably visible in some replays;
- the hidden spectator shell could appear as a floating pair of weapons when watching the replay, especially when the viewer was also a participant in the original match.

## Findings

Creature silhouette mode is no longer the correct target for final visuals. The module must treat the recorded packet stream as the authoritative actor visual layer when `ArenaReplay.ActorVisual.Backend = 3`.

However, packet recording was still too narrow and too late for reliable both-team playback. The capture hook ignored packets until `STATUS_IN_PROGRESS`, which can miss critical object create packets sent during arena preparation. It also used a one-recorder-per-team model by default, which can still miss client-specific create/update packets needed for full packet playback.

The spectator artifact was not a clone issue. It was the real hidden viewer body retaining visible virtual weapon slots while replay packets and invisible display morphing were active.

## Changes

- Packet capture now records visual packets before the gates open, stopping only when the battleground reaches wait-leave state.
- Added `ArenaReplay.ActorVisual.RecordedPacketStream.RecordAllParticipantPackets = 1` so packet visuals are captured from every arena participant instead of only one recorder per team.
- Added `ArenaReplay.ActorVisual.RecordedPacketStream.MaxPacketsPerReplay` as a safety cap.
- Added packet capture summary logging with per-team packet counts.
- Added `ArenaReplay.ActorVisual.RecordedPacketStream.RequirePackets = 1` so packet mode refuses empty visual streams instead of pretending an empty scene is healthy.
- Added `ArenaReplay.ActorVisual.RecordedPacketStream.FilterDestroyObjectPackets = 1` to reduce mixed-perspective destroy packets removing objects created by another participant’s stream.
- Added spectator shell virtual weapon stripping via `ArenaReplay.SpectatorShell.ClearViewerVisibleWeapons = 1`.
- Replay teardown restores the viewer’s previous virtual item slots.
- During packet playback the spectator shell continually reasserts invisible display, hidden state, and cleared virtual weapon slots so replay packets cannot resurrect the viewer’s weapon visuals.

## Expected Logs

Healthy fresh packet-backed recordings should show:

```txt
[RTG][REPLAY][PACKET_CAPTURE_SUMMARY] ... team0Packets>0 team1Packets>0 ... result=ok
[RTG][REPLAY][ACTOR_VISUAL_BACKEND] ... backend=recorded_packet_stream ... result=recorded_packet_stream_authoritative
[RTG][REPLAY][PACKET_VISUAL_SCENE] ... packets>0 result=use_recorded_packets_no_creature_clones
```

If a replay has no usable packet stream, packet backend should now log:

```txt
[RTG][REPLAY][PACKET_VISUAL_FAIL] ... reason=no_packets result=cancel
```

## Notes

This is still not full GUID remapping. It is a practical packet-backend stabilization pass meant to make fresh recordings carry both-team create/update packets and prevent the visible viewer-weapon artifact. If future tests still show viewer GUID collision beyond weapons, the next step is object GUID remapping for player update packets.
