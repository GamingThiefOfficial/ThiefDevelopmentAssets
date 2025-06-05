fx_version 'cerulean'
game 'gta5'

author 'Thief | GamingThief'
description 'Seatbelt script'
version '1.1'
lua54 'yes'

files {
    'html/index.html',
    'html/sounds/*.mp3'
}

server_script 'data/server.lua'

client_scripts {
    'data/client.lua'
}

shared_scripts{
    'config.lua'
}

ui_page 'html/index.html'

escrow_ignore{
    'config.lua'
}

-- For Seatbelt Sounds ( in Seatbelt/sounds/*.mp3 )
data_file 'AUDIO_WAVEPACK' 'sounds'