ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('nvq-tracker:setMarker')
AddEventHandler('nvq-tracker:setMarker', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

    if DoesEntityExist(vehicle) then
        local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
        local animName = "machinic_loop_mechandplayer"

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(100)
        end

        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)

        if Config.UseProgress then
            exports.rprogress:Start(TranslateCap('rprogress'), 5000)
        else 
            Citizen.Wait(5000)
        end

        StopAnimTask(playerPed, animDict, animName, 1.0)

        local plate = GetVehicleNumberPlateText(vehicle)
        local vehicleCoords = GetEntityCoords(vehicle)

        local blip = AddBlipForCoord(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
        SetBlipSprite(blip, Config.BlipSprite)
        SetBlipColour(blip, Config.BlipColour)
        SetBlipScale(blip, Config.BlipScale)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(TranslateCap('veh')..plate)
        EndTextCommandSetBlipName(blip)

        ESX.ShowNotification(TranslateCap('suc')..plate)

        Citizen.CreateThread(function()
            local lastCoords = vehicleCoords
            while DoesEntityExist(vehicle) do
                lastCoords = GetEntityCoords(vehicle)
                SetBlipCoords(blip, lastCoords.x, lastCoords.y, lastCoords.z)
                Citizen.Wait(1000)
            end

            SetBlipCoords(blip, lastCoords.x, lastCoords.y, lastCoords.z)
            SetBlipColour(blip, 1)  
            SetBlipAlpha(blip, 255)

            ESX.ShowNotification(TranslateCap('err'))

            Citizen.Wait(Config.DeletedTime) 

            RemoveBlip(blip)
        end)

        TriggerServerEvent('nvq-tracker:removeGPS')
    else
        ESX.ShowNotification(TranslateCap('no_veh'))
    end
end)
