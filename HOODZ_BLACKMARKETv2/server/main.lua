local QBCore = exports['qb-core']:GetCoreObject()

-- Event to handle item purchase
RegisterNetEvent('blackmarket:server:purchaseItem')
AddEventHandler('blackmarket:server:purchaseItem', function(item, price, itemType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Check if player has enough money
    if Player.Functions.GetMoney('cash') < price then
        TriggerClientEvent('QBCore:Notify', src, "You don't have enough cash.", "error")
        return
    end
    
    -- Remove money
    Player.Functions.RemoveMoney('cash', price)
    
    -- Add item based on type
    if itemType == "weapon" then
        Player.Functions.AddItem(item, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
    elseif itemType == "item" then
        Player.Functions.AddItem(item, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
    end
    
    TriggerClientEvent('QBCore:Notify', src, Config.Notifications.PurchaseSuccess, "success")
end)
