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

---@param object integer | string The object to spawn
---@param coords table | vector3 The coords to spawn the object at
---@param cb? function The callback function
---@param networked? boolean Whether the object should be networked
---@return integer | nil
function ESX.Game.SpawnObject(object, coords, cb, networked)
  local model = type(object) == 'number' and object or joaat(object)

  ESX.Streaming.RequestModel(model)

  local obj = CreateObject(model, coords.x, coords.y, coords.z, networked == nil or networked, false, true)
  return cb and cb(obj) or obj
end

---@param object integer | string The object to spawn
---@param coords table | vector3 The coords to spawn the object at
---@param cb? function The callback function
---@return nil
function ESX.Game.SpawnLocalObject(object, coords, cb)
  ESX.Game.SpawnObject(object, coords, cb, false)
end

---@param object integer The object to delete
---@return nil
function ESX.Game.DeleteObject(object)
  SetEntityAsMissionEntity(object, false, true)
  DeleteObject(object)
end

---@return integer[]
function ESX.Game.GetObjects() -- Leave the function for compatibility
  return GetGamePool('CObject')
end

---@param coords? table | vector3 The coords to get the closest object to
---@param modelFilter? table The model filter
---@return integer, integer
function ESX.Game.GetClosestObject(coords, modelFilter)
  return ESX.Game.GetClosestEntity(ESX.Game.GetObjects(), false, coords, modelFilter)
end

---@param entities table The entities to search through
---@param isPlayerEntities boolean Whether the entities are players
---@param coords? table | vector3 The coords to search from
---@param modelFilter? table The model filter
---@return integer, integer
function ESX.Game.GetClosestEntity(entities, isPlayerEntities, coords, modelFilter)
  local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

  if coords then
    coords = vector3(coords.x, coords.y, coords.z)
  else
    local playerPed = cache.ped
    coords = GetEntityCoords(playerPed)
  end

  if modelFilter then
    filteredEntities = {}

    for currentEntityIndex = 1, #entities do
      if modelFilter[GetEntityModel(entities[currentEntityIndex])] then
        filteredEntities[#filteredEntities + 1] = entities[currentEntityIndex]
      end
    end
  end

  for k, entity in pairs(filteredEntities or entities) do
    local distance = #(coords - GetEntityCoords(entity))

    if closestEntityDistance == -1 or distance < closestEntityDistance then
      closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
    end
  end

  return closestEntity, closestEntityDistance
end
