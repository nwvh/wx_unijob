wx = {}

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
        },
        bossMenu = {
            enable = true,
            location = vec3(1, 1, 1)
        },
        cloakroom = {
            enable = true,
            locations = {
                vec3(452.0984, -976.4167, 30.6896)
            }
        },
        grades = {
            { id = 'cadet',           label = 'Cadet',           salary = 500,  bossMenu = false },
            { id = 'officer1',        label = 'Officer I',       salary = 900,  bossMenu = false },
            { id = 'officer2',        label = 'Officer II',      salary = 1000, bossMenu = false },
            { id = 'officer3',        label = 'Officer III',     salary = 1500, bossMenu = false },
            { id = 'officer31',       label = 'Officer III+I',   salary = 2000, bossMenu = false },
            { id = 'sergeant1',       label = 'Sergeant I',      salary = 2500, bossMenu = false },
            { id = 'sergeant2',       label = 'Sergeant II',     salary = 3000, bossMenu = false },
            { id = 'lieutenant',      label = 'Lieutenant',      salary = 3500, bossMenu = false },
            { id = 'captain',         label = 'Captain',         salary = 3300, bossMenu = false },
            { id = 'commander',       label = 'Commander',       salary = 3400, bossMenu = false },
            { id = 'deputy_chief',    label = 'Deputy chief',    salary = 3500, bossMenu = true },
            { id = 'chief_assistant', label = 'Assistant chief', salary = 3700, bossMenu = true },
            { id = 'boss',            label = 'Chief of police', salary = 4000, bossMenu = true }
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
                npc = `s_m_y_dockwork_01`, -- NPC for the target
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
    }
}
