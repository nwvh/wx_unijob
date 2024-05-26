local cuffed = false
local canEscape = true

local function CannotCuff(ped)
    return IsPedFatallyInjured(ped)
        or GetIsTaskActive(ped, 0)
        or IsPedRagdoll(ped)
        or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
        or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
        or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3)
        or IsEntityPlayingAnim(ped, 'random@mugging3', 'handsup_standing_base', 3)
end
function CuffAnim()
    lib.requestAnimDict('mp_arrest_paired')
    Wait(250)
    TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
    Wait(3000)
    RemoveAnimDict('mp_arrest_paired')
end

function HandcuffPlayer(ped)
    local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    local handcuffed = lib.callback.await('wx_unijob:handcuffs:isCuffed', false, target)
    if handcuffed then
        return wx.Client.Notify(locale("handcuffsTitle"), locale("handcuffsAlready"), "error", "handcuffs")
    end
    if wx.GetItemCount(wx.handcuffsItem) < 1 then
        return wx.Client.Notify(locale("handcuffsTitle"), locale("handcuffsMissing"), "error", "handcuffs")
    end
    if not IsPedAPlayer(ped) then return end
    local heading = GetEntityHeading(cache.ped)
    local location = GetEntityForwardVector(cache.ped)
    local coords = GetEntityCoords(cache.ped)
    lib.callback.await('wx_unijob:handcuff', false, target, {
        item = wx.handcuffsItem,
        heading = heading,
        loc = location,
        coords = coords
    })
    CuffAnim()
end

function UncuffPlayer(ped)
    local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    local handcuffed = lib.callback.await('wx_unijob:handcuffs:isCuffed', false, target)
    if not handcuffed and not IsPedCuffed(ped) then
        return wx.Client.Notify(locale("handcuffsTitle"), locale("handcuffsNot"), "error", "handcuffs")
    end
    if not IsPedAPlayer(ped) then return end
    local heading = GetEntityHeading(cache.ped)
    local location = GetEntityForwardVector(cache.ped)
    local coords = GetEntityCoords(cache.ped)
    lib.callback.await('wx_unijob:uncuff', false, target, {
        item = "money",
        heading = heading,
        loc = location,
        coords = coords
    })
    TaskPlayAnim(cache.ped, "mp_arresting", 'a_uncuff', 8.0, -8, 5500, 0, 0, false, false, false)
    Wait(5500)
end

RegisterNetEvent('wx_unijob:handcuffs:getCuffed', function(cuffer, heading, loc, coords)
    wx.Client.Notify(locale("handcuffsTitle"), locale("handcuffsAlert"), "warning", "handcuffs")
    SetEnableHandcuffs(cache.ped, true)
    SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
    local x, y, z = table.unpack(coords + loc * 1.0)
    SetEntityCoords(cache.ped, x, y, z - 0.9)
    SetEntityHeading(cache.ped, heading)
    Wait(250)
    lib.requestAnimDict('mp_arrest_paired')
    TaskPlayAnim(cache.ped, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
    if wx.handcuffsCanBreak then
        if canEscape then
            canEscape = false
            SetTimeout(60 * 1000, function()
                canEscape = true
            end)
            if wx.Client.HandcuffResist() then
                lib.callback.await("wx_unijob:handcuffs:knockout", false, cuffer)
                ClearPedTasks(cache.ped)
                SetEnableHandcuffs(cache.ped, false)
                wx.Client.Notify(locale("handcuffsTitle"), locale("handcuffsEscapedSelf"), "warning",
                    "handcuffs")
                return
            end
        end
    end
    Wait(3760)
    RemoveAnimDict('mp_arrest_paired')
    cuffed = true
    lib.requestAnimDict('mp_arresting')
    TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
    RemoveAnimDict('mp_arresting')
end)
RegisterNetEvent('wx_unijob:handcuffs:getUncuffed', function(cuffer, heading, loc, coords)
    FreezeEntityPosition(cache.ped, true)
    local x, y, z = table.unpack(coords + loc * 1.0)
    SetEntityHeading(cache.ped, heading)
    Wait(5500)
    SetEntityCoords(cache.ped, x, y, z - 0.9)
    SetEnableHandcuffs(cache.ped, false)
    ClearPedTasks(cache.ped)
    SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
    cuffed = false
    FreezeEntityPosition(cache.ped, false)
end)

RegisterNetEvent('wx_unijob:handcuffs:knockout', function()
    local health = GetEntityHealth(cache.ped) - 10
    if health >= 5 then
        SetEntityHealth(cache.ped, health)
    end
    SetPedToRagdoll(cache.ped, 2000, 2000, 0, 0, 0, 0)
    return wx.Client.Notify(locale("handcuffsTitle"), locale("handcuffsEscaped"), "warning", "handcuffs")
end)


-- Taken and edited from https://github.com/overextended/ox_police/blob/5b8fac5692b0bf45b78bbc6b9a036e0a10d3ec1c/client/escort.lua#L49
local isEscorted = false
local isEscorting = false
local escortingPlayerId = 0
local dict = 'anim@move_m@prisoner_cuffed'
local dict2 = 'anim@move_m@trash'
function Escort(serverId)
    while isEscorted do
        local player = GetPlayerFromServerId(serverId)
        local ped = player > 0 and GetPlayerPed(player)

        if not ped then break end

        if not IsEntityAttachedToEntity(cache.ped, ped) then
            AttachEntityToEntity(cache.ped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, true, true, 2, true)
        end

        if IsPedWalking(ped) then
            if not IsEntityPlayingAnim(cache.ped, dict, 'walk', 3) then
                lib.requestAnimDict(dict)
                TaskPlayAnim(cache.ped, dict, 'walk', 8.0, -8, -1, 1, 0.0, false, false, false)
            end
        elseif IsPedRunning(ped) or IsPedSprinting(ped) then
            if not IsEntityPlayingAnim(cache.ped, dict2, 'run', 3) then
                lib.requestAnimDict(dict2)
                TaskPlayAnim(cache.ped, dict2, 'run', 8.0, -8, -1, 1, 0.0, false, false, false)
            end
        else
            StopAnimTask(cache.ped, dict, 'walk', -8.0)
            StopAnimTask(cache.ped, dict2, 'run', -8.0)
        end

        Wait(0)
    end

    RemoveAnimDict(dict)
    RemoveAnimDict(dict2)
end

RegisterNetEvent('wx_unijob:drag:getDragged', function(src)
    isEscorted = true
    Escort(src)
end)


function StopEscort()
    isEscorted = false
    if IsEntityAttached(cache.ped) then
        StopAnimTask(cache.ped, dict, 'walk', -8.0)
        StopAnimTask(cache.ped, dict2, 'run', -8.0)
        DetachEntity(cache.ped, true, false)
    end
end

RegisterNetEvent('wx_unijob:drag:stopDragging', function(src)
    StopEscort()
end)

local options = {
    {
        name = 'wx_unijob:handcuff:target',
        icon = "fas fa-handcuffs",
        distance = 2.0,
        label = locale("handcuffsTarget"),
        canInteract = function(entity, distance, coords, name, bone)
            local job = wx.GetJob()
            if not wx.Jobs[tostring(job)] then return false end
            if wx.Jobs[tostring(job)].canAccess['handcuff'] and not IsPedCuffed(entity) and CannotCuff() then
                return true
            end
            return false
        end,
        onSelect = function(data)
            local job = wx.GetJob()
            local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            HandcuffPlayer(data.entity)
        end
    },
    {
        name = 'wx_unijob:uncuff:target',
        icon = "fas fa-handcuffs",
        distance = 2.0,
        label = locale("uncuffTarget"),
        canInteract = function(entity, distance, coords, name, bone)
            local job = wx.GetJob()
            if not wx.Jobs[tostring(job)] then return false end
            if wx.Jobs[tostring(job)].canAccess['handcuff'] and IsPedCuffed(entity) then
                return true
            end
            return false
        end,
        onSelect = function(data)
            UncuffPlayer(data.entity)
        end
    },
    {
        name = 'wx_unijob:drag:target',
        icon = "fas fa-handshake-angle",
        distance = 2.0,
        label = locale("escortTarget"),
        canInteract = function(entity, distance, coords, name, bone)
            local job = wx.GetJob()
            if not wx.Jobs[tostring(job)] then return false end
            if wx.Jobs[tostring(job)].canAccess['drag'] and IsPedCuffed(entity) and not IsEntityAttached(entity) then
                return true
            end
            return false
        end,
        onSelect = function(data)
            local job = wx.GetJob()
            local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            escortingPlayerId = target
            lib.callback.await("wx_unijob:drag:dragPlayer", false, target)
            isEscorting = true
        end
    },
    {
        name = 'wx_unijob:undrag:target',
        icon = "fas fa-handshake-angle",
        distance = 2.0,
        label = locale("escortStopTarget"),
        canInteract = function(entity, distance, coords, name, bone)
            local job = wx.GetJob()
            if not wx.Jobs[tostring(job)] then return false end
            if wx.Jobs[tostring(job)].canAccess['drag'] and IsPedCuffed(entity) and IsEntityAttached(entity) then
                return true
            end
            return false
        end,
        onSelect = function(data)
            local job = wx.GetJob()
            local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            escortingPlayerId = 0
            lib.callback.await("wx_unijob:drag:stopDragging", false, target)
            isEscorting = false
        end
    },
    {

        name = 'wx_unijob:invoice:target',
        icon = "fas fa-file-invoice-dollar",
        label = locale("invoiceTarget"),
        distance = 2.0,
        canInteract = function(entity, distance, coords, name, bone)
            local job = wx.GetJob()
            if not wx.Jobs[tostring(job)] then return false end

            if wx.Jobs[tostring(job)].canAccess['invoice'] then
                return true
            end
            return false
        end,
        onSelect = function(data)
            local job = wx.GetJob()
            local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            local input = lib.inputDialog(locale("invoiceCreationTitle"), {
                { type = 'input',  label = locale("invoiceCreationReason"), description = locale("invoiceCreationReasonDesc"), required = true, min = 4, max = 20 },
                { type = 'number', label = locale("invoiceCreationAmount"), description = locale("invoiceCreationAmountDesc"), required = true, min = 1 },
            })
            if input then
                wx.Client.Invoice(target, input[2], input[1], job)
                wx.Client.Notify(locale("invoiceTitle"), locale("invoiceSent", input[2]), "success",
                    "file-invoice-dollar", 5000)
            end
        end
    },
    {

        name = 'wx_unijob:id:target',
        icon = "fas fa-id-card",
        label = locale("idCardTarget"),
        distance = 2.0,
        canInteract = function(entity, distance, coords, name, bone)
            local j = wx.GetJob()
            for k, v in pairs(wx.Jobs) do
                if v.canAccess['idcard'] and k == j then
                    return true
                end
            end
            return false
        end,
        onSelect = function(data)
            local job = wx.GetJob()
            local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            wx.Client.Notify(locale("idCardTitle"), locale("idCardRequested"), "info", "id-card",
                5000)
            local result = lib.callback.await("wx_unijob:idcard:request", false, target)
            if type(result) == "table" then
                lib.registerContext({
                    id = 'wx_unijob:idcard:result',
                    title = locale("idCardTitle"),
                    options = {
                        {
                            title = locale("idCardFirstName"),
                            icon = "user",
                            description = result.firstName
                        },
                        {
                            title = locale("idCartLastName"),
                            icon = "user",
                            description = result.lastName
                        },
                        {
                            title = locale("idCardDob"),
                            icon = "calendar-days",
                            description = result.dob
                        },
                        {
                            title = locale("idCardSex"),
                            icon = result.sex == "Female" and "venus" or "mars",
                            description = result.sex
                        },
                        {
                            title = locale("idCardHeight"),
                            icon = "ruler-vertical",
                            description = ("%s cm"):format(result.height)
                        },
                    }
                })

                lib.showContext('wx_unijob:idcard:result')
                wx.Client.Notify(locale("idCardTitle"), locale("idCardAccepted"), "success", "id-card",
                    5000)
            else
                wx.Client.Notify(locale("idCardTitle"), locale("idCardRejected"), "error", "id-card",
                    5000)
            end
        end
    },
}

CreateThread(function()
    while true do
        Wait(0)
        if cuffed then
            wx.DisableControls()
        end
    end
end)

RegisterNetEvent('wx_unijob:vehicles:getIn', function()
    StopEscort()
    local veh = lib.getClosestVehicle(GetEntityCoords(cache.ped), 5.0, false)

    local foundSeat = nil
    for i = -1, GetVehicleMaxNumberOfPassengers(veh) - 1 do
        if i ~= -1 or i ~= 1 then
            foundSeat = i
        end
    end
    TaskEnterVehicle(cache.ped, veh, -1, foundSeat, 1)
end)

RegisterNetEvent('wx_unijob:vehicles:getOut', function()
    TaskLeaveVehicle(cache.ped, GetVehiclePedIsUsing(cache.ped), 0)
end)

local vehicleOptions = {
    {
        name = 'wx_unijob:vehicle:putIn',
        icon = "fas fa-hand-point-right",
        distance = 2.0,
        label = locale("putInTarget"),
        canInteract = function(entity, distance, coords, name, bone)
            local j = wx.GetJob()
            for k, v in pairs(wx.Jobs) do
                if v.canAccess['putIn'] and k == j and isEscorting and escortingPlayerId ~= 0 then
                    return true
                end
            end
            return false
        end,
        onSelect = function(data)
            lib.callback.await("wx_unijob:vehicles:putIn", false, escortingPlayerId)
            isEscorting = false
            escortingPlayerId = 0
        end
    },
    {
        name = 'wx_unijob:vehicle:putOut',
        icon = "fas fa-hand-point-left",
        distance = 2.0,
        label = locale("putOutTarget"),
        canInteract = function(entity, distance, coords, name, bone)
            local j = wx.GetJob()
            for k, v in pairs(wx.Jobs) do
                if v.canAccess['putIn'] and k == j and not isEscorting and GetVehicleNumberOfPassengers(entity) >= 1 then
                    return true
                end
            end
            return false
        end,
        onSelect = function(data)
            local player = lib.getClosestPlayer(GetEntityCoords(data.entity), 2.0, false)

            lib.callback.await("wx_unijob:vehicles:putOut", false, GetPlayerServerId(player))
        end
    },
}

exports.ox_target:addGlobalVehicle(vehicleOptions)
exports.ox_target.addGlobalPlayer(_ENV, options)
