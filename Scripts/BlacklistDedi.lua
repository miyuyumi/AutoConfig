if not game:IsLoaded() then
    game.Loaded:Wait()
end

local httpService = game:GetService("HttpService")
local file = "pastServers.json"
local new = "playerServers.json"
local job = game.JobId
local count = #game.Players:GetPlayers()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local groupId = 5060810

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

local pastServers = httpService:JSONDecode(readfile(file) or "[]")

if not table.find(pastServers, job) and count > 10 then
    table.insert(pastServers, 1, job)
    if #pastServers > 100 then
        table.remove(pastServers, 101)
    end
    writefile(file, httpService:JSONEncode(pastServers))
else
    checkServerAsync()
end

for _, v in pairs(Players:GetPlayers()) do
    if v:IsInGroup(groupId) then
        player:Kick(string.format("Staff [%s] is in the game.", v.Name))
    end
end

Players.PlayerAdded:Connect(function(Player)
    count = count + 1
    if Player:IsInGroup(groupId) then
        player:Kick(string.format("Staff [%s] has joined the game.", Player.Name))
    end
end)

Players.PlayerRemoving:Connect(function(Player)
    count = count - 1
    if count < 10 then
        checkServerAsync()
    end
end)
