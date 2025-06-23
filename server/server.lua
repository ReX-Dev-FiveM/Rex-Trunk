local Framework
Citizen.CreateThread(function()
    if Config.Framework == "ESX" then
        Framework = exports["es_extended"]:getSharedObject()
    elseif Config.Framework == "QBCore" then
        Framework = exports['qb-core']:GetCoreObject()
    end
end)
local stashSlots = Config.StashSlots
local stashWeight = Config.StashWeight
RegisterNetEvent('vehicleStash:registerStash')
AddEventHandler('vehicleStash:registerStash', function(plate)
    local stashName = 'maletero_' .. plate
    local playerId = source
    exports.ox_inventory:RegisterStash(
        stashName, 
        "Maletero del Vehículo [" .. plate .. "]", 
        stashSlots, 
        stashWeight
    )
    TriggerClientEvent('vehicleStash:openStashOnClient', playerId, stashName)
end)
