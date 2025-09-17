local Services = {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    Lighting = game:GetService("Lighting"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    VoiceChatService = game:GetService("VoiceChatService"),
    TeleportService = game:GetService("TeleportService"),
    HttpService = game:GetService("HttpService"),
    StarterGui = game:GetService("StarterGui"),
    Workspace = game:GetService("Workspace")
}

local player = Services.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- Mobile detection
local isMobile = Services.UserInputService.TouchEnabled and not Services.UserInputService.KeyboardEnabled

local config = {
    currentSpeed = 16,
    currentJump = 50,
    flightSpeed = 50,
    forwardHold = 0,
    flightTracks = {},
    baseWidth = isMobile and 320 or 400, -- Smaller width for mobile
    baseHeight = isMobile and 420 or 380, -- Adjusted height for mobile
    animSpeed = 0.2,
    hoverSpeed = 0.1,
    isMinimized = false,
    isAnimating = false,
    currentTab = "Main",
    guiScale = 1,
    titleBarHeight = isMobile and 45 or 40, -- Taller for easier touch
    tabBarHeight = isMobile and 40 or 36, -- Taller tabs for mobile
    contentPadding = isMobile and 8 or 12,
    isMobile = isMobile
}

local function calculateScale()
    local viewport = Services.Workspace.CurrentCamera.ViewportSize
    local baseRes = Vector2.new(1366, 768)
    if isMobile then
        -- Use screen width as primary scaling factor for mobile
        local scale = math.min(viewport.X / 375, viewport.Y / 667) -- iPhone standard
        return math.clamp(scale, 0.8, 1.2)
    else
        local scale = math.min(viewport.X / baseRes.X, viewport.Y / baseRes.Y)
        return math.clamp(scale, 0.7, 1.1)
    end
end

config.guiScale = calculateScale()

local tabHeights = {
    Main = isMobile and 380 or 340,
    Teleport = isMobile and 200 or 180,
    Troll = isMobile and 380 or 350,
    Scripts = isMobile and 540 or 500,
    Games = isMobile and 330 or 300,
    PVP = isMobile and 460 or 420,
    Utility = isMobile and 310 or 280
}

local gameDatabase = {
    [286090429] = {
        name = "Arsenal",
        url = "https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Games/Arsenal/Arsenal(s0ulz).lua"
    },
    [7326934954] = {
        name = "99 Nights in the Forest",
        url = "https://pastefy.app/RXzul28o/raw"
    },
    [4777817887] = {
        name = "Blade Ball", 
        url = "http://lumin-hub.lol/Blade.lua"
    },
    [4348829796] = {
        name = "MVSD",
        url = "https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Games/MVSD/EZ.lua"
    },
    [4931927012] = {
        name = "Basketball Legends",
        url = "https://raw.githubusercontent.com/vnausea/absence-mini/refs/heads/main/absencemini.lua"
    },
    [66654135] = {
        name = "MM2",
        url = "https://raw.githubusercontent.com/vertex-peak/vertex/refs/heads/main/loadstring"
    },
    [3508322461] = {
        name = "Jujitsu Shenanigans",
        url = "https://raw.githubusercontent.com/NotEnoughJack/localplayerscripts/refs/heads/main/script"
    },
    [372226183] = {
        name = "FTF",
        url = "https://raw.githubusercontent.com/PabloOP-87/pedorga/refs/heads/main/Flee-Da-Facility"
    },
    [3808081382] = {
        name = "TSB",
        url = "https://raw.githubusercontent.com/ATrainz/Phantasm/refs/heads/main/Games/TSB.lua"
    },
    [5203828273] = {
        name = "DTI",
        url = "https://raw.githubusercontent.com/hellohellohell012321/DTI-GUI-V2/main/dti_gui_v2.lua"
    },
    [6931042565] = {
        name = "Volleyball Legends",
        url = "https://raw.githubusercontent.com/scriptshubzeck/Zeckhubv1/refs/heads/main/zeckhub"
    },
    [7436755782] = {
        name = "Grow A Garden",
        url = "https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/GaG/Main.lua"
    },
    [6035872082] = {
        name = "RIVALS",
        url = "https://soluna-script.vercel.app/main.lua"
    }
}

local theme = {
    bg = Color3.fromRGB(18, 18, 24),
    surface = Color3.fromRGB(28, 28, 36),
    surfaceLight = Color3.fromRGB(38, 38, 48),
    primary = Color3.fromRGB(88, 166, 255),
    secondary = Color3.fromRGB(44, 44, 56),
    accent = Color3.fromRGB(255, 105, 125),
    text = Color3.fromRGB(248, 248, 250),
    textSecondary = Color3.fromRGB(165, 165, 185),
    textTertiary = Color3.fromRGB(115, 115, 135),
    success = Color3.fromRGB(48, 205, 145),
    error = Color3.fromRGB(240, 105, 105),
    warning = Color3.fromRGB(245, 185, 30),
    inactive = Color3.fromRGB(70, 80, 94),
    border = Color3.fromRGB(55, 55, 67),
    shadow = Color3.fromRGB(8, 8, 12)
}

local fonts = {
    primary = Enum.Font.GothamMedium,
    secondary = Enum.Font.Gotham,
    bold = Enum.Font.GothamBold,
    mono = Enum.Font.RobotoMono
}

local states = {
    flight = false,
    infiniteTeleport = false,
    noclip = false,
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

local connections = {}

local trollSettings = {
    chatText = "Hello World!",
    chatDelay = 1,
    followTarget = nil,
    fakeLagWaitTime = 0.05,
    fakeLagDelayTime = 0.4
}

-- ESP and Aimbot settings
local espSettings = {
    Enabled = false,
    Tracers = false,
    Players = {},
    Highlights = {},
    Billboards = {},
    TracerLines = {},
    TeamCheck = true,
    MaxDistance = 500,
    HighlightColor = Color3.fromRGB(255, 255, 255)
}

local aimbotSettings = {
    Enabled = false,
    Smoothing = 0.15,
    TargetPart = "Head",
    TeamCheck = true,
    VisibleCheck = true,
    LockMode = true,
    Connection = nil,
    currentTarget = nil
}

local triggerbotSettings = {
    Enabled = false,
    delay = 0.1,
    range = 300,
    running = false
}

local hitboxSettings = { originalSizes = {}, expansionAmount = 1.5 }
local inputFlags = { forward = false, back = false, left = false, right = false, up = false, down = false }
local scriptEnv = { FPDH = Services.Workspace.FallenPartsDestroyHeight, OldPos = nil }

-- Mobile Flight Controls (Touch-based directional pad)
local mobileControls = {}

-- Get greeting based on time of day
local function getTimeBasedGreeting()
    local hour = tonumber(os.date("%H"))
    if hour >= 5 and hour < 12 then
        return "Good Morning bruv"
    elseif hour >= 12 and hour < 18 then
        return "Good Afternoon bruv"
    elseif hour >= 18 and hour < 22 then
        return "Good Evening bruv"
    else
        return "Good Night bruv"
    end
end

local function notify(title, text, duration, iconType)
    pcall(function()
        local icon = iconType == "error" and "rbxasset://textures/ui/ErrorIcon.png" or 
                    iconType == "success" and "rbxasset://textures/ui/success_icon.png" or nil
        Services.StarterGui:SetCore("SendNotification", {
            Title = title or "s0ulz Mobile",
            Text = text or "",
            Duration = duration or 4,
            Icon = icon
        })
    end)
end

local function findPlayer(str)
    local found = {}
    str = str:lower():gsub("%s+", "")
    
    if str == "all" then
        return Services.Players:GetPlayers()
    elseif str == "others" then
        for _, v in pairs(Services.Players:GetPlayers()) do
            if v ~= player then table.insert(found, v) end
        end
    elseif str == "me" then
        return {player}
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

local function createTween(obj, time, props, style, direction)
    return Services.TweenService:Create(
        obj,
        TweenInfo.new(
            time or config.animSpeed,
            style or Enum.EasingStyle.Quint,
            direction or Enum.EasingDirection.Out
        ),
        props
    )
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

-- GUI Creation
local gui = {}

gui.screen = Instance.new("ScreenGui")
gui.screen.Name = "s0ulzMobileGUI_V4"
gui.screen.Parent = playerGui
gui.screen.ResetOnSpawn = false
gui.screen.Enabled = false
gui.screen.IgnoreGuiInset = true
gui.screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main container with mobile positioning
gui.main = Instance.new("Frame")
gui.main.Name = "MainContainer"
gui.main.Parent = gui.screen
gui.main.BackgroundColor3 = theme.bg
gui.main.BorderSizePixel = 0
gui.main.AnchorPoint = Vector2.new(0.5, 0)
-- Position at top center for mobile
gui.main.Position = isMobile and UDim2.new(0.5, 0, 0, 20) or UDim2.new(0.5, 0, 0.5, 0)
gui.main.Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, config.baseHeight * config.guiScale)
gui.main.Active = true
gui.main.Draggable = not isMobile -- Disable dragging on mobile to prevent conflicts
gui.main.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, isMobile and 16 or 14)
mainCorner.Parent = gui.main

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Parent = gui.main
shadow.BackgroundColor3 = theme.shadow
shadow.BackgroundTransparency = 0.6
shadow.Size = UDim2.new(1, 16, 1, 16)
shadow.Position = UDim2.new(0, -8, 0, -8)
shadow.ZIndex = -1

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 18)
shadowCorner.Parent = shadow

gui.titleBar = Instance.new("Frame")
gui.titleBar.Name = "TitleBar"
gui.titleBar.Parent = gui.main
gui.titleBar.BackgroundColor3 = theme.surface
gui.titleBar.BorderSizePixel = 0
gui.titleBar.Size = UDim2.new(1, 0, 0, config.titleBarHeight)
gui.titleBar.ZIndex = 2

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, isMobile and 16 or 14)
titleCorner.Parent = gui.titleBar

local titleMask = Instance.new("Frame")
titleMask.Parent = gui.titleBar
titleMask.BackgroundColor3 = theme.surface
titleMask.BorderSizePixel = 0
titleMask.Size = UDim2.new(1, 0, 0.5, 0)
titleMask.Position = UDim2.new(0, 0, 0.5, 0)
titleMask.ZIndex = 1

gui.title = Instance.new("TextLabel")
gui.title.Parent = gui.titleBar
gui.title.BackgroundTransparency = 1
gui.title.Position = UDim2.new(0, 16, 0, 0)
gui.title.Size = UDim2.new(1, -100, 0.6, 0)
gui.title.Font = fonts.bold
gui.title.Text = "s0ulz V4 Mobile"
gui.title.TextColor3 = theme.text
gui.title.TextSize = math.floor((isMobile and 18 or 16) * config.guiScale)
gui.title.TextXAlignment = Enum.TextXAlignment.Left
gui.title.TextYAlignment = Enum.TextYAlignment.Center
gui.title.ZIndex = 3

local versionLabel = Instance.new("TextLabel")
versionLabel.Parent = gui.titleBar
versionLabel.BackgroundTransparency = 1
versionLabel.Position = UDim2.new(0, 16, 0.6, 0)
versionLabel.Size = UDim2.new(0.5, 0, 0.4, 0)
versionLabel.Font = fonts.secondary
versionLabel.Text = "Touch-friendly edition"
versionLabel.TextColor3 = theme.textSecondary
versionLabel.TextSize = math.floor((isMobile and 10 : 9) * config.guiScale)
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.TextYAlignment = Enum.TextYAlignment.Center
versionLabel.ZIndex = 3

-- Create mobile-friendly control buttons (larger touch targets)
local function createControlButton(text, pos, color, hoverColor)
    local btn = Instance.new("TextButton")
    btn.Parent = gui.titleBar
    btn.BackgroundColor3 = color or theme.secondary
    btn.Position = pos
    btn.Size = UDim2.new(0, isMobile and 35 or 28, 0, isMobile and 35 or 28)
    btn.Font = fonts.primary
    btn.Text = text
    btn.TextColor3 = theme.text
    btn.TextSize = math.floor((isMobile and 14 or 12) * config.guiScale)
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, isMobile and 8 or 6)
    corner.Parent = btn
    
    local originalColor = btn.BackgroundColor3
    
    -- Touch-friendly hover effects
    local function onPress()
        createTween(btn, 0.1, {
            BackgroundColor3 = hoverColor or theme.primary,
            Size = UDim2.new(0, (isMobile and 35 or 28) + 2, 0, (isMobile and 35 or 28) + 2)
        }):Play()
    end
    
    local function onRelease()
        createTween(btn, 0.1, {
            BackgroundColor3 = originalColor,
            Size = UDim2.new(0, isMobile and 35 or 28, 0, isMobile and 35 or 28)
        }):Play()
    end
    
    if isMobile then
        btn.TouchTap:Connect(function() end) -- Enable touch
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                onPress()
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                onRelease()
            end
        end)
    else
        btn.MouseEnter:Connect(onPress)
        btn.MouseLeave:Connect(onRelease)
    end
    
    return btn
end

gui.minimizeBtn = createControlButton("-", 
    UDim2.new(1, isMobile and -72 or -64, 0.5, isMobile and -17.5 or -14), 
    theme.secondary, theme.warning)
gui.closeBtn = createControlButton("X", 
    UDim2.new(1, isMobile and -36 or -32, 0.5, isMobile and -17.5 or -14), 
    theme.secondary, theme.error)

-- Create mobile flight controls overlay
if isMobile then
    mobileControls.overlay = Instance.new("Frame")
    mobileControls.overlay.Name = "MobileControls"
    mobileControls.overlay.Parent = gui.screen
    mobileControls.overlay.BackgroundTransparency = 1
    mobileControls.overlay.Size = UDim2.new(1, 0, 1, 0)
    mobileControls.overlay.Visible = false
    mobileControls.overlay.ZIndex = 10
    
    -- Flight control pad (bottom left)
    mobileControls.flightPad = Instance.new("Frame")
    mobileControls.flightPad.Name = "FlightPad"
    mobileControls.flightPad.Parent = mobileControls.overlay
    mobileControls.flightPad.BackgroundColor3 = theme.surface
    mobileControls.flightPad.BackgroundTransparency = 0.3
    mobileControls.flightPad.Position = UDim2.new(0, 20, 1, -160)
    mobileControls.flightPad.Size = UDim2.new(0, 120, 0, 120)
    
    local padCorner = Instance.new("UICorner")
    padCorner.CornerRadius = UDim.new(0, 12)
    padCorner.Parent = mobileControls.flightPad
    
    -- Directional buttons
    local directions = {
        {name = "forward", pos = UDim2.new(0.5, -15, 0, 10), text = "▲"},
        {name = "back", pos = UDim2.new(0.5, -15, 1, -40), text = "▼"},
        {name = "left", pos = UDim2.new(0, 10, 0.5, -15), text = "◄"},
        {name = "right", pos = UDim2.new(1, -40, 0.5, -15), text = "►"}
    }
    
    for _, dir in ipairs(directions) do
        local btn = Instance.new("TextButton")
        btn.Name = dir.name .. "Btn"
        btn.Parent = mobileControls.flightPad
        btn.BackgroundColor3 = theme.secondary
        btn.Position = dir.pos
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.Font = fonts.bold
        btn.Text = dir.text
        btn.TextColor3 = theme.text
        btn.TextSize = 16
        btn.AutoButtonColor = false
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        -- Touch controls for flight
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                inputFlags[dir.name] = true
                createTween(btn, 0.1, {BackgroundColor3 = theme.primary}):Play()
            end
        end)
        
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                inputFlags[dir.name] = false
                createTween(btn, 0.1, {BackgroundColor3 = theme.secondary}):Play()
            end
        end)
        
        mobileControls[dir.name .. "Btn"] = btn
    end
    
    -- Up/Down buttons (bottom right)
    mobileControls.verticalPad = Instance.new("Frame")
    mobileControls.verticalPad.Name = "VerticalPad"
    mobileControls.verticalPad.Parent = mobileControls.overlay
    mobileControls.verticalPad.BackgroundColor3 = theme.surface
    mobileControls.verticalPad.BackgroundTransparency = 0.3
    mobileControls.verticalPad.Position = UDim2.new(1, -80, 1, -160)
    mobileControls.verticalPad.Size = UDim2.new(0, 60, 0, 120)
    
    local vertPadCorner = Instance.new("UICorner")
    vertPadCorner.CornerRadius = UDim.new(0, 12)
    vertPadCorner.Parent = mobileControls.verticalPad
    
    local vertButtons = {
        {name = "up", pos = UDim2.new(0.5, -15, 0, 10), text = "↑"},
        {name = "down", pos = UDim2.new(0.5, -15, 1, -40), text = "↓"}
    }
    
    for _, vert in ipairs(vertButtons) do
        local btn = Instance.new("TextButton")
        btn.Name = vert.name .. "Btn"
        btn.Parent = mobileControls.verticalPad
        btn.BackgroundColor3 = theme.secondary
        btn.Position = vert.pos
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.Font = fonts.bold
        btn.Text = vert.text
        btn.TextColor3 = theme.text
        btn.TextSize = 16
        btn.AutoButtonColor = false
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                inputFlags[vert.name] = true
                createTween(btn, 0.1, {BackgroundColor3 = theme.primary}):Play()
            end
        end)
        
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                inputFlags[vert.name] = false
                createTween(btn, 0.1, {BackgroundColor3 = theme.secondary}):Play()
            end
        end)
        
        mobileControls[vert.name .. "Btn"] = btn
    end
end

gui.tabContainer = Instance.new("Frame")
gui.tabContainer.Name = "TabContainer"
gui.tabContainer.Parent = gui.main
gui.tabContainer.BackgroundTransparency = 1
gui.tabContainer.Position = UDim2.new(0, 0, 0, config.titleBarHeight + 2)
gui.tabContainer.Size = UDim2.new(1, 0, 0, config.tabBarHeight)
gui.tabContainer.ZIndex = 2

local tabList = {"Main", "Teleport", "Troll", "Scripts", "Games", "PVP", "Utility"}
local tabButtons = {}

for i, tabName in ipairs(tabList) do
    local tab = Instance.new("TextButton")
    tab.Name = tabName .. "Tab"
    tab.Parent = gui.tabContainer
    tab.BackgroundColor3 = theme.secondary
    tab.Position = UDim2.new((i-1) / #tabList, 2, 0, 4)
    tab.Size = UDim2.new(1 / #tabList, -4, 1, -8)
    tab.Font = fonts.primary
    tab.Text = tabName
    tab.TextColor3 = theme.textSecondary
    tab.TextSize = math.floor((isMobile and 10 or 9) * config.guiScale)
    tab.AutoButtonColor = false
    tab.ZIndex = 3
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, isMobile and 8 or 6)
    corner.Parent = tab
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Parent = tab
    indicator.BackgroundColor3 = theme.primary
    indicator.Size = UDim2.new(0, 0, 0, 2)
    indicator.Position = UDim2.new(0.5, 0, 1, -2)
    indicator.AnchorPoint = Vector2.new(0.5, 0)
    indicator.ZIndex = 4
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    -- Touch-friendly tab interactions
    if isMobile then
        tab.TouchTap:Connect(function() end)
    else
        tab.MouseEnter:Connect(function()
            if config.currentTab ~= tabName then
                createTween(tab, config.hoverSpeed, {
                    BackgroundColor3 = theme.surfaceLight,
                    TextColor3 = theme.text
                }):Play()
            end
        end)
        
        tab.MouseLeave:Connect(function()
            if config.currentTab ~= tabName then
                createTween(tab, config.hoverSpeed, {
                    BackgroundColor3 = theme.secondary,
                    TextColor3 = theme.textSecondary
                }):Play()
            end
        end)
    end
    
    tabButtons[tabName] = tab
end

gui.content = Instance.new("Frame")
gui.content.Parent = gui.main
gui.content.BackgroundTransparency = 1
gui.content.Position = UDim2.new(0, config.contentPadding, 0, config.titleBarHeight + config.tabBarHeight + 6)
gui.content.Size = UDim2.new(1, -config.contentPadding * 2, 1, -(config.titleBarHeight + config.tabBarHeight + 12))
gui.content.ZIndex = 2

local contentFrames = {}

-- Enhanced slider with mobile-friendly touch
local function createSlider(parent, labelText, minVal, maxVal, currentVal, callback, layoutOrder)
    local container = Instance.new("Frame")
    container.Parent = parent
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, isMobile and 80 or 70)
    container.LayoutOrder = layoutOrder or 1
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.55, 0, 0, isMobile and 25 or 20)
    label.Font = fonts.primary
    label.Text = labelText
    label.TextColor3 = theme.text
    label.TextSize = math.floor((isMobile and 13 or 12) * config.guiScale)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    
    local valueInput = Instance.new("TextBox")
    valueInput.Parent = container
    valueInput.BackgroundColor3 = theme.surface
    valueInput.Position = UDim2.new(1, isMobile and -85 or -80, 0, 0)
    valueInput.Size = UDim2.new(0, isMobile and 80 or 75, 0, isMobile and 25 or 20)
    valueInput.Font = fonts.mono
    valueInput.Text = tostring(currentVal)
    valueInput.TextColor3 = theme.primary
    valueInput.TextSize = math.floor((isMobile and 12 or 11) * config.guiScale)
    valueInput.TextXAlignment = Enum.TextXAlignment.Center
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 5)
    inputCorner.Parent = valueInput
    
    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 4)
    inputPadding.PaddingRight = UDim.new(0, 4)
    inputPadding.Parent = valueInput
    
    local track = Instance.new("Frame")
    track.Parent = container
    track.BackgroundColor3 = theme.secondary
    track.Position = UDim2.new(0, 0, 0, isMobile and 45 or 35)
    track.Size = UDim2.new(1, 0, 0, isMobile and 12 or 8) -- Thicker track for mobile
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Parent = track
    fill.BackgroundColor3 = theme.primary
    fill.Size = UDim2.new((currentVal - minVal)/(maxVal - minVal), 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local thumb = Instance.new("Frame")
    thumb.Parent = track
    thumb.BackgroundColor3 = theme.text
    thumb.Size = UDim2.new(0, isMobile and 28 or 20, 0, isMobile and 28 or 20) -- Larger thumb for mobile
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new((currentVal - minVal)/(maxVal - minVal), 0, 0.5, 0)
    thumb.ZIndex = 5
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    
    local dragging = false
    local function updateSlider(value)
        value = math.clamp(value, minVal, maxVal)
        local percent = (value - minVal)/(maxVal - minVal)
        
        createTween(fill, 0.08, { Size = UDim2.new(percent, 0, 1, 0) }):Play()
        createTween(thumb, 0.08, { Position = UDim2.new(percent, 0, 0.5, 0) }):Play()
        
        valueInput.Text = tostring(math.round(value * 100) / 100)
        if callback then callback(value) end
    end
    
    -- Text input functionality
    valueInput.FocusLost:Connect(function(enterPressed)
        local newValue = tonumber(valueInput.Text)
        if newValue then
            updateSlider(newValue)
        else
            valueInput.Text = tostring(math.round(currentVal * 100) / 100)
        end
    end)
    
    -- Mobile-friendly touch dragging
    local function startDrag(inputObject)
        dragging = true
        gui.main.Active = false
        local thumbSize = isMobile and 32 or 24
        createTween(thumb, 0.12, { Size = UDim2.new(0, thumbSize, 0, thumbSize), BackgroundColor3 = theme.primary }):Play()
    end
    
    local function updateDrag(inputObject)
        if not dragging then return end
        
        local mousePos
        if inputObject.UserInputType == Enum.UserInputType.Touch then
            mousePos = inputObject.Position
        else
            mousePos = Services.UserInputService:GetMouseLocation()
        end
        
        local trackPos = track.AbsolutePosition
        local trackSize = track.AbsoluteSize
        local relativeX = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
        updateSlider(minVal + (maxVal - minVal) * relativeX)
    end
    
    local function endDrag()
        if not dragging then return end
        dragging = false
        gui.main.Active = true
        local thumbSize = isMobile and 28 or 20
        createTween(thumb, 0.12, { Size = UDim2.new(0, thumbSize, 0, thumbSize), BackgroundColor3 = theme.text }):Play()
    end
    
    -- Touch and mouse support
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateDrag(input)
        end
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            endDrag()
        end
    end)
    
    return updateSlider, container
end

-- Mobile-friendly button creation
local function createButton(parent, text, color, callback, layoutOrder, size)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = color or theme.secondary
    btn.Size = size or UDim2.new(1, 0, 0, isMobile and 36 or 30) -- Taller buttons for mobile
    btn.Font = fonts.primary
    btn.Text = text
    btn.TextColor3 = theme.text
    btn.TextSize = math.floor((isMobile and 13 or 12) * config.guiScale)
    btn.AutoButtonColor = false
    btn.LayoutOrder = layoutOrder or 1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, isMobile and 8 or 6)
    corner.Parent = btn
    
    local originalColor = btn.BackgroundColor3
    
    -- Touch-friendly interactions
    local function onPress()
        local hoverColor = Color3.new(
            math.min(originalColor.R * 1.12, 1),
            math.min(originalColor.G * 1.12, 1),
            math.min(originalColor.B * 1.12, 1)
        )
        createTween(btn, config.hoverSpeed, { BackgroundColor3 = hoverColor }):Play()
        local currentSize = size or UDim2.new(1, 0, 0, isMobile and 36 or 30)
        createTween(btn, 0.08, { Size = currentSize - UDim2.new(0, 1, 0, 1) }):Play()
    end
    
    local function onRelease()
        createTween(btn, config.hoverSpeed, { BackgroundColor3 = originalColor }):Play()
        createTween(btn, 0.08, { Size = size or UDim2.new(1, 0, 0, isMobile and 36 or 30) }):Play()
    end
    
    if isMobile then
        btn.TouchTap:Connect(function() end) -- Enable touch
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                onPress()
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                onRelease()
            end
        end)
    else
        btn.MouseEnter:Connect(onPress)
        btn.MouseLeave:Connect(onRelease)
        btn.MouseButton1Down:Connect(function()
            createTween(btn, 0.08, { Size = (size or UDim2.new(1, 0, 0, 30)) - UDim2.new(0, 1, 0, 1) }):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            createTween(btn, 0.08, { Size = size or UDim2.new(1, 0, 0, 30) }):Play()
        end)
    end
    
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    
    return btn
end

-- Mobile-friendly input creation
local function createInput(parent, placeholder, layoutOrder)
    local input = Instance.new("TextBox")
    input.Parent = parent
    input.BackgroundColor3 = theme.surface
    input.Size = UDim2.new(1, 0, 0, isMobile and 36 or 30) -- Taller for mobile
    input.Font = fonts.secondary
    input.PlaceholderText = placeholder
    input.PlaceholderColor3 = theme.textTertiary
    input.Text = ""
    input.TextColor3 = theme.text
    input.TextSize = math.floor((isMobile and 13 or 12) * config.guiScale)
    input.ClearTextOnFocus = false
    input.LayoutOrder = layoutOrder or 1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, isMobile and 8 or 6)
    corner.Parent = input
    
    local border = Instance.new("UIStroke")
    border.Color = theme.border
    border.Thickness = isMobile and 2 or 1
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.Parent = input
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, isMobile and 10 or 8)
    padding.PaddingRight = UDim.new(0, isMobile and 10 or 8)
    padding.Parent = input
    
    input.Focused:Connect(function()
        createTween(border, 0.15, { Color = theme.primary, Thickness = isMobile and 3 or 2 }):Play()
        createTween(input, 0.15, { BackgroundColor3 = theme.surfaceLight }):Play()
    end)
    
    input.FocusLost:Connect(function()
        createTween(border, 0.15, { Color = theme.border, Thickness = isMobile and 2 or 1 }):Play()
        createTween(input, 0.15, { BackgroundColor3 = theme.surface }):Play()
    end)
    
    return input
end

-- Create content frames
for _, tabName in ipairs(tabList) do
    local frame = Instance.new("ScrollingFrame")
    frame.Name = tabName .. "Content"
    frame.Parent = gui.content
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Visible = (tabName == "Main")
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.ScrollBarThickness = isMobile and 8 or 4 -- Thicker scrollbar for mobile
    frame.ScrollBarImageColor3 = theme.primary
    frame.ScrollBarImageTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.ScrollingDirection = Enum.ScrollingDirection.Y
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = frame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, isMobile and 8 or 6)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
    end)
    
    contentFrames[tabName] = frame
end

-- MAIN TAB CONTENT
local greetingLabel = Instance.new("TextLabel")
greetingLabel.Parent = contentFrames.Main
greetingLabel.BackgroundTransparency = 1
greetingLabel.Size = UDim2.new(1, 0, 0, isMobile and 35 or 30)
greetingLabel.Font = fonts.bold
greetingLabel.Text = getTimeBasedGreeting()
greetingLabel.TextColor3 = theme.primary
greetingLabel.TextSize = math.floor((isMobile and 16 or 14) * config.guiScale)
greetingLabel.TextXAlignment = Enum.TextXAlignment.Center
greetingLabel.LayoutOrder = 1

local infoLabel = Instance.new("TextLabel")
infoLabel.Parent = contentFrames.Main
infoLabel.BackgroundTransparency = 1
infoLabel.Size = UDim2.new(1, 0, 0, isMobile and 50 or 40)
infoLabel.Font = fonts.secondary
infoLabel.Text = "Mobile V4 | Touch-friendly controls\n" .. (isMobile and "Flight pad shows when flying" or "Desktop controls available")
infoLabel.TextColor3 = theme.textSecondary
infoLabel.TextSize = math.floor((isMobile and 11 or 10) * config.guiScale)
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.TextYAlignment = Enum.TextYAlignment.Center
infoLabel.TextWrapped = true
infoLabel.LayoutOrder = 2

local speedUpdate = createSlider(
    contentFrames.Main, "Walk Speed", 16, 1000, config.currentSpeed,
    function(val) config.currentSpeed = val; applyCharacterSettings() end, 3
)

local jumpUpdate = createSlider(
    contentFrames.Main, "Jump Power", 50, 500, config.currentJump,
    function(val) config.currentJump = val; applyCharacterSettings() end, 4
)

local flightUpdate = createSlider(
    contentFrames.Main, "Flight Speed", 10, 200, config.flightSpeed,
    function(val) config.flightSpeed = val end, 5
)

local mainElements = {}

mainElements.flightBtn = createButton(
    contentFrames.Main, "Flight: OFF", theme.secondary,
    function() toggleFlight() end, 6
)

mainElements.noclipBtn = createButton(
    contentFrames.Main, "Noclip: OFF", theme.secondary,
    function() toggleNoclip() end, 7
)

-- TELEPORT TAB CONTENT
local teleportElements = {}
teleportElements.input = createInput(contentFrames.Teleport, "Enter player username...", 1)
teleportElements.teleportBtn = createButton(
    contentFrames.Teleport, "Teleport to Player", theme.primary,
    function() teleportToPlayer(teleportElements.input.Text) end, 2
)
teleportElements.infiniteBtn = createButton(
    contentFrames.Teleport, "Infinite Teleport: OFF", theme.secondary, nil, 3
)

-- TROLL TAB CONTENT
local trollElements = {}

trollElements.chatTextInput = createInput(contentFrames.Troll, "Enter text to spam...", 1)
trollElements.chatTextInput.Text = trollSettings.chatText

local chatDelayUpdate = createSlider(
    contentFrames.Troll, "Chat Delay (seconds)", 0.1, 5, trollSettings.chatDelay,
    function(val) trollSettings.chatDelay = val end, 2
)

trollElements.chatSpamBtn = createButton(
    contentFrames.Troll, "Chat Spammer: OFF", theme.secondary, nil, 3
)

local fakeLagWaitUpdate = createSlider(
    contentFrames.Troll, "Fake Lag Wait Time", 0.01, 1, trollSettings.fakeLagWaitTime,
    function(val) trollSettings.fakeLagWaitTime = val end, 4
)

local fakeLagDelayUpdate = createSlider(
    contentFrames.Troll, "Fake Lag Delay Time", 0.1, 2, trollSettings.fakeLagDelayTime,
    function(val) trollSettings.fakeLagDelayTime = val end, 5
)

trollElements.fakeLagBtn = createButton(
    contentFrames.Troll, "Fake Lag: OFF", theme.secondary, nil, 6
)

trollElements.flingInput = createInput(contentFrames.Troll, "Enter player username to fling...", 7)
trollElements.flingBtn = createButton(
    contentFrames.Troll, "Fling Player", theme.primary, nil, 8
)
trollElements.flingAllBtn = createButton(
    contentFrames.Troll, "Fling Everyone", theme.error, nil, 9
)
trollElements.touchFlingBtn = createButton(
    contentFrames.Troll, "Touch Fling: OFF", theme.secondary, nil, 10
)

trollElements.followInput = createInput(contentFrames.Troll, "Player to follow...", 11)
trollElements.followBtn = createButton(
    contentFrames.Troll, "Follow Player: OFF", theme.secondary, nil, 12
)

-- SCRIPTS TAB CONTENT (same as desktop version but with mobile-friendly sizing)
local function addScriptSection(title, scripts, parentFrame, layoutOrder)
    local sectionContainer = Instance.new("Frame")
    sectionContainer.Parent = parentFrame
    sectionContainer.BackgroundTransparency = 1
    sectionContainer.Size = UDim2.new(1, 0, 0, 0)
    sectionContainer.LayoutOrder = layoutOrder or 1
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Parent = sectionContainer
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Size = UDim2.new(1, 0, 0, isMobile and 28 or 22)
    sectionLabel.Font = fonts.bold
    sectionLabel.Text = title
    sectionLabel.TextColor3 = theme.primary
    sectionLabel.TextSize = math.floor((isMobile and 14 or 13) * config.guiScale)
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.TextYAlignment = Enum.TextYAlignment.Center
    
    local scriptLayout = Instance.new("UIListLayout")
    scriptLayout.Parent = sectionContainer
    scriptLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scriptLayout.Padding = UDim.new(0, isMobile and 8 or 6)
    
    scriptLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sectionContainer.Size = UDim2.new(1, 0, 0, scriptLayout.AbsoluteContentSize.Y + (isMobile and 28 or 22))
    end)
    
    for i, script in ipairs(scripts) do
        createButton(sectionContainer, script.name, theme.secondary, script.callback, i + 1)
    end
    
    return sectionContainer
end

-- Continue with the rest of the functionality...
-- (The script continues with all the same functionality as the desktop version,
-- but with mobile-friendly adaptations throughout)

local regularScripts = {
    {name = "Invisibility", callback = function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Global/invisibility.lua"))()
        notify("Script", "Invisibility loaded", 3, "success")
    end},
    {name = "IY (Infinite Yield)", callback = function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        notify("Script", "Infinite Yield loaded", 3, "success")
    end},
    {name = "FE-Chatdraw", callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Global/FE-Chatdraw.lua"))()
        notify("Script", "FE-Chatdraw loaded", 3, "success")
    end},
    {name = "Bird Poop", callback = function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Troll/FE-Bird-Poop.lua"))()
        notify("Script", "Bird Poop loaded", 3, "success")
    end},
    {name = "Chat Admin", callback = function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Global/FE-ChatAdmin.lua"))()
        notify("Script", "Chat Admin loaded", 3, "success")
    end},
    {name = "VC Unban", callback = function() 
        pcall(function() Services.VoiceChatService:joinVoice() end)
        notify("Voice Chat", "Unban attempted", 3)
    end},
    {name = "Super Ring Parts", callback = function() 
        loadstring(game:HttpGet("https://rscripts.net/raw/super-ring-parts-v4-by-lukas_1741980981842_td0ummjymf.txt",true))()
        notify("Script", "Super Ring Parts loaded", 3, "success")
    end}
}

local bypasserScripts = {
    {name = "SaturnBypasser", callback = function() 
        loadstring(game:HttpGet('https://getsaturn.pages.dev/sb.lua'))()
        notify("Bypasser", "Saturn loaded", 3, "success")
    end},
    {name = "CatBypasser", callback = function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/shadow62x/catbypass/main/upfix"))()
        notify("Bypasser", "Cat loaded", 3, "success")
    end},
    {name = "BetterBypasser", callback = function() 
        loadstring(game:HttpGet("https://github.com/Synergy-Networks/products/raw/main/BetterBypasser/loader.lua"))()
        notify("Bypasser", "Better Bypasser loaded", 3, "success")
    end},
    {name = "FeuralBypasser", callback = function() 
        loadstring(game:HttpGet("https://zxfolix.github.io/feuralbypasser.lua"))()
        notify("Bypasser", "Feural loaded", 3, "success")
    end}
}

local animationScripts = {
    {name = "AquaMatrix", callback = function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ExploitFin/AquaMatrix/refs/heads/AquaMatrix/AquaMatrix"))()
        notify("Animation", "AquaMatrix loaded", 3, "success")
    end},
    {name = "Griddy (Kinda Buggy)", callback = function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Animations/FE-Griddy(Buggy).lua"))()
        notify("Animation", "Griddy loaded", 3, "success")
    end}
}

addScriptSection("Regular Scripts", regularScripts, contentFrames.Scripts, 1)

local separator1 = Instance.new("Frame")
separator1.Parent = contentFrames.Scripts
separator1.BackgroundColor3 = theme.border
separator1.Size = UDim2.new(1, 0, 0, 1)
separator1.BorderSizePixel = 0
separator1.LayoutOrder = 2

addScriptSection("Bypassers", bypasserScripts, contentFrames.Scripts, 3)

local separator2 = Instance.new("Frame")
separator2.Parent = contentFrames.Scripts
separator2.BackgroundColor3 = theme.border
separator2.Size = UDim2.new(1, 0, 0, 1)
separator2.BorderSizePixel = 0
separator2.LayoutOrder = 4

addScriptSection("Animations", animationScripts, contentFrames.Scripts, 5)

-- GAMES TAB CONTENT
local gamesElements = {}

local function getSupportedGamesList()
    local gamesList = {}
    for _, gameInfo in pairs(gameDatabase) do
        table.insert(gamesList, "• " .. gameInfo.name)
    end
    return table.concat(gamesList, "\n")
end

local currentGame = gameDatabase[game.GameId]
if currentGame then
    local gameDetectedLabel = Instance.new("TextLabel")
    gameDetectedLabel.Parent = contentFrames["Games"]
    gameDetectedLabel.BackgroundTransparency = 1
    gameDetectedLabel.Size = UDim2.new(1, 0, 0, isMobile and 35 or 30)
    gameDetectedLabel.Font = fonts.bold
    gameDetectedLabel.Text = "🎮 Game Detected: " .. currentGame.name
    gameDetectedLabel.TextColor3 = theme.success
    gameDetectedLabel.TextSize = math.floor((isMobile and 15 or 14) * config.guiScale)
    gameDetectedLabel.TextXAlignment = Enum.TextXAlignment.Center
    gameDetectedLabel.LayoutOrder = 1
    
    gamesElements.loadBtn = createButton(
        contentFrames["Games"], "Load " .. currentGame.name .. " Script", theme.primary,
        function()
            loadstring(game:HttpGet(currentGame.url))()
            notify("Games", currentGame.name .. " script loaded!", 3, "success")
        end, 2
    )
end

local supportedGamesLabel = Instance.new("TextLabel")
supportedGamesLabel.Parent = contentFrames["Games"]
supportedGamesLabel.BackgroundTransparency = 1
supportedGamesLabel.Size = UDim2.new(1, 0, 0, isMobile and 28 or 22)
supportedGamesLabel.Font = fonts.bold
supportedGamesLabel.Text = "Supported Games:"
supportedGamesLabel.TextColor3 = theme.primary
supportedGamesLabel.TextSize = math.floor((isMobile and 14 or 13) * config.guiScale)
supportedGamesLabel.TextXAlignment = Enum.TextXAlignment.Left
supportedGamesLabel.LayoutOrder = 3

local gamesListLabel = Instance.new("TextLabel")
gamesListLabel.Parent = contentFrames["Games"]
gamesListLabel.BackgroundTransparency = 1
gamesListLabel.Size = UDim2.new(1, 0, 0, isMobile and 180 or 150)
gamesListLabel.Font = fonts.primary
gamesListLabel.Text = getSupportedGamesList()
gamesListLabel.TextColor3 = theme.textSecondary
gamesListLabel.TextSize = math.floor((isMobile and 12 or 11) * config.guiScale)
gamesListLabel.TextXAlignment = Enum.TextXAlignment.Left
gamesListLabel.TextYAlignment = Enum.TextYAlignment.Top
gamesListLabel.TextWrapped = true
gamesListLabel.LayoutOrder = 4

-- PVP TAB CONTENT
local pvpElements = {}

pvpElements.espBtn = createButton(contentFrames.PVP, "ESP: OFF", theme.secondary, nil, 1)
pvpElements.espBtn.TextColor3 = theme.error

pvpElements.tracerBtn = createButton(contentFrames.PVP, "Tracers: OFF", theme.secondary, nil, 2)
pvpElements.tracerBtn.TextColor3 = theme.error

pvpElements.aimbotBtn = createButton(contentFrames.PVP, "Aimbot: OFF", theme.secondary, nil, 3)
pvpElements.aimbotBtn.TextColor3 = theme.error

local aimbotSmoothingUpdate = createSlider(
    contentFrames.PVP, "Aimbot Smoothing", 0, 1, aimbotSettings.Smoothing,
    function(val) aimbotSettings.Smoothing = val end, 4
)

pvpElements.aimbotTeamCheck = createButton(contentFrames.PVP, "Aimbot Team Check: ON", theme.secondary, nil, 5)
pvpElements.aimbotTeamCheck.TextColor3 = theme.success

pvpElements.triggerbotBtn = createButton(contentFrames.PVP, "Triggerbot: OFF", theme.secondary, nil, 6)
pvpElements.triggerbotBtn.TextColor3 = theme.error

local triggerbotDelayUpdate = createSlider(
    contentFrames.PVP, "Triggerbot Delay", 0, 1, triggerbotSettings.delay,
    function(val) triggerbotSettings.delay = val end, 7
)

local triggerbotRangeUpdate = createSlider(
    contentFrames.PVP, "Triggerbot Range", 50, 1000, triggerbotSettings.range,
    function(val) triggerbotSettings.range = val end, 8
)

pvpElements.invincibleBtn = createButton(contentFrames.PVP, "Invincible: OFF", theme.secondary, nil, 9)
pvpElements.invincibleBtn.TextColor3 = theme.error

pvpElements.hitboxBtn = createButton(contentFrames.PVP, "Hit Box Expander: OFF", theme.secondary, nil, 10)
pvpElements.hitboxBtn.TextColor3 = theme.error

pvpElements.antiKickBtn = createButton(contentFrames.PVP, "Anti-Kick: ON", theme.secondary, nil, 11)
pvpElements.antiKickBtn.TextColor3 = theme.success

pvpElements.antiDetectionBtn = createButton(contentFrames.PVP, "Anti-Detection: ON", theme.secondary, nil, 12)
pvpElements.antiDetectionBtn.TextColor3 = theme.success

-- UTILITY TAB CONTENT
local utilityElements = {}

utilityElements.rejoinBtn = createButton(contentFrames.Utility, "Rejoin Server", theme.secondary, nil, 1)
utilityElements.hopBtn = createButton(contentFrames.Utility, "Server Hop (Smallest)", theme.secondary, nil, 2)
utilityElements.antiAfkBtn = createButton(contentFrames.Utility, "Anti-AFK", theme.secondary, nil, 3)
utilityElements.fpsBtn = createButton(contentFrames.Utility, "Unlock FPS", theme.secondary, nil, 4)

local uncLabel = Instance.new("TextLabel")
uncLabel.Parent = contentFrames.Utility
uncLabel.BackgroundTransparency = 1
uncLabel.Size = UDim2.new(1, 0, 0, isMobile and 28 or 22)
uncLabel.Font = fonts.bold
uncLabel.Text = "UNC Tests"
uncLabel.TextColor3 = theme.primary
uncLabel.TextSize = math.floor((isMobile and 14 or 13) * config.guiScale)
uncLabel.TextXAlignment = Enum.TextXAlignment.Left
uncLabel.TextYAlignment = Enum.TextYAlignment.Center
uncLabel.LayoutOrder = 5

utilityElements.suncBtn = createButton(contentFrames.Utility, "sUNC Test", theme.secondary, nil, 6)
utilityElements.uncBtn = createButton(contentFrames.Utility, "UNC Test", theme.secondary, nil, 7)

-- All the core functionality from the original script (ESP, Aimbot, Flight, etc.)
-- [Previous functionality code remains the same, just adapted for mobile where needed]

-- ESP FUNCTIONALITY
local function createPlayerESP(targetPlayer)
    if espSettings.Players[targetPlayer] then return end
    
    local character = targetPlayer.Character
    if not character then
        targetPlayer.CharacterAdded:Wait()
        character = targetPlayer.Character
    end
    
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
    billboard.Size = UDim2.new(0, isMobile and 140 or 120, 0, isMobile and 50 or 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Adornee = character:WaitForChild("Head")
    billboard.Parent = gui.screen
    billboard.Enabled = espSettings.Enabled
    
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.3
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BorderSizePixel = 0
    frame.Parent = billboard
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -10, 1, -10)
    textLabel.Position = UDim2.new(0, 5, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = isMobile and 11 or 10
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.Text = ""
    textLabel.Parent = frame
    
    local tracerLine = Drawing.new("Line")
    tracerLine.Visible = false
    tracerLine.Thickness = isMobile and 3 or 2
    tracerLine.Color = Color3.new(1, 1, 1)
    
    espSettings.Players[targetPlayer] = true
    espSettings.Highlights[targetPlayer] = highlight
    espSettings.Billboards[targetPlayer] = billboard
    espSettings.TracerLines[targetPlayer] = tracerLine
end

local function removePlayerESP(targetPlayer)
    if not espSettings.Players[targetPlayer] then return end
    
    local highlight = espSettings.Highlights[targetPlayer]
    if highlight then highlight:Destroy() end
    
    local billboard = espSettings.Billboards[targetPlayer]
    if billboard then billboard:Destroy() end
    
    local tracerLine = espSettings.TracerLines[targetPlayer]
    if tracerLine then tracerLine:Remove() end
    
    espSettings.Players[targetPlayer] = nil
    espSettings.Highlights[targetPlayer] = nil
    espSettings.Billboards[targetPlayer] = nil
    espSettings.TracerLines[targetPlayer] = nil
end

local function clearAllESP()
    for player, _ in pairs(espSettings.Players) do
        removePlayerESP(player)
    end
end

local function updatePlayerESP()
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
                local distance = 0
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    distance = (rootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                end
                
                local highlight = espSettings.Highlights[targetPlayer]
                local billboard = espSettings.Billboards[targetPlayer]
                local tracerLine = espSettings.TracerLines[targetPlayer]
                
                if not highlight or not billboard or not tracerLine then
                    createPlayerESP(targetPlayer)
                else
                    highlight.Enabled = espSettings.Enabled and (distance <= espSettings.MaxDistance)
                    
                    if billboard then
                        billboard.Enabled = espSettings.Enabled and (distance <= espSettings.MaxDistance)
                        
                        if billboard.Enabled then
                            local health = math.floor(humanoid.Health)
                            local maxHealth = math.floor(humanoid.MaxHealth)
                            local text = string.format("%s\n%d/%dHP\n%d studs", 
                                targetPlayer.Name, health, maxHealth, math.floor(distance))
                            
                            local frame = billboard:FindFirstChild("Frame")
                            if frame then
                                local textLabel = frame:FindFirstChild("TextLabel")
                                if textLabel then textLabel.Text = text end
                            end
                        end
                    end
                    
                    if tracerLine and espSettings.Tracers then
                        tracerLine.Visible = espSettings.Enabled and (distance <= espSettings.MaxDistance)
                        
                        if tracerLine.Visible then
                            local camera = Services.Workspace.CurrentCamera
                            local rootPos = rootPart.Position
                            local screenPos, onScreen = camera:WorldToViewportPoint(rootPos)
                            
                            if onScreen then
                                local bottomCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                                tracerLine.From = bottomCenter
                                tracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
                                
                                if targetPlayer.Team and player.Team then
                                    if targetPlayer.Team == player.Team then
                                        tracerLine.Color = Color3.new(0, 1, 0)
                                    else
                                        tracerLine.Color = Color3.new(1, 0, 0)
                                    end
                                else
                                    tracerLine.Color = Color3.new(1, 1, 1)
                                end
                            else
                                tracerLine.Visible = false
                            end
                        else
                            tracerLine.Visible = false
                        end
                    end
                end
            end
        end
    end
end

local function setupESP()
    clearAllESP()
    
    for _, otherPlayer in ipairs(Services.Players:GetPlayers()) do
        if otherPlayer ~= player then createPlayerESP(otherPlayer) end
    end
    
    Services.Players.PlayerAdded:Connect(function(newPlayer)
        if newPlayer ~= player then createPlayerESP(newPlayer) end
    end)
    
    Services.Players.PlayerRemoving:Connect(removePlayerESP)
end

-- FLIGHT SYSTEM (Mobile-adapted)
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
    
    -- Show mobile flight controls
    if isMobile and mobileControls.overlay then
        mobileControls.overlay.Visible = true
    end
    
    config.flightTracks = {}
    if humanoid then
        local function newAnim(id)
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. id
            return anim
        end

        local animIds = {
            forward = 90872539,
            up = 90872539,
            right1 = 136801964,
            right2 = 142495255,
            left1 = 136801964,
            left2 = 142495255,
            flyLow1 = 97169019,
            flyLow2 = 282574440,
            flyFast = 282574440,
            back1 = 136801964,
            back2 = 106772613,
            back3 = 42070810,
            back4 = 214744412,
            down = 233322916,
            idle1 = 97171309
        }
        
        for name, id in pairs(animIds) do
            local anim = newAnim(id)
            config.flightTracks[name] = humanoid:LoadAnimation(anim)
        end
    end
end

local function disableFlight()
    if connections.flyBodyVelocity then connections.flyBodyVelocity:Destroy(); connections.flyBodyVelocity = nil end
    if connections.flyBodyGyro then connections.flyBodyGyro:Destroy(); connections.flyBodyGyro = nil end
    
    -- Hide mobile flight controls
    if isMobile and mobileControls.overlay then
        mobileControls.overlay.Visible = false
        -- Reset all input flags
        for flag, _ in pairs(inputFlags) do
            inputFlags[flag] = false
        end
    end
    
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
    
    for _, track in pairs(config.flightTracks) do
        if track then track:Stop() end
    end
    config.flightTracks = {}
end

function toggleFlight()
    states.flight = not states.flight
    if states.flight then
        enableFlight()
        mainElements.flightBtn.Text = "Flight: ON"
        mainElements.flightBtn.TextColor3 = theme.success
        createTween(mainElements.flightBtn, 0.2, { BackgroundColor3 = theme.success:lerp(theme.secondary, 0.7) }):Play()
    else
        disableFlight()
        mainElements.flightBtn.Text = "Flight: OFF"
        mainElements.flightBtn.TextColor3 = theme.error
        createTween(mainElements.flightBtn, 0.2, { BackgroundColor3 = theme.secondary }):Play()
    end
end

-- NOCLIP SYSTEM
local function enableNoclip()
    states.noclip = true
    
    if connections.noclipConnection then connections.noclipConnection:Disconnect() end
    
    connections.noclipConnection = Services.RunService.Stepped:Connect(function()
        if states.noclip and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
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

function toggleNoclip()
    if states.noclip then
        disableNoclip()
        mainElements.noclipBtn.Text = "Noclip: OFF"
        mainElements.noclipBtn.TextColor3 = theme.error
        createTween(mainElements.noclipBtn, 0.2, { BackgroundColor3 = theme.secondary }):Play()
    else
        enableNoclip()
        mainElements.noclipBtn.Text = "Noclip: ON"
        mainElements.noclipBtn.TextColor3 = theme.success
        createTween(mainElements.noclipBtn, 0.2, { BackgroundColor3 = theme.success:lerp(theme.secondary, 0.7) }):Play()
    end
end

-- TELEPORT SYSTEM
function teleportToPlayer(username)
    if username == "" then return end
    
    local targets = findPlayer(username)
    if #targets == 0 then return end
    
    local target = targets[1]
    local targetChar = target.Character
    if not targetChar then return end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if myRoot then
        myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 0, -3)
    end
end

-- Button state management
local function updateButtonState(button, state, onText, offText)
    if state then
        button.Text = onText
        button.TextColor3 = theme.success
        createTween(button, 0.15, { BackgroundColor3 = theme.success:lerp(theme.secondary, 0.7) }):Play()
    else
        button.Text = offText
        button.TextColor3 = theme.error
        createTween(button, 0.15, { BackgroundColor3 = theme.secondary }):Play()
    end
end

-- TAB SWITCHING
local function resizeGUI(tabName)
    if config.isMinimized then return end
    
    local targetHeight = (tabHeights[tabName] + config.titleBarHeight + config.tabBarHeight + 20) * config.guiScale
    
    createTween(gui.main, config.animSpeed, {
        Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, targetHeight)
    }):Play()
end

local function switchTab(tabName)
    if config.currentTab == tabName or config.isAnimating then return end
    config.isAnimating = true
    
    for name, tab in pairs(tabButtons) do
        local indicator = tab:FindFirstChild("Indicator")
        if name == tabName then
            createTween(tab, config.animSpeed, { 
                BackgroundColor3 = theme.primary,
                TextColor3 = theme.text
            }):Play()
            if indicator then
                createTween(indicator, config.animSpeed, { 
                    Size = UDim2.new(0.5, 0, 0, 2)
                }):Play()
            end
        else
            createTween(tab, config.animSpeed, { 
                BackgroundColor3 = theme.secondary,
                TextColor3 = theme.textSecondary
            }):Play()
            if indicator then
                createTween(indicator, config.animSpeed, { 
                    Size = UDim2.new(0, 0, 0, 2)
                }):Play()
            end
        end
    end
    
    local currentFrame = contentFrames[config.currentTab]
    local newFrame = contentFrames[tabName]
    
    resizeGUI(tabName)
    
    newFrame.Visible = true
    newFrame.Position = UDim2.new(1, 0, 0, 0)
    
    local currentTween = createTween(currentFrame, config.animSpeed, {
        Position = UDim2.new(-1, 0, 0, 0)
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    
    local newTween = createTween(newFrame, config.animSpeed, {
        Position = UDim2.new(0, 0, 0, 0)
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    
    currentTween:Play()
    newTween:Play()
    
    newTween.Completed:Connect(function()
        currentFrame.Visible = false
        currentFrame.Position = UDim2.new(0, 0, 0, 0)
        config.currentTab = tabName
        config.isAnimating = false
    end)
end

-- Initialize first tab
contentFrames.Main.Position = UDim2.new(0, 0, 0, 0)
local mainIndicator = tabButtons.Main:FindFirstChild("Indicator")
if mainIndicator then
    mainIndicator.Size = UDim2.new(0.5, 0, 0, 2)
end
tabButtons.Main.BackgroundColor3 = theme.primary
tabButtons.Main.TextColor3 = theme.text

for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function() 
        switchTab(tabName) 
    end)
end

-- CONTROL BUTTONS
gui.minimizeBtn.MouseButton1Click:Connect(function()
    config.isMinimized = not config.isMinimized

    if config.isMinimized then
        createTween(gui.main, config.animSpeed, {
            Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, config.titleBarHeight)
        }):Play()

        for _, child in ipairs(gui.main:GetChildren()) do
            if child ~= gui.titleBar and child.Name ~= "UICorner" and child.Name ~= "Shadow" then
                createTween(child, config.animSpeed / 2, {BackgroundTransparency = 1}):Play()
            end
        end

        task.wait(config.animSpeed / 2)

        for _, child in ipairs(gui.main:GetChildren()) do
            if child ~= gui.titleBar and child.Name ~= "UICorner" and child.Name ~= "Shadow" then
                child.Visible = false
            end
        end

        gui.minimizeBtn.Text = "□"
    else
        for _, child in ipairs(gui.main:GetChildren()) do
            if child ~= gui.titleBar and child.Name ~= "UICorner" and child.Name ~= "Shadow" then
                child.Visible = true
                child.BackgroundTransparency = 1
            end
        end

        local targetHeight = (tabHeights[config.currentTab] + config.titleBarHeight + config.tabBarHeight + 20) * config.guiScale
        createTween(gui.main, config.animSpeed, {
            Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, targetHeight)
        }):Play()

        task.wait(config.animSpeed / 2)
        for _, child in ipairs(gui.main:GetChildren()) do
            if child ~= gui.titleBar and child.Name ~= "UICorner" and child.Name ~= "Shadow" then
                createTween(child, config.animSpeed / 2, {BackgroundTransparency = 0}):Play()
            end
        end

        gui.minimizeBtn.Text = "-"
    end
end)

gui.closeBtn.MouseButton1Click:Connect(function()
    createTween(gui.main, config.animSpeed, {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()

    task.wait(config.animSpeed)
    if gui.screen then
        gui.screen:Destroy()
    end
end)

-- FLIGHT CONTROLS (Mobile and Desktop)
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

    -- Flight animations (same as desktop)
    if inputFlags.up then
        if config.flightTracks.up and not config.flightTracks.up.IsPlaying then
            for _, track in pairs(config.flightTracks) do if track then track:Stop() end end
            config.flightTracks.up:Play()
        end
    elseif inputFlags.down then
        if config.flightTracks.down and not config.flightTracks.down.IsPlaying then
            for _, track in pairs(config.flightTracks) do if track then track:Stop() end end
            config.flightTracks.down:Play()
        end
    elseif inputFlags.left then
        if config.flightTracks.left1 and not config.flightTracks.left1.IsPlaying then
            for _, track in pairs(config.flightTracks) do if track then track:Stop() end end
            config.flightTracks.left1:Play(); config.flightTracks.left1.TimePosition = 2.0; config.flightTracks.left1:AdjustSpeed(0)
            config.flightTracks.left2:Play(); config.flightTracks.left2.TimePosition = 0.5; config.flightTracks.left2:AdjustSpeed(0)
        end
    elseif inputFlags.right then
        if config.flightTracks.right1 and not config.flightTracks.right1.IsPlaying then
            for _, track in pairs(config.flightTracks) do if track then track:Stop() end end
            config.flightTracks.right1:Play(); config.flightTracks.right1.TimePosition = 1.1; config.flightTracks.right1:AdjustSpeed(0)
            config.flightTracks.right2:Play(); config.flightTracks.right2.TimePosition = 0.5; config.flightTracks.right2:AdjustSpeed(0)
        end
    elseif inputFlags.back then
        if config.flightTracks.back1 and not config.flightTracks.back1.IsPlaying then
            for _, track in pairs(config.flightTracks) do if track then track:Stop() end end
            config.flightTracks.back1:Play(); config.flightTracks.back1.TimePosition = 5.3; config.flightTracks.back1:AdjustSpeed(0)
            config.flightTracks.back2:Play(); config.flightTracks.back2:AdjustSpeed(0)
            config.flightTracks.back3:Play(); config.flightTracks.back3.TimePosition = 0.8; config.flightTracks.back3:AdjustSpeed(0)
            config.flightTracks.back4:Play(); config.flightTracks.back4.TimePosition = 1; config.flightTracks.back4:AdjustSpeed(0)
        end
    elseif inputFlags.forward then
        config.forwardHold = config.forwardHold + dt
        if config.forwardHold >= 3 then
            if config.flightTracks.flyFast and not config.flightTracks.flyFast.IsPlaying then
                for _, track in pairs(config.flightTracks) do if track then track:Stop() end end
                config.flightSpeed = config.flightSpeed * 1.3
                config.flightTracks.flyFast:Play(); config.flightTracks.flyFast:AdjustSpeed(0.05)
            end
        else
            if config.flightTracks.flyLow1 and not config.flightTracks.flyLow1.IsPlaying then
                for _, track in pairs(config.flightTracks) do if track then track:Stop() end end
                config.flightSpeed = config.flightSpeed
                config.flightTracks.flyLow1:Play()
                config.flightTracks.flyLow2:Play()
            end
        end
    else
        if config.flightTracks.idle1 and not config.flightTracks.idle1.IsPlaying then
            for _, track in pairs(config.flightTracks) do if track then track:Stop() end end
            config.flightTracks.idle1:Play(); config.flightTracks.idle1:AdjustSpeed(0)
        end
    end
end)

-- Desktop keyboard input (only if not mobile)
if not isMobile then
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
            toggleFlight()
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
end

-- BUTTON CONNECTIONS (abbreviated - same functionality as desktop)
teleportElements.teleportBtn.MouseButton1Click:Connect(function()
    teleportToPlayer(teleportElements.input.Text)
end)

pvpElements.espBtn.MouseButton1Click:Connect(function()
    espSettings.Enabled = not espSettings.Enabled
    if espSettings.Enabled then
        updateButtonState(pvpElements.espBtn, true, "ESP: ON", "ESP: OFF")
        setupESP()
    else
        updateButtonState(pvpElements.espBtn, false, "ESP: ON", "ESP: OFF")
        clearAllESP()
    end
end)

utilityElements.rejoinBtn.MouseButton1Click:Connect(function()
    Services.TeleportService:Teleport(game.PlaceId, player)
end)

-- CHARACTER RESPAWN HANDLING
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    applyCharacterSettings()
    
    task.wait(1)
    
    if states.flight then
        enableFlight()
        updateButtonState(mainElements.flightBtn, true, "Flight: ON", "Flight: OFF")
    end
    
    if states.noclip then
        enableNoclip()
        updateButtonState(mainElements.noclipBtn, true, "Noclip: ON", "Noclip: OFF")
    end
    
    if espSettings.Enabled then
        setupESP()
    end
end)

-- Initialize character settings
applyCharacterSettings()

-- CORE LOOPS
local lastUpdate = 0
Services.RunService.Heartbeat:Connect(function()
    local now = tick()
    
    applyCharacterSettings()
    
    if now - lastUpdate >= 0.1 and espSettings.Enabled and gui.screen.Enabled then
        lastUpdate = now
        updatePlayerESP()
    end
end)

-- Update greeting every minute
Services.RunService.Heartbeat:Connect(function()
    if tick() % 60 < 1 then
        greetingLabel.Text = getTimeBasedGreeting()
    end
end)

-- Mobile-specific viewport scaling
Services.Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    local newScale = calculateScale()
    if math.abs(newScale - config.guiScale) > 0.1 then
        config.guiScale = newScale
        
        local targetHeight = (tabHeights[config.currentTab] + config.titleBarHeight + config.tabBarHeight + 20) * config.guiScale
        createTween(gui.main, 0.3, {
            Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, targetHeight)
        }):Play()
        
        -- Update mobile positioning on rotation
        if isMobile then
            gui.main.Position = UDim2.new(0.5, 0, 0, 20)
        end
        
        gui.title.TextSize = math.floor((isMobile and 18 or 16) * config.guiScale)
        versionLabel.TextSize = math.floor((isMobile and 10 or 9) * config.guiScale)
        gui.minimizeBtn.TextSize = math.floor((isMobile and 14 or 12) * config.guiScale)
        gui.closeBtn.TextSize = math.floor((isMobile and 14 or 12) * config.guiScale)
        
        for _, tab in pairs(tabButtons) do
            tab.TextSize = math.floor((isMobile and 10 or 9) * config.guiScale)
        end
    end
end)

-- CLEANUP
gui.screen.Destroying:Connect(function()
    for _, connection in pairs(connections) do
        if connection and typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        elseif connection and typeof(connection) == "thread" then
            task.cancel(connection)
        end
    end
    
    if states.flight then disableFlight() end
    if states.noclip then disableNoclip() end
    clearAllESP()
    
    Services.Workspace.FallenPartsDestroyHeight = scriptEnv.FPDH
end)

-- Mobile-specific open/close keybind (uses touch gesture or F4)
if isMobile then
    -- Add a small toggle button for mobile users
    local mobileToggle = Instance.new("TextButton")
    mobileToggle.Name = "MobileToggle"
    mobileToggle.Parent = gui.screen
    mobileToggle.BackgroundColor3 = theme.primary
    mobileToggle.Position = UDim2.new(1, -60, 0, 20)
    mobileToggle.Size = UDim2.new(0, 50, 0, 30)
    mobileToggle.Font = fonts.bold
    mobileToggle.Text = "GUI"
    mobileToggle.TextColor3 = theme.text
    mobileToggle.TextSize = 12
    mobileToggle.ZIndex = 15
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = mobileToggle
    
    mobileToggle.TouchTap:Connect(function()
        if gui.main.Visible then
            gui.main.Visible = false
            if mobileControls.overlay then
                mobileControls.overlay.Visible = false
            end
            mobileToggle.Text = "SHOW"
        else
            gui.main.Visible = true
            if states.flight and mobileControls.overlay then
                mobileControls.overlay.Visible = true
            end
            mobileToggle.Text = "GUI"
        end
    end)
else
    -- Desktop F4 toggle
    Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.F4 then
            if gui.screen.Enabled then
                createTween(gui.main, config.animSpeed, {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 0)
                }):Play()
                
                task.wait(config.animSpeed)
                gui.screen.Enabled = false
                gui.main.Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, (tabHeights[config.currentTab] + config.titleBarHeight + config.tabBarHeight + 20) * config.guiScale)
                gui.main.BackgroundTransparency = 0
            else
                gui.screen.Enabled = true
                gui.main.Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, config.titleBarHeight)
                
                local targetHeight = (tabHeights[config.currentTab] + config.titleBarHeight + config.tabBarHeight + 20) * config.guiScale
                createTween(gui.main, config.animSpeed, {
                    Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, targetHeight),
                    BackgroundTransparency = 0
                }):Play()
            end
        end
    end)
end

-- INITIALIZATION
task.wait(0.1)
gui.screen.Enabled = true

if isMobile then
    gui.main.Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, config.titleBarHeight)
else
    gui.main.Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, config.titleBarHeight)
end

local function initializeGUI()
    local targetHeight = (tabHeights[config.currentTab] + config.titleBarHeight + config.tabBarHeight + 20) * config.guiScale
    local sizeTween = createTween(gui.main, 0.5, {
        Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, targetHeight),
        BackgroundTransparency = 0
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    
    sizeTween:Play()
    
    createTween(shadow, 0.5, {
        BackgroundTransparency = 0.6
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
    
    for i, tabName in ipairs(tabList) do
        local tab = tabButtons[tabName]
        if tab then
            tab.BackgroundTransparency = 1
            tab.TextTransparency = 1
            
            task.wait(0.06)
            createTween(tab, 0.25, {
                BackgroundTransparency = 0,
                TextTransparency = 0
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        end
    end
end

task.spawn(initializeGUI)

-- Welcome notifications
task.wait(1.2)
if isMobile then
    notify("s0ulz V4 Mobile", "Touch-friendly edition loaded!", 5, "success")
    task.wait(0.6)
    notify("Mobile Controls", "Touch the GUI button to show/hide")
    task.wait(0.4)
    notify("Flight", "Flight controls appear when flying")
else
    notify("s0ulz V4", "Enhanced edition loaded successfully!", 5, "success")
    task.wait(0.6)
    notify("Info", "Press F4 to open/close the GUI")
    task.wait(0.4)
    notify("Flight Control", "Press F to toggle flight on/off", 4)
end

-- Mobile-specific welcome tips
if isMobile then
    task.wait(1)
    notify("Mobile Tips", "Larger buttons and touch controls optimized for mobile devices", 4)
end