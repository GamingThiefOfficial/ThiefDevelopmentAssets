fx_version 'cerulean'
game 'gta5'

author 'GamingThief | Thief Development'
description 'Basic Remove AI Script'
version '1.0.0'
lua54 'yes'

escrow_ignore {
    'config.lua'
}

-- Specify the server script and client script
server_script 'script/server.lua'
client_script 'script/client.lua'

-- Specify the configuration file
shared_script 'config.lua'