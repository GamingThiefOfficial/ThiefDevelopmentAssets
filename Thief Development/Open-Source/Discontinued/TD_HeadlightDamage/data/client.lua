Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
            local engineHealth = GetVehicleEngineHealth(vehicle)

            if engineHealth < Config.FlickerThreshold then
                if math.random() < Config.FlickerChance then
                    local lightsOn, highbeamsOn = GetVehicleLightsState(vehicle)

                    -- Flicker effect
                    if lightsOn == 1 then
                        SetVehicleLights(vehicle, 0) -- Turn off lights
                        Citizen.Wait(math.random(Config.FlickerMinTime, Config.FlickerMaxTime))
                        SetVehicleLights(vehicle, 2) -- Turn on headlights
                    end
                end
            end
        end

        Citizen.Wait(Config.CheckInterval)
    end
end)
