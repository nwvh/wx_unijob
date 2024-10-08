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

require("types")
---@type Job
wx.Jobs = RefreshJobs()

RegisterNetEvent('wx_unijob:jobs:refreshJobs', function()
    RefreshJobs()
end)

RegisterCommand('refreshJobs', function(source, args, raw)
    wx.Jobs = RefreshJobs()
end, false)
