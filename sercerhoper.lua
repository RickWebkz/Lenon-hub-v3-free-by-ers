-- PRIME-HUB UI shell (Luau)
-- Visual menu only. It does not modify another game's movement, ragdoll, or grab mechanics.
-- Upload the PRIME-HUB image to Roblox and replace IMAGE_ID below with its asset ID.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local IMAGE_ID = "rbxassetid://98208788131775" -- Replace with your uploaded image asset ID

local gui = Instance.new("ScreenGui")
gui.Name = "PrimeHubUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

local function addStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Parent = parent
end

local purple = Color3.fromRGB(151, 54, 255)
local dark = Color3.fromRGB(17, 12, 28)
local panelColor = Color3.fromRGB(25, 18, 40)
local white = Color3.fromRGB(245, 240, 255)

-- Floating PRIME-HUB icon
local icon = Instance.new("ImageButton")
icon.Name = "PrimeHubFloatingIcon"
icon.Size = UDim2.fromOffset(66, 66)
icon.Position = UDim2.new(0, 24, 0.42, 0)
icon.BackgroundColor3 = dark
icon.Image = IMAGE_ID
icon.ScaleType = Enum.ScaleType.Fit
icon.Parent = gui
addCorner(icon, 33)
addStroke(icon, purple, 2)

-- Main menu
local panel = Instance.new("Frame")
panel.Name = "PrimeHubMenu"
panel.Size = UDim2.fromOffset(300, 310)
panel.Position = UDim2.new(0, 100, 0.32, 0)
panel.BackgroundColor3 = panelColor
panel.Visible = false
panel.Parent = gui
addCorner(panel, 14)
addStroke(panel, purple, 2)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 0, 42)
title.Position = UDim2.fromOffset(12, 8)
title.BackgroundTransparency = 1
title.Text = "♛  PRIME-HUB"
title.TextColor3 = white
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.Parent = panel

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -24, 0, 20)
subtitle.Position = UDim2.fromOffset(12, 43)
subtitle.BackgroundTransparency = 1
subtitle.Text = "CONTROL PANEL"
subtitle.TextColor3 = purple
subtitle.Font = Enum.Font.GothamBold
subtitle.TextSize = 11
subtitle.Parent = panel

local function makeSwitchRow(name, y)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -24, 0, 42)
    row.Position = UDim2.fromOffset(12, y)
    row.BackgroundColor3 = dark
    row.Parent = panel
    addCorner(row, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -86, 1, 0)
    label.Position = UDim2.fromOffset(10, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = white
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Parent = row

    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(62, 27)
    button.Position = UDim2.new(1, -72, 0.5, -13)
    button.BackgroundColor3 = Color3.fromRGB(70, 65, 80)
    button.Text = "OFF"
    button.TextColor3 = white
    button.Font = Enum.Font.GothamBold
    button.TextSize = 11
    button.Parent = row
    addCorner(button, 7)

    local enabled = false
    button.Activated:Connect(function()
        enabled = not enabled
        button.Text = enabled and "ON" or "OFF"
        button.BackgroundColor3 = enabled and purple or Color3.fromRGB(70, 65, 80)
    end)

    return button
end

makeSwitchRow("SPEED HACK", 76)

local speedRow = Instance.new("Frame")
speedRow.Size = UDim2.new(1, -24, 0, 66)
speedRow.Position = UDim2.fromOffset(12, 124)
speedRow.BackgroundColor3 = dark
speedRow.Parent = panel
addCorner(speedRow, 8)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 24)
speedLabel.Position = UDim2.fromOffset(10, 4)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "SPEED: 16"
speedLabel.TextColor3 = white
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 12
speedLabel.Parent = speedRow

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, -24, 0, 8)
sliderTrack.Position = UDim2.fromOffset(12, 42)
sliderTrack.BackgroundColor3 = Color3.fromRGB(68, 54, 84)
sliderTrack.Parent = speedRow
addCorner(sliderTrack, 4)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(16 / 1500, 0, 1, 0)
sliderFill.BackgroundColor3 = purple
sliderFill.Parent = sliderTrack
addCorner(sliderFill, 4)

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(1, 0, 0, 28)
sliderButton.Position = UDim2.new(0, 0, 0, -10)
sliderButton.BackgroundTransparency = 1
sliderButton.Text = ""
sliderButton.Parent = sliderTrack

local speedValue = 16
local draggingSlider = false

local function setSliderFromX(x)
    local width = math.max(sliderTrack.AbsoluteSize.X, 1)
    local alpha = math.clamp((x - sliderTrack.AbsolutePosition.X) / width, 0, 1)
    speedValue = math.floor(alpha * 1500 + 0.5)
    sliderFill.Size = UDim2.new(alpha, 0, 1, 0)
    speedLabel.Text = "SPEED: " .. tostring(speedValue)
end

sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
        setSliderFromX(input.Position.X)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        setSliderFromX(input.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

makeSwitchRow("ANTI RAGDOLL", 198)
makeSwitchRow("INSTANT GRAB", 246)

icon.Activated:Connect(function()
    panel.Visible = not panel.Visible
end)

-- Drag the floating icon with mouse or touch.
local draggingIcon = false
local dragStart
local startPosition

icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingIcon = true
        dragStart = input.Position
        startPosition = icon.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingIcon and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        icon.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        draggingIcon = false
    end
end)
