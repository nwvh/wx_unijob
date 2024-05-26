function CleanVehicle(veh)
    SetPedCurrentWeaponVisible(cache.ped, false, false)
    if wx.ProgressBar(nil, 5000, "Cleaning vehicle", true, true, { dict = "timetable@floyd@clean_kitchen@base", clip = "base" }, {
            model = `prop_sponge_01`,
            bone = 28422,
            pos = {
                x = 0.0,
                y = 0.0,
                z = -0.01
            },
            rot = {
                x = 90.0,
                y = 0.0,
                z = 0.0
            }
        }) then
        SetPedCurrentWeaponVisible(cache.ped, true, false)
        SetVehicleDirtLevel(veh, 0.0)
    else
        SetPedCurrentWeaponVisible(cache.ped, true, false)
    end
end

local options = {
    {
        name = 'wx_unijob:clean:target',
        icon = "fas fa-soap",
        distance = 2.0,
        label = "Clean vehicle",
        canInteract = function(entity, distance, coords, name, bone)
            local j = wx.GetJob()
            for k, v in pairs(wx.Jobs) do
                if v.canAccess['clean'] and k == j and GetVehicleDirtLevel(entity) > 1.0 then
                    return true
                end
            end
            return false
        end,
        onSelect = function(data)
            CleanVehicle(data.entity)
        end
    }
}

exports.ox_target:addGlobalVehicle(options)
