# ArenaReplay modernization 5.4.0 — spectator shell + clone scene + viewpoint camera + hard teardown

## Intake signal
Live testing proved the previous surrogate pass was still structurally tied to the real viewer body:

- participants could still only see one side of the replay depending on selection path
- the viewer still felt physically present inside the replay arena instead of acting like a detached spectator shell
- replay teardown could still return the viewer with lingering levitate / no-jump state
- spectator camera ownership remained too loose because the hidden viewer body was still the main camera carrier

## Architectural verdict
The legacy model had reached its ceiling. ArenaReplay needed four explicit layers to become testable as a real replay scene:

1. **Spectator shell layer** — the viewer must be forced into spectator state and hidden.
2. **Replay clone scene layer** — replay actors must exist as synchronized scene surrogates for both teams.
3. **Viewpoint camera layer** — the replay camera must bind to a separate camera anchor rather than collapsing into the viewer body.
4. **Hard teardown layer** — replay exit must explicitly detach viewpoint, despawn scene entities, clear spectator state, and then restore world control.

## 5.4.0 action taken

### 1. Spectator shell activation
Replay entry now marks the viewer as a true spectator shell during replay startup instead of only hiding and movement-locking the body.

### 2. Clone-scene contract
Replay clone scene support is now an explicit subsystem with dedicated config keys:
- `ArenaReplay.CloneScene.Enable`
- `ArenaReplay.CloneScene.UseViewpoint`
- `ArenaReplay.CloneScene.CloneEntry`
- `ArenaReplay.CloneScene.CameraAnchorEntry`
- `ArenaReplay.CloneScene.SyncMs`

### 3. Separate replay camera anchor
Replay playback now builds a hidden camera anchor creature and binds the viewer viewpoint to that anchor. The anchor is moved using selected actor track follow math while the viewer shell stays hidden/spectator-owned.

### 4. Teardown hardening
Replay teardown now clears replay viewpoint binding before scene despawn, then restores spectator shell state after exit so levitate / no-jump fallout has a direct teardown owner.

## Expected proving targets
This pass is intended to make the following live checks possible in one test cycle:

- the replay viewer should no longer count as a normal arena participant once spectator state is honored by the branch
- self-watch should no longer collapse into the viewer body path
- both teams should exist in the replay clone scene instead of whichever side happened to survive the viewer-body ownership path
- replay end should release spectator movement state more cleanly

## Remaining risk
This is still not the final full cosmetic clone renderer because replay data does not yet include a persistent equipment/appearance snapshot. Actor bodies are still surrogate scene entities driven by actor-track position data.
