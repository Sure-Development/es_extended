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
      name = 'WEAPON_HEAVYSNIPER',
      label = TranslateCap('weapon_heavysniper'),
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_SNIPER` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'scope', label = TranslateCap('component_scope'), hash = `COMPONENT_AT_SCOPE_LARGE` },
        { name = 'scope_advanced', label = TranslateCap('component_scope_advanced'), hash = `COMPONENT_AT_SCOPE_MAX` },
      },
    },
    {
      name = 'WEAPON_HEAVYSNIPER_MK2',
      label = TranslateCap('weapon_heavysniper_mk2'),
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_SNIPER` },
      tints = weaponTints.mk2_weapon_tints,
      components = {
        { name = 'clip_default', label = TranslateCap('component_clip_default'), hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_01` },
        { name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_02` },
        { name = 'ammo_incendiary', label = TranslateCap('component_ammo_incendiary'), hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY` },
        { name = 'ammo_armor', label = TranslateCap('component_ammo_armor'), hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING` },
        { name = 'ammo_fmj', label = TranslateCap('component_ammo_fmj'), hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ` },
        { name = 'ammo_explosive', label = TranslateCap('component_ammo_explosive'), hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE` },
        { name = 'scope_zoom', label = TranslateCap('component_scope_zoom'), hash = `COMPONENT_AT_SCOPE_LARGE_MK2` },
        { name = 'scope_advanced', label = TranslateCap('component_scope_advanced'), hash = `COMPONENT_AT_SCOPE_MAX` },
        { name = 'scope_nightvision', label = TranslateCap('component_scope_nightvision'), hash = `COMPONENT_AT_SCOPE_NV` },
        { name = 'scope_thermal', label = TranslateCap('component_scope_thermal'), hash = `COMPONENT_AT_SCOPE_THERMAL` },
        { name = 'suppressor', label = TranslateCap('component_suppressor'), hash = `COMPONENT_AT_SR_SUPP_03` },
        { name = 'muzzle_squared', label = TranslateCap('component_muzzle_squared'), hash = `COMPONENT_AT_MUZZLE_08` },
        { name = 'muzzle_bell', label = TranslateCap('component_muzzle_bell'), hash = `COMPONENT_AT_MUZZLE_09` },
        { name = 'barrel_default', label = TranslateCap('component_barrel_default'), hash = `COMPONENT_AT_SR_BARREL_01` },
        { name = 'barrel_heavy', label = TranslateCap('component_barrel_heavy'), hash = `COMPONENT_AT_SR_BARREL_02` },
        { name = 'camo_finish', label = TranslateCap('component_camo_finish'), hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO` },
        { name = 'camo_finish2', label = TranslateCap('component_camo_finish2'), hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_02` },
        { name = 'camo_finish3', label = TranslateCap('component_camo_finish3'), hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_03` },
        { name = 'camo_finish4', label = TranslateCap('component_camo_finish4'), hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_04` },
        { name = 'camo_finish5', label = TranslateCap('component_camo_finish5'), hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_05` },
        { name = 'camo_finish6', label = TranslateCap('component_camo_finish6'), hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_06` },
        { name = 'camo_finish7', label = TranslateCap('component_camo_finish7'), hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_07` },
        { name = 'camo_finish8', label = TranslateCap('component_camo_finish8'), hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_08` },
        { name = 'camo_finish9', label = TranslateCap('component_camo_finish9'), hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_09` },
        { name = 'camo_finish10', label = TranslateCap('component_camo_finish10'), hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_10` },
        { name = 'camo_finish11', label = TranslateCap('component_camo_finish11'), hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01` },
      },
    },
    {
      name = 'WEAPON_MARKSMANRIFLE',
      label = TranslateCap('weapon_marksmanrifle'),
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_SNIPER` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'clip_default', label = TranslateCap('component_clip_default'), hash = `COMPONENT_MARKSMANRIFLE_CLIP_01` },
        { name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = `COMPONENT_MARKSMANRIFLE_CLIP_02` },
        { name = 'flashlight', label = TranslateCap('component_flashlight'), hash = `COMPONENT_AT_AR_FLSH` },
        { name = 'scope', label = TranslateCap('component_scope'), hash = `COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM` },
        { name = 'suppressor', label = TranslateCap('component_suppressor'), hash = `COMPONENT_AT_AR_SUPP` },
        { name = 'grip', label = TranslateCap('component_grip'), hash = `COMPONENT_AT_AR_AFGRIP` },
        { name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = `COMPONENT_MARKSMANRIFLE_VARMOD_LUXE` },
      },
    },
    {
      name = 'WEAPON_MARKSMANRIFLE_MK2',
      label = TranslateCap('weapon_marksmanrifle_mk2'),
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_SNIPER` },
      tints = weaponTints.mk2_weapon_tints,
      components = {
        { name = 'clip_default', label = TranslateCap('component_clip_default'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_01` },
        { name = 'clip_extended', label = TranslateCap('component_clip_extended'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_02` },
        { name = 'ammo_tracer', label = TranslateCap('component_ammo_tracer'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER` },
        { name = 'ammo_incendiary', label = TranslateCap('component_ammo_incendiary'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY` },
        { name = 'ammo_armor', label = TranslateCap('component_ammo_armor'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING` },
        { name = 'ammo_fmj', label = TranslateCap('component_ammo_fmj'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ` },
        { name = 'scope_holo', label = TranslateCap('component_scope_holo'), hash = `COMPONENT_AT_SIGHTS` },
        { name = 'scope_large', label = TranslateCap('component_scope_large'), hash = `COMPONENT_AT_SCOPE_MEDIUM_MK2` },
        { name = 'scope_zoom', label = TranslateCap('component_scope_zoom'), hash = `COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2` },
        { name = 'flashlight', label = TranslateCap('component_flashlight'), hash = `COMPONENT_AT_AR_FLSH` },
        { name = 'suppressor', label = TranslateCap('component_suppressor'), hash = `COMPONENT_AT_AR_SUPP` },
        { name = 'muzzle_flat', label = TranslateCap('component_muzzle_flat'), hash = `COMPONENT_AT_MUZZLE_01` },
        { name = 'muzzle_tactical', label = TranslateCap('component_muzzle_tactical'), hash = `COMPONENT_AT_MUZZLE_02` },
        { name = 'muzzle_fat', label = TranslateCap('component_muzzle_fat'), hash = `COMPONENT_AT_MUZZLE_03` },
        { name = 'muzzle_precision', label = TranslateCap('component_muzzle_precision'), hash = `COMPONENT_AT_MUZZLE_04` },
        { name = 'muzzle_heavy', label = TranslateCap('component_muzzle_heavy'), hash = `COMPONENT_AT_MUZZLE_05` },
        { name = 'muzzle_slanted', label = TranslateCap('component_muzzle_slanted'), hash = `COMPONENT_AT_MUZZLE_06` },
        { name = 'muzzle_split', label = TranslateCap('component_muzzle_split'), hash = `COMPONENT_AT_MUZZLE_07` },
        { name = 'barrel_default', label = TranslateCap('component_barrel_default'), hash = `COMPONENT_AT_MRFL_BARREL_01` },
        { name = 'barrel_heavy', label = TranslateCap('component_barrel_heavy'), hash = `COMPONENT_AT_MRFL_BARREL_02` },
        { name = 'grip', label = TranslateCap('component_grip'), hash = `COMPONENT_AT_AR_AFGRIP_02` },
        { name = 'camo_finish', label = TranslateCap('component_camo_finish'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO` },
        { name = 'camo_finish2', label = TranslateCap('component_camo_finish2'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_02` },
        { name = 'camo_finish3', label = TranslateCap('component_camo_finish3'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_03` },
        { name = 'camo_finish4', label = TranslateCap('component_camo_finish4'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_04` },
        { name = 'camo_finish5', label = TranslateCap('component_camo_finish5'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_05` },
        { name = 'camo_finish6', label = TranslateCap('component_camo_finish6'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_06` },
        { name = 'camo_finish7', label = TranslateCap('component_camo_finish7'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_07` },
        { name = 'camo_finish8', label = TranslateCap('component_camo_finish8'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_08` },
        { name = 'camo_finish9', label = TranslateCap('component_camo_finish9'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_09` },
        { name = 'camo_finish10', label = TranslateCap('component_camo_finish10'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_10` },
        { name = 'camo_finish11', label = TranslateCap('component_camo_finish11'), hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01` },
      },
    },
    {
      name = 'WEAPON_SNIPERRIFLE',
      label = TranslateCap('weapon_sniperrifle'),
      ammo = { label = TranslateCap('ammo_rounds'), hash = `AMMO_SNIPER` },
      tints = weaponTints.default_weapon_tints,
      components = {
        { name = 'scope', label = TranslateCap('component_scope'), hash = `COMPONENT_AT_SCOPE_LARGE` },
        { name = 'scope_advanced', label = TranslateCap('component_scope_advanced'), hash = `COMPONENT_AT_SCOPE_MAX` },
        { name = 'suppressor', label = TranslateCap('component_suppressor'), hash = `COMPONENT_AT_AR_SUPP_02` },
        { name = 'luxary_finish', label = TranslateCap('component_luxary_finish'), hash = `COMPONENT_SNIPERRIFLE_VARMOD_LUXE` },
      },
    },
  }
end
