-- Roblox Fruit Spawner Visual Menu v1
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Prevent duplicate GUIs from stacking
if PlayerGui:FindFirstChild("FruitSpawnerScreen") then
    PlayerGui.FruitSpawnerScreen:Destroy()
end

-- Create ScreenGui inside PlayerGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FruitSpawnerScreen"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Create Main Frame (Draggable Menu)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 240)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Sparking Background Panel
local BackgroundAnim = Instance.new("Frame")
BackgroundAnim.Name = "BackgroundAnim"
BackgroundAnim.Size = UDim2.new(1, -6, 1, -6)
BackgroundAnim.Position = UDim2.new(0, 3, 0, 3)
BackgroundAnim.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BackgroundAnim.BorderSizePixel = 0
BackgroundAnim.ZIndex = 1
BackgroundAnim.Parent = MainFrame

local AnimCorner = Instance.new("UICorner")
AnimCorner.CornerRadius = UDim.new(0, 10)
AnimCorner.Parent = BackgroundAnim

-- Title Text
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "FRUIT SPAWNER v1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.ZIndex = 2
Title.Parent = MainFrame

-- Fruit Input TextBox
local TextBox = Instance.new("TextBox")
TextBox.Name = "FruitInput"
TextBox.Size = UDim2.new(0, 260, 0, 40)
TextBox.Position = UDim2.new(0.5, -130, 0, 60)
TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextBox.Text = ""
TextBox.PlaceholderText = "Enter Fruit Name (e.g. Dragon)..."
TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.GothamSemibold
TextBox.TextSize = 14
TextBox.ZIndex = 2
TextBox.Parent = MainFrame

local TextCorner = Instance.new("UICorner")
TextCorner.CornerRadius = UDim.new(0, 8)
TextCorner.Parent = TextBox

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 195)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "System Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextSize = 14
StatusLabel.ZIndex = 2
StatusLabel.Parent = MainFrame

-- Fake Spawn Button (Moves item from real BackPack inventory to character hands)
local SpawnButton = Instance.new("TextButton")
SpawnButton.Name = "SpawnButton"
SpawnButton.Size = UDim2.new(0, 260, 0, 45)
SpawnButton.Position = UDim2.new(0.5, -130, 0, 120)
SpawnButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpawnButton.Text = "SPAWN FRUIT"
SpawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnButton.Font = Enum.Font.GothamBold
SpawnButton.TextSize = 15
SpawnButton.ZIndex = 2
SpawnButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = SpawnButton

SpawnButton.MouseButton1Click:Connect(function()
    local inputName = string.lower(TextBox.Text):gsub("%s+", "")
    
    -- Play visual click sound
    local clickSound = Instance.new("Sound")
    clickSound.SoundId = "rbxassetid://12221967"
    clickSound.Volume = 0.5
    clickSound.Parent = SoundService
    clickSound:Play()
    game:GetService("Debris"):AddItem(clickSound, 1)

    if inputName == "" then
        StatusLabel.Text = "Error: Please enter a fruit name!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
        return
    end

    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local foundItem = nil

    -- Look for a tool matching the text inside the player's real inventory folder
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") and string.lower(item.Name):gsub("%s+", ""):find(inputName) then
            foundItem = item
            break
        end
    end

    if foundItem then
        -- Forces the character to equip it directly into their hand
        LocalPlayer.Character.Humanoid:EquipTool(foundItem)
        StatusLabel.Text = "Status: Successfully Spawned!"
        StatusLabel.TextColor3 = Color3.fromRGB(85, 255, 85)
    else
        StatusLabel.Text = "Error: Fruit not found in database!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
    end
    
    task.delay(3, function()
        StatusLabel.Text = "System Status: Idle"
        StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    end)
end)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.ZIndex = 3
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Sparking Loop
task.spawn(function()
    local rng = Random.new()
    while ScreenGui.Parent do
        if rng:NextNumber() > 0.4 then
            BackgroundAnim.BackgroundColor3 = Color3.fromRGB(230, 230, 255)
            task.wait(rng:NextNumber(0.02, 0.05))
            BackgroundAnim.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            task.wait(rng:NextNumber(0.03, 0.08))
            BackgroundAnim.BackgroundColor3 = Color3.fromRGB(120, 120, 150)
            task.wait(rng:NextNumber(0.01, 0.03))
        end
        BackgroundAnim.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        task.wait(rng:NextNumber(0.1, 0.4))
    end
end)
