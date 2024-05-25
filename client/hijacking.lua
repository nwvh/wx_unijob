function lockpick(veh)
    if wx.Client.Lockpick() then
        SetVehicleDoorsLocked(veh, 1)
    end
end

local options = {
    {
        name = 'wx_unijob:lockpick:target',
        icon = "fas fa-car",
        distance = 2.0,
        label = "Lockpick vehicle",
        canInteract = function(entity, distance, coords, name, bone)
            local job = exports.wx_bridge:GetJob()
            if not wx.Jobs[tostring(job)] then return false end
            if wx.Jobs[tostring(job)].canAccess['hijack'] and (GetVehicleDoorLockStatus(entity) == 1) then
                return true
            end
            return false
        end,
        onSelect = function(data)
            lockpick(data.enitty)
        end
    }
}

exports.ox_target:addGlobalVehicle(options)