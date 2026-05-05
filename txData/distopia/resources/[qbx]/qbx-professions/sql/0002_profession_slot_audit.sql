CREATE TABLE IF NOT EXISTS `qbx_profession_slot_audit` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `old_slots` INT NOT NULL,
  `new_slots` INT NOT NULL,
  `reason` VARCHAR(64) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_qbx_profession_slot_audit_citizenid` (`citizenid`)
);
