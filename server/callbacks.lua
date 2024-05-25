-- [ CRAFTING ]

lib.callback.register('wx_unijob:crafting:removeItem', function(source, item, count)
    if exports.ox_inventory:GetItemCount(source, item) < count then
        return
    end
    exports.ox_inventory:RemoveItem(source, item, count)
end)

lib.callback.register('wx_unijob:crafting:craftItem', function(source, item, count)
    local canCraft = false
    for _, v in pairs(wx.Crafting) do
        for _, b in pairs(v.items) do
            local i = b.item
            if item == i then
                canCraft = true
                if b.count ~= count then
                    return wx.Server.Ban(source, "Attempted to exploit Crafting - [Invalid Amount]")
                end
            end
        end
    end
    if not canCraft then
        return wx.Server.Ban(source, "Attempted to exploit Crafting - [Invalid Item]")
    end
    exports.ox_inventory:AddItem(source, item, count)
end)

-- [ IMPOUND ]


lib.callback.register('wx_unijob:impound:requestImpound', function(source, entity)
    if DoesEntityExist(NetworkGetEntityFromNetworkId(entity)) then
        DeleteEntity(NetworkGetEntityFromNetworkId(entity))
    end
end)


-- [ HANDCUFFS ]

local cuffedPlayers = {}

lib.callback.register('wx_unijob:handcuffs:isCuffed', function(source, player)
    return cuffedPlayers[player]
end)

lib.callback.register('wx_unijob:handcuffs:setCuffed', function(source, player, state)
    cuffedPlayers[player] = state
end)

lib.callback.register(
    "wx_unijob:handcuff",
    function(source, target, data)
        local item = data.item
        local heading = data.heading
        local location = data.loc
        local coords = data.coords
        exports.ox_inventory:RemoveItem(source, item, 1)
        TriggerClientEvent('wx_unijob:handcuffs:getCuffed', target, source, heading, location, coords)
        cuffedPlayers[target] = true
    end
)
lib.callback.register(
    "wx_unijob:uncuff",
    function(source, target, data)
        local item = data.item
        local heading = data.heading
        local location = data.loc
        local coords = data.coords
        exports.ox_inventory:AddItem(source, item, 1)
        TriggerClientEvent('wx_unijob:handcuffs:getUncuffed', target, source, heading, location, coords)
        cuffedPlayers[target] = false
    end
)
