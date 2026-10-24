-- [[ HOSHIN HUB - SMART FREE PRIVATE SERVER (SERVER HOP + FAKE BOTS) ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Бұрынғы ашық GUI-ді өшіру
if CoreGui:FindFirstChild("FreePrivateServerHub") then
    CoreGui.FreePrivateServerHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FreePrivateServerHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parentGui = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Parent = parentGui

-- [[ 1. ҚАЛҚЫМАЛЫ ИКОНКА (PRIV) ]] --
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "FloatingIcon"
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 30, 0, 200)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
ToggleBtn.Text = "PRIV"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 240, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner", ToggleBtn)
ToggleCorner.CornerRadius = UDim.new(0, 10)

local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = Color3.fromRGB(0, 240, 255)
ToggleStroke.Thickness = 1.5

-- [[ 2. НЕГІЗГІ МЕНЮ ]] --
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 310)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 8, 19)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- RGB жиек (Border)
RunService.RenderStepped:Connect(function()
    if MainFrame.Parent then
        local hue = (tick() % 4) / 4
        MainStroke.Color = Color3.fromHSV(hue, 0.85, 1)
    end
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 15, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "🛡️ FREE PRIVATE SERVER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize, Title.TextXAlignment = 12, Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(180, 170, 200)
CloseBtn.TextSize, CloseBtn.Font = 15, Enum.Font.GothamBold

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- [[ 3. КОМПОНЕНТТЕР ]] --

-- ADD BOT SERVER [CHECK BUTTON]
local BotServerBtn = Instance.new("TextButton", MainFrame)
BotServerBtn.Size = UDim2.new(1, -30, 0, 36)
BotServerBtn.Position = UDim2.new(0, 15, 0, 50)
BotServerBtn.BackgroundColor3 = Color3.fromRGB(22, 18, 36)
BotServerBtn.Text = "   ADD BOT SERVER [ OFF ]"
BotServerBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
BotServerBtn.Font = Enum.Font.GothamBold
BotServerBtn.TextSize = 11
BotServerBtn.TextXAlignment = Enum.TextXAlignment.Left
BotServerBtn.BorderSizePixel = 0

local botCorner = Instance.new("UICorner", BotServerBtn)
botCorner.CornerRadius = UDim.new(0, 8)

local botStroke = Instance.new("UIStroke", BotServerBtn)
botStroke.Color = Color3.fromRGB(50, 45, 80)
botStroke.Thickness = 1

-- Фейк боттар панелі (Серверді толтырып көрсету үшін)
local BotListFrame = Instance.new("ScrollingFrame", MainFrame)
BotListFrame.Size = UDim2.new(1, -30, 0, 0)
BotListFrame.Position = UDim2.new(0, 15, 0, 90)
BotListFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 25)
BotListFrame.BorderSizePixel = 0
BotListFrame.Visible = false
BotListFrame.CanvasSize = UDim2.new(0, 0, 0, 200)

local botListCorner = Instance.new("UICorner", BotListFrame)
botListCorner.CornerRadius = UDim.new(0, 8)

local botToggled = false
BotServerBtn.MouseButton1Click:Connect(function()
    botToggled = not botToggled
    if botToggled then
        BotServerBtn.Text = "   ADD BOT SERVER [ ON (12 Bots) ]"
        BotServerBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
        botStroke.Color = Color3.fromRGB(0, 255, 150)
        BotListFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 320, 0, 420) -- Менюді үлкейту
        
        -- Жалған боттар тізімін жасау
        for i = 1, 12 do
            local botLabel = Instance.new("TextLabel", BotListFrame)
            botLabel.Size = UDim2.new(1, -10, 0, 24)
            botLabel.Position = UDim2.new(0, 5, 0, (i - 1) * 26)
            botLabel.BackgroundTransparency = 1
            botLabel.Text = " 🤖 [AFK_Bot_" .. math.random(1000, 9999) .. "] - Ping: " .. math.random(25, 60) .. "ms"
            botLabel.TextColor3 = Color3.fromRGB(150, 160, 180)
            botLabel.Font = Enum.Font.Code
            botLabel.TextSize = 10
            botLabel.TextXAlignment = Enum.TextXAlignment.Left
        end
    else
        BotServerBtn.Text = "   ADD BOT SERVER [ OFF ]"
        BotServerBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
        botStroke.Color = Color3.fromRGB(50, 45, 80)
        BotListFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 320, 0, 310) -- Менюді қайта кішірейту
        for _, child in pairs(BotListFrame:GetChildren()) do
            if child:IsA("TextLabel") then child:Destroy() end
        end
    end
end)

local Sep1 = Instance.new("TextLabel", MainFrame)
Sep1.Name = "Sep1"
Sep1.Size = UDim2.new(1, -30, 0, 20)
Sep1.Position = UDim2.new(0, 15, 0, 92) -- Динамикалық түрде орналасады
Sep1.BackgroundTransparency = 1
Sep1.Text = "========================="
Sep1.TextColor3 = Color3.fromRGB(100, 90, 130)
Sep1.Font = Enum.Font.GothamBold
Sep1.TextSize = 12

-- Bot қосылғанда Sep1 орнын төмен жылжыту үшін функция
RunService.RenderStepped:Connect(function()
    if botToggled then
        BotListFrame.Visible = true
        Sep1.Position = UDim2.new(0, 15, 0, 202)
    else
        BotListFrame.Visible = false
        Sep1.Position = UDim2.new(0, 15, 0, 92)
    end
end)

-- JOIN PRIVATE SERVER (1-2 адамдық бос серверді іздеп табу - Server Hop)
local JoinPrivBtn = Instance.new("TextButton", MainFrame)
JoinPrivBtn.Size = UDim2.new(1, -30, 0, 42)
JoinPrivBtn.Position = UDim2.new(0, 15, 0, 118)
JoinPrivBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
JoinPrivBtn.Text = "🚀 JOIN PRIVATE SERVER (Hop)"
JoinPrivBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinPrivBtn.Font = Enum.Font.GothamBold
JoinPrivBtn.TextSize = 11
JoinPrivBtn.BorderSizePixel = 0

local joinCorner = Instance.new("UICorner", JoinPrivBtn)
joinCorner.CornerRadius = UDim.new(0, 8)

-- Батырманың орнын да динамикалық ету
RunService.RenderStepped:Connect(function()
    if botToggled then
        JoinPrivBtn.Position = UDim2.new(0, 15, 0, 228)
    else
        JoinPrivBtn.Position = UDim2.new(0, 15, 0, 118)
    end
end)

JoinPrivBtn.MouseButton1Click:Connect(function()
    JoinPrivBtn.Text = "⏳ Бос сервер ізделуде (1-2 адам)..."
    
    local success, err = pcall(function()
        local servers = {}
        local cursor = ""
        
        -- Серверлер тізімін алу
        repeat
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            if cursor ~= "" then
                url = url .. "&cursor=" + cursor
            end
            local successHttp, response = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(url))
            end)
            
            if successHttp and response and response.data then
                for _, server in ipairs(response.data) do
                    -- 1 немесе 2 адам бар серверді іздейміз (және ол толы емес)
                    if server.playing and server.playing >= 1 and server.playing <= 2 and server.id ~= game.JobId then
                        table.insert(servers, server.id)
                    end
                end
                cursor = response.nextPageCursor or ""
            else
                break
            end
        until #servers > 0 or cursor == "" or cursor == nil
        
        if #servers > 0 then
            -- Табылған бос серверге қосылу
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            -- Егер 1-2 адамдық сервер табылмаса, кез келген басқа серверге қосылып көреді
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end)
    
    if not success then
        warn("Server Hop Error: " .. tostring(err))
        JoinPrivBtn.Text = "❌ Қате орын алды!"
        task.wait(2)
        JoinPrivBtn.Text = "🚀 JOIN PRIVATE SERVER (Hop)"
    end
end)

local Sep2 = Instance.new("TextLabel", MainFrame)
Sep2.Name = "Sep2"
Sep2.Size = UDim2.new(1, -30, 0, 20)
Sep2.BackgroundTransparency = 1
Sep2.Text = "========================="
Sep2.TextColor3 = Color3.fromRGB(100, 90, 130)
Sep2.Font = Enum.Font.GothamBold
Sep2.TextSize = 12

RunService.RenderStepped:Connect(function()
    if botToggled then
        Sep2.Position = UDim2.new(0, 15, 0, 276)
    else
        Sep2.Position = UDim2.new(0, 15, 0, 166)
    end
end)

-- [[ 4. INFO БӨЛІМІ ]] --
local InfoContainer = Instance.new("Frame", MainFrame)
InfoContainer.Size = UDim2.new(1, -30, 0, 95)
InfoContainer.BackgroundColor3 = Color3.fromRGB(16, 13, 26)
InfoContainer.BorderSizePixel = 0

RunService.RenderStepped:Connect(function()
    if botToggled then
        InfoContainer.Position = UDim2.new(0, 15, 0, 302)
    else
        InfoContainer.Position = UDim2.new(0, 15, 0, 192)
    end
end)

local infoCorner = Instance.new("UICorner", InfoContainer)
infoCorner.CornerRadius = UDim.new(0, 8)

local InfoTitle = Instance.new("TextLabel", InfoContainer)
InfoTitle.Size = UDim2.new(1, -15, 0, 20)
InfoTitle.Position = UDim2.new(0, 10, 0, 5)
InfoTitle.BackgroundTransparency = 1
InfoTitle.Text = "INFO:"
InfoTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.TextSize, InfoTitle.TextXAlignment = 11, Enum.TextXAlignment.Left

local GameLabel = Instance.new("TextLabel", InfoContainer)
GameLabel.Size = UDim2.new(1, -15, 0, 20)
GameLabel.Position = UDim2.new(0, 10, 0, 25)
GameLabel.BackgroundTransparency = 1
GameLabel.Text = "GAME: Жүктелуде..."
GameLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
GameLabel.Font = Enum.Font.Gotham
GameLabel.TextSize, GameLabel.TextXAlignment = 10, Enum.TextXAlignment.Left

local PlayerLabel = Instance.new("TextLabel", InfoContainer)
PlayerLabel.Size = UDim2.new(1, -15, 0, 20)
PlayerLabel.Position = UDim2.new(0, 10, 0, 45)
PlayerLabel.BackgroundTransparency = 1
PlayerLabel.Text = "PLAYER: " .. LocalPlayer.Name
PlayerLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
PlayerLabel.Font = Enum.Font.Gotham
PlayerLabel.TextSize, PlayerLabel.TextXAlignment = 10, Enum.TextXAlignment.Left

local FpsLabel = Instance.new("TextLabel", InfoContainer)
FpsLabel.Size = UDim2.new(1, -15, 0, 20)
FpsLabel.Position = UDim2.new(0, 10, 0, 65)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: 000"
FpsLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
FpsLabel.Font = Enum.Font.Gotham
FpsLabel.TextSize, FpsLabel.TextXAlignment = 10, Enum.TextXAlignment.Left

task.spawn(function()
    pcall(function()
        local info = MarketplaceService:GetProductInfo(game.PlaceId)
        if info and info.Name then
            GameLabel.Text = "GAME: " .. info.Name
        else
            GameLabel.Text = "GAME: Universal"
        end
    end)
end)

local lastTick = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTick = tick()
    if currentTick - lastTick >= 1 then
        local fps = math.floor(frameCount / (currentTick - lastTick))
        FpsLabel.Text = "FPS: " .. tostring(fps)
        frameCount = 0
        lastTick = currentTick
    end
end)