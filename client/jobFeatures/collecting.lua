wx.WaitForJobs()

local collected = {}

CreateThread(function()
    for job, v in pairs(wx.Jobs) do
        if not v.collectingPoints.enable then return end
        for _, data in pairs(v.collectingPoints.locations) do
            for id, coords in pairs(data.coords) do
                exports.ox_target:addSphereZone(
                    {
                        coords = coords,
                        radius = 0.25,
                        drawSprite = true,
                        options = {
                            {
                                label = ("Collect %s"):format(wx.GetItemName(data.item)),
                                icon = "fas fa-hand",
                                distance = 1.0,
                                canInteract = function(entity, distance, coords, name, bone)
                                    return (wx.GetJob() == job)
                                end,
                                onSelect = function()
                                    if collected[id] then
                                        return wx.Client.Notify(locale("collectingTitle"),
                                            "This point has already been collected",
                                            "error",
                                            "hand")
                                    end
                                    collected[id] = true,
                                        ---@diagnostic disable-next-line: redundant-value
                                        SetTimeout(5000, function()
                                            collected[id] = nil
                                        end)
                                    if wx.ProgressBar('circle', data.collectingTime, "Collecting...", false, true, {
                                            dict = 'random@domestic',
                                            clip = 'pickup_low'
                                        }) then
                                        wx.Client.Notify(locale("collectingTitle"),
                                            ("You have collected x%s %s!"):format(data.amount, wx.GetItemName(data.item)),
                                            "success",
                                            "hand")
                                        lib.callback.await("wx_unijob:crafting:craftItem", false, data.item, data.amount)
                                    end
                                end
                            }
                        }
                    }
                )
            end
        end
    end
end)
