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

---@param shape integer The shape to get the test result from
---@return boolean, table, table, integer, integer
function ESX.Game.GetShapeTestResultSync(shape)
  local handle, hit, coords, normal, material, entity
  repeat
    handle, hit, coords, normal, material, entity = GetShapeTestResultIncludingMaterial(shape)
    Wait(0)
  until handle ~= 1
  return hit, coords, normal, material, entity
end

---@param depth number The depth to raycast
---@vararg any The arguments to pass to the shape test
---@return table, boolean, table, table, integer, integer
function ESX.Game.RaycastScreen(depth, ...)
  local world, normal = GetWorldCoordFromScreenCoord(0.5, 0.5)
  local origin = world + normal
  local target = world + normal * depth
  return target, ESX.Game.GetShapeTestResultSync(StartShapeTestLosProbe(origin.x, origin.y, origin.z, target.x, target.y, target.z, ...))
end
