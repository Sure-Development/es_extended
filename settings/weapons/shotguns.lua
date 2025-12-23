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
      name = 'WEAPON_ASSAULTSHOTGUN',
      label = TranslateCap('weapon_assaultshotgun'),
      ammo = { label = TranslateCap('ammo_shells'), hash = `AMMO_SHOTGUN` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'clip_default', label = TranslateCap('component_clip_default'), hash = `COMPONENT_ASSAULTSHOTGUN_CLIP_01` },
        { name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = `COMPONENT_ASSAULTSHOTGUN_CLIP_02` },
        { name = 'flashlight', label = TranslateCap('component_flashlight'), hash = `COMPONENT_AT_AR_FLSH` },
        { name = 'suppressor', label = TranslateCap('component_suppressor'), hash = `COMPONENT_AT_AR_SUPP` },
        { name = 'grip', label = TranslateCap('component_grip'), hash = `COMPONENT_AT_AR_AFGRIP` },
      },
    },
    {
      name = 'WEAPON_AUTOSHOTGUN',
      label = TranslateCap('weapon_autoshotgun'),
      tints = weaponTints.default_weapon_tints,
      components = {},
      ammo = { label = TranslateCap('ammo_shells'), hash = `AMMO_SHOTGUN` },
    },
    {
      name = 'WEAPON_BULLPUPSHOTGUN',
      label = TranslateCap('weapon_bullpupshotgun'),
      ammo = { label = TranslateCap('ammo_shells'), hash = `AMMO_SHOTGUN` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'flashlight', label = TranslateCap('component_flashlight'), hash = `COMPONENT_AT_AR_FLSH` },
        { name = 'suppressor', label = TranslateCap('component_suppressor'), hash = `COMPONENT_AT_AR_SUPP_02` },
        { name = 'grip', label = TranslateCap('component_grip'), hash = `COMPONENT_AT_AR_AFGRIP` },
      },
    },
    {
      name = 'WEAPON_COMBATSHOTGUN',
      label = TranslateCap('weapon_combatshotgun'),
      ammo = { label = TranslateCap('ammo_shells'), hash = `AMMO_SHOTGUN` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'flashlight', label = TranslateCap('component_flashlight'), hash = `COMPONENT_AT_AR_FLSH` },
        { name = 'suppressor', label = TranslateCap('component_suppressor'), hash = `COMPONENT_AT_AR_SUPP` },
      },
    },
    {
      name = 'WEAPON_DBSHOTGUN',
      label = TranslateCap('weapon_dbshotgun'),
      tints = weaponTints.default_weapon_tints,
      components = {},
      ammo = { label = TranslateCap('ammo_shells'), hash = `AMMO_SHOTGUN` },
    },
    {
      name = 'WEAPON_HEAVYSHOTGUN',
      label = TranslateCap('weapon_heavyshotgun'),
      ammo = { label = TranslateCap('ammo_shells'), hash = `AMMO_SHOTGUN` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'clip_default', label = TranslateCap('component_clip_default'), hash = `COMPONENT_HEAVYSHOTGUN_CLIP_01` },
        { name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = `COMPONENT_HEAVYSHOTGUN_CLIP_02` },
        { name = 'clip_drum', label = TranslateCap('component_clip_drum'), hash = `COMPONENT_HEAVYSHOTGUN_CLIP_03` },
        { name = 'flashlight', label = TranslateCap('component_flashlight'), hash = `COMPONENT_AT_AR_FLSH` },
        { name = 'suppressor', label = TranslateCap('component_suppressor'), hash = `COMPONENT_AT_AR_SUPP_02` },
        { name = 'grip', label = TranslateCap('component_grip'), hash = `COMPONENT_AT_AR_AFGRIP` },
      },
    },
    {
      name = 'WEAPON_MUSKET',
      label = TranslateCap('weapon_musket'),
      tints = weaponTints.default_weapon_tints,
      components = {},
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_SHOTGUN` },
    },
    {
      name = 'WEAPON_PUMPSHOTGUN',
      label = TranslateCap('weapon_pumpshotgun'),
      ammo = { label = TranslateCap('ammo_shells'), hash = `AMMO_SHOTGUN` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'flashlight', label = TranslateCap('component_flashlight'), hash = `COMPONENT_AT_AR_FLSH` },
        { name = 'suppressor', label = TranslateCap('component_suppressor'), hash = `COMPONENT_AT_SR_SUPP` },
        { name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = `COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER` },
      },
    },
    {
      name = 'WEAPON_PUMPSHOTGUN_MK2',
      label = TranslateCap('weapon_pumpshotgun_mk2'),
      ammo = { label = TranslateCap('ammo_shells'), hash = `AMMO_SHOTGUN` },
      tints = weaponTints.mk2_weapon_tints,
      components = {
        { name = 'shells_default', label = TranslateCap('component_shells_default'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_01` },
        { name = 'shells_incendiary', label = TranslateCap('component_shells_incendiary'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY` },
        { name = 'shells_armor', label = TranslateCap('component_shells_armor'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_ARMORPIERCING` },
        { name = 'shells_hollowpoint', label = TranslateCap('component_shells_hollowpoint'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT` },
        { name = 'shells_explosive', label = TranslateCap('component_shells_explosive'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE` },
        { name = 'scope_holo', label = TranslateCap('component_scope_holo'), hash = `COMPONENT_AT_SIGHTS` },
        { name = 'scope_small', label = TranslateCap('component_scope_small'), hash = `COMPONENT_AT_SCOPE_MACRO_MK2` },
        { name = 'scope_medium', label = TranslateCap('component_scope_medium'), hash = `COMPONENT_AT_SCOPE_SMALL_MK2` },
        { name = 'flashlight', label = TranslateCap('component_flashlight'), hash = `COMPONENT_AT_AR_FLSH` },
        { name = 'suppressor', label = TranslateCap('component_suppressor'), hash = `COMPONENT_AT_SR_SUPP_03` },
        { name = 'muzzle_squared', label = TranslateCap('component_muzzle_squared'), hash = `COMPONENT_AT_MUZZLE_08` },
        { name = 'camo_finish', label = TranslateCap('component_camo_finish'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO` },
        { name = 'camo_finish2', label = TranslateCap('component_camo_finish2'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_02` },
        { name = 'camo_finish3', label = TranslateCap('component_camo_finish3'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_03` },
        { name = 'camo_finish4', label = TranslateCap('component_camo_finish4'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_04` },
        { name = 'camo_finish5', label = TranslateCap('component_camo_finish5'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_05` },
        { name = 'camo_finish6', label = TranslateCap('component_camo_finish6'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_06` },
        { name = 'camo_finish7', label = TranslateCap('component_camo_finish7'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_07` },
        { name = 'camo_finish8', label = TranslateCap('component_camo_finish8'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_08` },
        { name = 'camo_finish9', label = TranslateCap('component_camo_finish9'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_09` },
        { name = 'camo_finish10', label = TranslateCap('component_camo_finish10'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_10` },
        { name = 'camo_finish11', label = TranslateCap('component_camo_finish11'), hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01` },
      },
    },
    {
      name = 'WEAPON_SAWNOFFSHOTGUN',
      label = TranslateCap('weapon_sawnoffshotgun'),
      ammo = { label = TranslateCap('ammo_shells'), hash = `AMMO_SHOTGUN` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = `COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE` },
      },
    },
  }
end
