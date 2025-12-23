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

---@param weaponTints Settings.WeaponTints
---@return DEX.Config.Weapon[]
return function(weaponTints)
  return {
    {
      name = 'WEAPON_COMPACTLAUNCHER',
      label = TranslateCap('weapon_compactlauncher'),
      tints = weaponTints.default_weapon_tints,
      components = {},
      ammo = { label = TranslateCap('ammo_grenadelauncher'), hash = `AMMO_GRENADELAUNCHER` },
    },
    {
      name = 'WEAPON_FIREWORK',
      label = TranslateCap('weapon_firework'),
      components = {},
      ammo = { label = TranslateCap('ammo_firework'), hash = `AMMO_FIREWORK` },
    },
    {
      name = 'WEAPON_GRENADELAUNCHER',
      label = TranslateCap('weapon_grenadelauncher'),
      tints = weaponTints.default_weapon_tints,
      components = {},
      ammo = { label = TranslateCap('ammo_grenadelauncher'), hash = `AMMO_GRENADELAUNCHER` },
    },
    {
      name = 'WEAPON_HOMINGLAUNCHER',
      label = TranslateCap('weapon_hominglauncher'),
      tints = weaponTints.default_weapon_tints,
      components = {},
      ammo = { label = TranslateCap('ammo_rockets'), hash = `AMMO_HOMINGLAUNCHER` },
    },
    {
      name = 'WEAPON_MINIGUN',
      label = TranslateCap('weapon_minigun'),
      tints = weaponTints.default_weapon_tints,
      components = {},
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_MINIGUN` },
    },
    {
      name = 'WEAPON_RAILGUN',
      label = TranslateCap('weapon_railgun'),
      tints = weaponTints.default_weapon_tints,
      components = {},
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_RAILGUN` },
    },
    {
      name = 'WEAPON_RPG',
      label = TranslateCap('weapon_rpg'),
      tints = weaponTints.default_weapon_tints,
      components = {},
      ammo = { label = TranslateCap('ammo_rockets'), hash = `AMMO_RPG` },
    },
    {
      name = 'WEAPON_RAYMINIGUN',
      label = TranslateCap('weapon_rayminigun'),
      tints = weaponTints.default_weapon_tints,
      components = {},
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_MINIGUN` },
    },
  }
end
