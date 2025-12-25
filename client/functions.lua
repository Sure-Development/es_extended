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

function ESX.TriggerServerCallback(name, cb, ...)
  local result = lib.callback.await(name, false, ...)

  if type(result) ~= 'table' then
    result = { result }
  end

  cb(table.unpack(result))
end

---@return boolean
---@diagnostic disable-next-line: duplicate-set-field
function ESX.IsPlayerLoaded()
  return ESX.PlayerLoaded
end

---@return table
function ESX.GetPlayerData()
  return ESX.PlayerData
end

function ESX.WaitForPlayerLoaded()
  while not ESX.IsPlayerLoaded() do
    Wait(50)
  end
end

---@diagnostic disable-next-line: duplicate-set-field
function ESX.GetItemLabel(item)
  return (ESX.SearchInventory(item) or { label = nil }).label
end

function ESX.DisableSpawnManager()
  if GetResourceState('spawnmanager') == 'started' then
    exports.spawnmanager:setAutoSpawn(false)
  end
end

---@param items string | table The item(s) to search for
---@param count? boolean Whether to return the count of the item as well
---@return table<string, number | DEX.Item> | number?
function ESX.SearchInventory(items, count)
  local inventory = ESX.PlayerData.inventory
  local isString = type(items) == 'string'
  local searchItems = isString and { items } or items
  local results = {}

  local function findItem(itemName)
    if inventory[itemName] then
      return inventory[itemName]
    end

    for i = 1, #inventory do
      local item = inventory[i]
      if item and item.name == itemName then
        return item
      end
    end

    return nil
  end

  for i = 1, #searchItems do
    local name = searchItems[i]
    local itemData = findItem(name)

    if isString then
      return count and (itemData and itemData.count or 0) or itemData
    end

    results[name] = count and (itemData and itemData.count or 0) or itemData
  end

  return results
end

---@param key string Table key to set
---@param val any Value to set
---@return nil
function ESX.SetPlayerData(key, val)
  local current = ESX.PlayerData[key]
  ESX.PlayerData[key] = val
  if key ~= 'loadout' then
    if type(val) == 'table' or val ~= current then
      TriggerEvent('esx:setPlayerData', key, val, current)
    end
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

---@param message string The message to show
---@param notifyType? string The type of notification to show
---@param length? number The length of the notification
---@param title? string The title of the notification
---@return nil
function ESX.ShowNotification(message, notifyType, length, title)
  TriggerEvent('hud:notification', notifyType, message, length)
end

---@param sender string
---@param subject string
---@param msg string
---@param textureDict string
---@param iconType integer
---@param flash boolean
---@param saveToBrief? boolean
---@param hudColorIndex? integer
---@return nil
function ESX.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
  AddTextEntry('esxAdvancedNotification', msg)
  BeginTextCommandThefeedPost('esxAdvancedNotification')
  if hudColorIndex then
    ThefeedSetNextPostBackgroundColor(hudColorIndex)
  end
  EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
  EndTextCommandThefeedPostTicker(flash, saveToBrief == nil or saveToBrief)
end

---@param msg string The message to show
---@param thisFrame? boolean Whether to show the message this frame
---@param beep? boolean Whether to beep
---@param duration? number The duration of the message
---@return nil
function ESX.ShowHelpNotification(msg, thisFrame, beep, duration)
  AddTextEntry('esxHelpNotification', msg)
  if thisFrame then
    DisplayHelpTextThisFrame('esxHelpNotification', false)
  else
    BeginTextCommandDisplayHelp('esxHelpNotification')
    EndTextCommandDisplayHelp(0, false, beep == nil or beep, duration or -1)
  end
end

---@param msg string The message to show
---@param coords table The coords to show the message at
---@return nil
function ESX.ShowFloatingHelpNotification(msg, coords)
  AddTextEntry('esxFloatingHelpNotification', msg)
  SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z)
  SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
  BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
  EndTextCommandDisplayHelp(2, false, false, -1)
end

---@param msg string The message to show
---@param time number The duration of the message
---@return nil
function ESX.DrawMissionText(msg, time)
  ClearPrints()
  BeginTextCommandPrint('STRING')
  AddTextComponentSubstringPlayerName(msg)
  EndTextCommandPrint(time, true)
end

---@param str string The string to hash
---@return string The hashed string
function ESX.HashString(str)
  return ('~INPUT_%s~'):format(('%x'):format(joaat(str) & 0x7fffffff + 2 ^ 31):upper())
end

---@param command_name string The command name
---@param label string The label to show
---@param input_group string The input group
---@param key string The key to bind
---@param on_press function The function to call on press
---@param on_release? function The function to call on release
function ESX.RegisterInput(command_name, label, input_group, key, on_press, on_release)
  local command = on_release and '+' .. command_name or command_name
  RegisterCommand(command, on_press, false)
  Core.Input[command_name] = ESX.HashString(command)
  if on_release then
    RegisterCommand('-' .. command_name, on_release, false)
  end
  RegisterKeyMapping(command, label or '', input_group or 'keyboard', key or '')
end

---@param menuType string
---@param open function The function to call on open
---@param close function The function to call on close
function ESX.UI.Menu.RegisterType(menuType, open, close)
  ESX.UI.Menu.RegisteredTypes[menuType] = {
    open = open,
    close = close,
  }
end

---@class ESXMenu
---@field type string
---@field namespace string
---@field resourceName string
---@field name string
---@field data table
---@field submit? function
---@field cancel? function
---@field change? function
---@field close function
---@field update function
---@field refresh function
---@field setElement function
---@field setElements function
---@field setTitle function
---@field removeElement function

---@param menuType string
---@param namespace string
---@param name string
---@param data table
---@param submit? function
---@param cancel? function
---@param change? function
---@param close? function
---@return ESXMenu
function ESX.UI.Menu.Open(menuType, namespace, name, data, submit, cancel, change, close)
  ---@class ESXMenu
  local menu = {}

  menu.type = menuType
  menu.namespace = namespace
  menu.resourceName = (GetInvokingResource() or 'Unknown')
  menu.name = name
  menu.data = data
  menu.submit = submit
  menu.cancel = cancel
  menu.change = change

  menu.close = function()
    ESX.UI.Menu.RegisteredTypes[menuType].close(namespace, name)

    for i = 1, #ESX.UI.Menu.Opened, 1 do
      if ESX.UI.Menu.Opened[i] then
        if ESX.UI.Menu.Opened[i].type == menuType and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
          ESX.UI.Menu.Opened[i] = nil
        end
      end
    end

    if close then
      close()
    end
  end

  menu.update = function(query, newData)
    for i = 1, #menu.data.elements, 1 do
      local match = true

      for k, v in pairs(query) do
        if menu.data.elements[i][k] ~= v then
          match = false
        end
      end

      if match then
        for k, v in pairs(newData) do
          menu.data.elements[i][k] = v
        end
      end
    end
  end

  menu.refresh = function()
    ESX.UI.Menu.RegisteredTypes[menuType].open(namespace, name, menu.data)
  end

  menu.setElement = function(i, key, val)
    menu.data.elements[i][key] = val
  end

  menu.setElements = function(newElements)
    menu.data.elements = newElements
  end

  menu.setTitle = function(val)
    menu.data.title = val
  end

  menu.removeElement = function(query)
    for i = 1, #menu.data.elements, 1 do
      for k, v in pairs(query) do
        if menu.data.elements[i] then
          if menu.data.elements[i][k] == v then
            table.remove(menu.data.elements, i)
            break
          end
        end
      end
    end
  end

  ESX.UI.Menu.Opened[#ESX.UI.Menu.Opened + 1] = menu
  ESX.UI.Menu.RegisteredTypes[menuType].open(namespace, name, data)

  return menu
end

---@param menuType string
---@param namespace string
---@param name string
---@param cancel? boolean Should the close be classified as a cancel
---@return nil
function ESX.UI.Menu.Close(menuType, namespace, name, cancel)
  for i = 1, #ESX.UI.Menu.Opened, 1 do
    if ESX.UI.Menu.Opened[i] then
      if ESX.UI.Menu.Opened[i].type == menuType and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
        if not cancel then
          ESX.UI.Menu.Opened[i].close()
        else
          local menu = ESX.UI.Menu.Opened[i]
          ESX.UI.Menu.RegisteredTypes[menu.type].close(menu.namespace, menu.name)

          if type(menu.cancel) ~= 'nil' then
            menu.cancel(menu.data, menu)
          end
        end
        ESX.UI.Menu.Opened[i] = nil
      end
    end
  end
end

---@param cancel? boolean Should the close be classified as a cancel
---@return nil
function ESX.UI.Menu.CloseAll(cancel)
  for i = 1, #ESX.UI.Menu.Opened, 1 do
    if ESX.UI.Menu.Opened[i] then
      if not cancel then
        ESX.UI.Menu.Opened[i].close()
      else
        local menu = ESX.UI.Menu.Opened[i]
        ESX.UI.Menu.RegisteredTypes[menu.type].close(menu.namespace, menu.name)

        if type(menu.cancel) ~= 'nil' then
          menu.cancel(menu.data, menu)
        end
      end
      ESX.UI.Menu.Opened[i] = nil
    end
  end
end

---@param menuType string
---@param namespace string
---@param name string
---@return ESXMenu | nil
function ESX.UI.Menu.GetOpened(menuType, namespace, name)
  for i = 1, #ESX.UI.Menu.Opened, 1 do
    if ESX.UI.Menu.Opened[i] then
      if ESX.UI.Menu.Opened[i].type == menuType and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
        return ESX.UI.Menu.Opened[i]
      end
    end
  end
end

---@return ESXMenu[]
function ESX.UI.Menu.GetOpenedMenus()
  return ESX.UI.Menu.Opened
end

ESX.UI.Menu.IsOpen = ESX.UI.Menu.GetOpened

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

---@param vehicle integer The vehicle to delete
---@return nil
function ESX.Game.DeleteVehicle(vehicle)
  SetEntityAsMissionEntity(vehicle, true, true)
  DeleteVehicle(vehicle)
end

---@param object integer The object to delete
---@return nil
function ESX.Game.DeleteObject(object)
  SetEntityAsMissionEntity(object, false, true)
  DeleteObject(object)
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
function ESX.Game.GetObjects() -- Leave the function for compatibility
  return GetGamePool('CObject')
end

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

---@return table
function ESX.Game.GetVehicles() -- Leave the function for compatibility
  return GetGamePool('CVehicle')
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

---@param coords? table | vector3 The coords to get the closest object to
---@param modelFilter? table The model filter
---@return integer, integer
function ESX.Game.GetClosestObject(coords, modelFilter)
  return ESX.Game.GetClosestEntity(ESX.Game.GetObjects(), false, coords, modelFilter)
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

---@param coords? table | vector3 The coords to get the closest vehicle to
---@param modelFilter? table The model filter
---@return integer, integer
function ESX.Game.GetClosestVehicle(coords, modelFilter)
  return ESX.Game.GetClosestEntity(ESX.Game.GetVehicles(), false, coords, modelFilter)
end

---@param entities table The entities to search through
---@param isPlayerEntities boolean Whether the entities are players
---@param coords table | vector3 The coords to search from
---@param maxDistance number The max distance to search within
---@return table
local function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
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

---@param coords table | vector3 The coords to search from
---@param maxDistance number The max distance to search within
---@return table
function ESX.Game.GetPlayersInArea(coords, maxDistance)
  return EnumerateEntitiesWithinDistance(ESX.Game.GetPlayers(true, true), true, coords, maxDistance)
end

---@param coords table | vector3 The coords to search from
---@param maxDistance number The max distance to search within
---@return table
function ESX.Game.GetVehiclesInArea(coords, maxDistance)
  return EnumerateEntitiesWithinDistance(ESX.Game.GetVehicles(), false, coords, maxDistance)
end

---@param coords table | vector3 The coords to search from
---@param maxDistance number The max distance to search within
---@return boolean
function ESX.Game.IsSpawnPointClear(coords, maxDistance)
  return #ESX.Game.GetVehiclesInArea(coords, maxDistance) == 0
end

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

---@param account string Account name (money/bank/black_money)
---@return table|nil
function ESX.GetAccount(account)
  if ESX.PlayerData.accounts[account] then
    return ESX.PlayerData.accounts[account]
  end

  return nil
end

RegisterNetEvent('esx:showNotification', ESX.ShowNotification)

RegisterNetEvent('esx:showAdvancedNotification', ESX.ShowAdvancedNotification)

RegisterNetEvent('esx:showHelpNotification', ESX.ShowHelpNotification)

AddEventHandler('onResourceStop', function(resourceName)
  for i = 1, #ESX.UI.Menu.Opened, 1 do
    if ESX.UI.Menu.Opened[i] then
      if ESX.UI.Menu.Opened[i].resourceName == resourceName or ESX.UI.Menu.Opened[i].namespace == resourceName then
        ESX.UI.Menu.Opened[i].close()
        ESX.UI.Menu.Opened[i] = nil
      end
    end
  end
end)
-- Credits to txAdmin for the list.
local mismatchedTypes = {
  [`airtug`] = 'automobile', -- trailer
  [`avisa`] = 'submarine', -- boat
  [`blimp`] = 'heli', -- plane
  [`blimp2`] = 'heli', -- plane
  [`blimp3`] = 'heli', -- plane
  [`caddy`] = 'automobile', -- trailer
  [`caddy2`] = 'automobile', -- trailer
  [`caddy3`] = 'automobile', -- trailer
  [`chimera`] = 'automobile', -- bike
  [`docktug`] = 'automobile', -- trailer
  [`forklift`] = 'automobile', -- trailer
  [`kosatka`] = 'submarine', -- boat
  [`mower`] = 'automobile', -- trailer
  [`policeb`] = 'bike', -- automobile
  [`ripley`] = 'automobile', -- trailer
  [`rrocket`] = 'automobile', -- bike
  [`sadler`] = 'automobile', -- trailer
  [`sadler2`] = 'automobile', -- trailer
  [`scrap`] = 'automobile', -- trailer
  [`slamtruck`] = 'automobile', -- trailer
  [`Stryder`] = 'automobile', -- bike
  [`submersible`] = 'submarine', -- boat
  [`submersible2`] = 'submarine', -- boat
  [`thruster`] = 'heli', -- automobile
  [`towtruck`] = 'automobile', -- trailer
  [`towtruck2`] = 'automobile', -- trailer
  [`tractor`] = 'automobile', -- trailer
  [`tractor2`] = 'automobile', -- trailer
  [`tractor3`] = 'automobile', -- trailer
  [`trailersmall2`] = 'trailer', -- automobile
  [`utillitruck`] = 'automobile', -- trailer
  [`utillitruck2`] = 'automobile', -- trailer
  [`utillitruck3`] = 'automobile', -- trailer
}

---@param model number|string
---@return string | boolean
function ESX.GetVehicleTypeClient(model)
  model = type(model) == 'string' and joaat(model) or model
  if not IsModelInCdimage(model) then
    return false
  end

  if not IsModelAVehicle(model) then
    return false
  end

  if mismatchedTypes[model] then
    return mismatchedTypes[model]
  end

  local vehicleType = GetVehicleClassFromName(model)
  local types = {
    [8] = 'bike',
    [11] = 'trailer',
    [13] = 'bike',
    [14] = 'boat',
    [15] = 'heli',
    [16] = 'plane',
    [21] = 'train',
  }

  return types[vehicleType] or 'automobile'
end

ESX.GetVehicleType = ESX.GetVehicleTypeClient
