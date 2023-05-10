writefile("petList.txt", "Pets")
for i, v in pairs(game:GetService("ReplicatedStorage")["__DIRECTORY"].Pets:GetChildren()) do
    appendfile("petList.txt", "\n")
    appendfile("petList.txt", v.Name)
end
