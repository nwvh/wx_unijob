wx.WaitForJobs()

local lastSpawnedVehicle = 0
local displaying = false

function OpenGarages(v, data, job)
    local opt = {}
    for _, car in pairs(data.vehicles) do
        table.insert(
            opt,
            {
                title = car.label,
                icon = "car-side",
                disabled = (wx.GetGrade() < car.minGrade),
                onSelect = function()
                    local spawnpoint = wx.GetFreeSpawnpoint(data.spawnLocations)
                    if not spawnpoint then
                        return wx.Client.Notify(locale("garagesTitle"), locale("garagesSpawnpointOccupied", car.label),
                            "error",
                            "warehouse")
                    end
                    local veh = wx.SpawnVehicle(car.model, spawnpoint)
                    if car.plate then
                        SetVehicleNumberPlateText(veh, car.plate)
                    end
                    SetVehicleLivery(veh, car.livery)
                    lastSpawnedVehicle = veh
                    if data.spawnInside then
                        for i = 0, 200 do
                            if IsPedInVehicle(cache.ped, veh, false) then
                                break
                            end
                            TaskWarpPedIntoVehicle(cache.ped, veh, -1)
                        end
                    end
                    return wx.Client.Notify(locale("garagesTitle"), locale("garagesParkedOut", car.label), "success",
                        "warehouse")
                end
            }
        )
    end
    lib.registerContext(
        {
            id = "wx_unijob:garages:" .. job,
            title = v.label,
            options = opt
        }
    )

    lib.showContext("wx_unijob:garages:" .. job)
end

function ReturnVehicle()
    if lastSpawnedVehicle == 0 then
        return
    end
    if not DoesEntityExist(lastSpawnedVehicle) then
        lastSpawnedVehicle = 0
        return wx.Client.Notify(locale("garagesTitle"), locale("garagesVehicleMissing"), "error", "warehouse")
    end
    local pedCoords = GetEntityCoords(cache.ped)
    local vehCoords = GetEntityCoords(lastSpawnedVehicle)
    if #(pedCoords - vehCoords) > 20.0 then
        return wx.Client.Notify(locale("garagesTitle"), locale("garagesVehicleFar"), "error", "warehouse")
    end
    lib.callback.await("wx_unijob:impound:requestImpound", false, VehToNet(lastSpawnedVehicle))
    return wx.Client.Notify(locale("garagesTitle"), locale("garagesVehicleReturned"), "success", "warehouse")
end

CreateThread(
    function()
        for job, v in pairs(wx.Jobs) do
            for _, data in pairs(v.garages) do
                if data.type:lower() == "target" then
                    local spawned = false
                    local ped = 0
                    local garage =
                        lib.points.new(
                            {
                                coords = data.location,
                                distance = 50.0,
                                job = v.label
                            }
                        )

                    function garage:nearby()
                        if not spawned then
                            spawned = true
                            ped =
                                wx.SpawnPed(
                                    data.npc,
                                    data.location,
                                    {
                                        freeze = true,
                                        god = true,
                                        reactions = false
                                    }
                                )
                            TaskStartScenarioInPlace(ped, data.npcScenario, -1, true)
                            exports.ox_target.addLocalEntity(
                                _ENV,
                                (ped),
                                {
                                    {
                                        label = locale("garagesTarget"),
                                        name = "wx_unijob:garage:choose",
                                        icon = "fa-solid fa-warehouse",
                                        distance = 2.0,
                                        canInteract = function(entity, distance, coords, name, bone)
                                            local j = wx.GetJob()
                                            if job == j then
                                                return true
                                            end
                                        end,
                                        onSelect = function(d)
                                            OpenGarages(v, data, job)
                                        end
                                    },
                                    {
                                        label = locale("garagesTargetReturn"),
                                        name = "wx_unijob:garage:return",
                                        icon = "fa-solid fa-car-side",
                                        distance = 2.0,
                                        canInteract = function(entity, distance, coords, name, bone)
                                            local j = wx.GetJob()
                                            if job == j and lastSpawnedVehicle ~= 0 and DoesEntityExist(lastSpawnedVehicle) then
                                                return true
                                            end
                                        end,
                                        onSelect = function(d)
                                            ReturnVehicle()
                                        end
                                    }
                                }
                            )
                        end
                    end

                    function garage:onExit()
                        if spawned then
                            spawned = false
                            DeleteEntity(ped)
                            ped = 0
                        end
                    end
                else
                    local garage =
                        lib.points.new(
                            {
                                coords = data.location,
                                distance = 5.0,
                                job = v.label
                            }
                        )

                    function garage:onEnter()
                        if not displaying then
                            displaying = true
                            lib.showTextUI(
                                locale("garagesTextUI"),
                                {
                                    icon = "warehouse"
                                }
                            )
                        end
                    end

                    function garage:nearby()
                        if IsControlJustReleased(0, 38) then
                            OpenGarages(v, data, job)
                        end
                        if IsControlJustReleased(0, 58) then
                            ReturnVehicle()
                        end
                    end

                    function garage:onExit()
                        if displaying then
                            displaying = false
                            lib.hideTextUI()
                        end
                    end
                end
            end
        end
    end
)
