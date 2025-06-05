local gravity = 9.81  -- Gravity force applied to bullets
local bulletSpeed = 400.0  -- Approximate speed of bullets

-- Function to apply bullet drop
local function ApplyBulletDrop()
    local playerPed = PlayerPedId()
    if IsPedShooting(playerPed) then
        local weaponHash = GetSelectedPedWeapon(playerPed)
        local _, weaponType = GetWeaponHudStats(weaponHash)
        
        -- Only apply bullet drop for projectile weapons (excluding melee, etc.)
        if weaponType == 4 then 
            Citizen.Wait(10)

            -- Get shooting direction
            local startCoords = GetEntityCoords(playerPed)
            local forwardVector = GetEntityForwardVector(playerPed)

            -- Calculate initial bullet velocity
            local velocity = vector3(forwardVector.x * bulletSpeed, forwardVector.y * bulletSpeed, forwardVector.z * bulletSpeed)

            -- Simulate bullet drop over time
            local time = 0
            while time < 3.0 do -- Simulate bullet flight for up to 3 seconds
                Citizen.Wait(50)
                time = time + 0.05

                -- Apply gravity
                velocity = vector3(velocity.x, velocity.y, velocity.z - (gravity * time))

                -- Get new bullet position
                local newCoords = startCoords + velocity * time

                -- Draw debug marker (for testing)
                DrawMarker(1, newCoords.x, newCoords.y, newCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.1, 255, 0, 0, 255, false, false, 2, false, nil, nil, false)
            end
        end
    end
end

-- Main loop
Citizen.CreateThread(function()
    while true do
        ApplyBulletDrop()
        Citizen.Wait(0)
    end
end)
