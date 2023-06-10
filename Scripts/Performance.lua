if not game:IsLoaded() then
    game.Loaded:Wait()
end
wait(5)
setfpscap(2)
local uis = game:GetService("UserInputService")
uis.WindowFocused:Connect(function()
    setfpscap(2)
    game:GetService("RunService"):Set3dRenderingEnabled(true)
end)

uis.WindowFocusReleased:Connect(function()
    setfpscap(2)
    game:GetService("RunService"):Set3dRenderingEnabled(false)
end)
game:GetService("RunService"):Set3dRenderingEnabled(false)
