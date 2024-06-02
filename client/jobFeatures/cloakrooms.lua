wx.WaitForJobs()

local displaying = false

CreateThread(
    function()
        for job, v in pairs(wx.Jobs) do
            if not v.cloakroom.enable then
                return
            end
            for _, coords in pairs(v.cloakroom.locations) do
                local cloakroom =
                    lib.points.new(
                        {
                            coords = coords,
                            distance = 2.0,
                            job = v.label
                        }
                    )

                function cloakroom:onEnter()
                    if wx.GetJob() == job then
                        if not displaying then
                            displaying = true
                            lib.showTextUI(
                                locale("cloakroomTextUI"),
                                {
                                    icon = "shirt"
                                }
                            )
                        end
                    end
                end

                function cloakroom:nearby()
                    if wx.GetJob() == job then
                        if v.cloakroom.marker then
                            DrawMarker(
                                27,
                                coords.x,
                                coords.y,
                                coords.z - 0.99,
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
                        if IsControlJustReleased(0, 38) then
                            wx.OpenCloakroom()
                        end
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
    end
)

exports("openCloakroom", function()
    return wx.OpenCloakroom()
end)
