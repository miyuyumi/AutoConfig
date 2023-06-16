if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local Fire, Invoke = Network.Fire, Network.Invoke

local old
old = hookfunction(getupvalue(Fire, 1), function(...)
    return true
end)

function GetPetDataUID(uid)
    local framework = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
    local petCommands = framework.PetCmds
    return petCommands.Get(uid)
end

function GetPetDataById(id2)
    for i2, v2 in pairs(game:GetService("ReplicatedStorage")["__DIRECTORY"].Pets:GetChildren()) do
        if string.match(v2.Name, "%d+") == tostring(id2) then
            for i3, v3 in pairs(v2:GetChildren()) do
                if v3:IsA("ModuleScript") then
                    return require(v3)
                end
            end
        end
    end
end

function petidtodatatable(id)
    local datatable = {}
    pcall(function()
        local petData = GetPetDataUID(id)
        datatable['id'] = petData.id
        datatable['uid'] = petData.uid
        if petData.sh then
            datatable['sh'] = "Shiny"
        else
            datatable['sh'] = ""
        end
        if petData.g then
            datatable['type'] = "Golden"
        elseif petData.r then
            datatable['type'] = "Rainbow"
        elseif petData.dm then
            datatable['type'] = "Dark Matter"
        else
            datatable['type'] = "Regular"
        end
        local petData2 = GetPetDataById(petData.id)
        datatable['rarity'] = petData2.rarity
        datatable['name'] = petData2.name
    end)
    return datatable
end

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")
local httpService = game:GetService("HttpService")
local snipeList = httpService:JSONDecode(readfile(getgenv().Config))

Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    Root = Character:WaitForChild("HumanoidRootPart")
end)

playerPos = CFrame.new(-319.761322, 46.7770004, -2597.34473, 0.761269152, -1.61073377e-08, 0.64843601, 3.39745867e-08,
    1, -1.50461545e-08, -0.64843601, 3.34845183e-08, 0.761269152)

boothLocations = {{-323.891968, 37.4429474, -2525.14819, -0.643128514, 0, 0.765758753, 0, 1, 0, -0.765758753, 0,
                   -0.643128514},
                  {-311.833221, 39.14505, -2510.79004, -0.643128514, 0, 0.765758753, 0, 1, 0, -0.765758753, 0,
                   -0.643128514},
                  {-299.402344, 37.4429474, -2483.29199, -0.174068213, 0, 0.984733701, 0, 1, 0, -0.984733701, 0,
                   -0.174068213},
                  {-296.181824, 39.321888, -2464.57422, -0.174068213, 0, 0.984733701, 0, 1, 0, -0.984733701, 0,
                   -0.174068213},
                  {-292.873779, 37.4429474, -2446.36401, -0.174068213, 0, 0.984733701, 0, 1, 0, -0.984733701, 0,
                   -0.174068213},
                  {-295.59906, 39.321888, -2417.91455, 0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0,
                   0.342042685},
                  {-302.098145, 40.1350479, -2399.8103, 0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0,
                   0.342042685},
                  {-308.425476, 37.4429474, -2382.67578, 0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0,
                   0.342042685},
                  {-325.005249, 40.6067047, -2357.82202, 0.766061246, 0, 0.642767608, 0, 1, 0, -0.642767608, 0,
                   0.766061246},
                  {-340.576477, 37.4429474, -2344.96606, 0.766061246, 0, 0.642767608, 0, 1, 0, -0.642767608, 0,
                   0.766061246},
                  {-304.778809, 42.7476349, -2551.28833, -0.643128514, 0, 0.765758753, 0, 1, 0, -0.765758753, 0,
                   -0.643128514},
                  {-293.732361, 44.6265717, -2537.92383, -0.643128514, 0, 0.765758753, 0, 1, 0, -0.765758753, 0,
                   -0.643128514},
                  {-282.429749, 44.6265717, -2524.67773, -0.643128514, 0, 0.765758753, 0, 1, 0, -0.765758753, 0,
                   -0.643128514},
                  {-271.199249, 44.8541374, -2497.73901, -0.174068213, 0, 0.984733701, 0, 1, 0, -0.984733701, 0,
                   -0.174068213},
                  {-268.022217, 42.7476349, -2479.76758, -0.174068213, 0, 0.984733701, 0, 1, 0, -0.984733701, 0,
                   -0.174068213},
                  {-264.887451, 42.7476349, -2462.64331, -0.174068213, 0, 0.984733701, 0, 1, 0, -0.984733701, 0,
                   -0.174068213},
                  {-261.885864, 42.7476349, -2445.05591, -0.174068213, 0, 0.984733701, 0, 1, 0, -0.984733701, 0,
                   -0.174068213},
                  {-265.515564, 42.8680649, -2414.1438, 0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0,
                   0.342042685},
                  {-271.780334, 42.7476349, -2396.17432, 0.341646433, 0, 0.939828515, 0, 1, 0, -0.939828515, 0,
                   0.341646433},
                  {-278.341492, 42.7476349, -2378.90576, 0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0,
                   0.342042685},
                  {-283.984833, 44.6265717, -2363.40088, 0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0,
                   0.342042685},
                  {-300.163757, 42.7476349, -2338.19482, 0.766061246, 0, 0.642767608, 0, 1, 0, -0.642767608, 0,
                   0.766061246},
                  {-313.245361, 42.8680649, -2327.42773, 0.766061246, 0, 0.642767608, 0, 1, 0, -0.642767608, 0,
                   0.766061246},
                  {-325.680786, 42.6929474, -2316.6167, 0.765765965, 0, 0.643119454, 0, 1, 0, -0.643119454, 0,
                   0.765765965},
                  {-284.715942, 49.0943146, -2577.35547, -0.642836332, 0, 0.766003549, 0, 1, 0, -0.766003549, 0,
                   -0.642836332},
                  {-274.179626, 49.0943146, -2564.67969, -0.643128514, 0, 0.765758753, 0, 1, 0, -0.765758753, 0,
                   -0.643128514},
                  {-264.050293, 49.0943146, -2552.61938, -0.643128514, 0, 0.765758753, 0, 1, 0, -0.765758753, 0,
                   -0.643128514},
                  {-254.275269, 49.0943146, -2540.58789, -0.643128514, 0, 0.765758753, 0, 1, 0, -0.765758753, 0,
                   -0.643128514},
                  {-241.67981, 49.0943146, -2506.54688, -0.174068213, 0, 0.984733701, 0, 1, 0, -0.984733701, 0,
                   -0.174068213},
                  {-238.24176, 49.0943146, -2487.0979, -0.174068213, 0, 0.984733701, 0, 1, 0, -0.984733701, 0,
                   -0.174068213},
                  {-234.673096, 49.0943146, -2466.91113, -0.174068213, 0, 0.984733701, 0, 1, 0, -0.984733701, 0,
                   -0.174068213},
                  {-231.10022, 49.0943146, -2449.51782, -0.173624277, 0, 0.984811902, 0, 1, 0, -0.984811902, 0,
                   -0.173624277},
                  {-234.459839, 49.0943146, -2406.22876, 0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0,
                   0.342042685},
                  {-241.471313, 49.0943146, -2386.96533, 0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0,
                   0.342042685},
                  {-248.140747, 49.0943146, -2368.64136, 0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0,
                   0.342042685},
                  {-254.151184, 49.0943146, -2352.37598, 0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0,
                   0.342042685},
                  {-272.809296, 50.7964172, -2319.36279, 0.766061246, 0, 0.642767608, 0, 1, 0, -0.642767608, 0,
                   0.766061246},
                  {-285.760864, 49.0943146, -2308.05225, 0.766061246, 0, 0.642767608, 0, 1, 0, -0.642767608, 0,
                   0.766061246},
                  {-298.569153, 49.0943146, -2297.48047, 0.766061246, 0, 0.642767608, 0, 1, 0, -0.642767608, 0,
                   0.766061246},
                  {-310.781982, 49.0943146, -2287.14331, 0.766061246, 0, 0.642767608, 0, 1, 0, -0.642767608, 0,
                   0.766061246}}

function teleportToBooth(b)
    Root:PivotTo(CFrame.new(b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9], b[10], b[11], b[12]))
    task.wait(0.5)
end

function attemptPurchase(boothIndex, petUID, price)
    for x = 1, 10 do
        local purchased = Invoke("Purchase Trading Booth Pet", boothIndex, petUID, price)
        if purchased then
            return true
        end
        task.wait(0.1)
    end

    return false
end

local purchased = false
task.spawn(function()
    while true do
        local booths = Invoke("Get All Booths")
        for i, v in pairs(booths) do
            for i2, v2 in pairs(v.Listings) do
                pet = petidtodatatable(i2)
                for _, v3 in pairs(snipeList) do
                    if v3[1] ~= "" and v3[1] == pet.id and v3[2] >= v2.Price and
                        (v3[3] == pet.type or v3[3] == "Any" or v3[3] == pet.sh) then
                        b = boothLocations[tonumber(i)]
                        teleportToBooth(b)
                        purchased = attemptPurchase(tonumber(i), i2, v2.Price)
                        Root:PivotTo(playerPos)
                    elseif v3[3] ~= "" and pet.name then
                        if (v3[4] == pet.rarity or string.find(pet.name, v3[4])) and v3[2] >= v2.Price and
                            (v3[3] == pet.type or v3[3] == "Any" or v3[3] == pet.sh) then
                            b = boothLocations[tonumber(i)]
                            teleportToBooth(b)
                            purchased = attemptPurchase(tonumber(i), i2, v2.Price)
                            Root:PivotTo(playerPos)
                        end
                    end
                    if purchased then
                        break
                    end
                end
                if purchased then
                    break
                end
            end
            if purchased then
                purchased = false
                task.wait(5)
                break
            end
        end
    end
end)
