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
      name = 'WEAPON_FIREEXTINGUISHER',
      label = TranslateCap('weapon_fireextinguisher'),
      components = {},
      ammo = { label = TranslateCap('ammo_charge'), hash = `AMMO_FIREEXTINGUISHER` },
    },
    { name = 'WEAPON_DIGISCANNER', label = TranslateCap('weapon_digiscanner'), components = {} },
    { name = 'GADGET_PARACHUTE', label = TranslateCap('gadget_parachute'), components = {}, throwable = true },
    {
      name = 'WEAPON_TACTICALRIFLE',
      label = TranslateCap('weapon_tactilerifle'),
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_RIFLE` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'clip_default', label = TranslateCap('component_clip_default'), hash = `COMPONENT_TACTICALRIFLE_CLIP_01` },
        { name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = `COMPONENT_TACTICALRIFLE_CLIP_02` },
        { name = 'flashlight', label = TranslateCap('component_flashlight'), hash = `COMPONENT_AT_AR_FLSH_REH` },
        { name = 'grip', label = TranslateCap('component_grip'), hash = `COMPONENT_AT_AR_AFGRIP` },
        { name = 'suppressor', label = TranslateCap('component_suppressor'), hash = `COMPONENT_AT_AR_SUPP_02` },
      },
    },
    {
      name = 'WEAPON_BATTLERIFLE',
      label = TranslateCap('weapon_battlerifle'),
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_RIFLE` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'clip_default', label = TranslateCap('component_clip_default'), hash = `COMPONENT_BATTLERIFLE_CLIP_01` },
        { name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = `COMPONENT_BATTLERIFLE_CLIP_02` },
        { name = 'suppressor', label = TranslateCap('component_suppressor'), hash = `COMPONENT_AT_AR_SUPP` },
      },
    },
    {
      name = 'WEAPON_SNOWLAUNCHER',
      label = TranslateCap('weapon_snowlauncher'),
      ammo = { label = TranslateCap('ammo_snowball'), hash = `AMMO_SNOWLAUNCHER` },
      tints = weaponTints.default_weapon_tints,
      components = {},
    },
    {
      name = 'WEAPON_HACKINGDEVICE',
      label = TranslateCap('weapon_hackingdevice'),
      tints = weaponTints.default_weapon_tints,
      components = {},
    },
    {
      name = 'WEAPON_PRECISIONRIFLE',
      label = TranslateCap('weapon_precisionrifle'),
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_SNIPER` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'clip_default', label = TranslateCap('component_clip_default'), hash = `COMPONENT_PRECISIONRIFLE_CLIP_01` },
      },
    },
    { name = 'WEAPON_METALDETECTOR', label = TranslateCap('weapon_metaldetector'), components = {} },
    {
      name = 'WEAPON_PISTOLXM3',
      label = TranslateCap('weapon_pistolxm3'),
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_PISTOL` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'clip_default', label = TranslateCap('component_clip_default'), hash = `COMPONENT_PISTOLXM3_CLIP_01` },
        { name = 'suppressor', label = TranslateCap('component_suppressor'), hash = `COMPONENT_PISTOLXM3_SUPP` },
      },
    },
    { name = 'WEAPON_ACIDPACKAGE', label = TranslateCap('weapon_acidpackage'), components = {}, throwable = true },
    { name = 'WEAPON_CANDYCANE', label = TranslateCap('weapon_candycane'), components = {} },
    {
      name = 'WEAPON_RAILGUNXM3',
      label = TranslateCap('weapon_railgunxm3'),
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_RAILGUN` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'clip_default', label = TranslateCap('component_clip_default'), hash = `COMPONENT_RAILGUNXM3_CLIP_01` },
      },
    },
  }
end
