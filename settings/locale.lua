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

---@class Settings.Locale
local LOCALE = {}

--- ตั้งค่าภาษา (ชื่อไฟล์ในโฟลเดอร์ locales/)
---@type string
LOCALE.locale = 'en'

lib.locale(LOCALE.locale)

function TranslateCap(str, ...)
  return locale(str, ...):gsub('^%l', string.upper)
end

function _U(str, ...)
  return locale(str, ...):gsub('^%l', string.upper)
end

function Translate(str, ...)
  return locale(str, ...)
end

function _(str, ...)
  return locale(str, ...)
end

return LOCALE
