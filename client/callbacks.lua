lib.callback.register(
    "wx_unijob:idcard:request",
    function()
        local starttime = GetGameTimer()
        local alert =
            lib.alertDialog(
                {
                    header = locale("idCardRequestTitle"),
                    content = locale("idCardRequestDesc"),
                    centered = true,
                    cancel = true,
                    labels = { confirm = locale("idCardRequestAccept"), cancel = locale("idCardRequestRefuse") }
                }
            )
        local playerData = exports.wx_bridge:GetPlayerData()
        local data = {
            firstName = playerData.firstName,
            lastName = playerData.lastName,
            dob = playerData.dateofbirth,
            sex = playerData.sex == "m" and "Male" or "Female",
            height = playerData.height
        }
        if (GetGameTimer() - starttime > 5) and alert ~= "confirm" then -- Wait 5 seconds for the player to choose an option
            lib.closeAlertDialog()
            return false
        end
        return alert == "confirm" and data or false
    end
)

lib.callback.register("wx_unijob:revive:revivePlayer", function()
    wx.Client.Revive()
end)
lib.callback.register("wx_unijob:heal:healPlayer", function()
    wx.Client.Heal()
end)
