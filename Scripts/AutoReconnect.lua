repeat
    wait()
until game.CoreGui:FindFirstChild('RobloxPromptGui')

local promptOverlay = game.CoreGui.RobloxPromptGui.promptOverlay
local TeleportService = game:GetService('TeleportService')

sendError = function()
    errorMessage = promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text
    url = getgenv().DebugHook

    if string.match(errorMessage, "unexpected client behavior") or string.match(errorMessage, "Please rejoin%.") then
        data = {
            ["content"] = "@everyone",
            ["embeds"] = {{
                ["title"] = game:GetService("Players").LocalPlayer.Name .. " has been disconnected!",
                ["description"] = errorMessage,
                ["type"] = "rich",
                ["color"] = tonumber(0x7269da)
            }}
        }
    else
        data = {
            ["embeds"] = {{
                ["title"] = game:GetService("Players").LocalPlayer.Name .. " has been disconnected!",
                ["description"] = errorMessage,
                ["type"] = "rich",
                ["color"] = tonumber(0x7269da)
            }}
        }
    end

    newdata = game:GetService("HttpService"):JSONEncode(data)

    headers = {
        ["content-type"] = "application/json"
    }
    request = http_request or request or HttpPost or syn.request
    sendwebhook = {
        Url = url,
        Body = newdata,
        Method = "POST",
        Headers = headers
    }

    request(sendwebhook)
end

promptOverlay.ChildAdded:connect(function(V)
    if V.Name == 'ErrorPrompt' then
        repeat
            if promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text ~= "Label" then
                sendError()
                game:Shutdown()
            end
            wait(0.5)
        until false
    end
end)
