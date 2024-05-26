CreateThread(function()
    for job, data in pairs(wx.Jobs) do
        local result = MySQL.Sync.fetchAll("SELECT label FROM jobs WHERE name = @name", {
            ['@name'] = job
        })

        if result[1] then
            if json.encode(result[1].label) ~= data.label then
                MySQL.update.await('UPDATE jobs SET label = @label WHERE name = @name', {
                    ['@label'] = data.label,
                    ['@name'] = job
                }, function(affectedRows)
                    if affectedRows > 0 then
                        print('Updated job label for ' .. job)
                    end
                end)
            end
        else
            -----------------
        end
    end
end)