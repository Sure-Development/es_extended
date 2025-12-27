game 'gta5'
fx_version 'cerulean'

name 'Project Dogeaterx'
description 'The Core resource that provides the functionalities for all other resources.'
lua54 'yes'
version '2.1.0-pb'
git_version '2.1.0-pb'
use_experimental_fxv2_oal 'yes'
author 'ESX | Dogeaterx (Sure)'

dogeaterx_debug 'no'

shared_scripts {
	'@ox_lib/init.lua',

	'shared/main.lua',
	'shared/functions.lua',
	'shared/require.lua',
	'shared/modules/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',

	'server/init.lua'
}

client_scripts {
  'client/init.lua'
}

ui_page 'nui/dist/index.html'

files {
	'nui/dist/index.html',
	'nui/dist/assets/*.js',
	'nui/dist/assets/*.css',

	'locale.lua',
	'imports.lua',
	'shared/require.lua',

	--- Shared
	'settings/**/*.lua',
	'modules/**/*.lua',

	--- Store data
	'locales/*.json',
	'db/items.json',

	--- For: client
	'client/**/*.lua',
}

dependencies {
	'/native:0x6AE51D4B',
  '/native:0xA61C8FC6',
	'oxmysql',
	'ox_lib'
}
