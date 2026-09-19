-- Blox Fruits Real-Mesh Visual Spawner v2
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("RealFruitSpawnerScreen") then
    PlayerGui.RealFruitSpawnerScreen:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RealFruitSpawnerScreen"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

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

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "FRUIT SPAWNER v2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.ZIndex = 2
Title.Parent = MainFrame

local TextBox = Instance.new("TextBox")
TextBox.Name = "FruitInput"
TextBox.Size = UDim2.new(0, 260, 0, 40)
TextBox.Position = UDim2.new(0.5, -130, 0, 60)
TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextBox.Text = ""
TextBox.PlaceholderText = "Type Fruit Name (e.g., Kitsune)..."
TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.GothamSemibold
TextBox.TextSize = 14
TextBox.ZIndex = 2
TextBox.Parent = MainFrame

local TextCorner = Instance.new("UICorner")
TextCorner.CornerRadius = UDim.new(0, 8)
TextCorner.Parent = TextBox

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

-- Official Assets database mapping to load game meshes locally
local FruitDatabase = {
    ["kitsune"] = {mesh = "rbxassetid://15545227129", tex = "rbxassetid://15545227110", color = Color3.fromRGB(255, 100, 150)},
    ["dragon"] = {mesh = "rbxassetid://4991166487", tex = "rbxassetid://4991166472", color = Color3.fromRGB(80, 20, 20)},
    ["leopard"] = {mesh = "rbxassetid://11181285227", tex = "rbxassetid://11181285194", color = Color3.fromRGB(220, 180, 100)},
    ["dough"] = {mesh = "rbxassetid://9733471018", tex = "rbxassetid://9733470984", color = Color3.fromRGB(240, 230, 210)},
    ["magma"] = {mesh = "rbxassetid://5117361952", tex = "rbxassetid://5117361937", color = Color3.fromRGB(255, 60, 0)},
    ["default"] = {mesh = "rbxassetid://430030048", tex = "", color = Color3.fromRGB(200, 50, 50)}
}

local SpawnButton = Instance.new("TextButton")
SpawnButton.Name = "SpawnButton"
SpawnButton.Size = UDim2.new(0, 260, 0, 45)
SpawnButton.Position = UDim2.new(0.5, -130, 0, 120)
SpawnButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpawnButton.Text = "SPAWN REAL VISUAL"
SpawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnButton.Font = Enum.Font.GothamBold
SpawnButton.TextSize = 15
SpawnButton.ZIndex = 2
SpawnButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = SpawnButton

SpawnButton.MouseButton1Click:Connect(function()
    local cleanName = string.lower(TextBox.Text):gsub("%s+", "")
    local character = LocalPlayer.Character
    
    if not character or not character:FindFirstChild("Humanoid") then
        StatusLabel.Text = "Error: Character model missing!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
        return
    end

    local clickSound = Instance.new("Sound")
    clickSound.SoundId = "rbxassetid://12221967"
    clickSound.Volume = 0.5
    clickSound.Parent = SoundService
    clickSound:Play()
    game:GetService("Debris"):AddItem(clickSound, 1)

    local targetFruit = FruitDatabase[cleanName] or FruitDatabase["default"]
    
    -- Construct a proper Local equippable tool structure
    local cleanToolName = cleanName ~= "" and TextBox.Text or "Fruit"
    local newTool = Instance.new("Tool")
    newTool.Name = cleanToolName .. " Fruit"
    newTool.RequiresHandle = true

    -- Create Handle MeshPart to display official asset graphics
    local handle = Instance.new("MeshPart")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1.8, 1.8, 1.8)
    handle.CanCollide = false
    
    -- Safe execution injection of meshes safely
    pcall(function()
        handle.MeshId = targetFruit.mesh
        if targetFruit.tex ~= "" then
            handle.TextureID = targetFruit.tex
        end
    end)
    
    handle.Color = targetFruit.color
    handle.Parent = newTool

    -- Attaches directly into the character right hand locally
    character.Humanoid:EquipTool(newTool)

    StatusLabel.Text = "Status: Successfully Spawned!"
    StatusLabel.TextColor3 = Color3.fromRGB(85, 255, 85)

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
