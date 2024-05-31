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

wx.Jobs = {
    ["police"] = {                                             -- Job name
        label = "Los Santos Police Department",                -- Label of the job
        whitelisted = true,                                    -- Is job whitelisted
        blips = {                                              -- Blip Settings
            {
                location = vec3(450.8468, -987.8705, 43.6915), -- Location of the blip
                label = "LSPD Station",                        -- Label of the blip
                showForEveryone = true,                        -- [false = Only players with the job can see the blip]
                sprite = 60,                                   -- Blip "icon"
                color = 3,                                     -- Blip color
                size = 0.8                                     -- Blip Size
            }
        },
        canAccess = {
            ['handcuff'] = true,                           -- Can handcuff other players
            ['drag'] = true,                               -- Can escort (drag) other players
            ['vehicles'] = true,                           -- Can remove/put other players from/in vehicles
            ['impound'] = true,                            -- Can impound player's vehicles
            ['invoice'] = true,                            -- Can bill other players (you will need to configure your invoice system)
            ['repair'] = true,                             -- Can repair (player) vehicles
            ['hijack'] = true,                             -- Can hijack (player) vehicles
            ['idcard'] = true,                             -- Can request (player's) ID card
            ['clean'] = true,                              -- Can clean (player) vehicles
            ['putIn'] = true,                              -- Can put players in vehicles
            ['putOut'] = true,                             -- Can put players out of vehicles
            ['revive'] = true,                             -- Can revive other players
            ['heal'] = true,                               -- Can heal other players
        },
        bossMenu = {                                       -- Boss Menu options
            enable = true,                                 -- Enable boss menu
            marker = true,                                 -- Show marker when nearby
            location = vec3(442.5081, -975.0042, 30.6896), -- Location of the boss menu
            minGrade = 4                                   -- Minimum grade to interact with the boss menu
        },
        cloakroom = {                                      -- Cloakroom settings
            enable = true,                                 -- Enable cloakrooms
            marker = true,                                 -- Show marker when nearby
            locations = {                                  -- Locations of the cloakrooms
                vec3(452.0984, -976.4167, 30.6896)
            }
        },
        grades = { -- Grades for the job
            -- Format: { id = "gradeId", label = "Grade Label", salary = salaryInDollars }
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
            { id = 'boss',            label = 'Chief of police', salary = 4000, },
        },
        stashes = {                                            -- Stashes
            {
                label = "Evidence",                            -- Stash label
                location = vec3(461.8699, -979.0797, 30.6896), -- Stash location
                slots = 100,                                   -- Stash slots
                maxWeight = 100,                               -- Stash weight
                minGrade = 4,                                  -- Minimum grade needed to open the stash
                public = true                                  -- false - Stash content is individual
            }
        },
        garages = {                                                         -- Garage options
            {
                location = vector4(451.5510, -1019.1321, 27.4515, 90.9102), -- Location of the garage
                spawnLocations = {                                          -- Spawn location for the vehicles, if multiple are defined, the first free location will be selected
                    vector4(445.9415, -1025.0244, 28.6464, 356.1793),
                    vector4(438.4260, -1026.9872, 28.7916, 6.1582),
                    vector4(434.5964, -1026.4027, 28.8572, 3.8100),
                    vector4(431.2489, -1026.8451, 28.9187, 24.2232),
                    vector4(427.8488, -1027.7943, 28.9801, 0.7660),
                    vector4(436.7216, -1007.7450, 27.7102, 180.3662),
                },
                spawnInside = true,                    -- Enable warping ped into the vehicle on select
                type = "target",                       -- [ target / textui ]
                npc = `csb_trafficwarden`,             -- NPC for the target
                npcScenario = "WORLD_HUMAN_CLIPBOARD", -- NPC Scenario (Animation)
                vehicles = {                           -- Vehicle list
                    {
                        model = `police`,              -- Vehicle model
                        label = "Police Vehicle",      -- Vehicle label shown in the context menu
                        minGrade = 0,                  -- Minimum grade needed to choose this vehicle
                        livery = 0,                    -- Livery index
                        plate = "LSPD"                 -- License plate text, set to false for a random one
                    }
                }
            }
        },
        silentAlarm = {    -- Silent alarm options
            enable = true, -- Enable silent alarm funtion?
            locations = {  -- Locations of the silent alarm target
                vector3(441.1358, -979.8524, 30.6896),
                vector3(447.9791, -974.3834, 30.6896)
            }
        },
        shops = { -- Job shops
            enable = true,
            marker = true,
            locations = {
                {
                    label = "LSPD Armory",
                    coords = {
                        vec3(-1189.4739, -1402.0022, 17.8976)
                    },
                    minGrade = 2,
                    items = {
                        { name = "WEAPON_PISTOL_MK2", count = 1, license = "weapon", price = 5000, grade = 3 }
                    }
                }
            }
        },
        collectingPoints = {
            enable = true,
            locations = {
                {
                    coords = {
                        vec3(-1840.076416, 2096.329102, 138.817719),
                        vec3(-1841.327515, 2095.664551, 139.039200),
                        vec3(-1842.379272, 2095.104980, 139.279877),
                        vec3(-1844.365234, 2094.226562, 139.550491)
                    },
                    item = "wine",
                    amount = 1,
                    collectingTime = 1000
                },
                {
                    coords = {
                        vec3(-1853.272217, 2100.841064, 138.729874)
                    },
                    item = "marijuana",
                    amount = 1,
                    collectingTime = 2000
                }
            }
        },
        sellPoints = {
            enable = true,
            locations = {
                {
                    coords = vec3(-1899.785767, 2084.900635, 139.392700),
                    npc = `a_m_m_og_boss_01`,
                    items = {
                        ["wine"] = 100
                    },
                }
            }
        }
    }
}
