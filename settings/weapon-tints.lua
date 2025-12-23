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

---@class Settings.WeaponTints
local WEAPONTINTS = {}

--- ระบุ Tint เริ่มต้น
---@type table<integer, string>
WEAPONTINTS.default_weapon_tints = {
  [0] = TranslateCap('tint_default'),
  [1] = TranslateCap('tint_green'),
  [2] = TranslateCap('tint_gold'),
  [3] = TranslateCap('tint_pink'),
  [4] = TranslateCap('tint_army'),
  [5] = TranslateCap('tint_lspd'),
  [6] = TranslateCap('tint_orange'),
  [7] = TranslateCap('tint_platinum'),
}

--- ระบุ Tint เริ่มต้นของ MK2
---@type table<integer, string>
WEAPONTINTS.mk2_weapon_tints = {
  [0] = TranslateCap('tint_classic_black'),
  [1] = TranslateCap('tint_classic_gray'),
  [2] = TranslateCap('tint_classic_two_tone'),
  [3] = TranslateCap('tint_classic_white'),
  [4] = TranslateCap('tint_classic_beige'),
  [5] = TranslateCap('tint_classic_green'),
  [6] = TranslateCap('tint_classic_blue'),
  [7] = TranslateCap('tint_classic_earth'),
  [8] = TranslateCap('tint_classic_brown_black'),
  [9] = TranslateCap('tint_contrast_red'),
  [10] = TranslateCap('tint_contrast_blue'),
  [11] = TranslateCap('tint_contrast_yellow'),
  [12] = TranslateCap('tint_contrast_orange'),
  [13] = TranslateCap('tint_bold_pink'),
  [14] = TranslateCap('tint_bold_purple_yellow'),
  [15] = TranslateCap('tint_bold_orange'),
  [16] = TranslateCap('tint_bold_green_purple'),
  [17] = TranslateCap('tint_bold_red_feat'),
  [18] = TranslateCap('tint_bold_green_feat'),
  [19] = TranslateCap('tint_bold_cyan_feat'),
  [20] = TranslateCap('tint_bold_yellow_feat'),
  [21] = TranslateCap('tint_bold_red_white'),
  [22] = TranslateCap('tint_bold_blue_white'),
  [23] = TranslateCap('tint_metallic_gold'),
  [24] = TranslateCap('tint_metallic_platinum'),
  [25] = TranslateCap('tint_metallic_gray_lilac'),
  [26] = TranslateCap('tint_metallic_purple_lime'),
  [27] = TranslateCap('tint_metallic_red'),
  [28] = TranslateCap('tint_metallic_green'),
  [29] = TranslateCap('tint_metallic_blue'),
  [30] = TranslateCap('tint_metallic_white_aqua'),
  [31] = TranslateCap('tint_metallic_orange_yellow'),
  [32] = TranslateCap('tint_metallic_red_yellow'),
}

return WEAPONTINTS
