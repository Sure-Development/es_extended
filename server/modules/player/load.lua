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

---@class DEX.Player : ExtendedPlayer
local player = require('server.classes.player')
local public = require('settings.public')
local orm = require('server.classes.orm')

local mapKeyMethods = {
  job = 'getJob',
  source = 'getSource',
  playerId = 'getSource',
  group = 'getGroup',
  identifier = 'getIdentifier',
  license = 'getIdentifier',
  metadata = 'getMetadata',
  accounts = 'getAccounts',
  inventory = 'getInventory',
  loadout = 'getLoadout',
  admin = 'isAdmin',
  name = 'getName',
  coords = 'getCoords',
}

---@class (functions) DEX.Player.Functions : DEX.Player
---@param src number
---@return DEX.Player.Functions
local function createStaticPlayer(src)
  local self = {}

  self.source = src
  for _, method in pairs(mapKeyMethods) do
    self[method] = function(...)
      return exports.es_extended:runStaticPlayerMethod(self.source, method, ...)
    end
  end

  return self
end

---@param src number|string
---@return DEX.Player.Functions?
local function GetPlayerExtended(src)
  if type(src) ~= 'number' then
    src = ESX.GetPlayerIdFromIdentifier(src)
    if not src then
      return
    end
  elseif not ESX.IsPlayerLoaded(src) then
    return
  end

  return createStaticPlayer(src)
end

---@param identifier string
---@param source integer
---@param isNew boolean?
return function(identifier, source, isNew)
  local userData = {
    accounts = {},
    inventoryServer = {},
    inventoryClient = {},
    loadout = {},
    name = GetPlayerName(source),
    identifier = identifier,
    firstName = '',
    lastName = '',
    dateofbirth = '01/01/2000',
    height = 120,
  }

  local result = orm:findPrepare('users', { identifier = identifier })
  if not result then
    return
  end

  local accounts = result.accounts
  accounts = (accounts and accounts ~= '') and json.decode(accounts) or {}

  for account, data in pairs(public.accounts) do
    data.round = data.round or data.round == nil

    local index = #userData.accounts + 1
    userData.accounts[index] = {
      name = account,
      money = accounts[account] or public.starter.accounts[account] or 0,
      label = data.label,
      round = data.round,
      index = index,
    }
  end

  local job, grade = result.job, tostring(result.job_grade)

  if
    not ESX.DoesJobExist(job --[[@as string]], grade --[[@as integer]])
  then
    lib.print.warn(('[^3WARNING^7] Ignoring invalid job for ^5%s^7 [job: ^5%s^7, grade: ^5%s^7]'):format(identifier, job, grade))
    job, grade = 'unemployed', '0'
  end

  local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

  userData.job = {
    id = jobObject.id,
    name = jobObject.name,
    label = jobObject.label,
    grade = tonumber(grade) --[[@as integer]],
    grade_name = gradeObject.name,
    grade_label = gradeObject.label,
    grade_salary = gradeObject.salary,
  }

  local inventory = (result.inventory and result.inventory ~= '') and json.decode(result.inventory) or {}

  for name, item in pairs(ESX.Items) do
    local count = inventory[name] or 0

    local playerItemData = {
      name = name,
      count = count,
      label = item.label,
      limit = item.limit,
      usable = Core.UsableItemsCallbacks[name] ~= nil,
      rare = item.rare,
      canRemove = item.canRemove,
    }

    userData.inventoryServer[#userData.inventoryServer + 1] = playerItemData

    if count > 0 then
      userData.inventoryClient[#userData.inventoryClient + 1] = {
        name = name,
        count = count,
        usable = Core.UsableItemsCallbacks[name] ~= nil,
      }
    end
  end

  if result.group then
    if result.group == 'superadmin' then
      userData.group = 'admin'
      lib.print.warn('[^3WARNING^7] ^5Superadmin^7 detected, setting group to ^5admin^7')
    else
      userData.group = result.group
    end
  else
    userData.group = 'user'
  end

  if result.loadout and result.loadout ~= '' then
    local loadout = json.decode(result.loadout)
    for name, weapon in pairs(loadout) do
      local label = ESX.GetWeaponLabel(name)

      if label then
        userData.loadout[name] = {
          name = name,
          ammo = weapon.ammo,
          label = label,
          components = weapon.components or {},
          tintIndex = weapon.tintIndex or 0,
        }
      end
    end
  end

  userData.coords = json.decode(result.position) or public.spawn_points[ESX.Math.Random(1, #public.spawn_points)]
  userData.skin = (result.skin and result.skin ~= '') and json.decode(result.skin) or { sex = userData.sex == 'f' and 1 or 0 }
  userData.metadata = (result.metadata and result.metadata ~= '') and json.decode(result.metadata) or {}

  local xPlayer = player:new(
    source,
    identifier,
    userData.group,
    userData.accounts,
    userData.inventoryServer,
    userData.job,
    userData.loadout,
    GetPlayerName(source),
    userData.coords,
    userData.metadata
  )

  GlobalState['playerCount'] = GlobalState['playerCount'] + 1
  ESX.Players[source] = xPlayer
  Core.PlayersByIdentifier[identifier] = xPlayer

  if result.firstname and result.firstname ~= '' then
    userData.firstName = result.firstname
    userData.lastName = result.lastname

    local name = ('%s %s'):format(result.firstname, result.lastname)
    userData.name = name

    xPlayer:set('firstName', result.firstname)
    xPlayer:set('lastName', result.lastname)
    xPlayer:setName(name)

    if result.dateofbirth then
      userData.dateofbirth = result.dateofbirth
      xPlayer:set('dateofbirth', result.dateofbirth)
    end
    if result.sex then
      userData.sex = result.sex
      xPlayer:set('sex', result.sex)
    end
    if result.height then
      userData.height = result.height
      xPlayer:set('height', result.height)
    end
  end

  userData.money = xPlayer:getMoney()
  userData.variables = xPlayer.variables or {}

  local extendedPlayer = GetPlayerExtended(source)
  TriggerEvent('esx:playerLoaded', source, extendedPlayer, isNew)

  --- Cleanup before send to client
  userData.inventoryServer = nil
  userData.identifier = nil
  userData.dateofbirth = nil
  userData.name = nil
  userData.firstName = nil
  userData.lastName = nil
  userData.height = nil
  userData.job = nil
  userData.variables = nil
  userData.metadata = nil
  userData.group = nil

  xPlayer:triggerEvent('esx:playerLoaded', userData, isNew)
  xPlayer:triggerEvent('esx:registerSuggestions', Core.RegisteredCommands)

  lib.print.info(('[^2INFO^0] Player ^5"%s"^0 has connected to the server. ID: ^5%s^7'):format(xPlayer:getName(), source))
end
