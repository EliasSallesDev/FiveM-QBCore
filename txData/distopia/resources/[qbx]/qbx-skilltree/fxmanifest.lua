fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'qbx-skilltree'
author 'Distopia'
version '0.1.0'
description 'Distopia skill tree allocation for QBCore'

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

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/**',
    'html/js/**',
    'html/assets/brand/**',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/db.lua',
    'server/main.lua',
    'server/callbacks.lua',
    'server/events.lua',
    'server/commands.lua',
    'server/api.lua',
}

dependencies {
    'qb-core',
    'oxmysql',
    'qbx-progression',
    'qbx-classes',
}
