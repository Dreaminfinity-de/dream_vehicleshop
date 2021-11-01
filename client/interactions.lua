
isInInteractionArea = false
interactionArea     = nil
interactionPart     = nil
interactionMSG     = nil
HasAlreadyEnteredInteractionArea = false


--- Entering / Exiting Interaction Area
Citizen.CreateThread(function()
    local continue = true

    local lastInteractionArea     = nil
    local lastInteractionPart     = nil

    while continue do
        Citizen.Wait(250)

        continue = false

        local isIn  = false
        local area  = nil
        local part  = nil
        local MSG   = nil

		local playerPed = PlayerPedId()
		local PlayerCoords    = GetEntityCoords(playerPed)

        for i, v in ipairs(Config.Cardealer) do
            continue = true
            local distance  = GetDistanceBetweenCoords(PlayerCoords, v.cardealer.pos, true)
            if distance <= (v.cardealer.radius or 2) then
                isIn = true
                area = v.id
                part = 'cardealer'
                MSG = _U('help_notification_cardealer')
                break
            end
        end

        if isIn and not HasAlreadyEnteredInteractionArea then


            HasAlreadyEnteredInteractionArea = true

            lastInteractionArea = area
            lastInteractionPart = part

            isInInteractionArea = true
            interactionArea     = area
            interactionPart     = part
            interactionMSG      = MSG
            TriggerEvent('dream_vehicleshop:hasEnteredInteractionArea', area, part)
        end

        if not isIn and HasAlreadyEnteredInteractionArea then
            HasAlreadyEnteredInteractionArea = false
            isInInteractionArea = false
            interactionArea     = nil
            interactionPart     = nil
            interactionMSG      = nil

            TriggerEvent('dream_vehicleshop:hasExitedInteractionArea', area, part)
        end

    end
end)


Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)

        if interactionPart ~= nil then

            ESX.ShowHelpNotification(interactionMSG)

            if IsControlJustReleased(0, Config.KeyControle) then

                if interactionPart == 'cardealer' then
                    Citizen.CreateThread(function()
                        openCardealerMenu()
                    end)
                end

                interactionPart = nil
            end
        end
    end
end)