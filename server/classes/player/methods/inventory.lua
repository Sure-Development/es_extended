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

local public = require('settings.public')

local function debugInventoryLog(xPlayer, action, name, count)
  if not public.debug_inventory_loadout then
    return
  end

  lib.print.info(('[debug:inventory] source=%s action=%s item=%s count=%s'):format(xPlayer.source, action, name, count))
end

---@param minimal boolean?
---@overload fun(minimal: true): table<string, integer>
---@overload fun(minimal: false | nil): DEX.Item[]
function ExtendedPlayer:getInventory(minimal)
  if minimal then
    local minimalInventory = {}

    for _, v in pairs(self.inventory) do
      if v.count > 0 then
        minimalInventory[v.name] = v.count
      end
    end

    return minimalInventory
  end

  return self.inventory
end

---@param name string
---@return DEX.Item?
---@overload fun(name: string): DEX.Item?
function ExtendedPlayer:getInventoryItem(name)
  if self.inventory[name] then
    return self.inventory[name]
  end

  for _, v in ipairs(self.inventory) do
    if v.name == name then
      return v
    end
  end

  return nil
end

---@param name string
---@param count number
---@overload fun(name: string, count: integer)
function ExtendedPlayer:addInventoryItem(name, count)
  local item = self:getInventoryItem(name)

  if item then
    count = lib.math.round(count)
    item.count = item.count + count
    debugInventoryLog(self, 'add', item.name, item.count)

    TriggerEvent('esx:onAddInventoryItem', self.source, item.name, item.count)
    self:triggerEvent('esx:addInventoryItem', item.name, item.count)
  end
end

---@param name string
---@param count number
---@overload fun(name: string, count: integer)
function ExtendedPlayer:removeInventoryItem(name, count)
  local item = self:getInventoryItem(name)

  if item then
    count = lib.math.round(count)
    if count > 0 then
      local newCount = item.count - count

      if newCount >= 0 then
        item.count = newCount
        debugInventoryLog(self, 'remove', item.name, item.count)

        TriggerEvent('esx:onRemoveInventoryItem', self.source, item.name, item.count)
        self:triggerEvent('esx:removeInventoryItem', item.name, item.count)
      end
    else
      error(('Player ID:^5%s Tried remove a Invalid count -> %s of %s'):format(self.playerId, count, name))
    end
  end
end

---@param name string
---@param count number
---@overload fun(name: string, count: integer)
function ExtendedPlayer:setInventoryItem(name, count)
  local item = self:getInventoryItem(name)

  if item and count >= 0 then
    count = lib.math.round(count)
    debugInventoryLog(self, 'set', item.name, count)

    if count > item.count then
      self:addInventoryItem(item.name, count - item.count)
    else
      self:removeInventoryItem(item.name, item.count - count)
    end
  end
end

---@param name string
---@param count number
---@return boolean
---@overload fun(name: string, count: integer): boolean
function ExtendedPlayer:canCarryItem(name, count)
  if ESX.Items[name] then
    local itemData = self:getInventoryItem(name)

    if itemData and (itemData.count + count <= itemData.limit or itemData.limit == -1) then
      return true
    end
  else
    lib.print.warn(('[^3WARNING^7] Item ^5"%s"^7 was used but does not exist!'):format(name))
    return false
  end

  return false
end

---@param name string
---@return DEX.Item | false, number?
---@overload fun(name: string): DEX.Item | false, number?
function ExtendedPlayer:hasItem(name)
  for _, v in ipairs(self.inventory) do
    if v.name == name and v.count >= 1 then
      return v, v.count
    end
  end

  return false
end
