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
local orm = require('server.classes.orm')
local loadPlayer = require('server.modules.player.load')

---@param identifier string
---@param source integer
return function(identifier, source)
  local accounts = {}

  for account, money in pairs(public.starter.accounts) do
    accounts[account] = money
  end

  local defaultGroup = 'user'
  if Core.IsPlayerAdmin(source) then
    lib.print.info(('[^2INFO^0] Player ^5%s^0 Has been granted admin permissions via ^5Ace Perms^7.'):format(source))
    defaultGroup = 'admin'
  end

  orm:createPrepare('users', {
    identifier = identifier,
    group = defaultGroup,
    accounts = json.encode(accounts),
    inventory = json.encode(json.encode(public.starter.items)),
  })

  loadPlayer(identifier, source, true)
end
