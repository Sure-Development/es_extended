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

---@param name string
---@param cb fun(source: integer, cb: fun(...), ...)
function ESX.RegisterServerCallback(name, cb)
  lib.callback.register(name, function(source, ...)
    local args = { ... }
    local result
    local p = promise.new()

    cb(source, function(...)
      result = { ... }
      p:resolve()
    end, table.unpack(args))

    return table.unpack(result)
  end)
end
