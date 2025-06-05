local activeShifts = {}
local departments = {}

RegisterServerEvent("shift:setDepartment")
AddEventHandler("shift:setDepartment", function(department)
    departments[source] = department
end)

RegisterServerEvent("shift:start")
AddEventHandler("shift:start", function(location)
    local src = source
    if activeShifts[src] then return end

    local name = GetPlayerName(src)
    local discord = getDiscordID(src)
    if not discord then return end

    local time = os.time()
    activeShifts[src] = {start = time, location = location}
    local dept = departments[src] or "Unknown"

    sendEmbed({
        title = Config.Embed.StartTitle,
        color = Config.Embed.ColorStart,
        fields = {
            {name = "Player", value = name, inline = true},
            {name = "Discord", value = "<@" .. discord .. ">", inline = true},
            {name = "Department", value = dept, inline = true},
            {name = "Date", value = os.date("%m-%d-%Y", time), inline = true},
            {name = "Start Time", value = os.date("%H:%M:%S", time), inline = true}
        }
    })

    TriggerClientEvent("shift:setState", src, true)
end)

RegisterServerEvent("shift:end")
AddEventHandler("shift:end", function()
    local src = source
    local shift = activeShifts[src]
    if not shift then return end

    local endTime = os.time()
    local duration = os.difftime(endTime, shift.start)
    local name = GetPlayerName(src)
    local discord = getDiscordID(src)
    local dept = departments[src] or "Unknown"

    local hours = math.floor(duration / 3600)
    local mins = math.floor((duration % 3600) / 60)
    local secs = duration % 60

    sendEmbed({
    title = Config.Embed.EndTitle,
    color = Config.Embed.ColorEnd,
    fields = {
        {name = "Player", value = name, inline = true},
        {name = "Discord", value = "<@" .. discord .. ">", inline = true},
        {name = "Department", value = dept, inline = true},
        {name = "Start Time", value = os.date("%H:%M:%S", shift.start), inline = true},
        {name = "End Time", value = os.date("%H:%M:%S", endTime), inline = true},
        {name = "Total Time", value = string.format("%02dh %02dm %02ds", hours, mins, secs), inline = true}
    }
})


    activeShifts[src] = nil
    TriggerClientEvent("shift:setState", src, false)
end)
    -- Auto-end shift on disconnect/crash
AddEventHandler("playerDropped", function(reason)
    local src = source
    if activeShifts[src] then
        local shift = activeShifts[src]
        local endTime = os.time()
        local duration = os.difftime(endTime, shift.start)
        local name = GetPlayerName(src)
        local discord = getDiscordID(src)
        local dept = departments[src] or "Unknown"

        local hours = math.floor(duration / 3600)
        local mins = math.floor((duration % 3600) / 60)
        local secs = duration % 60

        sendEmbed({
    title = Config.Embed.EndTitle,
    color = Config.Embed.ColorEnd,
    fields = {
        {name = "Player", value = name, inline = true},
        {name = "Discord", value = "<@" .. discord .. ">", inline = true},
        {name = "Department", value = dept, inline = true},
        {name = "Start Time", value = os.date("%H:%M:%S", shift.start), inline = true},
        {name = "End Time", value = os.date("%H:%M:%S", endTime), inline = true},
        {name = "Total Time", value = string.format("%02dh %02dm %02ds", hours, mins, secs), inline = true}
    }
})


        activeShifts[src] = nil
    end
end)

RegisterNetEvent("shift:getState")
AddEventHandler("shift:getState", function()
    local src = source
    local isActive = activeShifts[src] ~= nil
    TriggerClientEvent("shift:setState", src, isActive)
end)

function getDiscordID(src)
    for _, id in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(id, 1, 8) == "discord:" then
            return string.sub(id, 9)
        end
    end
    return nil
end

function sendEmbed(data)
    local embed = {
        {
            title = data.title,
            color = data.color,
            fields = data.fields,
            footer = { text = Config.Embed.Footer },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }

    PerformHttpRequest(Config.WebhookURL, function() end, "POST", json.encode({embeds = embed}), {["Content-Type"] = "application/json"})
end
