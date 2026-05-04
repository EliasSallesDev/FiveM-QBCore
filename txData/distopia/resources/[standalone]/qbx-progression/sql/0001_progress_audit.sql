CREATE TABLE IF NOT EXISTS qbx_character_progress_audit (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  citizenid VARCHAR(50) NOT NULL,
  delta_xp INT NOT NULL,
  reason VARCHAR(64) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  KEY idx_citizenid_time (citizenid, created_at)
);
