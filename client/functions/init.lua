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

require('client.functions.services.callback')
require('client.functions.services.player-data')
require('client.functions.services.spawn')
require('client.functions.services.notification')
require('client.functions.services.ui')
require('client.functions.services.game')

RegisterNetEvent('esx:showNotification', ESX.ShowNotification)

RegisterNetEvent('esx:showAdvancedNotification', ESX.ShowAdvancedNotification)

RegisterNetEvent('esx:showHelpNotification', ESX.ShowHelpNotification)

AddEventHandler('onResourceStop', function(resourceName)
  for i = 1, #ESX.UI.Menu.Opened, 1 do
    if ESX.UI.Menu.Opened[i] then
      if ESX.UI.Menu.Opened[i].resourceName == resourceName or ESX.UI.Menu.Opened[i].namespace == resourceName then
        ESX.UI.Menu.Opened[i].close()
        ESX.UI.Menu.Opened[i] = nil
      end
    end
  end
end)
-- Credits to txAdmin for the list.
local mismatchedTypes = {
  [`airtug`] = 'automobile', -- trailer
  [`avisa`] = 'submarine', -- boat
  [`blimp`] = 'heli', -- plane
  [`blimp2`] = 'heli', -- plane
  [`blimp3`] = 'heli', -- plane
  [`caddy`] = 'automobile', -- trailer
  [`caddy2`] = 'automobile', -- trailer
  [`caddy3`] = 'automobile', -- trailer
  [`chimera`] = 'automobile', -- bike
  [`docktug`] = 'automobile', -- trailer
  [`forklift`] = 'automobile', -- trailer
  [`kosatka`] = 'submarine', -- boat
  [`mower`] = 'automobile', -- trailer
  [`policeb`] = 'bike', -- automobile
  [`ripley`] = 'automobile', -- trailer
  [`rrocket`] = 'automobile', -- bike
  [`sadler`] = 'automobile', -- trailer
  [`sadler2`] = 'automobile', -- trailer
  [`scrap`] = 'automobile', -- trailer
  [`slamtruck`] = 'automobile', -- trailer
  [`Stryder`] = 'automobile', -- bike
  [`submersible`] = 'submarine', -- boat
  [`submersible2`] = 'submarine', -- boat
  [`thruster`] = 'heli', -- automobile
  [`towtruck`] = 'automobile', -- trailer
  [`towtruck2`] = 'automobile', -- trailer
  [`tractor`] = 'automobile', -- trailer
  [`tractor2`] = 'automobile', -- trailer
  [`tractor3`] = 'automobile', -- trailer
  [`trailersmall2`] = 'trailer', -- automobile
  [`utillitruck`] = 'automobile', -- trailer
  [`utillitruck2`] = 'automobile', -- trailer
  [`utillitruck3`] = 'automobile', -- trailer
}

---@param model number|string
---@return string | boolean
function ESX.GetVehicleTypeClient(model)
  model = type(model) == 'string' and joaat(model) or model
  if not IsModelInCdimage(model) then
    return false
  end

  if not IsModelAVehicle(model) then
    return false
  end

  if mismatchedTypes[model] then
    return mismatchedTypes[model]
  end

  local vehicleType = GetVehicleClassFromName(model)
  local types = {
    [8] = 'bike',
    [11] = 'trailer',
    [13] = 'bike',
    [14] = 'boat',
    [15] = 'heli',
    [16] = 'plane',
    [21] = 'train',
  }

  return types[vehicleType] or 'automobile'
end

ESX.GetVehicleType = ESX.GetVehicleTypeClient
