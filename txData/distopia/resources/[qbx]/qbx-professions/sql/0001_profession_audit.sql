CREATE TABLE IF NOT EXISTS `qbx_profession_audit` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `profession_id` VARCHAR(32) NOT NULL,
  `amount` INT NOT NULL,
  `reason` VARCHAR(64) NOT NULL,
  `level_after` INT NOT NULL,
  `xp_after` INT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_qbx_profession_audit_citizenid` (`citizenid`),
  KEY `idx_qbx_profession_audit_profession` (`profession_id`)
);
