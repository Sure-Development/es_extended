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

---@param entity integer The entity to get the coords of
---@param coords table | vector3 | vector4 The coords to teleport the entity to
---@param cb? function The callback function
function ESX.Game.Teleport(entity, coords, cb)
  if DoesEntityExist(entity) then
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    while not HasCollisionLoadedAroundEntity(entity) do
      Wait(0)
    end

    SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)
    SetEntityHeading(entity, coords.w or coords.heading or 0.0)
  end

  if cb then
    cb()
  end
end

---@param coords vector3 | table coords to get the closest pickup to
---@param text string The text to display
---@param size? number The size of the text
---@param font? number The font of the text
---@return nil
function ESX.Game.Utils.DrawText3D(coords, text, size, font)
  local vector = type(coords) == 'vector3' and coords or vec(coords.x, coords.y, coords.z)

  local camCoords = GetFinalRenderedCamCoord()
  local distance = #(vector - camCoords)

  size = size or 1
  font = font or 0

  local scale = (size / distance) * 2
  local fov = (1 / GetGameplayCamFov()) * 100
  scale = scale * fov

  SetTextScale(0.0, 0.55 * scale)
  SetTextFont(font)
  SetTextProportional(true)
  SetTextColour(255, 255, 255, 215)
  BeginTextCommandDisplayText('STRING')
  SetTextCentre(true)
  AddTextComponentSubstringPlayerName(text)
  SetDrawOrigin(vector.x, vector.y, vector.z, 0)
  EndTextCommandDisplayText(0.0, 0.0)
  ClearDrawOrigin()
end
