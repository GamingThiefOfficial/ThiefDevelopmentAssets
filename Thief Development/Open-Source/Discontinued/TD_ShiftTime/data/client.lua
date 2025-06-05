local inZone = false
local curZone = nil

RegisterCommand("endshift", function()
    TriggerServerEvent("shift:end")
end)

RegisterCommand("setdepartment", function(_, args)
    local department = table.concat(args, " ")
    if department ~= "" then
        TriggerServerEvent("shift:setDepartment", department)
    end
end)

CreateThread(function()
    while true do
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        inZone = false

        for _, loc in pairs(Config.ShiftPoints) do
            local dist = #(coords - loc.coords)
            if dist < 2.5 then
                inZone = true
                curZone = loc
                DrawText3D(loc.coords, "[E] Start Shift at " .. loc.label)
                if IsControlJustReleased(0, Config.InteractKey) then
                    TriggerServerEvent("shift:start", loc.label)
                end
                break
            end
        end

        Wait(inZone and 0 or 1000)
    end
end)

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - coords)
    local scale = (1 / dist) * 1.5 * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local width = string.len(text) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + width, 0.03, 41, 11, 41, 100)
    end
end
