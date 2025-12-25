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

---@param message string The message to show
---@param notifyType? string The type of notification to show
---@param length? number The length of the notification
---@param title? string The title of the notification
---@return nil
function ESX.ShowNotification(message, notifyType, length, title)
  TriggerEvent('hud:notification', notifyType, message, length)
end

---@param sender string
---@param subject string
---@param msg string
---@param textureDict string
---@param iconType integer
---@param flash boolean
---@param saveToBrief? boolean
---@param hudColorIndex? integer
---@return nil
function ESX.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
  AddTextEntry('esxAdvancedNotification', msg)
  BeginTextCommandThefeedPost('esxAdvancedNotification')
  if hudColorIndex then
    ThefeedSetNextPostBackgroundColor(hudColorIndex)
  end
  EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
  EndTextCommandThefeedPostTicker(flash, saveToBrief == nil or saveToBrief)
end

---@param msg string The message to show
---@param thisFrame? boolean Whether to show the message this frame
---@param beep? boolean Whether to beep
---@param duration? number The duration of the message
---@return nil
function ESX.ShowHelpNotification(msg, thisFrame, beep, duration)
  AddTextEntry('esxHelpNotification', msg)
  if thisFrame then
    DisplayHelpTextThisFrame('esxHelpNotification', false)
  else
    BeginTextCommandDisplayHelp('esxHelpNotification')
    EndTextCommandDisplayHelp(0, false, beep == nil or beep, duration or -1)
  end
end

---@param msg string The message to show
---@param coords table The coords to show the message at
---@return nil
function ESX.ShowFloatingHelpNotification(msg, coords)
  AddTextEntry('esxFloatingHelpNotification', msg)
  SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z)
  SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
  BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
  EndTextCommandDisplayHelp(2, false, false, -1)
end

---@param msg string The message to show
---@param time number The duration of the message
---@return nil
function ESX.DrawMissionText(msg, time)
  ClearPrints()
  BeginTextCommandPrint('STRING')
  AddTextComponentSubstringPlayerName(msg)
  EndTextCommandPrint(time, true)
end
