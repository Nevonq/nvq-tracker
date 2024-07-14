ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterUsableItem('gps_tracker', function(source)
    -- local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('nvq-tracker:setMarker', source)
end)

RegisterNetEvent('nvq-tracker:removeGPS')
AddEventHandler('nvq-tracker:removeGPS', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('gps_tracker', 1)
end)
