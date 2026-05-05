CREATE TABLE IF NOT EXISTS qbx_skill_nodes (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  citizenid VARCHAR(50) NOT NULL,
  tree_id VARCHAR(32) NOT NULL,
  node_id VARCHAR(64) NOT NULL,
  `rank` SMALLINT NOT NULL DEFAULT 1,
  allocated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_player_node (citizenid, tree_id, node_id),
  KEY idx_citizenid (citizenid)
);
