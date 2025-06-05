-- Configuration
local zombieModels = {
    "a_m_y_tattoocust_01", -- Add zombie ped models here
}

local spawnRadius = 50.0 -- Radius around the player where zombies spawn
local zombieSpawnInterval = 5000 -- Time interval (in milliseconds) for spawning zombies
local maxZombies = 15 -- Maximum number of zombies to spawn near each player

local zombies = {} -- Keeps track of zombie entities

-- Disable all NPCs and normal traffic
Citizen.CreateThread(function()
    while true do
        -- Disable ped and vehicle generation
        SetPedDensityMultiplierThisFrame(0.0)
        SetVehicleDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)

        -- Clear random events
        SetGarbageTrucks(false)
        SetRandomBoats(false)
        ClearAreaOfPeds(PlayerPedId(), 1000.0, 1)

        Citizen.Wait(0) -- Run every frame
    end
end)

-- Spawn zombies near players
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        -- Check how many zombies are already spawned
        if #zombies < maxZombies then
            for i = 1, (maxZombies - #zombies) do
                SpawnZombie(playerCoords)
            end
        end

        Citizen.Wait(zombieSpawnInterval) -- Wait before spawning more zombies
    end
end)

-- Function to spawn a zombie near the player
function SpawnZombie(playerCoords)
    local zombieModel = GetHashKey(zombieModels[math.random(#zombieModels)])
    
    -- Load the zombie model
    RequestModel(zombieModel)
    while not HasModelLoaded(zombieModel) do
        Citizen.Wait(10)
    end

    -- Generate random spawn location near the player
    local spawnX = playerCoords.x + math.random(-spawnRadius, spawnRadius)
    local spawnY = playerCoords.y + math.random(-spawnRadius, spawnRadius)
    local spawnZ = playerCoords.z + 1.0
    local spawnCoords = vector3(spawnX, spawnY, spawnZ)

    -- Ensure the spawn location is on ground
    local ground, groundZ = GetGroundZFor_3dCoord(spawnX, spawnY, spawnZ, 1)
    if ground then
        spawnCoords = vector3(spawnX, spawnY, groundZ)
    end

    -- Create the zombie ped
    local zombie = CreatePed(4, zombieModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, false)
    SetEntityAsMissionEntity(zombie, true, true)
    SetPedRelationshipGroupDefaultHash(zombie, GetHashKey("HATES_PLAYER"))
    SetPedRelationshipGroupHash(zombie, GetHashKey("HATES_PLAYER"))
    SetPedCombatAttributes(zombie, 46, true) -- Make them always fight
    SetPedFleeAttributes(zombie, 0, 0)
    SetPedCombatRange(zombie, 2)
    SetPedCombatMovement(zombie, 3)
    SetPedAccuracy(zombie, 15)

    -- Add zombie to tracking table
    table.insert(zombies, zombie)

    -- Remove zombie when killed
    Citizen.CreateThread(function()
        while DoesEntityExist(zombie) and not IsEntityDead(zombie) do
            Citizen.Wait(1000)
        end

        -- Cleanup after death
        DeleteEntity(zombie)
        for i = #zombies, 1, -1 do
            if zombies[i] == zombie then
                table.remove(zombies, i)
                break
            end
        end
    end)
end
