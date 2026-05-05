RegisterNetEvent('qbx-skilltree:server:requestMenuData', function()
    local src = source
    local menuData = SkillTree.GetMenuData(src)

    if menuData then
        TriggerClientEvent('qbx-skilltree:client:skillTreeUpdated', src, menuData)
    end
end)
