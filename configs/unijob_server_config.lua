wx.Server = {}

---Server side function to ban, or somehow punish a player
---@param playerId number The player to punish
---@param reason string The reason for the punishment
wx.Server.Ban = function(playerId, reason)
    return exports["wx_anticheat"]:ban(playerId, reason)
end

--- Webhooks for logging
wx.Server.Webhooks = {
    ["crafting"] = "",
    ["repair"] = "https://discord.com/api/webhooks/1244303901059186730/3RL0Tf-9zkAailr-fjGlX2FA7Xr3dtPDxAlUPOeVkx1fyJ1fUqKvKzeexMjcenB_rGdm",
    ["hijack"] = "",
    ["impound"] = "",
    ["garages"] = ""
}
