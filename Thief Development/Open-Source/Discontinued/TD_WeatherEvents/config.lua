Config = {}

-- Time in milliseconds between weather changes (e.g., 10 minutes = 600000 ms)
Config.WeatherChangeInterval = 600000 

-- List of weather events with optional effects
Config.WeatherEvents = {
    {type = 'RAIN', duration = 5},          -- Rain for 5 minutes
    {type = 'CLEAR', duration = 10},        -- Clear skies for 10 minutes
    {type = 'FOGGY', duration = 7},         -- Fog for 7 minutes
    {type = 'THUNDER', duration = 6},       -- Thunderstorm for 6 minutes
    {type = 'EXTRASUNNY', duration = 10},   -- Heatwave with extra sun
}
