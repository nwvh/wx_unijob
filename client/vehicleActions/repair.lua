function fixCar(veh)
    local vehW = GetEntityHeading(veh)
    local vehC = GetEntityCoords(veh)
    SetVehicleDoorOpen(veh, 4, false, false)
    if wx.ProgressBar(nil, 5000, "Repairing vehicle", true, true, { dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", clip = "machinic_loop_mechandplayer" }) then
        SetVehicleDoorShut(veh, 4, false)
        wx.Client.Notify("Mechanic", "Vehicle was repaired", "success", "wrench", 5000)
        Wait(500)
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
        icon = "fas fa-wrench",
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
