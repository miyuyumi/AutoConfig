if not game:IsLoaded() then
    game.Loaded:Wait()
end

getgenv().DebugHook =
    "https://discord.com/api/webhooks/1100659121256157184/b026lTPa9QyEyB_BNayvzWfgBLWNj4qdaVb9VIAZU9bFwQ49aO-_0WaxarpLHsWiCO0X"
getgenv().MailHook =
    "https://discord.com/api/webhooks/1085614599480545403/gVUJwGgNCEKd__c6gbirNP2mMLysdBbAI80OgTe8wR0st7BFXvFGiVuYrZDCRuVYnBSF"
getgenv().MilkupKey = ""
getgenv().MailUsername = "miyufii"
getgenv().SellHook =
    "https://discord.com/api/webhooks/1081501111795597443/JCy46DAgd-Bzn5CeAbP6Z0pFKHmm0FnHfqeV9tE9yv7PAlJSZrijm-bUX4ihBMhEMxET"
getgenv().SnipeHook =
    "https://discord.com/api/webhooks/1081499816279949362/7ZdYeFx_rJnTHmTnXbQH6zd8RCSjZUF5QuPcmDhsuNeRkuz5cnibejS1x_kGOz4xBHMW"
getgenv().HugeKey = ""

local httpService = game:GetService("HttpService")
local promptOverlay = game.CoreGui.RobloxPromptGui.promptOverlay
local apiUrl = "https://calculators-gross-drives-surveys.trycloudflare.com/servers"

local function makeGetRequest(url)
    local response = game:HttpGetAsync(url)
    return httpService:JSONDecode(response)["jobID"]
end

sendError = function()
    local errorMessage = promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text
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

pcall(function()
    if promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text then
        repeat
            if errorMessage ~= "Label" then
                sendError()
                if string.match(errorMessage, "unexpected client behavior") or
                    string.match(errorMessage, "Please rejoin%.") then
                    game:Shutdown()
                else
                    local getResponse = makeGetRequest(apiUrl)
                    game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
                        game.Players.LocalPlayer)
                    task.wait(300)
                end
            end
            task.wait(0.5)
        until false
    end
end)

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Scripts/All.lua"))()
end)

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Scripts/Seller.lua"))()
end)

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Scripts/Super.lua"))()
end)
