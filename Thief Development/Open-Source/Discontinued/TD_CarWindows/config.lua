Config = Config or {}

-- Define keybinds and commands that players can change via FiveM settings
Config.WindowKeys = {
    { command = "roll_window_0", index = 0, defaultKey = "F1" },  -- F1 for front left window
    { command = "roll_window_1", index = 1, defaultKey = "F2" },  -- F2 for front right window
    { command = "roll_window_2", index = 2, defaultKey = "F3" },  -- F3 for back left window
    { command = "roll_window_3", index = 3, defaultKey = "F4" },  -- F4 for back right window
}

Config.Debug = true  -- Enable debugging to see window events in the console
Config.AllowedVehicles = {}  -- List of vehicle models where window rolling is enabled
