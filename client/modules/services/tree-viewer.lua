--[[
    _________________________________________
   |    __      _                            |
   |  o'')}____//      D O G E A T E R X     |
   |   `_/      )      Development           |
   |   (_(_/-(_/                             |
   |_________________________________________|

  Discord : https://discord.gg/Pnsta3xnZX

  ⚠  OUR CODE | THANKS FOR YOUR TRUSTED
--]]

local ui = require('settings.ui')

---@class Client.Module.Service.TreeViewer
local TREEVIEWER = {}

TREEVIEWER.show_ui = false

@onNui('ready', function(_, cb)
  cb({ offset = ui.offset })
  Core.NUIReady:resolve()
end)

@onNui('notification/ready', function(_, cb)
  cb({
    defaultLimit = ui.notification.default_limit,
    defaultTimeout = ui.notification.default_timeout
  })
end)

@onNui('close', function(_, cb)
  cb({})

  TREEVIEWER.show_ui = false
  @emitNui({
    type = 'toggle',
    data = TREEVIEWER.show_ui,
  })

  SetNuiFocus(false, false)
end)

@command('dbg', function(_, args)
  Citizen.Await(Core.NUIReady)

  if args[1] and args[1] == 'toggle' then
    TREEVIEWER.show_ui = not TREEVIEWER.show_ui
    @emitNui({
      type = 'toggle',
      data = TREEVIEWER.show_ui,
    })

    SetNuiFocus(TREEVIEWER.show_ui, TREEVIEWER.show_ui)
  elseif args[1] and args[1] == 'update' then
    @emitNui({
      type = 'update',
      data = ESX.PlayerData,
    })
  end
end, true)
