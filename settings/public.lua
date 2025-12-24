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

---@class Settings.Public
local PUBLIC = {}

--- กำหนดบัญชีของผู้เล่น
---@class Settings.Public.Account
---@field label string ชื่อระบุ
---@field round boolean ปัดเศษหรือไม่
---@type table<string, Settings.Public.Account>
PUBLIC.accounts = {
  bank = {
    label = TranslateCap('account_bank'),
    round = true,
  },
  black_money = {
    label = TranslateCap('account_black_money'),
    round = true,
  },
  money = {
    label = TranslateCap('account_money'),
    round = true,
  },
}

--- เปิดการใช้งานข้อมูลแบบ Hybrid สำหรับ PlayerData, Inventory | Accounts | Loadout ฝั่ง Client
--- สามารถ Loop ipairs เพื่อรองรับการหาข้อมูลแบบเดิมได้ หรือเข้าถึงข้อมูลด้วย Hash Table ESX.PlayerData.inventory['itemName']
---@type boolean
PUBLIC.hybrid_data = true

--- กำหนดของเริ่มต้น
---@class Settings.Public.Starter
---@field accounts table<string, integer> [ชื่อบัญชี] = จำนวนเงิน
---@field items table<string, integer> [ชื่อไอเทม] = จำนวนไอเทม
PUBLIC.starter = {
  accounts = {
    money = 10000,
    bank = 0,
  },

  items = {},
}

--- กำหนดจุดเกิดเริ่มต้น
---@alias Settings.Public.SpawnPoints { x: number, y: number, z: number, heading: number }
---@type Settings.Public.SpawnPoints[]
PUBLIC.spawn_points = {
  { x = -6278.84, y = -458.92, z = 99.04, heading = 1.0 },
}

--- กำหนด Group ที่มีความสามารถแอดมิน
---@type table<string, boolean>
PUBLIC.admin_groups = {
  ['owner'] = true,
  ['admin'] = true,
  ['superadmin'] = true,
}

--- กำหนดระยะที่ไกลที่สุด ที่สามารถมอบของได้
---@type number
PUBLIC.distance_give = 4.0

--- กำหนดตัวระบุ Identifier Type
---@alias Settings.Public.IdentifierType
---| 'steam'
---| 'discord'
---| 'license'
---@type Settings.Public.IdentifierType
PUBLIC.identifier = 'steam'

return PUBLIC
