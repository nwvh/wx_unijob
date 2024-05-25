function SpawnProp(prop1, bone, offset1, offset2, offset3, rotation1, rotation2, rotation3)
    local player = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(player))

    lib.requestModel(prop1)


    local prop = CreateObject(GetHashKey(prop1), x, y, z + 0.2, true, true, true)
    AttachEntityToEntity(prop, player, GetPedBoneIndex(player, bone), offset1, offset2, offset3, rotation1, rotation2,
        rotation3, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(prop1)
    return prop
end

function Impound(entity)
    for i = -1, GetVehicleModelNumberOfSeats(GetHashKey(entity)) do
        if not IsVehicleSeatFree(entity, i) then
            return lib.notify({
                title = "Impound",
                icon = "car-side",
                type = "error",
                description = "The vehicle you're trying to impound is occupied"
            })
        end
    end

    local prop = SpawnProp("prop_pencil_01", 58866, 0.11, -0.02, 0.001, -100.0, 0.0, 0.0)
    if wx.ProgressBar(nil, 5000, "Impounding vehicle", true, true, { dict = "missheistdockssetup1clipboard@base", clip = "base" }, {
            model = `prop_notepad_01`,
            bone = 18905,
            pos = {
                x = 0.1,
                y = 0.02,
                z = 0.05
            },
            rot = {
                x = 10.0,
                y = 0.0,
                z = 0.0
            }
        }) then
        local entityCoords = GetEntityCoords(entity)
        local playerCoords = GetEntityCoords(cache.ped)
        if #(playerCoords - entityCoords) > 5 then
            return lib.notify({
                title = "Impound",
                icon = "car-side",
                type = "error",
                description = "The vehicle you're trying to impound is too far"
            })
        end
        DeleteEntity(prop)
        lib.callback.await("wx_unijob:impound:requestImpound", false, (VehToNet(entity)))
    else
        DeleteEntity(prop)
    end
end

CreateThread(function()
    exports.ox_target.addGlobalVehicle(_ENV, {
        {
            name = 'wx_unijob:impound:target',
            icon = "fas fa-car-burst",
            label = "Impound",
            canInteract = function(entity, distance, coords, name, bone)
                local j = wx.GetJob()
                for k, v in pairs(wx.Jobs) do
                    if v.canAccess['impound'] and k == j then
                        return true
                    end
                end
                return false
            end,
            onSelect = function(data)
                Impound(data.entity)
            end
        },
    })
end)
