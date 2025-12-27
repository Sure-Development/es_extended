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

---@return boolean
---@diagnostic disable-next-line: duplicate-set-field
function ESX.IsPlayerLoaded()
  return ESX.PlayerLoaded
end

---@return table
function ESX.GetPlayerData()
  return ESX.PlayerData
end

function ESX.WaitForPlayerLoaded(cb)
  local thread = function(_cb)
    _cb()
  end
  if cb then
    thread = CreateThread
  end

  thread(function()
    while not ESX.IsPlayerLoaded() do
      Wait(50)
    end

    cb()
  end)
end

---@diagnostic disable-next-line: duplicate-set-field
function ESX.GetItemLabel(item)
  return (ESX.SearchInventory(item) or { label = nil }).label
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

---@param account string Account name (money/bank/black_money)
---@return table|nil
function ESX.GetAccount(account)
  if ESX.PlayerData.accounts[account] then
    return ESX.PlayerData.accounts[account]
  end

  return nil
end
