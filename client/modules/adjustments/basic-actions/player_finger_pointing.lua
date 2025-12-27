local once = false
local keyPressed = false
local isPointing = false
local pointingCommand = 'player_finger_pointing'
local anim = {
  dict = 'anim@mp_point',
  name = 'task_mp_pointing',
}

local function startPointing()
  local ped = cache.ped

  lib.requestAnimDict(anim.dict)

  --- @diagnostic disable-next-line
  SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)

  --- @diagnostic disable-next-line
  SetPedConfigFlag(ped, 36, 1)
  Citizen.InvokeNative(0x2D537BA194896636, ped, anim.name, 0.5, 0, anim.dict, 24)
end

local function stopPointing()
  local ped = cache.ped

  Citizen.InvokeNative(0xD01015C7316AE176, ped, 'Stop')

  if not IsPedInjured(ped) then
    ClearPedSecondaryTask(ped)
  end

  --- @diagnostic disable-next-line
  if not IsPedInAnyVehicle(ped, 1) then
    --- @diagnostic disable-next-line
    SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
  end

  --- @diagnostic disable-next-line
  SetPedConfigFlag(ped, 36, 0)
  ClearPedSecondaryTask(ped)
  RemoveAnimDict(anim.dict)
end

@command(pointingCommand, function()
  local ped = cache.ped

  if not IsPedInAnyVehicle(ped, true) and not LocalPlayer.state.isDead then
    if not once then
      once = true
      while true do
        Wait(0)

        if not keyPressed then
          if not isPointing and IsPedOnFoot(ped) then
            Wait(200)
            if not IsControlPressed(0, 29) then
              keyPressed = true
              startPointing()
              isPointing = true
            else
              keyPressed = true
              while IsControlPressed(0, 29) do
                Wait(50)
              end
            end
          elseif (IsControlPressed(0, 29) and isPointing) or (not IsPedOnFoot(ped) and isPointing) then
            keyPressed = true
            isPointing = false
            stopPointing()
          end
        end

        if keyPressed then
          if not IsControlPressed(0, 29) then
            keyPressed = false
          end
        end

        if Citizen.InvokeNative(0x921CE12C489C4C41, ped) and not isPointing then
          stopPointing()
        end

        if Citizen.InvokeNative(0x921CE12C489C4C41, ped) then
          if not IsPedOnFoot(ped) then
            stopPointing()
          else
            local camPitch = GetGameplayCamRelativePitch()

            if camPitch < -70.0 then
              camPitch = -70.0
            elseif camPitch > 42.0 then
              camPitch = 42.0
            end

            camPitch = (camPitch + 70.0) / 112.0

            local camHeading = GetGameplayCamRelativeHeading()
            local cosCamHeading = Cos(camHeading)
            local sinCamHeading = Sin(camHeading)

            if camHeading < -180.0 then
              camHeading = -180.0
            elseif camHeading > 180.0 then
              camHeading = 180.0
            end

            camHeading = (camHeading + 180.0) / 360.0

            local blocked = 0

            local coords = GetOffsetFromEntityInWorldCoords(
              ped,
              (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)),
              (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)),
              0.6
            )
            local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7)

            ---@diagnostic disable-next-line
            _, blocked, coords, coords = GetRaycastResult(ray)

            Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, 'Pitch', camPitch)
            Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, 'Heading', camHeading * -1.0 + 1.0)
            Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, 'isBlocked', blocked)
            Citizen.InvokeNative(
              0xB0A6CFD2C69C1088,
              ped,
              'isFirstPerson',
              Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4
            )
          end
        end

        if not once then
          break
        end
      end
    else
      once = false
    end
  end
end, false)

RegisterKeyMapping(pointingCommand, '(Don\'t change) Pointing', 'keyboard', 'B')
