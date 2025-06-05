Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Wait for 1 second after server starts
    if _G ~= nil and type(_G) == "table" then
        print('^2 TD_HeadlightDamage ^0 is live and running!') -- Edit this
    else
        print('^1ERROR: ^0_G is a null pointer reference!')
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Wait for 1 second after server starts
    if pcall(function() print([[
        ___________.__    .__        _____ 
        \__    ___/|  |__ |__| _____/ ____\
          |    |   |  |  \|  |/ __ \   __\ 
          |    |   |   Y  \  \  ___/|  |   
          |____|   |___|  /__|\___  >__|   
                        \/        \/                  
    ]]) end) then
    else
        print('^1ERROR: ^0Could not print the ASCII art!')
    end
end)