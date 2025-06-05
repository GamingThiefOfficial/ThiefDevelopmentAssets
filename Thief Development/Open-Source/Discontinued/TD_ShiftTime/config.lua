Config = {}

-- Discord Webhook
Config.Webhook = "https://discordapp.com/api/webhooks/1374632134655873135/Mo89gvXGooHhUWYYS3hbGgjQyYMUjDOh1688QTCAxyvjnur-V2ciEKI5Z8nK7TQnp6T0"

-- Key to press at the shift marker (E = 38)
Config.ShiftKey = 38

-- Shift start/end locations using vector3()
Config.ShiftLocations = {
    { coords = vector3(440.0, -975.0, 30.7), radius = 2.0 },
    { coords = vector3(1853.0, 3689.0, 34.2), radius = 2.0 }
}
-- Embed Config
Config.Embed = {
    StartTitle = "🚨 Shift Started",
    EndTitle = "💼 Shift Ended",
    ColorStart = 65280,
    ColorEnd = 16711680,
    Footer = "TD Testing Server | If you see this, Ignore."
}
