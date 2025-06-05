local activeShifts = {}
local playerDepartments = {}

local function getDiscordID(source)
    for _, v in ipairs(GetPlayerIdentifiers(source)) do
        if v:find("discord:") then
            return v:gsub("discord:", "")
        end
    end
    return nil
end

local function sendEmbed(embed)
    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end,
        "POST",
        json.encode({embeds = embed}),
        {["Content-Type"] = "application/json"}
    )
end

-- Set Department command
RegisterCommand(Config.Commands.SetDepartment, function(source, args)
    if #args == 0 then
        TriggerClientEvent('chat:addMessage', source, { args = {"System", "Usage: /setdepartment [Department Name]"} })
        return
    end

    local department = table.concat(args, " ")
    playerDepartments[source] = department

    TriggerClientEvent('chat:addMessage', source, { args = {"System", "Department set to: " .. department} })
end)

-- Start Shift command
RegisterCommand(Config.Commands.StartShift, function(source)
    local name = GetPlayerName(source)
    local discordID = getDiscordID(source)
    if not discordID then return end

    local date = os.date("%m-%d-%Y")
    local time = os.date("%H:%M:%S")
    local mention = "<@" .. discordID .. ">"
    local department = playerDepartments[source] or "Unknown"

    activeShifts[source] = os.time()

    local embed = {{
        title = Config.Embed.StartShift.Title,
        color = Config.Embed.StartShift.Color,
        fields = {
            {name = "Player", value = name, inline = true},
            {name = "Discord", value = mention, inline = true},
            {name = "Department", value = department, inline = true},
            {name = "Date", value = date, inline = true},
            {name = "Start Time", value = time, inline = true}
        },
        footer = {text = Config.Embed.FooterText},
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }}

    sendEmbed(embed)
end)

-- End Shift command
RegisterCommand(Config.Commands.EndShift, function(source)
    local name = GetPlayerName(source)
    local startTime = activeShifts[source]
    if not startTime then
        TriggerClientEvent('chat:addMessage', source, { args = {"System", "You didn't start a shift."} })
        return
    end

    local discordID = getDiscordID(source)
    if not discordID then return end

    local date = os.date("%m-%d-%Y")
    local endTime = os.time()
    local duration = os.difftime(endTime, startTime)
    local hours = math.floor(duration / 3600)
    local minutes = math.floor((duration % 3600) / 60)
    local seconds = duration % 60
    local totalTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)

    local startStr = os.date("%H:%M:%S", startTime)
    local endStr = os.date("%H:%M:%S", endTime)
    local mention = "<@" .. discordID .. ">"
    local department = playerDepartments[source] or "Unknown"

    local embed = {{
        title = Config.Embed.EndShift.Title,
        color = Config.Embed.EndShift.Color,
        fields = {
            {name = "Player", value = name, inline = true},
            {name = "Discord", value = mention, inline = true},
            {name = "Department", value = department, inline = true},
            {name = "Date", value = date, inline = true},
            {name = "Start Time", value = startStr, inline = true},
            {name = "End Time", value = endStr, inline = true},
            {name = "Total Duration", value = totalTime, inline = true}
        },
        footer = {text = Config.Embed.FooterText},
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }}

    sendEmbed(embed)
    activeShifts[source] = nil
end)

AddEventHandler("playerDropped", function(reason)
    local src = source
    local name = GetPlayerName(src)
    local startTime = activeShifts[src]
    if not startTime then return end

    local discordID = getDiscordID(src)
    if not discordID then return end

    local date = os.date("%m-%d-%Y")
    local endTime = os.time()
    local duration = os.difftime(endTime, startTime)
    local hours = math.floor(duration / 3600)
    local minutes = math.floor((duration % 3600) / 60)
    local seconds = duration % 60
    local totalTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)

    local startStr = os.date("%H:%M:%S", startTime)
    local endStr = os.date("%H:%M:%S", endTime)
    local mention = "<@" .. discordID .. ">"
    local department = playerDepartments[src] or "Unknown"

    local readableReason = interpretDisconnectReason(reason)

    local embed = {{
        title = Config.Embed.EndShift.Title .. " (Auto)",
        color = Config.Embed.EndShift.Color,
        fields = {
            {name = "Player", value = name, inline = true},
            {name = "Discord", value = mention, inline = true},
            {name = "Department", value = department, inline = true},
            {name = "Date", value = date, inline = true},
            {name = "Start Time", value = startStr, inline = true},
            {name = "End Time", value = endStr, inline = true},
            {name = "Total Duration", value = totalTime, inline = true},
            {name = "Disconnect Reason", value = readableReason, inline = true}
        },
        footer = {text = Config.Embed.FooterText},
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }}

    sendEmbed(embed)
    activeShifts[src] = nil
end)


