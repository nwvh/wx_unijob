-- [[ Resource Info ]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.0.0'
author 'wx / woox'
description 'FiveM Resource for managing multiple jobs'


-- [[ Client-Side Files ]]

client_scripts {
    'configs/unijob_client_editme.lua',
    'client/*.lua'
}

-- [[ Server-Side Files ]]

server_scripts {
    'configs/unijob_server_config.lua',
    'server/*.lua'
}

-- [[ Shared Files & Configs ]]

shared_scripts {
    '@ox_lib/init.lua',
    'configs/unijob_config.lua'
}

-- [[ Other Files ]]

files {
    'locales/*.json',
    'jobs/*.lua'
}

dependencies {
    'ox_target', -- https://github.com/overextended/ox_target
    'ox_lib',    -- https://github.com/overextended/ox_lib
    'wx_bridge'  -- https://github.com/nwvh/wx_bridge
}
