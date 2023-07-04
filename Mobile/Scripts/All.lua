local httpService = game:GetService("HttpService")
local count = #game.Players:GetPlayers()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local groupId = 5060810
local apiUrl = "https://functioning-install-isa-larry.trycloudflare.com/servers"

local function makeGetRequest(url)
    local response = game:HttpGetAsync(url)
    return httpService:JSONDecode(response)["jobID"]
end

local function makePostRequest(url, requestBody)
    local headers = {
        ["content-type"] = "application/json"
    }

    local request = request
    local sendRequest = {
        Url = url,
        Body = requestBody,
        Method = "POST",
        Headers = headers
    }
    local responseBody = request(sendRequest)
    return httpService:JSONEncode(responseBody)
end

function Webhook(Url, Data)
    request {
        Url = Url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode(Data)
    }
end

if game.PlaceId ~= 7722306047 then
    task.spawn(function()
        repeat
            task.wait()
        until game.CoreGui:FindFirstChild('RobloxPromptGui')

        local promptOverlay = game.CoreGui.RobloxPromptGui.promptOverlay

        sendError = function()
            errorMessage = promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text
            url = getgenv().DebugHook

            if string.match(errorMessage, "unexpected client behavior") or string.match(errorMessage, "Please rejoin%.") then
                Webhook(url, {
                    ["content"] = "@everyone",
                    ["embeds"] = {{
                        ["title"] = game:GetService("Players").LocalPlayer.Name .. " has been disconnected!",
                        ["description"] = errorMessage,
                        ["type"] = "rich",
                        ["color"] = tonumber(0x7269da)
                    }}
                })
            else
                Webhook(url, {
                    ["embeds"] = {{
                        ["title"] = game:GetService("Players").LocalPlayer.Name .. " has been disconnected!",
                        ["description"] = errorMessage,
                        ["type"] = "rich",
                        ["color"] = tonumber(0x7269da)
                    }}
                })
            end
        end

        promptOverlay.ChildAdded:connect(function(V)
            if V.Name == 'ErrorPrompt' then
                repeat
                    if promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text ~= "Label" then
                        sendError()
                        -- local getResponse = makeGetRequest(apiUrl)
                        -- game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
                        --     game.Players.LocalPlayer)
                        game:Shutdown()
                    end
                    task.wait(5)
                until false
            end
        end)
    end)

    local count = 0
    while game.PlaceId ~= 7722306047 do
        count = count + 1
        local getResponse = makeGetRequest(apiUrl)
        game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse, game.Players.LocalPlayer)
        task.wait(10)
        if count > 10 then
            game:Shutdown()
        end
    end

else
    task.wait(20)

    task.spawn(function()
        repeat
            task.wait()
        until game.CoreGui:FindFirstChild('RobloxPromptGui')

        local promptOverlay = game.CoreGui.RobloxPromptGui.promptOverlay

        sendError = function()
            errorMessage = promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text
            url = getgenv().DebugHook

            if string.match(errorMessage, "unexpected client behavior") or string.match(errorMessage, "Please rejoin%.") then
                Webhook(url, {
                    ["content"] = "@everyone",
                    ["embeds"] = {{
                        ["title"] = game:GetService("Players").LocalPlayer.Name .. " has been disconnected!",
                        ["description"] = errorMessage,
                        ["type"] = "rich",
                        ["color"] = tonumber(0x7269da)
                    }}
                })
            else
                Webhook(url, {
                    ["embeds"] = {{
                        ["title"] = game:GetService("Players").LocalPlayer.Name .. " has been disconnected!",
                        ["description"] = errorMessage,
                        ["type"] = "rich",
                        ["color"] = tonumber(0x7269da)
                    }}
                })
            end
        end

        promptOverlay.ChildAdded:connect(function(V)
            if V.Name == 'ErrorPrompt' then
                repeat
                    if promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text ~= "Label" then
                        sendError()
                        -- local getResponse = makeGetRequest(apiUrl)
                        -- game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
                        --     game.Players.LocalPlayer)
                        game:GetService("TeleportService"):Teleport(6284583030)
                    end
                    task.wait(5)
                until false
            end
        end)
    end)

    task.spawn(function()
        if count > 10 then
            local postRequestBody = {
                username = game:GetService 'Players'.LocalPlayer.Name,
                jobid = game.JobId
            }
            local postResponse = makePostRequest(apiUrl, httpService:JSONEncode(postRequestBody))
            if postResponse:find("Hopping server.") then
                -- local getResponse = makeGetRequest(apiUrl)
                -- game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
                --     game.Players.LocalPlayer)
                game:GetService("TeleportService"):Teleport(6284583030)
            end
        else
            -- local getResponse = makeGetRequest(apiUrl)
            -- game:GetService("TeleportService")
            --     :TeleportToPlaceInstance(7722306047, getResponse, game.Players.LocalPlayer)
            game:GetService("TeleportService"):Teleport(6284583030)
        end

        for _, v in pairs(Players:GetPlayers()) do
            pcall(function()
                if v:IsInGroup(groupId) then
                    player:Kick(string.format("Staff [%s] is in the game.", v.Name))
                end
            end)

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
                -- local getResponse = makeGetRequest(apiUrl)
                -- game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
                --     game.Players.LocalPlayer)
                game:GetService("TeleportService"):Teleport(6284583030)
            end
        end)
    end)

    -- task.spawn(function()
    --     task.wait(math.random(45, 90) * 20)
    --     -- local getResponse = makeGetRequest(apiUrl)
    --     -- game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse, game.Players.LocalPlayer)
    --     while true do
    --         game:GetService("TeleportService"):Teleport(6284583030)
    --         task.wait(60)
    --     end

    -- end)

    task.spawn(function()
        task.wait(5)
        setfpscap(10)
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    end)

    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Scripts/Super.lua"))()
    end)
end

