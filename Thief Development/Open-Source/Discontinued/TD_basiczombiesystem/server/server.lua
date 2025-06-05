local QBCore = exports['qb-core']:GetCoreObject()

-- Crafting System: Craft items based on Config
RegisterNetEvent('zombie:craftItem')
AddEventHandler('zombie:craftItem', function(item)
    local recipe = Config.CraftingRecipes[item]

    if recipe then
        local hasIngredients = true
        for _, ingredient in pairs(recipe.ingredients) do
            if not exports['qb-inventory']:hasItem(ingredient) then
                hasIngredients = false
                break
            end
        end

        if hasIngredients then
            -- Remove ingredients from player
            for _, ingredient in pairs(recipe.ingredients) do
                TriggerEvent('qb-inventory:removeItem', ingredient)
            end
            -- Give crafted item
            TriggerEvent('qb-inventory:addItem', recipe.result)
            TriggerEvent("chat:addMessage", { args = { "^2[Crafting] You crafted: " .. recipe.result .. " (" .. recipe.description .. ")" } })
        else
            TriggerEvent("chat:addMessage", { args = { "^1[Crafting] You don't have enough materials!" } })
        end
    else
        TriggerEvent("chat:addMessage", { args = { "^1[Crafting] Invalid item recipe!" } })
    end
end)
