local seatbeltOn = false
local playerPed = nil
local lastVehicle = nil
local wasInVehicle = false
local lastSpeed = 0.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = GetEntitySpeed(vehicle) * 3.6 -- Convert to km/h

            -- Check if player enters a new vehicle
            if lastVehicle ~= vehicle then
                seatbeltOn = false
                lastVehicle = vehicle
            end

            -- Toggle seatbelt
            if IsControlJustReleased(0, Config.SeatbeltKey) then
                seatbeltOn = not seatbeltOn
            
                if seatbeltOn then
                    PlaySeatbeltSound("seatbelt_on")
                    Notify("Seatbelt ~g~ON")
                else
                    PlaySeatbeltSound("seatbelt_off")
                    Notify("Seatbelt ~r~OFF")
                end
            end            

            -- Detect crashes
            if wasInVehicle and speed < lastSpeed - Config.ImpactThreshold then
                if not seatbeltOn and lastSpeed > Config.EjectSpeed then
                    RagdollEjectPlayer(vehicle, lastSpeed)
                end
            end

            lastSpeed = speed
            wasInVehicle = true
        else
            wasInVehicle = false
            seatbeltOn = false
        end
    end
end)

-- Ragdoll Ejection
function RagdollEjectPlayer(vehicle, speed)
    local velocity = GetEntityVelocity(vehicle)
    
    -- Remove player from vehicle WITHOUT an animation
    Citizen.Wait(50)
    SetEntityCoords(playerPed, GetEntityCoords(vehicle).x, GetEntityCoords(vehicle).y, GetEntityCoords(vehicle).z + 1.0, true, true, true, false)
    
    -- Enable ragdoll
    SetPedToRagdoll(playerPed, Config.RagdollTime, Config.RagdollTime, 0, true, true, false)
    
    -- Apply ejection force based on crash speed
    local ejectForce = vector3(velocity.x * 1.5, velocity.y * 1.5, (velocity.z + 4.0) * (speed / 100))
    SetEntityVelocity(playerPed, ejectForce.x, ejectForce.y, ejectForce.z)
    
    Notify("~r~You flew out of the windshield! Wear your seatbelt.")
    
    -- Wait for ragdoll time to finish
    Citizen.Wait(Config.RagdollTime)

    -- Play getting-up animation
    PlayGetUpAnimation()
end

-- Play the "getting up" animation after being ejected
function PlayGetUpAnimation()
    RequestAnimDict("move_m@injured") -- Load animation dictionary

    while not HasAnimDictLoaded("move_m@injured") do
        Citizen.Wait(10)
    end

    -- Play getting-up animation
    TaskPlayAnim(playerPed, "move_m@injured", "idle", 8.0, -8.0, 3000, 48, 0, false, false, false)
    Citizen.Wait(3000) -- Wait for animation to finish

    ClearPedTasks(playerPed) -- Clear animation after it's done
end

-- Notification function
function Notify(msg)
    if Config.NotifType == "chat" then
        TriggerEvent("chat:addMessage", { args = { "(TD Seatbelt)", msg } })
    elseif Config.NotifType == "notify" then
        SetNotificationTextEntry("STRING")
        AddTextComponentString(msg)
        DrawNotification(false, true)
    end
end

-- Play sound via NUI
function PlaySeatbeltSound(sound)
    SendNUIMessage({
        action = "playSound",
        soundFile = sound .. ".mp3",
        volume = Config.SeatbeltVolume
    })
end


