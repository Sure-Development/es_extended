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

local TimeoutCount = 0
local CancelledTimeouts = {}

---@param msec number
---@param cb function
---@return number
ESX.SetTimeout = function(msec, cb)
  local id = TimeoutCount + 1

  SetTimeout(msec, function()
    if CancelledTimeouts[id] then
      CancelledTimeouts[id] = nil
      return
    end

    cb()
  end)

  TimeoutCount = id

  return id
end

---@param id number
---@return nil
ESX.ClearTimeout = function(id)
  CancelledTimeouts[id] = true
end
