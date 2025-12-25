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

---@param onlyOtherPeds? boolean Whether to exlude the player ped
---@return table
function ESX.Game.GetPeds(onlyOtherPeds)
  local pool = GetGamePool('CPed')

  if onlyOtherPeds then
    local myPed = cache.ped
    for i = 1, #pool do
      if pool[i] == myPed then
        table.remove(pool, i)
        break
      end
    end
  end

  return pool
end

---@param onlyOtherPlayers? boolean Whether to exclude the player
---@param returnKeyValue? boolean Whether to return the key value pair
---@param returnPeds? boolean Whether to return the peds
---@return table
function ESX.Game.GetPlayers(onlyOtherPlayers, returnKeyValue, returnPeds)
  local players = {}
  local active = GetActivePlayers()

  for i = 1, #active do
    local currentPlayer = active[i]
    local ped = GetPlayerPed(currentPlayer)

    if DoesEntityExist(ped) and ((onlyOtherPlayers and currentPlayer ~= cache.playerId) or not onlyOtherPlayers) then
      if returnKeyValue then
        players[currentPlayer] = ped
      else
        players[#players + 1] = returnPeds and ped or currentPlayer
      end
    end
  end

  return players
end

---@param ped integer The ped to get the mugshot of
---@param transparent? boolean Whether the mugshot should be transparent
function ESX.Game.GetPedMugshot(ped, transparent)
  if not DoesEntityExist(ped) then
    return
  end
  local mugshot = transparent and RegisterPedheadshotTransparent(ped) or RegisterPedheadshot(ped)

  while not IsPedheadshotReady(mugshot) do
    Wait(0)
  end

  return mugshot, GetPedheadshotTxdString(mugshot)
end

---@param coords? table | vector3 The coords to get the closest ped to
---@param modelFilter? table The model filter
---@return integer, integer
function ESX.Game.GetClosestPed(coords, modelFilter)
  return ESX.Game.GetClosestEntity(ESX.Game.GetPeds(true), false, coords, modelFilter)
end

---@param coords? table | vector3 The coords to get the closest player to
---@return integer, integer
function ESX.Game.GetClosestPlayer(coords)
  return ESX.Game.GetClosestEntity(ESX.Game.GetPlayers(true, true), true, coords, nil)
end

---@param coords table | vector3 The coords to search from
---@param maxDistance number The max distance to search within
---@return table
function ESX.Game.GetPlayersInArea(coords, maxDistance)
  return Core.EnumerateEntitiesWithinDistance(ESX.Game.GetPlayers(true, true), true, coords, maxDistance)
end
