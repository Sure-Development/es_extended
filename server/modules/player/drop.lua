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

---@param source number
---@param reason string
---@param cb function?
return function(source, reason, cb)
  local p = not cb and promise:new()
  local function resolve()
    if cb then
      return cb()
    elseif p then
      return p:resolve()
    end
  end

  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then
    return resolve()
  end

  TriggerEvent('esx:playerDropped', source, reason)
  local job = xPlayer:getJob().name
  local currentJob = Core.JobsPlayerCount[job]
  Core.JobsPlayerCount[job] = ((currentJob and currentJob > 0) and currentJob or 1) - 1
  Core.IdsByJobs[job][source] = nil

  GlobalState[('%s:count'):format(job)] = Core.JobsPlayerCount[job]

  Core.SavePlayer(xPlayer, function()
    GlobalState['playerCount'] = GlobalState['playerCount'] - 1
    ESX.Players[source] = nil
    Core.PlayersByIdentifier[xPlayer.identifier] = nil

    resolve()
  end)

  if p then
    return Citizen.Await(p)
  end
end
