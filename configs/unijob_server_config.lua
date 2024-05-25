wx.Server = {}

---Server side function to ban, or somehow punish a player
---@param playerId number The player to punish
---@param reason string The reason for the punishment
wx.Server.Ban = function(playerId, reason)
    return exports['wx_anticheat']:ban(playerId, reason)
end

--- Webhooks for logging
wx.Server.Webhooks = {

}
