wx = {}

wx.handcuffsItem = "handcuffs"

wx.Crafting = {
    {
        location = vector4(639.1279, 254.6801, 102.1521, 64.8326),
        allowedJobs = { -- Leave empty to disable
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

wx.Jobs = {
    ["police"] = {
        label = "Los Santos Police Department",
        canAccess = {
            ['handcuff'] = true, -- Can handcuff other players
            ['drag'] = true,     -- Can escort (drag) other players
            ['vehicles'] = true, -- Can remove/put other players from/in vehicles
            ['impound'] = true,  -- Can impound player's vehicles
            ['invoice'] = true,  -- Can bill other players (you will need to configure your invoice system)
            ['repair'] = true,   -- Can repair (player) vehicles
            ['hijack'] = true,   -- Can hijack (player) vehicles
            ['idcard'] = true,   -- Can request (player's) ID card

        },
        bossMenu = {
            enable = true,
            location = vec3(442.5081, -975.0042, 30.6896),
            minGrade = 4
        },
        cloakroom = {
            enable = true,
            locations = {
                vec3(452.0984, -976.4167, 30.6896)
            }
        },
        grades = {
            { id = 'cadet',           label = 'Cadet',           salary = 500, },
            { id = 'officer1',        label = 'Officer I',       salary = 900, },
            { id = 'officer2',        label = 'Officer II',      salary = 1000, },
            { id = 'officer3',        label = 'Officer III',     salary = 1500, },
            { id = 'officer31',       label = 'Officer III+I',   salary = 2000, },
            { id = 'sergeant1',       label = 'Sergeant I',      salary = 2500, },
            { id = 'sergeant2',       label = 'Sergeant II',     salary = 3000, },
            { id = 'lieutenant',      label = 'Lieutenant',      salary = 3500, },
            { id = 'captain',         label = 'Captain',         salary = 3300, },
            { id = 'commander',       label = 'Commander',       salary = 3400, },
            { id = 'deputy_chief',    label = 'Deputy chief',    salary = 3500, },
            { id = 'chief_assistant', label = 'Assistant chief', salary = 3700, },
            { id = 'boss',            label = 'Chief of police', salary = 4000, }
        },
        stashes = {
            {
                label = "Evidence",
                location = vec3(461.8699, -979.0797, 30.6896),
                slots = 100,
                maxWeight = 100,
                minGrade = 4,
                public = true
            }
        },
        garages = {
            {
                location = vector4(451.5510, -1019.1321, 27.4515, 90.9102),
                spawnLocation = vector4(439.7650, -1019.4845, 27.7254, 87.2493),
                spawnInside = true,
                type = "textui",           -- [ target / textui ]
                npc = `csb_trafficwarden`, -- NPC for the target
                vehicles = {
                    {
                        model = `police`,
                        label = "Police Vehicle",
                        minGrade = 0,
                        livery = 0
                    }
                }
            }
        }
    },
    ["dick"] = {
        label = "Los Santos Police Department",
        canAccess = {
            ['handcuff'] = true, -- Can handcuff other players
            ['drag'] = true,     -- Can escort (drag) other players
            ['vehicles'] = true, -- Can remove/put other players from/in vehicles
            ['impound'] = true,  -- Can impound player's vehicles
            ['invoice'] = true,  -- Can bill other players (you will need to configure your invoice system)
            ['repair'] = true,   -- Can repair (player) vehicles
            ['hijack'] = true,   -- Can hijack (player) vehicles
            ['idcard'] = true,   -- Can request (player's) ID card
        },
        bossMenu = {
            enable = true,
            marker = true,
            location = vec3(442.5081, -975.0042, 30.6896),
            minGrade = 4,
        },
        cloakroom = {
            enable = true,
            marker = true,
            locations = {
                vec3(452.0984, -976.4167, 30.6896)
            }
        },
        grades = {
            { id = 'cadet',           label = 'Cadet',           salary = 500, },
            { id = 'officer1',        label = 'Officer I',       salary = 900, },
            { id = 'officer2',        label = 'Officer II',      salary = 1000, },
            { id = 'officer3',        label = 'Officer III',     salary = 1500, },
            { id = 'officer31',       label = 'Officer III+I',   salary = 2000, },
            { id = 'sergeant1',       label = 'Sergeant I',      salary = 2500, },
            { id = 'sergeant2',       label = 'Sergeant II',     salary = 3000, },
            { id = 'lieutenant',      label = 'Lieutenant',      salary = 3500, },
            { id = 'captain',         label = 'Captain',         salary = 3300, },
            { id = 'commander',       label = 'Commander',       salary = 3400, },
            { id = 'deputy_chief',    label = 'Deputy chief',    salary = 3500, },
            { id = 'chief_assistant', label = 'Assistant chief', salary = 3700, },
            { id = 'boss',            label = 'Chief of police', salary = 4000, }
        },
        stashes = {
            {
                label = "Kokot",
                location = vec3(1, 1, 1),
            }
        },
        garages = {
            {
                location = vector4(451.5510, -1019.1321, 27.4515, 90.9102),
                spawnLocation = vector4(439.7650, -1019.4845, 27.7254, 87.2493),
                spawnInside = true,
                type = "textui",           -- [ target / textui ]
                npc = `csb_trafficwarden`, -- NPC for the target
                vehicles = {
                    {
                        model = `police`,
                        label = "Police Vehicle",
                        minGrade = 0,
                        livery = 0
                    }
                }
            }
        }
    },
}
