# Arena Replay Modernization 5.5.4 - Copied Map Watchability Pass

Subsystem: mod-arena-replay / copied replay maps / clone scene / replay arena objects

## Context

Copied replay map entry is no longer the active blocker. Healthy startup now resolves native arena maps to copied replay maps, `TeleportTo` succeeds, attach succeeds, clone scene creation runs, and replay HUD playback can start while the viewer remains outside battleground state.

The next failure mode was scene watchability: repeated camera anchor summon failure caused fallback to the old live-body chase path, which made the hidden viewer body move and fall as the camera shell. Copied replay instances also cannot rely on permanent DB gameobject spawns for arena completion because the replay scene needs per-session object ownership and replay-time state.

## Changes

- Added camera anchor template validation before summon.
- Added per-session camera anchor failure flags, retry throttling, and log-once behavior.
- Added fixed arena overview fallback for missing camera anchors so the live viewer body is not used as a moving camera shell.
- Added `ArenaReplay.CloneScene.RequireCameraAnchor`, `DisableBodyChaseFallback`, `CameraAnchorRetryMs`, `CameraAnchorFailLogOnce`, `FallbackMode`, and per-map fallback position config.
- Expanded session-owned replay arena objects to include Nagrand and Blade's Edge structural blockers in addition to gates, buffs, Dalaran water, and Ring of Valor machinery.
- Moved distributed object config to `ArenaReplay.ReplayObjects.*`.
- Kept replay object spawning downstream of `ATTACH_OK` and upstream of clone scene creation.
- Added actor classification diagnostics so both teams' playable tracks and clone exclusions are visible in logs.
- Added cleanup logs for replay objects, camera anchor, clones, and state restore.

## Architecture Contract

Replay viewers remain copied-map cinematic visitors:

- no `CreateNewBattleground`
- no `SendToBattleground`
- no `SetupBattleground`
- no `SetBattlegroundId`
- no `LeaveBattleground`
- expected viewer state remains `playerBg=0`, `sessionBg=0`, and `InBattleground=false`

Future replay-watchability fixes should stay inside the copied-map attach, replay object, clone scene, camera anchor, fallback camera, and teardown surfaces.

## Healthy Signals

Camera-anchor missing template or summon failure should appear once per session, followed by `CAMERA_FALLBACK` when fallback mode is fixed overview.

Object startup should show `OBJECT_SPAWN` for session-owned replay objects before `CLONE_SCENE`. Gate `OBJECT_STATE` should open at replay time 0 when `StartWithGatesOpen=1`.

Clone scene diagnostics should include `ACTOR_CLASSIFY` lines for both winner and loser tracks and a `CLONE_SCENE` summary with total/playable/cloned actor counts.
