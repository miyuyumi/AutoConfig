if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(40)

Library = require(game.ReplicatedStorage.Framework.Library)

InvokeHook = hookfunction(getupvalue(Library.Network.Invoke, 1), function(...)
    return true
end)
FireHook = hookfunction(getupvalue(Library.Network.Fire, 1), function(...)
    return true
end)

local httpService = game:GetService("HttpService")

local apiUrl = "https://calculators-gross-drives-surveys.trycloudflare.com/servers"

local function makeGetRequest(url)
    local response = game:HttpGetAsync(url)
    return httpService:JSONDecode(response)["jobID"]
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
    task.wait(1)
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
        if condition == 1 then
            if config == 'AM' then
                if #num > 34 then
                    config = 'PM'
                    local getResponse = makeGetRequest(apiUrl)
                    game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
                        game.Players.LocalPlayer)
                end
            else
                if #num < 6 then
                    config = 'AM'
                    local getResponse = makeGetRequest(apiUrl)
                    game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
                        game.Players.LocalPlayer)
                end
            end
        end

        if mailDiamonds > 0 then
            if mailDiamonds > 10000000000 then
                sendMail()
            end
        end
        task.wait(1)
    end
end)

RAMAccount = loadstring(
    game:HttpGet 'https://raw.githubusercontent.com/ic3w0lf22/Roblox-Account-Manager/master/RAMAccount.lua')()
num = {}
lib = require(game.ReplicatedStorage:WaitForChild('Framework'):WaitForChild('Library'))

repeat
    wait()
until lib.Loaded

myAccount = RAMAccount.new(game:GetService 'Players'.LocalPlayer.Name)
num = lib.Save.Get().Pets

if isfile(game:GetService 'Players'.LocalPlayer.Name .. "_walkerfanXDsssr.txt") then
    delfile(game:GetService 'Players'.LocalPlayer.Name .. "_walkerfanXDsssr.txt")
end

condition = math.random(1, 2)

if condition == 1 then -- Exclusives
    if #num <= 10 then
        config = 'AM'
        setRAM()
        local contents = tostring(game:HttpGetAsync(
            "https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Configurations/Sniping.json"))
        writefile(game:GetService 'Players'.LocalPlayer.Name .. "_walkerfanXDsssr.txt", contents)
    else
        config = 'PM'
        setRAM()
        local contents = tostring(game:HttpGetAsync(
            "https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Configurations/Purging.json"))
        writefile(game:GetService 'Players'.LocalPlayer.Name .. "_walkerfanXDsssr.txt", contents)
        setRAM()
    end
else -- Huges
    config = 'PM'
    setRAM()
    local contents = tostring(game:HttpGetAsync(
        "https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Configurations/Huges.json"))
    writefile(game:GetService 'Players'.LocalPlayer.Name .. "_walkerfanXDsssr.txt", contents)
end