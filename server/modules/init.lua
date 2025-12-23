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

SetMapName('San Andreas')
SetGameType('Sure | Dogeaterx')

local public = require('settings.public')
local playerJoin = require('server.modules.player.join')
local playerDrop = require('server.modules.player.drop')
local registerCallback = lib.callback.register

local oneSyncState = GetConvar('onesync', 'off')

AddEventHandler('esx:onPlayerDropped', playerDrop)
RegisterNetEvent('esx:onPlayerJoined', function()
  local source = source
  while not next(ESX.Jobs) do
    Wait(50)
  end

  if not ESX.Players[source] then
    playerJoin(source)
  end
end)

AddEventHandler('playerConnecting', function(_, _, deferrals)
  local playerId = source
  deferrals.defer()
  Wait(0)
  local identifier
  local correctLicense, _ = pcall(function()
    identifier = ESX.GetIdentifier(playerId)
  end)

  if not SetEntityOrphanMode then
    return deferrals.done(TranslateCap('require_minimum_artifact'))
  end

  if oneSyncState == 'off' or oneSyncState == 'legacy' then
    return deferrals.done(TranslateCap('require_onesync', oneSyncState))
  end

  if not Core.DatabaseConnected then
    return deferrals.done(TranslateCap('require_database'))
  end

  if not identifier or not correctLicense then
    return deferrals.done(TranslateCap('require_identity'))
  end

  local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

  if not xPlayer then
    return deferrals.done()
  end

  if
    GetPlayerPing(xPlayer.source --[[@as string]]) > 0
  then
    return deferrals.done(TranslateCap('duplicate_player', identifier))
  end

  deferrals.update(('[ESX] Cleaning stale player entry...'):format(identifier))
  playerDrop(xPlayer.source, 'esx_stale_player_obj')
  deferrals.done()
end)

AddEventHandler('chatMessage', function(playerId, _, message)
  local xPlayer = ESX.GetPlayerFromId(playerId)
  if xPlayer and message:sub(1, 1) == '/' and playerId > 0 then
    CancelEvent()
  end
end)

---@param reason string
AddEventHandler('playerDropped', function(reason)
  playerDrop(source, reason)
end)

AddEventHandler('esx:playerLoaded', function(playerId)
  local xPlayer = ESX.GetPlayerFromId(playerId)

  if xPlayer then
    local job = xPlayer:getJob().name
    local jobKey = ('%s:count'):format(job)

    Core.JobsPlayerCount[job] = (Core.JobsPlayerCount[job] or 0) + 1
    GlobalState[jobKey] = Core.JobsPlayerCount[job]

    Core.IdsByJobs[job][playerId] = true
  end
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
  local lastJobKey = ('%s:count'):format(lastJob.name)
  local jobKey = ('%s:count'):format(job.name)
  local currentLastJob = Core.JobsPlayerCount[lastJob.name]

  Core.JobsPlayerCount[lastJob.name] = ((currentLastJob and currentLastJob > 0) and currentLastJob or 1) - 1
  Core.JobsPlayerCount[job.name] = (Core.JobsPlayerCount[job.name] or 0) + 1

  GlobalState[lastJobKey] = Core.JobsPlayerCount[lastJob.name]
  GlobalState[jobKey] = Core.JobsPlayerCount[job.name]

  Core.IdsByJobs[job.name][playerId] = true
  Core.IdsByJobs[lastJob.name][playerId] = nil
end)

RegisterNetEvent('esx:updateWeaponAmmo', function(weaponName, ammoCount)
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer then
    xPlayer:updateWeaponAmmo(weaponName, ammoCount)
  end
end)

RegisterNetEvent('esx:giveInventoryItem', function(target, itemType, itemName, itemCount)
  local playerId = source
  local sourceXPlayer = ESX.GetPlayerFromId(playerId)
  local targetXPlayer = ESX.GetPlayerFromId(target)
  local distance = #(GetEntityCoords(GetPlayerPed(playerId)) - GetEntityCoords(GetPlayerPed(target)))
  if not sourceXPlayer or not targetXPlayer or distance > public.distance_give then
    lib.print.warn(('[^3WARNING^7] Player Detected Cheating: ^5%s^7'):format(GetPlayerName(playerId)))
    return
  end

  if itemType == 'item_standard' then
    local sourceItem = sourceXPlayer:getInventoryItem(itemName)

    if not sourceItem then
      return
    end

    if itemCount < 1 or sourceItem.count < itemCount then
      return
    end

    if not targetXPlayer:canCarryItem(itemName, itemCount) then
      return
    end

    sourceXPlayer:removeInventoryItem(itemName, itemCount)
    targetXPlayer:addInventoryItem(itemName, itemCount)
  elseif itemType == 'item_account' then
    if itemCount < 1 or sourceXPlayer:getAccount(itemName).money < itemCount then
      return
    end

    sourceXPlayer:removeAccountMoney(itemName, itemCount)
    targetXPlayer:addAccountMoney(itemName, itemCount)
  elseif itemType == 'item_weapon' then
    if not sourceXPlayer:hasWeapon(itemName) then
      return
    end

    if targetXPlayer:hasWeapon(itemName) then
      return
    end

    local _, weapon = sourceXPlayer:getWeapon(itemName)
    if not weapon then
      return
    end

    itemCount = weapon.ammo
    local weaponComponents = ESX.Table.Clone(weapon.components)
    local weaponTint = weapon.tintIndex

    if weaponTint then
      targetXPlayer:setWeaponTint(itemName, weaponTint)
    end

    if weaponComponents then
      for _, v in pairs(weaponComponents) do
        targetXPlayer:addWeaponComponent(itemName, v)
      end
    end

    sourceXPlayer:removeWeapon(itemName)
    targetXPlayer:addWeapon(itemName, itemCount)
  elseif itemType == 'item_ammo' then
    if not sourceXPlayer:hasWeapon(itemName) then
      return
    end

    local _, weapon = sourceXPlayer:getWeapon(itemName)
    if not weapon then
      return
    end

    if not targetXPlayer:hasWeapon(itemName) then
      return
    end

    local _, weaponObject = ESX.GetWeapon(itemName)

    if not weaponObject.ammo then
      return
    end

    if weapon.ammo >= itemCount then
      sourceXPlayer:removeWeaponAmmo(itemName, itemCount)
      targetXPlayer:addWeaponAmmo(itemName, itemCount)
    end
  end
end)

RegisterNetEvent('esx:removeInventoryItem', function(itemType, itemName, itemCount)
  local playerId = source
  local xPlayer = ESX.GetPlayerFromId(playerId)

  if not xPlayer then
    return
  end

  if itemType == 'item_standard' then
    if not itemCount or itemCount < 1 then
      return
    end

    local xItem = xPlayer:getInventoryItem(itemName)
    if not xItem then
      return
    end

    if itemCount > xItem.count or xItem.count < 1 then
      return
    end

    xPlayer:removeInventoryItem(itemName, itemCount)
  elseif itemType == 'item_account' then
    if itemCount == nil or itemCount < 1 then
      return
    end

    local account = xPlayer:getAccount(itemName)
    if not account then
      return
    end

    if itemCount > account.money or account.money < 1 then
      return
    end

    xPlayer:removeAccountMoney(itemName, itemCount)
  elseif itemType == 'item_weapon' then
    itemName = string.upper(itemName)

    if not xPlayer:hasWeapon(itemName) then
      return
    end

    local _, weapon = xPlayer:getWeapon(itemName)
    if not weapon then
      return
    end

    xPlayer:removeWeapon(itemName)
  end
end)

RegisterNetEvent('esx:useItem', function(itemName)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)

  if not xPlayer then
    return
  end

  local item = xPlayer:getInventoryItem(itemName)
  if not item then
    return
  end

  if item.count < 1 then
    return
  end

  if (item.limit ~= -1 and item.count > item.limit) and not xPlayer:isAdmin() then
    TriggerClientEvent(
      'hud:notification',
      source,
      ('ไอเทม %s มีเกินจำนวนที่สามารถเก็บได้'):format(item.label)
    )
    return
  end

  ESX.UseItem(source, itemName)
end)

registerCallback('esx:getPlayerData', function(source, target)
  if target ~= nil then
    source = target
  end

  local xPlayer = ESX.GetPlayerFromId(source)

  if not xPlayer then
    return
  end

  return {
    identifier = xPlayer.identifier,
    accounts = xPlayer:getAccounts(),
    inventory = xPlayer:getInventory(),
    job = xPlayer:getJob(),
    loadout = xPlayer:getLoadout(),
    money = xPlayer:getMoney(),
    position = xPlayer:getCoords(true),
    metadata = xPlayer:getMeta(),
  }
end)

registerCallback('esx:isUserAdmin', function(source)
  return Core.IsPlayerAdmin(source)
end)

registerCallback('esx:getGameBuild', function(_)
  return tonumber(GetConvar('sv_enforceGameBuild', '1604'))
end)

registerCallback('esx:getPlayerNames', function(source, players)
  players[source] = nil

  for playerId, _ in pairs(players) do
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer then
      players[playerId] = xPlayer:getName()
    else
      players[playerId] = nil
    end
  end

  return players
end)

registerCallback('esx:spawnVehicle', function(source, vehData)
  local ped = GetPlayerPed(source)
  local idPromise = promise.new()
  ESX.OneSync.SpawnVehicle(
    vehData.model or `ADDER`,
    vehData.coords or GetEntityCoords(ped),
    vehData.coords.w or 0.0,
    vehData.props or {},
    function(id)
      if vehData.warp then
        local vehicle = NetworkGetEntityFromNetworkId(id)
        local timeout = 0
        while GetVehiclePedIsIn(ped, false) ~= vehicle and timeout <= 15 do
          Wait(0)
          TaskWarpPedIntoVehicle(ped, vehicle, -1)
          timeout += 1
        end
      end

      idPromise:resolve(idPromise)
    end
  )

  return Citizen.Await(idPromise)
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
  if eventData.secondsRemaining == 60 then
    CreateThread(function()
      Wait(50000)
      Core.SavePlayers()
    end)
  end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function()
  Core.SavePlayers()
end)

local DoNotUse = {
  ['essentialmode'] = true,
  ['es_admin2'] = true,
  ['basic-gamemode'] = true,
  ['mapmanager'] = true,
  ['fivem-map-skater'] = true,
  ['fivem-map-hipster'] = true,
  ['qb-core'] = true,
  ['default_spawnpoint'] = true,
}

AddEventHandler('onResourceStart', function(key)
  if DoNotUse[string.lower(key)] then
    while GetResourceState(key) ~= 'started' do
      Wait(0)
    end

    StopResource(key)
    error(('WE STOPPED A RESOURCE THAT WILL BREAK ^1ESX^1, PLEASE REMOVE ^5%s^1'):format(key))
  end

  if not SetEntityOrphanMode then
    CreateThread(function()
      while true do
        error('ESX Requires a minimum Artifact version of 10188, Please update your server.')
        Wait(60 * 1000)
      end
    end)
  end
end)

for key in pairs(DoNotUse) do
  if GetResourceState(key) == 'started' or GetResourceState(key) == 'starting' then
    StopResource(key)
    error(('WE STOPPED A RESOURCE THAT WILL BREAK ^1ESX^1, PLEASE REMOVE ^5%s^1'):format(key))
  end
end
