lib.callback.register(
    "wx_unijob:idcard:request",
    function()
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
        return alert == "confirm" and data or false
    end
)
