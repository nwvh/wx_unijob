local cooldown = {}
CreateThread(
    function()
        for job, v in pairs(wx.Jobs) do
            if not v.silentAlarm.enable then return end
            for _, coord in pairs(v.silentAlarm.locations) do
                exports.ox_target:addSphereZone(
                    {
                        coords = coord,
                        radius = 2.0,
                        drawSprite = true,
                        options = {
                            {
                                label = locale("silentAlarmTarget"),
                                icon = "fas fa-bell",
                                distance = 1.0,
                                canInteract = function(entity, distance, coords, name, bone)
                                    return wx.GetJob() == job
                                end,
                                onSelect = function()
                                    local alert = lib.alertDialog({
                                        header = locale("silentAlarmTitle"),
                                        content = locale("silentAlarmDesc"),
                                        centered = true,
                                        cancel = true
                                    })
                                    if alert == "confirm" then
                                        if cooldown[coord] then
                                            return wx.Client.Notify(locale("silentAlarmTitle"),
                                                locale("silentAlarmCooldown"),
                                                "error",
                                                "bell", 5000)
                                        end
                                        cooldown[coord] = true
                                        SetTimeout(30000, function()
                                            cooldown[coord] = nil
                                        end)
                                        local jobs = {}
                                        table.insert(jobs, job)
                                        lib.requestAnimDict("mp_common")
                                        TaskPlayAnim(cache.ped, 'mp_common', 'givetake1_a', 2.0, 1.0, 2000, 16, 0, false,
                                            false, false)
                                        return exports.wx_bridge:Dispatch("10-99", "Silent Alarm",
                                            "Silent alarm has been triggered", 459, jobs, true)
                                    end
                                end
                            }
                        }
                    }
                )
            end
        end
    end
)
