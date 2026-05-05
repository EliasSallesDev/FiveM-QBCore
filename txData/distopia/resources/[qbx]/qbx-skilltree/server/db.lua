local schemaReady = false

function SkillTree.EnsureSchema()
    if schemaReady then
        return true
    end

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS qbx_skill_nodes (
          id BIGINT AUTO_INCREMENT PRIMARY KEY,
          citizenid VARCHAR(50) NOT NULL,
          tree_id VARCHAR(32) NOT NULL,
          node_id VARCHAR(64) NOT NULL,
          `rank` SMALLINT NOT NULL DEFAULT 1,
          allocated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          UNIQUE KEY uniq_player_node (citizenid, tree_id, node_id),
          KEY idx_citizenid (citizenid)
        )
    ]])

    schemaReady = true
    return true
end

function SkillTree.FetchAllocatedNodes(citizenid)
    if type(citizenid) ~= 'string' or citizenid == '' then
        return {}
    end

    SkillTree.EnsureSchema()

    local rows = MySQL.query.await(
        'SELECT tree_id, node_id, `rank`, allocated_at FROM qbx_skill_nodes WHERE citizenid = ?',
        { citizenid }
    ) or {}

    return rows
end

function SkillTree.UpsertAllocatedNode(citizenid, treeId, nodeId, rank)
    SkillTree.EnsureSchema()

    return MySQL.prepare.await([[
        INSERT INTO qbx_skill_nodes (citizenid, tree_id, node_id, `rank`)
        VALUES (?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE `rank` = VALUES(`rank`)
    ]], { citizenid, treeId, nodeId, rank }) ~= false
end

function SkillTree.DeleteAllocatedNodes(citizenid)
    SkillTree.EnsureSchema()

    return MySQL.prepare.await(
        'DELETE FROM qbx_skill_nodes WHERE citizenid = ?',
        { citizenid }
    )
end
