local disabledAreas = {}

RegisterNetEvent('receiveDisabledAreas')
AddEventHandler('receiveDisabledAreas', function(serverDisabledAreas)
    disabledAreas = serverDisabledAreas
end)

function isInDisabledArea(x, y, z)
    for _, area in ipairs(disabledAreas) do
        local distance = Vdist(x, y, z, area.x, area.y, area.z)
        if distance <= area.radius then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    TriggerServerEvent('sendDisabledAreas') -- Request all disabled areas from the server

    while true do
        Citizen.Wait(1000)

        local playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)

        if isInDisabledArea(pos.x, pos.y, pos.z) then
            SetCreateRandomCops(false)
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetPedDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
        else
            SetCreateRandomCops(true)
            SetVehicleDensityMultiplierThisFrame(1.0)
            SetPedDensityMultiplierThisFrame(1.0)
            SetRandomVehicleDensityMultiplierThisFrame(1.0)
            SetParkedVehicleDensityMultiplierThisFrame(1.0)
        end
    end
end)
