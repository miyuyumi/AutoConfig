if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local Fire, Invoke = Network.Fire, Network.Invoke

local old
old = hookfunction(getupvalue(Fire, 1), function(...)
    return true
end)

local httpService = game:GetService("HttpService")

local apiUrl = "https://functioning-install-isa-larry.trycloudflare.com/servers"
local API = loadstring(game:HttpGet("https://raw.githubusercontent.com/7BioHazard/Utils/main/API.lua"))()

local function makeGetRequest(url)
    local response = game:HttpGetAsync(url)
    return httpService:JSONDecode(response)["jobID"]
end

sendMail = function()
    url = getgenv().MailHook
    args = {
        [1] = {
            ["Recipient"] = getgenv().MailUsername,
            ["Diamonds"] = mailDiamonds,
            ["Pets"] = {},
            ["Message"] = ""
        }
    }

    local mailed = false
    while mailed == false do
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-396, 33, -2549)
        task.wait(0.5)
        mailed = Invoke("Send Mail", unpack(args))
        task.wait(0.5)
        if mailed == true then
            API:Webhook(url, {
                ["embeds"] = {{
                    ["title"] = game:GetService("Players").LocalPlayer.Name .. " has sent a mail!",
                    ["description"] = "Diamonds Mailed: " .. string.format('%.2f', mailDiamonds / 1000000000) .. 'b',
                    ["type"] = "rich",
                    ["color"] = tonumber(0x7269da)
                }}
            })
        end
    end
end

setRAM = coroutine.wrap(function()
    while true do
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

if isfile("Snipe.json") then
    delfile("Snipe.json")
end

if isfile("Purge.json") then
    delfile("Purge.json")
end

local snipe = tostring(game:HttpGetAsync(
    "https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Configurations/Sniping.json"))
writefile("Snipe.json", snipe)
local purge = tostring(game:HttpGetAsync(
    "https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Configurations/Purging.json"))
writefile("Purge.json", purge)

if #num <= 10 then
    config = 'AM'
    setRAM()
    getgenv().Config = 'Snipe.json'
else
    config = 'PM'
    setRAM()
    getgenv().Config = 'Purge.json'
end

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Scripts/Snipe.lua"))()
end)
