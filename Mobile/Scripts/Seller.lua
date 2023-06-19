shared.Settings = {
    FilePath = "Selling.json",
    SellLink = getgenv().SellHook,
    SnipeLink = getgenv().SnipeHook
}

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Identity = set_thread_identity(1)

local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/preztel/AzureLibrary/master/uilib.lua", true))()

local lib = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))

while not lib.Loaded do
	task.wait()
end

task.wait(10)
local SellingTab = UILibrary:CreateTab("Seller", "Selling script has loaded", true)

local API = loadstring(game:HttpGet("https://raw.githubusercontent.com/7BioHazard/Utils/main/API.lua"))()

API:Load()

function Webhook(Url, Data)
    request {
        Url = Url,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode(Data)
    }
end

local Services = API.Services
local Players = Services.Players
local TweenService = Services.TweenService
local RunService = Services.RunService
local ReplicatedStorage = Services.ReplicatedStorage
local VirtualUser = Services.VirtualUser
local HttpService = Services.HttpService


local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

local PSX_Library_Instance = ReplicatedStorage:WaitForChild("Library")
local PSX_Library = require(PSX_Library_Instance)

local Framework = ReplicatedStorage:WaitForChild("Framework")
local FrameworkLibrary = require(Framework:WaitForChild("Library"))

local Map = PSX_Library.WorldCmds
local Signal = require(PSX_Library_Instance.Signal)

local Client = require(PSX_Library_Instance.Client)
local Network = Client.Network

setupvalue(Network.Invoke, 1, function() return true end)
setupvalue(Network.Invoked, 1, function() return true end)
setupvalue(Network.Fire, 1, function() return true end)
setupvalue(Network.Fired, 1, function() return true end)

playerPos = CFrame.new(-319.761322, 46.7770004, -2597.34473, 0.761269152, -1.61073377e-08, 0.64843601, 3.39745867e-08,
    1, -1.50461545e-08, -0.64843601, 3.34845183e-08, 0.761269152)

if isfile("Selling.json") then
    delfile("Selling.json")
end
local contents = tostring(game:HttpGetAsync("https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Configurations/Selling.json"))
writefile("Selling.json", contents)

local petList = HttpService:JSONDecode(readfile(shared.Settings.FilePath))
local toList = {}


local function sellingFunction()
    for _, v in next, FrameworkLibrary.Save.Get().Pets do
        if not v.l then
            for _, v2 in next, petList do
                if v2[1] ~= v.id then
                    continue
                end
                local rarity = (v.g and "Golden") or (v.r and "Rainbow") or (v.dm and "Dark Matter") or "Regular"
                if v2[3][1] ~= rarity then
                    continue
                end
    
                if v2[3][2] ~= nil and not v.sh then
                    continue
                end
    
                table.insert(toList, {v.uid, v2[2]})
                break
            end
        end
    end

    table.sort(toList, function(a, b)
        return a[2] > b[2]
    end)
    
    for _, v in next, toList do
        Network.Invoke("Add Trading Booth Pet", {v})
        task.wait(1)
    end
end

if not getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game["Trading Booths"]).GetBooth() then
    for _, v in next, workspace:WaitForChild("__MAP"):WaitForChild("Interactive"):WaitForChild("Booths"):GetChildren() do
        pcall(function()
            if v.Info.SurfaceGui.Frame.Top.Text == "Unclaimed Stand" then
                Root:PivotTo(v.Booth.CFrame)
                task.wait(3)
                API:VirtualPressButton("E")
                task.wait(3)
                Root:PivotTo(playerPos)
            end
        end)
        if getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game["Trading Booths"]).GetBooth() then
            break
        end
    end
end

task.spawn(function()
    while true do
        sellingFunction()
        task.wait(30)
    end
end)


setfflag("HumanoidParallelRemoveNoPhysics", "False")
setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")
setfflag("AbuseReportScreenshot", "False")
setfflag("AbuseReportScreenshotPercentage", "0")

Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    Root = Character:WaitForChild("HumanoidRootPart")
end)

Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

Player.PlayerGui:FindFirstChild("Chat"):FindFirstChild("Frame"):FindFirstChild("ChatChannelParentFrame"):FindFirstChild("Frame_MessageLogDisplay"):FindFirstChild("Scroller").ChildAdded:Connect(function(Child)
    if Child:IsA("Frame") and Child.Name == "Frame" then
        if not Child:FindFirstChild("TextLabel") then
            return
        end
        --print(Child:FindFirstChild("TextLabel").Text)
        if string.find(Child:FindFirstChild("TextLabel").Text, Player.DisplayName) then
            local sellString = tostring(Child:FindFirstChild("TextLabel").Text)
            local buyer = sellString:match("(%S+)%spurchased")
            local pet = sellString:match("%sa%s([%p%w%s]+)%sfrom")
            local seller = sellString:match("from%s([^%s]+)%sfor")
            local price = sellString:match("for%s([^%s]+)%sDiamonds")
            local currentDiamonds = string.format('%.2f',FrameworkLibrary.Save.Get().Diamonds/1000000000)
            if seller == Player.DisplayName then
                Webhook(shared.Settings.SellLink, {
                    ["embeds"] = {{
                        ["title"] = "Sold A " .. pet,
                        ["description"] = "**Sold For:** " .. price .. " :diamonds:\n**To:** ||" .. buyer .. "||\n**Current Diamonds:** " .. currentDiamonds .."b\n**Account:** ||" .. seller .. "||",
                        ["type"] = "rich",
                        ["color"] = tonumber(0x00ff00)
                    }}
                })
            elseif buyer == Player.DisplayName then
                Webhook(shared.Settings.SnipeLink, {
                    ["embeds"] = {{
                        ["title"] = "Sniped A " .. pet,
                        ["description"] = "**Sniped For:** " .. price .. " :diamonds:\n**From:** ||" .. seller .. "||\n**Current Diamonds:** " .. currentDiamonds .."b\n**Account:** ||" .. buyer .. "||",
                        ["type"] = "rich",
                        ["color"] = tonumber(0x00ff00)
                    }}
                })
            end
        end
    end
end)