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
    { name = 'WEAPON_DAGGER', label = TranslateCap('weapon_dagger'), components = {} },
    { name = 'WEAPON_BAT', label = TranslateCap('weapon_bat'), components = {} },
    { name = 'WEAPON_BATTLEAXE', label = TranslateCap('weapon_battleaxe'), components = {} },
    { name = 'WEAPON_BOTTLE', label = TranslateCap('weapon_bottle'), components = {} },
    { name = 'WEAPON_CROWBAR', label = TranslateCap('weapon_crowbar'), components = {} },
    { name = 'WEAPON_FLASHLIGHT', label = TranslateCap('weapon_flashlight'), components = {} },
    { name = 'WEAPON_GOLFCLUB', label = TranslateCap('weapon_golfclub'), components = {} },
    { name = 'WEAPON_HAMMER', label = TranslateCap('weapon_hammer'), components = {} },
    { name = 'WEAPON_HATCHET', label = TranslateCap('weapon_hatchet'), components = {} },
    { name = 'WEAPON_KNIFE', label = TranslateCap('weapon_knife'), components = {} },
    { name = 'WEAPON_MACHETE', label = TranslateCap('weapon_machete'), components = {} },
    { name = 'WEAPON_NIGHTSTICK', label = TranslateCap('weapon_nightstick'), components = {} },
    { name = 'WEAPON_WRENCH', label = TranslateCap('weapon_wrench'), components = {} },
    { name = 'WEAPON_POOLCUE', label = TranslateCap('weapon_poolcue'), components = {} },
    { name = 'WEAPON_STONE_HATCHET', label = TranslateCap('weapon_stone_hatchet'), components = {} },
    {
      name = 'WEAPON_SWITCHBLADE',
      label = TranslateCap('weapon_switchblade'),
      components = {
        { name = 'handle_default', label = TranslateCap('component_handle_default'), hash = `COMPONENT_SWITCHBLADE_VARMOD_BASE` },
        { name = 'handle_vip', label = TranslateCap('component_handle_vip'), hash = `COMPONENT_SWITCHBLADE_VARMOD_VAR1` },
        { name = 'handle_bodyguard', label = TranslateCap('component_handle_bodyguard'), hash = `COMPONENT_SWITCHBLADE_VARMOD_VAR2` },
      },
    },
    {
      name = 'WEAPON_KNUCKLE',
      label = TranslateCap('weapon_knuckle'),
      components = {
        { name = 'knuckle_base', label = TranslateCap('component_knuckle_base'), hash = `COMPONENT_KNUCKLE_VARMOD_BASE` },
        { name = 'knuckle_pimp', label = TranslateCap('component_knuckle_pimp'), hash = `COMPONENT_KNUCKLE_VARMOD_PIMP` },
        { name = 'knuckle_ballas', label = TranslateCap('component_knuckle_ballas'), hash = `COMPONENT_KNUCKLE_VARMOD_BALLAS` },
        { name = 'knuckle_dollar', label = TranslateCap('component_knuckle_dollar'), hash = `COMPONENT_KNUCKLE_VARMOD_DOLLAR` },
        { name = 'knuckle_diamond', label = TranslateCap('component_knuckle_diamond'), hash = `COMPONENT_KNUCKLE_VARMOD_DIAMOND` },
        { name = 'knuckle_hate', label = TranslateCap('component_knuckle_hate'), hash = `COMPONENT_KNUCKLE_VARMOD_HATE` },
        { name = 'knuckle_love', label = TranslateCap('component_knuckle_love'), hash = `COMPONENT_KNUCKLE_VARMOD_LOVE` },
        { name = 'knuckle_player', label = TranslateCap('component_knuckle_player'), hash = `COMPONENT_KNUCKLE_VARMOD_PLAYER` },
        { name = 'knuckle_king', label = TranslateCap('component_knuckle_king'), hash = `COMPONENT_KNUCKLE_VARMOD_KING` },
        { name = 'knuckle_vagos', label = TranslateCap('component_knuckle_vagos'), hash = `COMPONENT_KNUCKLE_VARMOD_VAGOS` },
      },
    },
  }
end
