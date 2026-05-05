function Professions.InsertAudit(citizenid, professionId, amount, reason, level, xp)
    if not citizenid or not professionId then
        return
    end

    MySQL.insert([[
        INSERT INTO qbx_profession_audit (citizenid, profession_id, amount, reason, level_after, xp_after)
        VALUES (?, ?, ?, ?, ?, ?)
    ]], {
        citizenid,
        professionId,
        amount,
        reason,
        level,
        xp,
    })
end

function Professions.InsertSlotAudit(citizenid, oldSlots, newSlots, reason)
    if not citizenid then
        return
    end

    MySQL.insert([[
        INSERT INTO qbx_profession_slot_audit (citizenid, old_slots, new_slots, reason)
        VALUES (?, ?, ?, ?)
    ]], {
        citizenid,
        oldSlots,
        newSlots,
        reason,
    })
end
