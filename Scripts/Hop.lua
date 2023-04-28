if not game:IsLoaded() then
    game.Loaded:Wait()
end

local httpService = game:GetService("HttpService")
local file = "pastServers.json"
local new = "playerServers.json"

function getServer()
    local pastServers = httpService:JSONDecode(readfile(file) or "[]")
    local playerServers = httpService:JSONDecode(readfile(new) or "[]")
    local servernum = math.random(1, #playerServers)

    table.insert(pastServers, 1, playerServers[servernum])
    if #pastServers > 100 then
        table.remove(pastServers, 101)
    end
    table.remove(playerServers, servernum)
    writefile(new, httpService:JSONEncode(playerServers))
    return pastServers[1]
end

function checkServerAsync()
    spawn(function()
        while true do
            local playerServers = httpService:JSONDecode(readfile(new) or "[]")
            if #playerServers > 0 then
                local server = getServer()
                game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, server, game.Players.LocalPlayer)
                task.wait(60)
            else
                task.wait(30)
            end
        end
    end)
end

task.wait(math.random(45, 90) * 60)
checkServerAsync()

