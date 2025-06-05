Config = {}

-- Discord Webhook
Config.WebhookURL = "https://discordapp.com/api/webhooks/1374632134655873135/Mo89gvXGooHhUWYYS3hbGgjQyYMUjDOh1688QTCAxyvjnur-V2ciEKI5Z8nK7TQnp6T0"

Config.Commands = {
    SetDepartment = "setdepartment",
    StartShift = "startshift",
    EndShift = "endshift"
}

Config.Embed = {
    StartShift = {
        Title = "Shift Started",
        Color = 65280 -- Green
    },
    EndShift = {
        Title = "Shift Ended",
        Color = 16711680 -- Red
    },
    FooterText = "TD Scripts Beta V1.0"
}
