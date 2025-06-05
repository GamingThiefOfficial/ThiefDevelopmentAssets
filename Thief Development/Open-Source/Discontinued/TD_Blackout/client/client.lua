-- Client-side script to handle blackout visuals and effects

-- Event handler to toggle the blackout state
RegisterNetEvent('blackout:toggle')
AddEventHandler('blackout:toggle', function(isBlackout)
    if isBlackout then
        -- Apply blackout visual effect
        SetTimecycleModifier('CAMERA_secuirity') -- Darkens the view
        SetBlackout(true) -- Turns off streetlights and other lighting
        print("Blackout started.")
    else
        -- Remove blackout visual effect
        ClearTimecycleModifier()
        SetBlackout(false)
        print("Blackout ended.")
    end
end)
