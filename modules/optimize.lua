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

--- MARK: Not sure source of it will works

local optimize = require('settings.addons.optimize')
local isClient = not IsDuplicityVersion()

if isClient then
  AddEventHandler('populationPedCreating', function(x, y, z, model, setters)
    setters.setPosition(x, y, z - 999.5)
  end)

  if optimize.syncs.no_peds_sync then
    CreateThread(function()
      while true do
        Wait(2000)

        for _, ped in ipairs(GetGamePool('CPed')) do
          if not IsPedAPlayer(ped) then
            if NetworkGetEntityIsNetworked(ped) then
              NetworkUnregisterNetworkedEntity(ped)
              SetEntityAsMissionEntity(ped, false, false)
            end
          end
        end
      end
    end)
  end

  if optimize.syncs.no_objects_sync then
    CreateThread(function()
      while true do
        Wait(3000)

        for _, obj in ipairs(GetGamePool('CObject')) do
          if NetworkGetEntityIsNetworked(obj) then
            NetworkUnregisterNetworkedEntity(obj)
            if not IsEntityPositionFrozen(obj) then
              FreezeEntityPosition(obj, true)
            end
          end
        end
      end
    end)
  end

  if optimize.syncs.no_particles_sync then
    CreateThread(function()
      while true do
        Wait(5000)

        for _, ped in ipairs(GetGamePool('CPed')) do
          RemoveParticleFxFromEntity(ped)
        end
      end
    end)
  end
else
  AddEventHandler('entityCreating', function(entity)
    local entType = GetEntityType(entity)
    local cancelled = false

    if entType == 1 or entType == 3 then
      local owner = NetworkGetEntityOwner(entity)

      if not owner or (optimize.syncs.no_peds_sync or optimize.syncs.no_objects_sync) then
        cancelled = true
      end
    end

    if cancelled then
      CancelEvent()
    end
  end)
end

lib.print.info('Loaded [^2MODULE^7] ^3optimize')
