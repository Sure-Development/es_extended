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

Core = {}
Core.Input = {}
Core.Events = {}

---@type table<string, DEX.Item>
Core.Items = {}
Core.ItemsLoaded = false
Core.NUIReady = promise.new()

ESX.PlayerData = {}
ESX.PlayerLoaded = false

ESX.UI = {}
ESX.UI.Menu = {}
ESX.UI.Menu.RegisteredTypes = {}
ESX.UI.Menu.Opened = {}

ESX.Game = {}
ESX.Game.Utils = {}

CreateThread(function()
  while true do
    Wait(100)

    if NetworkIsPlayerActive(cache.playerId) then
      ESX.DisableSpawnManager()
      DoScreenFadeOut(0)
      Wait(500)
      TriggerServerEvent('esx:onPlayerJoined')
      break
    end
  end
end)

require('client.functions')
require('client.modules')
require('client.modules.services.scaleform')
require('client.modules.services.streaming')
require('client.modules.services.tree-viewer')
require('client.modules.services.admin')

BOOTSTRAP:resolve()
