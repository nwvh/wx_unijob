wx = {}

wx.handcuffsItem = "handcuffs"                                     -- Item for the handcuffs

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
        garages = {                                                              -- Garage options
            {
                location = vector4(451.5510, -1019.1321, 27.4515, 90.9102),      -- Location of the garage
                spawnLocation = vector4(439.7650, -1019.4845, 27.7254, 87.2493), -- Spawn location for the vehicles
                spawnInside = true,                                              -- Enable warping ped into the vehicle on select
                type = "textui",                                                 -- [ target / textui ]
                npc = `csb_trafficwarden`,                                       -- NPC for the target
                vehicles = {                                                     -- Vehicle list
                    {
                        model = `police`,                                        -- Vehicle model
                        label = "Police Vehicle",                                -- Vehicle label shown in the context menu
                        minGrade = 0,                                            -- Minimum grade needed to choose this vehicle
                        livery = 0                                               -- Livery index
                    }
                }
            }
        }
    }
}
