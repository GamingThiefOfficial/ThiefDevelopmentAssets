local currentWeather = 'CLEAR'
local nextChangeTime = 0

-- Function to set weather
function SetWeather(weatherType)
    currentWeather = weatherType
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist(weatherType)
    SetWeatherTypeNow(weatherType)
    SetWeatherTypeNowPersist(weatherType)
end

-- Function to apply effects (optional)
function ApplyWeatherEffects(weatherType)
    if weatherType == 'RAIN' or weatherType == 'THUNDER' then
        -- Example: Reduce player movement speed in rain/thunder
        Citizen.CreateThread(function()
            local player = PlayerPedId()
            while currentWeather == weatherType do
                Citizen.Wait(1000)
                SetPedMoveRateOverride(player, 0.8) -- Slower movement
            end
        end)
    elseif weatherType == 'EXTRASUNNY' then
        -- Example: Blurry vision for heatwave
        Citizen.CreateThread(function()
            while currentWeather == weatherType do
                Citizen.Wait(10000) -- Apply effect every 10 seconds
                StartScreenEffect("DrugsDrivingOut", 5000, false)
            end
        end)
    end
end

-- Main loop to change weather
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if GetGameTimer() > nextChangeTime then
            -- Pick random weather event
            local event = Config.WeatherEvents[math.random(#Config.WeatherEvents)]
            SetWeather(event.type)
            ApplyWeatherEffects(event.type)
            -- Set next change time
            nextChangeTime = GetGameTimer() + (event.duration * 60000) -- Convert minutes to ms
        end
    end
end)
