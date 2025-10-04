local Services = {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    TeleportService = game:GetService("TeleportService"),
    HttpService = game:GetService("HttpService"),
    StarterGui = game:GetService("StarterGui"),
    Workspace = game:GetService("Workspace")
}

-- prevent script from running twice
if _G.s0ulzV5Loaded then
    warn("s0ulz V5 is already running!")
    return
end
_G.s0ulzV5Loaded = true

local player = Services.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- theme colors
-- theme presets
local themes = {
    Dark = {
        bg = Color3.fromRGB(15, 15, 20),
        glass = Color3.fromRGB(25, 25, 35),
        surface = Color3.fromRGB(30, 30, 40),
        surfaceLight = Color3.fromRGB(40, 40, 52),
        accent = Color3.fromRGB(255, 255, 255),
        text = Color3.fromRGB(220, 220, 225),
        textDim = Color3.fromRGB(140, 140, 150),
        border = Color3.fromRGB(55, 55, 65),
        success = Color3.fromRGB(34, 197, 94),
        error = Color3.fromRGB(239, 68, 68),
        warning = Color3.fromRGB(251, 146, 60)
    },
    Blue = {
        bg = Color3.fromRGB(10, 15, 30),
        glass = Color3.fromRGB(15, 25, 45),
        surface = Color3.fromRGB(20, 30, 50),
        surfaceLight = Color3.fromRGB(30, 45, 70),
        accent = Color3.fromRGB(100, 150, 255),
        text = Color3.fromRGB(220, 230, 255),
        textDim = Color3.fromRGB(130, 150, 180),
        border = Color3.fromRGB(50, 70, 120),
        success = Color3.fromRGB(34, 197, 94),
        error = Color3.fromRGB(239, 68, 68),
        warning = Color3.fromRGB(251, 146, 60)
    },
    Indigo = {
        bg = Color3.fromRGB(15, 10, 30),
        glass = Color3.fromRGB(25, 20, 45),
        surface = Color3.fromRGB(35, 25, 55),
        surfaceLight = Color3.fromRGB(50, 40, 75),
        accent = Color3.fromRGB(150, 100, 255),
        text = Color3.fromRGB(230, 220, 255),
        textDim = Color3.fromRGB(160, 140, 190),
        border = Color3.fromRGB(70, 55, 110),
        success = Color3.fromRGB(34, 197, 94),
        error = Color3.fromRGB(239, 68, 68),
        warning = Color3.fromRGB(251, 146, 60)
    },
    Orange = {
        bg = Color3.fromRGB(20, 15, 10),
        glass = Color3.fromRGB(35, 25, 20),
        surface = Color3.fromRGB(45, 30, 25),
        surfaceLight = Color3.fromRGB(60, 45, 35),
        accent = Color3.fromRGB(255, 150, 50),
        text = Color3.fromRGB(255, 240, 220),
        textDim = Color3.fromRGB(180, 150, 130),
        border = Color3.fromRGB(90, 65, 50),
        success = Color3.fromRGB(34, 197, 94),
        error = Color3.fromRGB(239, 68, 68),
        warning = Color3.fromRGB(251, 146, 60)
    },
    Slate = {
        bg = Color3.fromRGB(25, 25, 28),
        glass = Color3.fromRGB(40, 40, 45),
        surface = Color3.fromRGB(50, 50, 55),
        surfaceLight = Color3.fromRGB(65, 65, 72),
        accent = Color3.fromRGB(180, 180, 200),
        text = Color3.fromRGB(230, 230, 235),
        textDim = Color3.fromRGB(150, 150, 160),
        border = Color3.fromRGB(80, 80, 90),
        success = Color3.fromRGB(34, 197, 94),
        error = Color3.fromRGB(239, 68, 68),
        warning = Color3.fromRGB(251, 146, 60)
    }
}

local theme = themes.Dark  -- Default theme

-- icon theme (can be changed later)
local iconTheme = {
    color = theme.textDim,
    activeColor = theme.accent,
    thickness = 2
}

-- config
local config = {
    currentSpeed = 16,
    currentJump = 50,
    flightSpeed = 50,
    forwardHold = 0,
    flightTracks = {},
    currentTab = "Main",
    isMinimized = false,
    isHidden = false,
    currentTheme = "Dark"  -- ADD THIS
}

local states = {
    flight = false,
    noclip = false,
    infiniteTeleport = false,
    invincible = false,
    triggerbot = false,
    hitboxExpander = false,
    antiDetection = true,
    antiKick = true,
    touchFling = false,
    chatSpammer = false,
    fakeLag = false,
    followPlayer = false,
    aimbot = false
}

local trollSettings = {
    chatText = "Hello World!",
    chatDelay = 3,
    followTarget = nil,
    fakeLagWaitTime = 0.05,
    fakeLagDelayTime = 0.4,
    flingWhitelist = {}
}

local espSettings = {
    Enabled = false,
    Tracers = false,
    TracerThickness = 2,
    TracerColor = Color3.fromRGB(255, 255, 255),
    Skeleton = false,
    Box = false,
    Players = {},
    Highlights = {},
    Billboards = {},
    TracerLines = {},
    SkeletonLines = {},
    BoxLines = {},
    TeamCheck = true,
    MaxDistance = 500,
    HighlightColor = Color3.fromRGB(255, 255, 255),
    BoxColor = Color3.fromRGB(255, 255, 255),
    SkeletonColor = Color3.fromRGB(255, 255, 255)
}

local aimbotSettings = {
    Enabled = false,
    Smoothing = 0.15,
    TargetPart = "Head",
    TeamCheck = true,
    VisibleCheck = true,
    Connection = nil,
    currentTarget = nil
}

local triggerbotSettings = {
    Enabled = false,
    delay = 0.1,
    range = 300,
    running = false
}

local HitboxExpander = {
    Enabled = false,
    Size = 10,
    Transparency = 0.5,
    Color = Color3.fromRGB(255, 0, 0),
    Connection = nil
}

local expandedPlayers = {}

local inputFlags = {forward = false, back = false, left = false, right = false, up = false, down = false}
local scriptEnv = {FPDH = Services.Workspace.FallenPartsDestroyHeight, OldPos = nil}
local connections = {}
local drawnIcons = {}

-- game database
local gameDatabase = {
    {id = 286090429, name = "Arsenal", desc = "Fast-paced FPS", url = "https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Games/Arsenal/Arsenal(s0ulz).lua"},
    {id = 7326934954, name = "99 Nights In The Forest", desc = "Survival horror", url = "https://pastefy.app/RXzul28o/raw"},
    {id = 4777817887, name = "Blade Ball", desc = "Dodge & deflect", url = "http://lumin-hub.lol/Blade.lua"},
    {id = 4348829796, name = "MVSD", desc = "Murder mystery", url = "https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Games/MVSD/EZ.lua"},
    {id = 4931927012, name = "Basketball Legends", desc = "Arcade hoops", url = "https://raw.githubusercontent.com/vnausea/absence-mini/refs/heads/main/absencemini.lua"},
    {id = 66654135, name = "MM2", desc = "Classic mystery", url = "https://raw.githubusercontent.com/vertex-peak/vertex/refs/heads/main/loadstring"},
    {id = 3508322461, name = "Jujitsu Shenanigans", desc = "Anime combat", url = "https://raw.githubusercontent.com/NotEnoughJack/localplayerscripts/refs/heads/main/script"},
    {id = 372226183, name = "Flee the Facility", desc = "Hide & seek", url = "https://raw.githubusercontent.com/PabloOP-87/pedorga/refs/heads/main/Flee-Da-Facility"},
    {id = 3808081382, name = "TSB", desc = "Hero battles", url = "https://raw.githubusercontent.com/ATrainz/Phantasm/refs/heads/main/Games/TSB.lua"},
    {id = 5203828273, name = "DTI", desc = "Fashion show", url = "https://raw.githubusercontent.com/hellohellohell012321/DTI-GUI-V2/main/dti_gui_v2.lua"},
    {id = 6931042565, name = "Volleyball", desc = "Competitive", url = "https://raw.githubusercontent.com/scriptshubzeck/Zeckhubv1/refs/heads/main/zeckhub"},
    {id = 7436755782, name = "Grow A Garden", desc = "Relaxing sim", url = "https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/GaG/Main.lua"},
    {id = 6035872082, name = "RIVALS", desc = "Tactical FPS", url = "https://pastebin.com/raw/zWhb1mMS"},
    {id = 47545, name = "Work At A Pizza Place", desc = "Work roleplay", url = "https://raw.githubusercontent.com/Hm5011/hussain/refs/heads/main/Work%20at%20a%20pizza%20place"},
    {id = 1268927906, name = "Muscle Legends", desc = "Training sim", url = "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"}
}

-- game detection and auto-load with confirmation
local currentPlaceId = game.GameId
local detectedGame = nil

local function detectGame()
    for _, gameData in ipairs(gameDatabase) do
        if currentPlaceId == gameData.id then
            return gameData
        end
    end
    return nil
end

local function createGameDetectionPrompt(gameData)
    local prompt = Instance.new("Frame")
    prompt.Name = "GameDetectionPrompt"
    prompt.Parent = gui.screen
    prompt.BackgroundColor3 = theme.surface
    prompt.BackgroundTransparency = 0.1
    prompt.BorderSizePixel = 0
    prompt.AnchorPoint = Vector2.new(0.5, 0.5)
    prompt.Position = UDim2.new(0.5, 0, 0.5, 0)
    prompt.Size = UDim2.new(0, 0, 0, 0)
    prompt.ZIndex = 1000
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = prompt
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.border
    stroke.Transparency = 0.5
    stroke.Parent = prompt
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 25)
    padding.PaddingRight = UDim.new(0, 25)
    padding.PaddingTop = UDim.new(0, 20)
    padding.PaddingBottom = UDim.new(0, 20)
    padding.Parent = prompt
    
    local title = Instance.new("TextLabel")
    title.Parent = prompt
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 24)
    title.Font = Enum.Font.GothamBold
    title.Text = "Game Detected!"
    title.TextColor3 = theme.accent
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.ZIndex = 1001
    
    local gameName = Instance.new("TextLabel")
    gameName.Parent = prompt
    gameName.BackgroundTransparency = 1
    gameName.Position = UDim2.new(0, 0, 0, 32)
    gameName.Size = UDim2.new(1, 0, 0, 20)
    gameName.Font = Enum.Font.GothamMedium
    gameName.Text = gameData.name
    gameName.TextColor3 = theme.text
    gameName.TextSize = 14
    gameName.TextXAlignment = Enum.TextXAlignment.Center
    gameName.ZIndex = 1001
    
    local desc = Instance.new("TextLabel")
    desc.Parent = prompt
    desc.BackgroundTransparency = 1
    desc.Position = UDim2.new(0, 0, 0, 56)
    desc.Size = UDim2.new(1, 0, 0, 16)
    desc.Font = Enum.Font.Gotham
    desc.Text = gameData.desc
    desc.TextColor3 = theme.textDim
    desc.TextSize = 11
    desc.TextXAlignment = Enum.TextXAlignment.Center
    desc.ZIndex = 1001
    
    local question = Instance.new("TextLabel")
    question.Parent = prompt
    question.BackgroundTransparency = 1
    question.Position = UDim2.new(0, 0, 0, 80)
    question.Size = UDim2.new(1, 0, 0, 18)
    question.Font = Enum.Font.Gotham
    question.Text = "Load " .. gameData.name .. " script?"
    question.TextColor3 = theme.text
    question.TextSize = 12
    question.TextXAlignment = Enum.TextXAlignment.Center
    question.ZIndex = 1001
    
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Parent = prompt
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Position = UDim2.new(0, 0, 0, 110)
    buttonFrame.Size = UDim2.new(1, 0, 0, 38)
    buttonFrame.ZIndex = 1001
    
    local yesBtn = Instance.new("TextButton")
    yesBtn.Parent = buttonFrame
    yesBtn.BackgroundColor3 = theme.success
    yesBtn.BackgroundTransparency = 0.2
    yesBtn.Position = UDim2.new(0, 0, 0, 0)
    yesBtn.Size = UDim2.new(0.48, 0, 1, 0)
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.Text = "Load"
    yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesBtn.TextSize = 13
    yesBtn.AutoButtonColor = false
    yesBtn.ZIndex = 1002
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 8)
    yesCorner.Parent = yesBtn
    
    local noBtn = Instance.new("TextButton")
    noBtn.Parent = buttonFrame
    noBtn.BackgroundColor3 = theme.error
    noBtn.BackgroundTransparency = 0.2
    noBtn.Position = UDim2.new(0.52, 0, 0, 0)
    noBtn.Size = UDim2.new(0.48, 0, 1, 0)
    noBtn.Font = Enum.Font.GothamBold
    noBtn.Text = "Cancel"
    noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noBtn.TextSize = 13
    noBtn.AutoButtonColor = false
    noBtn.ZIndex = 1002
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 8)
    noCorner.Parent = noBtn
    
    -- Animate in
    tween(prompt, 0.3, {Size = UDim2.new(0, 350, 0, 168)}):Play()
    
    yesBtn.MouseEnter:Connect(function()
        tween(yesBtn, 0.15, {BackgroundTransparency = 0}):Play()
    end)
    
    yesBtn.MouseLeave:Connect(function()
        tween(yesBtn, 0.15, {BackgroundTransparency = 0.2}):Play()
    end)
    
    noBtn.MouseEnter:Connect(function()
        tween(noBtn, 0.15, {BackgroundTransparency = 0}):Play()
    end)
    
    noBtn.MouseLeave:Connect(function()
        tween(noBtn, 0.15, {BackgroundTransparency = 0.2}):Play()
    end)
    
    yesBtn.MouseButton1Click:Connect(function()
        tween(prompt, 0.2, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.2)
        prompt:Destroy()
        
        notify("Loading", "Loading " .. gameData.name .. " script...", 3)
        task.wait(0.5)
        pcall(function()
            loadstring(game:HttpGet(gameData.url))()
        end)
    end)
    
    noBtn.MouseButton1Click:Connect(function()
        tween(prompt, 0.2, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.2)
        prompt:Destroy()
        notify("Cancelled", "Script load cancelled", 2)
    end)
end

-- Call detection after GUI loads
task.spawn(function()
    task.wait(2)  -- Wait for GUI to fully initialize
    detectedGame = detectGame()
    if detectedGame then
        notify("Game Detected", detectedGame.name .. " detected!", 4)
        task.wait(1)
        createGameDetectionPrompt(detectedGame)
    end
end)

-- Call detection after GUI loads
task.spawn(function()
    task.wait(1.5)  -- Wait for GUI to initialize
    detectAndLoadGame()
end)

-- utilities
local function notify(title, text, duration)
    pcall(function()
        Services.StarterGui:SetCore("SendNotification", {
            Title = title or "s0ulz V5",
            Text = text or "",
            Duration = duration or 4
        })
    end)
end

local function tween(obj, time, props)
    return Services.TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
end

local function getTimeBasedGreeting()
    local hour = tonumber(os.date("%H"))
    if hour >= 5 and hour < 12 then return "Good Morning bruv"
    elseif hour >= 12 and hour < 18 then return "Good Afternoon bruv"
    elseif hour >= 18 and hour < 22 then return "Good Evening bruv"
    else return "Good Night bruv" end
end

local function findPlayer(str)
    local found = {}
    str = str:lower():gsub("%s+", "")
    
    if str == "all" then return Services.Players:GetPlayers()
    elseif str == "others" then
        for _, v in pairs(Services.Players:GetPlayers()) do
            if v ~= player then table.insert(found, v) end
        end
    elseif str == "me" then return {player}
    else
        for _, v in pairs(Services.Players:GetPlayers()) do
            local name = v.Name:lower():gsub("%s+", "")
            local displayName = v.DisplayName:lower():gsub("%s+", "")
            if name:find(str, 1, true) or displayName:find(str, 1, true) then
                table.insert(found, v)
            end
        end
    end
    return found
end

local function applyCharacterSettings()
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.WalkSpeed = config.currentSpeed
            humanoid.JumpPower = config.currentJump
        end
    end
end

-- icon drawing system - precise poly shapes
local function drawIcon(iconType, parent, basePos, size)
    local icon = {
        type = iconType,
        parent = parent,
        basePos = basePos,
        size = size,
        elements = {},
        visible = true,
        color = iconTheme.color
    }
    
    local function addLine(from, to)
        local line = Drawing.new("Line")
        line.Thickness = iconTheme.thickness
        line.Color = icon.color
        line.Visible = icon.visible
        line.From = from
        line.To = to
        line.Transparency = 1
        table.insert(icon.elements, line)
        return line
    end
    
    local function addCircle(pos, radius, filled)
        local circle = Drawing.new("Circle")
        circle.Radius = radius
        circle.Position = pos
        circle.Color = icon.color
        circle.Filled = filled or false
        circle.Thickness = iconTheme.thickness
        circle.Visible = icon.visible
        circle.Transparency = 1
        table.insert(icon.elements, circle)
        return circle
    end
    
    -- home icon - detailed house
    if iconType == "home" then
        local cx, cy = basePos.X + size/2, basePos.Y + size/2
        
        -- roof
        addLine(Vector2.new(cx - size*0.4, cy - size*0.15), Vector2.new(cx, cy - size*0.5))
        addLine(Vector2.new(cx, cy - size*0.5), Vector2.new(cx + size*0.4, cy - size*0.15))
        
        -- walls
        addLine(Vector2.new(cx - size*0.4, cy - size*0.15), Vector2.new(cx - size*0.4, cy + size*0.5))
        addLine(Vector2.new(cx + size*0.4, cy - size*0.15), Vector2.new(cx + size*0.4, cy + size*0.5))
        addLine(Vector2.new(cx - size*0.4, cy + size*0.5), Vector2.new(cx + size*0.4, cy + size*0.5))
        
        -- door
        addLine(Vector2.new(cx - size*0.15, cy + size*0.1), Vector2.new(cx - size*0.15, cy + size*0.5))
        addLine(Vector2.new(cx + size*0.15, cy + size*0.1), Vector2.new(cx + size*0.15, cy + size*0.5))
        addLine(Vector2.new(cx - size*0.15, cy + size*0.1), Vector2.new(cx + size*0.15, cy + size*0.1))
        
    -- location pin - precise droplet shape
    elseif iconType == "location" then
        local cx, cy = basePos.X + size/2, basePos.Y + size/2
        
        -- outer circle
        addCircle(Vector2.new(cx, cy - size*0.1), size*0.25, false)
        
        -- pin point using multiple lines for smooth curve
        for i = 0, 10 do
            local angle1 = math.pi * 0.2 + (i / 10) * math.pi * 0.6
            local angle2 = math.pi * 0.2 + ((i + 1) / 10) * math.pi * 0.6
            local r = size * 0.25
            local x1 = cx + math.cos(angle1) * r
            local y1 = cy - size*0.1 + math.sin(angle1) * r
            local x2 = cx + math.cos(angle2) * r
            local y2 = cy - size*0.1 + math.sin(angle2) * r
            
            if i >= 4 and i <= 6 then
                addLine(Vector2.new(x1, y1), Vector2.new(cx, cy + size*0.4))
            end
        end
        
        -- inner dot
        addCircle(Vector2.new(cx, cy - size*0.1), size*0.08, true)
        
    -- crosshair target - detailed
    elseif iconType == "target" then
        local cx, cy = basePos.X + size/2, basePos.Y + size/2
        
        -- outer ring
        addCircle(Vector2.new(cx, cy), size*0.4, false)
        
        -- middle ring
        addCircle(Vector2.new(cx, cy), size*0.25, false)
        
        -- center dot
        addCircle(Vector2.new(cx, cy), size*0.06, true)
        
        -- crosshair lines with gaps
        addLine(Vector2.new(cx - size*0.5, cy), Vector2.new(cx - size*0.45, cy))
        addLine(Vector2.new(cx + size*0.45, cy), Vector2.new(cx + size*0.5, cy))
        addLine(Vector2.new(cx, cy - size*0.5), Vector2.new(cx, cy - size*0.45))
        addLine(Vector2.new(cx, cy + size*0.45), Vector2.new(cx, cy + size*0.5))
        
    -- eye - detailed eyeball
    elseif iconType == "eye" then
        local cx, cy = basePos.X + size/2, basePos.Y + size/2
        
        -- eye outline - curved shape using multiple line segments
        local points = {}
        for i = 0, 20 do
            local t = i / 20
            local angle = t * math.pi * 2
            local rx = size * 0.45
            local ry = size * 0.25
            if angle > math.pi * 0.3 and angle < math.pi * 0.7 then
                ry = ry * 1.3
            elseif angle > math.pi * 1.3 and angle < math.pi * 1.7 then
                ry = ry * 1.3
            end
            local x = cx + math.cos(angle) * rx
            local y = cy + math.sin(angle) * ry
            table.insert(points, Vector2.new(x, y))
        end
        
        for i = 1, #points do
            local p1 = points[i]
            local p2 = points[i % #points + 1]
            addLine(p1, p2)
        end
        
        -- iris
        addCircle(Vector2.new(cx, cy), size*0.18, false)
        
        -- pupil
        addCircle(Vector2.new(cx, cy), size*0.08, true)
        
    -- settings gear - detailed cog
    elseif iconType == "settings" then
        local cx, cy = basePos.X + size/2, basePos.Y + size/2
        
        -- gear teeth (8 teeth)
        for i = 0, 7 do
            local angle = (i / 8) * math.pi * 2
            local innerR = size * 0.25
            local outerR = size * 0.45
            
            local x1 = cx + math.cos(angle - 0.15) * innerR
            local y1 = cy + math.sin(angle - 0.15) * innerR
            local x2 = cx + math.cos(angle - 0.1) * outerR
            local y2 = cy + math.sin(angle - 0.1) * outerR
            local x3 = cx + math.cos(angle + 0.1) * outerR
            local y3 = cy + math.sin(angle + 0.1) * outerR
            local x4 = cx + math.cos(angle + 0.15) * innerR
            local y4 = cy + math.sin(angle + 0.15) * innerR
            
            addLine(Vector2.new(x1, y1), Vector2.new(x2, y2))
            addLine(Vector2.new(x2, y2), Vector2.new(x3, y3))
            addLine(Vector2.new(x3, y3), Vector2.new(x4, y4))
        end
        
        -- center circle
        addCircle(Vector2.new(cx, cy), size*0.15, false)
        
    -- game controller - detailed
    elseif iconType == "game" then
        local cx, cy = basePos.X + size/2, basePos.Y + size/2
        
        -- body outline
        local bodyPoints = {
            Vector2.new(cx - size*0.4, cy - size*0.1),
            Vector2.new(cx - size*0.35, cy - size*0.3),
            Vector2.new(cx - size*0.1, cy - size*0.35),
            Vector2.new(cx + size*0.1, cy - size*0.35),
            Vector2.new(cx + size*0.35, cy - size*0.3),
            Vector2.new(cx + size*0.4, cy - size*0.1),
            Vector2.new(cx + size*0.4, cy + size*0.2),
            Vector2.new(cx + size*0.3, cy + size*0.3),
            Vector2.new(cx - size*0.3, cy + size*0.3),
            Vector2.new(cx - size*0.4, cy + size*0.2),
        }
        
        for i = 1, #bodyPoints do
            local p1 = bodyPoints[i]
            local p2 = bodyPoints[i % #bodyPoints + 1]
            addLine(p1, p2)
        end
        
        -- d-pad (left side)
        addLine(Vector2.new(cx - size*0.25, cy), Vector2.new(cx - size*0.1, cy))
        addLine(Vector2.new(cx - size*0.175, cy - size*0.075), Vector2.new(cx - size*0.175, cy + size*0.075))
        
        -- buttons (right side)
        addCircle(Vector2.new(cx + size*0.2, cy - size*0.05), size*0.05, false)
        addCircle(Vector2.new(cx + size*0.3, cy + size*0.05), size*0.05, false)
        addCircle(Vector2.new(cx + size*0.15, cy + size*0.1), size*0.05, false)
    end
    
    function icon:UpdatePosition(newBasePos)
        local offsetX = newBasePos.X - self.basePos.X
        local offsetY = newBasePos.Y - self.basePos.Y
        self.basePos = newBasePos
        
        for _, element in ipairs(self.elements) do
            if element.Position then
                element.Position = element.Position + Vector2.new(offsetX, offsetY)
            end
            if element.From then
                element.From = element.From + Vector2.new(offsetX, offsetY)
            end
            if element.To then
                element.To = element.To + Vector2.new(offsetX, offsetY)
            end
        end
    end
    
    function icon:SetColor(color)
        self.color = color
        for _, element in ipairs(self.elements) do
            element.Color = color
        end
    end
    
    function icon:SetVisible(visible)
        self.visible = visible
        for _, element in ipairs(self.elements) do
            element.Visible = visible
        end
    end
    
    function icon:Destroy()
        for _, element in ipairs(self.elements) do
            element:Remove()
        end
        self.elements = {}
    end
    
    table.insert(drawnIcons, icon)
    return icon
end

-- esp functionality
local function createPlayerESP(targetPlayer)
    if espSettings.Players[targetPlayer] then return end
    local character = targetPlayer.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
   
    local highlight = Instance.new("Highlight")
    highlight.Name = targetPlayer.Name .. "_Highlight"
    highlight.OutlineColor = espSettings.HighlightColor
    highlight.FillColor = Color3.new(0, 0, 0)
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    highlight.Adornee = character
    highlight.Enabled = espSettings.Enabled
   
    local billboard = Instance.new("BillboardGui")
    billboard.Name = targetPlayer.Name .. "_Billboard"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Adornee = head
    billboard.Parent = playerGui
    billboard.Enabled = espSettings.Enabled
   
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.3
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BorderSizePixel = 0
    frame.Parent = billboard
   
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
   
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -10, 1, -10)
    textLabel.Position = UDim2.new(0, 5, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 10
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.Text = ""
    textLabel.Parent = frame
   
    local tracerLine = Drawing.new("Line")
    tracerLine.Visible = false
    tracerLine.Thickness = espSettings.TracerThickness
    tracerLine.Color = espSettings.TracerColor
    
    -- Skeleton lines
    local skeletonLines = {}
    local skeletonConnections = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"}
    }
    
    for _, connection in ipairs(skeletonConnections) do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 2
        line.Color = espSettings.SkeletonColor
        line.Transparency = 1
        table.insert(skeletonLines, {line = line, from = connection[1], to = connection[2]})
    end
    
    -- Box lines
    local boxLines = {}
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 2
        line.Color = espSettings.BoxColor
        line.Transparency = 1
        table.insert(boxLines, line)
    end
   
    espSettings.Players[targetPlayer] = true
    espSettings.Highlights[targetPlayer] = highlight
    espSettings.Billboards[targetPlayer] = billboard
    espSettings.TracerLines[targetPlayer] = tracerLine
    espSettings.SkeletonLines[targetPlayer] = skeletonLines
    espSettings.BoxLines[targetPlayer] = boxLines
end

local function removePlayerESP(targetPlayer)
    if not espSettings.Players[targetPlayer] then return end
    
    local highlight = espSettings.Highlights[targetPlayer]
    if highlight then highlight:Destroy() end
    
    local billboard = espSettings.Billboards[targetPlayer]
    if billboard then billboard:Destroy() end
    
    local tracerLine = espSettings.TracerLines[targetPlayer]
    if tracerLine then tracerLine:Remove() end
    
    local skeletonLines = espSettings.SkeletonLines[targetPlayer]
    if skeletonLines then
        for _, lineData in ipairs(skeletonLines) do
            if lineData.line then lineData.line:Remove() end
        end
    end
    
    local boxLines = espSettings.BoxLines[targetPlayer]
    if boxLines then
        for _, line in ipairs(boxLines) do
            if line then line:Remove() end
        end
    end
    
    espSettings.Players[targetPlayer] = nil
    espSettings.Highlights[targetPlayer] = nil
    espSettings.Billboards[targetPlayer] = nil
    espSettings.TracerLines[targetPlayer] = nil
    espSettings.SkeletonLines[targetPlayer] = nil
    espSettings.BoxLines[targetPlayer] = nil
end

local function clearAllESP()
    for player, _ in pairs(espSettings.Players) do
        removePlayerESP(player)
    end
    
    -- Disconnect ESP listeners
    if connections.espPlayerAdded then
        connections.espPlayerAdded:Disconnect()
        connections.espPlayerAdded = nil
    end
    if connections.espCharacterAdded then
        connections.espCharacterAdded:Disconnect()
        connections.espCharacterAdded = nil
    end
    if connections.espPlayerRemoving then
        connections.espPlayerRemoving:Disconnect()
        connections.espPlayerRemoving = nil
    end
end

local function updatePlayerESP()
    local camera = Services.Workspace.CurrentCamera
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not camera or not myRoot then return end
   
    for targetPlayer, _ in pairs(espSettings.Players) do
        if not targetPlayer or not targetPlayer.Character then
            removePlayerESP(targetPlayer)
        else
            local character = targetPlayer.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local head = character:FindFirstChild("Head")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
           
            if not humanoid or not head or not rootPart then
                removePlayerESP(targetPlayer)
            else
                local distance = (rootPart.Position - myRoot.Position).Magnitude
                local inRange = distance <= espSettings.MaxDistance
                local highlight = espSettings.Highlights[targetPlayer]
                local billboard = espSettings.Billboards[targetPlayer]
                local tracerLine = espSettings.TracerLines[targetPlayer]
                local skeletonLines = espSettings.SkeletonLines[targetPlayer]
                local boxLines = espSettings.BoxLines[targetPlayer]
               
                if not highlight or not billboard or not tracerLine then
                    createPlayerESP(targetPlayer)
                else
                    highlight.Enabled = espSettings.Enabled and inRange
                    highlight.OutlineColor = espSettings.HighlightColor
                    billboard.Enabled = espSettings.Enabled and inRange
                   
                    if billboard.Enabled then
                        local health = math.floor(humanoid.Health)
                        local maxHealth = math.floor(humanoid.MaxHealth)
                        local text = string.format("%s\n%d/%dHP\n%d studs", targetPlayer.Name, health, maxHealth, math.floor(distance))
                        local frame = billboard:FindFirstChild("Frame")
                        if frame then
                            local textLabel = frame:FindFirstChild("TextLabel")
                            if textLabel then textLabel.Text = text end
                        end
                    end
                   
                    -- Tracers
                    if espSettings.Tracers and espSettings.Enabled and inRange then
                        local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                        if onScreen and screenPos.Z > 0 then
                            tracerLine.Visible = true
                            tracerLine.Thickness = espSettings.TracerThickness
                            tracerLine.Color = espSettings.TracerColor
                            tracerLine.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                            tracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
                        else
                            tracerLine.Visible = false
                        end
                    else
                        tracerLine.Visible = false
                    end
                    
                    -- Skeleton ESP
                    if espSettings.Skeleton and espSettings.Enabled and inRange and skeletonLines then
                        for _, lineData in ipairs(skeletonLines) do
                            local part1 = character:FindFirstChild(lineData.from)
                            local part2 = character:FindFirstChild(lineData.to)
                            if part1 and part2 then
                                local pos1, onScreen1 = camera:WorldToViewportPoint(part1.Position)
                                local pos2, onScreen2 = camera:WorldToViewportPoint(part2.Position)
                                if onScreen1 and onScreen2 and pos1.Z > 0 and pos2.Z > 0 then
                                    lineData.line.Visible = true
                                    lineData.line.From = Vector2.new(pos1.X, pos1.Y)
                                    lineData.line.To = Vector2.new(pos2.X, pos2.Y)
                                    lineData.line.Color = espSettings.SkeletonColor
                                else
                                    lineData.line.Visible = false
                                end
                            else
                                lineData.line.Visible = false
                            end
                        end
                    elseif skeletonLines then
                        for _, lineData in ipairs(skeletonLines) do
                            lineData.line.Visible = false
                        end
                    end
                    
                    -- Box ESP
                    if espSettings.Box and espSettings.Enabled and inRange and boxLines then
                        local corners = {}
                        local size = character:GetExtentsSize()
                        local cf = rootPart.CFrame
                        
                        local function addCorner(offset)
                            local pos = cf * offset
                            local screenPos, onScreen = camera:WorldToViewportPoint(pos)
                            if onScreen and screenPos.Z > 0 then
                                table.insert(corners, Vector2.new(screenPos.X, screenPos.Y))
                            end
                        end
                        
                        addCorner(CFrame.new(-size.X/2, size.Y/2, 0))
                        addCorner(CFrame.new(size.X/2, size.Y/2, 0))
                        addCorner(CFrame.new(size.X/2, -size.Y/2, 0))
                        addCorner(CFrame.new(-size.X/2, -size.Y/2, 0))
                        
                        if #corners == 4 then
                            for i = 1, 4 do
                                boxLines[i].Visible = true
                                boxLines[i].From = corners[i]
                                boxLines[i].To = corners[i % 4 + 1]
                                boxLines[i].Color = espSettings.BoxColor
                            end
                        else
                            for _, line in ipairs(boxLines) do
                                line.Visible = false
                            end
                        end
                    elseif boxLines then
                        for _, line in ipairs(boxLines) do
                            line.Visible = false
                        end
                    end
                end
            end
        end
    end
end

local function setupESP()
    clearAllESP()
    
    -- Add all current players
    for _, otherPlayer in ipairs(Services.Players:GetPlayers()) do
        if otherPlayer ~= player then 
            task.spawn(function()
                if otherPlayer.Character then
                    createPlayerESP(otherPlayer)
                else
                    otherPlayer.CharacterAdded:Wait()
                    if espSettings.Enabled then createPlayerESP(otherPlayer) end
                end
            end)
        end
    end
    
    -- Listen for new players joining
    if connections.espPlayerAdded then connections.espPlayerAdded:Disconnect() end
    connections.espPlayerAdded = Services.Players.PlayerAdded:Connect(function(newPlayer)
        if newPlayer ~= player then
            task.spawn(function()
                newPlayer.CharacterAdded:Wait()
                if espSettings.Enabled then 
                    createPlayerESP(newPlayer)
                    notify("ESP", newPlayer.Name .. " joined - ESP applied", 3)
                end
            end)
        end
    end)
    
    -- Listen for player characters respawning
    if connections.espCharacterAdded then connections.espCharacterAdded:Disconnect() end
    connections.espCharacterAdded = Services.Players.PlayerAdded:Connect(function(otherPlayer)
        if otherPlayer ~= player then
            otherPlayer.CharacterAdded:Connect(function()
                task.wait(0.5)
                if espSettings.Enabled and not espSettings.Players[otherPlayer] then
                    createPlayerESP(otherPlayer)
                end
            end)
        end
    end)
    
    -- Re-apply ESP to existing players when they respawn
    for _, otherPlayer in ipairs(Services.Players:GetPlayers()) do
        if otherPlayer ~= player then
            otherPlayer.CharacterAdded:Connect(function()
                task.wait(0.5)
                if espSettings.Enabled then
                    if espSettings.Players[otherPlayer] then
                        removePlayerESP(otherPlayer)
                    end
                    createPlayerESP(otherPlayer)
                end
            end)
        end
    end
    
    -- Listen for players leaving
    if connections.espPlayerRemoving then connections.espPlayerRemoving:Disconnect() end
    connections.espPlayerRemoving = Services.Players.PlayerRemoving:Connect(function(leavingPlayer)
        removePlayerESP(leavingPlayer)
    end)
end

-- aimbot
local function isVisible(targetPart)
    if not aimbotSettings.VisibleCheck then return true end
    if not player.Character then return false end
    local origin = Services.Workspace.CurrentCamera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    local result = Services.Workspace:Raycast(origin, direction, raycastParams)
    if result then
        local hitChar = result.Instance.Parent
        if hitChar and hitChar:FindFirstChild("Humanoid") then
            return hitChar == targetPart.Parent
        end
        return false
    end
    return true
end

local function isValidTarget(targetPlayer)
    if not targetPlayer or targetPlayer == player then return false end
    if not targetPlayer.Character then return false end
    local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if aimbotSettings.TeamCheck and targetPlayer.Team and player.Team and targetPlayer.Team == player.Team then
        return false
    end
    return true
end

local function getClosestTarget()
    local closestTarget = nil
    local closestDistance = math.huge
    for _, otherPlayer in pairs(Services.Players:GetPlayers()) do
        if isValidTarget(otherPlayer) then
            local targetPart = otherPlayer.Character:FindFirstChild(aimbotSettings.TargetPart)
            if targetPart then
                local distance = (Services.Workspace.CurrentCamera.CFrame.Position - targetPart.Position).Magnitude
                if distance < closestDistance and isVisible(targetPart) then
                    closestDistance = distance
                    closestTarget = targetPart
                end
            end
        end
    end
    return closestTarget
end

local function smoothAim(targetPart)
    if not targetPart or not targetPart.Parent then return end
    local targetPosition = targetPart.Position
    local cameraPosition = Services.Workspace.CurrentCamera.CFrame.Position
    local direction = (targetPosition - cameraPosition).Unit
    local currentDirection = Services.Workspace.CurrentCamera.CFrame.LookVector
    local smoothFactor = 1 - aimbotSettings.Smoothing
    local newDirection = currentDirection:Lerp(direction, smoothFactor)
    Services.Workspace.CurrentCamera.CFrame = CFrame.new(cameraPosition, cameraPosition + newDirection)
end

local function startAimbot()
    if aimbotSettings.Connection then aimbotSettings.Connection:Disconnect() end
    aimbotSettings.Connection = Services.RunService.Heartbeat:Connect(function()
        if not aimbotSettings.Enabled then return end
        local target = getClosestTarget()
        if target then
            aimbotSettings.currentTarget = target
            smoothAim(target)
        else
            aimbotSettings.currentTarget = nil
        end
    end)
end

local function stopAimbot()
    if aimbotSettings.Connection then
        aimbotSettings.Connection:Disconnect()
        aimbotSettings.Connection = nil
    end
    aimbotSettings.currentTarget = nil
end

-- triggerbot
local function getTargetAtCrosshair()
    local target = mouse.Target
    if not target then return nil end
    local character = target.Parent
    if not character or not character:FindFirstChild("Humanoid") then
        character = target.Parent.Parent
        if not character or not character:FindFirstChild("Humanoid") then return nil end
    end
    local targetPlayer = Services.Players:GetPlayerFromCharacter(character)
    if not targetPlayer or targetPlayer == player then return nil end
    if aimbotSettings.TeamCheck and player.Team and targetPlayer.Team and player.Team == targetPlayer.Team then
        return nil
    end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil end
    local distance = (Services.Workspace.CurrentCamera.CFrame.Position - target.Position).Magnitude
    if distance > triggerbotSettings.range then return nil end
    return character
end

local function fireWeapon()
    Services.VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.05)
    Services.VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

local function startTriggerBot()
    if connections.triggerbotConnection then connections.triggerbotConnection:Disconnect() end
    connections.triggerbotConnection = Services.RunService.Heartbeat:Connect(function()
        if not triggerbotSettings.Enabled or triggerbotSettings.running then return end
        local target = getTargetAtCrosshair()
        if target then
            triggerbotSettings.running = true
            fireWeapon()
            task.wait(triggerbotSettings.delay)
            triggerbotSettings.running = false
        end
    end)
end

local function stopTriggerBot()
    if connections.triggerbotConnection then
        connections.triggerbotConnection:Disconnect()
        connections.triggerbotConnection = nil
    end
    triggerbotSettings.running = false
end

-- hitbox expander (fixed)
local function enableHitbox()
    if HitboxExpander.Connection then HitboxExpander.Connection:Disconnect() end
    
    HitboxExpander.Connection = Services.RunService.Heartbeat:Connect(function()
        if not HitboxExpander.Enabled then return end
        
        for _, p in ipairs(Services.Players:GetPlayers()) do
            if p ~= player then
                local c = p.Character
                if c then
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    if hrp and not expandedPlayers[hrp] then
                        pcall(function()
                            hrp.Size = Vector3.new(HitboxExpander.Size, HitboxExpander.Size, HitboxExpander.Size)
                            hrp.Transparency = HitboxExpander.Transparency
                            hrp.Color = HitboxExpander.Color
                            hrp.Material = Enum.Material.Neon
                            hrp.CanCollide = false
                            expandedPlayers[hrp] = true
                        end)
                    end
                end
            end
        end
    end)
    notify("Hitbox", "Hitbox Expander Enabled (size "..HitboxExpander.Size..")", 5)
end

local function disableHitbox()
    if HitboxExpander.Connection then HitboxExpander.Connection:Disconnect() HitboxExpander.Connection = nil end
    for _, p in ipairs(Services.Players:GetPlayers()) do
        if p ~= player then
            local c = p.Character
            if c then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        hrp.Size = Vector3.new(2,2,1)
                        hrp.Transparency = 1
                        hrp.CanCollide = false
                        expandedPlayers[hrp] = nil
                    end)
                end
            end
        end
    end
    expandedPlayers = {}
    notify("Hitbox", "Hitbox Expander Disabled", 5)
end

-- troll features - chat spam (fixed)
local function chatSpammerLoop()
    while states.chatSpammer do
        local text = trollSettings.chatText
        if text ~= "" then
            pcall(function()
                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(text)
            end)
        end
        task.wait(trollSettings.chatDelay)
    end
end

local function enableFakeLag()
    states.fakeLag = true
    if connections.fakeLagConnection then connections.fakeLagConnection:Disconnect() end
    connections.fakeLagConnection = Services.RunService.Heartbeat:Connect(function()
        if states.fakeLag and player.Character then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.Anchored = true
                task.wait(trollSettings.fakeLagDelayTime)
                if rootPart and rootPart.Parent then rootPart.Anchored = false end
            end
        end
        task.wait(trollSettings.fakeLagWaitTime)
    end)
end

local function disableFakeLag()
    states.fakeLag = false
    if connections.fakeLagConnection then
        connections.fakeLagConnection:Disconnect()
        connections.fakeLagConnection = nil
    end
    if player.Character then
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then rootPart.Anchored = false end
    end
end

local function followPlayerLoop()
    while states.followPlayer and Services.RunService.Heartbeat:Wait() do
        if trollSettings.followTarget and trollSettings.followTarget.Character then
            local targetRoot = trollSettings.followTarget.Character:FindFirstChild("HumanoidRootPart")
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot and myRoot then
                myRoot.CFrame = targetRoot.CFrame * CFrame.new(2, 0, 0)
            end
        else
            states.followPlayer = false
            trollSettings.followTarget = nil
            break
        end
        task.wait(0.03)
    end
end

-- fling (fixed)
local function GetPlayer(Name)
    Name = Name:lower()
    local AllBool = false
    if Name == "all" or Name == "others" then
        AllBool = true
        local allPlayers = {}
        for _, x in next, Services.Players:GetPlayers() do
            if x ~= player then table.insert(allPlayers, x) end
        end
        return allPlayers, AllBool
    elseif Name == "random" then
        local GetPlayers = Services.Players:GetPlayers()
        if table.find(GetPlayers, player) then table.remove(GetPlayers, table.find(GetPlayers, player)) end
        return {GetPlayers[math.random(#GetPlayers)]}, false
    elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
        for _, x in next, Services.Players:GetPlayers() do
            if x ~= player then
                if x.Name:lower():match("^"..Name) then
                    return {x}, false
                elseif x.DisplayName:lower():match("^"..Name) then
                    return {x}, false
                end
            end
        end
    end
    return {}, false
end

local function SkidFling(TargetPlayer)
    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle

    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessory and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit then
            return notify("Error", "Target is sitting", 5)
        end
        if THead then
            Services.Workspace.CurrentCamera.CameraSubject = THead
        elseif not THead and Handle then
            Services.Workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            Services.Workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end
        
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local SFBasePart = function(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Services.Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end
        
        Services.Workspace.FallenPartsDestroyHeight = 0/0
        
        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        else
            return notify("Error", "Target is missing everything", 5)
        end
        
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        Services.Workspace.CurrentCamera.CameraSubject = Humanoid
        
        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            table.foreach(Character:GetChildren(), function(_, x)
                if x:IsA("BasePart") then
                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                end
            end)
            task.wait()
        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
        Services.Workspace.FallenPartsDestroyHeight = scriptEnv.FPDH
    else
        return notify("Error", "Random error", 5)
    end
end

-- flight
local function enableFlight()
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if connections.flyBodyVelocity then connections.flyBodyVelocity:Destroy() end
    if connections.flyBodyGyro then connections.flyBodyGyro:Destroy() end
    
    connections.flyBodyVelocity = Instance.new("BodyVelocity")
    connections.flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    connections.flyBodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    connections.flyBodyVelocity.Parent = hrp
    
    connections.flyBodyGyro = Instance.new("BodyGyro")
    connections.flyBodyGyro.D = 500
    connections.flyBodyGyro.P = 10000
    connections.flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    connections.flyBodyGyro.CFrame = hrp.CFrame
    connections.flyBodyGyro.Parent = hrp
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.PlatformStand = true end
end

local function disableFlight()
    if connections.flyBodyVelocity then connections.flyBodyVelocity:Destroy(); connections.flyBodyVelocity = nil end
    if connections.flyBodyGyro then connections.flyBodyGyro:Destroy(); connections.flyBodyGyro = nil end
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
end

local function toggleFlightState()
    states.flight = not states.flight
    if states.flight then enableFlight() else disableFlight() end
end

-- noclip
local function enableNoclip()
    states.noclip = true
    if connections.noclipConnection then connections.noclipConnection:Disconnect() end
    connections.noclipConnection = Services.RunService.Stepped:Connect(function()
        if states.noclip and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

local function disableNoclip()
    states.noclip = false
    if connections.noclipConnection then
        connections.noclipConnection:Disconnect()
        connections.noclipConnection = nil
    end
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

-- teleport
local function teleportToPlayer(username)
    if username == "" then return end
    local targets = findPlayer(username)
    if #targets == 0 then return end
    local targetRoot = targets[1].Character and targets[1].Character:FindFirstChild("HumanoidRootPart")
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if targetRoot and myRoot then
        myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 0, -3)
    end
end

-- other features
local function enableInvincibility()
    if connections.healthConnection then connections.healthConnection:Disconnect() end
    connections.healthConnection = Services.RunService.Heartbeat:Connect(function()
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid.Health = humanoid.MaxHealth end
        end
    end)
end

local function disableInvincibility()
    if connections.healthConnection then
        connections.healthConnection:Disconnect()
        connections.healthConnection = nil
    end
end

local function touchFlingLoop()
    while states.touchFling and Services.RunService.Heartbeat:Wait() do
        local character = player.Character
        if not character then continue end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        local originalVel = hrp.Velocity
        hrp.Velocity = originalVel * 10000 + Vector3.new(0, 10000, 0)
        Services.RunService.RenderStepped:Wait()
        hrp.Velocity = originalVel
    end
end

-- gui creation
local gui = {}

gui.screen = Instance.new("ScreenGui")
gui.screen.Name = "s0ulzV5Glass"
gui.screen.Parent = playerGui
gui.screen.ResetOnSpawn = false
gui.screen.IgnoreGuiInset = true
gui.screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.screen.DisplayOrder = 999999

-- main container (mobile responsive)
gui.main = Instance.new("Frame")
gui.main.Name = "MainContainer"
gui.main.Parent = gui.screen
gui.main.BackgroundColor3 = theme.glass
gui.main.BackgroundTransparency = 0.15
gui.main.BorderSizePixel = 0
gui.main.AnchorPoint = Vector2.new(0.5, 0.5)
gui.main.Position = UDim2.new(0.5, 0, 0.5, 0)
gui.main.Size = UDim2.new(0, math.min(800, Services.Workspace.CurrentCamera.ViewportSize.X * 0.9), 0, math.min(500, Services.Workspace.CurrentCamera.ViewportSize.Y * 0.8))
gui.main.Active = true
gui.main.ZIndex = 1

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = gui.main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = theme.border
mainStroke.Transparency = 0.5
mainStroke.Parent = gui.main

-- glass overlay
local glassOverlay = Instance.new("Frame")
glassOverlay.Name = "GlassOverlay"
glassOverlay.Parent = gui.main
glassOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glassOverlay.BackgroundTransparency = 0.95
glassOverlay.BorderSizePixel = 0
glassOverlay.Size = UDim2.new(1, 0, 1, 0)
glassOverlay.ZIndex = 0

local glassCorner = Instance.new("UICorner")
glassCorner.CornerRadius = UDim.new(0, 12)
glassCorner.Parent = glassOverlay

-- dragging
local dragToggle, dragStart, startPos = nil, nil, nil
local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    tween(gui.main, 0.25, {Position = position}):Play()
end

gui.main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = gui.main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)

Services.UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragToggle then
        -- Don't drag GUI if a slider is being dragged
        local draggingSlider = false
        for _, descendant in ipairs(gui.main:GetDescendants()) do
            if descendant.Name == "Track" then
                local thumb = descendant:FindFirstChild("Thumb")
                if thumb and thumb:FindFirstChild("UIStroke") and thumb.UIStroke.Transparency < 0.4 then
                    draggingSlider = true
                    break
                end
            end
        end
        
        if not draggingSlider then
            updateInput(input)
        end
    end
end)

-- top bar
gui.topBar = Instance.new("Frame")
gui.topBar.Name = "TopBar"
gui.topBar.Parent = gui.main
gui.topBar.BackgroundColor3 = theme.surface
gui.topBar.BackgroundTransparency = 0
gui.topBar.BorderSizePixel = 0
gui.topBar.Size = UDim2.new(1, 0, 0, 50)
gui.topBar.ZIndex = 2
gui.topBar.ClipsDescendants = false  -- Changed to false

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 12)
topBarCorner.Parent = gui.topBar

local titleText = Instance.new("TextLabel")
titleText.Parent = gui.topBar
titleText.BackgroundTransparency = 1
titleText.Position = UDim2.new(0, 20, 0, 0)
titleText.Size = UDim2.new(0, 200, 1, 0)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "s0ulz V5"
titleText.TextColor3 = theme.text
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.ZIndex = 3

local topBarBottomMask = Instance.new("Frame")
topBarBottomMask.Parent = gui.topBar
topBarBottomMask.BackgroundColor3 = theme.surface
topBarBottomMask.BackgroundTransparency = 0.3
topBarBottomMask.BorderSizePixel = 0
topBarBottomMask.Position = UDim2.new(0, 0, 1, -12)
topBarBottomMask.Size = UDim2.new(1, 0, 0, 12)
topBarBottomMask.ZIndex = 2

local authorText = Instance.new("TextLabel")
authorText.Parent = gui.topBar
authorText.BackgroundTransparency = 1
authorText.Position = UDim2.new(0, 100, 0, 0)
authorText.Size = UDim2.new(0, 200, 1, 0)
authorText.Font = Enum.Font.Gotham
authorText.Text = "Universal Cheats :D"
authorText.TextColor3 = theme.textDim
authorText.TextSize = 11
authorText.TextXAlignment = Enum.TextXAlignment.Left
authorText.ZIndex = 3

-- control buttons (fixed positioning)
local function createControlBtn(text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Parent = gui.topBar
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.2
    btn.Position = pos
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = theme.text
    btn.TextSize = 16
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.border
    stroke.Transparency = 0.7
    stroke.Parent = btn
    
    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, {BackgroundTransparency = 0}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, {BackgroundTransparency = 0.2}):Play()
    end)
    
    return btn
end

gui.minimizeBtn = createControlBtn("_", UDim2.new(1, -110, 0.5, -15), theme.surface)
gui.closeBtn = createControlBtn("×", UDim2.new(1, -70, 0.5, -15), theme.surface)

-- sidebar
gui.sidebar = Instance.new("Frame")
gui.sidebar.Name = "Sidebar"
gui.sidebar.Parent = gui.main
gui.sidebar.BackgroundColor3 = theme.surface
gui.sidebar.BackgroundTransparency = 0.4
gui.sidebar.BorderSizePixel = 0
gui.sidebar.Position = UDim2.new(0, 0, 0, 50)  -- Changed from (0, 0, 0, 50) - starts BELOW topBar
gui.sidebar.Size = UDim2.new(0, 200, 1, -50)
gui.sidebar.ZIndex = 2

local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Color = theme.border
sidebarStroke.Transparency = 0.7
sidebarStroke.Parent = gui.sidebar

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Parent = gui.sidebar
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Padding = UDim.new(0, 2)

local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 10)
sidebarPadding.Parent = gui.sidebar

-- Updated tabs with asset IDs
local tabs = {
    {name = "Main", iconId = "rbxassetid://120749810782714", category = nil},
    {name = "Teleport", iconId = "rbxassetid://110936541789414", category = nil},
    {name = "Troll", iconId = "rbxassetid://116306337740101", category = nil},
    {name = "Combat", iconId = "rbxassetid://98186551294424", category = true, subcategories = {"Hitbox", "Aim", "Invincible", "Triggerbot"}},
    {name = "Visual", iconId = "rbxassetid://80175980744052", category = true, subcategories = {"ESP", "Tracers"}},
    {name = "Scripts", iconId = "rbxassetid://139603486234259", category = nil},
    {name = "Games", iconId = "rbxassetid://96175208477490", category = nil},
    {name = "Utility", iconId = "rbxassetid://128329248371751", category = nil}
}

local tabButtons = {}
local expandedCategories = {}

local function createNavButton(parent, text, iconId, layoutOrder, isCategory)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = theme.surface
    btn.BackgroundTransparency = 0.4
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = layoutOrder
    btn.ZIndex = 3
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = theme.border
    btnStroke.Transparency = 0.9
    btnStroke.Parent = btn
    
    local iconImage = Instance.new("ImageLabel")
    iconImage.Name = "Icon"
    iconImage.Parent = btn
    iconImage.BackgroundTransparency = 1
    iconImage.Position = UDim2.new(0, 15, 0.5, -10)
    iconImage.Size = UDim2.new(0, 20, 0, 20)
    iconImage.Image = iconId
    iconImage.ImageColor3 = theme.textDim
    iconImage.ScaleType = Enum.ScaleType.Fit
    iconImage.ZIndex = 4
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = btn
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 45, 0, 0)
    textLabel.Size = UDim2.new(1, -70, 1, 0)
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.Text = text
    textLabel.TextColor3 = theme.textDim
    textLabel.TextSize = 12
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.ZIndex = 3
    
    if isCategory then
        local arrow = Instance.new("TextLabel")
        arrow.Name = "Arrow"
        arrow.Parent = btn
        arrow.BackgroundTransparency = 1
        arrow.Position = UDim2.new(1, -25, 0, 0)
        arrow.Size = UDim2.new(0, 20, 1, 0)
        arrow.Font = Enum.Font.Gotham
        arrow.Text = "▼"
        arrow.TextColor3 = theme.textDim
        arrow.TextSize = 10
        arrow.Rotation = -90
        arrow.ZIndex = 3
    end
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Parent = btn
    indicator.BackgroundColor3 = theme.accent
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0, 0)
    indicator.Size = UDim2.new(0, 0, 1, 0)
    indicator.ZIndex = 3
    
    btn.MouseEnter:Connect(function()
        if config.currentTab ~= text then
            tween(btn, 0.15, {BackgroundTransparency = 0.2}):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if config.currentTab ~= text then
            tween(btn, 0.15, {BackgroundTransparency = 0.4}):Play()
        end
    end)
    
    return btn, textLabel, iconImage
end

for i, tab in ipairs(tabs) do
    local btn, textLabel, iconImage = createNavButton(gui.sidebar, tab.name, tab.iconId, i, tab.category)
    tabButtons[tab.name] = {button = btn, textLabel = textLabel, icon = iconImage}
    
    if tab.category and tab.subcategories then
        local subContainer = Instance.new("Frame")
        subContainer.Name = tab.name .. "SubContainer"
        subContainer.Parent = gui.sidebar
        subContainer.BackgroundTransparency = 1
        subContainer.Size = UDim2.new(1, 0, 0, 0)
        subContainer.Visible = false
        subContainer.LayoutOrder = i + 0.5
        subContainer.ClipsDescendants = true
        subContainer.ZIndex = 2
        
        local subLayout = Instance.new("UIListLayout")
        subLayout.Parent = subContainer
        subLayout.SortOrder = Enum.SortOrder.LayoutOrder
        subLayout.Padding = UDim.new(0, 2)
        
        for j, subcat in ipairs(tab.subcategories) do
            local subBtn = Instance.new("TextButton")
            subBtn.Parent = subContainer
            subBtn.BackgroundColor3 = theme.bg
            subBtn.BackgroundTransparency = 0.3
            subBtn.BorderSizePixel = 0
            subBtn.Size = UDim2.new(1, 0, 0, 35)
            subBtn.Font = Enum.Font.Gotham
            subBtn.Text = ""
            subBtn.AutoButtonColor = false
            subBtn.LayoutOrder = j
            subBtn.ZIndex = 3
            
            local subText = Instance.new("TextLabel")
            subText.Parent = subBtn
            subText.BackgroundTransparency = 1
            subText.Position = UDim2.new(0, 50, 0, 0)
            subText.Size = UDim2.new(1, -50, 1, 0)
            subText.Font = Enum.Font.Gotham
            subText.Text = subcat
            subText.TextColor3 = theme.textDim
            subText.TextSize = 11
            subText.TextXAlignment = Enum.TextXAlignment.Left
            subText.ZIndex = 3
            
            local subIndicator = Instance.new("Frame")
            subIndicator.Name = "Indicator"
            subIndicator.Parent = subBtn
            subIndicator.BackgroundColor3 = theme.accent
            subIndicator.BorderSizePixel = 0
            subIndicator.Position = UDim2.new(0, 0, 0, 0)
            subIndicator.Size = UDim2.new(0, 0, 1, 0)
            subIndicator.ZIndex = 3
            
            subBtn.MouseEnter:Connect(function()
                tween(subBtn, 0.15, {BackgroundTransparency = 0.1}):Play()
            end)
            
            subBtn.MouseLeave:Connect(function()
                tween(subBtn, 0.15, {BackgroundTransparency = 0.3}):Play()
            end)
            
            tabButtons[subcat] = {button = subBtn, textLabel = subText}
        end
        
        btn.MouseButton1Click:Connect(function()
            expandedCategories[tab.name] = not expandedCategories[tab.name]
            local arrow = btn:FindFirstChild("Arrow")
            if arrow then
                if expandedCategories[tab.name] then
                    tween(arrow, 0.2, {Rotation = 0}):Play()
                    subContainer.Visible = true
                    tween(subContainer, 0.2, {Size = UDim2.new(1, 0, 0, #tab.subcategories * 37)}):Play()
                    
                    -- Expand GUI height dynamically
                    if not config.isMinimized then
                        local expandHeight = #tab.subcategories * 37
                        local currentHeight = gui.main.Size.Y.Offset
                        local maxHeight = math.min(700, Services.Workspace.CurrentCamera.ViewportSize.Y * 0.9)
                        local newHeight = math.min(currentHeight + expandHeight, maxHeight)
                        
                        tween(gui.main, 0.3, {Size = UDim2.new(gui.main.Size.X.Scale, gui.main.Size.X.Offset, 0, newHeight)}):Play()
                        tween(gui.sidebar, 0.3, {Size = UDim2.new(0, 200, 0, newHeight - 50)}):Play()
                        tween(gui.content, 0.3, {Size = UDim2.new(1, -200, 0, newHeight - 50)}):Play()
                    end
                else
                    tween(arrow, 0.2, {Rotation = -90}):Play()
                    tween(subContainer, 0.2, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    task.wait(0.2)
                    if not expandedCategories[tab.name] then subContainer.Visible = false end
                    
                    -- Shrink GUI height back
                    if not config.isMinimized then
                        local collapseHeight = #tab.subcategories * 37
                        local currentHeight = gui.main.Size.Y.Offset
                        local baseHeight = math.min(500, Services.Workspace.CurrentCamera.ViewportSize.Y * 0.8)
                        
                        -- Check if other categories are expanded
                        local totalExpandedHeight = 0
                        for catName, isExpanded in pairs(expandedCategories) do
                            if isExpanded and catName ~= tab.name then
                                for _, t in ipairs(tabs) do
                                    if t.name == catName and t.subcategories then
                                        totalExpandedHeight = totalExpandedHeight + (#t.subcategories * 37)
                                    end
                                end
                            end
                        end
                        
                        local newHeight = math.max(baseHeight + totalExpandedHeight, baseHeight)
                        
                        tween(gui.main, 0.3, {Size = UDim2.new(gui.main.Size.X.Scale, gui.main.Size.X.Offset, 0, newHeight)}):Play()
                        tween(gui.sidebar, 0.3, {Size = UDim2.new(0, 200, 0, newHeight - 50)}):Play()
                        tween(gui.content, 0.3, {Size = UDim2.new(1, -200, 0, newHeight - 50)}):Play()
                    end
                end
            end
        end)
    end
end

-- content area
-- content area
gui.content = Instance.new("Frame")
gui.content.Name = "ContentArea"
gui.content.Parent = gui.main
gui.content.BackgroundTransparency = 1
gui.content.Position = UDim2.new(0, 200, 0, 50)  -- Should be (0, 200, 0, 50)
gui.content.Size = UDim2.new(1, -200, 1, -50)
gui.content.ZIndex = 2
gui.content.ClipsDescendants = true

local contentFrames = {}
local allTabs = {}
for _, tab in ipairs(tabs) do
    table.insert(allTabs, tab.name)
    if tab.subcategories then
        for _, subcat in ipairs(tab.subcategories) do
            table.insert(allTabs, subcat)
        end
    end
end

for _, tabName in ipairs(allTabs) do
    local frame = Instance.new("ScrollingFrame")
    frame.Name = tabName .. "Content"
    frame.Parent = gui.content
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0, 0, -1, 0)  -- START OFF-SCREEN AT TOP
    frame.Visible = (tabName == "Main")
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = theme.accent
    frame.ScrollBarImageTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.ZIndex = 2
    
    if tabName == "Main" then
        frame.Position = UDim2.new(0, 0, 0, 0)  -- Main tab starts visible
    end
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 20)
    padding.PaddingRight = UDim.new(0, 20)
    padding.PaddingTop = UDim.new(0, 20)
    padding.PaddingBottom = UDim.new(0, 20)
    padding.Parent = frame
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = frame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 15)
    
    contentFrames[tabName] = frame
end

-- ui components
local function createCard(parent, layoutOrder)
    local card = Instance.new("Frame")
    card.Parent = parent
    card.BackgroundColor3 = theme.surface
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Size = UDim2.new(1, 0, 0, 100)
    card.LayoutOrder = layoutOrder or 1
    card.ZIndex = 2
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.border
    stroke.Transparency = 0.7
    stroke.Parent = card
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 20)
    padding.PaddingRight = UDim.new(0, 20)
    padding.PaddingTop = UDim.new(0, 15)
    padding.PaddingBottom = UDim.new(0, 15)
    padding.Parent = card
    
    return card
end

local function createToggle(parent, labelText, descText, callback, layoutOrder)
    local card = createCard(parent, layoutOrder)
    card.Size = UDim2.new(1, 0, 0, descText and 70 or 60)
    
    local label = Instance.new("TextLabel")
    label.Parent = card
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.Font = Enum.Font.GothamMedium
    label.Text = labelText
    label.TextColor3 = theme.text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.ZIndex = 3
    
    if descText then
        local desc = Instance.new("TextLabel")
        desc.Parent = card
        desc.BackgroundTransparency = 1
        desc.Position = UDim2.new(0, 0, 0, 24)
        desc.Size = UDim2.new(0.7, 0, 0, 30)
        desc.Font = Enum.Font.Gotham
        desc.Text = descText
        desc.TextColor3 = theme.textDim
        desc.TextSize = 11
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextYAlignment = Enum.TextYAlignment.Top
        desc.TextWrapped = true
        desc.ZIndex = 3
    end
    
    local toggle = Instance.new("Frame")
    toggle.Parent = card
    toggle.BackgroundColor3 = theme.border
    toggle.BackgroundTransparency = 0.2
    toggle.BorderSizePixel = 0
    toggle.Position = UDim2.new(1, -50, 0.5, -12)
    toggle.Size = UDim2.new(0, 50, 0, 24)
    toggle.ZIndex = 3
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = theme.border
    toggleStroke.Transparency = 0.5
    toggleStroke.Parent = toggle
    
    local knob = Instance.new("Frame")
    knob.Parent = toggle
    knob.BackgroundColor3 = theme.textDim
    knob.BorderSizePixel = 0
    knob.Position = UDim2.new(0, 2, 0.5, -10)
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.ZIndex = 4
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local button = Instance.new("TextButton")
    button.Parent = card
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.ZIndex = 5
    
    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        if state then
            tween(toggle, 0.2, {BackgroundColor3 = theme.accent, BackgroundTransparency = 0}):Play()
            tween(knob, 0.2, {Position = UDim2.new(1, -22, 0.5, -10), BackgroundColor3 = theme.bg}):Play()
        else
            tween(toggle, 0.2, {BackgroundColor3 = theme.border, BackgroundTransparency = 0.2}):Play()
            tween(knob, 0.2, {Position = UDim2.new(0, 2, 0.5, -10), BackgroundColor3 = theme.textDim}):Play()
        end
        if callback then callback(state) end
    end)
    
    return button
end

local function createSlider(parent, labelText, descText, minVal, maxVal, currentVal, callback, layoutOrder)
    local card = createCard(parent, layoutOrder)
    card.Size = UDim2.new(1, 0, 0, 90)
    
    local label = Instance.new("TextLabel")
    label.Parent = card
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.Font = Enum.Font.GothamMedium
    label.Text = labelText
    label.TextColor3 = theme.text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    
    local desc = Instance.new("TextLabel")
    desc.Parent = card
    desc.BackgroundTransparency = 1
    desc.Position = UDim2.new(0, 0, 0, 24)
    desc.Size = UDim2.new(1, -80, 0, 16)
    desc.Font = Enum.Font.Gotham
    desc.Text = descText
    desc.TextColor3 = theme.textDim
    desc.TextSize = 11
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextWrapped = true
    desc.ZIndex = 3
    
    local valueBox = Instance.new("TextBox")
    valueBox.Parent = card
    valueBox.BackgroundTransparency = 1
    valueBox.Position = UDim2.new(1, -70, 0, 0)
    valueBox.Size = UDim2.new(0, 70, 0, 20)
    valueBox.Font = Enum.Font.RobotoMono
    valueBox.Text = tostring(currentVal)
    valueBox.TextColor3 = theme.text
    valueBox.TextSize = 13
    valueBox.TextXAlignment = Enum.TextXAlignment.Right
    valueBox.ClearTextOnFocus = false
    valueBox.ZIndex = 3
    
    local track = Instance.new("Frame")
    track.Parent = card
    track.BackgroundColor3 = theme.border
    track.BackgroundTransparency = 0.3
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 0, 1, -12)
    track.Size = UDim2.new(1, 0, 0, 6)
    track.ZIndex = 3
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    track.Name = "Track"

    local fill = Instance.new("Frame")
    fill.Parent = track
    fill.BackgroundColor3 = theme.accent
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((currentVal - minVal)/(maxVal - minVal), 0, 1, 0)
    fill.ZIndex = 4
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local thumb = Instance.new("Frame")
    thumb.Parent = track
    thumb.BackgroundColor3 = theme.accent
    thumb.BorderSizePixel = 0
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new((currentVal - minVal)/(maxVal - minVal), 0, 0.5, 0)
    thumb.ZIndex = 5
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    thumb.Name = "Thumb"

    local thumbGlow = Instance.new("UIStroke")
    thumbGlow.Color = theme.accent
    thumbGlow.Transparency = 0.5
    thumbGlow.Thickness = 2
    thumbGlow.Parent = thumb
    
    local dragging = false
    local function updateSlider(value)
        value = math.clamp(value, minVal, maxVal)
        local percent = (value - minVal)/(maxVal - minVal)
        tween(fill, 0.1, {Size = UDim2.new(percent, 0, 1, 0)}):Play()
        tween(thumb, 0.1, {Position = UDim2.new(percent, 0, 0.5, 0)}):Play()
        valueBox.Text = tostring(math.round(value * 100) / 100)
        if callback then callback(value) end
    end
    
    valueBox.FocusLost:Connect(function()
        local num = tonumber(valueBox.Text)
        if num then
            updateSlider(math.clamp(num, minVal, maxVal))
        else
            valueBox.Text = tostring(math.round(currentVal * 100) / 100)
        end
    end)
    
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            tween(thumb, 0.1, {Size = UDim2.new(0, 20, 0, 20)}):Play()
            tween(thumbGlow, 0.1, {Transparency = 0.2}):Play()
        end
    end)

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = false
            dragging = true
            tween(thumb, 0.1, {Size = UDim2.new(0, 20, 0, 20)}):Play()
            tween(thumbGlow, 0.1, {Transparency = 0.2}):Play()
            
            local mousePos = Services.UserInputService:GetMouseLocation()
            local trackPos = track.AbsolutePosition
            local relativeX = math.clamp((mousePos.X - trackPos.X) / track.AbsoluteSize.X, 0, 1)
            updateSlider(minVal + (maxVal - minVal) * relativeX)
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = Services.UserInputService:GetMouseLocation()
            local trackPos = track.AbsolutePosition
            local relativeX = math.clamp((mousePos.X - trackPos.X) / track.AbsoluteSize.X, 0, 1)
            updateSlider(minVal + (maxVal - minVal) * relativeX)
        end
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            dragging = false
            tween(thumb, 0.1, {Size = UDim2.new(0, 16, 0, 16)}):Play()
            tween(thumbGlow, 0.1, {Transparency = 0.5}):Play()
        end
    end)
    
    return updateSlider
end

local function createButton(parent, text, callback, layoutOrder, color)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = color or theme.surface
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, 0, 0, 44)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = theme.text
    btn.TextSize = 13
    btn.AutoButtonColor = false
    btn.LayoutOrder = layoutOrder or 1
    btn.ZIndex = 3
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.border
    stroke.Transparency = 0.7
    stroke.Parent = btn
    
    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, {BackgroundTransparency = 0.1}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, {BackgroundTransparency = 0.3}):Play()
    end)
    
    if callback then btn.MouseButton1Click:Connect(callback) end
    return btn
end

local function createInput(parent, placeholder, layoutOrder)
    local input = Instance.new("TextBox")
    input.Parent = parent
    input.BackgroundColor3 = theme.surface
    input.BackgroundTransparency = 0.3
    input.BorderSizePixel = 0
    input.Size = UDim2.new(1, 0, 0, 50)
    input.Font = Enum.Font.Gotham
    input.PlaceholderText = placeholder
    input.PlaceholderColor3 = theme.textDim
    input.Text = ""
    input.TextColor3 = theme.text
    input.TextSize = 12
    input.ClearTextOnFocus = false
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.LayoutOrder = layoutOrder
    input.ZIndex = 3
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = input
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = theme.border
    inputStroke.Transparency = 0.7
    inputStroke.Parent = input
    
    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 12)
    inputPadding.PaddingRight = UDim.new(0, 12)
    inputPadding.Parent = input
    
    return input
end

-- main tab
local headerCard = createCard(contentFrames.Main, 1)
headerCard.Size = UDim2.new(1, 0, 0, 60)

local greetingText = Instance.new("TextLabel")
greetingText.Parent = headerCard
greetingText.BackgroundTransparency = 1
greetingText.Size = UDim2.new(1, 0, 0, 22)
greetingText.Font = Enum.Font.GothamBold
greetingText.Text = getTimeBasedGreeting()
greetingText.TextColor3 = theme.text
greetingText.TextSize = 16
greetingText.TextXAlignment = Enum.TextXAlignment.Left
greetingText.ZIndex = 3

local infoText = Instance.new("TextLabel")
infoText.Parent = headerCard
infoText.BackgroundTransparency = 1
infoText.Position = UDim2.new(0, 0, 0, 26)
infoText.Size = UDim2.new(1, 0, 0, 28)
infoText.Font = Enum.Font.Gotham
infoText.Text = "Don't be a dumbass :D"
infoText.TextColor3 = theme.textDim
infoText.TextSize = 11
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.TextWrapped = true
infoText.ZIndex = 3

createSlider(contentFrames.Main, "Walk Speed", "Movement speed", 16, 1000, config.currentSpeed, 
    function(val) config.currentSpeed = val; applyCharacterSettings() end, 2)

createSlider(contentFrames.Main, "Jump Power", "Jump height", 50, 500, config.currentJump,
    function(val) config.currentJump = val; applyCharacterSettings() end, 3)

createSlider(contentFrames.Main, "Flight Speed", "Flight velocity", 10, 200, config.flightSpeed,
    function(val) config.flightSpeed = val end, 4)

createToggle(contentFrames.Main, "Flight", "Press F to toggle", function(state) 
    states.flight = state
    if state then enableFlight() else disableFlight() end
end, 5)

createToggle(contentFrames.Main, "Noclip", "Walk through walls", function(state) 
    if state then enableNoclip() else disableNoclip() end
end, 6)

-- teleport tab
local teleportInput = createInput(contentFrames.Teleport, "Enter player username...", 1)
createButton(contentFrames.Teleport, "Teleport to Player", function() teleportToPlayer(teleportInput.Text) end, 2)
createToggle(contentFrames.Teleport, "Infinite Teleport", "Loop teleport", function(state) 
    states.infiniteTeleport = state
    if state then
        connections.teleportConnection = Services.RunService.Heartbeat:Connect(function()
            if teleportInput.Text ~= "" then teleportToPlayer(teleportInput.Text) end
        end)
    else
        if connections.teleportConnection then
            connections.teleportConnection:Disconnect()
            connections.teleportConnection = nil
        end
    end
end, 3)

-- troll tab
local chatTextInput = createInput(contentFrames.Troll, "Enter text to spam...", 1)
createSlider(contentFrames.Troll, "Chat Delay", "Time between messages", 0.1, 10, trollSettings.chatDelay,
    function(val) trollSettings.chatDelay = val end, 2)
createToggle(contentFrames.Troll, "Chat Spammer", "Spam chat", function(state) 
    states.chatSpammer = state
    trollSettings.chatText = chatTextInput.Text
    if state then
        connections.chatSpamThread = task.spawn(chatSpammerLoop)
    else
        if connections.chatSpamThread then
            task.cancel(connections.chatSpamThread)
            connections.chatSpamThread = nil
        end
    end
end, 3)
createSlider(contentFrames.Troll, "Fake Lag Wait", "Delay between lags", 0.01, 1, trollSettings.fakeLagWaitTime,
    function(val) trollSettings.fakeLagWaitTime = val end, 4)
createSlider(contentFrames.Troll, "Fake Lag Delay", "Lag duration", 0.1, 2, trollSettings.fakeLagDelayTime,
    function(val) trollSettings.fakeLagDelayTime = val end, 5)
createToggle(contentFrames.Troll, "Fake Lag", "Simulate lag", function(state) 
    if state then enableFakeLag() else disableFakeLag() end
end, 6)

local followInput = createInput(contentFrames.Troll, "Player to follow...", 7)
createToggle(contentFrames.Troll, "Follow Player", "Mirror movements", function(state) 
    if state then
        local targets = findPlayer(followInput.Text)
        if #targets > 0 then
            trollSettings.followTarget = targets[1]
            states.followPlayer = true
            connections.followThread = task.spawn(followPlayerLoop)
        end
    else
        states.followPlayer = false
        trollSettings.followTarget = nil
        if connections.followThread then task.cancel(connections.followThread) end
    end
end, 8)

local flingInput = createInput(contentFrames.Troll, "Player to fling...", 9)
createButton(contentFrames.Troll, "Fling Player", function()
    local targets, _ = GetPlayer(flingInput.Text:lower())
    for _, target in ipairs(targets) do
        if target then
            SkidFling(target)
        end
    end
end, 10)

local whitelistInput = createInput(contentFrames.Troll, "Whitelist (comma separated)...", 11)
createButton(contentFrames.Troll, "Fling Everyone", function()
    local whitelist = {}
    for name in whitelistInput.Text:gmatch("[^,]+") do
        local trimmed = name:match("^%s*(.-)%s*$")
        if trimmed ~= "" then
            whitelist[trimmed:lower()] = true
        end
    end
    
    for _, otherPlayer in ipairs(Services.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local isWhitelisted = whitelist[otherPlayer.Name:lower()] or whitelist[otherPlayer.DisplayName:lower()]
            if not isWhitelisted then
                SkidFling(otherPlayer)
            end
        end
    end
end, 12, theme.error)

createToggle(contentFrames.Troll, "Touch Fling", "Fling on touch", function(state) 
    states.touchFling = state
    if state then
        connections.touchFlingThread = task.spawn(touchFlingLoop)
    else
        if connections.touchFlingThread then task.cancel(connections.touchFlingThread) end
    end
end, 13)

-- hitbox tab
createToggle(contentFrames.Hitbox, "Enable Hitbox", "Expand hitboxes", function(state) 
    HitboxExpander.Enabled = state
    if state then enableHitbox() else disableHitbox() end
end, 1)
createSlider(contentFrames.Hitbox, "Hitbox Size", "Expansion amount", 1, 20, HitboxExpander.Size,
    function(val) HitboxExpander.Size = val; if HitboxExpander.Enabled then disableHitbox(); enableHitbox() end end, 2)

-- aim tab
createToggle(contentFrames.Aim, "Aimbot", "Auto-aim", function(state) 
    aimbotSettings.Enabled = state
    if state then startAimbot() else stopAimbot() end
end, 1)
createSlider(contentFrames.Aim, "Smoothing", "Aim smoothness", 0, 1, aimbotSettings.Smoothing,
    function(val) aimbotSettings.Smoothing = val end, 2)

-- invincible tab
createToggle(contentFrames.Invincible, "Invincible", "God mode", function(state) 
    states.invincible = state
    if state then enableInvincibility() else disableInvincibility() end
end, 1)

-- triggerbot tab
createToggle(contentFrames.Triggerbot, "Triggerbot", "Auto-fire on target", function(state) 
    triggerbotSettings.Enabled = state
    if state then startTriggerBot() else stopTriggerBot() end
end, 1)
createSlider(contentFrames.Triggerbot, "Delay", "Fire delay", 0, 1, triggerbotSettings.delay,
    function(val) triggerbotSettings.delay = val end, 2)
createSlider(contentFrames.Triggerbot, "Range", "Max distance", 50, 1000, triggerbotSettings.range,
    function(val) triggerbotSettings.range = val end, 3)

createToggle(contentFrames.ESP, "ESP", "See through walls", function(state) 
    espSettings.Enabled = state
    if state then setupESP() else clearAllESP() end
end, 1)

-- scripts tab
local function createScriptSection(title, scripts, parent, order)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = parent
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.text
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.LayoutOrder = order
    titleLabel.ZIndex = 3
    
    for i, script in ipairs(scripts) do
        createButton(parent, script.name, script.callback, order + i)
    end
end

local regularScripts = {
    {name = "Invisibility", callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Global/invisibility.lua"))() end},
    {name = "IY", callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end},
    {name = "FE-Chatdraw", callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Global/FE-Chatdraw.lua"))() end},
    {name = "Bird Poop", callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Troll/FE-Bird-Poop.lua"))() end},
    {name = "Chat Admin", callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Global/FE-ChatAdmin.lua"))() end}
}

local bypassers = {
    {name = "SaturnBypasser", callback = function() loadstring(game:HttpGet('https://getsaturn.pages.dev/sb.lua'))() end},
    {name = "CatBypasser", callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/shadow62x/catbypass/main/upfix"))() end},
    {name = "BetterBypasser", callback = function() loadstring(game:HttpGet("https://github.com/Synergy-Networks/products/raw/main/BetterBypasser/loader.lua"))() end}
}

local animations = {
    {name = "AquaMatrix", callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ExploitFin/AquaMatrix/refs/heads/AquaMatrix/AquaMatrix"))() end},
    {name = "Griddy", callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Animations/FE-Griddy(Buggy).lua"))() end}
}

createScriptSection("Regular Scripts", regularScripts, contentFrames.Scripts, 1)
createScriptSection("Bypassers", bypassers, contentFrames.Scripts, 20)
createScriptSection("Animations", animations, contentFrames.Scripts, 40)

-- games tab (with working search)
local searchBar = createInput(contentFrames.Games, "Search games...", 1)
local gameCards = {}

for i, gameData in ipairs(gameDatabase) do
    local gameCard = createCard(contentFrames.Games, i + 1)
    gameCard.Size = UDim2.new(1, 0, 0, 80)
    gameCard.Name = "GameCard_" .. gameData.name
    
    local gameName = Instance.new("TextLabel")
    gameName.Parent = gameCard
    gameName.BackgroundTransparency = 1
    gameName.Size = UDim2.new(1, -120, 0, 22)
    gameName.Font = Enum.Font.GothamBold
    gameName.Text = gameData.name
    gameName.TextColor3 = theme.text
    gameName.TextSize = 14
    gameName.TextXAlignment = Enum.TextXAlignment.Left
    gameName.ZIndex = 3
    
    local gameDesc = Instance.new("TextLabel")
    gameDesc.Parent = gameCard
    gameDesc.BackgroundTransparency = 1
    gameDesc.Position = UDim2.new(0, 0, 0, 26)
    gameDesc.Size = UDim2.new(1, -120, 0, 30)
    gameDesc.Font = Enum.Font.Gotham
    gameDesc.Text = gameData.desc
    gameDesc.TextColor3 = theme.textDim
    gameDesc.TextSize = 11
    gameDesc.TextXAlignment = Enum.TextXAlignment.Left
    gameDesc.TextWrapped = true
    gameDesc.ZIndex = 3
    
    local loadBtn = Instance.new("TextButton")
    loadBtn.Parent = gameCard
    loadBtn.BackgroundColor3 = theme.accent
    loadBtn.BackgroundTransparency = 0.2
    loadBtn.Position = UDim2.new(1, -110, 0.5, -15)
    loadBtn.Size = UDim2.new(0, 100, 0, 30)
    loadBtn.Font = Enum.Font.GothamBold
    loadBtn.Text = "Load"
    loadBtn.TextColor3 = theme.bg
    loadBtn.TextSize = 11
    loadBtn.AutoButtonColor = false
    loadBtn.ZIndex = 3
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = loadBtn
    
    loadBtn.MouseEnter:Connect(function()
        tween(loadBtn, 0.15, {BackgroundTransparency = 0}):Play()
    end)
    
    loadBtn.MouseLeave:Connect(function()
        tween(loadBtn, 0.15, {BackgroundTransparency = 0.2}):Play()
    end)
    
    loadBtn.MouseButton1Click:Connect(function()
        pcall(function()
            loadstring(game:HttpGet(gameData.url))()
            notify("Games", gameData.name .. " loaded!", 3)
        end)
    end)
    
    table.insert(gameCards, {card = gameCard, data = gameData})
end

-- Search functionality
searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local query = searchBar.Text:lower()
    for _, entry in ipairs(gameCards) do
        if query == "" then
            entry.card.Visible = true
        else
            local nameMatch = entry.data.name:lower():find(query, 1, true)
            local descMatch = entry.data.desc:lower():find(query, 1, true)
            entry.card.Visible = (nameMatch ~= nil or descMatch ~= nil)
        end
    end
end)

-- ESP Color Picker
local espColorCard = createCard(contentFrames.ESP, 2)
espColorCard.Size = UDim2.new(1, 0, 0, 60)

local espColorLabel = Instance.new("TextLabel")
espColorLabel.Parent = espColorCard
espColorLabel.BackgroundTransparency = 1
espColorLabel.Size = UDim2.new(0.6, 0, 0, 20)
espColorLabel.Font = Enum.Font.GothamMedium
espColorLabel.Text = "ESP Highlight Color"
espColorLabel.TextColor3 = theme.text
espColorLabel.TextSize = 14
espColorLabel.TextXAlignment = Enum.TextXAlignment.Left
espColorLabel.ZIndex = 3

local function createColorButton(parent, pos, currentColor, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = currentColor
    btn.Position = pos
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Text = ""
    btn.ZIndex = 3
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.border
    stroke.Thickness = 2
    stroke.Parent = btn
    
    local colors = {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255)
    }
    
    local colorIndex = 1
    btn.MouseButton1Click:Connect(function()
        colorIndex = (colorIndex % #colors) + 1
        btn.BackgroundColor3 = colors[colorIndex]
        if callback then callback(colors[colorIndex]) end
    end)
    
    return btn
end

createColorButton(espColorCard, UDim2.new(1, -40, 0.5, -15), espSettings.HighlightColor, function(color)
    espSettings.HighlightColor = color
end)

createToggle(contentFrames.ESP, "Skeleton ESP", "Show skeleton", function(state) 
    espSettings.Skeleton = state
end, 3)

-- Skeleton Color
local skelColorCard = createCard(contentFrames.ESP, 4)
skelColorCard.Size = UDim2.new(1, 0, 0, 60)

local skelColorLabel = Instance.new("TextLabel")
skelColorLabel.Parent = skelColorCard
skelColorLabel.BackgroundTransparency = 1
skelColorLabel.Size = UDim2.new(0.6, 0, 0, 20)
skelColorLabel.Font = Enum.Font.GothamMedium
skelColorLabel.Text = "Skeleton Color"
skelColorLabel.TextColor3 = theme.text
skelColorLabel.TextSize = 14
skelColorLabel.TextXAlignment = Enum.TextXAlignment.Left
skelColorLabel.ZIndex = 3

createColorButton(skelColorCard, UDim2.new(1, -40, 0.5, -15), espSettings.SkeletonColor, function(color)
    espSettings.SkeletonColor = color
end)

-- Tracers tab
local tracerNote = Instance.new("TextLabel")
tracerNote.Parent = contentFrames.Tracers
tracerNote.BackgroundTransparency = 1
tracerNote.Size = UDim2.new(1, 0, 0, 40)
tracerNote.Font = Enum.Font.GothamMedium
tracerNote.Text = "Note: Turn on ESP first to use Tracers"
tracerNote.TextColor3 = theme.warning
tracerNote.TextSize = 12
tracerNote.TextXAlignment = Enum.TextXAlignment.Left
tracerNote.TextWrapped = true
tracerNote.LayoutOrder = 0
tracerNote.ZIndex = 3

createToggle(contentFrames.Tracers, "Tracers", "Draw lines to players", function(state) 
    espSettings.Tracers = state
    if not state then
        for _, line in pairs(espSettings.TracerLines) do
            if line then line.Visible = false end
        end
    end
end, 1)

createSlider(contentFrames.Tracers, "Tracer Thickness", "Line thickness", 1, 5, espSettings.TracerThickness,
    function(val) espSettings.TracerThickness = val end, 2)

-- Tracer Color
local tracerColorCard = createCard(contentFrames.Tracers, 3)
tracerColorCard.Size = UDim2.new(1, 0, 0, 60)

local tracerColorLabel = Instance.new("TextLabel")
tracerColorLabel.Parent = tracerColorCard
tracerColorLabel.BackgroundTransparency = 1
tracerColorLabel.Size = UDim2.new(0.6, 0, 0, 20)
tracerColorLabel.Font = Enum.Font.GothamMedium
tracerColorLabel.Text = "Tracer Color"
tracerColorLabel.TextColor3 = theme.text
tracerColorLabel.TextSize = 14
tracerColorLabel.TextXAlignment = Enum.TextXAlignment.Left
tracerColorLabel.ZIndex = 3

createColorButton(tracerColorCard, UDim2.new(1, -40, 0.5, -15), espSettings.TracerColor, function(color)
    espSettings.TracerColor = color
end)

-- utility tab
createButton(contentFrames.Utility, "Rejoin", function()
    Services.TeleportService:Teleport(game.PlaceId, player)
end, 1)
createButton(contentFrames.Utility, "Server Hop(Smallest)", function()
    local success, response = pcall(function()
        return Services.HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)))
    end)
    if success and response.data then
        table.sort(response.data, function(a, b) return a.playing < b.playing end)
        for _, srv in pairs(response.data) do
            if srv.id ~= game.JobId then
                Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, player)
                return
            end
        end
    end
end, 2)
createButton(contentFrames.Utility, "Anti-AFK", function()
    for _, v in pairs(getconnections(player.Idled)) do v:Disable() end
    notify("Anti-AFK", "Enabled", 3)
end, 3)
createButton(contentFrames.Utility, "Unlock FPS", function()
    if setfpscap then setfpscap(999) notify("FPS", "Unlocked", 3) end
end, 4)

-- tab switching with SLIDE ANIMATION
-- tab switching with SLIDE ANIMATION
local switchingTab = false  -- Add this flag at the top

local function switchTab(tabName)
    if config.currentTab == tabName or switchingTab then return end  -- Check if already switching
    
    switchingTab = true  -- Lock tab switching
    
    -- Update button states
    for name, data in pairs(tabButtons) do
        local indicator = data.button:FindFirstChild("Indicator")
        if name == tabName then
            tween(data.button, 0.2, {BackgroundTransparency = 0.1}):Play()
            if data.textLabel then tween(data.textLabel, 0.2, {TextColor3 = theme.text}):Play() end
            if data.icon then tween(data.icon, 0.2, {ImageColor3 = iconTheme.activeColor}):Play() end
            if indicator then tween(indicator, 0.2, {Size = UDim2.new(0, 3, 1, 0)}):Play() end
        else
            tween(data.button, 0.2, {BackgroundTransparency = 0.4}):Play()
            if data.textLabel then tween(data.textLabel, 0.2, {TextColor3 = theme.textDim}):Play() end
            if data.icon then tween(data.icon, 0.2, {ImageColor3 = iconTheme.color}):Play() end
            if indicator then tween(indicator, 0.2, {Size = UDim2.new(0, 0, 1, 0)}):Play() end
        end
    end
    
    local currentFrame = contentFrames[config.currentTab]
    local newFrame = contentFrames[tabName]
    
    if currentFrame and newFrame then
        -- Slide out current frame (down, but stays within bounds)
        tween(currentFrame, 0.25, {Position = UDim2.new(0, 0, 1, 0)}):Play()
        
        -- Prepare new frame at top (within bounds)
        newFrame.Position = UDim2.new(0, 0, -1, 0)
        newFrame.Visible = true
        
        -- Slide in new frame (from top to center)
        task.wait(0.1)
        tween(newFrame, 0.3, {Position = UDim2.new(0, 0, 0, 0)}):Play()
        
        task.wait(0.3)
        currentFrame.Visible = false
        
        config.currentTab = tabName
    end
    
    switchingTab = false  -- Unlock tab switching
end

for name, data in pairs(tabButtons) do
    data.button.MouseButton1Click:Connect(function() switchTab(name) end)
end

switchTab("Main")

-- control buttons FIXED
gui.minimizeBtn.MouseButton1Click:Connect(function()
    config.isMinimized = not config.isMinimized
    if config.isMinimized then
        tween(gui.main, 0.3, {Size = UDim2.new(0, math.min(800, Services.Workspace.CurrentCamera.ViewportSize.X * 0.9), 0, 50)}):Play()
        tween(gui.sidebar, 0.3, {Size = UDim2.new(0, 200, 0, 0)}):Play()
        tween(gui.content, 0.3, {Size = UDim2.new(1, -200, 0, 0)}):Play()
        gui.sidebar.Visible = false  
        gui.content.Visible = false  
    else
        gui.sidebar.Visible = true  
        gui.content.Visible = true
        tween(gui.main, 0.3, {Size = UDim2.new(0, math.min(800, Services.Workspace.CurrentCamera.ViewportSize.X * 0.9), 0, math.min(500, Services.Workspace.CurrentCamera.ViewportSize.Y * 0.8))}):Play()
        tween(gui.sidebar, 0.3, {Size = UDim2.new(0, 200, 1, -50)}):Play()
        tween(gui.content, 0.3, {Size = UDim2.new(1, -200, 1, -50)}):Play()
    end
end)

gui.closeBtn.MouseButton1Click:Connect(function()
    tween(gui.main, 0.3, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    for _, icon in ipairs(drawnIcons) do icon:Destroy() end
    gui.screen:Destroy()
    _G.s0ulzV5Loaded = nil
end)

-- input handling
Services.RunService.RenderStepped:Connect(function(dt)
    if not states.flight or not connections.flyBodyVelocity then return end
    if not inputFlags.forward then config.forwardHold = 0 end

    local dir = Vector3.zero
    local camCF = Services.Workspace.CurrentCamera.CFrame

    if inputFlags.forward then dir = dir + camCF.LookVector end
    if inputFlags.back then dir = dir - camCF.LookVector end
    if inputFlags.left then dir = dir - camCF.RightVector end
    if inputFlags.right then dir = dir + camCF.RightVector end
    if inputFlags.up then dir = dir + Vector3.new(0,1,0) end
    if inputFlags.down then dir = dir + Vector3.new(0,-1,0) end

    if dir.Magnitude > 0 then dir = dir.Unit end
    connections.flyBodyVelocity.Velocity = dir * config.flightSpeed
    if connections.flyBodyGyro then connections.flyBodyGyro.CFrame = camCF end
end)

Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then inputFlags.forward = true
    elseif key == Enum.KeyCode.S then inputFlags.back = true
    elseif key == Enum.KeyCode.A then inputFlags.left = true
    elseif key == Enum.KeyCode.D then inputFlags.right = true
    elseif key == Enum.KeyCode.E then inputFlags.up = true
    elseif key == Enum.KeyCode.Q then inputFlags.down = true
    elseif key == Enum.KeyCode.F then 
        toggleFlightState()
    elseif key == Enum.KeyCode.F4 then 
        -- SMOOTH F4 TOGGLE with fade and scale
        config.isHidden = not config.isHidden
        if config.isHidden then
            -- Hide GUI with smooth fade and scale down
            local targetSize = UDim2.new(0, gui.main.Size.X.Offset * 0.8, 0, gui.main.Size.Y.Offset * 0.8)
            tween(gui.main, 0.25, {Size = targetSize, BackgroundTransparency = 0.5}):Play()
            tween(glassOverlay, 0.25, {BackgroundTransparency = 1}):Play()
            tween(mainStroke, 0.25, {Transparency = 1}):Play()
            
            -- Fade out all visible elements
            for _, child in ipairs(gui.main:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    tween(child, 0.25, {TextTransparency = 1}):Play()
                end
                if child:IsA("ImageLabel") then
                    tween(child, 0.25, {ImageTransparency = 1}):Play()
                end
                if child:IsA("Frame") and child.BackgroundTransparency < 1 then
                    local originalTrans = child.BackgroundTransparency
                    child:SetAttribute("OriginalTransparency", originalTrans)
                    tween(child, 0.25, {BackgroundTransparency = 1}):Play()
                end
                if child:IsA("UIStroke") then
                    tween(child, 0.25, {Transparency = 1}):Play()
                end
            end
            
            task.wait(0.25)
            tween(gui.main, 0.2, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
            task.wait(0.2)
            gui.main.Visible = false
        else
            -- Show GUI with smooth fade and scale up
            gui.main.Visible = true
            gui.main.Size = UDim2.new(0, 0, 0, 0)
            gui.main.BackgroundTransparency = 1
            glassOverlay.BackgroundTransparency = 1
            mainStroke.Transparency = 1
            
            local targetHeight = config.isMinimized and 50 or math.min(500, Services.Workspace.CurrentCamera.ViewportSize.Y * 0.8)
            local targetWidth = math.min(800, Services.Workspace.CurrentCamera.ViewportSize.X * 0.9)
            
            tween(gui.main, 0.3, {Size = UDim2.new(0, targetWidth, 0, targetHeight), BackgroundTransparency = 0.15}):Play()
            tween(glassOverlay, 0.3, {BackgroundTransparency = 0.95}):Play()
            tween(mainStroke, 0.3, {Transparency = 0.5}):Play()
            
            -- Fade in all elements
            task.wait(0.1)
            for _, child in ipairs(gui.main:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    child.TextTransparency = 1
                    tween(child, 0.3, {TextTransparency = 0}):Play()
                end
                if child:IsA("ImageLabel") then
                    child.ImageTransparency = 1
                    tween(child, 0.3, {ImageTransparency = 0}):Play()
                end
                if child:IsA("Frame") then
                    local originalTrans = child:GetAttribute("OriginalTransparency")
                    if originalTrans then
                        child.BackgroundTransparency = 1
                        tween(child, 0.3, {BackgroundTransparency = originalTrans}):Play()
                    end
                end
                if child:IsA("UIStroke") then
                    tween(child, 0.3, {Transparency = 0.5}):Play()
                end
            end
        end
    end
end)

Services.UserInputService.InputEnded:Connect(function(input)
    local key = input.KeyCode
    if key == Enum.KeyCode.W then inputFlags.forward = false
    elseif key == Enum.KeyCode.S then inputFlags.back = false
    elseif key == Enum.KeyCode.A then inputFlags.left = false
    elseif key == Enum.KeyCode.D then inputFlags.right = false
    elseif key == Enum.KeyCode.E then inputFlags.up = false
    elseif key == Enum.KeyCode.Q then inputFlags.down = false
    end
end)

-- character respawn
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    applyCharacterSettings()
    task.wait(1)
    if states.flight then enableFlight() end
    if states.noclip then enableNoclip() end
    if states.invincible then enableInvincibility() end
    if HitboxExpander.Enabled then enableHitbox() end
    if espSettings.Enabled then setupESP() end
end)

-- core loops
Services.RunService.RenderStepped:Connect(function()
    if espSettings.Enabled then updatePlayerESP() end
end)

-- ESP persistence and player check loop
task.spawn(function()
    while task.wait(2) do
        if espSettings.Enabled then
            for _, otherPlayer in ipairs(Services.Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    if not espSettings.Players[otherPlayer] then
                        createPlayerESP(otherPlayer)
                    else
                        local highlight = espSettings.Highlights[otherPlayer]
                        local billboard = espSettings.Billboards[otherPlayer]
                        if not highlight or not highlight.Parent or not billboard or not billboard.Parent then
                            removePlayerESP(otherPlayer)
                            createPlayerESP(otherPlayer)
                        end
                    end
                end
            end
            
            for trackedPlayer, _ in pairs(espSettings.Players) do
                if not trackedPlayer or not trackedPlayer.Parent then
                    removePlayerESP(trackedPlayer)
                end
            end
        end
    end
end)

-- cleanup
gui.screen.Destroying:Connect(function()
    for _, connection in pairs(connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        elseif typeof(connection) == "thread" then
            task.cancel(connection)
        end
    end
    for _, icon in ipairs(drawnIcons) do icon:Destroy() end
    if states.flight then disableFlight() end
    if states.noclip then disableNoclip() end
    clearAllESP()
    if states.invincible then disableInvincibility() end
    if HitboxExpander.Enabled then disableHitbox() end
    if aimbotSettings.Connection then aimbotSettings.Connection:Disconnect() end
    Services.Workspace.FallenPartsDestroyHeight = scriptEnv.FPDH
    _G.s0ulzV5Loaded = nil
end)

-- apply themes function yea...

local function applyTheme(themeName)
    if not themes[themeName] then return end
    theme = themes[themeName]
    config.currentTheme = themeName
    
    -- Update all GUI elements
    gui.main.BackgroundColor3 = theme.glass
    glassOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainStroke.Color = theme.border
    
    gui.topBar.BackgroundColor3 = theme.surface
    topBarMask.BackgroundColor3 = theme.surface
    
    gui.sidebar.BackgroundColor3 = theme.surface
    
    titleText.TextColor3 = theme.text
    authorText.TextColor3 = theme.textDim
    
    -- Update all cards, buttons, and UI elements
    for _, frame in pairs(contentFrames) do
        for _, child in ipairs(frame:GetDescendants()) do
            if child:IsA("Frame") then
                if child.Name:find("Card") then
                    child.BackgroundColor3 = theme.surface
                -- Update toggle fills and slider fills
                elseif child.Parent and child.Parent.Name == "Track" then
                    child.BackgroundColor3 = theme.accent  -- Slider fill
                elseif child.Parent and child.Parent.Parent and child.Parent.Parent:IsA("Frame") then
                    -- Check if it's a toggle that's active
                    if child.Parent.BackgroundTransparency < 0.15 then
                        child.Parent.BackgroundColor3 = theme.accent
                    end
                end
            elseif child:IsA("TextLabel") then
                if child.Font == Enum.Font.GothamBold or child.Font == Enum.Font.GothamMedium then
                    child.TextColor3 = theme.text
                else
                    child.TextColor3 = theme.textDim
                end
            elseif child:IsA("TextButton") then
                child.BackgroundColor3 = theme.surface
                child.TextColor3 = theme.text
            elseif child:IsA("TextBox") then
                child.BackgroundColor3 = theme.surface
                child.TextColor3 = theme.text
                child.PlaceholderColor3 = theme.textDim
            elseif child:IsA("UIStroke") then
                child.Color = theme.border
            end
        end
    end
    
    -- Update nav buttons
    for _, data in pairs(tabButtons) do
        data.button.BackgroundColor3 = theme.surface
        if data.textLabel then
            data.textLabel.TextColor3 = (data.button == tabButtons[config.currentTab].button) and theme.text or theme.textDim
        end
        if data.icon then
            data.icon.ImageColor3 = (data.button == tabButtons[config.currentTab].button) and theme.accent or iconTheme.color
        end
    end
    
    -- Update iconTheme colors
    iconTheme.activeColor = theme.accent
    
    notify("Theme", "Applied " .. themeName .. " theme", 3)
end

--themes had to add at become because of fucking nil

-- Theme selector
-- Theme selector
local themeCard = createCard(contentFrames.Utility, 5)
themeCard.Size = UDim2.new(1, 0, 0, 90)  -- Increased height

local themeLabel = Instance.new("TextLabel")
themeLabel.Parent = themeCard
themeLabel.BackgroundTransparency = 1
themeLabel.Size = UDim2.new(1, 0, 0, 20)
themeLabel.Font = Enum.Font.GothamMedium
themeLabel.Text = "Theme"
themeLabel.TextColor3 = theme.text
themeLabel.TextSize = 14
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.ZIndex = 3

local themeButtons = Instance.new("Frame")
themeButtons.Parent = themeCard
themeButtons.BackgroundTransparency = 1
themeButtons.Position = UDim2.new(0, 0, 0, 30)
themeButtons.Size = UDim2.new(1, 0, 1, -30)
themeButtons.ZIndex = 3

local themeLayout = Instance.new("UIListLayout")
themeLayout.Parent = themeButtons
themeLayout.FillDirection = Enum.FillDirection.Horizontal
themeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
themeLayout.SortOrder = Enum.SortOrder.LayoutOrder
themeLayout.Padding = UDim.new(0, 8)

for i, themeName in ipairs({"Dark", "Blue", "Indigo", "Orange", "Slate"}) do
    local btn = Instance.new("TextButton")
    btn.Parent = themeButtons
    btn.BackgroundColor3 = themes[themeName].accent
    btn.BackgroundTransparency = 0.3
    btn.Size = UDim2.new(0, 90, 0, 32)  -- Fixed size
    btn.Font = Enum.Font.GothamBold
    btn.Text = themeName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.ZIndex = 4
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, {BackgroundTransparency = 0.1}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, {BackgroundTransparency = 0.3}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        applyTheme(themeName)
    end)
end

-- init
applyCharacterSettings()
gui.main.Size = UDim2.new(0, 0, 0, 0)
tween(gui.main, 0.5, {Size = UDim2.new(0, math.min(800, Services.Workspace.CurrentCamera.ViewportSize.X * 0.9), 0, math.min(500, Services.Workspace.CurrentCamera.ViewportSize.Y * 0.8))}):Play()

task.wait(0.8)
notify("s0ulz V5", "Loaded successfully!", 5)
task.wait(0.4)
notify("Controls", "F4 = Toggle GUI | F = Fly", 4)

print("--================================--")
print("     Made With Love <3 - s0ulz")
print("--================================--")
