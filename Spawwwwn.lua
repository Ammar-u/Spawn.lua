-- Blox Fruits Real-Mesh Visual Rain v3
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("FruitRainV3Screen") then
    PlayerGui.FruitRainV3Screen:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FruitRainV3Screen"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 180)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -90)
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
Title.Text = "FRUIT RAIN v3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.ZIndex = 2
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 135)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "System Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextSize = 14
StatusLabel.ZIndex = 2
StatusLabel.Parent = MainFrame

-- Official Game Asset IDs for Fruit Mesh rendering
local FruitList = {
    {name = "Kitsune", mesh = "rbxassetid://15545227129", tex = "rbxassetid://15545227110", color = Color3.fromRGB(255, 100, 150)},
    {name = "Dragon", mesh = "rbxassetid://4991166487", tex = "rbxassetid://4991166472", color = Color3.fromRGB(80, 20, 20)},
    {name = "Leopard", mesh = "rbxassetid://11181285227", tex = "rbxassetid://11181285194", color = Color3.fromRGB(220, 180, 100)},
    {name = "Dough", mesh = "rbxassetid://9733471018", tex = "rbxassetid://9733470984", color = Color3.fromRGB(240, 230, 210)},
    {name = "Magma", mesh = "rbxassetid://5117361952", tex = "rbxassetid://5117361937", color = Color3.fromRGB(255, 60, 0)}
}

local RainButton = Instance.new("TextButton")
RainButton.Name = "RainButton"
RainButton.Size = UDim2.new(0, 260, 0, 45)
RainButton.Position = UDim2.new(0.5, -130, 0, 65)
RainButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
RainButton.Text = "RAIN FRUITS: OFF"
RainButton.TextColor3 = Color3.fromRGB(255, 85, 85)
RainButton.Font = Enum.Font.GothamBold
RainButton.TextSize = 15
RainButton.ZIndex = 2
RainButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = RainButton

local rainActive = false

-- Handles background falling and interactive picking touch states locally
task.spawn(function()
    local rng = Random.new()
    while true do
        task.wait(0.6) -- Adjust timing interval for fruit drop rates
        if rainActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local chosenData = FruitList[rng:NextInteger(1, #FruitList)]
            
            -- Create a local equippable Tool box container instance
            local localTool = Instance.new("Tool")
            localTool.Name = chosenData.name .. " Fruit"
            localTool.RequiresHandle = true
            
            local handle = Instance.new("MeshPart")
            handle.Name = "Handle"
            handle.Size = Vector3.new(1.8, 1.8, 1.8)
            handle.CanCollide = true -- Allows it to hit the ground naturally
            handle.Color = chosenData.color
            
            pcall(function()
                handle.MeshId = chosenData.mesh
                if chosenData.tex ~= "" then
                    handle.TextureID = chosenData.tex
                end
            end)
            
            handle.Parent = localTool
            
            -- Set local spawn trajectory drops right over player surroundings
            local rootPos = LocalPlayer.Character.HumanoidRootPart.Position
            handle.Position = rootPos + Vector3.new(rng:NextNumber(-25, 25), 45, rng:NextNumber(-25, 25))
            
            -- Place in client directory workspace structure safely
            localTool.Parent = workspace
            
            -- Trigger immediate pickup on touch locally
            local connection
            connection = handle.Touched:Connect(function(hit)
                local char = LocalPlayer.Character
                if char and hit:IsDescendantOf(char) and char:FindFirstChild("Humanoid") then
                    connection:Disconnect()
                    char.Humanoid:EquipTool(localTool)
                    StatusLabel.Text = "Status: Successfully Picked Up!"
                    StatusLabel.TextColor3 = Color3.fromRGB(85, 255, 85)
                    task.delay(2, function()
                        if StatusLabel.Text == "Status: Successfully Picked Up!" then
                            StatusLabel.Text = "System Status: Active"
                            StatusLabel.TextColor3 = Color3.fromRGB(85, 255, 85)
                        end
                    end)
                end
            end)
            
            -- Automatically cleans uncollected debris drop boxes after 15 seconds
            task.delay(15, function()
                if localTool and localTool.Parent == workspace then
                    if connection then connection:Disconnect() end
                    localTool:Destroy()
                end
            end)
        end
    end
end)

RainButton.MouseButton1Click:Connect(function()
    rainActive = not rainActive
    
    local clickSound = Instance.new("Sound")
    clickSound.SoundId = "rbxassetid://12221967"
    clickSound.Volume = 0.5
    clickSound.Parent = SoundService
    clickSound:Play()
    game:GetService("Debris"):AddItem(clickSound, 1)

    if rainActive then
        RainButton.Text = "RAIN FRUITS: ON"
        RainButton.BackgroundColor3 = Color3.fromRGB(35, 55, 35)
        RainButton.TextColor3 = Color3.fromRGB(85, 255, 85)
        StatusLabel.Text = "System Status: Active"
        StatusLabel.TextColor3 = Color3.fromRGB(85, 255, 85)
    else
        RainButton.Text = "RAIN FRUITS: OFF"
        RainButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        RainButton.TextColor3 = Color3.fromRGB(255, 85, 85)
        StatusLabel.Text = "System Status: Idle"
        StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
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
    rainActive = false
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
