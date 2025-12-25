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

---@param item string
---@param cb function
---@return nil
function ESX.RegisterUsableItem(item, cb)
  Core.UsableItemsCallbacks[item] = cb
end

---@param source number
---@param item string
---@param ... any
---@return nil
function ESX.UseItem(source, item, ...)
  if ESX.Items[item] then
    local itemCallback = Core.UsableItemsCallbacks[item]

    if itemCallback then
      local success, result = pcall(itemCallback, source, item, ...)

      if not success then
        return result and lib.print.info(result)
          or lib.print.warn(('[^3WARNING^7] An error occured when using item ^5 %s ^7! This was not caused by ESX.'):format(item))
      end
    end
  else
    lib.print.warn(('[^3WARNING^7] Item ^5 %s ^7 was used but does not exist!'):format(item))
  end
end

---@param item string
---@return string?
---@diagnostic disable-next-line: duplicate-set-field
function ESX.GetItemLabel(item)
  if ESX.Items[item] then
    return ESX.Items[item].label
  else
    lib.print.warn(('[^3WARNING^7] Attemting to get invalid Item -> ^5%s^7'):format(item))
  end
end

---@return table
function ESX.GetItems()
  return ESX.Items
end

---@return table
function ESX.GetUsableItems()
  local Usables = {}
  for k in pairs(Core.UsableItemsCallbacks) do
    Usables[k] = true
  end
  return Usables
end

local function refreshPlayerInventories()
  local xPlayers = ESX.GetExtendedPlayers()
  for i = 1, #xPlayers do
    local xPlayer = xPlayers[i] --[[@as DEX.Player]]
    local minimalInv = xPlayer:getInventory(true) --[[@as table<string, integer>]]

    for itemName, _ in pairs(minimalInv) do
      if not ESX.Items[itemName] then
        xPlayer:setInventoryItem(itemName, 0)
        minimalInv[itemName] = nil
      end
    end

    xPlayer.inventory = {}
    local itemIndex = 0
    for itemName, itemData in pairs(ESX.Items) do
      itemIndex += 1
      xPlayer.inventory[itemIndex] = {
        name = itemName,
        count = minimalInv[itemName] or 0,
        limit = itemData.limit,
        usable = Core.UsableItemsCallbacks[itemName] ~= nil,
        rare = itemData.rare,
        canRemove = itemData.canRemove,
        label = itemData.label,
      }
    end

    TriggerClientEvent('esx:setInventory', xPlayer.source, xPlayer.inventory)
  end
end

---@return number newItemCount
function ESX.RefreshItems()
  ESX.Items = {}

  local items = MySQL.query.await('SELECT * FROM items')
  local itemCount = #items
  for i = 1, itemCount do
    local item = items[i]
    ESX.Items[item.name] = {
      name = item.name,
      label = item.label,
      limit = item.limit,
      rare = item.rare,
      canRemove = item.can_remove,
    }
  end

  local previousItems = lib.loadJson('db.items')
  if not lib.table.matches(previousItems, ESX.Items) then
    SaveResourceFile(cache.resource, 'db/items.json', json.encode(ESX.Items), -1)

    CreateThread(function()
      while true do
        Wait(1000)
        lib.print.info('Base of server has detected that something changes in ESX.Items please restart server one time!')
      end
    end)
  end

  refreshPlayerInventories()

  return itemCount
end
