-- Arena Replay schema sync for existing characters DB installs.
-- Fixes unknown column errors such as winnerActorTrack / loserActorTrack when module code is newer than the table schema.

SET @arenaReplayDb := DATABASE();

SET @stmt := IF(
  EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = @arenaReplayDb
      AND TABLE_NAME = 'character_arena_replays'
      AND COLUMN_NAME = 'winnerActorTrack'
  ),
  'SELECT 1',
  'ALTER TABLE `character_arena_replays` ADD COLUMN `winnerActorTrack` LONGTEXT NULL AFTER `loserPlayerGuids`'
);
PREPARE stmt FROM @stmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @stmt := IF(
  EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = @arenaReplayDb
      AND TABLE_NAME = 'character_arena_replays'
      AND COLUMN_NAME = 'loserActorTrack'
  ),
  'SELECT 1',
  'ALTER TABLE `character_arena_replays` ADD COLUMN `loserActorTrack` LONGTEXT NULL AFTER `winnerActorTrack`'
);
PREPARE stmt FROM @stmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @stmt := IF(
  EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = @arenaReplayDb
      AND TABLE_NAME = 'character_arena_replays'
      AND INDEX_NAME = 'idx_arena_type_timestamp'
  ),
  'SELECT 1',
  'ALTER TABLE `character_arena_replays` ADD INDEX `idx_arena_type_timestamp` (`arenaTypeId`, `timestamp`)'
);
PREPARE stmt FROM @stmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @stmt := IF(
  EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = @arenaReplayDb
      AND TABLE_NAME = 'character_arena_replays'
      AND INDEX_NAME = 'idx_times_watched_rating'
  ),
  'SELECT 1',
  'ALTER TABLE `character_arena_replays` ADD INDEX `idx_times_watched_rating` (`timesWatched`, `winnerTeamRating`)'
);
PREPARE stmt FROM @stmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @stmt := IF(
  EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = @arenaReplayDb
      AND TABLE_NAME = 'character_arena_replays'
      AND INDEX_NAME = 'idx_timestamp'
  ),
  'SELECT 1',
  'ALTER TABLE `character_arena_replays` ADD INDEX `idx_timestamp` (`timestamp`)'
);
PREPARE stmt FROM @stmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @stmt := IF(
  EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = @arenaReplayDb
      AND TABLE_NAME = 'character_saved_replays'
      AND INDEX_NAME = 'idx_replay_id'
  ),
  'SELECT 1',
  'ALTER TABLE `character_saved_replays` ADD INDEX `idx_replay_id` (`replay_id`)'
);
PREPARE stmt FROM @stmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
