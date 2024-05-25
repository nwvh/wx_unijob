local displaying = false

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
                    lib.showTextUI("[E] - Boss Menu", {
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
