fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'QBCore Black Market'
author 'Your Name'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'qb-core',
    'qb-target',
    'ox_lib'
}
