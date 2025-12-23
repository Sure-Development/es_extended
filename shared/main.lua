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

---@class DEX
ESX = {}
DEBUG = (GetResourceMetadata('es_extended', 'dogeaterx_debug', 0) or 'no') == 'yes'
BOOTSTRAP = promise.new()

require('settings.locale')

exports('getSharedObject', function(targetFunc)
  Citizen.Await(BOOTSTRAP)

  if targetFunc and ESX[targetFunc] then
    return ESX[targetFunc]
  end

  return ESX
end)

AddEventHandler('esx:getSharedObject', function(cb)
  if ESX.IsFunctionReference(cb) then
    Citizen.Await(BOOTSTRAP)
    cb(ESX)
  end
end)
