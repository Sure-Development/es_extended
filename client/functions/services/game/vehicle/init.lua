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

---@param vehicle integer The vehicle to delete
---@return nil
function ESX.Game.DeleteVehicle(vehicle)
  SetEntityAsMissionEntity(vehicle, true, true)
  DeleteVehicle(vehicle)
end

---@param vehicleModel integer | string The vehicle to spawn
---@param coords table | vector3 The coords to spawn the vehicle at
---@param heading number The heading of the vehicle
---@param cb? fun(vehicle: number) The callback function
---@param networked? boolean Whether the vehicle should be networked
---@return number? vehicle
function ESX.Game.SpawnVehicle(vehicleModel, coords, heading, cb, networked)
  if cb and not ESX.IsFunctionReference(cb) then
    error('Invalid callback function')
  end

  local model = type(vehicleModel) == 'number' and vehicleModel or joaat(vehicleModel)
  local vector = type(coords) == 'vector3' and coords or vec(coords.x, coords.y, coords.z)
  local isNetworked = networked == nil or networked

  local playerCoords = GetEntityCoords(cache.ped)
  if not vector or not playerCoords then
    return
  end

  local dist = #(playerCoords - vector)
  if dist > 424 then -- Onesync infinity Range (https://docs.fivem.net/docs/scripting-reference/onesync/)
    local executingResource = GetInvokingResource() or 'Unknown'
    return error(
      ('Resource ^5%s^1 Tried to spawn vehicle on the client but the position is too far away (Out of onesync range).'):format(executingResource)
    )
  end

  local promise = not cb and promise.new()
  CreateThread(function()
    local modelHash = ESX.Streaming.RequestModel(model)
    if not modelHash then
      if promise then
        promise:reject(('Tried to spawn invalid vehicle - ^5%s^7!'):format(model))
        return
      end
      error(('Tried to spawn invalid vehicle - ^5%s^7!'):format(model))
    end

    local vehicle = CreateVehicle(model, vector.x, vector.y, vector.z, heading, isNetworked, true)

    if networked then
      local id = NetworkGetNetworkIdFromEntity(vehicle)
      SetNetworkIdCanMigrate(id, true)
      SetEntityAsMissionEntity(vehicle, true, true)
    end
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetModelAsNoLongerNeeded(model)
    SetVehRadioStation(vehicle, 'OFF')

    RequestCollisionAtCoord(vector.x, vector.y, vector.z)
    while not HasCollisionLoadedAroundEntity(vehicle) do
      Wait(0)
    end

    if promise then
      promise:resolve(vehicle)
    elseif cb then
      cb(vehicle)
    end
  end)

  if promise then
    return Citizen.Await(promise)
  end
end

---@param vehicle integer The vehicle to spawn
---@param coords table | vector3 The coords to spawn the vehicle at
---@param heading number The heading of the vehicle
---@param cb? function The callback function
---@return nil
function ESX.Game.SpawnLocalVehicle(vehicle, coords, heading, cb)
  ESX.Game.SpawnVehicle(vehicle, coords, heading, cb, false)
end

---@param vehicle integer The vehicle to check
---@return boolean
function ESX.Game.IsVehicleEmpty(vehicle)
  return GetVehicleNumberOfPassengers(vehicle) == 0 and IsVehicleSeatFree(vehicle, -1)
end

---@return table
function ESX.Game.GetVehicles() -- Leave the function for compatibility
  return GetGamePool('CVehicle')
end

---@param coords? table | vector3 The coords to get the closest vehicle to
---@param modelFilter? table The model filter
---@return integer, integer
function ESX.Game.GetClosestVehicle(coords, modelFilter)
  return ESX.Game.GetClosestEntity(ESX.Game.GetVehicles(), false, coords, modelFilter)
end

---@param coords table | vector3 The coords to search from
---@param maxDistance number The max distance to search within
---@return table
function ESX.Game.GetVehiclesInArea(coords, maxDistance)
  return Core.EnumerateEntitiesWithinDistance(ESX.Game.GetVehicles(), false, coords, maxDistance)
end

---@param coords table | vector3 The coords to search from
---@param maxDistance number The max distance to search within
---@return boolean
function ESX.Game.IsSpawnPointClear(coords, maxDistance)
  return #ESX.Game.GetVehiclesInArea(coords, maxDistance) == 0
end

---@return integer | nil, vector3 | nil
function ESX.Game.GetVehicleInDirection()
  local _, hit, coords, _, _, entity = ESX.Game.RaycastScreen(5, 10, cache.ped)
  if hit and IsEntityAVehicle(entity) then
    return entity, coords
  end
end

local __GVM, __ITMO, __GVL, __GVWT = GetVehicleMod, IsToggleModOn, GetVehicleLivery, GetVehicleWindowTint
local GetVehicleMod = function(vehicle, modType)
  local mod = __GVM(vehicle, modType)
  return mod ~= -1 and mod or nil
end

local IsToggleModOn = function(vehicle, modType)
  return __ITMO(vehicle, modType) or nil
end

local GetVehicleLivery = function(vehicle)
  local mod = __GVL(vehicle)
  return mod ~= -1 and mod or nil
end

local GetVehicleWindowTint = function(vehicle)
  local tint = __GVWT(vehicle)
  return tint ~= -1 and tint or nil
end

---@param vehicle integer The vehicle to get the properties of
---@return table | nil
function ESX.Game.GetVehicleProperties(vehicle)
  if not DoesEntityExist(vehicle) then
    return
  end

  local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
  local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
  local hasCustomPrimaryColor = GetIsVehiclePrimaryColourCustom(vehicle)
  local customPrimaryColor = hasCustomPrimaryColor and { GetVehicleCustomPrimaryColour(vehicle) } or nil

  local customXenonColorR, customXenonColorG, customXenonColorB = GetVehicleXenonLightsCustomColor(vehicle)
  local customXenonColor = nil
  if customXenonColorR and customXenonColorG and customXenonColorB then
    customXenonColor = { customXenonColorR, customXenonColorG, customXenonColorB }
  end

  local hasCustomSecondaryColor = GetIsVehicleSecondaryColourCustom(vehicle)
  local customSecondaryColor = hasCustomSecondaryColor and { GetVehicleCustomSecondaryColour(vehicle) } or nil

  local haveExtras = false
  local extras = {}
  for extraId = 0, 12 do
    if DoesExtraExist(vehicle, extraId) then
      extras[tostring(extraId)] = IsVehicleExtraTurnedOn(vehicle, extraId)
      haveExtras = true
    end
  end

  local someDoorsBroken, someWindowsBroken, someTyreBurst, someNeonEnabled = false, false, false, false
  local doorsBroken, windowsBroken, tyreBurst = {}, {}, {}
  local numWheels = tostring(GetVehicleNumberOfWheels(vehicle))

  local tyresIndex = {
    ['2'] = { 0, 4 },
    ['3'] = { 0, 1, 4, 5 },
    ['4'] = { 0, 1, 4, 5 },
    ['6'] = { 0, 1, 2, 3, 4, 5 },
  }
  if tyresIndex[numWheels] then
    for _, idx in pairs(tyresIndex[numWheels]) do
      local state = not not IsVehicleTyreBurst(vehicle, idx, false)
      tyreBurst[tostring(idx)] = state
      if state then
        someTyreBurst = true
      end
    end
  end

  for windowId = 0, 7 do
    local state = not IsVehicleWindowIntact(vehicle, windowId)
    windowsBroken[tostring(windowId)] = state
    if state then
      someWindowsBroken = true
    end
  end

  local numDoors = GetNumberOfVehicleDoors(vehicle)
  if numDoors and numDoors > 0 then
    for doorsId = 0, numDoors do
      local state = not not IsVehicleDoorDamaged(vehicle, doorsId)
      doorsBroken[tostring(doorsId)] = state
      if state then
        someDoorsBroken = true
      end
    end
  end

  local neonEnabled = {}
  for i = 0, 3 do
    local state = IsVehicleNeonLightEnabled(vehicle, i)
    neonEnabled[i + 1] = state
    if state then
      someNeonEnabled = true
    end
  end

  return {
    model = GetEntityModel(vehicle),
    plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),
    plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
    doorsBroken = someDoorsBroken and doorsBroken or nil,
    windowsBroken = someWindowsBroken and windowsBroken or nil,
    tyreBurst = someTyreBurst and tyreBurst or nil,

    bodyHealth = lib.math.round(GetVehicleBodyHealth(vehicle), 1),
    engineHealth = lib.math.round(GetVehicleEngineHealth(vehicle), 1),
    tankHealth = lib.math.round(GetVehiclePetrolTankHealth(vehicle), 1),

    fuelLevel = lib.math.round(GetVehicleFuelLevel(vehicle), 1),
    dirtLevel = lib.math.round(GetVehicleDirtLevel(vehicle), 1),

    color1 = colorPrimary,
    color2 = colorSecondary,
    customPrimaryColor = customPrimaryColor,
    customSecondaryColor = customSecondaryColor,

    pearlescentColor = pearlescentColor,
    wheelColor = wheelColor,

    wheels = GetVehicleWheelType(vehicle),
    windowTint = GetVehicleWindowTint(vehicle),
    xenonColor = GetVehicleXenonLightsColor(vehicle),
    customXenonColor = customXenonColor,

    neonEnabled = someNeonEnabled and neonEnabled or nil,

    neonColor = { GetVehicleNeonLightsColour(vehicle) },
    extras = haveExtras and extras or nil,
    tyreSmokeColor = { GetVehicleTyreSmokeColor(vehicle) },

    modSpoilers = GetVehicleMod(vehicle, 0),
    modFrontBumper = GetVehicleMod(vehicle, 1),
    modRearBumper = GetVehicleMod(vehicle, 2),
    modSideSkirt = GetVehicleMod(vehicle, 3),
    modExhaust = GetVehicleMod(vehicle, 4),
    modFrame = GetVehicleMod(vehicle, 5),
    modGrille = GetVehicleMod(vehicle, 6),
    modHood = GetVehicleMod(vehicle, 7),
    modFender = GetVehicleMod(vehicle, 8),
    modRightFender = GetVehicleMod(vehicle, 9),
    modRoof = GetVehicleMod(vehicle, 10),

    modEngine = GetVehicleMod(vehicle, 11),
    modBrakes = GetVehicleMod(vehicle, 12),
    modTransmission = GetVehicleMod(vehicle, 13),
    modHorns = GetVehicleMod(vehicle, 14),
    modSuspension = GetVehicleMod(vehicle, 15),
    modArmor = GetVehicleMod(vehicle, 16),

    modTurbo = IsToggleModOn(vehicle, 18),
    modSmokeEnabled = IsToggleModOn(vehicle, 20),
    modXenon = IsToggleModOn(vehicle, 22),

    modFrontWheels = GetVehicleMod(vehicle, 23),
    modBackWheels = GetVehicleMod(vehicle, 24),

    modPlateHolder = GetVehicleMod(vehicle, 25),
    modVanityPlate = GetVehicleMod(vehicle, 26),
    modTrimA = GetVehicleMod(vehicle, 27),
    modOrnaments = GetVehicleMod(vehicle, 28),
    modDashboard = GetVehicleMod(vehicle, 29),
    modDial = GetVehicleMod(vehicle, 30),
    modDoorSpeaker = GetVehicleMod(vehicle, 31),
    modSeats = GetVehicleMod(vehicle, 32),
    modSteeringWheel = GetVehicleMod(vehicle, 33),
    modShifterLeavers = GetVehicleMod(vehicle, 34),
    modAPlate = GetVehicleMod(vehicle, 35),
    modSpeakers = GetVehicleMod(vehicle, 36),
    modTrunk = GetVehicleMod(vehicle, 37),
    modHydrolic = GetVehicleMod(vehicle, 38),
    modEngineBlock = GetVehicleMod(vehicle, 39),
    modAirFilter = GetVehicleMod(vehicle, 40),
    modStruts = GetVehicleMod(vehicle, 41),
    modArchCover = GetVehicleMod(vehicle, 42),
    modAerials = GetVehicleMod(vehicle, 43),
    modTrimB = GetVehicleMod(vehicle, 44),
    modTank = GetVehicleMod(vehicle, 45),
    modDoorR = GetVehicleMod(vehicle, 47),
    modLivery = GetVehicleMod(vehicle, 48),
    modLightbar = GetVehicleMod(vehicle, 49),

    livery = GetVehicleLivery(vehicle),
  }
end

---@param vehicle integer The vehicle to set the properties of
---@param props table The properties to set
---@return nil
function ESX.Game.SetVehicleProperties(vehicle, props)
  if not DoesEntityExist(vehicle) then
    return
  end
  local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
  local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
  SetVehicleModKit(vehicle, 0)

  if props.plate then
    SetVehicleNumberPlateText(vehicle, props.plate)
  end
  if props.plateIndex then
    SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
  end
  if props.customPrimaryColor then
    SetVehicleCustomPrimaryColour(vehicle, props.customPrimaryColor[1], props.customPrimaryColor[2], props.customPrimaryColor[3])
  end
  if props.customSecondaryColor then
    SetVehicleCustomSecondaryColour(vehicle, props.customSecondaryColor[1], props.customSecondaryColor[2], props.customSecondaryColor[3])
  end
  if props.color1 then
    SetVehicleColours(vehicle, props.color1, colorSecondary)
  end
  if props.color2 then
    SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2)
  end
  if props.pearlescentColor then
    SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
  end
  if props.wheelColor then
    SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor)
  end
  if props.wheels then
    SetVehicleWheelType(vehicle, props.wheels)
  end
  if props.windowTint then
    SetVehicleWindowTint(vehicle, props.windowTint)
  end

  if props.neonEnabled then
    for i = 0, 3 do
      SetVehicleNeonLightEnabled(vehicle, i, props.neonEnabled[i + 1])
    end
  end

  if props.extras then
    for extraId, enabled in pairs(props.extras) do
      SetVehicleExtra(vehicle, tonumber(extraId) --[[@as integer]], enabled and false or true)
    end
  end

  if props.neonColor then
    SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
  end
  if props.xenonColor then
    SetVehicleXenonLightsColor(vehicle, props.xenonColor)
  end
  if props.customXenonColor then
    SetVehicleXenonLightsCustomColor(vehicle, props.customXenonColor[1], props.customXenonColor[2], props.customXenonColor[3])
  end
  if props.modSmokeEnabled then
    ToggleVehicleMod(vehicle, 20, true)
  end
  if props.tyreSmokeColor then
    SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
  end

  if props.modSpoilers then
    SetVehicleMod(vehicle, 0, props.modSpoilers, false)
  end
  if props.modFrontBumper then
    SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
  end
  if props.modRearBumper then
    SetVehicleMod(vehicle, 2, props.modRearBumper, false)
  end
  if props.modSideSkirt then
    SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
  end
  if props.modExhaust then
    SetVehicleMod(vehicle, 4, props.modExhaust, false)
  end
  if props.modFrame then
    SetVehicleMod(vehicle, 5, props.modFrame, false)
  end
  if props.modGrille then
    SetVehicleMod(vehicle, 6, props.modGrille, false)
  end
  if props.modHood then
    SetVehicleMod(vehicle, 7, props.modHood, false)
  end
  if props.modFender then
    SetVehicleMod(vehicle, 8, props.modFender, false)
  end
  if props.modRightFender then
    SetVehicleMod(vehicle, 9, props.modRightFender, false)
  end
  if props.modRoof then
    SetVehicleMod(vehicle, 10, props.modRoof, false)
  end
  if props.modEngine then
    SetVehicleMod(vehicle, 11, props.modEngine, false)
  end
  if props.modBrakes then
    SetVehicleMod(vehicle, 12, props.modBrakes, false)
  end
  if props.modTransmission then
    SetVehicleMod(vehicle, 13, props.modTransmission, false)
  end
  if props.modHorns then
    SetVehicleMod(vehicle, 14, props.modHorns, false)
  end
  if props.modSuspension then
    SetVehicleMod(vehicle, 15, props.modSuspension, false)
  end
  if props.modArmor then
    SetVehicleMod(vehicle, 16, props.modArmor, false)
  end
  if props.modTurbo then
    ToggleVehicleMod(vehicle, 18, props.modTurbo)
  end
  if props.modXenon then
    ToggleVehicleMod(vehicle, 22, props.modXenon)
  end
  if props.modFrontWheels then
    SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
  end
  if props.modBackWheels then
    SetVehicleMod(vehicle, 24, props.modBackWheels, false)
  end
  if props.modPlateHolder then
    SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
  end
  if props.modVanityPlate then
    SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
  end
  if props.modTrimA then
    SetVehicleMod(vehicle, 27, props.modTrimA, false)
  end
  if props.modOrnaments then
    SetVehicleMod(vehicle, 28, props.modOrnaments, false)
  end
  if props.modDashboard then
    SetVehicleMod(vehicle, 29, props.modDashboard, false)
  end
  if props.modDial then
    SetVehicleMod(vehicle, 30, props.modDial, false)
  end
  if props.modDoorSpeaker then
    SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
  end
  if props.modSeats then
    SetVehicleMod(vehicle, 32, props.modSeats, false)
  end
  if props.modSteeringWheel then
    SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
  end
  if props.modShifterLeavers then
    SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
  end
  if props.modAPlate then
    SetVehicleMod(vehicle, 35, props.modAPlate, false)
  end
  if props.modSpeakers then
    SetVehicleMod(vehicle, 36, props.modSpeakers, false)
  end
  if props.modTrunk then
    SetVehicleMod(vehicle, 37, props.modTrunk, false)
  end
  if props.modHydrolic then
    SetVehicleMod(vehicle, 38, props.modHydrolic, false)
  end
  if props.modEngineBlock then
    SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
  end
  if props.modAirFilter then
    SetVehicleMod(vehicle, 40, props.modAirFilter, false)
  end
  if props.modStruts then
    SetVehicleMod(vehicle, 41, props.modStruts, false)
  end
  if props.modArchCover then
    SetVehicleMod(vehicle, 42, props.modArchCover, false)
  end
  if props.modAerials then
    SetVehicleMod(vehicle, 43, props.modAerials, false)
  end
  if props.modTrimB then
    SetVehicleMod(vehicle, 44, props.modTrimB, false)
  end
  if props.modTank then
    SetVehicleMod(vehicle, 45, props.modTank, false)
  end
  if props.modWindows then
    SetVehicleMod(vehicle, 46, props.modWindows, false)
  end
  if props.modLivery then
    SetVehicleMod(vehicle, 48, props.modLivery, false)
  end
  if props.livery then
    SetVehicleLivery(vehicle, props.livery)
  end

  if props.windowsBroken then
    for k, v in pairs(props.windowsBroken) do
      if v then
        SmashVehicleWindow(vehicle, tonumber(k) --[[@as integer]])
      end
    end
  end
  if props.doorsBroken then
    for k, v in pairs(props.doorsBroken) do
      if v then
        SetVehicleDoorBroken(vehicle, tonumber(k) --[[@as integer]], true)
      end
    end
  end
  if props.tyreBurst then
    for k, v in pairs(props.tyreBurst) do
      if v then
        SetVehicleTyreBurst(vehicle, tonumber(k) --[[@as integer]], true, 1000.0)
      end
    end
  end

  -- Vehicle Stats
  if props.bodyHealth then
    SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
  end
  if props.engineHealth then
    SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
  end
  if props.tankHealth then
    SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0)
  end
  if props.fuelLevel then
    SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
  end
  if props.dirtLevel then
    SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
  end
end
