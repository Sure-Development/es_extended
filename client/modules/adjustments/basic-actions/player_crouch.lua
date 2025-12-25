local crouchCommand = 'player_crouch'
local animSet = 'move_ped_crouched'
local crouched = false

RegisterCommand(crouchCommand, function()
  local isDead = LocalPlayer.state.isDead or false

  if not isDead then
    local ped = cache.ped
    if DoesEntityExist(ped) then
      HideHudComponentThisFrame(6)
      HideHudComponentThisFrame(7)
      HideHudComponentThisFrame(8)
      HideHudComponentThisFrame(9)
      DisableControlAction(0, 36, true)

      if not IsPauseMenuActive() then
        lib.requestAnimSet(animSet)

        if crouched == true then
          ResetPedMovementClipset(ped, 0.3)
          RemoveAnimSet(animSet)

          crouched = false
        elseif crouched == false then
          SetPedMovementClipset(ped, animSet, 0.3)

          crouched = true
        end
      end
    end
  end
end, false)

RegisterKeyMapping(crouchCommand, '(Don\'t Change) Crouch', 'keyboard', 'LCONTROL')
