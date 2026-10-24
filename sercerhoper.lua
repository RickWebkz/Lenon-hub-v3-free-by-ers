-- ======================================================
-- PRIME-HUB | Neon Purple Edition (Fixed for Delta)
-- ======================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Бұрынғы GUI-ді тазалау
if CoreGui:FindFirstChild("PrimeHubFixed") then
    CoreGui.PrimeHubFixed:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PrimeHubFixed"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

-- Басты Контейнер (Иконка мен Меню бірге жылжуы үшін)
local MainHolder = Instance.new("Frame")
MainHolder.Name = "MainHolder"
MainHolder.Parent = ScreenGui
MainHolder.BackgroundTransparency = 1
MainHolder.Position = UDim2.new(0.1, 0, 0.2, 0)
MainHolder.Size = UDim2.new(0, 260, 0, 300)

-- 1. Қалқымалы Иконка (Floating Icon)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "FloatingIcon"
ToggleButton.Parent = MainHolder
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 10, 45)
ToggleButton.Position = UDim2.new(0, 0, 0, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "PH"
ToggleButton.TextColor3 = Color3.fromRGB(210, 120, 255)
ToggleButton.TextSize = 18

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 12)
UICornerBtn.Parent = ToggleButton

local UIStrokeBtn = Instance.new("UIStroke")
UIStrokeBtn.Color = Color3.fromRGB(160, 32, 240)
UIStrokeBtn.Thickness = 2.5
UIStrokeBtn.Parent = ToggleButton

-- 2. Негізгі Меню Frame (Төмен қарай ашылады)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = MainHolder
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 6, 28)
MainFrame.Position = UDim2.new(0, 0, 0, 55)
MainFrame.Size = UDim2.new(0, 260, 0, 0) -- Бастапқы биіктігі 0
MainFrame.ClipsDescendants = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 14)
UICornerMain.Parent = MainFrame

local UIStrokeMain = Instance.new("UIStroke")
UIStrokeMain.Color = Color3.fromRGB(140, 0, 255)
UIStrokeMain.Thickness = 2.5
UIStrokeMain.Parent = MainFrame

-- Тақырыбы
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 8)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "PRIME - HUB"
Title.TextColor3 = Color3.fromRGB(230, 150, 255)
Title.TextSize = 16

-- Контейнер
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 38)
Container.Size = UDim2.new(1, -20, 1, -48)
Container.CanvasSize = UDim2.new(0, 0, 0, 230)
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(160, 32, 240)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- ======================================================
-- СҮЙРЕУ ЛОГИКАСЫ (MainHolder-ді Иконка арқылы сүйреу)
-- ======================================================
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainHolder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainHolder.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Менюді ашу/жабу анимациясы
local menuOpen = false
ToggleButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    local targetSize = menuOpen and UDim2.new(0, 260, 0, 235) or UDim2.new(0, 260, 0, 0)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(MainFrame, tweenInfo, {Size = targetSize}):Play()
end)

-- ======================================================
-- ФУНКЦИЯЛАР
-- ======================================================

local targetSpeed = 16
local speedEnabled = false
local antiRagdollEnabled = false
local instantGrabEnabled = false

-- 1. SPEED HACK (16 - 300)
local speedFrame = Instance.new("Frame")
speedFrame.Parent = Container
speedFrame.BackgroundColor3 = Color3.fromRGB(30, 12, 55)
speedFrame.Size = UDim2.new(1, 0, 0, 52)

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = speedFrame
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 10, 0, 4)
speedLabel.Size = UDim2.new(1, -20, 0, 18)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.Text = "SPEED HACK (16 - 300)"
speedLabel.TextColor3 = Color3.fromRGB(200, 130, 255)
speedLabel.TextSize = 11
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedBox = Instance.new("TextBox")
speedBox.Parent = speedFrame
speedBox.BackgroundColor3 = Color3.fromRGB(18, 6, 32)
speedBox.Position = UDim2.new(0, 10, 0, 24)
speedBox.Size = UDim2.new(1, -20, 0, 22)
speedBox.Font = Enum.Font.Gotham
speedBox.PlaceholderText = "16 - 300 аралығын жаз..."
speedBox.Text = ""
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 12

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = speedBox

speedBox.FocusLost:Connect(function()
    local num = tonumber(speedBox.Text)
    if num then
        if num < 16 then num = 16 end
        if num > 300 then num = 300 end
        targetSpeed = num
        speedEnabled = true
        speedBox.Text = "Жылдамдық: " .. tostring(targetSpeed)
    else
        speedEnabled = false
        speedBox.Text = ""
    end
end)

-- Speed Hack циклы
RunService.RenderStepped:Connect(function()
    if speedEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = targetSpeed
        end
    end
end)

-- 2. TOGGLE КӨМЕКШІСІ
local function createToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.BackgroundColor3 = Color3.fromRGB(30, 12, 55)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Font = Enum.Font.GothamBold
    btn.Text = "  " .. name .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.Text = "  " .. name .. " [ON]"
            btn.TextColor3 = Color3.fromRGB(220, 120, 255)
            btn.BackgroundColor3 = Color3.fromRGB(60, 20, 100)
        else
            btn.Text = "  " .. name .. " [OFF]"
            btn.TextColor3 = Color3.fromRGB(180, 180, 200)
            btn.BackgroundColor3 = Color3.fromRGB(30, 12, 55)
        end
        callback(active)
    end)
end

-- ANTI RAGDOLL
createToggle("ANTI RAGDOLL", function(state)
    antiRagdollEnabled = state
end)

RunService.Stepped:Connect(function()
    if antiRagdollEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            
            local currentState = hum:GetState()
            if currentState == Enum.HumanoidStateType.Ragdoll or currentState == Enum.HumanoidStateType.FallingDown or currentState == Enum.HumanoidStateType.PlatformStanding then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
end)

-- INSTANT GRAB
createToggle("INSTANT GRAB", function(state)
    instantGrabEnabled = state
end)

ProximityPromptService.PromptShown:Connect(function(prompt)
    if instantGrabEnabled then
        prompt.HoldDuration = 0
    end
end)

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if instantGrabEnabled then
        fireproximityprompt(prompt)
    end
end)
