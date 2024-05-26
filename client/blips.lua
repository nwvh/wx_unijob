CreateThread(function()
    for _, data in pairs(wx.Jobs) do
        for _, blipData in pairs(data.blips) do
            local blip = AddBlipForCoord(blipData.location.x, blipData.location.y, blipData.location.z)
            SetBlipSprite(blip, blipData.sprite or 57)
            SetBlipScale(blip, blipData.size or 1.0)
            SetBlipColour(blip, blipData.color or 1)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(blipData.label or data.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)