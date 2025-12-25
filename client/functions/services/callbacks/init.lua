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
