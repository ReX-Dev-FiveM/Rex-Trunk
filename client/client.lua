local Framework
local stashDistance = Config.StashDistance

-- Framework detection
Citizen.CreateThread(function()
    if Config.Framework == "ESX" then
        Framework = exports["es_extended"]:getSharedObject()
    elseif Config.Framework == "QBCore" then
        Framework = exports['qb-core']:GetCoreObject()
    end
end)

local function abrirMaletero()
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), stashDistance, 0, 71)
    if vehicle and DoesEntityExist(vehicle) then
        local plate = GetVehicleNumberPlateText(vehicle)
        local lockStatus = GetVehicleDoorLockStatus(vehicle)
        if lockStatus == 2 then 
            if Config.Framework == "ESX" then
                Framework.ShowNotification("~r~El vehículo está cerrado. No puedes abrir el maletero.")
            elseif Config.Framework == "QBCore" then
                Framework.Functions.Notify("El vehículo está cerrado. No puedes abrir el maletero.", "error")
            end
            return
        end
        TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
        Citizen.Wait(2000)
        ClearPedTasksImmediately(playerPed)
        TriggerServerEvent('vehicleStash:registerStash', plate)
    else
        if Config.Framework == "ESX" then
            Framework.ShowNotification("~r~No estás cerca de un vehículo.")
        elseif Config.Framework == "QBCore" then
            Framework.Functions.Notify("No estás cerca de un vehículo.", "error")
        end
    end
end

RegisterNetEvent('vehicleStash:openStashOnClient')
AddEventHandler('vehicleStash:openStashOnClient', function(stashName)
    TriggerEvent('ox_inventory:openInventory', 'stash', stashName)
end)

RegisterCommand(Config.Command, function()
    abrirMaletero()
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 244) then -- M
            ExecuteCommand(Config.Command)
        end
    end
end)
