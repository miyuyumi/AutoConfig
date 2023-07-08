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
    pcall(function()
        while mailed == false do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-396, 33, -2549)
            task.wait(0.5)
            mailed = Invoke("Send Mail", unpack(args))
            task.wait(0.5)
            if mailed == true then
                Webhook(url, {
                    ["embeds"] = {{
                        ["title"] = game:GetService("Players").LocalPlayer.Name .. " has sent a mail!",
                        ["description"] = "Diamonds Mailed: " .. string.format('%.2f', mailDiamonds / 1000000000) .. 'b',
                        ["type"] = "rich",
                        ["color"] = tonumber(0x7269da)
                    }}
                })
            end
        end
    end)

end

local function setRAM()
    task.spawn(function()
        local Threshold
        local day = os.date("*t").wday
        if day ~= 2 then
            Threshold = 100000100000
        else
            Threshold = 25000100000
        end
        while true do
            allDiamonds = lib.Save.Get().Diamonds
            mailDiamonds = allDiamonds - Threshold

            num = lib.Save.Get().Pets
            if config == 'AM' then
                if #num > 40 then
                    config = 'PM'
                    -- local getResponse = makeGetRequest(apiUrl)
                    -- game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
                    --     game.Players.LocalPlayer)
                    game:Shutdown()
                end
            else
                if #num < 6 then
                    config = 'AM'
                    -- local getResponse = makeGetRequest(apiUrl)
                    -- game:GetService("TeleportService"):TeleportToPlaceInstance(7722306047, getResponse,
                    --     game.Players.LocalPlayer)
                    game:Shutdown()
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
end

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

if #num <= 20 then
    config = 'AM'
    setRAM()
    getgenv().Config = 'Snipe.json'
else
    config = 'PM'
    setRAM()
    getgenv().Config = 'Purge.json'
end

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Scripts/Booth.lua"))()
end)
