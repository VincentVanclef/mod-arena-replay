# Arena Replay Modernization 5.5.7

## Appearance/camera follow-up

- Copied-instance clone replay now treats player appearance snapshots as base playable-model silhouettes, not full player outfit reconstruction.
- Weapon capture was split into legacy display ids and playback-safe item entries. Creature clone virtual item slots must receive item entries, never `ItemTemplate.DisplayInfoID`, or the client can render blue/white placeholder cubes.
- Inline appearance serialization was extended additively with `mainhandItemEntry`, `offhandItemEntry`, and `rangedItemEntry`; older snapshots still load with zero item entries and will clear clone weapon slots instead of applying display ids.
- The actor snapshot table has optional item-entry columns. Runtime code detects them before selecting/inserting those columns so older schemas remain loadable until SQL updates are applied.
- Creature clones still cannot show arbitrary player armor from base display ids alone. Future full-appearance paths remain: generated outfit DBCs, synthetic player-like ghost objects, or playerbot-backed replay bodies.
- Self POV must resolve to the viewer's replay clone and camera anchor. The hidden live player body must never become the replay actor/camera shell.
- Camera anchor movement now supports smoothing, vertical deadband, clone-position targeting, minimum anchor move distance, and minimum move intervals to reduce vertical jitter from raw actor Z frames.
