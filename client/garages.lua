local lastSpawnedVehicle = 0

CreateThread(function()
    for job, v in pairs(wx.Jobs) do
        for _, data in pairs(v.garages) do
            if data.type:lower() == "target" then
                local ped = wx.SpawnPed(data.npc, data.location, {
                    freeze = true,
                    god = true,
                    reactions = false
                })
                exports.ox_target.addLocalEntity(_ENV, (ped), {
                    {
                        label = "Open Garage",
                        name = "wx_unijob:garage:choose",
                        icon = "fa-solid fa-warehouse",
                        canInteract = function(entity, distance, coords, name, bone)
                            local j = exports.wx_bridge:GetJob()
                            if job == j then
                                return true
                            end
                        end,
                        onSelect = function(d)
                            local opt = {}
                            for _, car in pairs(data.vehicles) do
                                table.insert(opt, {
                                    title = car.label,
                                    icon = "car-side",
                                    disabled = (exports.wx_bridge:GetJobGrade() < car.minGrade),
                                    onSelect = function()
                                        local veh = wx.SpawnVehicle(car.model, data.spawnLocation)
                                        lastSpawnedVehicle = veh
                                        if data.spawnInside then
                                            for i = 0, 200 do
                                                if IsPedInVehicle(cache.ped, veh, false) then break end
                                                TaskWarpPedIntoVehicle(cache.ped, veh, -1)
                                            end
                                        end
                                    end
                                })
                            end
                            lib.registerContext({
                                id = 'wx_unijob:garages:' .. job,
                                title = v.label,
                                options = opt
                            })

                            lib.showContext('wx_unijob:garages:' .. job)
                        end
                    },
                    {
                        label = "Return Vehicle",
                        name = "wx_unijob:garage:return",
                        icon = "fa-solid fa-car-side",
                        canInteract = function(entity, distance, coords, name, bone)
                            local j = exports.wx_bridge:GetJob()
                            if job == j and lastSpawnedVehicle ~= 0 then
                                return true
                            end
                        end,
                        onSelect = function(d)
                            if lastSpawnedVehicle == 0 then return end
                            if not DoesEntityExist(lastSpawnedVehicle) then
                                lastSpawnedVehicle = 0
                                return lib.notify({
                                    title = "Garages",
                                    icon = "warehouse",
                                    type = "error",
                                    description = "The vehicle you're trying to return is unavailable"
                                })
                            end
                            local pedCoords = GetEntityCoords(cache.ped)
                            local vehCoords = GetEntityCoords(lastSpawnedVehicle)
                            if #(pedCoords - vehCoords) > 20.0 then
                                return lib.notify({
                                    title = "Garages",
                                    icon = "warehouse",
                                    type = "error",
                                    description = "The vehicle you're trying to return is too far"
                                })
                            end
                            lib.callback.await("wx_unijob:impound:requestImpound", false, VehToNet(lastSpawnedVehicle))
                            return lib.notify({
                                title = "Garages",
                                icon = "warehouse",
                                type = "success",
                                description = "Vehicle has been returned"
                            })
                        end
                    },
                })
            end
        end
    end
end)
