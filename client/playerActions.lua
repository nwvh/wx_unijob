local cuffed = false

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
    print(handcuffed)
    if handcuffed then
        return wx.Client.Notify("Handcuffs", "This person is already handcuffed", "handcuffs", "error")
    end
    if wx.GetItemCount(wx.handcuffsItem) < 1 then
        return wx.Client.Notify("Handcuffs", "You don't have any handcuffs", "handcuffs", "error")
    end
    if not IsPedAPlayer(ped) then return end
    local heading = GetEntityHeading(cache.ped)
    local location = GetEntityForwardVector(cache.ped)
    local coords = GetEntityCoords(cache.ped)
    print("callback")
    lib.callback.await('wx_unijob:handcuff', false, target, {
        item = "money",
        heading = heading,
        loc = location,
        coords = coords
    })
    print("callback ok")
    CuffAnim()
end

function UncuffPlayer(ped)
    local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    local handcuffed = lib.callback.await('wx_unijob:handcuffs:isCuffed', false, target)
    if not handcuffed and not IsPedCuffed(ped) then
        return wx.Client.Notify("Handcuffs", "This person is not handcuffed", "handcuffs", "error")
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
    SetEnableHandcuffs(cache.ped, true)
    SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
    local x, y, z = table.unpack(coords + loc * 1.0)
    SetEntityCoords(cache.ped, x, y, z - 0.9)
    SetEntityHeading(cache.ped, heading)
    Wait(250)
    lib.requestAnimDict('mp_arrest_paired')
    TaskPlayAnim(cache.ped, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
    Wait(3760)
    RemoveAnimDict('mp_arrest_paired')
    cuffed = true
    lib.requestAnimDict('mp_arresting')
    TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
    RemoveAnimDict('mp_arresting')
end)
RegisterNetEvent('wx_unijob:handcuffs:getUncuffed', function(cuffer, heading, loc, coords)
    SetEnableHandcuffs(cache.ped, false)
    ClearPedTasks(cache.ped)
    SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
    cuffed = false
end)

local options = {
    {
        name = 'wx_unijob:handcuff:target',
        icon = "fas fa-handcuffs",
        distance = 2.0,
        label = "Handcuff",
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
        name = 'wx_unijob:handcuff:target',
        icon = "fas fa-handcuffs",
        distance = 2.0,
        label = "Uncuff",
        canInteract = function(entity, distance, coords, name, bone)
            local job = wx.GetJob()
            if not wx.Jobs[tostring(job)] then return false end
            if wx.Jobs[tostring(job)].canAccess['handcuff'] and IsPedCuffed(entity) then
                return true
            end
            return false
        end,
        onSelect = function(data)
            local job = wx.GetJob()
            local target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
            UncuffPlayer(data.entity)
        end
    },
    {

        name = 'wx_unijob:invoice:target',
        icon = "fas fa-file-invoice-dollar",
        label = "Invoice",
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
            local input = lib.inputDialog('Create an Invoice', {
                { type = 'input',  label = 'Invoice Reason', description = 'Brief reason for the invoice', required = true, min = 4, max = 20 },
                { type = 'number', label = 'Invoice Amount', description = 'Amount of the invoice',        required = true, min = 1 },
            })
            if input then
                wx.Client.Invoice(target, input[2], input[1], job)
                wx.Client.Notify("Invoice", "You have sent an invoice for $" .. input[2], "success",
                    "file-invoice-dollar", 5000)
            end
        end
    },
    {

        name = 'wx_unijob:id:target',
        icon = "fas fa-id-card",
        label = "ID Card",
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
            wx.Client.Notify("ID Card", "You have requested the ID Card from this person", "info", "id-card", 5000)
            local result = lib.callback.await("wx_unijob:idcard:request", false, target)
            if type(result) == "table" then
                lib.registerContext({
                    id = 'wx_unijob:idcard:result',
                    title = "ID Card",
                    options = {
                        {
                            title = "First Name",
                            icon = "user",
                            description = result.firstName
                        },
                        {
                            title = "Last Name",
                            icon = "user",
                            description = result.lastName
                        },
                        {
                            title = "Date of Birth",
                            icon = "calendar-days",
                            description = result.dob
                        },
                        {
                            title = "Sex",
                            icon = result.sex == "Female" and "venus" or "mars",
                            description = result.sex
                        },
                        {
                            title = "Height",
                            icon = "ruler-vertical",
                            description = ("%s cm"):format(result.height)
                        },
                    }
                })

                lib.showContext('wx_unijob:idcard:result')
                wx.Client.Notify("ID Card", "The person has shown you their ID Card", "success", "id-card", 5000)
            else
                wx.Client.Notify("ID Card", "The person rejected your ID Card request", "error", "id-card", 5000)
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

exports.ox_target.addGlobalPlayer(_ENV, options)
