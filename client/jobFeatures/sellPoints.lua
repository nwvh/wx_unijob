local spawned = false
local ped

CreateThread(
    function()
        for job, v in pairs(wx.Jobs) do
            if not v.sellPoints.enable then return end
            for _, data in pairs(v.sellPoints.locations) do
                local sellPoint =
                    lib.points.new(
                        {
                            coords = data.coords,
                            distance = 50.0,
                            job = v.label
                        }
                    )

                function sellPoint:nearby()
                    if spawned then return end
                    spawned = true
                    ped =
                        wx.SpawnPed(
                            data.npc,
                            data.coords,
                            {
                                freeze = true,
                                god = true,
                                reactions = false
                            }
                        )
                    exports.ox_target.addLocalEntity(
                        _ENV,
                        (ped),
                        {
                            {
                                label = locale("sellTarget"),
                                name = "wx_unijob:sell:target:",
                                icon = "fa-solid fa-dollar",
                                distance = 2.0,
                                canInteract = function(entity, distance, coords, name, bone)
                                    local j = wx.GetJob()
                                    if job == j then
                                        return true
                                    end
                                end,
                                onSelect = function(d)
                                    local opt = {}
                                    for item, price in pairs(data.items) do
                                        table.insert(opt, {
                                            title = wx.GetItemName(item),
                                            description = ("Sell 1 for %s$"):format(price),
                                            icon = "dollar",
                                            disabled = wx.GetItemCount(item) == 0,
                                            onSelect = function()
                                                local input = lib.inputDialog('Sell Amount', {
                                                    { type = 'number', label = 'Amount to sell', icon = 'dollar', required = true, min = 1, max = wx.GetItemCount(item) },
                                                })
                                                if not input then return end
                                                if wx.ProgressBar(nil, 5000, "Selling...", false, true, {
                                                        dict = 'oddjobs@assassinate@vice@hooker',
                                                        clip = 'argue_a'
                                                    }) then
                                                    lib.callback.await("wx_unijob:sell:sellItem", false, item, input[1])
                                                end
                                            end
                                        })
                                    end
                                    lib.registerContext(
                                        {
                                            id = "wx_unijob:sell:" .. job,
                                            title = locale("sell"),
                                            options = opt
                                        }
                                    )

                                    lib.showContext("wx_unijob:sell:" .. job)
                                end
                            },
                        }
                    )
                end

                function sellPoint:onExit()
                    if not spawned then return end
                    spawned = false
                    DeleteEntity(ped)
                end
            end
        end
    end
)
