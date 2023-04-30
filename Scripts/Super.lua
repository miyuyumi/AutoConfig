if not game:IsLoaded() then
    game.Loaded:Wait()
end

Library = require(game.ReplicatedStorage.Framework.Library)

InvokeHook = hookfunction(getupvalue(Library.Network.Invoke, 1), function(...)
    return true
end)
FireHook = hookfunction(getupvalue(Library.Network.Fire, 1), function(...)
    return true
end)

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

sendMail = function()
    url = getgenv().MailHook
    data = {
        ["embeds"] = {{
            ["title"] = game:GetService("Players").LocalPlayer.Name .. " has sent a mail!",
            ["description"] = "Diamonds Mailed: " .. string.format('%.2f', mailDiamonds / 1000000000) .. 'b',
            ["type"] = "rich",
            ["color"] = tonumber(0x7269da)
        }}
    }
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

    args = {
        [1] = {
            ["Recipient"] = getgenv().MailUsername,
            ["Diamonds"] = mailDiamonds,
            ["Pets"] = {},
            ["Message"] = ""
        }
    }

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-396, 33, -2549)
    task.wait(0.5)
    Library.Network.Invoke("Send Mail", unpack(args))

    local diamondCheck = string.gsub(game:GetService("Players").LocalPlayer.PlayerGui.Main.Right.Diamonds.Amount.Text,
        "%,", "") - 15000000000

    if (diamondCheck <= 0) then
        task.wait(1)
        local diamondCheck = string.gsub(game:GetService("Players").LocalPlayer.PlayerGui.Main.Right.Diamonds.Amount
                                             .Text, "%,", "") - 15000000000
        if (diamondCheck <= 0) then
            request(sendwebhook)
        end
    end
end

setRAM = coroutine.wrap(function()
    while myAccount do
        allDiamonds = string.gsub(game:GetService("Players").LocalPlayer.PlayerGui.Main.Right.Diamonds.Amount.Text,
            "%,", "")
        mailDiamonds = allDiamonds - 15000100000
        if config == 'AM' then
            if #num > 34 then
                config = 'PM'
                myAccount:SetAlias('P - Pet Count: ' .. #num)
                checkServerAsync()
            else
                myAccount:SetAlias('S - Pet Count: ' .. #num)
            end
        else
            if #num < 6 then
                config = 'AM'
                myAccount:SetAlias('S - Pet Count: ' .. #num)
                checkServerAsync()
            else
                myAccount:SetAlias('P - Pet Count: ' .. #num)
            end
        end
        if mailDiamonds > 0 then
            if mailDiamonds > 10000000000 then
                sendMail()
            end
            myAccount:SetDescription('Gems: ' .. string.format('%.2f', allDiamonds / 1000000000) .. 'B Mail: ' ..
                                         string.format('%.2f', mailDiamonds / 1000000000) .. 'B')
        else
            myAccount:SetDescription('Gems: ' .. string.format('%.2f', allDiamonds / 1000000000) .. 'B')
        end
        task.wait(1)
    end
end)

RAMAccount = loadstring(
    game:HttpGet 'https://raw.githubusercontent.com/ic3w0lf22/Roblox-Account-Manager/master/RAMAccount.lua')()
num = {}
lib = require(game.ReplicatedStorage:WaitForChild('Framework'):WaitForChild('Library'))
script_key = getgenv().MilkupKey;

repeat
    wait()
until lib.Loaded

myAccount = RAMAccount.new(game:GetService 'Players'.LocalPlayer.Name)
num = lib.Save.Get().Pets

if isfile("MilkUp/PetSimulatorX/" .. game:GetService 'Players'.LocalPlayer.Name .. ".json") then
    delfile("MilkUp/PetSimulatorX/" .. game:GetService 'Players'.LocalPlayer.Name .. ".json")
end

if #num <= 10 then
    config = 'AM'
    setRAM()
    local contents = readfile("MilkUp/PetSimulatorX/AM/DefaultConfig.json")
    writefile("MilkUp/PetSimulatorX/" .. game:GetService 'Players'.LocalPlayer.Name .. ".json", contents)
else
    config = 'PM'
    setRAM()
    local contents = readfile("MilkUp/PetSimulatorX/PM/DefaultConfig.json")
    writefile("MilkUp/PetSimulatorX/" .. game:GetService 'Players'.LocalPlayer.Name .. ".json", contents)
end

local loadScript = coroutine.create(function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/2a31571481d9db7f3be01903493bfc9a.lua"))()
end)

-- repeat
--     task.wait(240)
--     coroutine.resume(loadScript)
-- until game.CoreGui:FindFirstChild("Rayfield")

