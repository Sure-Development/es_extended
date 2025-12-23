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

local createPlayer = require('server.modules.player.create')
local loadPlayer = require('server.modules.player.load')

---@param source integer
return function(source)
  local identifier = ESX.GetIdentifier(source)
  if not identifier then
    return DropPlayer(
      source --[[@as string]],
      'there was an error loading your character!\nError code: identifier-missing-ingame\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.'
    )
  end

  if ESX.GetPlayerFromIdentifier(identifier) then
    DropPlayer(
      source --[[@as string]],
      ('there was an error loading your character!\nError code: identifier-active-ingame\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same Rockstar account.\n\nYour Rockstar identifier: %s'):format(
        identifier
      )
    )
  else
    local result = MySQL.scalar.await('SELECT 1 FROM users WHERE identifier = ?', { identifier })
    if result then
      loadPlayer(identifier, source, false)
    else
      createPlayer(identifier, source)
    end
  end
end
