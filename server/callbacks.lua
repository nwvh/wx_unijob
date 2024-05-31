-- [ CRAFTING ]

lib.callback.register(
    "wx_unijob:crafting:removeItem",
    function(source, item, count)
        if exports.ox_inventory:GetItemCount(source, item) < count then
            return
        end
        exports.ox_inventory:RemoveItem(source, item, count)
    end
)

lib.callback.register(
    "wx_unijob:crafting:craftItem",
    function(source, item, count)
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
    end
)

-- [ IMPOUND ]

lib.callback.register(
    "wx_unijob:impound:requestImpound",
    function(source, entity)
        if DoesEntityExist(NetworkGetEntityFromNetworkId(entity)) then
            DeleteEntity(NetworkGetEntityFromNetworkId(entity))
        end
    end
)

-- [ HANDCUFFS ]

local cuffedPlayers = {}

lib.callback.register(
    "wx_unijob:handcuffs:isCuffed",
    function(source, player)
        return cuffedPlayers[player]
    end
)

lib.callback.register(
    "wx_unijob:handcuffs:setCuffed",
    function(source, player, state)
        cuffedPlayers[player] = state
    end
)

lib.callback.register(
    "wx_unijob:handcuffs:knockout",
    function(source, target)
        cuffedPlayers[source] = false
        TriggerClientEvent("wx_unijob:handcuffs:knockout", target)
    end
)

lib.callback.register(
    "wx_unijob:handcuff",
    function(source, target, data)
        local item = data.item
        local heading = data.heading
        local location = data.loc
        local coords = data.coords
        exports.ox_inventory:RemoveItem(source, item, 1)
        TriggerClientEvent("wx_unijob:handcuffs:getCuffed", target, source, heading, location, coords)
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
        TriggerClientEvent("wx_unijob:handcuffs:getUncuffed", target, source, heading, location, coords)
        cuffedPlayers[target] = false
    end
)

-- [ STASHES ]

lib.callback.register(
    "wx_unijob:stashes:request",
    function()
        for job, v in pairs(wx.Jobs) do
            for _, data in pairs(v.stashes) do
                exports.ox_inventory:RegisterStash(
                    (data.label:gsub(" ", "")):lower(),
                    data.label,
                    data.slots or 100,
                    (data.maxWeight or 100) * 1000,
                    (not data.public and true or false),
                    { [job] = data.minGrade or 0 },
                    data.location
                )
            end
        end
    end
)

-- [ ID CARD ]
lib.callback.register(
    "wx_unijob:idcard:request",
    function(source, target)
        local response = lib.callback.await("wx_unijob:idcard:request", target)
        return response
    end
)

-- [ ESCORT ]
lib.callback.register(
    "wx_unijob:drag:dragPlayer",
    function(source, target)
        TriggerClientEvent("wx_unijob:drag:getDragged", target, source)
    end
)

lib.callback.register(
    "wx_unijob:drag:stopDragging",
    function(source, target)
        TriggerClientEvent("wx_unijob:drag:stopDragging", target, source)
    end
)

-- [ PUT IN / OUT ]
lib.callback.register(
    "wx_unijob:vehicles:putIn",
    function(_, target)
        TriggerClientEvent("wx_unijob:vehicles:getIn", target)
    end
)

lib.callback.register(
    "wx_unijob:vehicles:putOut",
    function(_, target)
        TriggerClientEvent("wx_unijob:vehicles:getOut", target)
    end
)
lib.callback.register("wx_unijob:vehicles:putOut", function(_, target)
    TriggerClientEvent('wx_unijob:vehicles:getOut', target)
end)

-- [ REVIVE ]
lib.callback.register("wx_unijob:revive:requestRevive", function(_, target)
    lib.callback.await("wx_unijob:revive:revivePlayer", target)
end)

-- [ HEAL ]
lib.callback.register("wx_unijob:heal:requestHeal", function(_, target)
    lib.callback.await("wx_unijob:heal:healPlayer", target)
end)

-- [ GET DISCORD ]
lib.callback.register("wx_unijob:logs:getPlayer", function(_, source)
    local xP = exports.wx_bridge:GetPlayer(source)
    local player = {
        discord = "",
        id = "",
        ICname = xP.getName(),
        name = GetPlayerName(source),
        license = xP.getIdentifier()
    }



    identifiers = GetNumPlayerIdentifiers(source)
    for i = 0, identifiers + 1 do
        if GetPlayerIdentifier(source, i) ~= nil then
            if string.match(GetPlayerIdentifier(source, i), "discord") then
                player.discord = GetPlayerIdentifier(source, i)
                player.id = string.sub(player.discord, 9, -1)
                player.discord = "<@" .. player.id .. ">"
            end
        end
    end

    return player
end)

-- [ PERMISSIONS ]
lib.callback.register("wx_unijob:permissions:check", function(source)
    return exports.wx_bridge:HasPermission(source)
end)
