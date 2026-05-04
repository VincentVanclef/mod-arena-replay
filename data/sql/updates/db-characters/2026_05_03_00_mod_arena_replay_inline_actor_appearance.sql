-- RTG Arena Replay: inline actor appearance snapshot storage.
-- This keeps fresh clone-mode replays self-contained in character_arena_replays
-- and avoids depending on LAST_INSERT_ID()/side-table timing for appearance playback.

SET @arenaReplayDb := DATABASE();

SET @stmt := IF(
  EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = @arenaReplayDb
      AND TABLE_NAME = 'character_arena_replays'
      AND COLUMN_NAME = 'actorAppearanceSnapshots'
  ),
  'SELECT 1',
  'ALTER TABLE `character_arena_replays` ADD COLUMN `actorAppearanceSnapshots` LONGTEXT NULL AFTER `loserActorTrack`'
);
PREPARE stmt FROM @stmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
