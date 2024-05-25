local props = {}

CreateThread(function()
    for _, v in pairs(wx.Crafting) do
        local craftingbench = lib.points.new(
            { coords = { x = v.location.x, y = v.location.y, z = v.location.z }, heading = v.location.w, index = _, distance = 50 })

        function craftingbench:onEnter()
            lib.requestModel(`gr_prop_gr_bench_02a`)
            props[self.index] = CreateObject(`gr_prop_gr_bench_02a`, self.coords.x, self.coords.y, self.coords.z, false,
                false, false)
            SetEntityHeading(props[self.index], self.heading - 180)
            FreezeEntityPosition(props[self.index], true)
            exports.ox_target:addLocalEntity(props[_], {
                {
                    name = 'wx_unijob:crafting:showCrafting',
                    icon = 'fa-solid fa-wrench',
                    label = 'Open Crafting',
                    canInteract = function(entity, distance, coords, name, bone)
                        local job = wx.GetJob()
                        return v.allowedJobs[job]
                    end,
                    onSelect = function(entity, distance, coords, name, bone)
                        local opt = {}
                        for a, b in pairs(v.items) do
                            local metadata = {}
                            for c, d in pairs(b.neededItems) do
                                local item = wx.GetItemName(c)
                                if item ~= "Error" then
                                    table.insert(metadata, {
                                        label = item,
                                        value = d,
                                        colorScheme = (wx.GetProgress(wx.GetItemCount(c), d) == 100 and "green" or "red"),
                                        progress = wx.GetProgress(wx.GetItemCount(c), d)
                                    })
                                end
                            end
                            table.insert(opt, {
                                title = ("%s %s"):format((b.count == 1 and "" or ("(%sx)"):format(b.count)),
                                    wx.GetItemName(b.item)),
                                description = "Hover over to see the recipe",
                                icon = "wrench",
                                metadata = metadata,
                                onSelect = function()
                                    local item = b.item
                                    local count = b.count or 1
                                    local time = b.craftingTime or 5000

                                    for i, c in pairs(b.neededItems) do
                                        if wx.GetItemCount(i) < c then
                                            return lib.notify({
                                                title = "Crafting",
                                                icon = "wrench",
                                                type = "error",
                                                description = "You are missing some items..."
                                            })
                                        end
                                    end
                                    if wx.ProgressBar(nil, time, ("Crafting %s"):format(wx.GetItemName(item)), false, true, {
                                            dict = 'mini@repair',
                                            clip = 'fixing_a_ped'
                                        }) then
                                        for i, c in pairs(b.neededItems) do
                                            lib.callback.await("wx_unijob:crafting:removeItem", false, i, c)
                                        end
                                        lib.callback.await("wx_unijob:crafting:craftItem", false, item, count)
                                    end
                                end
                            })
                        end
                        lib.registerContext({
                            id = 'unijob_crafting',
                            title = 'Crafting',
                            options = opt
                        })
                        lib.showContext("unijob_crafting")
                    end
                }
            })
        end

        function craftingbench:onExit()
            if DoesEntityExist(props[self.index]) then
                exports.ox_target:removeLocalEntity(props[self.index], { 'weaponrepair:openRepairBench' })
                DeleteEntity(props[self.index])
            end
        end
    end
end)
