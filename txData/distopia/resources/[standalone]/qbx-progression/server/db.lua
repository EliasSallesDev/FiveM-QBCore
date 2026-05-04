function Progression.InsertAudit(citizenid, amount, reason)
    if not citizenid or not amount or not reason then
        return false
    end

    local ok, err = pcall(MySQL.insert,
        'INSERT INTO qbx_character_progress_audit (citizenid, delta_xp, reason) VALUES (?, ?, ?)',
        { citizenid, amount, reason }
    )

    if not ok then
        print(('[qbx-progression] audit insert failed: %s'):format(tostring(err)))
        return false
    end

    return true
end
