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

ESX.RegisterCommand(
  { 'setcoords', 'tp' },
  'admin',
  function(xPlayer, args)
    xPlayer:setCoords({ x = args.x, y = args.y, z = args.z })
  end,
  false,
  {
    help = TranslateCap('command_setcoords'),
    validate = true,
    arguments = {
      { name = 'x', help = TranslateCap('command_setcoords_x'), type = 'coordinate' },
      { name = 'y', help = TranslateCap('command_setcoords_y'), type = 'coordinate' },
      { name = 'z', help = TranslateCap('command_setcoords_z'), type = 'coordinate' },
    },
  }
)

ESX.RegisterCommand(
  'setjob',
  'admin',
  function(xPlayer, args, showError)
    if not ESX.DoesJobExist(args.job, args.grade) then
      return showError(TranslateCap('command_setjob_invalid'))
    end

    args.playerId:setJob(args.job, args.grade)
  end,
  true,
  {
    help = TranslateCap('command_setjob'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
      { name = 'job', help = TranslateCap('command_setjob_job'), type = 'string' },
      { name = 'grade', help = TranslateCap('command_setjob_grade'), type = 'number' },
    },
  }
)

local upgrades = {
  plate = 'ADMINCAR',
  modEngine = 3,
  modBrakes = 2,
  modTransmission = 2,
  modSuspension = 3,
  modArmor = true,
  windowTint = 1,
}

ESX.RegisterCommand(
  'car',
  'admin',
  function(xPlayer, args, showError)
    if not xPlayer then
      return showError('[^1ERROR^7] The xPlayer value is nil')
    end

    local playerPed = GetPlayerPed(xPlayer.source)
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)

    if not args.car or type(args.car) ~= 'string' then
      args.car = 'adder'
    end

    if playerVehicle then
      DeleteEntity(playerVehicle)
    end

    local xRoutingBucket = GetPlayerRoutingBucket(xPlayer.source)

    ESX.OneSync.SpawnVehicle(args.car, playerCoords, playerHeading, upgrades, function(networkId)
      if networkId then
        local vehicle = NetworkGetEntityFromNetworkId(networkId)

        if xRoutingBucket ~= 0 then
          SetEntityRoutingBucket(vehicle, xRoutingBucket)
        end

        for _ = 1, 100 do
          Wait(0)
          SetPedIntoVehicle(playerPed, vehicle, -1)

          if GetVehiclePedIsIn(playerPed, false) == vehicle then
            break
          end
        end

        if GetVehiclePedIsIn(playerPed, false) ~= vehicle then
          showError('[^1ERROR^7] The player could not be seated in the vehicle')
        end
      end
    end)
  end,
  false,
  {
    help = TranslateCap('command_car'),
    validate = false,
    arguments = {
      { name = 'car', validate = false, help = TranslateCap('command_car_car'), type = 'string' },
    },
  }
)

ESX.RegisterCommand(
  { 'cardel', 'dv' },
  'admin',
  function(xPlayer, args)
    local ped = GetPlayerPed(xPlayer.source)
    local pedVehicle = GetVehiclePedIsIn(ped, false)

    if DoesEntityExist(pedVehicle) then
      DeleteEntity(pedVehicle)
    end

    local coords = GetEntityCoords(ped)
    local Vehicles = ESX.OneSync.GetVehiclesInArea(coords, tonumber(args.radius) or 5.0)
    for i = 1, #Vehicles do
      local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
      if DoesEntityExist(Vehicle) then
        DeleteEntity(Vehicle)
      end
    end
  end,
  false,
  {
    help = TranslateCap('command_cardel'),
    validate = false,
    arguments = {
      { name = 'radius', validate = false, help = TranslateCap('command_cardel_radius'), type = 'number' },
    },
  }
)

ESX.RegisterCommand(
  { 'fix', 'repair' },
  'admin',
  function(xPlayer, args, showError)
    local xTarget = args.playerId
    local ped = GetPlayerPed(xTarget.source)
    local pedVehicle = GetVehiclePedIsIn(ped, false)
    if not pedVehicle or GetPedInVehicleSeat(pedVehicle, -1) ~= ped then
      showError(TranslateCap('not_in_vehicle'))
      return
    end
    xTarget.triggerEvent('esx:repairPedVehicle')
  end,
  true,
  {
    help = TranslateCap('command_repair'),
    validate = false,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
    },
  }
)

ESX.RegisterCommand(
  'setaccountmoney',
  'admin',
  function(xPlayer, args, showError)
    if not args.playerId:getAccount(args.account) then
      return showError(TranslateCap('command_giveaccountmoney_invalid'))
    end
    args.playerId:setAccountMoney(args.account, args.amount, 'Government Grant')
  end,
  true,
  {
    help = TranslateCap('command_setaccountmoney'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
      { name = 'account', help = TranslateCap('command_giveaccountmoney_account'), type = 'string' },
      { name = 'amount', help = TranslateCap('command_setaccountmoney_amount'), type = 'number' },
    },
  }
)

ESX.RegisterCommand(
  'giveaccountmoney',
  'admin',
  function(xPlayer, args, showError)
    if not args.playerId:getAccount(args.account) then
      return showError(TranslateCap('command_giveaccountmoney_invalid'))
    end
    args.playerId:addAccountMoney(args.account, args.amount, 'Government Grant')
  end,
  true,
  {
    help = TranslateCap('command_giveaccountmoney'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
      { name = 'account', help = TranslateCap('command_giveaccountmoney_account'), type = 'string' },
      { name = 'amount', help = TranslateCap('command_giveaccountmoney_amount'), type = 'number' },
    },
  }
)

ESX.RegisterCommand(
  'removeaccountmoney',
  'admin',
  function(xPlayer, args, showError)
    if not args.playerId:getAccount(args.account) then
      return showError(TranslateCap('command_removeaccountmoney_invalid'))
    end
    args.playerId:removeAccountMoney(args.account, args.amount, 'Government Tax')
  end,
  true,
  {
    help = TranslateCap('command_removeaccountmoney'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
      { name = 'account', help = TranslateCap('command_removeaccountmoney_account'), type = 'string' },
      { name = 'amount', help = TranslateCap('command_removeaccountmoney_amount'), type = 'number' },
    },
  }
)

ESX.RegisterCommand(
  'giveitem',
  'admin',
  function(xPlayer, args)
    args.playerId:addInventoryItem(args.item, args.count)
  end,
  true,
  {
    help = TranslateCap('command_giveitem'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
      { name = 'item', help = TranslateCap('command_giveitem_item'), type = 'item' },
      { name = 'count', help = TranslateCap('command_giveitem_count'), type = 'number' },
    },
  }
)

ESX.RegisterCommand(
  'giveweapon',
  'admin',
  function(xPlayer, args, showError)
    if args.playerId:hasWeapon(args.weapon) then
      return showError(TranslateCap('command_giveweapon_hasalready'))
    end
    args.playerId:addWeapon(args.weapon, args.ammo)
  end,
  true,
  {
    help = TranslateCap('command_giveweapon'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
      { name = 'weapon', help = TranslateCap('command_giveweapon_weapon'), type = 'weapon' },
      { name = 'ammo', help = TranslateCap('command_giveweapon_ammo'), type = 'number' },
    },
  }
)

ESX.RegisterCommand(
  'giveammo',
  'admin',
  function(xPlayer, args, showError)
    if not args.playerId:hasWeapon(args.weapon) then
      return showError(TranslateCap('command_giveammo_noweapon_found'))
    end
    args.playerId:addWeaponAmmo(args.weapon, args.ammo)
  end,
  true,
  {
    help = TranslateCap('command_giveweapon'),
    validate = false,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
      { name = 'weapon', help = TranslateCap('command_giveammo_weapon'), type = 'weapon' },
      { name = 'ammo', help = TranslateCap('command_giveammo_ammo'), type = 'number' },
    },
  }
)

ESX.RegisterCommand(
  'giveweaponcomponent',
  'admin',
  function(xPlayer, args, showError)
    if args.playerId:hasWeapon(args.weaponName) then
      local component = ESX.GetWeaponComponent(args.weaponName, args.componentName)

      if component then
        if args.playerId:hasWeaponComponent(args.weaponName, args.componentName) then
          showError(TranslateCap('command_giveweaponcomponent_hasalready'))
        else
          args.playerId:addWeaponComponent(args.weaponName, args.componentName)
        end
      else
        showError(TranslateCap('command_giveweaponcomponent_invalid'))
      end
    else
      showError(TranslateCap('command_giveweaponcomponent_missingweapon'))
    end
  end,
  true,
  {
    help = TranslateCap('command_giveweaponcomponent'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
      { name = 'weaponName', help = TranslateCap('command_giveweapon_weapon'), type = 'weapon' },
      { name = 'componentName', help = TranslateCap('command_giveweaponcomponent_component'), type = 'string' },
    },
  }
)

ESX.RegisterCommand({ 'clear', 'cls' }, 'user', function(xPlayer)
  xPlayer:triggerEvent('chat:clear')
end, false, { help = TranslateCap('command_clear') })

ESX.RegisterCommand({ 'clearall', 'clsall' }, 'admin', function(xPlayer)
  TriggerClientEvent('chat:clear', -1)
end, true, { help = TranslateCap('command_clearall') })

ESX.RegisterCommand('refreshjobs', 'admin', function()
  ESX.RefreshJobs()
end, true, { help = TranslateCap('command_clearall') })

ESX.RegisterCommand('refreshitems', 'admin', function(xPlayer)
  ESX.RefreshItems()
end, true, { help = TranslateCap('command_refreshitems') })

ESX.RegisterCommand(
  'clearinventory',
  'admin',
  function(xPlayer, args)
    for _, v in ipairs(args.playerId.inventory) do
      if v.count > 0 then
        args.playerId:setInventoryItem(v.name, 0)
      end
    end
    TriggerEvent('esx:playerInventoryCleared', args.playerId)
  end,
  true,
  {
    help = TranslateCap('command_clearinventory'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
    },
  }
)

ESX.RegisterCommand(
  'clearloadout',
  'admin',
  function(xPlayer, args)
    for i = #args.playerId.loadout, 1, -1 do
      args.playerId:removeWeapon(args.playerId.loadout[i].name)
    end
    TriggerEvent('esx:playerLoadoutCleared', args.playerId)
  end,
  true,
  {
    help = TranslateCap('command_clearloadout'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
    },
  }
)

ESX.RegisterCommand(
  'setgroup',
  'admin',
  function(xPlayer, args)
    if not args.playerId then
      args.playerId = xPlayer.source
    end
    if args.group == 'superadmin' then
      args.group = 'admin'
      lib.print.info('[^3WARNING^7] ^5Superadmin^7 detected, setting group to ^5admin^7')
    end
    args.playerId:setGroup(args.group)
  end,
  true,
  {
    help = TranslateCap('command_setgroup'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
      { name = 'group', help = TranslateCap('command_setgroup_group'), type = 'string' },
    },
  }
)

ESX.RegisterCommand(
  'save',
  'admin',
  function(_, args)
    Core.SavePlayer(args.playerId)
    lib.print.info(('[^2Info^0] Saved Player - ^5%s^0'):format(args.playerId.source))
  end,
  true,
  {
    help = TranslateCap('command_save'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
    },
  }
)

ESX.RegisterCommand('saveall', 'admin', function()
  Core.SavePlayers()
end, true, { help = TranslateCap('command_saveall') })

ESX.RegisterCommand('group', { 'user', 'admin' }, function(xPlayer, _, _)
  lib.print.info(('%s, you are currently: ^5%s^0'):format(xPlayer:getName(), xPlayer:getGroup()))
end, true)

ESX.RegisterCommand('job', { 'user', 'admin' }, function(xPlayer, _, _)
  local job = xPlayer:getJob()

  lib.print.info(
    ('%s, your job is: ^5%s^0 - ^5%s^0 - ^5%s^0'):format(xPlayer:getName(), job.name, job.grade_label, job.onDuty and 'On Duty' or 'Off Duty')
  )
end, false)

ESX.RegisterCommand('info', { 'user', 'admin' }, function(xPlayer)
  local job = xPlayer:getJob().name
  lib.print.info(
    ('^2ID: ^5%s^0 | ^2Name: ^5%s^0 | ^2Group: ^5%s^0 | ^2Job: ^5%s^0'):format(xPlayer.source, xPlayer:getName(), xPlayer:getGroup(), job)
  )
end, false)

ESX.RegisterCommand('coords', 'admin', function(xPlayer)
  local ped = GetPlayerPed(xPlayer.source)
  local coords = GetEntityCoords(ped, false)
  local heading = GetEntityHeading(ped)
  lib.print.info(('Coords - Vector3: ^5%s^0'):format(vector3(coords.x, coords.y, coords.z)))
  lib.print.info(('Coords - Vector4: ^5%s^0'):format(vector4(coords.x, coords.y, coords.z, heading)))
end, false)

ESX.RegisterCommand('tpm', 'admin', function(xPlayer)
  xPlayer:triggerEvent('esx:tpm')
end, false)

ESX.RegisterCommand(
  'goto',
  'admin',
  function(xPlayer, args)
    local targetCoords = args.playerId:getCoords()
    local srcDim = GetPlayerRoutingBucket(xPlayer.source)
    local targetDim = GetPlayerRoutingBucket(args.playerId.source)

    if srcDim ~= targetDim then
      SetPlayerRoutingBucket(xPlayer.source, targetDim)
    end
    xPlayer:setCoords(targetCoords)
  end,
  false,
  {
    help = TranslateCap('command_goto'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
    },
  }
)

ESX.RegisterCommand(
  'bring',
  'admin',
  function(xPlayer, args)
    local playerCoords = xPlayer:getCoords()
    local targetDim = GetPlayerRoutingBucket(args.playerId.source)
    local srcDim = GetPlayerRoutingBucket(xPlayer.source)

    if targetDim ~= srcDim then
      SetPlayerRoutingBucket(args.playerId.source, srcDim)
    end
    args.playerId:setCoords(playerCoords)
  end,
  false,
  {
    help = TranslateCap('command_bring'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
    },
  }
)

ESX.RegisterCommand(
  'kill',
  'admin',
  function(xPlayer, args)
    args.playerId:triggerEvent('esx:killPlayer')
  end,
  true,
  {
    help = TranslateCap('command_kill'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
    },
  }
)

ESX.RegisterCommand(
  'freeze',
  'admin',
  function(xPlayer, args)
    args.playerId:triggerEvent('esx:freezePlayer', 'freeze')
  end,
  true,
  {
    help = TranslateCap('command_freeze'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
    },
  }
)

ESX.RegisterCommand(
  'unfreeze',
  'admin',
  function(xPlayer, args)
    args.playerId:triggerEvent('esx:freezePlayer', 'unfreeze')
  end,
  true,
  {
    help = TranslateCap('command_unfreeze'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
    },
  }
)

ESX.RegisterCommand('noclip', 'admin', function(xPlayer)
  xPlayer:triggerEvent('esx:noclip')
end, false)

ESX.RegisterCommand('players', 'admin', function()
  local xPlayers = ESX.GetExtendedPlayers() -- Returns all xPlayers
  lib.print.info(('^5%s^2 online player(s)^0'):format(#xPlayers))
  for i = 1, #xPlayers do
    local xPlayer = xPlayers[i] --[[@as DEX.Player]]
    lib.print.info(
      ('^1[^2ID: ^5%s^0 | ^2Name : ^5%s^0 | ^2Group : ^5%s^0 | ^2Identifier : ^5%s^1]^0\n'):format(
        xPlayer.source,
        xPlayer:getName(),
        xPlayer:getGroup(),
        xPlayer.identifier
      )
    )
  end
end, true)

ESX.RegisterCommand(
  { 'setdim', 'setbucket' },
  'admin',
  function(xPlayer, args)
    SetPlayerRoutingBucket(args.playerId.source, args.dimension)
  end,
  true,
  {
    help = TranslateCap('command_setdim'),
    validate = true,
    arguments = {
      { name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
      { name = 'dimension', help = TranslateCap('commandgeneric_dimension'), type = 'number' },
    },
  }
)
