-- =====================================================
-- PRIME-HUB - Full Edition (FIXED v2)
-- Delta Executor
-- by ers
-- =====================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local speedEnabled = false
local speedValue = 50
local menuOpen = false
local guiParent = nil
local speedConnection = nil
local antiRagdollEnabled = false
local antiRagdollConnection = nil
local instantGrabEnabled = false
local antiTpEnabled = false
local antiTpConnection = nil
local antiTpAttempts = 0
local antiTpMaxAttempts = 3
local lastPosition = nil

-- ===== GUI PARENT =====
do
    local ok, result = pcall(function() return gethui() end)
    if ok and result then guiParent = result
    else
        local ok2, result2 = pcall(function() return game:GetService("CoreGui") end)
        if ok2 and result2 then guiParent = result2
        else guiParent = LocalPlayer:WaitForChild("PlayerGui") end
    end
end

local NEON_PURPLE = Color3.fromRGB(180, 80, 255)
local DARK_PURPLE = Color3.fromRGB(25, 10, 45)
local DARKER_PURPLE = Color3.fromRGB(15, 5, 30)

-- ===== GUI =====
local sg = Instance.new("ScreenGui")
sg.Name = "PrimeHub"
sg.Parent = guiParent
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 42)
mainFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
mainFrame.BackgroundTransparency = 1
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = sg

local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 130, 0, 42)
icon.BackgroundColor3 = DARK_PURPLE
icon.BackgroundTransparency = 0.1
icon.BorderSizePixel = 0
icon.Text = "PRIME-HUB"
icon.TextColor3 = NEON_PURPLE
icon.TextScaled = true
icon.Font = Enum.Font.GothamBold
icon.AutoButtonColor = false
icon.Parent = mainFrame

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 10)
iconCorner.Parent = icon

local iconStroke = Instance.new("UIStroke")
iconStroke.Color = NEON_PURPLE
iconStroke.Thickness = 2
iconStroke.Transparency = 0.2
iconStroke.Parent = icon

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 280, 0, 0)
menu.Position = UDim2.new(0, 0, 0, 48)
menu.BackgroundColor3 = DARKER_PURPLE
menu.BackgroundTransparency = 0.05
menu.BorderSizePixel = 0
menu.ClipsDescendants = true
menu.Visible = false
menu.Parent = mainFrame

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 14)
menuCorner.Parent = menu

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = NEON_PURPLE
menuStroke.Thickness = 2
menuStroke.Transparency = 0.1
menuStroke.Parent = menu

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

local function CreateSwitch(text, yPos, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 35)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundTransparency = 1
    row.Parent = menu

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 180, 255)
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 55, 1, -6)
    btn.Position = UDim2.new(0.7, 0, 0, 3)
    btn.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
    btn.BackgroundTransparency = 0.2
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 100, 150)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = row

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.TextColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 100, 150)
        btn.BackgroundColor3 = state and Color3.fromRGB(20, 80, 50) or Color3.fromRGB(35, 20, 55)
        callback(state)
    end)
    return btn
end

local speedBtn = CreateSwitch("🏃 SPEED HACK", 50, function(state)
    speedEnabled = state
    ApplySpeed()
end)

local antiRagdollBtn = CreateSwitch("🧍 ANTI RAGDOLL", 85, function(state)
    antiRagdollEnabled = state
    if state then EnableAntiRagdoll() else DisableAntiRagdoll() end
end)

local instantGrabBtn = CreateSwitch("🎯 INSTANT GRAB", 120, function(state)
    instantGrabEnabled = state
end)

local antiTpBtn = CreateSwitch("🛡️ ANTI TP", 155, function(state)
    antiTpEnabled = state
    antiTpAttempts = 0
    if state then EnableAntiTp() else DisableAntiTp() end
end)

-- SPEED INPUT
local speedInputRow = Instance.new("Frame")
speedInputRow.Size = UDim2.new(1, -20, 0, 35)
speedInputRow.Position = UDim2.new(0, 10, 0, 190)
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
speedInput.Size = UDim2.new(0.4, 0, 0, 26)
speedInput.Position = UDim2.new(0.5, 0, 0, 4)
speedInput.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
speedInput.BackgroundTransparency = 0.2
speedInput.TextColor3 = NEON_PURPLE
speedInput.TextSize = 14
speedInput.Font = Enum.Font.GothamBold
speedInput.Text = "50"
speedInput.PlaceholderText = "1-1500"
speedInput.BorderSizePixel = 0
speedInput.ClearTextOnFocus = false
speedInput.Parent = speedInputRow

local speedInputCorner = Instance.new("UICorner")
speedInputCorner.CornerRadius = UDim.new(0, 8)
speedInputCorner.Parent = speedInput

-- RE-SERVER
local reServerBtn = Instance.new("TextButton")
reServerBtn.Size = UDim2.new(1, -20, 0, 40)
reServerBtn.Position = UDim2.new(0, 10, 0, 235)
reServerBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 140)
reServerBtn.BackgroundTransparency = 0.15
reServerBtn.Text = "🔄 RE-SERVER"
reServerBtn.TextColor3 = Color3.fromRGB(220, 180, 255)
reServerBtn.TextSize = 15
reServerBtn.Font = Enum.Font.GothamBold
reServerBtn.BorderSizePixel = 0
reServerBtn.AutoButtonColor = false
reServerBtn.Parent = menu

local reServerCorner = Instance.new("UICorner")
reServerCorner.CornerRadius = UDim.new(0, 10)
reServerCorner.Parent = reServerBtn

local reServerStroke = Instance.new("UIStroke")
reServerStroke.Color = NEON_PURPLE
reServerStroke.Thickness = 1.5
reServerStroke.Transparency = 0.3
reServerStroke.Parent = reServerBtn

-- STATUS
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 280)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "⚡ Дайын"
statusLabel.TextColor3 = Color3.fromRGB(150, 120, 200)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = menu

-- MENU ANIMATION
local function ToggleMenu()
    menuOpen = not menuOpen
    menu.Visible = true
    local targetSize = menuOpen and UDim2.new(0, 280, 0, 315) or UDim2.new(0, 280, 0, 0)
    local tween = TweenService:Create(menu, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = targetSize})
    tween:Play()
    if not menuOpen then
        tween.Completed:Connect(function()
            if not menuOpen then menu.Visible = false end
        end)
    end
end

icon.MouseButton1Click:Connect(ToggleMenu)

-- ===== SPEED HACK =====
function ApplySpeed()
    if speedConnection then speedConnection:Disconnect() speedConnection = nil end
    if not speedEnabled then
        local char = LocalPlayer.Character
        if char then
            local h = char:FindFirstChild("Humanoid")
            if h then h.WalkSpeed = 16 end
        end
        return
    end
    speedConnection = RunService.Heartbeat:Connect(function()
        if not speedEnabled then return end
        local char = LocalPlayer.Character
        if char then
            local h = char:FindFirstChild("Humanoid")
            if h and h.WalkSpeed ~= speedValue then h.WalkSpeed = speedValue end
        end
    end)
end

speedInput.FocusLost:Connect(function()
    local ok, val = pcall(function() return tonumber(speedInput.Text) end)
    if ok and val then
        speedValue = math.clamp(val, 1, 1500)
        speedInput.Text = tostring(speedValue)
        if speedEnabled then ApplySpeed() end
    else
        speedInput.Text = tostring(speedValue)
    end
end)

-- ===== ANTI RAGDOLL (ТҮЗЕТІЛГЕН) =====
function EnableAntiRagdoll()
    if antiRagdollConnection then antiRagdollConnection:Disconnect() end
    
    antiRagdollConnection = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- PlatformStand өшіру
            if humanoid.PlatformStand then
                humanoid.PlatformStand = false
            end
            
            -- Ragdoll күйін GettingUp-қа ауыстыру
            local state = humanoid:GetState()
            if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
        
        -- Ragdoll constraint-терін өшіру
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint") or obj:IsA("WeldConstraint") then
                local name = obj.Name:lower()
                if name:find("ragdoll") or name:find("joint") or name:find("socket") then
                    obj.Enabled = false
                end
            end
        end
    end)
end

function DisableAntiRagdoll()
    if antiRagdollConnection then antiRagdollConnection:Disconnect() antiRagdollConnection = nil end
end

-- ===== ANTI TP (ТҮЗЕТІЛГЕН - BodyPosition арқылы) =====
function EnableAntiTp()
    if antiTpConnection then antiTpConnection:Disconnect() end
    
    antiTpAttempts = 0
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then lastPosition = root.CFrame end
    end
    
    antiTpConnection = RunService.Heartbeat:Connect(function()
        if not antiTpEnabled then return end
        if antiTpAttempts >= antiTpMaxAttempts then
            if antiTpConnection then antiTpConnection:Disconnect() antiTpConnection = nil end
            statusLabel.Text = "🛡️ ANTI TP: тоқтатылды"
            return
        end
        
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        if lastPosition then
            local distance = (root.Position - lastPosition.Position).Magnitude
            if distance > 5 then
                -- BodyPosition арқылы қайтару (CFrame емес)
                local bp = Instance.new("BodyPosition")
                bp.Position = lastPosition.Position
                bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bp.Parent = root
                task.wait(0.1)
                bp:Destroy()
                
                antiTpAttempts = antiTpAttempts + 1
                statusLabel.Text = "🛡️ ANTI TP: " .. antiTpAttempts .. "/3"
                
                if antiTpAttempts >= antiTpMaxAttempts then
                    if antiTpConnection then antiTpConnection:Disconnect() antiTpConnection = nil end
                    statusLabel.Text = "🛡️ ANTI TP: тоқтатылды"
                end
            else
                lastPosition = root.CFrame
            end
        end
    end)
end

function DisableAntiTp()
    if antiTpConnection then antiTpConnection:Disconnect() antiTpConnection = nil end
    lastPosition = nil
    antiTpAttempts = 0
end

-- ===== INSTANT GRAB (ТҮЗЕТІЛГЕН - fireproximityprompt) =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not instantGrabEnabled then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- ProximityPrompt (Delta-ның fireproximityprompt арқылы)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local parent = obj.Parent
                if parent and parent:IsA("BasePart") then
                    if (parent.Position - root.Position).Magnitude <= 50 then
                        pcall(function()
                            if fireproximityprompt then
                                fireproximityprompt(obj)
                            else
                                obj:InputHoldBegin()
                                task.wait(0.05)
                                obj:InputHoldEnd()
                            end
                        end)
                    end
                end
            end
        end
        
        -- ClickDetector
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ClickDetector") then
                local parent = obj.Parent
                if parent and parent:IsA("BasePart") then
                    if (parent.Position - root.Position).Magnitude <= 50 then
                        pcall(function() fireclickdetector(obj) end)
                    end
                end
            end
        end
        
        -- Tool
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") then
                local handle = obj:FindFirstChild("Handle")
                if handle and handle:IsA("BasePart") then
                    if (handle.Position - root.Position).Magnitude <= 50 then
                        pcall(function() obj.Parent = char end)
                    end
                end
            end
        end
    end
end)

-- Respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if speedEnabled then ApplySpeed() end
    if antiRagdollEnabled then EnableAntiRagdoll() end
    if antiTpEnabled then EnableAntiTp() end
end)

-- ===== RE-SERVER =====
local function HopToLowestServer()
    statusLabel.Text = "🔄 Сервер іздестірілуде..."
    local placeId = game.PlaceId
    local currentJobId = game.JobId
    
    local function FetchServers(cursor)
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor then url = url .. "&cursor=" .. cursor end
        local ok, response = pcall(function() return game:HttpGet(url) end)
        if not ok or not response then return nil end
        local decodeOk, decoded = pcall(function() return HttpService:JSONDecode(response) end)
        if not decodeOk or not decoded then return nil end
        return decoded
    end
    
    local function FindBestServer(cursor, bestServer, lowestCount, depth)
        if depth > 5 then return bestServer, lowestCount end
        local data = FetchServers(cursor)
        if not data or not data.data then return bestServer, lowestCount end
        for _, server in ipairs(data.data) do
            if server.id and server.id ~= currentJobId then
                if server.playing and server.maxPlayers and server.playing < server.maxPlayers then
                    if server.playing < lowestCount then
                        lowestCount = server.playing
                        bestServer = server
                    end
                end
            end
        end
        if lowestCount <= 1 then return bestServer, lowestCount end
        if data.nextPageCursor then
            return FindBestServer(data.nextPageCursor, bestServer, lowestCount, depth + 1)
        end
        return bestServer, lowestCount
    end
    
    local bestServer, lowestCount = FindBestServer(nil, nil, math.huge, 0)
    
    if bestServer then
        statusLabel.Text = "🔄 Телепорт: " .. lowestCount .. " ойыншы"
        task.wait(0.3)
        pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, bestServer.id, LocalPlayer)
        end)
    else
        statusLabel.Text = "❌ Бос сервер табылмады"
        reServerBtn.Text = "🔄 RE-SERVER"
    end
end

reServerBtn.MouseButton1Click:Connect(function()
    if reServerBtn.Text == "🔄 RE-SERVER" then
        reServerBtn.Text = "⏳ ІЗДЕУДЕ..."
        task.spawn(HopToLowestServer)
    end
end)

print("⚡ PRIME-HUB by ers - Жүктелді!")
