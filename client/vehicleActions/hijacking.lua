function lockpick(veh)
    if wx.Client.Lockpick() then
        wx.Client.Notify("Lockpick", "You have unlocked the vehicle!", "success", "lock-open")
        SetVehicleDoorsLocked(veh, 1)
    else
        wx.Client.Notify("Lockpick", "You have failed to unlocked the vehicle!", "error", "lock-open")
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
        label = "Lockpick vehicle",
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
            if wx.Client.needLockpick then
                local count = exports.ox_inventory:GetItemCount(wx.Client.lockpickItems)
                if count > 0 then
                    lockpick(data.entity)
                else
                    wx.Client.Notify("Lockpick", "You need lockpick for this!", "error", "lock-open")
                end
            else
                lockpick(data.entity)
            end
        end
    }
}

exports.ox_target:addGlobalVehicle(options)
