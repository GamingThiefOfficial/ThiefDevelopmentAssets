-- Event to send all disabled areas to clients
RegisterNetEvent('sendDisabledAreas')
AddEventHandler('sendDisabledAreas', function()
    local src = source
    TriggerClientEvent('receiveDisabledAreas', src, disabledAreas)
end)

-- Command to dynamically add a new disabled area
RegisterCommand('addDisabledArea', function(source, args)
    if source == 0 then -- Console command
        local x, y, z, radius = tonumber(args[1]), tonumber(args[2]), tonumber(args[3]), tonumber(args[4])
        if x and y and z and radius then
            table.insert(disabledAreas, {x = x, y = y, z = z, radius = radius})
            print("Added new disabled area at:", x, y, z, "with radius:", radius)
        else
            print("Invalid arguments! Use: /addDisabledArea [x] [y] [z] [radius]")
        end
    else
        print("This command can only be run from the server console.")
    end
end, true)
