local currentWeather = 'CLEAR'

-- Event to sync weather changes
RegisterServerEvent('TD_WeatherEvents:ChangeWeather')
AddEventHandler('TD_WeatherEvents:ChangeWeather', function(weatherType, duration)
    currentWeather = weatherType
    TriggerClientEvent('TD_WeatherEvents:UpdateWeather', -1, weatherType, duration)
end)

-- Request current weather for new players
RegisterServerEvent('TD_WeatherEvents:RequestWeather')
AddEventHandler('TD_WeatherEvents:RequestWeather', function()
    local src = source
    TriggerClientEvent('TD_WeatherEvents:UpdateWeather', src, currentWeather, 0)
end)
