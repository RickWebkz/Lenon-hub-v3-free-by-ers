-- =====================================================
-- PRIME-HUB - Speed Hack + Re-Server
-- Delta Executor
-- by ers
-- =====================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ===== АЙНЫМАЛЫ =====
local speedEnabled = false
local speedValue = 50
local isMenuOpen = false
local guiParent = nil

-- ===== DELTA ҚАУІПСІЗ GUI PARENT =====
do
    local ok, result = pcall(function() return gethui() end)
    if ok and result then
        guiParent = result
    else
        local ok2, result2 = pcall(function()
            return game:GetService("CoreGui")
        end)
        if ok2 and result2 then
            guiParent = result2
        else
            guiParent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end
end

-- ===== GUI =====
local sg = Instance.new("ScreenGui")
sg.Name = "PrimeHub"
sg.Parent = guiParent
sg.ResetOnSpawn = false

-- Түстер
local NEON_PURPLE = Color3.fromRGB(180, 80, 255)
local NEON_PURPLE_LIGHT = Color3.fromRGB(210, 150, 255)
local DARK_PURPLE = Color3.fromRGB(25, 10, 45)
local DARKER_PURPLE = Color3.fromRGB(15, 5, 30)

-- ===== FLOATING ICON (PRIME-HUB) =====
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 130, 0, 42)
icon.Position = UDim2.new(0.02, 0, 0.15, 0)
icon.BackgroundColor3 = DARK_PURPLE
icon.BackgroundTransparency = 0.1
icon.BorderSizePixel = 0
icon.Text = "PRIME-HUB"
icon.TextColor3 = NEON_PURPLE
icon.TextScaled = true
icon.Font = Enum.Font.GothamBold
icon.Draggable = true
icon.Parent = sg

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 10)
iconCorner.Parent = icon

local iconStroke = Instance.new("UIStroke")
iconStroke.Color = NEON_PURPLE
iconStroke.Thickness = 2
iconStroke.Transparency = 0.2
iconStroke.Parent = icon

-- Icon ішіндегі padding (мәтін жиектерге тиіп кетпеуі үшін)
local iconPadding = Instance.new("UIPadding")
iconPadding.PaddingLeft = UDim.new(0, 10)
iconPadding.PaddingRight = UDim.new(0, 10)
iconPadding.Parent = icon

-- ===== MENU =====
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 280, 0, 0)
menu.Position = UDim2.new(0.02, 0, 0.15, 48)
menu.BackgroundColor3 = DARKER_PURPLE
menu.BackgroundTransparency = 0.05
menu.BorderSizePixel = 0
menu.ClipsDescendants = true
menu.Visible = false
menu.Parent = sg

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 14)
menuCorner.Parent = menu

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = NEON_PURPLE
menuStroke.Thickness = 2
menuStroke.Transparency = 0.1
menuStroke.Parent = menu

-- Menu Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = DARK_PURPLE
header.BackgroundTransparency = 0.3
header.Text = "⚡ PRIME-HUB"
header.TextColor3 = NEON_PURPLE
header.TextScaled = true
header.Font = Enum.Font.GothamBold
header.Parent = menu

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

-- ===== SPEED HACK SWITCH =====
local speedRow = Instance.new("Frame")
speedRow.Size = UDim2.new(1, -20, 0, 35)
speedRow.Position = UDim2.new(0, 10, 0, 50)
speedRow.BackgroundTransparency = 1
speedRow.Parent = menu

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.6, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "🏃 SPEED HACK"
speedLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
speedLabel.TextSize = 14
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = speedRow

local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0, 55, 1, -6)
speedBtn.Position = UDim2.new(0.72, 0, 0, 3)
speedBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
speedBtn.BackgroundTransparency = 0.2
speedBtn.Text = "OFF"
speedBtn.TextColor3 = Color3.fromRGB(255, 100, 150)
speedBtn.TextSize = 13
speedBtn.Font = Enum.Font.GothamBold
speedBtn.BorderSizePixel = 0
speedBtn.Parent = speedRow

local speedBtnCorner = Instance.new("UICorner")
speedBtnCorner.CornerRadius = UDim.new(0, 8)
speedBtnCorner.Parent = speedBtn

-- ===== SPEED VALUE INPUT =====
local speedInputRow = Instance.new("Frame")
speedInputRow.Size = UDim2.new(1, -20, 0, 35)
speedInputRow.Position = UDim2.new(0, 10, 0, 90)
speedInputRow.BackgroundTransparency = 1
speedInputRow.Parent = menu

local speedInputLabel = Instance.new("TextLabel")
speedInputLabel.Size = UDim2.new(0.5, 0, 1, 0)
speedInputLabel.BackgroundTransparency = 1
speedInputLabel.Text = "⚡ SPEED:"
speedInputLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
speedInputLabel.TextSize = 14
speedInputLabel.TextXAlignment = Enum.TextXAlignment.Left
speedInputLabel.Font = Enum.Font.Gotham
speedInputLabel.Parent = speedInputRow

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.35, 0, 0, 26)
speedInput.Position = UDim2.new(0.5, 0, 0, 4)
speedInput.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
speedInput.BackgroundTransparency = 0.2
speedInput.TextColor3 = NEON_PURPLE
speedInput.TextSize = 14
speedInput.Font = Enum.Font.GothamBold
speedInput.Text = "50"
speedInput.PlaceholderText = "1-300"
speedInput.BorderSizePixel = 0
speedInput.Parent = speedInputRow

local speedInputCorner = Instance.new("UICorner")
speedInputCorner.CornerRadius = UDim.new(0, 8)
speedInputCorner.Parent = speedInput

-- ===== RE-SERVER BUTTON =====
local reServerBtn = Instance.new("TextButton")
reServerBtn.Size = UDim2.new(1, -20, 0, 40)
reServerBtn.Position = UDim2.new(0, 10, 0, 135)
reServerBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 140)
reServerBtn.BackgroundTransparency = 0.15
reServerBtn.Text = "🔄 RE-SERVER"
reServerBtn.TextColor3 = Color3.fromRGB(220, 180, 255)
reServerBtn.TextSize = 15
reServerBtn.Font = Enum.Font.GothamBold
reServerBtn.BorderSizePixel = 0
reServerBtn.Parent = menu

local reServerCorner = Instance.new("UICorner")
reServerCorner.CornerRadius = UDim.new(0, 10)
reServerCorner.Parent = reServerBtn

local reServerStroke = Instance.new("UIStroke")
reServerStroke.Color = NEON_PURPLE
reServerStroke.Thickness = 1.5
reServerStroke.Transparency = 0.3
reServerStroke.Parent = reServerBtn

-- ===== STATUS LABEL =====
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 180)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "⚡ Дайын"
statusLabel.TextColor3 = Color3.fromRGB(150, 120, 200)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = menu

-- ===== MENU ANIMATION =====
local menuOpen = false

local function ToggleMenu()
    menuOpen = not menuOpen
    menu.Visible = true
    
    local targetSize = menuOpen and UDim2.new(0, 280, 0, 215) or UDim2.new(0, 280, 0, 0)
    
    local tween = TweenService:Create(
        menu,
        TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = targetSize}
    )
    tween:Play()
    
    if not menuOpen then
        tween.Completed:Connect(function()
            if not menuOpen then
                menu.Visible = false
            end
        end)
    end
end

icon.MouseButton1Click:Connect(ToggleMenu)
icon.TouchTap:Connect(ToggleMenu)

-- ===== SPEED HACK ЛОГИКАСЫ =====
local function ApplySpeed()
    if not speedEnabled then return end
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedValue
        end
    end
end

local function ToggleSpeed()
    speedEnabled = not speedEnabled
    speedBtn.Text = speedEnabled and "ON" or "OFF"
    speedBtn.TextColor3 = speedEnabled and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 100, 150)
    speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(20, 80, 50) or Color3.fromRGB(35, 20, 55)
    
    if speedEnabled then
        local ok, val = pcall(function() return tonumber(speedInput.Text) end)
        if ok and val then
            speedValue = math.clamp(val, 1, 300)
            speedInput.Text = tostring(speedValue)
        end
        ApplySpeed()
        statusLabel.Text = "⚡ Speed: " .. speedValue
    else
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
        statusLabel.Text = "⚡ Дайын"
    end
end

speedBtn.MouseButton1Click:Connect(ToggleSpeed)
speedBtn.TouchTap:Connect(ToggleSpeed)

-- Speed value өзгергенде
speedInput.FocusLost:Connect(function()
    local ok, val = pcall(function() return tonumber(speedInput.Text) end)
    if ok and val then
        speedValue = math.clamp(val, 1, 300)
        speedInput.Text = tostring(speedValue)
        if speedEnabled then
            ApplySpeed()
        end
    else
        speedInput.Text = tostring(speedValue)
    end
end)

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if speedEnabled then
        ApplySpeed()
    end
end)

-- ===== RE-SERVER ЛОГИКАСЫ =====
local function HopToLowestServer()
    statusLabel.Text = "🔄 Сервер іздестірілуде..."
    
    local placeId = game.PlaceId
    local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local ok, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not ok or not response then
        statusLabel.Text = "❌ Сервер тізімі алынбады"
        reServerBtn.Text = "🔄 RE-SERVER"
        return
    end
    
    local decodeOk, decoded = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    
    if not decodeOk or not decoded or not decoded.data then
        statusLabel.Text = "❌ JSON қате"
        reServerBtn.Text = "🔄 RE-SERVER"
        return
    end
    
    -- Ең аз ойыншысы бар серверді табу
    local bestServer = nil
    local lowestCount = math.huge
    
    for _, server in ipairs(decoded.data) do
        if server.id and server.id ~= game.JobId and server.playing and server.playing < server.maxPlayers then
            if server.playing < lowestCount then
                lowestCount = server.playing
                bestServer = server
            end
        end
    end
    
    if bestServer then
        statusLabel.Text = "🔄 Телепорт: " .. bestServer.playing .. " ойыншы"
        task.wait(0.5)
        TeleportService:TeleportToPlaceInstance(placeId, bestServer.id, LocalPlayer)
    else
        statusLabel.Text = "❌ Бос сервер табылмады"
        reServerBtn.Text = "🔄 RE-SERVER"
    end
end

local function OnReServer()
    if reServerBtn.Text == "🔄 RE-SERVER" then
        reServerBtn.Text = "⏳ ІЗДЕУДЕ..."
        HopToLowestServer()
    end
end

reServerBtn.MouseButton1Click:Connect(OnReServer)
reServerBtn.TouchTap:Connect(OnReServer)

-- ===== ІСКЕ ҚОСУ =====
print("⚡ PRIME-HUB by ers - Жүктелді!")
print("💜 Күлгін неон дизайн")
print("🏃 Speed Hack + 🔄 Re-Server")
