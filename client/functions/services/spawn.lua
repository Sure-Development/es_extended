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

function ESX.DisableSpawnManager()
  if GetResourceState('spawnmanager') == 'started' then
    exports.spawnmanager:setAutoSpawn(false)
  end
end

---@param freeze boolean Whether to freeze the player
---@return nil
function Core.FreezePlayer(freeze)
  local ped = PlayerPedId()
  SetPlayerControl(cache.playerId, not freeze, 0)

  if freeze then
    SetEntityCollision(ped, false, false)
    FreezeEntityPosition(ped, true)
  else
    SetEntityCollision(ped, true, true)
    FreezeEntityPosition(ped, false)
  end
end

---@param skin table Skin data to set
---@param coords table Coords to spawn the player at
---@param cb function Callback function
---@return nil
function ESX.SpawnPlayer(skin, coords, cb)
  local p = promise.new()
  TriggerEvent('skinchanger:loadSkin', skin, function()
    p:resolve()
  end)
  Citizen.Await(p)

  RequestCollisionAtCoord(coords.x, coords.y, coords.z)

  local playerPed = PlayerPedId()
  local timer = GetGameTimer()

  Core.FreezePlayer(true)
  SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z, false, false, true)
  SetEntityHeading(playerPed, coords.heading)

  RequestCollisionAtCoord(coords.x, coords.y, coords.z)
  while not HasCollisionLoadedAroundEntity(playerPed) and (GetGameTimer() - timer) < 5000 do
    Wait(0)
  end

  NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, 0, true)
  TriggerEvent('playerSpawned', coords)

  cb()
end
