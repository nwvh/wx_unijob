function BetterPrint(text, type)
    local types = {
        ["error"] = "^7[^1 ERROR ^7] ",
        ["warning"] = "^7[^3 WARNING ^7] ",
        ["config"] = "^7[^3 CONFIG WARNING ^7] ",
        ["info"] = "^7[^5 INFO ^7] ",
        ["success"] = "^7[^2 SUCCESS ^7] ",
    }
    return print("^7[^5 WX UNIJOB ^7] " .. (types[type or "info"]) .. text)
end

function wx.OpenCloakroom()
    if GetResourceState('fivem-appearance') == "started" then
        TriggerEvent('fivem-appearance:clothingShop')
    elseif GetResourceState('illenium-appearance') == "started" then
        TriggerEvent('illenium-appearance:client:openClothingShopMenu', false)
    elseif GetResourceState('qb-clothing') == "started" then
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    else
        BetterPrint(
            [[
            Couldn't open any supported clothing menu.
            Please make sure that you have fivem-appearance, illenium-appearance or qb-clothing on your server.
            If you're using other clothing menu script, please add support for it in client/functions.lua
            ]]
            , "error")
    end
end

---Opens Boss Menu
---@param job string Job Name
function wx.OpenBossMenu(job)
    if not job then return end
    if GetResourceState('esx_society') == "started" then
        exports.wx_bridge:CloseMenu()
        TriggerEvent('esx_society:openBossMenu', job, function(data, menu)
            if menu then
                menu.close()
            end
        end, {
            wash = false
        })
    elseif GetResourceState('qbx_management') == "started" then
        exports.qbx_management:OpenBossMenu('job')
    elseif GetResourceState('qb-management') == "started" then
        TriggerEvent('qb-bossmenu:client:OpenMenu')
    else
        BetterPrint(
            [[
            Couldn't open any supported boss menu (society).
            Please make sure that you have esx_society, qbx_management, qb-management on your server.
            If you're using other society script, please add support for it in client/functions.lua
            ]]
            , "error")
    end
end

function wx.GetItemName(item)
    local i = exports.ox_inventory:Items(item) and exports.ox_inventory:Items(item).label or "Error"
    return i
end

function wx.GetItemCount(item)
    return lib.callback.await('ox_inventory:getItemCount', false, item)
end

function wx.GetProgress(has, need)
    if need == 0 then
        return 100
    end

    if has >= need then
        return 100
    end

    local progress = (has / need) * 100

    if progress > 100 then
        return 100
    elseif progress < 0 then
        return 0
    else
        return progress
    end
end

function wx.ProgressBar(type, duration, label, cancel, freeze, anim, prop)
    local disable = {}
    if freeze then
        disable = {
            move = true,
            car = true,
            combat = true
        }
    end
    if type == "circle" then
        return lib.progressCircle({
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = cancel,
            disable = disable,
            anim = anim,
            prop = prop
        })
    else
        return lib.progressBar({
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = cancel,
            disable = disable,
            anim = anim,
            prop = prop
        })
    end
end

function wx.DisableControls()
    DisableControlAction(0, 24, true)  --Attack
    DisableControlAction(0, 257, true) --Attack 2
    DisableControlAction(0, 25, true)  --Aim
    DisableControlAction(0, 263, true) --Melee Attack 1
    DisableControlAction(0, 45, true)  --Reload
    DisableControlAction(0, 44, true)  --Cover
    DisableControlAction(0, 37, true)  --Select Weapon
    DisableControlAction(0, 23, true)  --Also 'enter' ?
    DisableControlAction(0, 288, true) --Disable phone
    DisableControlAction(0, 289, true) --Inventory
    DisableControlAction(0, 170, true) --Animations
    DisableControlAction(0, 167, true) --Job
    DisableControlAction(0, 0, true)   --Disable changing view
    DisableControlAction(0, 26, true)  --Disable looking behind
    DisableControlAction(0, 73, true)  --Disable clearing animation
    -- DisableControlAction(2, 199, true)     --Disable pause screen
    DisableControlAction(0, 59, true)  --Disable steering in vehicle
    DisableControlAction(0, 71, true)  --Disable driving forward in vehicle
    DisableControlAction(0, 72, true)  --Disable reversing in vehicle
    DisableControlAction(2, 36, true)  --Disable going stealth
    DisableControlAction(0, 47, true)  --Disable weapon
    DisableControlAction(0, 264, true) --Disable melee
    DisableControlAction(0, 257, true) --Disable melee
    DisableControlAction(0, 140, true) --Disable melee
    DisableControlAction(0, 141, true) --Disable melee
    DisableControlAction(0, 142, true) --Disable melee
    DisableControlAction(0, 143, true) --Disable melee
    DisableControlAction(0, 75, true)  --Disable exit vehicle
    DisableControlAction(27, 75, true) --Disable exit vehicle
end

---Spawn Vehicle
---@param model string
---@param coords vector4 | vector3
---@param data table
---@return number | integer
function wx.SpawnVehicle(model, coords, data)
    if not data or data == nil then
        data = {
            locked = false,
            color = { 0, 0, 0 }
            ---@todo: more options
        }
    end
    if not IsModelValid(model) then -- Return an error if the vehicle model doesn't exist
        return ("[ERROR] The specified vehicle model - [%s] doesn't exist!"):format(model)
    end
    RequestModel(model)                                              -- Request the vehicle model
    while not HasModelLoaded(model) do Wait(5) end                   -- Wait for the vehicle to load
    local spawnedvehicle = CreateVehicle(model, coords, true, false) -- Finally spawn the vehicle
    if data.locked then
        SetVehicleDoorsLocked(spawnedvehicle, 2)
    end
    SetVehicleCustomPrimaryColour(spawnedvehicle, data.color[1], data.color[2], data.color[3])

    return spawnedvehicle
end

---Simplified function for spawning peds
---@param model string Ped model
---@param coords vector3 | vector4 Coords of the ped
---@param data table
---@return integer
function wx.SpawnPed(model, coords, data)
    if not data then
        data = {
            freeze = false,
            reactions = true,
            god = false,
            scenario = nil
        }
    end
    if not IsModelValid(model) then -- Return an error if the vehicle model doesn't exist
        return ("[ERROR] The specified ped model - [%s] doesn't exist!"):format(model)
    end
    RequestModel(model)                            -- Request the ped model
    while not HasModelLoaded(model) do Wait(5) end -- Wait for the ped to load
    local spawnedped = CreatePed(0, model, coords, true, false)
    if data.freeze then
        FreezeEntityPosition(spawnedped, true)
    end
    if not data.reactions then
        SetBlockingOfNonTemporaryEvents(spawnedped, true)
    end
    if data.god then
        SetEntityInvincible(spawnedped, true)
    end
    if data.anim then
        RequestAnimDict(data.anim[1])
        TaskPlayAnim(spawnedped, data.anim[1], data.anim[2], 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
    if data.scenario then
        TaskStartScenarioInPlace(spawnedped, data.scenario, 0, true)
    end
    return spawnedped
end

local lastGrade = 0
local lastJob = "unemployed"

CreateThread(function()
    while true do
        Wait(500)
        local grade = exports.wx_bridge:GetJobGrade()
        local job = exports.wx_bridge:GetJob()
        if grade ~= lastGrade then
            lastGrade = grade
        elseif job ~= lastJob then
            lastJob = job
        end
    end
end)

wx.GetGrade = function()
    return lastGrade
end

wx.GetJob = function()
    return lastJob
end

wx.TableSize = function(t)
    local size = 0
    for k, v in pairs(t) do
        size += 1
    end
    return size
end
