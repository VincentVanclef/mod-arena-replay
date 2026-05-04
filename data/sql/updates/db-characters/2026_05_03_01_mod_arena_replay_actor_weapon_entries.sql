-- Arena Replay actor weapon item entries for creature clone virtual slots.

SET @arenaReplayDb := DATABASE();

SET @stmt := IF(
  EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = @arenaReplayDb
      AND TABLE_NAME = 'character_arena_replay_actor_snapshot'
      AND COLUMN_NAME = 'mainhand_item_entry'
  ),
  'SELECT 1',
  'ALTER TABLE `character_arena_replay_actor_snapshot` ADD COLUMN `mainhand_item_entry` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `ranged_display_id`'
);
PREPARE stmt FROM @stmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @stmt := IF(
  EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = @arenaReplayDb
      AND TABLE_NAME = 'character_arena_replay_actor_snapshot'
      AND COLUMN_NAME = 'offhand_item_entry'
  ),
  'SELECT 1',
  'ALTER TABLE `character_arena_replay_actor_snapshot` ADD COLUMN `offhand_item_entry` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `mainhand_item_entry`'
);
PREPARE stmt FROM @stmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @stmt := IF(
  EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = @arenaReplayDb
      AND TABLE_NAME = 'character_arena_replay_actor_snapshot'
      AND COLUMN_NAME = 'ranged_item_entry'
  ),
  'SELECT 1',
  'ALTER TABLE `character_arena_replay_actor_snapshot` ADD COLUMN `ranged_item_entry` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `offhand_item_entry`'
);
PREPARE stmt FROM @stmt;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
