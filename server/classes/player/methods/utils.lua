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

---@param eventName string
---@overload fun(eventName: string, ...)
function ExtendedPlayer:triggerEvent(eventName, ...)
  assert(type(eventName) == 'string', 'eventName should be string!')
  TriggerClientEvent(eventName, self.source, ...)
end

---@param coords vector4 | vector3
---@overload fun(coords: vector4 | vector3)
function ExtendedPlayer:setCoords(coords)
  local ped = GetPlayerPed(self.source)
  SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
  SetEntityHeading(ped, coords.w or coords.w or 0.0)
end

---@param getVector boolean?
---@param withHeading boolean?
---@overload fun(getVector?: boolean, withHeading?: boolean): vector3 | vector4
function ExtendedPlayer:getCoords(getVector, withHeading)
  local ped = GetPlayerPed(self.source)
  local entityCoords = GetEntityCoords(ped)
  local entityHeading = GetEntityHeading(ped)

  local coords = { x = entityCoords.x, y = entityCoords.y, z = entityCoords.z }

  if getVector then
    coords = (withHeading and vector4(entityCoords.x, entityCoords.y, entityCoords.z, entityHeading) or entityCoords)
  else
    if withHeading then
      coords.heading = entityHeading
    end
  end

  return coords
end

---@param reason string
---@overload fun(reason: string)
function ExtendedPlayer:kick(reason)
  DropPlayer(self.source --[[@as string]], reason)
end

---@param command string
---@overload fun(command: string)
function ExtendedPlayer:executeCommand(command)
  if type(command) ~= 'string' then
    error('xPlayer.executeCommand must be of type string!')
    return
  end

  self:triggerEvent('esx:executeCommand', command)
end
