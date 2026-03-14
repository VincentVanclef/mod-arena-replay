# Arena Replay modernization addendum 5.2.1

## Theme
Repair replay viewer isolation and spectator camera stability so replay playback behaves like a pure spectator feature instead of a live battleground participant.

## Delivered in this pass
- Returned replay viewer battleground entry to `TEAM_NEUTRAL` spectator flow.
- Stopped replay-instance add-player handling from treating the viewer as a recorded combatant.
- Fixed replay HUD/sysmessage formatting so literal `%s` no longer appears.
- Added replay-movement stabilization during playback with gravity disabled and hover/fly enabled.
- Restored viewer movement state on replay exit so levitation does not persist after leaving playback.
- Made actor POV stepping apply immediately instead of waiting for the next replay update tick.
- Reworked fallback spectator anchoring to use replay-space actor positions instead of the pre-replay world anchor.
- Fixed replay exit ordering so anchor data is still available when returning the player home.

## Why this matters
This is a direct player-experience patch. The replay viewer must be invisible to arena team state, must not poison actor counts, and must feel stable enough to rewatch repeatedly. Without that isolation, the replay looks broken even when the actor track data is valid.

## Testing targets
- replay UI team counts should no longer include the viewer
- next/prev actor stepping should move immediately
- leaving replay should restore normal gravity and movement flags
- replay viewer should not rubber-band or fall during playback
