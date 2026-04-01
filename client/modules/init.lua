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

@onNet('esx:requestModel', function(model)
  ESX.Streaming.RequestModel(model)
end)

local watchers = { 'identifier', 'dateofbirth', 'name', 'firstName', 'lastName', 'height', 'job', 'variables', 'metadata', 'group' }
for _, watcher in ipairs(watchers) do
  AddStateBagChangeHandler(watcher, 'player:' .. cache.serverId, function(_, _, value)
    ESX.PlayerData[watcher] = value
    ESX.SetPlayerData(watcher, value)
  end)
end

local hybridType = public.hybrid_data

local function debugClientLog(action, name, extra)
  if not public.debug_inventory_loadout then
    return
  end

  lib.print.info(('[debug:client] action=%s name=%s %s'):format(action, tostring(name), extra or ''))
end

local function findEntry(collection, name)
  if (hybridType == true or hybridType == 'hash') and collection[name] then
    return collection[name]
  end

  if hybridType == true or hybridType == 'numeric' then
    for index, entry in ipairs(collection) do
      if entry.name == name then
        return entry, index
      end
    end
  end
end

local function setHybridEntry(collection, name, value)
  if hybridType == true or hybridType == 'hash' then
    collection[name] = value
  end

  if hybridType == true or hybridType == 'numeric' then
    local _, entryIndex = findEntry(collection, name)

    if value == nil then
      if entryIndex then
        table.remove(collection, entryIndex)
      end
    elseif entryIndex then
      collection[entryIndex] = value
    else
      collection[#collection + 1] = value
    end
  end
end

@onNet('esx:playerLoaded', function(xPlayer, isNew)
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
    local itemData = lib.table.deepclone(item)
    itemData.count = (inventoryServerCount[name] or { count = 0 }).count or 0
    itemData.usable = (inventoryServerCount[name] or { usable = false }).usable or false

    if hybridType == true then
      newInventory[name] = itemData
      newInventory[itemIndex] = itemData
    elseif hybridType == 'hash' then
      newInventory[name] = itemData
    elseif hybridType == 'numeric' then
      newInventory[itemIndex] = itemData
    end
  end

  local accountIndex = 0
  ---@type table<string, DEX.Account>
  local newAccounts = {}
  for _, account in ipairs(xPlayer.accounts) do
    accountIndex += 1

    if hybridType == true then
      newAccounts[account.name] = account
      newAccounts[accountIndex] = account
    elseif hybridType == 'hash' then
      newAccounts[account.name] = account
    elseif hybridType == 'numeric' then
      newAccounts[accountIndex] = account
    end
  end

  local loadoutIndex = 0
  ---@type table<string, DEX.Loadout>
  local newLoadout = {}
  for _, weapon in ipairs(xPlayer.loadout) do
    loadoutIndex += 1

    if hybridType == true then
      newLoadout[weapon.name] = weapon
      newLoadout[loadoutIndex] = weapon
    elseif hybridType == 'hash' then
      newLoadout[weapon.name] = weapon
    elseif hybridType == 'numeric' then
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
    if ESX.PlayerData.metadata.isDead == 1 or ESX.PlayerData.metadata.isDead == true then
      SetEntityHealth(cache.ped, 0)
      LocalPlayer.state:set('isDead', true, true)
    else
      SetEntityHealth(cache.ped, ESX.PlayerData.metadata.health)
      SetPedArmour(cache.ped, ESX.PlayerData.metadata.armor)
    end
  end

  lib.print.info('Player has initialized')
end)

@onNet('esx:setInventory', function(_newInventory)
  local newInventory = {}

  for index, item in ipairs(_newInventory) do
    if hybridType == true then
      newInventory[index] = item
      newInventory[item.name] = item
    elseif hybridType == 'hash' then
      newInventory[item.name] = item
    elseif hybridType == 'numeric' then
      newInventory[index] = item
    end
  end

  ESX.SetPlayerData('inventory', newInventory)
end)

local function onPlayerSpawn()
  ESX.SetPlayerData('dead', false)
end

@on('playerSpawned', onPlayerSpawn)
@on('esx:onPlayerSpawn', onPlayerSpawn)

@on('esx:onPlayerDeath', function()
  ESX.SetPlayerData('dead', true)
end)

@on('skinchanger:modelLoaded', function()
  while not ESX.PlayerLoaded do
    Wait(100)
  end
  TriggerEvent('esx:restoreLoadout')
end)

@on('esx:restoreLoadout', function()
  local ammoTypes = {}
  local restoredWeapons = {}
  RemoveAllPedWeapons(cache.ped, true)

  for _, v in pairs(ESX.PlayerData.loadout) do
    if restoredWeapons[v.name] then
      goto continue
    end

    restoredWeapons[v.name] = true
    local weaponName = v.name
    local weaponHash = joaat(weaponName)

    GiveWeaponToPed(cache.ped, weaponHash, 0, false, false)
    SetPedWeaponTintIndex(cache.ped, weaponHash, v.tintIndex)

    local ammoType = GetPedAmmoTypeFromWeapon(cache.ped, weaponHash)

    for _, v2 in ipairs(v.components or {}) do
      local componentData = ESX.GetWeaponComponent(weaponName, v2)
      if componentData then
        GiveWeaponComponentToPed(cache.ped, weaponHash, componentData.hash)
      end
    end

    if not ammoTypes[ammoType] then
      AddAmmoToPed(cache.ped, weaponHash, v.ammo)
      ammoTypes[ammoType] = true
    end

    ::continue::
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

@onNet('esx:setAccountMoney', function(account)
  local retval = true
  if hybridType == true or hybridType == 'hash' then
    retval = pcall(function()
      ESX.PlayerData.accounts[account.name] = account
    end)
  end

  if hybridType == true or hybridType == 'numeric' then
    for k, v in ipairs(ESX.PlayerData.accounts) do
      if v.name == account.name then
        ESX.PlayerData.accounts[k] = account
        break
      end
    end
  end

  if not retval then
    lib.print.error(('Error during esx:setAccountMoney %s'):format(json.encode(account)))
    return
  end

  ESX.SetPlayerData('accounts', ESX.PlayerData.accounts)
end)

@onNet('esx:setJob', function(job)
  ESX.SetPlayerData('job', job)
end)

@onNet('esx:setGroup', function(group)
  ESX.SetPlayerData('group', group)
end)

@onNet('esx:registerSuggestions', function(registeredCommands)
  for name, command in pairs(registeredCommands) do
    if command.suggestion then
      TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.suggestion.help, command.suggestion.arguments)
    end
  end
end)

@onNet('esx:addInventoryItem', function(item, count)
  local itemData = findEntry(ESX.PlayerData.inventory, item)

  if not itemData then
    lib.print.error(('Error during esx:addInventoryItem %s %s'):format(item, count))
    return
  end

  itemData.count = count
  debugClientLog('addInventoryItem', item, ('count=%s'):format(count))
  ESX.SetPlayerData('inventory', ESX.PlayerData.inventory)
end)

@onNet('esx:removeInventoryItem', function(item, count)
  local itemData = findEntry(ESX.PlayerData.inventory, item)

  if not itemData then
    lib.print.error(('Error during esx:removeInventoryItem %s %s'):format(item, count))
    return
  end

  itemData.count = count
  debugClientLog('removeInventoryItem', item, ('count=%s'):format(count))
  ESX.SetPlayerData('inventory', ESX.PlayerData.inventory)
end)

@onNet('esx:addLoadoutItem', function(weaponName, weaponLabel, ammo)
  local data = {
    name = weaponName,
    ammo = ammo,
    label = weaponLabel,
    components = {},
    tintIndex = 0,
  }

  local currentWeapon = findEntry(ESX.PlayerData.loadout, weaponName)
  if currentWeapon then
    currentWeapon.ammo = ammo
    currentWeapon.label = weaponLabel
  else
    setHybridEntry(ESX.PlayerData.loadout, weaponName, data)
  end

  debugClientLog('addLoadoutItem', weaponName, ('ammo=%s'):format(ammo))
  ESX.SetPlayerData('loadout', ESX.PlayerData.loadout)
end)

@onNet('esx:removeLoadoutItem', function(weaponName, weaponLabel)
  local currentWeapon = findEntry(ESX.PlayerData.loadout, weaponName)
  if not currentWeapon then
    lib.print.error(('Error during esx:removeLoadoutItem %s %s'):format(weaponName, weaponLabel))
    return
  end

  setHybridEntry(ESX.PlayerData.loadout, weaponName, nil)
  debugClientLog('removeLoadoutItem', weaponName)
  ESX.SetPlayerData('loadout', ESX.PlayerData.loadout)
end)

@onNet('esx:addWeaponComponent', function(weaponName, componentName)
  local currentWeapon = findEntry(ESX.PlayerData.loadout, weaponName)
  if not currentWeapon then
    lib.print.error(('Error during esx:addWeaponComponent %s %s'):format(weaponName, componentName))
    return
  end

  for _, currentComponent in ipairs(currentWeapon.components) do
    if currentComponent == componentName then
      return
    end
  end

  currentWeapon.components[#currentWeapon.components + 1] = componentName

  local componentData = ESX.GetWeaponComponent(weaponName, componentName)
  if componentData then
    GiveWeaponComponentToPed(cache.ped, joaat(weaponName), componentData.hash)
  end

  debugClientLog('addWeaponComponent', weaponName, ('component=%s'):format(componentName))
  ESX.SetPlayerData('loadout', ESX.PlayerData.loadout)
end)

@onNet('esx:removeWeaponComponent', function(weaponName, componentName)
  local currentWeapon = findEntry(ESX.PlayerData.loadout, weaponName)
  if not currentWeapon then
    lib.print.error(('Error during esx:removeWeaponComponent %s %s'):format(weaponName, componentName))
    return
  end

  for index, currentComponent in ipairs(currentWeapon.components) do
    if currentComponent == componentName then
      table.remove(currentWeapon.components, index)
      break
    end
  end

  local componentData = ESX.GetWeaponComponent(weaponName, componentName)
  if componentData then
    RemoveWeaponComponentFromPed(cache.ped, joaat(weaponName), componentData.hash)
  end

  debugClientLog('removeWeaponComponent', weaponName, ('component=%s'):format(componentName))
  ESX.SetPlayerData('loadout', ESX.PlayerData.loadout)
end)

@onNet('esx:setWeaponTint', function(weaponName, tintIndex)
  local currentWeapon = findEntry(ESX.PlayerData.loadout, weaponName)
  if not currentWeapon then
    lib.print.error(('Error during esx:setWeaponTint %s %s'):format(weaponName, tintIndex))
    return
  end

  currentWeapon.tintIndex = tintIndex
  SetPedWeaponTintIndex(cache.ped, joaat(weaponName), tintIndex)
  debugClientLog('setWeaponTint', weaponName, ('tint=%s'):format(tintIndex))
  ESX.SetPlayerData('loadout', ESX.PlayerData.loadout)
end)

registerCallback('esx:getVehicleType', function(model)
  return ESX.GetVehicleTypeClient(model)
end)

@onNet('esx:updatePlayerData', function(key, val)
  ESX.SetPlayerData(key, val)
end)

---@param command string
@onNet('esx:executeCommand', function(command)
  ExecuteCommand(command)
end)

@on('onResourceStop', function(resource)
  if Core.Events[resource] then
    for i = 1, #Core.Events[resource] do
      RemoveEventHandler(Core.Events[resource][i])
    end
  end
end)
