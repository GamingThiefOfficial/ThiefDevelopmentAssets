-- Server-side script for managing blackouts

-- A variable to track blackout status
local blackoutActive = false

-- Function to start a blackout
function startBlackout()
    if not blackoutActive then
        blackoutActive = true
        TriggerClientEvent('blackout:toggle', -1, true) -- Notify all clients about the blackout
        print("Blackout started.")

        -- Automatically end the blackout after a random period (e.g., 60-120 seconds)
        Citizen.SetTimeout(math.random(60000, 120000), function()
            blackoutActive = false
            TriggerClientEvent('blackout:toggle', -1, false) -- Notify all clients that the blackout ended
            print("Blackout ended.")
        end)
    else
        print("A blackout is already in progress.")
    end
end

-- Command to manually trigger a blackout
RegisterCommand('blackout', function(source, args, rawCommand)
    if source == 0 then -- Allow server console to trigger blackouts
        startBlackout()
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^1Error", "You don't have permission to run this command."}
        })
    end
end, true)
