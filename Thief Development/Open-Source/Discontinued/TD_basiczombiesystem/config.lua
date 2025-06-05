Config = {}

-- Zombie AI Settings
Config.ZombieSpawns = {
    vector3(232.1, -1565.9, 29.9),
    vector3(-1335.6, 4694.8, 49.8),
    vector3(1741.2, 3312.7, 41.5),
    vector3(-232.4, 2535.8, 45.0)
}

-- Infection System Settings
Config.InfectionTimer = 300 -- Time (in seconds) before player turns into a zombie (5 minutes)
Config.CureItem = "antidote" -- Item required to cure the infection

-- Crafting Recipes: Define new crafting recipes here
Config.CraftingRecipes = {
    ["health_pack"] = { 
        ingredients = { "bandage", "water" }, 
        result = "medkit", 
        description = "Craft a health pack from a bandage and water." 
    },
    ["ammo"] = { 
        ingredients = { "scrap_metal", "gunpowder" }, 
        result = "ammo_pack", 
        description = "Craft ammo using scrap metal and gunpowder." 
    },
    -- Example: Adding a new recipe for crafting a weapon
    ["shotgun_shells"] = {
        ingredients = { "scrap_metal", "gunpowder", "shotgun_parts" },
        result = "shotgun_shells",
        description = "Craft shotgun shells with scrap metal, gunpowder, and shotgun parts."
    },
    -- Add more recipes below
}

-- Day/Night Cycle Settings
Config.NightStart = 18  -- Hour when night starts (18 = 6:00 PM)
Config.NightEnd = 6     -- Hour when night ends (6 = 6:00 AM)

-- Safe Zones
Config.SafeZones = {
    { x = 200.1, y = -1350.5, z = 30.5 },
    { x = -1325.5, y = 4722.9, z = 45.3 }
}
