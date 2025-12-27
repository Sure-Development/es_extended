local handsupCommand = 'player_handsup'
local handsup = false
local anim = {
  dict = 'missminuteman_1ig_2',
  name = 'handsup_enter',
}

@command(handsupCommand, function()
  local ped = cache.ped
  local notInVehicle = cache.vehicle == false or cache.vehicle == nil

  if notInVehicle and not LocalPlayer.state.isDead then
    if not handsup then
      handsup = true

      lib.requestAnimDict(anim.dict)

      TaskPlayAnim(ped, anim.dict, anim.name, 8.0, 8.0, -1, 50, 0, false, false, false)
    else
      handsup = false

      ClearPedTasks(ped)
      RemoveAnimDict(anim.dict)
    end
  end
end, false)

RegisterKeyMapping(handsupCommand, '(Don\'t change) Handsup', 'keyboard', 'X')
