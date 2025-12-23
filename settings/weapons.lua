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

---@class DEX.Config.Weapon
---@field name string ชื่ออาวุธ
---@field label string คำระบุอาวุธ
---@field components DEX.WeaponComponent[] กำหนด Component ของอาวุธ
---@type DEX.Config.Weapon[]

local weaponTints = require('settings.weapon-tints')

---@class Settings.Weapons
local WEAPONS = {}

local function loadWeaponConfig(name)
  return table.unpack(require('settings.weapons.' .. name)(weaponTints))
end

--- เพิ่มหมวดหมู่อาวุธที่ตรงนี้
---@type DEX.Config.Weapon[]
WEAPONS.list = {
  loadWeaponConfig('melee'),
  loadWeaponConfig('handguns'),
  loadWeaponConfig('shotguns'),
  loadWeaponConfig('smg-lmg'),
  loadWeaponConfig('rifples'),
  loadWeaponConfig('snipers'),
  loadWeaponConfig('heavy-launchers'),
  loadWeaponConfig('throwns'),
  loadWeaponConfig('tools'),
}

return WEAPONS
