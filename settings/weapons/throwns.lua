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
      name = 'WEAPON_BALL',
      label = TranslateCap('weapon_ball'),
      components = {},
      ammo = { label = TranslateCap('ammo_ball'), hash = `AMMO_BALL` },
      throwable = true,
    },
    {
      name = 'WEAPON_BZGAS',
      label = TranslateCap('weapon_bzgas'),
      components = {},
      ammo = { label = TranslateCap('ammo_bzgas'), hash = `AMMO_BZGAS` },
      throwable = true,
    },
    {
      name = 'WEAPON_FLARE',
      label = TranslateCap('weapon_flare'),
      components = {},
      ammo = { label = TranslateCap('ammo_flare'), hash = `AMMO_FLARE` },
      throwable = true,
    },
    {
      name = 'WEAPON_GRENADE',
      label = TranslateCap('weapon_grenade'),
      components = {},
      ammo = { label = TranslateCap('ammo_grenade'), hash = `AMMO_GRENADE` },
      throwable = true,
    },
    {
      name = 'WEAPON_PETROLCAN',
      label = TranslateCap('weapon_petrolcan'),
      components = {},
      ammo = { label = TranslateCap('ammo_petrol'), hash = `AMMO_PETROLCAN` },
      throwable = true,
    },
    {
      name = 'WEAPON_HAZARDCAN',
      label = TranslateCap('weapon_hazardcan'),
      components = {},
      ammo = { label = TranslateCap('ammo_petrol'), hash = `AMMO_PETROLCAN` },
      throwable = true,
    },
    {
      name = 'WEAPON_MOLOTOV',
      label = TranslateCap('weapon_molotov'),
      components = {},
      ammo = { label = TranslateCap('ammo_molotov'), hash = `AMMO_MOLOTOV` },
      throwable = true,
    },
    {
      name = 'WEAPON_PROXMINE',
      label = TranslateCap('weapon_proxmine'),
      components = {},
      ammo = { label = TranslateCap('ammo_proxmine'), hash = `AMMO_PROXMINE` },
      throwable = true,
    },
    {
      name = 'WEAPON_PIPEBOMB',
      label = TranslateCap('weapon_pipebomb'),
      components = {},
      ammo = { label = TranslateCap('ammo_pipebomb'), hash = `AMMO_PIPEBOMB` },
      throwable = true,
    },
    {
      name = 'WEAPON_SNOWBALL',
      label = TranslateCap('weapon_snowball'),
      components = {},
      ammo = { label = TranslateCap('ammo_snowball'), hash = `AMMO_SNOWBALL` },
      throwable = true,
    },
    {
      name = 'WEAPON_STICKYBOMB',
      label = TranslateCap('weapon_stickybomb'),
      components = {},
      ammo = { label = TranslateCap('ammo_stickybomb'), hash = `AMMO_STICKYBOMB` },
      throwable = true,
    },
    {
      name = 'WEAPON_SMOKEGRENADE',
      label = TranslateCap('weapon_smokegrenade'),
      components = {},
      ammo = { label = TranslateCap('ammo_smokebomb'), hash = `AMMO_SMOKEGRENADE` },
      throwable = true,
    },
  }
end
