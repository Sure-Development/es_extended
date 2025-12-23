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

---@class DEX.Item
---@field name string
---@field label string
---@field limit integer | -1
---@field rare boolean
---@field canRemove boolean
---@field count integer
---@field usable boolean

---@class DEX.Loadout
---@field name string
---@field ammo integer
---@field label string
---@field components string[]
---@field tintIndex integer

---@class DEX.PlayerJob
---@field id integer
---@field name string
---@field label string
---@field grade integer
---@field grade_name string
---@field grade_label string
---@field grade_salary integer

---@class DEX.Account
---@field name string
---@field label string
---@field money integer
---@field round boolean
---@field index integer

---@class ExtendedPlayer : OxClass
---@field accounts DEX.Account[]
---@field inventory DEX.Item[]
---@field loadout DEX.Loadout[]
---@field job DEX.PlayerJob
---@field coords vector3
---@field name string
---@field playerId integer
---@field source integer
---@field identifier string
---@field license string
---@field variables table<string, any>
---@field metadata table<string, any>
---@field admin boolean
ExtendedPlayer = lib.class('ExtendedPlayer')

function ExtendedPlayer:constructor(playerId, identifier, group, accounts, inventory, job, loadout, name, coords, metadata)
  self.accounts = {}
  self.inventory = {}
  self.loadout = {}
  self.coords = coords
  self.group = group
  self.identifier = identifier
  self.job = job
  self.name = name
  self.playerId = playerId
  self.source = playerId
  self.variables = {}
  self.metadata = metadata
  self.admin = Core.IsPlayerAdmin(playerId)
  self.license = identifier

  lib.print.info(('[CLASS] identifier=%s group=%s'):format(self.license, self.group))
  ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.license, self.group))

  local stateBag = Player(self.source).state

  stateBag:set('name', self.name, true)
  stateBag:set('identifier', self.identifier, true)
  stateBag:set('job', self.job, true)
  stateBag:set('group', self.group, true)
  stateBag:set('metadata', self.metadata, true)

  for _, item in ipairs(inventory) do
    self.inventory[item.name] = item
  end

  for _, account in ipairs(accounts) do
    self.accounts[account.name] = account
  end

  for _, weapon in ipairs(loadout) do
    self.loadout[weapon.name] = weapon
  end

  for k, v in pairs(ExtendedPlayer) do
    if type(v) == 'function' and k ~= 'constructor' then
      self[k] = function(...)
        local args = { ... }
        if args[1] == self then
          return v(table.unpack(args))
        else
          return v(self, table.unpack(args))
        end
      end
    end
  end
end

---
--- MARK: Load parts of player
---

require('server.classes.player.methods.utils')
require('server.classes.player.methods.variables')
require('server.classes.player.methods.job')
require('server.classes.player.methods.accounts')
require('server.classes.player.methods.inventory')
require('server.classes.player.methods.loadout')
require('server.classes.player.methods.metadata')

return ExtendedPlayer
