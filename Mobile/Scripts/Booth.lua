if not game:IsLoaded() then
    game.Loaded:Wait()
end

shared.Settings = {
    FilePath = "Selling.json",
    SellLink = getgenv().SellHook,
    SnipeLink = getgenv().SnipeHook
}

local Library = require(game.ReplicatedStorage:WaitForChild('Framework'):WaitForChild('Library'))

while not Library.Loaded do
    task.wait()
end

local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local Root = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local Fire, Invoke = Network.Fire, Network.Invoke
local old
old = hookfunction(getupvalue(Fire, 1), function(...)
    return true
end)
local Player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local Scripts = Player.PlayerScripts.Scripts
local playerPos = CFrame.new(-319.761322, 46.7770004, -2597.34473, 0.761269152, -1.61073377e-08, 0.64843601,
    3.39745867e-08, 1, -1.50461545e-08, -0.64843601, 3.34845183e-08, 0.761269152)

if isfile("Selling.json") then
    delfile("Selling.json")
end
local contents = tostring(game:HttpGetAsync(
    "https://raw.githubusercontent.com/miyuyumi/AutoConfig/main/Mobile/Configurations/Selling.json"))
writefile("Selling.json", contents)

local sellingList = HttpService:JSONDecode(readfile(shared.Settings.FilePath))
local snipeList = HttpService:JSONDecode(readfile(getgenv().Config))
local inventoryList = {}
local addedList = {}

for i, v in
    pairs(game:GetService("Workspace")["__MAP"]:WaitForChild("Interactive"):WaitForChild("Booths"):GetChildren()) do
    local Snipe = Instance.new("Part")
    Snipe.Parent = game.Workspace
    Snipe.Size = Vector3.new(5, 1, 5)
    Snipe.Anchored = true
    Snipe.CFrame = v.Booth.CFrame * CFrame.new(0, -16, 0)
end

Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local function Webhook(Url, Data)
    request {
        Url = Url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(Data)
    }
end

local function addPet()
    inventoryList = {}
    for _, v in pairs(Library.Save.Get().Pets) do
        if not v.l then
            for _, v2 in pairs(sellingList) do
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

                table.insert(inventoryList, {v.uid, v2[2]})
                break
            end
        end
    end

    table.sort(inventoryList, function(a, b)
        return a[2] > b[2]
    end)

    for _, v in pairs(inventoryList) do
        if not table.find(addedList, v[1]) then
            Invoke("Add Trading Booth Pet", {v})
        end
    end
end

Player.PlayerGui:FindFirstChild("Chat"):FindFirstChild("Frame"):FindFirstChild("ChatChannelParentFrame"):FindFirstChild(
    "Frame_MessageLogDisplay"):FindFirstChild("Scroller").ChildAdded:Connect(function(Child)
    if Child:IsA("Frame") and Child.Name == "Frame" then
        if not Child:FindFirstChild("TextLabel") then
            return
        end
        if string.find(Child:FindFirstChild("TextLabel").Text, Player.DisplayName) then
            local sellString = tostring(Child:FindFirstChild("TextLabel").Text)
            local buyer = sellString:match("(%S+)%spurchased")
            local pet = sellString:match("%sa%s([%p%w%s]+)%sfrom")
            local seller = sellString:match("from%s([^%s]+)%sfor")
            local price = sellString:match("for%s([^%s]+)%sDiamonds")
            local currentDiamonds = string.format('%.2f', Library.Save.Get().Diamonds / 1000000000)
            if seller == Player.DisplayName then
                Webhook(shared.Settings.SellLink, {
                    ["embeds"] = {{
                        ["title"] = "Sold A " .. pet,
                        ["description"] = "**Sold For:** " .. price .. " :diamonds:\n**To:** ||" .. buyer ..
                            "||\n**Current Diamonds:** " .. currentDiamonds .. "b\n**Account:** ||" .. seller .. "||",
                        ["type"] = "rich",
                        ["color"] = tonumber(0x00ff00)
                    }}
                })
                pcall(function()
                    addPet()
                end)
            elseif buyer == Player.DisplayName then
                Webhook(shared.Settings.SnipeLink, {
                    ["embeds"] = {{
                        ["title"] = "Sniped A " .. pet,
                        ["description"] = "**Sniped For:** " .. price .. " :diamonds:\n**From:** ||" .. seller ..
                            "||\n**Current Diamonds:** " .. currentDiamonds .. "b\n**Account:** ||" .. buyer .. "||",
                        ["type"] = "rich",
                        ["color"] = tonumber(0x00ff00)
                    }}
                })
            end
        end
    end
end)

local function CheckTypeOrRarity(Type, TypeTable, CheckTable)
    local Settings = TypeTable
    local Pet = CheckTable
    if Type == "Type" then
        if (Settings["Regular"] and (not Pet.hc and not Pet.sh and not Pet.g and not Pet.r and not Pet.dm)) then
            return true
        end
        if (Settings["Golden"] and (not Pet.hc and not Pet.sh and Pet.g)) then
            return true
        end
        if (Settings["Rainbow"] and (not Pet.hc and not Pet.sh and Pet.r)) then
            return true
        end
        if (Settings["Dark Matter"] and (not Pet.hc and not Pet.sh and Pet.dm)) then
            return true
        end
        if ((Settings["Hardcore"] and Settings["Regular"]) and
            (Pet.hc and not Pet.sh and not Pet.g and not Pet.r and not Pet.dm)) then
            return true
        end
        if ((Settings["Hardcore"] and Settings["Golden"]) and (Pet.hc and not Pet.sh and Pet.g)) then
            return true
        end
        if ((Settings["Hardcore"] and Settings["Rainbow"]) and (Pet.hc and not Pet.sh and Pet.r)) then
            return true
        end
        if ((Settings["Hardcore"] and Settings["Dark Matter"]) and (Pet.hc and not Pet.sh and Pet.dm)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Regular"]) and
            (not Pet.hc and Pet.sh and not Pet.g and not Pet.r and not Pet.dm)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Golden"]) and (not Pet.hc and Pet.sh and Pet.g)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Rainbow"]) and (not Pet.hc and Pet.sh and Pet.r)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Dark Matter"]) and (not Pet.hc and Pet.sh and Pet.dm)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Hardcore"] and Settings["Regular"]) and
            (Pet.hc and Pet.sh and not Pet.g and not Pet.r and not Pet.dm)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Hardcore"] and Settings["Golden"]) and (Pet.hc and Pet.sh and Pet.g)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Hardcore"] and Settings["Rainbow"]) and (Pet.hc and Pet.sh and Pet.r)) then
            return true
        end
        if ((Settings["Shiny"] and Settings["Hardcore"] and Settings["Dark Matter"]) and (Pet.hc and Pet.sh and Pet.dm)) then
            return true
        end
        if ((Settings["Shiny"]) and (Pet.sh)) then
            return true
        end
        if Settings["Any"] then
            return true
        end
    elseif Type == "Rarity" then
        if (Settings.Rarities["Basic"] and Library.Directory.Pets[Pet.id].rarity == "Basic") or
            (Settings.Rarities["Rare"] and Library.Directory.Pets[Pet.id].rarity == "Rare") or
            (Settings.Rarities["Epic"] and Library.Directory.Pets[Pet.id].rarity == "Epic") or
            (Settings.Rarities["Legendary"] and Library.Directory.Pets[Pet.id].rarity == "Legendary") or
            (Settings.Rarities["Mythical"] and Library.Directory.Pets[Pet.id].rarity == "Mythical") or
            (Settings.Rarities[""] and Library.Directory.Pets[Pet.id].rarity == "") or
            (Settings.Rarities["Event"] and Library.Directory.Pets[Pet.id].rarity == "Event") or
            (Settings.Rarities["Exclusive"] and Library.Directory.Pets[Pet.id].rarity == "Exclusive") or
            (Settings.Rarities["Huge"] and Library.Directory.Pets[Pet.id].huge) or
            (Settings.Rarities["Titanic"] and Library.Directory.Pets[Pet.id].titanic) then
            return true
        end
    end
    return false
end

local function CalculateItemsInTable(Table, AmountOfLoops)
    local AmountToReturn = 0
    if AmountOfLoops == 1 then
        for i, v in pairs(Table) do
            AmountToReturn = AmountToReturn + 1
        end
    elseif AmountOfLoops == 2 then
        for i, v in pairs(Table) do
            for i2, v2 in pairs(v) do
                AmountToReturn = AmountToReturn + 1
            end
        end
    end
    return AmountToReturn
end

local function CheckForSnipePet(PetUid)
    local Found = false
    for i, v in pairs(game:GetService("Workspace")["__MAP"].Interactive.Booths:GetDescendants()) do
        task.spawn(function()
            if v.Name == PetUid then
                Found = true
            end
        end)
    end
    return Found
end

local function sellPet()
    for _, v in pairs(Library.Save.Get().Pets) do
        if not v.l then
            for _, v2 in pairs(sellingList) do
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

                table.insert(inventoryList, {v.uid, v2[2]})
                break
            end
        end
    end

    table.sort(inventoryList, function(a, b)
        return a[2] > b[2]
    end)

    for _, v in pairs(inventoryList) do
        if #inventoryList >= 1 then
            table.insert(addedList, v)
        end
        if #addedList == 12 then
            break
        end
    end
    local added = false
    while added == false do
        added = Invoke("Add Trading Booth Pet", addedList)
        task.wait(0.1)
    end
end

local function attemptPurchase(boothIndex, petUID, price)
    local Success = false
    repeat
        Success = Invoke("Purchase Trading Booth Pet", boothIndex, petUID, price)
        task.wait()
    until CheckForSnipePet(petUID) == false
    if Success then
        return Success
    end
end

local function SettingsChecker(Config, Check)
    if Config == Check then
        return true
    end
    return false
end

local Purchased = false
local function snipePet()
    task.spawn(function()
        while true do
            for i, v in pairs(debug.getupvalues(getsenv(Scripts.Game["Trading Booths"]).SetupClaimed)[1]) do
                task.spawn(function()
                    pcall(function()
                        if CalculateItemsInTable(v.Listings, 1) >= 1 and v.Owner ~= Player.UserId then
                            for i2, v2 in pairs(v.Listings) do
                                for i3, v3 in pairs(snipeList) do
                                    local Pet = Library.PetCmds.Get(i2)
                                    local Settings = {
                                        ["Regular"] = (SettingsChecker(v3[3], "Regular") and true) or false,
                                        ["Hardcore"] = (SettingsChecker(v3[3], "Hardcore") and true) or false,
                                        ["Shiny"] = (SettingsChecker(v3[3], "Shiny") and true) or false,
                                        ["Golden"] = (SettingsChecker(v3[3], "Golden") and true) or false,
                                        ["Rainbow"] = (SettingsChecker(v3[3], "Rainbow") and true) or false,
                                        ["Dark Matter"] = (SettingsChecker(v3[3], "Dark Matter") and true) or false,
                                        ["Any"] = (SettingsChecker(v3[3], "Any") and true) or false
                                    }
                                    if v3[1] ~= "" and Pet.id == v3[1] and Library.Save.Get().Diamonds >= v2.Price and
                                        v3[2] >= v2.Price and CheckTypeOrRarity("Type", Settings, Pet) then
                                        Root:PivotTo(v.Model.Booth.CFrame * CFrame.new(0, -13, 0))
                                        Purchased = attemptPurchase(tonumber(i), i2, v2.Price)
                                        if Purchased then
                                            addPet()
                                        end
                                    elseif v3[4] ~= "" then
                                        Settings["Rarities"] = {
                                            ["Basic"] = (SettingsChecker(v3[4], "Basic") and true) or false,
                                            ["Rare"] = (SettingsChecker(v3[4], "Rare") and true) or false,
                                            ["Epic"] = (SettingsChecker(v3[4], "Epic") and true) or false,
                                            ["Legendary"] = (SettingsChecker(v3[4], "Legendary") and true) or false,
                                            ["Mythical"] = (SettingsChecker(v3[4], "Mythical") and true) or false,
                                            [""] = (SettingsChecker(v3[4], "") and true) or false,
                                            ["Event"] = (SettingsChecker(v3[4], "Event") and true) or false,
                                            ["Exclusive"] = (SettingsChecker(v3[4], "Exclusive") and true) or false,
                                            ["Huge"] = (SettingsChecker(v3[4], "Huge") and true) or false,
                                            ["Titanic"] = (SettingsChecker(v3[4], "Titanic") and true) or false
                                        }
                                        if Library.Save.Get().Diamonds >= v2.Price and v3[2] >= v2.Price and
                                            CheckTypeOrRarity("Type", Settings, Pet) and
                                            CheckTypeOrRarity("Rarity", Settings, Pet) then
                                            Root:PivotTo(v.Model.Booth.CFrame * CFrame.new(0, -13, 0))
                                            Purchased = attemptPurchase(tonumber(i), i2, v2.Price)
                                            if Purchased then
                                                addPet()
                                            end
                                        end
                                    end
                                    if Purchased then
                                        break
                                    end
                                end
                                if Purchased then
                                    break
                                end
                            end
                        end
                    end)
                end)
                if Purchased then
                    Purchased = false
                    break
                end
            end
            task.wait()
        end
    end)
end

while not getsenv(Scripts.Game["Trading Booths"]).GetBooth() do
    getBooths = Invoke("Get All Booths")
    claimedBooths = {}
    for k, v in pairs(getBooths) do
        table.insert(claimedBooths, tonumber(k))
    end
    table.sort(claimedBooths, function(a, b)
        return a < b
    end)
    for x = 1, 40 do
        if x ~= claimedBooths[x] then
            Invoke("Claim Trading Booth", x)
            Root:PivotTo(playerPos)
            break
        end
    end
end

pcall(function()
    sellPet()
end)

pcall(function()
    snipePet()
end)

