local displaying = false

CreateThread(function()
    for _, v in pairs(wx.Jobs) do
        if not v.cloakroom.enable then return end
        for _, coords in pairs(v.cloakroom.locations) do
            local cloakroom = lib.points.new({
                coords = coords,
                distance = 2.0,
                job = v.label
            })

            function cloakroom:onEnter()
                if not displaying then
                    displaying = true
                    lib.showTextUI("[E] - Cloakroom", {
                        icon = "shirt"
                    })
                end
            end

            function cloakroom:nearby()
                if IsControlJustReleased(0, 38) then
                    wx.OpenCloakroom()
                end
            end

            function cloakroom:onExit()
                if displaying then
                    displaying = false
                    lib.hideTextUI()
                end
            end
        end
    end
end)
