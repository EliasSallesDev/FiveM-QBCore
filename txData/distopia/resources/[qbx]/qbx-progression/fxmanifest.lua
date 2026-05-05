fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'qbx-progression'
author 'Distopia'
version '0.1.0'
description 'Distopia character level and XP progression for QBCore'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locale/en.lua',
    'locale/pt-br.lua',
    'config.lua',
    'shared/main.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/db.lua',
    'server/callbacks.lua',
    'server/events.lua',
    'server/commands.lua',
    'server/api.lua',
}

dependencies {
    'qb-core',
    'oxmysql',
}
