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

        -- Play the animation
        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)
        -- Wait for the animation to complete (adjust timing as necessary)
        if Config.UseProgress then
            exports.rprogress:Start(_U('rprogress'), 5000)

        end

        -- Citizen.Wait(5000)

        -- Stop the animation
        StopAnimTask(playerPed, animDict, animName, 1.0)

        local plate = GetVehicleNumberPlateText(vehicle)
        local vehicleCoords = GetEntityCoords(vehicle)
        local blip =  AddBlipForCoord(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
        SetBlipSprite(blip, Config.BlipSprite)  -- Change the blip icon to a car
        SetBlipColour(blip, Config.BlipColour)    -- Change the blip color, e.g., blue
        SetBlipScale(blip, Config.BlipScale)   -- Set the blip scale
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('<font face=\'Roboto\'>'.._U('veh')..plate)
        EndTextCommandSetBlipName(blip)
        ESX.ShowNotification(_U('suc')..plate)
 

           -- Monitor the vehicle
           Citizen.CreateThread(function()
            local lastCoords = vehicleCoords
            while DoesEntityExist(vehicle) do
                lastCoords = GetEntityCoords(vehicle)
                Citizen.Wait(1000)
            end

            -- Vehicle deleted, update the blip
        -- local lastCoords = GetEntityCoords(vehicle)
            SetBlipCoords(blip, lastCoords.x, lastCoords.y, lastCoords.z)
            SetBlipColour(blip, 1)  
            SetBlipAlpha(blip, 255)

            ESX.ShowNotification(_U('err'))

            Citizen.Wait(Config.DeletedTime)  -- Wait

            -- Delete the blip
            RemoveBlip(blip)
        end)



		TriggerServerEvent('nvq-tracker:removeGPS')

    else
        ESX.ShowNotification(_U('no_veh'))
    end
end)

