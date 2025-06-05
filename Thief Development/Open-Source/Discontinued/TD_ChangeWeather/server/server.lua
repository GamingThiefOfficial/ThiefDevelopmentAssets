-- Weather Control Script for FiveM

-- Weather types available in FiveM
local weatherTypes = {
    "CLEAR", "EXTRASUNNY", "CLOUDS", "OVERCAST", "RAIN", "CLEARING", "THUNDER", 
    "SMOG", "FOGGY", "XMAS", "SNOWLIGHT", "BLIZZARD"
}

-- Default weather
local currentWeather = "CLEAR"

-- Function to change the weather
local function setWeather(weather)
    currentWeather = weather
    TriggerClientEvent("vfx:setWeather", -1, weather)
    TriggerClientEvent("chat:addMessage", -1, {
        args = {"TD Weather Control", "Weather has been changed to " .. weather}
    })
end

-- Register the weather change command
RegisterCommand("setweather", function(source, args, rawCommand)
    local player = source

    -- Check if player has required permissions (from Config)
    if not IsPlayerAceAllowed(player, Config.WeatherCommandPermission) then
        TriggerClientEvent("chat:addMessage", player, {
            args = {"TD Weather Control", "You do not have permission to use this command."}
        })
        return
    end

    -- Check if weather type is valid
    local weather = args[1] and args[1]:upper()
    local isValidWeather = false
    for _, wType in ipairs(weatherTypes) do
        if wType == weather then
            isValidWeather = true
            break
        end
    end

    if not isValidWeather then
        TriggerClientEvent("chat:addMessage", player, {
            args = {"TD Weather Control", "Invalid weather type. Available types: " .. table.concat(weatherTypes, ", ")}
        })
        return
    end

    -- Change the weather
    setWeather(weather)
end, false)
