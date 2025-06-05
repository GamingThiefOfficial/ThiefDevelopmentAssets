-- Config for storing the keybinds for each window
Config = Config or {}
local windowKeys = Config.WindowKeys or {}

Citizen.CreateThread(function()
    -- Register commands for each window with their unique keybind
    for _, win in pairs(windowKeys) do
        -- Register a command for each window to control its roll up/down
        RegisterCommand(win.command, function()
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            -- Check if the player is in a vehicle
            if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
                local model = GetEntityModel(vehicle)

                -- Check if the vehicle is allowed for window control
                if #Config.AllowedVehicles == 0 or IsVehicleAllowed(model) then
                    ToggleWindow(vehicle, win.index)
                end
            end
        end, false)

        -- Register the key mapping for each window's keybind
        RegisterKeyMapping(win.command, "Roll down window " .. win.index, "keyboard", win.defaultKey)
    end
end)

-- Function to toggle window up/down
function ToggleWindow(vehicle, index)
    -- Check if the window is intact (not already rolled down)
    if IsVehicleWindowIntact(vehicle, index) then
        RollDownWindow(vehicle, index)
        if Config.Debug then print("Window " .. index .. " rolled down") end
    else
        RollUpWindow(vehicle, index)
        if Config.Debug then print("Window " .. index .. " rolled up") end
    end
end

-- Function to check if the vehicle is in the allowed list
function IsVehicleAllowed(model)
    for _, allowedModel in pairs(Config.AllowedVehicles) do
        if model == GetHashKey(allowedModel) then
            return true
        end
    end
    return false
end
