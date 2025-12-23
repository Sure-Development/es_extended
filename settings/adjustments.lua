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

---@class Settings.Adjustment
local ADJUSTMENT = {}

--- ปิดการเพิ่มเลือดอัตโนมัติ
---@type boolean
ADJUSTMENT.disable_health_regeneration = true

--- ปิดการได้รับอาวุธจากยานพาหนะ
---@type boolean
ADJUSTMENT.disable_vehicle_rewards = true

--- ปิดการ Drop อาวุธจาก NPC
---@type boolean
ADJUSTMENT.disable_npc_drops = true

--- ปิดหน่วยกู้ภัย NPC
---@type boolean
ADJUSTMENT.disable_dispatch_services = true

--- ปิด Scenarios
---@type boolean
ADJUSTMENT.disable_scenarios = true

--- ปิด Aim Assist
---@type boolean
ADJUSTMENT.disable_aim_assist = true

--- ปิดการสลับที่นั่งอัตโนมัติ
---@type boolean
ADJUSTMENT.disable_vehicle_seat_shuffle = true

--- ปิดการแสดงจำนวนกระสุนของตัวเกม
---@type boolean
ADJUSTMENT.disable_display_ammo = true

--- เปิดการต่อสู้ PVP
---@type boolean
ADJUSTMENT.enable_pvp = true

--- เปิด Wanted Level (ติดดาว)
---@type boolean
ADJUSTMENT.enable_wanted_level = false

--- ตั้งค่าเปิด/ปิด GTAV HUD
---@type table<integer, boolean>
ADJUSTMENT.remove_hud_components = {
  [1] = false, --WANTED_STARS,
  [2] = false, --WEAPON_ICON
  [3] = false, --CASH
  [4] = false, --MP_CASH
  [5] = false, --MP_MESSAGE
  [6] = true, --VEHICLE_NAME
  [7] = true, -- AREA_NAME
  [8] = true, -- VEHICLE_CLASS
  [9] = true, --STREET_NAME
  [10] = false, --HELP_TEXT
  [11] = false, --FLOATING_HELP_TEXT_1
  [12] = false, --FLOATING_HELP_TEXT_2
  [13] = false, --CASH_CHANGE
  [14] = false, --RETICLE
  [15] = false, --SUBTITLE_TEXT
  [16] = false, --RADIO_STATIONS
  [17] = false, --SAVING_GAME,
  [18] = false, --GAME_STREAM
  [19] = false, --WEAPON_WHEEL
  [20] = false, --WEAPON_WHEEL_STATS
  [21] = false, --HUD_COMPONENTS
  [22] = false, --HUD_WEAPONS
}

--- ตั้งค่าจำนวนการ Spawn สิ่งต่าง ๆ
---@class Settings.Adjustment.multipliers
---@field ped_density number ความหนาแน่นของ NPC
---@field scenario_ped_density_interior number ความหนาแน่นของ NPC
---@field scenario_ped_density_exterior number ความหนาแน่นของ NPC
---@field ambient_vehicle_range number ความหนาแน่นของ Vehicle
---@field parked_vehicle_density number ความหนาแน่นของ Vehicle
---@field random_vehicle_density number ความหนาแน่นของ Vehicle
---@field vehicle_density number ความหนาแน่นของ Vehicle
ADJUSTMENT.multipliers = {
  ped_density = 0.0,
  scenario_ped_density_interior = 0.0,
  scenario_ped_density_exterior = 0.0,
  ambient_vehicle_range = 0.0,
  parked_vehicle_density = 0.0,
  random_vehicle_density = 0.0,
  vehicle_density = 0.0,
}

-- Pattern string format
--1 will lead to a random number from 0-9.
--A will lead to a random letter from A-Z.
-- . will lead to a random letter or number, with a 50% probability of being either.
--^1 will lead to a literal 1 being emitted.
--^A will lead to a literal A being emitted.
--Any other character will lead to said character being emitted.
-- A string shorter than 8 characters will be padded on the right.
ADJUSTMENT.custom_ai_plate = '........' -- Custom plates for AI vehicles

return ADJUSTMENT
