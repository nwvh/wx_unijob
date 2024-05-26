function fixCar(veh)
    local vehW = GetEntityHeading(veh)
    local vehC = GetEntityCoords(veh)
    SetVehicleDoorOpen(veh, 4, false, false)
    local newCoords = GetOffsetFromEntityInWorldCoords(veh, 0.0, 2.5, 0.0)
    local oldCoords = GetEntityCoords(PlayerPedId())
    TaskGoStraightToCoord(PlayerPedId(), newCoords.x, newCoords.y, newCoords.z, 1, -1, vehW - 180, oldCoords)

    while true do
        Wait(0)
        local dist = #(newCoords.xy - GetEntityCoords(PlayerPedId()).xy)
        if dist <= 0.5 then
            break
        end
    end

    if lib.progressBar({
            duration = 5000,
            label = 'Repairing vehicle',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped'
            },
        }) then
        wx.Client.Notify("Mechanic", "Vehicle was repaired", "success", 5000)
        SetVehicleFixed(veh)
        SetVehicleDeformationFixed(veh)
        SetVehicleUndriveable(veh, false)
        SetVehicleEngineOn(vehicle, true, true)
        lib.callback.await("wx_unijob:crafting:removeItem", false, wx.Client.repairItem, 1)
    end
end

local options = {
    {
        name = 'wx_unijob:repair:target',
        icon = "fas fa-car",
        distance = 2.0,
        label = "Repair vehicle",
        canInteract = function(entity, distance, coords, name, bone)
            local j = wx.GetJob()
            for k, v in pairs(wx.Jobs) do
                if v.canAccess['impound'] and k == j and IsVehicleDamaged(entity) then
                    return true
                end
            end
            return false
        end,
        onSelect = function(data)
            fixCar(data.entity)
        end
    }
}

exports.ox_target:addGlobalVehicle(options)
