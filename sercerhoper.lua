-- ======================================================
-- PRIME-HUB | Neon Purple Edition (Delta Compatible)
-- ======================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Бұрын ашылған GUI болса жою
if CoreGui:FindFirstChild("PrimeHub_Delta") then
    CoreGui.PrimeHub_Delta:Destroy()
end

-- Негізгі ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PrimeHub_Delta"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

-- 1. Қалқымалы иконка (Floating Icon)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "FloatingIcon"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 10, 45)
ToggleButton.Position = UDim2.new(0.08, 0, 0.15, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "PH"
ToggleButton.TextColor3 = Color3.fromRGB(210, 120, 255)
ToggleButton.TextSize = 18
ToggleButton.Draggable = true
ToggleButton.Active = true

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 12)
UICornerBtn.Parent = ToggleButton

local UIStrokeBtn = Instance.new("UIStroke")
UIStrokeBtn.Color = Color3.fromRGB(160, 32, 240)
UIStrokeBtn.Thickness = 2.5
UIStrokeBtn.Parent = ToggleButton

-- 2. Негізгі Меню (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 6, 28)
MainFrame.Position = UDim2.new(0.08, 0, 0.15, 60)
MainFrame.Size = UDim2.new(0, 260, 0, 0) -- Төмен созылу үшін бастапқы биіктік 0
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
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "PRIME - HUB"
Title.TextColor3 = Color3.fromRGB(230, 150, 255)
Title.TextSize = 18

-- Контейнер
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 40)
Container.Size = UDim2.new(1, -20, 1, -50)
Container.CanvasSize = UDim2.new(0, 0, 0, 240)
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(160, 32, 240)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Менюді созып ашу / жабу анимациясы
local menuOpen = false
ToggleButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    local targetSize = menuOpen and UDim2.new(0, 260, 0, 250) or UDim2.new(0, 260, 0, 0)
    local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(MainFrame, tweenInfo, {Size = targetSize}):Play()
end)

-- ======================================================
-- ВАРУИРОВКА ЛОГИКАСЫ ЖӘНЕ ФУНКЦИЯЛАР
-- ======================================================

local currentSpeed = 16
local speedHackActive = false
local antiRagdollActive = false
local instantGrabActive = false

-- 1. SPEED HACK ЭЛЕМЕНТІ
local speedFrame = Instance.new("Frame")
speedFrame.Parent = Container
speedFrame.BackgroundColor3 = Color3.fromRGB(30, 12, 55)
speedFrame.Size = UDim2.new(1, 0, 0, 55)

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = speedFrame
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 10, 0, 5)
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.Text = "SPEED HACK (16 - 300)"
speedLabel.TextColor3 = Color3.fromRGB(200, 130, 255)
speedLabel.TextSize = 12
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedBox = Instance.new("TextBox")
speedBox.Parent = speedFrame
speedBox.BackgroundColor3 = Color3.fromRGB(18, 6, 32)
speedBox.Position = UDim2.new(0, 10, 0, 28)
speedBox.Size = UDim2.new(1, -20, 0, 20)
speedBox.Font = Enum.Font.Gotham
speedBox.PlaceholderText = "Жылдамдық енгіз (16-300)..."
speedBox.Text = ""
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 12

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = speedBox

speedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(speedBox.Text)
        if val then
            if val < 16 then val = 16 end
            if val > 300 then val = 300 end
            currentSpeed = val
            speedHackActive = true
            speedBox.Text = "Орнатылды: " .. tostring(currentSpeed)
        else
            speedHackActive = false
            speedBox.Text = ""
        end
    end
end)

-- Loop: Жылдамдықты үнемі бақылау (Delta анти-ресет)
RunService.Stepped:Connect(function()
    if speedHackActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = currentSpeed
    end
end)

-- 2. TOGGLE ЖАСАУ КӨМЕКШІСІ
local function createToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.BackgroundColor3 = Color3.fromRGB(30, 12, 55)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.GothamBold
    btn.Text = "  " .. name .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = "  " .. name .. " [ON]"
            btn.TextColor3 = Color3.fromRGB(220, 120, 255)
            btn.BackgroundColor3 = Color3.fromRGB(60, 20, 100)
        else
            btn.Text = "  " .. name .. " [OFF]"
            btn.TextColor3 = Color3.fromRGB(180, 180, 200)
            btn.BackgroundColor3 = Color3.fromRGB(30, 12, 55)
        end
        callback(state)
    end)
end

-- ANTI RAGDOLL
createToggle("ANTI RAGDOLL", function(state)
    antiRagdollActive = state
end)

RunService.Heartbeat:Connect(function()
    if antiRagdollActive and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Ragdoll күйлерін болдырмау
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            if hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum:GetState() == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
end)

-- INSTANT GRAB
createToggle("INSTANT GRAB", function(state)
    instantGrabActive = state
end)

-- ProximityPrompt (Заттарды/зат ұстауды бірден ашу)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if instantGrabActive then
        fireproximityprompt(prompt)
    end
end)
