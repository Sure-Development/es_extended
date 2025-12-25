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

      lib.print.info(
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

---@param job string
---@return table<integer, true>
function ESX.GetIdsByJob(job)
  return Core.IdsByJobs[job]
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
