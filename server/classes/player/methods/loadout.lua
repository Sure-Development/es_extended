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

---@param minimal boolean?
---@overload fun(minimal: true): table<string, { ammo: integer, tintIndex?: integer, components: table<integer, string> }>
---@overload fun(minimal: false | nil): DEX.Loadout[]
function ExtendedPlayer:getLoadout(minimal)
  if not minimal then
    return self.loadout
  end
  local minimalLoadout = {}

  for _, v in pairs(self.loadout) do
    minimalLoadout[v.name] = { ammo = v.ammo }
    if v.tintIndex > 0 then
      minimalLoadout[v.name].tintIndex = v.tintIndex
    end

    if #v.components > 0 then
      local components = {}

      for _, component in ipairs(v.components) do
        if component ~= 'clip_default' then
          components[#components + 1] = component
        end
      end

      if #components > 0 then
        minimalLoadout[v.name].components = components
      end
    end
  end

  return minimalLoadout
end

---@param name string
---@param ammo integer
---@overload fun(name: string, ammo: integer)
function ExtendedPlayer:addWeapon(name, ammo)
  if not self:hasWeapon(name) then
    local weaponLabel = ESX.GetWeaponLabel(name)

    self.loadout[name] = {
      name = name,
      ammo = ammo,
      label = weaponLabel,
      components = {},
      tintIndex = 0,
    }

    GiveWeaponToPed(GetPlayerPed(self.source), joaat(name), ammo, false, false)
    self:triggerEvent('esx:addInventoryItem', weaponLabel, false, true)
    self:triggerEvent('esx:addLoadoutItem', name, weaponLabel, ammo)
  end
end

---@param name string
---@param component string
---@overload fun(name: string, component: string)
function ExtendedPlayer:addWeaponComponent(name, component)
  local loadoutKey, weapon = self:getWeapon(name)

  if weapon then
    local _component = ESX.GetWeaponComponent(name, component)

    if _component then
      if not self:hasWeaponComponent(name, component) then
        self.loadout[loadoutKey].components[#self.loadout[loadoutKey].components + 1] = component
        local componentHash = ESX.GetWeaponComponent(name, component).hash

        GiveWeaponComponentToPed(GetPlayerPed(self.source), joaat(name), componentHash)
        self:triggerEvent('esx:addInventoryItem', _component.label, false, true)
      end
    end
  end
end

---@param name string
---@param count integer
---@overload fun(name: string, count: integer)
function ExtendedPlayer:addWeaponAmmo(name, count)
  local _, weapon = self:getWeapon(name)

  if weapon then
    weapon.ammo = weapon.ammo + count
    SetPedAmmo(GetPlayerPed(self.source), joaat(name), weapon.ammo)
  end
end

---@param name string
---@param count integer
---@overload fun(name: string, count: integer)
function ExtendedPlayer:updateWeaponAmmo(name, count)
  local _, weapon = self:getWeapon(name)

  if not weapon then
    return
  end

  weapon.ammo = count

  if weapon.ammo <= 0 then
    local _, weaponConfig = ESX.GetWeapon(name)
    if weaponConfig.throwable then
      self:removeWeapon(name)
    end
  end
end

---@param name string
---@param tintIndex integer
---@overload fun(name: string, tintIndex: integer)
function ExtendedPlayer:setWeaponTint(name, tintIndex)
  local loadoutKey, weapon = self:getWeapon(name)

  if weapon then
    local _, weaponObject = ESX.GetWeapon(name)

    if weaponObject.tints and weaponObject.tints[tintIndex] then
      self.loadout[loadoutKey].tintIndex = tintIndex
      self:triggerEvent('esx:setWeaponTint', name, tintIndex)
      self:triggerEvent('esx:addInventoryItem', weaponObject.tints[tintIndex], false, true)
    end
  end
end

---@param name string
---@overload fun(name: string)
function ExtendedPlayer:getWeaponTint(name)
  local _, weapon = self:getWeapon(name)

  if weapon then
    return weapon.tintIndex
  end

  return 0
end

---@param name string
---@overload fun(name: string)
function ExtendedPlayer:removeWeapon(name)
  local weaponLabel, playerPed = nil, GetPlayerPed(self.source)

  if not playerPed then
    return error('xPlayer.removeWeapon ^5invalid^1 player ped!')
  end

  if self.loadout[name] then
    weaponLabel = self.loadout[name].label
    for _, v2 in ipairs(self.loadout[name].components or {}) do
      self:removeWeaponComponent(name, v2)
    end

    local weaponHash = joaat(name)
    RemoveWeaponFromPed(playerPed, weaponHash)
    SetPedAmmo(playerPed, weaponHash, 0)

    self.loadout[name] = nil
  end

  if weaponLabel then
    self:triggerEvent('esx:removeInventoryItem', weaponLabel, false, true)
    self:triggerEvent('esx:removeLoadoutItem', name, weaponLabel)
  end
end

---@param name string
---@param component string
---@overload fun(name: string, component: string)
function ExtendedPlayer:removeWeaponComponent(name, component)
  local loadoutKey, weapon = self:getWeapon(name)

  if weapon then
    local _component = ESX.GetWeaponComponent(name, component)

    if _component then
      if self:hasWeaponComponent(name, component) then
        for k, v in ipairs(self.loadout[loadoutKey].components) do
          if v == component then
            table.remove(self.loadout[loadoutKey].components, k)
            break
          end
        end

        self:triggerEvent('esx:removeWeaponComponent', name, component)
        self:triggerEvent('esx:removeInventoryItem', _component.label, false, true)
      end
    end
  end
end

---@param name string
---@param count integer
---@overload fun(name: string, count: integer)
function ExtendedPlayer:removeWeaponAmmo(name, count)
  local _, weapon = self:getWeapon(name)

  if weapon then
    weapon.ammo = weapon.ammo - count
    SetPedAmmo(GetPlayerPed(self.source), joaat(name), weapon.ammo)
  end
end

---@param name string
---@param component string
---@overload fun(name: string, component: string): boolean
function ExtendedPlayer:hasWeaponComponent(name, component)
  local _, weapon = self:getWeapon(name)

  if weapon then
    for _, v in ipairs(weapon.components) do
      if v == component then
        return true
      end
    end

    return false
  end

  return false
end

---@param name string
---@overload fun(name: string): boolean
function ExtendedPlayer:hasWeapon(name)
  for _, v in ipairs(self.loadout) do
    if v.name == name then
      return true
    end
  end

  return false
end

---@param name string
---@overload fun(name: string): string | nil, DEX.Loadout | nil
function ExtendedPlayer:getWeapon(name)
  if self.loadout[name] then
    return name, self.loadout[name]
  end

  return nil, nil
end
