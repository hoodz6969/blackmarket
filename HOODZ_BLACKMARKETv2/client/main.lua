local QBCore = exports['qb-core']:GetCoreObject()
local dealerPed = nil
local dealerBlip = nil
local activeTimer = nil
local dealerLocation = nil
local dealerInteraction = nil
local callerIdentifier = nil -- To track which player called the dealer

-- Function to set up payphone interactions
local function SetupPayphones()
    -- Add target to all payphone models
    exports['qb-target']:AddTargetModel(Config.PayphoneModels, {
        options = {
            {
                type = "client",
                event = "blackmarket:client:showPayphoneMenu",
                icon = "fas fa-phone",
                label = "Use Payphone",
            },
        },
        distance = 2.0
    })
end

-- Function to show payphone menu
RegisterNetEvent('blackmarket:client:showPayphoneMenu')
AddEventHandler('blackmarket:client:showPayphoneMenu', function()
    lib.registerContext({
        id = 'payphone_menu',
        title = 'Payphone',
        options = {
            {
                title = 'Make a Call',
                description = 'Contact the black market dealer',
                icon = 'phone',
                onSelect = function()
                    TriggerEvent('blackmarket:client:usePayphone')
                end
            },
            {
                title = 'Hang Up',
                description = 'Cancel the call',
                icon = 'times-circle',
                onSelect = function()
                    -- Just close the menu
                end
            }
        }
    })
    
    lib.showContext('payphone_menu')
end)

-- Function to select random dealer location
local function GetRandomDealerLocation()
    return Config.DealerLocations[math.random(#Config.DealerLocations)]
end

-- Function to create dealer
local function SpawnDealer()
    -- Select random ped model
    local pedModel = Config.DealerPeds[math.random(#Config.DealerPeds)]
    
    -- Request model
    RequestModel(GetHashKey(pedModel))
    
    while not HasModelLoaded(GetHashKey(pedModel)) do
        Wait(1)
    end
    
    -- Create ped at location
    dealerPed = CreatePed(4, GetHashKey(pedModel), dealerLocation.x, dealerLocation.y, dealerLocation.z, dealerLocation.h, true, false)
    SetBlockingOfNonTemporaryEvents(dealerPed, true)
    SetEntityAsMissionEntity(dealerPed, true, true)
    
    -- Make ped stand still
    TaskStandStill(dealerPed, -1)
    SetPedKeepTask(dealerPed, true)
    
    -- Add blip
    dealerBlip = AddBlipForEntity(dealerPed)
    SetBlipSprite(dealerBlip, 280) -- Person blip
    SetBlipColour(dealerBlip, 1)
    SetBlipScale(dealerBlip, 0.8)
    SetBlipAsShortRange(dealerBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Black Market Dealer")
    EndTextCommandSetBlipName(dealerBlip)
    
    -- Store caller identifier
    callerIdentifier = QBCore.Functions.GetPlayerData().citizenid
    
    -- Debug notification
    QBCore.Functions.Notify("Dealer has arrived. Look for the blip on your map.", "success")
    
    -- Set up ox_lib interaction with the dealer
    SetupDealerInteraction()
    
    -- Set a timer to clean up if player doesn't interact
    SetTimeout(60000 * Config.TimeLimit, function()
        if dealerPed ~= nil then
            TriggerEvent("blackmarket:client:cleanupDealer")
        end
    end)
end

-- Function to set up ox_lib interaction with the dealer
function SetupDealerInteraction()
    Citizen.CreateThread(function()
        while dealerPed ~= nil and DoesEntityExist(dealerPed) do
            local coords = GetEntityCoords(dealerPed)
            
            -- Create the interaction point
            dealerInteraction = lib.points.new({
                coords = coords,
                distance = 3.0,
                onEnter = function()
                    -- Only show interaction to the player who called
                    if QBCore.Functions.GetPlayerData().citizenid == callerIdentifier then
                        lib.showTextUI('[E] Talk to Dealer', {
                            position = "right-center",
                            icon = 'fas fa-shopping-bag',
                        })
                    end
                end,
                onExit = function()
                    lib.hideTextUI()
                end,
                nearby = function(self)
                    -- Check for E key press when nearby (only for caller)
                    if IsControlJustPressed(0, 38) and QBCore.Functions.GetPlayerData().citizenid == callerIdentifier then
                        TriggerEvent("blackmarket:client:openDealerMenu")
                    end
                end
            })
            
            -- Only need to set up once
            break
        end
    end)
end

-- Function to clean up dealer
local function CleanupDealer()
    if dealerInteraction then
        dealerInteraction:remove()
        dealerInteraction = nil
        lib.hideTextUI()
    end
    
    if DoesEntityExist(dealerPed) then
        DeleteEntity(dealerPed)
    end
    
    if dealerBlip ~= nil then
        RemoveBlip(dealerBlip)
    end
    
    dealerPed = nil
    dealerBlip = nil
    dealerLocation = nil
    callerIdentifier = nil
    
    if activeTimer ~= nil then
        activeTimer = nil
    end
end

-- Event to use payphone
RegisterNetEvent('blackmarket:client:usePayphone')
AddEventHandler('blackmarket:client:usePayphone', function()
    local hasItem = QBCore.Functions.HasItem(Config.RequiredItem)
    
    if not hasItem then
        QBCore.Functions.Notify(Config.Notifications.NoItem, "error")
        return
    end
    
    if dealerPed ~= nil then
        QBCore.Functions.Notify("You already have an active contact.", "error")
        return
    end
    
    -- Play phone animation
    local ped = PlayerPedId()
    local animDict = "anim@cellphone@in_car@ps"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end
    TaskPlayAnim(ped, animDict, "cellphone_text_in", 8.0, -8, -1, 49, 0, false, false, false)
    
    -- Show calling dialog
    lib.progressBar({
        duration = 5000,
        label = 'Making a call...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = animDict,
            clip = 'cellphone_text_in',
        },
    })
    
    -- Stop animation
    StopAnimTask(ped, animDict, "cellphone_text_in", 1.0)
    
    -- Select random dealer location
    dealerLocation = GetRandomDealerLocation()
    
    -- Notify player
    QBCore.Functions.Notify(Config.Notifications.PhoneUsed, "success")
    QBCore.Functions.Notify(Config.Notifications.TimerStarted, "primary")
    
    -- Set waypoint
    SetNewWaypoint(dealerLocation.x, dealerLocation.y)
    
    -- Spawn dealer
    SpawnDealer()
    
    -- Start timer
    activeTimer = Config.TimeLimit * 60
    
    -- Timer countdown
    Citizen.CreateThread(function()
        while activeTimer > 0 and dealerPed ~= nil do
            activeTimer = activeTimer - 1
            if activeTimer <= 0 then
                QBCore.Functions.Notify(Config.Notifications.TimerExpired, "error")
                TriggerEvent("blackmarket:client:cleanupDealer")
            end
            Citizen.Wait(1000)
        end
    end)
end)

-- Event to open dealer menu
RegisterNetEvent('blackmarket:client:openDealerMenu')
AddEventHandler('blackmarket:client:openDealerMenu', function()
    -- Check if this is the player who called the dealer
    if QBCore.Functions.GetPlayerData().citizenid ~= callerIdentifier then
        return
    end
    
    -- Debug notification
    QBCore.Functions.Notify("Opening dealer menu...", "primary")
    
    local options = {}
    
    for _, item in ipairs(Config.BlackMarketItems) do
        table.insert(options, {
            title = item.label,
            description = "$" .. item.price,
            icon = 'tag',
            onSelect = function()
                TriggerEvent('blackmarket:client:purchaseItem', {
                    item = item.name,
                    price = item.price,
                    type = item.type
                })
            end
        })
    end
    
    -- Add a cancel option
    table.insert(options, {
        title = 'Cancel',
        icon = 'times-circle',
        onSelect = function()
            -- Just close the menu
        end
    })
    
    lib.registerContext({
        id = 'blackmarket_shop',
        title = 'Black Market Dealer',
        options = options
    })
    
    lib.showContext('blackmarket_shop')
end)

-- Event to purchase item
RegisterNetEvent('blackmarket:client:purchaseItem')
AddEventHandler('blackmarket:client:purchaseItem', function(data)
    TriggerServerEvent('blackmarket:server:purchaseItem', data.item, data.price, data.type)
    
    -- Start countdown for dealer to leave
    QBCore.Functions.Notify(Config.Notifications.DealerLeaving, "primary")
    
    -- Set timeout to remove dealer after 60 seconds
    SetTimeout(60000, function()
        TriggerEvent("blackmarket:client:cleanupDealer")
    end)
end)

-- Event to clean up dealer
RegisterNetEvent('blackmarket:client:cleanupDealer')
AddEventHandler('blackmarket:client:cleanupDealer', function()
    CleanupDealer()
end)

-- Initialize script
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        SetupPayphones()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    SetupPayphones()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        CleanupDealer()
    end
end)
