CREATE TABLE IF NOT EXISTS `character_recently_watched_replays` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `character_id` INT NOT NULL,
  `replay_id` INT NOT NULL,
  `last_watched` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `watch_count` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_character_recent_replay` (`character_id`, `replay_id`) USING BTREE,
  INDEX `idx_character_last_watched` (`character_id`, `last_watched`) USING BTREE,
  INDEX `idx_replay_id` (`replay_id`) USING BTREE
) ENGINE=InnoDB CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
