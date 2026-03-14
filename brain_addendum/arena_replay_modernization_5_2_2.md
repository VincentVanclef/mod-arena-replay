# Arena Replay modernization addendum 5.2.2

## Theme
Advance replay viewing toward a hidden spectator-anchor model so playback no longer shows the viewer body and only exposes playable actor POV targets.

## Delivered in this pass
- Kept the replay viewer hidden for the full session and restored visibility cleanly on exit.
- Filtered replay POV actor selection to only tracks that contain playable frame data.
- Rebased replay HUD actor totals onto playable tracks only, preventing dead/empty actor slots from polluting the `current/total` display.
- Excluded the local replay viewer from watcher HUD roster output.
- Reapplied hidden-viewer state during replay camera updates so map transfer or camera ticks do not accidentally reveal the anchor.
- Reduced unnecessary teleports by only relocating when the hidden anchor meaningfully drifts from the target frame.

## Why this matters
The prior viewer path could still expose a body-like anchor concept in edge cases and could advertise POV slots that had no usable frame data, which makes replay switching feel broken. This pass moves the system closer to a true spectator-anchor model even before a future clone-renderer exists.

## Testing targets
- replay POV total should only count viewable actors
- next/prev should never land on an unviewable target with no camera output
- replay scene should not visibly reveal the watcher body
- replay exit should always restore normal player visibility and movement
