# Arena Replay Modernization 5.5.2 — Private Phase Map Sandbox Correction

Date: 2026-05-02
Subsystem: mod-arena-replay / replay actor playback / sandbox attach
Status: patch prepared

## Context

Replay attach logging showed that playback knew the recorded arena map (`replayMap=572`) but the viewer remained on `playerMap=0`. A prior repair direction attempted to create and register a fresh battleground shell so `BattlegroundMgr::SendToBattleground` could resolve the instance.

That direction was rejected as architecturally wrong for RTG replay actor mode. Replay viewing must not create a live battleground/arena match through `BattlegroundMgr`, because that risks making the replay look like an active match and can reintroduce earlier scoreboard/team/arena-state pollution.

## Decision

Replay playback now uses a map-and-phase sandbox:

- no `CreateNewBattleground` for replay playback
- no `SendToBattleground` for replay playback
- no replay-owned battleground instance id
- direct teleport to the recorded map id from the replay record
- per-viewer private phase allocation so multiple replay viewers can watch without seeing each other
- actor clones and camera anchors are summoned into the viewer's active private phase and marked visible by summoner only
- teardown restores the viewer's original phase and anchor position without calling battleground leave for the replay sandbox path

## Expected log shape

A healthy replay start should retain `replayBg=0` / `playerBg=0` and show the viewer moving onto the recorded map with matching private phase:

```text
[RTG][REPLAY][ENTER_SANDBOX] ... replayBg=0 replayMap=572 replayPhase=<mask> playerPhase=<mask> ...
[RTG][REPLAY][ATTACH_OK] ... playerMap=572 replayMap=572 playerBg=0 sessionBg=0 playerPhase=<mask> replayPhase=<mask> hasBg=0 ...
```

`playerBg=0` is no longer a failure for replay playback. For the corrected architecture, it is expected.

## Guardrail

Do not repair future replay attach failures by routing the viewer through `BattlegroundMgr`, registering a new battleground, or setting a fake battleground id. The replay viewer is a cinematic visitor on the recorded map, isolated by phase and clone scene ownership.
