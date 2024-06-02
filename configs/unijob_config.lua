wx = {}

wx.radialMenus = false                                             -- Enables radial menu support
wx.handcuffsItem = "money"                                         -- Item for the handcuffs
wx.Items = {
    ["handcuffs"] = { item = "handcuffs", count = 1 },             -- Item(s) needed to handcuff players
    ["revive"] = { item = "medikit", count = 1 },                  -- Item(s) needed to revive players
    ["heal"] = { item = "bandage", count = 1 },                    -- Item(s) needed to heal players
}
wx.handcuffsCanBreak = true                                        -- Enables skill check when being handcuffed, when success, player will be able to flee

wx.Crafting = {                                                    -- Crafting options
    {
        location = vector4(639.1279, 254.6801, 102.1521, 64.8326), -- Crafting bench location
        allowedJobs = {                                            -- Leave empty to disable
            ["police"] = true
        },
        items = {
            {
                item = "WEAPON_CARBINERIFLE",
                count = 1,
                craftingTime = 2500,
                neededItems = {
                    ["scrapmetal"] = 100,
                    ["money"] = 5000
                }
            },
            {
                item = "ammo-9",
                count = 10,
                craftingTime = 2500,
                neededItems = {
                    ["scrapmetal"] = 10,
                }
            },
        }
    }
}
