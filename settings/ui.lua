---@class Settings.Ui
local UI = {}

--- ระยะห่างจากขอบจอ (หน่วย rem)
---@type integer
UI.offset = 1

---@class Settings.Ui.Notification
---@field default_limit integer จำนวน Limit Queue
---@field default_timeout integer จำนวนเวลา Timeout ตั้งต้น
UI.notification = {
  default_limit = 6,
  default_timeout = 5000,
}

return UI
