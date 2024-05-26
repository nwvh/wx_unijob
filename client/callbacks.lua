lib.callback.register('wx_unijob:idcard:request', function()
    local alert = lib.alertDialog({
        header = 'ID Card Request',
        content = 'A nearby officer is requesting your ID Card!',
        centered = true,
        cancel = true,
        labels = { confirm = "Show your ID Card", cancel = "Reject" }
    })
    local playerData = exports.wx_bridge:GetPlayerData()
    local data = {
        firstName = playerData.firstName,
        lastName = playerData.lastName,
        dob = playerData.dateofbirth,
        sex = playerData.sex == "m" and "Male" or "Female",
        height = playerData.height,
    }
    return alert == "confirm" and data or false
end)
