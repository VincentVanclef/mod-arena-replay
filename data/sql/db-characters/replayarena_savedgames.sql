CREATE TABLE IF NOT EXISTS `character_saved_replays` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `character_id` INT NOT NULL,
  `replay_id` INT NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_saved_replay` (`character_id`, `replay_id`) USING BTREE
) ENGINE=InnoDB CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

SET @arenaReplayDb := DATABASE();

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
