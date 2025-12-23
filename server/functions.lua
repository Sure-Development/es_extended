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

---@class DEX.Player
local player = require('server.classes.player')
local public = require('settings.public')

---@param msg string
---@return nil
function ESX.Trace(msg)
  if DEBUG then
    lib.print.info(('%s^7'):format(msg))
  end
end

---@param name string
---@param cb fun(source: integer, cb: fun(...), ...)
function ESX.RegisterServerCallback(name, cb)
  lib.callback.register(name, function(source, ...)
    local args = { ... }
    local result
    local p = promise.new()

    cb(source, function(...)
      result = { ... }
      p:resolve()
    end, table.unpack(args))

    return table.unpack(result)
  end)
end

---@param name string | table
---@param group string | table
---@param cb function
---@param allowConsole? boolean
---@param suggestion? table
function ESX.RegisterCommand(name, group, cb, allowConsole, suggestion)
  if type(name) == 'table' then
    for _, v in ipairs(name) do
      ESX.RegisterCommand(v, group, cb, allowConsole, suggestion)
    end
    return
  end

  if Core.RegisteredCommands[name] then
    print(('[^3WARNING^7] Command ^5 %s ^7already registered, overriding command'):format(name))

    if Core.RegisteredCommands[name].suggestion then
      TriggerClientEvent('chat:removeSuggestion', -1, ('/%s'):format(name))
    end
  end

  if suggestion then
    if not suggestion.arguments then
      suggestion.arguments = {}
    end
    if not suggestion.help then
      suggestion.help = ''
    end

    TriggerClientEvent('chat:addSuggestion', -1, ('/%s'):format(name), suggestion.help, suggestion.arguments)
  end

  Core.RegisteredCommands[name] = { group = group, cb = cb, allowConsole = allowConsole, suggestion = suggestion }

  RegisterCommand(name, function(playerId, args)
    local command = Core.RegisteredCommands[name]

    if not command.allowConsole and playerId == 0 then
      print(('[^3WARNING^7] ^5%s^0'):format(TranslateCap('commanderror_console')))
    else
      local xPlayer, error = ESX.Players[playerId], nil

      if command.suggestion then
        if command.suggestion.validate then
          if #args ~= #command.suggestion.arguments then
            error = TranslateCap('commanderror_argumentmismatch', #args, #command.suggestion.arguments)
          end
        end

        if not error and command.suggestion.arguments then
          local newArgs = {}

          for k, v in ipairs(command.suggestion.arguments) do
            if v.type then
              if v.type == 'number' then
                local newArg = tonumber(args[k])

                if newArg then
                  newArgs[v.name] = newArg
                else
                  error = TranslateCap('commanderror_argumentmismatch_number', k)
                end
              elseif v.type == 'player' or v.type == 'playerId' then
                local targetPlayer = tonumber(args[k])

                if args[k] == 'me' then
                  targetPlayer = playerId
                end

                if targetPlayer then
                  local xTargetPlayer = ESX.GetPlayerFromId(targetPlayer)

                  if xTargetPlayer then
                    if v.type == 'player' then
                      newArgs[v.name] = xTargetPlayer
                    else
                      newArgs[v.name] = targetPlayer
                    end
                  else
                    error = TranslateCap('commanderror_invalidplayerid')
                  end
                else
                  error = TranslateCap('commanderror_argumentmismatch_number', k)
                end
              elseif v.type == 'string' then
                local newArg = tonumber(args[k])
                if not newArg then
                  newArgs[v.name] = args[k]
                else
                  error = TranslateCap('commanderror_argumentmismatch_string', k)
                end
              elseif v.type == 'item' then
                if ESX.Items[args[k]] then
                  newArgs[v.name] = args[k]
                else
                  error = TranslateCap('commanderror_invaliditem')
                end
              elseif v.type == 'weapon' then
                if ESX.GetWeapon(args[k]) then
                  newArgs[v.name] = string.upper(args[k])
                else
                  error = TranslateCap('commanderror_invalidweapon')
                end
              elseif v.type == 'any' then
                newArgs[v.name] = args[k]
              elseif v.type == 'merge' then
                local length = 0
                for i = 1, k - 1 do
                  length = length + string.len(args[i]) + 1
                end
                local merge = table.concat(args, ' ')

                newArgs[v.name] = string.sub(merge, length)
              elseif v.type == 'coordinate' then
                local coord = tonumber(args[k]:match('(-?%d+%.?%d*)'))
                if not coord then
                  error = TranslateCap('commanderror_argumentmismatch_number', k)
                else
                  newArgs[v.name] = coord
                end
              end
            end

            --backwards compatibility
            if v.validate ~= nil and not v.validate then
              error = nil
            end

            if error then
              break
            end
          end

          args = newArgs
        end
      end

      if error then
        if playerId == 0 then
          lib.print.warn(('[^3WARNING^7] %s^7'):format(error))
        end
      else
        cb(xPlayer or false, args, function(msg)
          if playerId == 0 then
            lib.print.warn(('[^3WARNING^7] %s^7'):format(msg))
          end
        end)
      end
    end
  end, true)

  if type(group) == 'table' then
    for _, v in ipairs(group) do
      ExecuteCommand(('add_ace group.%s command.%s allow'):format(v, name))
    end
  else
    ExecuteCommand(('add_ace group.%s command.%s allow'):format(group, name))
  end
end

local function updateHealthAndArmorInMetadata(xPlayer)
  local ped = GetPlayerPed(xPlayer.source)
  local playerState = Player(xPlayer.source).state

  local isDead = playerState.isDead or false
  if isDead == true then
    isDead = 1
  elseif isDead == false then
    isDead = 0
  end

  xPlayer:setMeta('health', GetEntityHealth(ped))
  xPlayer:setMeta('armor', GetPedArmour(ped))
  xPlayer:setMeta('isDead', isDead)
end

---@param xPlayer table
---@param cb? function
---@return nil
function Core.SavePlayer(xPlayer, cb)
  updateHealthAndArmorInMetadata(xPlayer)
  local parameters = {
    --[[ accounts ]]
    json.encode(xPlayer:getAccounts(true)),
    --[[ job ]]
    xPlayer.job.name,
    --[[ job_grade ]]
    xPlayer.job.grade,
    --[[ group ]]
    xPlayer.group,
    --[[ position ]]
    json.encode(xPlayer:getCoords(false, true)),
    --[[ inventory ]]
    json.encode(xPlayer:getInventory(true)),
    --[[ loadout ]]
    json.encode(xPlayer:getLoadout(true)),
    --[[ metadata ]]
    json.encode(xPlayer:getMeta()),

    xPlayer.identifier,
  }

  MySQL.prepare(
    'UPDATE `users` SET `accounts` = ?, `job` = ?, `job_grade` = ?, `group` = ?, `position` = ?, `inventory` = ?, `loadout` = ?, `metadata` = ? WHERE `identifier` = ?',
    parameters,
    function(affectedRows)
      if affectedRows == 1 then
        print(('[^2INFO^7] Saved player ^5"%s^7"'):format(xPlayer.name))
        TriggerEvent('esx:playerSaved', xPlayer.playerId, xPlayer)
      end
      if cb then
        cb()
      end
    end
  )
end

---@param cb? function
---@return nil
function Core.SavePlayers(cb)
  local xPlayers = ESX.Players
  if not next(xPlayers) then
    return
  end

  local startTime = os.time()
  local parameters = {}

  for _, xPlayer in pairs(ESX.Players) do
    updateHealthAndArmorInMetadata(xPlayer)

    parameters[#parameters + 1] = {
      --[[ accounts ]]
      json.encode(xPlayer:getAccounts(true)),
      --[[ job ]]
      xPlayer.job.name,
      --[[ job_grade ]]
      xPlayer.job.grade,
      --[[ group ]]
      xPlayer.group,
      --[[ position ]]
      json.encode(xPlayer:getCoords(false, true)),
      --[[ inventory ]]
      json.encode(xPlayer:getInventory(true)),
      --[[ loadout ]]
      json.encode(xPlayer:getLoadout(true)),
      --[[ metadata ]]
      json.encode(xPlayer:getMeta()),

      xPlayer.identifier,
    }
  end

  MySQL.prepare(
    'UPDATE `users` SET `accounts` = ?, `job` = ?, `job_grade` = ?, `group` = ?, `position` = ?, `inventory` = ?, `loadout` = ?, `metadata` = ? WHERE `identifier` = ?',
    parameters,
    function(results)
      if not results then
        return
      end

      if type(cb) == 'function' then
        return cb()
      end

      print(
        ('[^2INFO^7] Saved ^5%s^7 %s over ^5%s^7 ms'):format(
          #parameters,
          #parameters > 1 and 'players' or 'player',
          lib.math.round((os.time() - startTime) / 1000000, 2)
        )
      )
    end
  )
end

ESX.GetPlayers = GetPlayers

local function checkTable(key, val, xPlayer, xPlayers, minimal)
  for valIndex = 1, #val do
    local value = val[valIndex]
    if not xPlayers[value] then
      xPlayers[value] = {}
    end

    if (key == 'job' and xPlayer.job.name == value) or xPlayer[key] == value then
      xPlayers[value][#xPlayers[value] + 1] = (minimal and xPlayer.source or xPlayer)
    end
  end
end

---@param key? string
---@param val? string | table
---@param minimal? boolean
---@return DEX.Player[] | number[] | table<any, DEX.Player[]> | table<any, number[]>
---@overload fun(key: nil, val: nil, minimal: nil): DEX.Player[]
function ESX.GetExtendedPlayers(key, val, minimal)
  if not key then
    if not minimal then
      return ESX.Table.ToArray(ESX.Players)
    end

    local xPlayers = {}
    local index = 1
    for src, _ in pairs(ESX.Players) do
      xPlayers[index] = src
      index += 1
    end

    return xPlayers
  end

  local xPlayers = {}
  if type(val) == 'table' then
    for _, xPlayer in pairs(ESX.Players) do
      checkTable(key, val, xPlayer, xPlayers, minimal)
    end

    return xPlayers
  end

  for _, xPlayer in pairs(ESX.Players) do
    if (key == 'job' and xPlayer.job.name == val) or xPlayer[key] == val then
      xPlayers[#xPlayers + 1] = (minimal and xPlayer.source or xPlayer)
    end
  end

  return xPlayers
end

---@param key? string
---@param val? string|table
---@return number | table
function ESX.GetNumPlayers(key, val)
  if not key then
    return #GetPlayers()
  end

  if type(val) == 'table' then
    local numPlayers = {}
    if key == 'job' then
      for _, v in ipairs(val) do
        numPlayers[v] = (Core.JobsPlayerCount[v] or 0)
      end
      return numPlayers
    end

    local filteredPlayers = ESX.GetExtendedPlayers(key, val)
    for i, v in pairs(filteredPlayers) do
      numPlayers[i] = (#v or 0)
    end
    return numPlayers
  end

  if key == 'job' then
    return (Core.JobsPlayerCount[val] or 0)
  end

  return #ESX.GetExtendedPlayers(key, val)
end

---@param source number
---@return DEX.Player?
function ESX.GetPlayerFromId(source)
  return ESX.Players[tonumber(source)]
end

---@param identifier string
---@return DEX.Player?
function ESX.GetPlayerFromIdentifier(identifier)
  return Core.PlayersByIdentifier[identifier]
end

---@param identifier string
---@return number playerId
function ESX.GetPlayerIdFromIdentifier(identifier)
  return Core.PlayersByIdentifier[identifier]?.source
end

---@param source number
---@return boolean
---@diagnostic disable-next-line: duplicate-set-field
function ESX.IsPlayerLoaded(source)
  return ESX.Players[source] ~= nil
end

---@param playerId number | string
---@return string
function ESX.GetIdentifier(playerId)
  local fxDk = GetConvarInt('sv_fxdkMode', 0)
  if fxDk == 1 then
    return 'ESX-DEBUG-LICENCE'
  end

  playerId = tostring(playerId)

  local identifierType = public.identifier
  local identifier = GetPlayerIdentifierByType(playerId, identifierType)

  assert(identifier, ('[ESX] GetIdentifier failed: no identifier found for playerId %s with type %s'):format(playerId, identifierType))

  return identifier
end

---@param model string | number
---@param player number
---@param cb function?
---@return string?
---@diagnostic disable-next-line: duplicate-set-field
function ESX.GetVehicleType(model, player, cb)
  if cb and not ESX.IsFunctionReference(cb) then
    error('Invalid callback function')
  end

  local promise = not cb and promise.new()
  local function resolve(result)
    if promise then
      promise:resolve(result)
    elseif cb then
      cb(result)
    end

    return result
  end

  model = type(model) == 'string' and joaat(model) or model

  if Core.vehicleTypesByModel[model] then
    return resolve(Core.vehicleTypesByModel[model])
  end

  local vehicleType = lib.callback.await('esx:getVehicleType', player, model)
  Core.vehicleTypesByModel[model] = vehicleType
  resolve(vehicleType)

  if promise then
    return Citizen.Await(promise)
  end
end

function ESX.GetIdsByJob(job)
  return Core.IdsByJobs[job]
end

---@return nil
function ESX.RefreshJobs()
  Core.JobsLoaded = false

  local Jobs = {}
  local jobs = MySQL.query.await('SELECT * FROM jobs')

  for _, v in ipairs(jobs) do
    Jobs[v.name] = v
    Jobs[v.name].grades = {}
    Core.IdsByJobs[v.name] = {}
  end

  local jobGrades = MySQL.query.await('SELECT * FROM job_grades')

  for _, v in ipairs(jobGrades) do
    if Jobs[v.job_name] then
      Jobs[v.job_name].grades[tostring(v.grade)] = v
    else
      print(('[^3WARNING^7] Ignoring job grades for ^5 %s ^0 due to missing job'):format(v.job_name))
    end
  end

  for _, v in pairs(Jobs) do
    if ESX.Table.SizeOf(v.grades) == 0 then
      Jobs[v.name] = nil
      print(('[^3WARNING^7] Ignoring job ^5 %s ^0 due to no job grades found'):format(v.name))
    end
  end

  if not Jobs then
    ESX.Jobs['unemployed'] = {
      name = 'unemployed',
      label = 'Unemployed',
      grades = { ['0'] = { grade = 0, name = 'unemployed', label = 'Unemployed', salary = 200, skin_male = {}, skin_female = {} } },
    }
  else
    ESX.Jobs = Jobs
  end

  TriggerEvent('esx:jobsRefreshed')
  Core.JobsLoaded = true
end

---@param item string
---@param cb function
---@return nil
function ESX.RegisterUsableItem(item, cb)
  Core.UsableItemsCallbacks[item] = cb
end

---@param source number
---@param item string
---@param ... any
---@return nil
function ESX.UseItem(source, item, ...)
  if ESX.Items[item] then
    local itemCallback = Core.UsableItemsCallbacks[item]

    if itemCallback then
      local success, result = pcall(itemCallback, source, item, ...)

      if not success then
        return result and print(result)
          or print(('[^3WARNING^7] An error occured when using item ^5 %s ^7! This was not caused by ESX.'):format(item))
      end
    end
  else
    print(('[^3WARNING^7] Item ^5 %s ^7 was used but does not exist!'):format(item))
  end
end

---@param item string
---@return string?
---@diagnostic disable-next-line: duplicate-set-field
function ESX.GetItemLabel(item)
  if ESX.Items[item] then
    return ESX.Items[item].label
  else
    print(('[^3WARNING^7] Attemting to get invalid Item -> ^5%s^7'):format(item))
  end
end

---@return table
function ESX.GetJobs()
  while not Core.JobsLoaded do
    Citizen.Wait(200)
  end

  return ESX.Jobs
end

---@return table
function ESX.GetItems()
  return ESX.Items
end

---@return table
function ESX.GetUsableItems()
  local Usables = {}
  for k in pairs(Core.UsableItemsCallbacks) do
    Usables[k] = true
  end
  return Usables
end

local function refreshPlayerInventories()
  local xPlayers = ESX.GetExtendedPlayers()
  for i = 1, #xPlayers do
    local xPlayer = xPlayers[i] --[[@as DEX.Player]]
    local minimalInv = xPlayer:getInventory(true) --[[@as table<string, integer>]]

    for itemName, _ in pairs(minimalInv) do
      if not ESX.Items[itemName] then
        xPlayer:setInventoryItem(itemName, 0)
        minimalInv[itemName] = nil
      end
    end

    xPlayer.inventory = {}
    for itemName, itemData in pairs(ESX.Items) do
      xPlayer.inventory[itemName] = {
        name = itemName,
        count = minimalInv[itemName] or 0,
        limit = itemData.limit,
        usable = Core.UsableItemsCallbacks[itemName] ~= nil,
        rare = itemData.rare,
        canRemove = itemData.canRemove,
        label = itemData.label,
      }
    end

    TriggerClientEvent('esx:setInventory', xPlayer.source, xPlayer.inventory)
  end
end

---@return number newItemCount
function ESX.RefreshItems()
  ESX.Items = {}

  local items = MySQL.query.await('SELECT * FROM items')
  local itemCount = #items
  for i = 1, itemCount do
    local item = items[i]
    ESX.Items[item.name] = {
      name = item.name,
      label = item.label,
      limit = item.limit,
      rare = item.rare,
      canRemove = item.can_remove,
    }
  end

  local previousItems = lib.loadJson('db.items')
  if not lib.table.matches(previousItems, ESX.Items) then
    SaveResourceFile(cache.resource, 'db/items.json', json.encode(ESX.Items), -1)

    CreateThread(function()
      while true do
        Wait(1000)
        lib.print.info('Base of server has detected that something changes in ESX.Items please restart server one time!')
      end
    end)
  end

  refreshPlayerInventories()

  return itemCount
end

---@param job string
---@param grade integer | string
---@return boolean
function ESX.DoesJobExist(job, grade)
  while not Core.JobsLoaded do
    Citizen.Wait(200)
  end

  return (ESX.Jobs[job] and ESX.Jobs[job].grades[tostring(grade)] ~= nil) or false
end

---@param playerSrc number
---@return boolean
function Core.IsPlayerAdmin(playerSrc)
  if type(playerSrc) ~= 'number' then
    return false
  end

  if
    IsPlayerAceAllowed(playerSrc --[[@as string]], 'command') or GetConvar('sv_lan', '') == 'true'
  then
    return true
  end

  local xPlayer = ESX.GetPlayerFromId(playerSrc)
  return xPlayer and public.admin_groups[xPlayer:getGroup()] or false
end
