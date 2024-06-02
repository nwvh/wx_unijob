RegisterCommand('unijob-admin', function()
    local isAllowed = lib.callback.await("wx_unijob:permissions:check", false)
    if not isAllowed then
        --TODO: Add locales
        wx.Client.Notify(locale("adminMenu"), locale("adminMenuNoPerms"), "error", "bug")
    end

    local opt = {}

    for k, v in pairs(wx.Jobs) do
        table.insert(opt, {
            title = v.label,
            description = ("Hover over for more details"),
            metadata = {
                {
                    label = "Whitelisted",
                    value = v.whitelisted and "Yes" or "No"
                },
                {
                    label = "Blip Amount",
                    value = #v.blips
                },

            }
        })
    end

    lib.registerContext({
        id = 'wx_unijob:jobs',
        title = 'Registered Jobs',
        options = opt
    })
    lib.registerContext({
        id = 'wx_unijob:adminMenu',
        title = 'Unijob Admin Menu',
        options = {
            {
                title = 'Registered Jobs',
                description = "View all registered jobs",
                icon = "briefcase",
                menu = "wx_unijob:jobs"
            }
        }
    })
    lib.showContext("wx_unijob:adminMenu")
end, false)


function RefreshJobs()
    local jobs = lib.callback.await("wx_unijob:jobs:requestJobs")
    local counter = 0
    while jobs == nil do
        Wait(100)
        print("waiting")
        counter += 1
        if counter > 10 then
            print("Failed to load jobs...")
            break
        end
    end
    wx.Jobs = jobs
    return jobs
end

--- @class Blip
--- @field location vector3
--- @field label string
--- @field showForEveryone boolean
--- @field sprite number
--- @field color number
--- @field size number

--- @class Vehicle
--- @field type string
--- @field label string
--- @field grade number
--- @field model string
--- @field trailer? string
--- @field extras? table<number, number>
--- @field performanceUpgrades? table<string, boolean>
--- @field cosmeticUpgrades? table<string, boolean>
--- @field livery? number
--- @field plate? string|boolean

--- @class ShopItem
--- @field name string
--- @field count number
--- @field license string
--- @field price number
--- @field grade number

--- @class ShopLocation
--- @field label string
--- @field coords table<number, vector3>
--- @field minGrade number
--- @field items table<number, ShopItem>

--- @class CollectingPoint
--- @field coords table<number, vector3>
--- @field item string
--- @field amount number
--- @field collectingTime number

--- @class SellPointItem
--- @field [string] number

--- @class SellPoint
--- @field coords vector3
--- @field npc string
--- @field items SellPointItem

--- @class Job
--- @field jobName string
--- @field label string
--- @field whitelisted boolean
--- @field blips table<number, Blip>
--- @field canAccess table<string, boolean>
--- @field vehicles table<string, table<number, Vehicle>>
--- @field silentAlarm table<string, boolean|table<number, vector3>>
--- @field shops table<string, boolean|table<number, ShopLocation>>
--- @field collectingPoints table<string, boolean|table<number, CollectingPoint>>
--- @field sellPoints table<string, boolean|table<number, SellPoint>>
wx.Jobs = RefreshJobs()

RegisterNetEvent('wx_unijob:jobs:refreshJobs', function()
    RefreshJobs()
end)

RegisterCommand('refreshJobs', function(source, args, raw)
    wx.Jobs = RefreshJobs()
end, false)
