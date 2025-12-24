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

local orm = require('server.classes.orm')

ESX.Players = {}
ESX.Jobs = {}

---@class (partial) DEX.Partial.Item : DEX.Item
---@type { [string]: DEX.Partial.Item }
ESX.Items = {}

Core = {}
Core.JobsPlayerCount = {}
Core.UsableItemsCallbacks = {}
Core.RegisteredCommands = {}
Core.DatabaseConnected = false
Core.PlayersByIdentifier = {}
Core.JobsLoaded = false
Core.IdsByJobs = {}

--- Bootstrap
require('server.functions')
require('server.modules')
require('server.modules.services.commands')
require('server.modules.services.createJob')
require('server.modules.services.onesync')

BOOTSTRAP:resolve()

local function StartDBSync()
  CreateThread(function()
    local interval = 5 * 60 * 1000
    while true do
      Wait(interval)
      Core.SavePlayers()
    end
  end)
end

MySQL.ready(function()
  Core.DatabaseConnected = true

  --- Install database
  local createdUsers = orm:createTableIfNotExists('users_test', {
    { name = 'identifier', type = 'VARCHAR(60) NOT NULL PRIMARY KEY' },
    { name = 'accounts', type = 'LONGTEXT NULL DEFAULT NULL' },
    { name = 'group', type = 'VARCHAR(50) NULL DEFAULT \'user\'' },
    { name = 'inventory', type = 'LONGTEXT NULL DEFAULT NULL' },
    { name = 'job', type = 'VARCHAR(20) NULL DEFAULT \'unemployed\'' },
    { name = 'job_grade', type = 'INT NULL DEFAULT 0' },
    { name = 'loadout', type = 'LONGTEXT NULL DEFAULT NULL' },
    { name = 'metadata', type = 'LONGTEXT NULL DEFAULT NULL' },
    { name = 'position', type = 'LONGTEXT NULL DEFAULT NULL' },
    { name = 'firstname', type = 'VARCHAR(50) NULL DEFAULT NULL' },
    { name = 'lastname', type = 'VARCHAR(50) NULL DEFAULT NULL' },
    { name = 'dateofbirth', type = 'VARCHAR(50) NULL DEFAULT NULL' },
    { name = 'sex', type = 'VARCHAR(50) NULL DEFAULT NULL' },
    { name = 'height', type = 'INT(11) NULL DEFAULT NULL' },
    { name = 'skin', type = 'LONGTEXT NULL DEFAULT NULL' },
    { name = 'phone_number', type = 'VARCHAR(50) NULL DEFAULT NULL' },
  })

  local createdItems = orm:createTableIfNotExists('items', {
    { name = 'name', type = 'VARCHAR(50) NOT NULL PRIMARY KEY' },
    { name = 'label', type = 'VARCHAR(50) NOT NULL' },
    { name = 'limit', type = 'INT NOT NULL DEFAULT -1' },
    { name = 'rare', type = 'TINYINT NOT NULL DEFAULT 0' },
    { name = 'can_remove', type = 'TINYINT NOT NULL DEFAULT 1' },
  })

  local createdJobs = orm:createTableIfNotExists('jobs', {
    { name = 'name', type = 'VARCHAR(50) NOT NULL PRIMARY KEY' },
    { name = 'label', type = 'VARCHAR(50) DEFAULT NULL' },
  })

  local createdJobGrades = orm:createTableIfNotExists('job_grades', {
    { name = 'id', type = 'INT NOT NULL PRIMARY KEY AUTO_INCREMENT' },
    { name = 'job_name', type = 'VARCHAR(50) DEFAULT NULL' },
    { name = 'grade', type = 'INT NOT NULL' },
    { name = 'name', type = 'VARCHAR(50) NOT NULL' },
    { name = 'label', type = 'VARCHAR(50) NOT NULL' },
  })

  if createdUsers then
    lib.print.info('Setup table [users] successfully')
  end

  if createdItems then
    lib.print.info('Setup table [items] successfully')
  end

  if createdJobs then
    orm:createPrepare('jobs', { name = 'unemployed', label = 'Unemployed' })
    lib.print.info('Setup table [jobs] successfully with inserted unemployed data')
  end

  if createdJobGrades then
    orm:createPrepare('job_grades', {
      id = 1,
      job_name = 'unemployed',
      grade = 0,
      name = 'unemployed',
      label = 'Unemployed',
    })
    lib.print.info('Setup table [job_grades] successfully with inserted unemployed data')
  end

  ESX.RefreshItems()
  ESX.RefreshJobs()

  lib.print.info(('[^2INFO^7] ESX ^5Legacy %s^0 initialized!'):format(GetResourceMetadata('es_extended', 'version', 0)))
  lib.print.info('Fully Optimized <3 by Dogeaterx (999s)')

  StartDBSync()
end)

RegisterNetEvent('esx:clientLog', function(msg)
  if DEBUG then
    lib.print.info(('[^2TRACE^7] %s^7'):format(msg))
  end
end)

local function runStaticPlayerMethod(src, method, ...)
  local xPlayer = ESX.Players[src]
  if not xPlayer then
    return
  end

  if not ESX.IsFunctionReference(xPlayer[method]) then
    return xPlayer[method]
  end

  return xPlayer[method](...)
end

exports('runStaticPlayerMethod', runStaticPlayerMethod)

GlobalState.playerCount = 0
