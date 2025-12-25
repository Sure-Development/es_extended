---@param cooldown integer
return function(cooldown)
  local slideCommand = 'player_slide'
  local canSlide = true
  local pressShift = false
  local anim = {
    dict = 'missheistfbi3b_ig6_v2',
    enterName = 'rubble_slide_gunman',
    exitName = 'exit',
  }

  RegisterCommand('+pressShift', function()
    pressShift = true
  end, false)

  RegisterCommand('-pressShift', function()
    pressShift = false
  end, false)

  RegisterKeyMapping('+pressShift', '(Dont\'n change) Press Shift', 'keyboard', 'LSHIFT')

  RegisterCommand(slideCommand, function()
    local isDead = LocalPlayer.state.isDead or false

    if canSlide and not isDead and pressShift then
      local ped = cache.ped

      local onFoot = IsPedOnFoot(ped)
      local notRagDoll = not IsPedRagdoll(ped)
      local onInWater = not IsEntityInWater(ped)

      if onFoot and notRagDoll and onInWater then
        canSlide = false

        lib.requestAnimDict(anim.dict)

        SetPedMoveRateOverride(ped, 1.25)
        ClearPedSecondaryTask(ped)
        --- @diagnostic disable-next-line
        TaskPlayAnim(ped, anim.dict, anim.enterName, 3.0, 1.0, -1, 01, 0, 0, 0, 0)

        --- @diagnostic disable-next-line
        ApplyForceToEntityCenterOfMass(ped, 1, 0, 12.8, 0.8, true, true, true, true)
        Wait(250)

        --- @diagnostic disable-next-line
        TaskPlayAnim(ped, anim.dict, anim.exitName, 3.0, 1.0, -1, 01, 0, 0, 0, 0)
        ClearPedSecondaryTask(ped)

        RemoveAnimDict(anim.dict)

        Wait(cooldown or 10000)

        canSlide = true
      end
    end
  end, false)

  RegisterKeyMapping(slideCommand, '(Don\'t change) Slide', 'keyboard', 'H')
end
