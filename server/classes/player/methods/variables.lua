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

---@overload fun(): boolean
function ExtendedPlayer:isAdmin()
  return Core.IsPlayerAdmin(self.source)
end

---@return string
---@overload fun(): string
function ExtendedPlayer:getIdentifier()
  return self.identifier
end

---@param newGroup string
---@overload fun(newGroup: string)
function ExtendedPlayer:setGroup(newGroup)
  local lastGroup = self.group

  self.group = newGroup

  TriggerEvent('esx:setGroup', self.source, self.group, lastGroup)
  self:triggerEvent('esx:setGroup', self.group, lastGroup)

  Player(self.source).state:set('group', self.group, true)

  ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.license, self.group))
  ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.license, self.group))
end

---@return string
---@overload fun(): string
function ExtendedPlayer:getGroup()
  return self.group
end

---@return string
---@overload fun(): string
function ExtendedPlayer:getName()
  return self.name
end

---@param newName string
---@overload fun(newName: string)
function ExtendedPlayer:setName(newName)
  self.name = newName
  Player(self.source).state:set('name', newName)
end

---@return integer
---@overload fun(): integer
function ExtendedPlayer:getSource()
  return self.source
end

---@return integer
---@overload fun(): integer
function ExtendedPlayer:getPlayerId()
  return self.source
end

---@param key string
---@param value any
---@overload fun(key: string, value: any)
function ExtendedPlayer:set(key, value)
  self.variables[key] = value

  self:triggerEvent('esx:updatePlayerData', 'variables', self.variables)
  Player(self.source).state:set(key, value, true)
end

---@param k string
---@return any
---@overload fun(k: string): any
function ExtendedPlayer:get(k)
  return self.variables[k]
end
