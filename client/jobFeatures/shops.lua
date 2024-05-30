local displaying = false

CreateThread(
    function()
        for job, v in pairs(wx.Jobs) do
            if not v.shops.enable then
                return
            end
            for _, data in pairs(v.shops.locations) do
                for _, coord in pairs(data.coords) do
                    local shop =
                        lib.points.new(
                            {
                                coords = coord,
                                distance = 2.0,
                                job = v.label
                            }
                        )

                    function shop:onEnter()
                        if wx.GetJob() == job then
                            if not displaying then
                                displaying = true
                                lib.showTextUI(
                                    locale("shopTextUI"),
                                    {
                                        icon = "basket-shopping"
                                    }
                                )
                            end
                        end
                    end

                    function shop:nearby()
                        if wx.GetJob() == job then
                            if v.shops.marker then
                                DrawMarker(
                                    27,
                                    coord.x,
                                    coord.y,
                                    coord.z - 0.99,
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.0,
                                    180.0,
                                    0.0,
                                    .7,
                                    .7,
                                    .7,
                                    128,
                                    128,
                                    255,
                                    185,
                                    false,
                                    true,
                                    2,
                                    true,
                                    nil,
                                    false
                                )
                            end
                        end
                    end

                    function shop:onExit()
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
