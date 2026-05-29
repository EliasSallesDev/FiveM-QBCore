fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'trucking'
author 'Distopia'
version '0.1.0'
description 'Personal truck freight contracts with server-side validation and reputation'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locale/en.lua',
    'locale/*.lua',
    'config.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

dependencies {
    'qb-core',
    'qb-menu',
    'qb-inventory',
    'progressbar',
    'oxmysql',
    'PolyZone',
}
