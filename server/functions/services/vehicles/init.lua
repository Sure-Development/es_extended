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

---@param model string | number
---@param player number
---@param cb function?
---@return string?
---@diagnostic disable-next-line: duplicate-set-field
function ESX.GetVehicleType(model, player, cb)
  if cb and not ESX.IsFunctionReference(cb) then
    error('Invalid callback function')
  end

  local promise = not cb and promise.new()
  local function resolve(result)
    if promise then
      promise:resolve(result)
    elseif cb then
      cb(result)
    end

    return result
  end

  model = type(model) == 'string' and joaat(model) or model

  if Core.vehicleTypesByModel[model] then
    return resolve(Core.vehicleTypesByModel[model])
  end

  local vehicleType = lib.callback.await('esx:getVehicleType', player, model)
  Core.vehicleTypesByModel[model] = vehicleType
  resolve(vehicleType)

  if promise then
    return Citizen.Await(promise)
  end
end
