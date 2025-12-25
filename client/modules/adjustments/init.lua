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

local adjustment = require('settings.adjustments')

---@class Client.Module.Adjustment
local M = {}

function M:RemoveHudComponents()
  for i = 1, #adjustment.remove_hud_components do
    if adjustment.remove_hud_components[i] then
      SetHudComponentSize(i, 0.0, 0.0)
      SetHudComponentPosition(i, 900.0, 900.0)
    end
  end
end

function M:DisableAimAssist()
  if adjustment.disable_aim_assist then
    SetPlayerTargetingMode(3)
  end
end

function M:DisableNPCDrops()
  if adjustment.disable_npc_drops then
    local weaponPickups = { `PICKUP_WEAPON_CARBINERIFLE`, `PICKUP_WEAPON_PISTOL`, `PICKUP_WEAPON_PUMPSHOTGUN` }
    for i = 1, #weaponPickups do
      ToggleUsePickupsForPlayer(cache.playerId, weaponPickups[i], false)
    end
  end
end

function M:SeatShuffle()
  if adjustment.disable_vehicle_seat_shuffle then
    lib.onCache('vehicle', function(vehicle)
      if vehicle then
        CreateThread(function()
          while cache.vehicle do
            Wait(0)
            if GetPedInVehicleSeat(cache.vehicle, 0) == cache.ped then
              if GetIsTaskActive(cache.ped, 165) then
                SetPedIntoVehicle(cache.ped, GetVehiclePedIsIn(cache.ped, false), 0)
              end
            end
          end
        end)
      end
    end)
  end
end

function M:HealthRegeneration()
  CreateThread(function()
    while true do
      if adjustment.disable_health_regeneration then
        SetPlayerHealthRechargeMultiplier(cache.playerId, 0.0)
      end

      Wait(1000)
    end
  end)
end

function M:AmmoAndVehicleRewards()
  CreateThread(function()
    while true do
      if adjustment.disable_display_ammo then
        DisplayAmmoThisFrame(false)
      end

      if adjustment.disable_vehicle_rewards then
        DisablePlayerVehicleRewards(cache.playerId)
      end

      HideHudComponentThisFrame(14)

      Wait(0)
    end
  end)
end

function M:EnablePvP()
  if adjustment.enable_pvp then
    SetCanAttackFriendly(cache.ped, true, false)
    NetworkSetFriendlyFireOption(true)
  end
end

function M:DispatchServices()
  if adjustment.disable_dispatch_services then
    for i = 1, 15 do
      EnableDispatchService(i, false)
    end
    SetAudioFlag('PoliceScannerDisabled', true)
  end
end

function M:NPCScenarios()
  if adjustment.disable_scenarios then
    local scenarios = {
      'WORLD_VEHICLE_ATTRACTOR',
      'WORLD_VEHICLE_AMBULANCE',
      'WORLD_VEHICLE_BICYCLE_BMX',
      'WORLD_VEHICLE_BICYCLE_BMX_BALLAS',
      'WORLD_VEHICLE_BICYCLE_BMX_FAMILY',
      'WORLD_VEHICLE_BICYCLE_BMX_HARMONY',
      'WORLD_VEHICLE_BICYCLE_BMX_VAGOS',
      'WORLD_VEHICLE_BICYCLE_MOUNTAIN',
      'WORLD_VEHICLE_BICYCLE_ROAD',
      'WORLD_VEHICLE_BIKE_OFF_ROAD_RACE',
      'WORLD_VEHICLE_BIKER',
      'WORLD_VEHICLE_BOAT_IDLE',
      'WORLD_VEHICLE_BOAT_IDLE_ALAMO',
      'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
      'WORLD_VEHICLE_BROKEN_DOWN',
      'WORLD_VEHICLE_BUSINESSMEN',
      'WORLD_VEHICLE_HELI_LIFEGUARD',
      'WORLD_VEHICLE_CLUCKIN_BELL_TRAILER',
      'WORLD_VEHICLE_CONSTRUCTION_SOLO',
      'WORLD_VEHICLE_CONSTRUCTION_PASSENGERS',
      'WORLD_VEHICLE_DRIVE_PASSENGERS',
      'WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED',
      'WORLD_VEHICLE_DRIVE_SOLO',
      'WORLD_VEHICLE_FIRE_TRUCK',
      'WORLD_VEHICLE_EMPTY',
      'WORLD_VEHICLE_MARIACHI',
      'WORLD_VEHICLE_MECHANIC',
      'WORLD_VEHICLE_MILITARY_PLANES_BIG',
      'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
      'WORLD_VEHICLE_PARK_PARALLEL',
      'WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN',
      'WORLD_VEHICLE_PASSENGER_EXIT',
      'WORLD_VEHICLE_POLICE_BIKE',
      'WORLD_VEHICLE_POLICE_CAR',
      'WORLD_VEHICLE_POLICE',
      'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
      'WORLD_VEHICLE_QUARRY',
      'WORLD_VEHICLE_SALTON',
      'WORLD_VEHICLE_SALTON_DIRT_BIKE',
      'WORLD_VEHICLE_SECURITY_CAR',
      'WORLD_VEHICLE_STREETRACE',
      'WORLD_VEHICLE_TOURBUS',
      'WORLD_VEHICLE_TOURIST',
      'WORLD_VEHICLE_TANDL',
      'WORLD_VEHICLE_TRACTOR',
      'WORLD_VEHICLE_TRACTOR_BEACH',
      'WORLD_VEHICLE_TRUCK_LOGS',
      'WORLD_VEHICLE_TRUCKS_TRAILERS',
      'WORLD_VEHICLE_DISTANT_EMPTY_GROUND',
      'WORLD_HUMAN_PAPARAZZI',
    }

    for i = 1, #scenarios do
      SetScenarioTypeEnabled(scenarios[i], false)
    end
  end
end

function M:LicensePlates()
  SetDefaultVehicleNumberPlateTextPattern(-1, adjustment.custom_ai_plate)
end

local placeHolders = {
  server_name = function()
    return GetConvar('sv_projectName', 'ESX-Framework')
  end,
  server_endpoint = function()
    return GetCurrentServerEndpoint() or 'localhost:30120'
  end,
  server_players = function()
    return GlobalState.playerCount or 0
  end,
  server_maxplayers = function()
    return GetConvarInt('sv_maxClients', 48)
  end,
  player_name = function()
    return GetPlayerName(cache.playerId)
  end,
  player_rp_name = function()
    return ESX.PlayerData.name or 'John Doe'
  end,
  player_id = function()
    return cache.serverId
  end,
  player_street = function()
    if not cache.ped then
      return 'Unknown'
    end

    local playerCoords = GetEntityCoords(cache.ped)
    local streetHash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)

    return GetStreetNameFromHashKey(streetHash) or 'Unknown'
  end,
}

function M:ReplacePlaceholders(text)
  for placeholder, cb in pairs(placeHolders) do
    local success, result = pcall(cb)

    if not success then
      error(('Failed to execute placeholder: ^5%s^7\n%s'):format(placeholder, result))
      result = 'Unknown'
    end

    text = text:gsub(('{%s}'):format(placeholder), tostring(result))
  end
  return text
end

function M:WantedLevel()
  if not adjustment.enable_wanted_level then
    ClearPlayerWantedLevel(cache.playerId)
    SetMaxWantedLevel(0)
  end
end

function M:DisableRadio()
  if adjustment.remove_hud_components[16] then
    AddEventHandler('esx:enteredVehicle', function(vehicle)
      SetVehRadioStation(vehicle, 'OFF')
      SetUserRadioControlEnabled(false)
    end)
  end
end

function M:Multipliers()
  CreateThread(function()
    while true do
      SetPedDensityMultiplierThisFrame(adjustment.multipliers.ped_density)
      SetScenarioPedDensityMultiplierThisFrame(
        adjustment.multipliers.scenario_ped_density_interior,
        adjustment.multipliers.scenario_ped_density_exterior
      )
      SetAmbientVehicleRangeMultiplierThisFrame(adjustment.multipliers.ambient_vehicle_range)
      SetParkedVehicleDensityMultiplierThisFrame(adjustment.multipliers.parked_vehicle_density)
      SetRandomVehicleDensityMultiplierThisFrame(adjustment.multipliers.random_vehicle_density)
      SetVehicleDensityMultiplierThisFrame(adjustment.multipliers.vehicle_density)
      Wait(0)
    end
  end)
end

function M:BasicActions()
  local actions = adjustment.basic_actions
  if actions.disable_motor_helmet then
    require('client.modules.adjustments.basic-actions.disable_motor_helmet')
  end

  if actions.disable_idle_camera then
    require('client.modules.adjustments.basic-actions.disable_idle_camera')
  end

  if actions.player_crouch then
    require('client.modules.adjustments.basic-actions.player_crouch')
  end

  if actions.player_handsup then
    require('client.modules.adjustments.basic-actions.player_handsup')
  end

  if actions.player_finger_pointing then
    require('client.modules.adjustments.basic-actions.player_finger_pointing')
  end

  if actions.player_injured and actions.player_injured.enabled then
    require('client.modules.adjustments.basic-actions.player_injured')(actions.player_injured.below)
  end

  if actions.player_slide and actions.player_slide.enabled then
    require('client.modules.adjustments.basic-actions.player_slide')(actions.player_slide.delay)
  end
end

function M:Load()
  self:RemoveHudComponents()
  self:DisableAimAssist()
  self:DisableNPCDrops()
  self:SeatShuffle()
  self:HealthRegeneration()
  self:AmmoAndVehicleRewards()
  self:EnablePvP()
  self:DispatchServices()
  self:NPCScenarios()
  self:LicensePlates()
  self:WantedLevel()
  self:DisableRadio()
  self:Multipliers()
  self:BasicActions()
end

return M
