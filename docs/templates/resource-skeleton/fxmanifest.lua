fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'qbx-feature'
author 'Your Team'
version '0.1.0'
description 'QBCore extension — replace with feature name'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/main.lua',
}

client_scripts {
    'client/main.lua',
    'client/events.lua',
    -- 'client/ui.lua', -- if NUI
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/db.lua',
    'server/callbacks.lua',
    'server/events.lua',
    'server/api.lua',
}

-- Optional NUI (Distopia brand: copy logos into html/assets/brand/ — see docs/branding.md)
-- ui_page 'html/index.html'
-- files {
--     'html/index.html',
--     'html/css/**',
--     'html/js/**',
--     'html/assets/brand/**',
-- }

dependencies {
    'qb-core',
    'oxmysql',
    'ox_lib',
}
