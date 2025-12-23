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

---@class Client.Module.Death
local M = {}

local _round = lib.math.round

M = {}
M._index = M

function M:ResetValues()
  self.killerEntity = nil
  self.deathCause = nil
  self.killerId = nil
  self.killerServerId = nil
end

function M:ByPlayer()
  local victimCoords = GetEntityCoords(cache.ped)
  local killerCoords = GetEntityCoords(self.killerEntity)
  local distance = #(victimCoords - killerCoords)

  local data = {
    victimCoords = { x = _round(victimCoords.x, 1), y = _round(victimCoords.y, 1), z = _round(victimCoords.z, 1) },
    killerCoords = { x = _round(killerCoords.x, 1), y = _round(killerCoords.y, 1), z = _round(killerCoords.z, 1) },

    killedByPlayer = true,
    deathCause = self.deathCause,
    distance = _round(distance, 1),

    killerServerId = self.killerServerId,
    killerClientId = self.killerId,
  }

  TriggerEvent('esx:onPlayerDeath', data)
  TriggerServerEvent('esx:onPlayerDeath', data)
end

function M:Natural()
  local coords = GetEntityCoords(cache.ped)

  local data = {
    victimCoords = { x = _round(coords.x, 1), y = _round(coords.y, 1), z = _round(coords.z, 1) },

    killedByPlayer = false,
    deathCause = self.deathCause,
  }

  TriggerEvent('esx:onPlayerDeath', data)
  TriggerServerEvent('esx:onPlayerDeath', data)
end

function M:Died()
  self.killerEntity = GetPedSourceOfDeath(cache.ped)
  self.deathCause = GetPedCauseOfDeath(cache.ped)
  self.killerId = NetworkGetPlayerIndexFromPed(self.killerEntity)
  self.killerServerId = GetPlayerServerId(self.killerId)

  local isActive = NetworkIsPlayerActive(self.killerId)

  if self.killerEntity ~= cache.ped and self.killerId and isActive then
    self:ByPlayer()
  else
    self:Natural()
  end

  self:ResetValues()
end

function M:Load()
  AddEventHandler('esx:onPlayerSpawn', function()
    LocalPlayer.state:set('isDead', false, true)

    Citizen.CreateThreadNow(function()
      while not ESX.PlayerLoaded do
        Wait(0)
      end

      while ESX.PlayerLoaded and not ESX.PlayerData.dead do
        if DoesEntityExist(cache.ped) and (IsPedDeadOrDying(cache.ped, true) or IsPedFatallyInjured(cache.ped)) then
          M:Died()
          break
        end
        Citizen.Wait(250)
      end
    end)
  end)

  AddEventHandler('esx:onPlayerDeath', function()
    LocalPlayer.state:set('isDead', true, true)
  end)
end

return M
