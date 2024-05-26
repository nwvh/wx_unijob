function Lockpick(veh)
    if wx.Client.Lockpick() then
        wx.Client.Notify(locale("lockpickTitle"), locale("lockpickSuccess"), "success", "lock-open")
        SetVehicleDoorsLocked(veh, 1)
    else
        wx.Client.Notify(locale("lockpickTitle"), locale("lockpickFailed"), "error", "lock-open")
    end
end

function CanLockpick(entity)
    return GetVehicleDoorLockStatus(entity) == 2 or GetVehicleDoorLockStatus(entity) == 3 or
        GetVehicleDoorLockStatus(entity) == 7
end

local options = {
    {
        name = 'wx_unijob:lockpick:target',
        icon = "fas fa-car",
        distance = 2.0,
        label = locale("lockpickTarget"),
        canInteract = function(entity, distance, coords, name, bone)
            local j = wx.GetJob()
            for k, v in pairs(wx.Jobs) do
                if v.canAccess['hijack'] and k == j and (CanLockpick(entity)) then
                    return true
                end
            end
            return false
        end,
        onSelect = function(data)
            Lockpick(data.entity)
        end
    }
}

exports.ox_target:addGlobalVehicle(options)
