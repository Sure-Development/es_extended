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

---@param entities table The entities to search through
---@param isPlayerEntities boolean Whether the entities are players
---@param coords table | vector3 The coords to search from
---@param maxDistance number The max distance to search within
---@return table
Core.EnumerateEntitiesWithinDistance = function(entities, isPlayerEntities, coords, maxDistance)
  local nearbyEntities = {}

  if coords then
    coords = vector3(coords.x, coords.y, coords.z)
  else
    local playerPed = cache.ped
    coords = GetEntityCoords(playerPed)
  end

  for k, entity in pairs(entities) do
    local distance = #(coords - GetEntityCoords(entity))

    if distance <= maxDistance then
      nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
    end
  end

  return nearbyEntities
end

require('client.functions.services.game.player-ped')
require('client.functions.services.game.utils')
require('client.functions.services.game.object')
require('client.functions.services.game.vehicle')
require('client.functions.services.game.raycast')
