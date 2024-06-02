function debug(text, type)
    local types = {
        ["error"] = "^7[^1 ERROR ^7] ",
        ["warning"] = "^7[^3 WARNING ^7] ",
        ["config"] = "^7[^3 CONFIG WARNING ^7] ",
        ["info"] = "^7[^5 INFO ^7] ",
        ["success"] = "^7[^2 SUCCESS ^7] "
    }
    return print("^7[^5 WX UNIJOB ^7] " .. (types[type or "info"]) .. text)
end

local function loadJobs(directory)
    local jobs = {}
    local resourceName = GetCurrentResourceName()
    local resourcePath = GetResourcePath(resourceName) .. "/" .. directory

    -- Use io.popen to list files in the directory
    local p = io.popen('dir "' .. resourcePath .. '" /b')
    for file in p:lines() do
        -- Check if the file is a Lua file
        if file:match("%.lua$") then
            -- Remove the .lua extension to get the module name
            local moduleName = file:sub(1, -5)
            -- Construct the require path relative to the resource
            local requirePath = directory:gsub("/", ".") .. "." .. moduleName
            -- Require the module
            local job = require(requirePath)
            -- Use jobName as key and job data as value in jobs table
            if job.jobName then
                jobs[job.jobName] = job
            end
        end
    end
    p:close()

    return jobs
end

wx.Jobs = loadJobs("jobs")

CreateThread(
    function()
        local registeredJobs = 0
        local newjobs = 0
        for job, data in pairs(wx.Jobs) do
            local whitelist
            if data.whitelisted then
                whitelist = 1
            else
                whitelist = 0
            end

            local result =
                MySQL.Sync.fetchAll(
                    "SELECT label, whitelisted FROM jobs WHERE name = @name",
                    {
                        ["@name"] = job
                    }
                )

            if result[1] then
                registeredJobs = registeredJobs + 1

                if json.encode(result[1].label):gsub('"', "") ~= data.label then
                    MySQL.update(
                        "UPDATE jobs SET label = @label WHERE name = @name",
                        {
                            ["@label"] = data.label,
                            ["@name"] = job
                        },
                        function(affectedRows)
                            if affectedRows > 0 then
                                debug(("Label of %s has been updated to %s"):format(job, data.label), "info")
                            end
                        end
                    )
                end

                if tostring(data.whitelisted) ~= json.encode(result[1].whitelisted) then
                    MySQL.update(
                        "UPDATE jobs SET whitelisted = @whitelisted WHERE name = @name",
                        {
                            ["@whitelisted"] = whitelist,
                            ["@name"] = job
                        },
                        function(num)
                            if num > 0 then
                                debug(("Whitelist of %s has been updated to %s"):format(job, data.whitelisted), "info")
                            end
                        end
                    )
                end
            else
                newjobs = newjobs + 1

                MySQL.insert(
                    "INSERT INTO `jobs` (name, label, whitelisted) VALUES (?, ?, ?)",
                    {
                        job,
                        data.label,
                        whitelist
                    },
                    function(id)
                        print(id)
                    end
                )
            end
        end

        debug(("Registered ^2%s^7 jobs (^2%s^7 new)"):format(registeredJobs, newjobs), "info")

        local registeredGrades = 0
        local newGrades = 0

        for job, jobData in pairs(wx.Jobs) do
            for number, gradeData in pairs(jobData.grades) do
                local result =
                    MySQL.Sync.fetchAll(
                        "SELECT label, salary, grade, name FROM job_grades WHERE job_name = @job_name AND grade = @grade",
                        {
                            ["@job_name"] = job,
                            ["@grade"] = number
                        }
                    )

                if result[1] then
                    registeredGrades = registeredGrades + 1
                    if json.encode(result[1].label):gsub('"', "") ~= gradeData.label then
                        MySQL.update(
                            "UPDATE job_grades SET label = @label WHERE job_name = @job_name AND grade = @grade",
                            {
                                ["@label"] = gradeData.label,
                                ["@job_name"] = job,
                                ["@grade"] = number
                            },
                            function(num)
                                if num > 0 then
                                    debug(
                                        ("Label of %s of %s has been updated to %s"):format(
                                            number,
                                            job,
                                            gradeData.label
                                        ),
                                        "info"
                                    )
                                end
                            end
                        )
                    end

                    if tonumber(json.encode(result[1].salary)) ~= gradeData.salary then
                        MySQL.update(
                            "UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade",
                            {
                                ["@salary"] = gradeData.salary,
                                ["@job_name"] = job,
                                ["@grade"] = number
                            },
                            function(num)
                                if num > 0 then
                                    debug(
                                        ("Salary of %s of %s has been updated to %s"):format(
                                            gradeData.label,
                                            job,
                                            gradeData.salary
                                        ),
                                        "info"
                                    )
                                end
                            end
                        )
                    end

                    if json.encode(result[1].name):gsub('"', "") ~= gradeData.id then
                        MySQL.update(
                            "UPDATE job_grades SET name = @name WHERE job_name = @job_name AND grade = @grade",
                            {
                                ["@name"] = gradeData.id,
                                ["@job_name"] = job,
                                ["@grade"] = number
                            },
                            function(num)
                                if num > 0 then
                                    debug(
                                        ("Grade %s of %s has been updated to %s"):format(number, job, gradeData.id),
                                        "info"
                                    )
                                end
                            end
                        )
                    end
                else
                    newGrades = newGrades + 1
                    MySQL.insert(
                        "INSERT INTO `job_grades` (job_name, name, grade, label, salary, skin_male, skin_female) VALUES (?, ?, ?, ?, ?, ? ,?)",
                        {
                            job,
                            gradeData.id,
                            number,
                            gradeData.label,
                            gradeData.salary,
                            "{}",
                            "{}"
                        }
                    )
                end
            end
        end


        debug(("Registered ^2%s^7 grades (^2%s^7 new)"):format(registeredGrades, newGrades), "info")
    end
)

-- CreateThread(function()
--     for job, data in pairs(wx.Jobs) do
--         if not data.shops.enable then return end
--         for _, opt in pairs(data.shops.locations) do
--             exports.ox_inventory:RegisterShop(opt.label:gsub(" ", ""), {
--                 name = opt.label,
--                 inventory = opt.items,
--                 locations = opt.coords,
--                 groups = {
--                     [tostring(job)] = opt.minGrade
--                 },
--             })
--         end
--     end
-- end)
exports.ox_inventory:RegisterShop('TestShop', {
    name = 'Test shop',
    inventory = {
        { name = 'burger', price = 10 },
        { name = 'water',  price = 10 },
        { name = 'cola',   price = 10 },
    },
    locations = {
        vec3(-1195.1508, -1402.2836, 17.8976),
    },
})
