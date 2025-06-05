local QBCore = exports['qb-core']:GetCoreObject()

-- List of possible zombie models
local zombieModels = {
    "a_m_m_farmer_01",
    "a_m_m_genstreet_01",
    "a_m_m_business_01",
    "a_m_m_downtown_01",
    "a_m_m_hipster_01",
    "s_m_m_highsec_01",
    "s_m_y_chef_01"
}

-- Function to spawn zombies at valid ground locations
function spawnZombieEverywhere()
    local maxZombies = 50  -- Limit the number of active zombies
    local spawnedZombies = {}  -- Keep track of zombies

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(math.random(5000, 10000))  -- Random interval between 5 and 10 seconds

            -- Check if the zombie limit has been reached
            if #spawnedZombies >= maxZombies then
                Citizen.Wait(1000)  -- Pause if too many zombies are active
                goto continue
            end

            -- Generate a random spawn location near the player
            local playerCoords = GetEntityCoords(PlayerPedId())
            local offsetX = math.random(-50, 50)  -- Spawn within 50 units around the player
            local offsetY = math.random(-50, 50)
            local spawnX = playerCoords.x + offsetX
            local spawnY = playerCoords.y + offsetY
            local spawnZ = playerCoords.z + 50.0  -- Start above ground level to ensure proper placement

            -- Find the ground level
            local foundGround, groundZ = GetGroundZFor_3dCoord(spawnX, spawnY, spawnZ, false)
            if not foundGround then goto continue end  -- Skip if ground isn't found

            -- Randomly select a zombie model
            local randomZombieModel = zombieModels[math.random(#zombieModels)]

            -- Request and load the zombie model
            RequestModel(randomZombieModel)
            while not HasModelLoaded(randomZombieModel) do
                Citizen.Wait(100)
            end

            -- Create the zombie and set its properties
            local zombie = CreatePed(4, randomZombieModel, spawnX, spawnY, groundZ, 0.0, true, false)
            SetEntityAsMissionEntity(zombie, true, true)
            SetPedAsEnemy(zombie, true)
            SetEntityHealth(zombie, 100)  -- Set the zombie's health
            TaskWanderStandard(zombie, 1.0, 10)  -- Make the zombie wander initially
            TaskCombatPed(zombie, PlayerPedId(), 0, 16)  -- Zombies will attack the player when close

            -- Add the zombie to the tracking list
            table.insert(spawnedZombies, zombie)

            -- Clean up zombie if it dies or is too far from the player
            Citizen.CreateThread(function()
                while DoesEntityExist(zombie) do
                    Citizen.Wait(1000)
                    if IsEntityDead(zombie) or #(GetEntityCoords(zombie) - playerCoords) > 200.0 then
                        DeleteEntity(zombie)
                        for i, z in ipairs(spawnedZombies) do
                            if z == zombie then
                                table.remove(spawnedZombies, i)
                                break
                            end
                        end
                        break
                    end
                end
            end)

            ::continue::
        end
    end)
end

-- Start spawning zombies everywhere
spawnZombieEverywhere()
