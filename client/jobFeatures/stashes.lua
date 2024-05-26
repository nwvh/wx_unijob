CreateThread(
    function()
        for job, v in pairs(wx.Jobs) do
            for _, data in pairs(v.stashes) do
                exports.ox_target:addSphereZone(
                    {
                        coords = data.location,
                        radius = 2.0,
                        drawSprite = true,
                        options = {
                            {
                                label = locale("stashesTarget", data.label),
                                icon = "fas fa-box",
                                distance = 1.0,
                                canInteract = function(entity, distance, coords, name, bone)
                                    return wx.GetGrade() >= data.minGrade
                                end,
                                onSelect = function()
                                    lib.callback.await("wx_unijob:stashes:request")
                                    exports.ox_inventory:openInventory("stash", (data.label:gsub(" ", "")):lower())
                                end
                            }
                        }
                    }
                )
            end
        end
    end
)
