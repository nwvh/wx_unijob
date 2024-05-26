local displaying = false
lib.locale()

CreateThread(function()
    for job, v in pairs(wx.Jobs) do
        if not v.bossMenu.enable then return end
        local bossmenu = lib.points.new({
            coords = v.bossMenu.location,
            distance = 2.0,
            job = job,
        })

        function bossmenu:onEnter()
            if wx.GetGrade() >= v.bossMenu.minGrade then
                if not displaying then
                    displaying = true
                    lib.showTextUI(locale("bossMenuTextUI"), {
                        icon = "briefcase"
                    })
                end
            end
        end

        function bossmenu:nearby()
            if wx.GetGrade() >= v.bossMenu.minGrade then
                if IsControlJustReleased(0, 38) then
                    wx.OpenBossMenu(self.job)
                end
                if v.bossMenu.marker then
                    DrawMarker(27, v.bossMenu.location.x, v.bossMenu.location.y, v.bossMenu.location.z - 0.99, 0.0, 0.0,
                        0.0,
                        0.0, 180.0, 0.0, .7, .7, .7, 128, 128, 255, 185, false,
                        true, 2, true, nil, false)
                end
            end
        end

        function bossmenu:onExit()
            if displaying then
                displaying = false
                lib.hideTextUI()
            end
        end
    end
end)
