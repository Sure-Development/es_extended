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

local public = require('settings.public')

local M = {
  adjustment = require('client.modules.adjustments'),
  death = require('client.modules.death'),
}

local registerCallback = lib.callback.register

RegisterNetEvent('esx:requestModel', function(model)
  ESX.Streaming.RequestModel(model)
end)

local watchers = { 'identifier', 'dateofbirth', 'name', 'firstName', 'lastName', 'height', 'job', 'variables', 'metadata', 'group' }
for _, watcher in ipairs(watchers) do
  AddStateBagChangeHandler(watcher, 'player:' .. cache.serverId, function(_, _, value)
    ESX.PlayerData[watcher] = value
    ESX.SetPlayerData(watcher, value)
  end)
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer, isNew)
  local tries = 0
  repeat
    Core.Items = lib.loadJson('db.items')
    if ESX.Table.SizeOf(Core.Items) > 0 or tries == 50 then
      Core.ItemsLoaded = true
    end

    Wait(100)

    tries += 1
  until Core.ItemsLoaded and LocalPlayer.state.metadata ~= nil

  ESX.PlayerData = lib.table.merge(ESX.PlayerData, xPlayer)

  local inventoryServerCount = {}
  for _, item in ipairs(xPlayer.inventoryClient) do
    inventoryServerCount[item.name] = {
      count = item.count,
      usable = item.usable,
    }
  end

  local itemIndex = 0
  ---@type table<string, DEX.Item>
  local newInventory = {}
  for name, item in pairs(Core.Items) do
    itemIndex += 1
    newInventory[name] = item
    newInventory[name].count = (inventoryServerCount[name] or { count = 0 }).count or 0
    newInventory[name].usable = (inventoryServerCount[name] or { usable = false }).usable or false

    if public.hybrid_data then
      newInventory[itemIndex] = newInventory[name]
    end
  end

  local accountIndex = 0
  ---@type table<string, DEX.Account>
  local newAccounts = {}
  for _, account in ipairs(xPlayer.accounts) do
    accountIndex += 1
    newAccounts[account.name] = account

    if public.hybrid_data then
      newAccounts[accountIndex] = account
    end
  end

  local loadoutIndex = 0
  ---@type table<string, DEX.Loadout>
  local newLoadout = {}
  for _, weapon in ipairs(xPlayer.loadout) do
    loadoutIndex += 1
    newLoadout[weapon.name] = weapon

    if public.hybrid_data then
      newLoadout[loadoutIndex] = weapon
    end
  end

  ESX.PlayerData.inventory = lib.table.deepclone(newInventory)
  ESX.PlayerData.accounts = lib.table.deepclone(newAccounts)
  ESX.PlayerData.loadout = lib.table.deepclone(newLoadout)

  ESX.SpawnPlayer(ESX.PlayerData.skin, ESX.PlayerData.coords, function()
    TriggerEvent('esx:onPlayerSpawn')
    TriggerEvent('esx:restoreLoadout')
    TriggerServerEvent('esx:onPlayerSpawn')
    TriggerEvent('esx:loadingScreenOff')
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
  end)

  while not DoesEntityExist(cache.ped) do
    Wait(20)
  end

  ESX.PlayerLoaded = true

  local timer = GetGameTimer()
  while not HaveAllStreamingRequestsCompleted(cache.ped) and (GetGameTimer() - timer) < 2000 do
    Wait(0)
  end

  M.adjustment:Load()
  M.death:Load()

  ClearPedTasksImmediately(cache.ped)
  Core.FreezePlayer(false)

  if IsScreenFadedOut() then
    DoScreenFadeIn(500)
  end

  NetworkSetLocalPlayerSyncLookAt(true)

  if ESX.PlayerData.metadata then
    if ESX.PlayerData.metadata.isDead then
      SetEntityHealth(cache.ped, 0)
      LocalPlayer.state:set('isDead', true, true)
    else
      SetEntityHealth(cache.ped, ESX.PlayerData.metadata.health)
      SetPedArmour(cache.ped, ESX.PlayerData.metadata.armor)
    end
  end

  lib.print.info('Player has initialized')
end)

RegisterNetEvent('esx:setInventory', function(newInventory)
  ESX.SetPlayerData('inventory', newInventory)
end)

local function onPlayerSpawn()
  ESX.SetPlayerData('dead', false)
end

AddEventHandler('playerSpawned', onPlayerSpawn)
AddEventHandler('esx:onPlayerSpawn', onPlayerSpawn)

AddEventHandler('esx:onPlayerDeath', function()
  ESX.SetPlayerData('dead', true)
end)

AddEventHandler('skinchanger:modelLoaded', function()
  while not ESX.PlayerLoaded do
    Wait(100)
  end
  TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout', function()
  local ammoTypes = {}
  RemoveAllPedWeapons(cache.ped, true)

  for _, v in ipairs(ESX.PlayerData.loadout) do
    local weaponName = v.name
    local weaponHash = joaat(weaponName)

    GiveWeaponToPed(cache.ped, weaponHash, 0, false, false)
    SetPedWeaponTintIndex(cache.ped, weaponHash, v.tintIndex)

    local ammoType = GetPedAmmoTypeFromWeapon(cache.ped, weaponHash)

    for _, v2 in ipairs(v.components) do
      local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash
      GiveWeaponComponentToPed(cache.ped, weaponHash, componentHash)
    end

    if not ammoTypes[ammoType] then
      AddAmmoToPed(cache.ped, weaponHash, v.ammo)
      ammoTypes[ammoType] = true
    end
  end
end)

---@diagnostic disable-next-line: param-type-mismatch
AddStateBagChangeHandler('VehicleProperties', nil, function(bagName, _, value)
  if not value then
    return
  end

  bagName = bagName:gsub('entity:', '')
  local netId = tonumber(bagName)
  if not netId then
    error('Tried to set vehicle properties with invalid netId')
    return
  end

  local tries = 0

  while not NetworkDoesEntityExistWithNetworkId(netId) do
    Wait(200)
    tries = tries + 1
    if tries > 20 then
      return error(('Invalid entity - ^5%s^7!'):format(netId))
    end
  end

  local vehicle = NetToVeh(netId)

  if NetworkGetEntityOwner(vehicle) ~= cache.playerId then
    return
  end

  ESX.Game.SetVehicleProperties(vehicle, value)
end)

RegisterNetEvent('esx:setAccountMoney', function(account)
  local retval = pcall(function()
    ESX.PlayerData.accounts[account.name] = account
  end)

  if public.hybrid_data then
    for k, v in ipairs(ESX.PlayerData.accounts) do
      if v.name == account.name then
        ESX.PlayerData.accounts[k] = account
        break
      end
    end
  end

  if not retval then
    lib.print.error(('Error during esx:addInventoryItem %s'):format(json.encode(account)))
    return
  end

  ESX.SetPlayerData('accounts', ESX.PlayerData.accounts)
end)

RegisterNetEvent('esx:setJob', function(job)
  ESX.SetPlayerData('job', job)
end)

RegisterNetEvent('esx:setGroup', function(group)
  ESX.SetPlayerData('group', group)
end)

RegisterNetEvent('esx:registerSuggestions', function(registeredCommands)
  for name, command in pairs(registeredCommands) do
    if command.suggestion then
      TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.suggestion.help, command.suggestion.arguments)
    end
  end
end)

RegisterNetEvent('esx:addInventoryItem', function(item, count)
  local retval = pcall(function()
    ESX.PlayerData.inventory[item].count = count
  end)

  if public.hybrid_data then
    for k, v in ipairs(ESX.PlayerData.inventory) do
      if v.name == item then
        ESX.PlayerData.inventory[k].count = count
        break
      end
    end
  end

  if not retval then
    lib.print.error(('Error during esx:addInventoryItem %s %s'):format(item, count))
  end
end)

RegisterNetEvent('esx:removeInventoryItem', function(item, count)
  local retval = pcall(function()
    ESX.PlayerData.inventory[item].count = count
  end)

  if public.hybrid_data then
    for k, v in ipairs(ESX.PlayerData.inventory) do
      if v.name == item then
        ESX.PlayerData.inventory[k].count = count
        break
      end
    end
  end

  if not retval then
    lib.print.error(('Error during esx:removeInventoryItem %s %s'):format(item, count))
  end
end)

RegisterNetEvent('esx:addLoadoutItem', function(weaponName, weaponLabel, ammo)
  local data = {
    name = weaponName,
    ammo = ammo,
    label = weaponLabel,
    components = {},
    tintIndex = 0,
  }
  local retval = pcall(function()
    ESX.PlayerData.loadout[weaponName] = data
  end)

  if public.hybrid_data then
    for _, v in ipairs(ESX.PlayerData.loadout) do
      if v.name == weaponName then
        ESX.PlayerData.loadout[#ESX.PlayerData.loadout + 1] = data
        break
      end
    end
  end

  if not retval then
    lib.print.error(('Error during esx:addLoadoutItem %s %s %s'):format(weaponName, weaponLabel, ammo))
    return
  end

  ESX.SetPlayerData('loadout', ESX.PlayerData.loadout)
end)

RegisterNetEvent('esx:removeLoadoutItem', function(weaponName, weaponLabel)
  local retval = pcall(function()
    ESX.PlayerData.loadout[weaponName] = nil
  end)

  if public.hybrid_data then
    for k, v in ipairs(ESX.PlayerData.loadout) do
      if v.name == weaponName then
        table.remove(ESX.PlayerData.loadout, k)
        break
      end
    end
  end

  if not retval then
    lib.print.error(('Error during esx:addLoadoutItem %s %s'):format(weaponName, weaponLabel))
    return
  end

  ESX.SetPlayerData('loadout', ESX.PlayerData.loadout)
end)

registerCallback('esx:getVehicleType', function(model)
  return ESX.GetVehicleTypeClient(model)
end)

RegisterNetEvent('esx:updatePlayerData', function(key, val)
  ESX.SetPlayerData(key, val)
end)

---@param command string
RegisterNetEvent('esx:executeCommand', function(command)
  ExecuteCommand(command)
end)

AddEventHandler('onResourceStop', function(resource)
  if Core.Events[resource] then
    for i = 1, #Core.Events[resource] do
      RemoveEventHandler(Core.Events[resource][i])
    end
  end
end)
