lib.callback.register("wx_unijob:logs:send", function(source, title, data, type)
    for k, v in pairs(wx.Server.Webhooks) do
        if k == type then
            sendLog(title, data, v)
        end
    end
    --sendLog(title, data, )
end)


--[[SendLog("🟢 Player is Connecting", {
    color = 65280,
    fields = {
      {
        ["name"] = "Player Name",
        ["value"] = GetPlayerName(source),
        ["inline"] = true
      },
      {
        ["name"] = "IC Name",
        ["value"] = player.ICname,
        ["inline"] = true
      },
      {
        ["name"] = "Discord ID",
        ["value"] = player.discord,
        ["inline"] = true
      }
    }
}, Webhooks.WebHookConnect)]]

function send(title, data, webhook)
    local embed = {
      {
        ["color"] = data.color or 13369599,
        ["title"] = title,
        ["author"] = {
          ["name"] = "WX UNIJOB",
          ["url"] = "https://github.com/nwvh/wx_unijob",
          ["icon_url"] =
          "https://github.com/nwvh/wx_unijob/blob/main/.assets/unijob-ico.png"
        },
        ["description"] = data.description or "",
        ["fields"] = data.fields or "",
        ["thumbnail"] = {
          ["url"] = 'https://github.com/nwvh/wx_unijob/blob/main/.assets/unijob-ico.png'
        },
        ["footer"] = {
          ["text"] = "🌠 WX UNIJOB [ " .. os.date('%d.%m.%Y - %H:%M:%S') .. " ]",
          ["icon_url"] = 'https://github.com/nwvh/wx_unijob/blob/main/.assets/unijob-ico.png'
        }
      }
    }
  
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = "WX UNIJOB", embeds = embed }), { ['Content-Type'] = 'application/json' })
end