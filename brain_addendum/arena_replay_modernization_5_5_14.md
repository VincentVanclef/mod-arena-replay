# Arena Replay Modernization 5.5.14 — Packet Stream Viewer GUID Safety

## Context
Recorded-packet visuals are now the preferred replay actor backend because creature clone actors cannot reproduce real player appearance or animation.

## Problem
The first viewer GUID isolation pass used raw byte-level GUID replacement inside arbitrary recorded packets. During testing this still allowed the viewer shell to appear as floating weapons and also introduced client fatal errors. The packet stream showed both teams more accurately, but packets containing the live viewer's original GUID were unsafe to send or mutate without opcode-aware rewriting.

## Change
This pass disables unsafe raw viewer-GUID remapping by default and instead skips recorded packets that contain the live viewer's own GUID. This intentionally omits the current viewer's replay actor from packet visuals until a proper opcode-aware object-update rewriter exists, but protects the live hidden spectator shell and avoids corrupting packet payloads.

## Config
- `ArenaReplay.ActorVisual.RecordedPacketStream.SkipViewerGuidPackets = 1`
- `ArenaReplay.ActorVisual.RecordedPacketStream.RemapViewerGuid = 0`

## Expected Behavior
- No creature clone actor bodies.
- Packet stream remains the authoritative visual layer.
- The viewer's own replay actor may be absent from visuals when watching their own replay.
- The hidden viewer should no longer appear as floating weapons/swords.
- Packet payloads containing the viewer GUID are skipped instead of byte-rewritten.
- Replay teardown should remain clean and client crashes from unsafe GUID replacement should stop.

## Future Work
A future packet-stream v3 should implement opcode-aware GUID remapping for `SMSG_UPDATE_OBJECT` / `SMSG_COMPRESSED_UPDATE_OBJECT` rather than raw byte replacement, allowing the viewer's own replay actor to appear safely as a separate visual object.
