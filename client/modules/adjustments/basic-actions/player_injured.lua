---@param healthToBeInjured integer
return function(healthToBeInjured)
  local isPlayingInjured = false
  local animSet = 'move_m@injured'

  CreateThread(function()
    while true do
      Wait(1000)

      local isDead = LocalPlayer.state.isDead or false
      local ped = cache.ped

      if GetPedMaxHealth(ped) ~= 200 and not isDead then
        SetPedMaxHealth(ped, 200)
        SetEntityHealth(ped, GetEntityHealth(ped) + 25)
      end

      local currentHealth = GetEntityHealth(ped)
      if (currentHealth < healthToBeInjured) and not isPlayingInjured then
        lib.requestAnimSet(animSet)
        SetPedMovementClipset(ped, animSet, 0.1)

        isPlayingInjured = true
      elseif (currentHealth >= healthToBeInjured) and isPlayingInjured then
        ResetPedMovementClipset(ped, 0.1)
        ResetPedWeaponMovementClipset(ped)
        ResetPedStrafeClipset(ped)
        RemoveAnimSet(animSet)

        isPlayingInjured = false
      end
    end
  end)
end
