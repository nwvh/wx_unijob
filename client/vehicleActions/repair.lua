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

    if wx.ProgressBar(nil, 5000, locale("repairProgress"), true, true, { dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", clip = "machinic_loop_mechandplayer" }) then
        wx.Client.Notify(locale("repairTitle"), locale("repairDone"), "success", "wrench", 5000)
        Wait(500)
        SetVehicleFixed(veh)
        SetVehicleDeformationFixed(veh)
        SetVehicleUndriveable(veh, false)
        SetVehicleEngineOn(vehicle, true, true)
        lib.callback.await("wx_unijob:crafting:removeItem", false, wx.Client.repairItem, 1)
    end

    local player = lib.callback.await("wx_unijob:logs:getPlayer", false, source)
    local data = {
        color = 13369599,
        fields = {
            {
                ["name"] = "Player Name",
                ["value"] = player.name,
                ["inline"] = true
            },
            {
                ["name"] = "IC Name",
                ["value"] = player.ICname,
                ["inline"] = true
            },
            {
                ["name"] = "Discord ID",
                ["value"] = player.discord,
                ["inline"] = true
            },
            {
                ["name"] = "License",
                ["value"] = player.license,
                ["inline"] = false
            },
            {
                ["name"] = "Vehicle",
                ["value"] = GetDisplayNameFromVehicleModel(GetEntityModel(veh)),
                ["inline"] = true
            },
            {
                ["name"] = "Plate",
                ["value"] = GetVehicleNumberPlateText(veh),
                ["inline"] = true
            },
        }
    }
    lib.callback.await("wx_unijob:logs:send", false, "Player fixed vehicle", data, "repair")
end

local options = {
    {
        name = "wx_unijob:repair:target",
        icon = "fas fa-wrench",
        distance = 2.0,
        label = locale("repairTarget"),
        canInteract = function(entity, distance, coords, name, bone)
            local j = wx.GetJob()
            for k, v in pairs(wx.Jobs) do
                if v.canAccess["repair"] and k == j and IsVehicleDamaged(entity) then
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
