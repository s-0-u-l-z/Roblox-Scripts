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

-- Enhanced configuration with proper scaling
local config = {
    currentSpeed = 16,
    currentJump = 50,
    flightSpeed = 50,
    forwardHold = 0,
    flightTracks = {},
    baseWidth = 400,  -- Reduced width for better fit
    baseHeight = 380, -- Reduced height for better fit
    animSpeed = 0.2,  -- Smoother animations
    hoverSpeed = 0.1,
    isMinimized = false,
    isAnimating = false,
    currentTab = "Main",
    guiScale = 1,
    titleBarHeight = 40,  -- Reduced height
    tabBarHeight = 36,    -- Reduced height
    contentPadding = 12   -- Reduced padding
}

-- Improved scaling calculation
local function calculateScale()
    local viewport = Services.Workspace.CurrentCamera.ViewportSize
    local baseRes = Vector2.new(1366, 768) -- More standard base resolution
    local scale = math.min(viewport.X / baseRes.X, viewport.Y / baseRes.Y)
    return math.clamp(scale, 0.7, 1.1) -- Tighter scale range
end

config.guiScale = calculateScale()

-- Updated tab heights for optimal spacing
local tabHeights = {
    Main = 300,
    Teleport = 180,
    Troll = 450,     -- Increased for new features
    Scripts = 450,   -- Increased height for scripts
    Games = 300,  -- New tab
    PVP = 360,
    Utility = 280
}

-- Game database for Best Scripts tab
local gameDatabase = {
    [286090429] = {
        name = "Arsenal",
        url = "https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Games/Arsenal/Arsenal(s0ulz).lua"
    },
    [4292856079] = {  -- 99 Nights in the Forest PlaceId (example - replace with actual)
        name = "99 Nights in the Forest",
        url = "https://pastefy.app/RXzul28o/raw"
    },
    [13772394625] = {  -- Blade Ball PlaceId
        name = "Blade Ball", 
        url = "http://lumin-hub.lol/Blade.lua"
    }
}

-- Clean modern theme
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
    annoyMode = false
}

local connections = {}

-- New state variables for troll features
local trollSettings = {
    chatText = "Hello World!",
    chatDelay = 1,
    followTarget = nil,
    annoyTarget = nil
}

-- ESP and Aimbot settings (PRESERVED EXACTLY)
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
    ActivationKey = Enum.KeyCode.RightControl,
    Smoothing = 0.3,
    FOV = 120,
    TargetPart = "Head",
    TeamCheck = true,
    VisibleCheck = true,
    Connection = nil,
    Active = false
}

local triggerbotSettings = { delay = 0.05, range = 500 }
local hitboxSettings = { originalSizes = {}, expansionAmount = 1.5 }
local inputFlags = { forward = false, back = false, left = false, right = false, up = false, down = false }
local scriptEnv = { FPDH = Services.Workspace.FallenPartsDestroyHeight, OldPos = nil }

-- Clean notification system
local function notify(title, text, duration, iconType)
    pcall(function()
        local icon = iconType == "error" and "rbxasset://textures/ui/ErrorIcon.png" or 
                    iconType == "success" and "rbxasset://textures/ui/success_icon.png" or nil
        Services.StarterGui:SetCore("SendNotification", {
            Title = title or "s0ulz GUI",
            Text = text or "",
            Duration = duration or 4,
            Icon = icon
        })
    end)
end

-- Enhanced player search
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

-- Smooth tween creation
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

-- Character settings
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

-- GUI Creation with clean modern structure
local gui = {}

-- Main ScreenGui
gui.screen = Instance.new("ScreenGui")
gui.screen.Name = "s0ulzGUI_V4_Clean"
gui.screen.Parent = playerGui
gui.screen.ResetOnSpawn = false
gui.screen.Enabled = false
gui.screen.IgnoreGuiInset = true
gui.screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main container with clean styling
gui.main = Instance.new("Frame")
gui.main.Name = "MainContainer"
gui.main.Parent = gui.screen
gui.main.BackgroundColor3 = theme.bg
gui.main.BorderSizePixel = 0
gui.main.AnchorPoint = Vector2.new(0.5, 0.5)
gui.main.Position = UDim2.new(0.5, 0, 0.5, 0)
gui.main.Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, config.baseHeight * config.guiScale)
gui.main.Active = true
gui.main.Draggable = true
gui.main.ClipsDescendants = true

-- Clean rounded corners
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = gui.main

-- Subtle shadow
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Parent = gui.main
shadow.BackgroundColor3 = theme.shadow
shadow.BackgroundTransparency = 0.6
shadow.Size = UDim2.new(1, 16, 1, 16)
shadow.Position = UDim2.new(0, -8, 0, -8)
shadow.ZIndex = -1

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 16)
shadowCorner.Parent = shadow

-- Clean title bar
gui.titleBar = Instance.new("Frame")
gui.titleBar.Name = "TitleBar"
gui.titleBar.Parent = gui.main
gui.titleBar.BackgroundColor3 = theme.surface
gui.titleBar.BorderSizePixel = 0
gui.titleBar.Size = UDim2.new(1, 0, 0, config.titleBarHeight)
gui.titleBar.ZIndex = 2

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = gui.titleBar

-- Corner masking for clean edges
local titleMask = Instance.new("Frame")
titleMask.Parent = gui.titleBar
titleMask.BackgroundColor3 = theme.surface
titleMask.BorderSizePixel = 0
titleMask.Size = UDim2.new(1, 0, 0.5, 0)
titleMask.Position = UDim2.new(0, 0, 0.5, 0)
titleMask.ZIndex = 1

-- Clean title text
gui.title = Instance.new("TextLabel")
gui.title.Parent = gui.titleBar
gui.title.BackgroundTransparency = 1
gui.title.Position = UDim2.new(0, 16, 0, 0)
gui.title.Size = UDim2.new(1, -100, 0.6, 0)
gui.title.Font = fonts.bold
gui.title.Text = "s0ulz GUI V4"
gui.title.TextColor3 = theme.text
gui.title.TextSize = math.floor(16 * config.guiScale)
gui.title.TextXAlignment = Enum.TextXAlignment.Left
gui.title.TextYAlignment = Enum.TextYAlignment.Center
gui.title.ZIndex = 3

-- Version label
local versionLabel = Instance.new("TextLabel")
versionLabel.Parent = gui.titleBar
versionLabel.BackgroundTransparency = 1
versionLabel.Position = UDim2.new(0, 16, 0.6, 0)
versionLabel.Size = UDim2.new(0.5, 0, 0.4, 0)
versionLabel.Font = fonts.secondary
versionLabel.Text = "its V4 I guess"
versionLabel.TextColor3 = theme.textSecondary
versionLabel.TextSize = math.floor(9 * config.guiScale)
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.TextYAlignment = Enum.TextYAlignment.Center
versionLabel.ZIndex = 3

-- Clean control buttons
local function createControlButton(text, pos, color, hoverColor)
    local btn = Instance.new("TextButton")
    btn.Parent = gui.titleBar
    btn.BackgroundColor3 = color or theme.secondary
    btn.Position = pos
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.Font = fonts.primary
    btn.Text = text
    btn.TextColor3 = theme.text
    btn.TextSize = math.floor(12 * config.guiScale)
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    -- Clean hover effects
    local originalColor = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        createTween(btn, config.hoverSpeed, {
            BackgroundColor3 = hoverColor or theme.primary,
            Size = UDim2.new(0, 30, 0, 30)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        createTween(btn, config.hoverSpeed, {
            BackgroundColor3 = originalColor,
            Size = UDim2.new(0, 28, 0, 28)
        }):Play()
    end)
    
    return btn
end

gui.minimizeBtn = createControlButton("-", UDim2.new(1, -64, 0.5, -14), theme.secondary, theme.warning)
gui.closeBtn = createControlButton("X", UDim2.new(1, -32, 0.5, -14), theme.secondary, theme.error)

-- Clean tab system
gui.tabContainer = Instance.new("Frame")
gui.tabContainer.Name = "TabContainer"
gui.tabContainer.Parent = gui.main
gui.tabContainer.BackgroundTransparency = 1
gui.tabContainer.Position = UDim2.new(0, 0, 0, config.titleBarHeight + 2)
gui.tabContainer.Size = UDim2.new(1, 0, 0, config.tabBarHeight)
gui.tabContainer.ZIndex = 2

-- Updated tab list
local tabList = {"Main", "Teleport", "Troll", "Scripts", "Games", "PVP", "Utility"}
local tabButtons = {}

-- Create clean tabs
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
    tab.TextSize = math.floor(9 * config.guiScale)  -- Smaller text for more tabs
    tab.AutoButtonColor = false
    tab.ZIndex = 3
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tab
    
    -- Tab indicator
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
    
    -- Clean hover effects
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
    
    tabButtons[tabName] = tab
end

-- Clean content area
gui.content = Instance.new("Frame")
gui.content.Parent = gui.main
gui.content.BackgroundTransparency = 1
gui.content.Position = UDim2.new(0, config.contentPadding, 0, config.titleBarHeight + config.tabBarHeight + 6)
gui.content.Size = UDim2.new(1, -config.contentPadding * 2, 1, -(config.titleBarHeight + config.tabBarHeight + 12))
gui.content.ZIndex = 2

-- Content frames
local contentFrames = {}

-- Clean UI creation functions
local function createSlider(parent, labelText, minVal, maxVal, currentVal, callback, layoutOrder)
    local container = Instance.new("Frame")
    container.Parent = parent
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 60)
    container.LayoutOrder = layoutOrder or 1
    
    -- Clean label
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.65, 0, 0, 20)
    label.Font = fonts.primary
    label.Text = labelText
    label.TextColor3 = theme.text
    label.TextSize = math.floor(12 * config.guiScale)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    
    -- Value display
    local valueContainer = Instance.new("Frame")
    valueContainer.Parent = container
    valueContainer.BackgroundColor3 = theme.surface
    valueContainer.Position = UDim2.new(1, -55, 0, 0)
    valueContainer.Size = UDim2.new(0, 55, 0, 20)
    
    local valueCorner = Instance.new("UICorner")
    valueCorner.CornerRadius = UDim.new(0, 5)
    valueCorner.Parent = valueContainer
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = valueContainer
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.Font = fonts.mono
    valueLabel.Text = tostring(currentVal)
    valueLabel.TextColor3 = theme.primary
    valueLabel.TextSize = math.floor(11 * config.guiScale)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Clean track
    local track = Instance.new("Frame")
    track.Parent = container
    track.BackgroundColor3 = theme.secondary
    track.Position = UDim2.new(0, 0, 0, 28)
    track.Size = UDim2.new(1, 0, 0, 6)
    
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
    
    -- Clean thumb
    local thumb = Instance.new("Frame")
    thumb.Parent = track
    thumb.BackgroundColor3 = theme.text
    thumb.Size = UDim2.new(0, 18, 0, 18)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new((currentVal - minVal)/(maxVal - minVal), 0, 0.5, 0)
    thumb.ZIndex = 5
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    
    -- Dragging functionality
    local dragging = false
    local function updateSlider(value)
        value = math.clamp(value, minVal, maxVal)
        local percent = (value - minVal)/(maxVal - minVal)
        
        createTween(fill, 0.08, { Size = UDim2.new(percent, 0, 1, 0) }):Play()
        createTween(thumb, 0.08, { Position = UDim2.new(percent, 0, 0.5, 0) }):Play()
        
        valueLabel.Text = tostring(math.round(value * 100) / 100)  -- Better decimal handling
        if callback then callback(value) end
    end
    
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            gui.main.Active = false
            createTween(thumb, 0.12, { Size = UDim2.new(0, 22, 0, 22), BackgroundColor3 = theme.primary }):Play()
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = Services.UserInputService:GetMouseLocation()
            local trackPos = track.AbsolutePosition
            local trackSize = track.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
            updateSlider(minVal + (maxVal - minVal) * relativeX)
        end
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            gui.main.Active = true
            createTween(thumb, 0.12, { Size = UDim2.new(0, 18, 0, 18), BackgroundColor3 = theme.text }):Play()
        end
    end)
    
    return updateSlider, container
end

-- Clean button creation
local function createButton(parent, text, color, callback, layoutOrder, size)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = color or theme.secondary
    btn.Size = size or UDim2.new(1, 0, 0, 30)
    btn.Font = fonts.primary
    btn.Text = text
    btn.TextColor3 = theme.text
    btn.TextSize = math.floor(12 * config.guiScale)
    btn.AutoButtonColor = false
    btn.LayoutOrder = layoutOrder or 1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    -- Clean hover and click effects
    local originalColor = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        local hoverColor = Color3.new(
            math.min(originalColor.R * 1.12, 1),
            math.min(originalColor.G * 1.12, 1),
            math.min(originalColor.B * 1.12, 1)
        )
        createTween(btn, config.hoverSpeed, { BackgroundColor3 = hoverColor }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        createTween(btn, config.hoverSpeed, { BackgroundColor3 = originalColor }):Play()
    end)
    
    btn.MouseButton1Down:Connect(function()
        createTween(btn, 0.08, { Size = (size or UDim2.new(1, 0, 0, 30)) - UDim2.new(0, 1, 0, 1) }):Play()
    end)
    
    btn.MouseButton1Up:Connect(function()
        createTween(btn, 0.08, { Size = size or UDim2.new(1, 0, 0, 30) }):Play()
    end)
    
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    
    return btn
end

-- Clean input field
local function createInput(parent, placeholder, layoutOrder)
    local input = Instance.new("TextBox")
    input.Parent = parent
    input.BackgroundColor3 = theme.surface
    input.Size = UDim2.new(1, 0, 0, 30)
    input.Font = fonts.secondary
    input.PlaceholderText = placeholder
    input.PlaceholderColor3 = theme.textTertiary
    input.Text = ""
    input.TextColor3 = theme.text
    input.TextSize = math.floor(12 * config.guiScale)
    input.ClearTextOnFocus = false
    input.LayoutOrder = layoutOrder or 1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = input
    
    local border = Instance.new("UIStroke")
    border.Color = theme.border
    border.Thickness = 1
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.Parent = input
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = input
    
    -- Clean focus effects
    input.Focused:Connect(function()
        createTween(border, 0.15, { Color = theme.primary, Thickness = 2 }):Play()
        createTween(input, 0.15, { BackgroundColor3 = theme.surfaceLight }):Play()
    end)
    
    input.FocusLost:Connect(function()
        createTween(border, 0.15, { Color = theme.border, Thickness = 1 }):Play()
        createTween(input, 0.15, { BackgroundColor3 = theme.surface }):Play()
    end)
    
    return input
end

-- Create content frames with proper layout
for _, tabName in ipairs(tabList) do
    local frame = Instance.new("ScrollingFrame")
    frame.Name = tabName .. "Content"
    frame.Parent = gui.content
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Visible = (tabName == "Main")
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = theme.primary
    frame.ScrollBarImageTransparency = 0.4
    frame.BorderSizePixel = 0
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = frame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    
    -- Update canvas size when layout changes
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
    end)
    
    contentFrames[tabName] = frame
end

-- MAIN TAB CONTENT
local speedUpdate = createSlider(
    contentFrames.Main, "Walk Speed", 16, 1000, config.currentSpeed,
    function(val) config.currentSpeed = val; applyCharacterSettings() end, 1
)

local jumpUpdate = createSlider(
    contentFrames.Main, "Jump Power", 50, 500, config.currentJump,
    function(val) config.currentJump = val; applyCharacterSettings() end, 2
)

local flightUpdate = createSlider(
    contentFrames.Main, "Flight Speed", 10, 200, config.flightSpeed,
    function(val) config.flightSpeed = val end, 3
)

-- Main tab buttons
local mainElements = {}

mainElements.flightBtn = createButton(
    contentFrames.Main, "Flight: OFF", theme.secondary,
    function() toggleFlight() end, 4
)

mainElements.noclipBtn = createButton(
    contentFrames.Main, "Noclip: OFF", theme.secondary,
    function() toggleNoclip() end, 5
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

-- TROLL TAB CONTENT WITH NEW FEATURES
local trollElements = {}

-- Chat Spammer Section
trollElements.chatTextInput = createInput(contentFrames.Troll, "Enter text to spam...", 1)
trollElements.chatTextInput.Text = trollSettings.chatText

local chatDelayUpdate = createSlider(
    contentFrames.Troll, "Chat Delay (seconds)", 0.1, 5, trollSettings.chatDelay,
    function(val) trollSettings.chatDelay = val end, 2
)

trollElements.chatSpamBtn = createButton(
    contentFrames.Troll, "Chat Spammer: OFF", theme.secondary, nil, 3
)

-- Original Fling Section
trollElements.flingInput = createInput(contentFrames.Troll, "Enter player username to fling...", 4)
trollElements.flingBtn = createButton(
    contentFrames.Troll, "Fling Player", theme.primary, nil, 5
)
trollElements.flingAllBtn = createButton(
    contentFrames.Troll, "Fling Everyone", theme.error, nil, 6
)
trollElements.touchFlingBtn = createButton(
    contentFrames.Troll, "Touch Fling: OFF", theme.secondary, nil, 7
)

-- New Troll Features
trollElements.fakeLagBtn = createButton(
    contentFrames.Troll, "Fake Lag: OFF", theme.secondary, nil, 8
)

trollElements.followInput = createInput(contentFrames.Troll, "Player to follow...", 9)
trollElements.followBtn = createButton(
    contentFrames.Troll, "Follow Player: OFF", theme.secondary, nil, 10
)

trollElements.annoyInput = createInput(contentFrames.Troll, "Player to annoy...", 11)
trollElements.annoyBtn = createButton(
    contentFrames.Troll, "Annoy Mode: OFF", theme.secondary, nil, 12
)

-- SCRIPTS TAB CONTENT - Fixed organization with FE-Chatdraw
local function addScriptSection(title, scripts, parentFrame, layoutOrder)
    local sectionContainer = Instance.new("Frame")
    sectionContainer.Parent = parentFrame
    sectionContainer.BackgroundTransparency = 1
    sectionContainer.Size = UDim2.new(1, 0, 0, 0)
    sectionContainer.LayoutOrder = layoutOrder or 1
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Parent = sectionContainer
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Size = UDim2.new(1, 0, 0, 22)
    sectionLabel.Font = fonts.bold
    sectionLabel.Text = title
    sectionLabel.TextColor3 = theme.primary
    sectionLabel.TextSize = math.floor(13 * config.guiScale)
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.TextYAlignment = Enum.TextYAlignment.Center
    
    local scriptLayout = Instance.new("UIListLayout")
    scriptLayout.Parent = sectionContainer
    scriptLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scriptLayout.Padding = UDim.new(0, 6)
    
    -- Update container height when layout changes
    scriptLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sectionContainer.Size = UDim2.new(1, 0, 0, scriptLayout.AbsoluteContentSize.Y + 22)
    end)
    
    for i, script in ipairs(scripts) do
        createButton(sectionContainer, script.name, theme.secondary, script.callback, i + 1)
    end
    
    return sectionContainer
end

-- Regular scripts with FE-Chatdraw added
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

-- Bypasser scripts
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

-- Add script sections
addScriptSection("Regular Scripts", regularScripts, contentFrames.Scripts, 1)

-- Separator
local separator = Instance.new("Frame")
separator.Parent = contentFrames.Scripts
separator.BackgroundColor3 = theme.border
separator.Size = UDim2.new(1, 0, 0, 1)
separator.BorderSizePixel = 0
separator.LayoutOrder = 2

addScriptSection("Bypassers", bypasserScripts, contentFrames.Scripts, 3)

-- GAMES TAB CONTENT - Game Detection (FIXED with correct PlaceIds)
local gamesElements = {}

-- Game database with correct PlaceIds
local gameDatabase = {
    [286090429] = {
        name = "Arsenal",
        url = "https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Games/Arsenal/Arsenal(s0ulz).lua"
    },
    [4292856079] = {
        name = "99 Nights in the Forest",
        url = "https://pastefy.app/RXzul28o/raw"
    },
    [13772394625] = {
        name = "Blade Ball", 
        url = "http://lumin-hub.lol/Blade.lua"
    }
}

-- Helper function to generate supported games list dynamically
local function getSupportedGamesList()
    local gamesList = {}
    for _, gameInfo in pairs(gameDatabase) do
        table.insert(gamesList, "• " .. gameInfo.name)
    end
    return table.concat(gamesList, "\n")
end

-- Check current game and display appropriate script
local currentGame = gameDatabase[game.PlaceId]
if currentGame then
    -- Game detected label
    local gameDetectedLabel = Instance.new("TextLabel")
    gameDetectedLabel.Parent = contentFrames["Games"]
    gameDetectedLabel.BackgroundTransparency = 1
    gameDetectedLabel.Size = UDim2.new(1, 0, 0, 30)
    gameDetectedLabel.Font = fonts.bold
    gameDetectedLabel.Text = "🎮 Game Detected: " .. currentGame.name
    gameDetectedLabel.TextColor3 = theme.success
    gameDetectedLabel.TextSize = math.floor(14 * config.guiScale)
    gameDetectedLabel.TextXAlignment = Enum.TextXAlignment.Center
    gameDetectedLabel.LayoutOrder = 1
    
    -- Load script button
    gamesElements.loadBtn = createButton(
        contentFrames["Games"], "Load " .. currentGame.name .. " Script", theme.primary,
        function()
            loadstring(game:HttpGet(currentGame.url))()
            notify("Games", currentGame.name .. " script loaded!", 3, "success")
        end, 2
    )
else
    -- No game detected - dynamically shows ALL games from database
    local noGameLabel = Instance.new("TextLabel")
    noGameLabel.Parent = contentFrames["Games"]
    noGameLabel.BackgroundTransparency = 1
    noGameLabel.Size = UDim2.new(1, 0, 0, 100)
    noGameLabel.Font = fonts.primary
    noGameLabel.Text = "⚠ No supported game detected\n\nSupported games:\n" .. getSupportedGamesList()
    noGameLabel.TextColor3 = theme.textSecondary
    noGameLabel.TextSize = math.floor(12 * config.guiScale)
    noGameLabel.TextXAlignment = Enum.TextXAlignment.Center
    noGameLabel.TextYAlignment = Enum.TextYAlignment.Center
    noGameLabel.LayoutOrder = 1
    noGameLabel.TextWrapped = true
    
    -- Debug info (optional - remove if you don't want this)
    local debugLabel = Instance.new("TextLabel")
    debugLabel.Parent = contentFrames["Games"]
    debugLabel.BackgroundTransparency = 1
    debugLabel.Size = UDim2.new(1, 0, 0, 20)
    debugLabel.Font = fonts.secondary
    debugLabel.Text = "Current PlaceId: " .. tostring(game.PlaceId)
    debugLabel.TextColor3 = theme.textTertiary
    debugLabel.TextSize = math.floor(10 * config.guiScale)
    debugLabel.TextXAlignment = Enum.TextXAlignment.Center
    debugLabel.LayoutOrder = 2
end

-- PVP TAB CONTENT (ESP/Tracers functionality PRESERVED EXACTLY)
local pvpElements = {}

pvpElements.espBtn = createButton(contentFrames.PVP, "ESP: OFF", theme.secondary, nil, 1)
pvpElements.espBtn.TextColor3 = theme.error

pvpElements.tracerBtn = createButton(contentFrames.PVP, "Tracers: OFF", theme.secondary, nil, 2)
pvpElements.tracerBtn.TextColor3 = theme.error

pvpElements.invincibleBtn = createButton(contentFrames.PVP, "Invincible: OFF", theme.secondary, nil, 3)
pvpElements.invincibleBtn.TextColor3 = theme.error

pvpElements.aimbotBtn = createButton(contentFrames.PVP, "Aimbot: OFF", theme.secondary, nil, 4)
pvpElements.aimbotBtn.TextColor3 = theme.error

pvpElements.triggerbotBtn = createButton(contentFrames.PVP, "Triggerbot: OFF", theme.secondary, nil, 5)
pvpElements.triggerbotBtn.TextColor3 = theme.error

pvpElements.hitboxBtn = createButton(contentFrames.PVP, "Hit Box Expander: OFF", theme.secondary, nil, 6)
pvpElements.hitboxBtn.TextColor3 = theme.error

pvpElements.antiKickBtn = createButton(contentFrames.PVP, "Anti-Kick: ON", theme.secondary, nil, 7)
pvpElements.antiKickBtn.TextColor3 = theme.success

pvpElements.antiDetectionBtn = createButton(contentFrames.PVP, "Anti-Detection: ON", theme.secondary, nil, 8)
pvpElements.antiDetectionBtn.TextColor3 = theme.success

-- UTILITY TAB CONTENT
local utilityElements = {}

utilityElements.rejoinBtn = createButton(contentFrames.Utility, "Rejoin Server", theme.secondary, nil, 1)
utilityElements.hopBtn = createButton(contentFrames.Utility, "Server Hop (Smallest)", theme.secondary, nil, 2)
utilityElements.antiAfkBtn = createButton(contentFrames.Utility, "Anti-AFK", theme.secondary, nil, 3)
utilityElements.fpsBtn = createButton(contentFrames.Utility, "Unlock FPS", theme.secondary, nil, 4)

-- UNC Test section
local uncLabel = Instance.new("TextLabel")
uncLabel.Parent = contentFrames.Utility
uncLabel.BackgroundTransparency = 1
uncLabel.Size = UDim2.new(1, 0, 0, 22)
uncLabel.Font = fonts.bold
uncLabel.Text = "UNC Tests"
uncLabel.TextColor3 = theme.primary
uncLabel.TextSize = math.floor(13 * config.guiScale)
uncLabel.TextXAlignment = Enum.TextXAlignment.Left
uncLabel.TextYAlignment = Enum.TextYAlignment.Center
uncLabel.LayoutOrder = 5

utilityElements.suncBtn = createButton(contentFrames.Utility, "sUNC Test", theme.secondary, nil, 6)
utilityElements.uncBtn = createButton(contentFrames.Utility, "UNC Test", theme.secondary, nil, 7)

-- ESP FUNCTIONALITY (PRESERVED EXACTLY AS REQUESTED)
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
    billboard.Size = UDim2.new(0, 120, 0, 40)
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
    tracerLine.Thickness = 2
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

-- NEW TROLL FUNCTIONALITY IMPLEMENTATIONS

-- Chat Spammer
local function chatSpammerLoop()
    while states.chatSpammer and Services.RunService.Heartbeat:Wait() do
        local text = trollElements.chatTextInput.Text
        if text ~= "" then
            pcall(function()
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All")
            end)
        end
        task.wait(trollSettings.chatDelay)
    end
end

-- Fake Lag Switch
local function enableFakeLag()
    states.fakeLag = true
    local originalSpeed = config.currentSpeed
    
    connections.fakeLagConnection = Services.RunService.Heartbeat:Connect(function()
        if states.fakeLag and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                -- Simulate lag by freezing movement temporarily
                if tick() % 3 < 1.5 then  -- Freeze for 1.5 seconds every 3 seconds
                    humanoid.WalkSpeed = 0
                    rootPart.Anchored = true
                else
                    humanoid.WalkSpeed = originalSpeed
                    rootPart.Anchored = false
                end
            end
        end
    end)
end

local function disableFakeLag()
    states.fakeLag = false
    
    if connections.fakeLagConnection then
        connections.fakeLagConnection:Disconnect()
        connections.fakeLagConnection = nil
    end
    
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            humanoid.WalkSpeed = config.currentSpeed
            rootPart.Anchored = false
        end
    end
end

-- Follow Player
local function followPlayerLoop()
    while states.followPlayer and Services.RunService.Heartbeat:Wait() do
        if trollSettings.followTarget and trollSettings.followTarget.Character then
            local targetChar = trollSettings.followTarget.Character
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            
            if targetRoot and myRoot then
                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -3)  -- Follow 3 studs behind
            end
        else
            -- Target left, stop following
            states.followPlayer = false
            trollSettings.followTarget = nil
            updateButtonState(trollElements.followBtn, false, "Follow Player: ON", "Follow Player: OFF")
            notify("Follow", "Target left the game", 3)
            break
        end
        task.wait(0.1)  -- Update 10 times per second
    end
end

-- Annoy Mode (teleport in front of player)
local function annoyModeLoop()
    while states.annoyMode and Services.RunService.Heartbeat:Wait() do
        if trollSettings.annoyTarget and trollSettings.annoyTarget.Character then
            local targetChar = trollSettings.annoyTarget.Character
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            
            if targetRoot and myRoot then
                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)  -- Teleport 2 studs in front
            end
        else
            -- Target left, stop annoying
            states.annoyMode = false
            trollSettings.annoyTarget = nil
            updateButtonState(trollElements.annoyBtn, false, "Annoy Mode: ON", "Annoy Mode: OFF")
            notify("Annoy", "Target left the game", 3)
            break
        end
        task.wait(0.5)  -- Update every 0.5 seconds for annoy mode
    end
end

-- CORE FUNCTIONALITY IMPLEMENTATIONS

-- Enhanced Flight System (Fixed to work like Invincible-Flight.lua)
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
    
    -- Flight animations
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

-- Enhanced Noclip System
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
        createTween(mainElements.noclipBtn, 0.2, { BackgroundColor3 = theme.success:lerp(theme.secondary, 0.7) }):Play()
    end
end

-- Enhanced Teleport System
function teleportToPlayer(username)
    if username == "" then
        notify("Error", "Please enter a username", 3, "error")
        return
    end
    
    local targets = findPlayer(username)
    if #targets == 0 then
        notify("Error", "Player not found: " .. username, 3, "error")
        return
    end
    
    local target = targets[1]
    local targetChar = target.Character
    if not targetChar then
        notify("Error", target.Name .. " has no character", 3, "error")
        return
    end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        notify("Error", "Cannot find " .. target.Name .. "'s HumanoidRootPart", 3, "error")
        return
    end
    
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if myRoot then
        myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 0, -3)
        notify("Teleported", "Teleported to " .. target.Name, 2, "success")
    else
        notify("Error", "Your character not found", 3, "error")
    end
end

-- Enhanced FLING SYSTEM (preserved from original)
local function SkidFling(TargetPlayer)
    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if not (Character and Humanoid and RootPart) then return end

    if RootPart.Velocity.Magnitude < 50 then scriptEnv.OldPos = RootPart.CFrame end

    if THumanoid and THumanoid.Sit then return end

    if THead then Services.Workspace.CurrentCamera.CameraSubject = THead
    elseif Handle then Services.Workspace.CurrentCamera.CameraSubject = Handle
    elseif THumanoid and TRootPart then Services.Workspace.CurrentCamera.CameraSubject = THumanoid end

    if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end

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
                    Angle += 100
                    for _, offset in ipairs({
                        CFrame.new(0, 1.5, 0), CFrame.new(0, -1.5, 0), CFrame.new(2.25, 1.5, -2.25),
                        CFrame.new(-2.25, -1.5, 2.25), CFrame.new(0, 1.5, 0), CFrame.new(0, -1.5, 0)
                    }) do
                        FPos(BasePart, offset + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    end
                else
                    for _, offset in ipairs({
                        CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.new(0, -1.5, -THumanoid.WalkSpeed),
                        CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25),
                        CFrame.new(0, -1.5, 0), CFrame.new(0, -1.5, 0), CFrame.new(0, -1.5, 0)
                    }) do
                        FPos(BasePart, offset, CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                    end
                end
            else break end
        until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Services.Players or 
              TargetPlayer.Character ~= TCharacter or (THumanoid and THumanoid.Sit) or Humanoid.Health <= 0 or tick() > Time + TimeToWait
    end

    Services.Workspace.FallenPartsDestroyHeight = 0/0

    local BV = Instance.new("BodyVelocity")
    BV.Name = "EpixVel"
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    if TRootPart and THead then
        if (TRootPart.Position - THead.Position).Magnitude > 5 then SFBasePart(THead)
        else SFBasePart(TRootPart) end
    elseif TRootPart then SFBasePart(TRootPart)
    elseif THead then SFBasePart(THead)
    elseif Handle then SFBasePart(Handle) end

    if BV then BV:Destroy() end
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    Services.Workspace.CurrentCamera.CameraSubject = Humanoid

    if scriptEnv.OldPos then
        repeat
            RootPart.CFrame = scriptEnv.OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(scriptEnv.OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            for _, x in ipairs(Character:GetChildren()) do
                if x:IsA("BasePart") then
                    x.Velocity = Vector3.new()
                    x.RotVelocity = Vector3.new()
                end
            end
            task.wait()
        until (RootPart.Position - scriptEnv.OldPos.Position).Magnitude < 25
    end

    Services.Workspace.FallenPartsDestroyHeight = scriptEnv.FPDH
end

-- Enhanced Tab Switching System
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
    
    -- Update tab buttons with clean animations
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
    
    -- Smooth content transition
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

-- Connect tab buttons
for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function() 
        switchTab(tabName) 
    end)
end

-- Enhanced minimize functionality
gui.minimizeBtn.MouseButton1Click:Connect(function()
    config.isMinimized = not config.isMinimized

    if config.isMinimized then
        -- Animate shrinking
        createTween(gui.main, config.animSpeed, {
            Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, config.titleBarHeight)
        }):Play()

        -- Fade out children except title bar / decorations
        for _, child in ipairs(gui.main:GetChildren()) do
            if child ~= gui.titleBar and child.Name ~= "UICorner" and child.Name ~= "Shadow" then
                createTween(child, config.animSpeed / 2, {BackgroundTransparency = 1}):Play()
            end
        end

        task.wait(config.animSpeed / 2)

        -- Hide children after fade
        for _, child in ipairs(gui.main:GetChildren()) do
            if child ~= gui.titleBar and child.Name ~= "UICorner" and child.Name ~= "Shadow" then
                child.Visible = false
            end
        end

        gui.minimizeBtn.Text = "□"

    else
        -- Show children instantly but transparent
        for _, child in ipairs(gui.main:GetChildren()) do
            if child ~= gui.titleBar and child.Name ~= "UICorner" and child.Name ~= "Shadow" then
                child.Visible = true
                child.BackgroundTransparency = 1
            end
        end

        -- Expand back to full size
        local targetHeight = (tabHeights[config.currentTab] + config.titleBarHeight + config.tabBarHeight + 20) * config.guiScale
        createTween(gui.main, config.animSpeed, {
            Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, targetHeight)
        }):Play()

        -- Fade children in after expansion starts
        task.wait(config.animSpeed / 2)
        for _, child in ipairs(gui.main:GetChildren()) do
            if child ~= gui.titleBar and child.Name ~= "UICorner" and child.Name ~= "Shadow" then
                createTween(child, config.animSpeed / 2, {BackgroundTransparency = 0}):Play()
            end
        end

        gui.minimizeBtn.Text = "-"
    end
end)

-- Enhanced close functionality
gui.closeBtn.MouseButton1Click:Connect(function()
    -- Fade out + shrink
    createTween(gui.main, config.animSpeed, {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()

    task.wait(config.animSpeed)
    if gui.screen then
        gui.screen:Destroy()
    end
end)

-- Enhanced PVP functionality (preserving ESP/Tracers exactly)
-- Invincibility system
local function enableInvincibility()
    if connections.healthConnection then connections.healthConnection:Disconnect() end

    local function maintainHealth()
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid.Health = humanoid.MaxHealth end
        end
    end

    maintainHealth()
    connections.healthConnection = Services.RunService.Heartbeat:Connect(maintainHealth)
end

local function disableInvincibility()
    if connections.healthConnection then
        connections.healthConnection:Disconnect()
        connections.healthConnection = nil
    end
end

-- Enhanced Aimbot system
local function isEnemy(targetPlayer)
    if not aimbotSettings.TeamCheck then return true end
    return player.Team ~= targetPlayer.Team
end

local function isVisible(character, targetPart)
    if not aimbotSettings.VisibleCheck then return true end
    
    local camera = Services.Workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local target = targetPart.Position
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character, character}
    raycastParams.IgnoreWater = true
    
    local raycastResult = Services.Workspace:Raycast(origin, target - origin, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        return hitPart and hitPart:IsDescendantOf(character)
    end
    
    return true
end

local function findClosestEnemy()
    if not player.Character then return nil end
    
    local camera = Services.Workspace.CurrentCamera
    local closestEnemy = nil
    local closestAngle = math.rad(aimbotSettings.FOV)
    local closestDistance = math.huge
    
    for _, otherPlayer in ipairs(Services.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and isEnemy(otherPlayer) then
            local char = otherPlayer.Character
            local humanoid = char:FindFirstChild("Humanoid")
            local targetPart = char:FindFirstChild(aimbotSettings.TargetPart)
            
            if humanoid and humanoid.Health > 0 and targetPart and isVisible(char, targetPart) then
                local cameraLook = camera.CFrame.LookVector
                local direction = (targetPart.Position - camera.CFrame.Position).Unit
                local angle = math.acos(cameraLook:Dot(direction))
                local distance = (targetPart.Position - camera.CFrame.Position).Magnitude
                
                if angle < closestAngle and distance < closestDistance then
                    closestAngle = angle
                    closestDistance = distance
                    closestEnemy = char
                end
            end
        end
    end
    
    return closestEnemy
end

local function smoothAim(targetPosition)
    local camera = Services.Workspace.CurrentCamera
    local currentLook = camera.CFrame.LookVector
    local targetDirection = (targetPosition - camera.CFrame.Position).Unit
    
    local smoothingFactor = math.clamp(1 - aimbotSettings.Smoothing, 0.01, 0.99)
    local smoothedDirection = currentLook:Lerp(targetDirection, smoothingFactor)
    camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + smoothedDirection)
end

-- Enhanced Triggerbot
local function isEnemyPlayer(character)
    if not character then return false end
    local targetPlayer = Services.Players:GetPlayerFromCharacter(character)
    
    if targetPlayer and targetPlayer ~= player then
        if aimbotSettings.TeamCheck and player.Team and targetPlayer.Team then
            return player.Team ~= targetPlayer.Team
        end
        return true
    end
    return false
end

local function triggerbotLoop()
    while states.triggerbot and Services.RunService.RenderStepped:Wait() do
        if not player.Character then continue end
        
        local camera = Services.Workspace.CurrentCamera
        
        if mouse.Target then
            local model = mouse.Target:FindFirstAncestorOfClass("Model")
            if model then
                local distance = (camera.CFrame.Position - mouse.Hit.Position).Magnitude
                if distance <= triggerbotSettings.range and isEnemyPlayer(model) then
                    createTween(pvpElements.triggerbotBtn, 0.1, { BackgroundColor3 = theme.success }):Play()
                    Services.VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(triggerbotSettings.delay)
                    Services.VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    task.wait(0.1)
                    if states.triggerbot then 
                        createTween(pvpElements.triggerbotBtn, 0.1, { BackgroundColor3 = theme.secondary }):Play()
                    end
                end
            end
        end
    end
end

-- Enhanced hitbox expander
local function expandHitBoxes(enable)
    for _, otherPlayer in ipairs(Services.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local char = otherPlayer.Character
            if char then
                if enable then
                    hitboxSettings.originalSizes[otherPlayer] = {}
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            hitboxSettings.originalSizes[otherPlayer][part] = part.Size
                            part.Size = part.Size * hitboxSettings.expansionAmount
                        end
                    end
                else
                    if hitboxSettings.originalSizes[otherPlayer] then
                        for part, size in pairs(hitboxSettings.originalSizes[otherPlayer]) do
                            if part.Parent then part.Size = size end
                        end
                        hitboxSettings.originalSizes[otherPlayer] = nil
                    end
                end
            end
        end
    end
end

-- Touch fling system
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
        Services.RunService.Stepped:Wait()
        hrp.Velocity = originalVel + Vector3.new(0, 0.1, 0)
        Services.RunService.Stepped:Wait()
        hrp.Velocity = originalVel - Vector3.new(0, 0.1, 0)
    end
end

-- Clean button state management
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

-- EVENT CONNECTIONS

-- Enhanced flight controls (Fixed to work like Invincible-Flight.lua)
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

    -- Flight animations (Fixed to work like Invincible-Flight.lua)
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

-- Clean input handling
Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local key = input.KeyCode
    if key == Enum.KeyCode.W then inputFlags.forward = true
    elseif key == Enum.KeyCode.S then inputFlags.back = true
    elseif key == Enum.KeyCode.A then inputFlags.left = true
    elseif key == Enum.KeyCode.D then inputFlags.right = true
    elseif key == Enum.KeyCode.E then inputFlags.up = true
    elseif key == Enum.KeyCode.Q then inputFlags.down = true
    elseif key == Enum.KeyCode.F4 then
        -- Clean GUI toggle
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

-- BUTTON EVENT CONNECTIONS

-- Teleport functionality
teleportElements.teleportBtn.MouseButton1Click:Connect(function()
    teleportToPlayer(teleportElements.input.Text)
end)

teleportElements.infiniteBtn.MouseButton1Click:Connect(function()
    states.infiniteTeleport = not states.infiniteTeleport
    if states.infiniteTeleport then
        updateButtonState(teleportElements.infiniteBtn, true, "Infinite Teleport: ON", "Infinite Teleport: OFF")
        connections.teleportConnection = Services.RunService.Heartbeat:Connect(function()
            if teleportElements.input.Text ~= "" then
                teleportToPlayer(teleportElements.input.Text)
            end
        end)
    else
        updateButtonState(teleportElements.infiniteBtn, false, "Infinite Teleport: ON", "Infinite Teleport: OFF")
        if connections.teleportConnection then
            connections.teleportConnection:Disconnect()
            connections.teleportConnection = nil
        end
    end
end)

-- NEW TROLL FUNCTIONALITY CONNECTIONS

-- Chat Spammer
trollElements.chatSpamBtn.MouseButton1Click:Connect(function()
    states.chatSpammer = not states.chatSpammer
    trollSettings.chatText = trollElements.chatTextInput.Text
    
    if states.chatSpammer then
        updateButtonState(trollElements.chatSpamBtn, true, "Chat Spammer: ON", "Chat Spammer: OFF")
        connections.chatSpamThread = task.spawn(chatSpammerLoop)
    else
        updateButtonState(trollElements.chatSpamBtn, false, "Chat Spammer: ON", "Chat Spammer: OFF")
        if connections.chatSpamThread then
            task.cancel(connections.chatSpamThread)
            connections.chatSpamThread = nil
        end
    end
end)

-- Original Fling functionality
trollElements.flingBtn.MouseButton1Click:Connect(function()
    local username = trollElements.flingInput.Text
    if username == "" then
        notify("Error", "Please enter a username", 3, "error")
        return
    end
    
    local targets = findPlayer(username)
    if #targets > 0 then
        for _, target in ipairs(targets) do
            SkidFling(target)
        end
        notify("Fling", "Flinging " .. username, 3, "success")
    else
        notify("Error", "Player not found", 3, "error")
    end
end)

trollElements.flingAllBtn.MouseButton1Click:Connect(function()
    for _, otherPlayer in ipairs(Services.Players:GetPlayers()) do
        if otherPlayer ~= player then
            SkidFling(otherPlayer)
        end
    end
    notify("Fling", "Flinging everyone!", 3, "success")
end)

trollElements.touchFlingBtn.MouseButton1Click:Connect(function()
    states.touchFling = not states.touchFling
    
    if states.touchFling then
        updateButtonState(trollElements.touchFlingBtn, true, "Touch Fling: ON", "Touch Fling: OFF")
        connections.touchFlingThread = task.spawn(touchFlingLoop)
    else
        updateButtonState(trollElements.touchFlingBtn, false, "Touch Fling: ON", "Touch Fling: OFF")
        if connections.touchFlingThread then
            task.cancel(connections.touchFlingThread)
            connections.touchFlingThread = nil
        end
    end
end)

-- Fake Lag functionality
trollElements.fakeLagBtn.MouseButton1Click:Connect(function()
    if states.fakeLag then
        disableFakeLag()
        updateButtonState(trollElements.fakeLagBtn, false, "Fake Lag: ON", "Fake Lag: OFF")
    else
        enableFakeLag()
        updateButtonState(trollElements.fakeLagBtn, true, "Fake Lag: ON", "Fake Lag: OFF")
    end
end)

-- Follow Player functionality
trollElements.followBtn.MouseButton1Click:Connect(function()
    if states.followPlayer then
        states.followPlayer = false
        trollSettings.followTarget = nil
        updateButtonState(trollElements.followBtn, false, "Follow Player: ON", "Follow Player: OFF")
        if connections.followThread then
            task.cancel(connections.followThread)
            connections.followThread = nil
        end
    else
        local username = trollElements.followInput.Text
        if username == "" then
            notify("Error", "Please enter a username to follow", 3, "error")
            return
        end
        
        local targets = findPlayer(username)
        if #targets > 0 then
            trollSettings.followTarget = targets[1]
            states.followPlayer = true
            updateButtonState(trollElements.followBtn, true, "Follow Player: ON", "Follow Player: OFF")
            connections.followThread = task.spawn(followPlayerLoop)
            notify("Follow", "Following " .. targets[1].Name, 3, "success")
        else
            notify("Error", "Player not found", 3, "error")
        end
    end
end)

-- Annoy Mode functionality
trollElements.annoyBtn.MouseButton1Click:Connect(function()
    if states.annoyMode then
        states.annoyMode = false
        trollSettings.annoyTarget = nil
        updateButtonState(trollElements.annoyBtn, false, "Annoy Mode: ON", "Annoy Mode: OFF")
        if connections.annoyThread then
            task.cancel(connections.annoyThread)
            connections.annoyThread = nil
        end
    else
        local username = trollElements.annoyInput.Text
        if username == "" then
            notify("Error", "Please enter a username to annoy", 3, "error")
            return
        end
        
        local targets = findPlayer(username)
        if #targets > 0 then
            trollSettings.annoyTarget = targets[1]
            states.annoyMode = true
            updateButtonState(trollElements.annoyBtn, true, "Annoy Mode: ON", "Annoy Mode: OFF")
            connections.annoyThread = task.spawn(annoyModeLoop)
            notify("Annoy", "Annoying " .. targets[1].Name, 3, "success")
        else
            notify("Error", "Player not found", 3, "error")
        end
    end
end)

-- PVP buttons (ESP/Tracers preserved exactly)
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

pvpElements.tracerBtn.MouseButton1Click:Connect(function()
    espSettings.Tracers = not espSettings.Tracers
    if espSettings.Tracers then
        updateButtonState(pvpElements.tracerBtn, true, "Tracers: ON", "Tracers: OFF")
    else
        updateButtonState(pvpElements.tracerBtn, false, "Tracers: ON", "Tracers: OFF")
        for _, tracerLine in pairs(espSettings.TracerLines) do
            if tracerLine then tracerLine.Visible = false end
        end
    end
end)

pvpElements.invincibleBtn.MouseButton1Click:Connect(function()
    states.invincible = not states.invincible
    if states.invincible then
        updateButtonState(pvpElements.invincibleBtn, true, "Invincible: ON", "Invincible: OFF")
        enableInvincibility()
    else
        updateButtonState(pvpElements.invincibleBtn, false, "Invincible: ON", "Invincible: OFF")
        disableInvincibility()
    end
end)

pvpElements.aimbotBtn.MouseButton1Click:Connect(function()
    aimbotSettings.Enabled = not aimbotSettings.Enabled
    if aimbotSettings.Enabled then
        updateButtonState(pvpElements.aimbotBtn, true, "Aimbot: ON", "Aimbot: OFF")
        
        if aimbotSettings.Connection then aimbotSettings.Connection:Disconnect() end
        
        aimbotSettings.Connection = Services.RunService.RenderStepped:Connect(function()
            aimbotSettings.Active = Services.UserInputService:IsKeyDown(aimbotSettings.ActivationKey)
            if aimbotSettings.Active then
                local enemy = findClosestEnemy()
                if enemy then
                    local targetPart = enemy:FindFirstChild(aimbotSettings.TargetPart)
                    if targetPart then
                        smoothAim(targetPart.Position)
                        createTween(pvpElements.aimbotBtn, 0.1, { BackgroundColor3 = Color3.fromRGB(0, 255, 0) }):Play()
                    end
                end
            else
                createTween(pvpElements.aimbotBtn, 0.1, { BackgroundColor3 = theme.success:lerp(theme.secondary, 0.7) }):Play()
            end
        end)
    else
        updateButtonState(pvpElements.aimbotBtn, false, "Aimbot: ON", "Aimbot: OFF")
        if aimbotSettings.Connection then
            aimbotSettings.Connection:Disconnect()
            aimbotSettings.Connection = nil
        end
    end
end)

pvpElements.triggerbotBtn.MouseButton1Click:Connect(function()
    states.triggerbot = not states.triggerbot
    if states.triggerbot then
        updateButtonState(pvpElements.triggerbotBtn, true, "Triggerbot: ON", "Triggerbot: OFF")
        connections.triggerbotThread = task.spawn(triggerbotLoop)
    else
        updateButtonState(pvpElements.triggerbotBtn, false, "Triggerbot: ON", "Triggerbot: OFF")
        if connections.triggerbotThread then
            task.cancel(connections.triggerbotThread)
            connections.triggerbotThread = nil
        end
    end
end)

pvpElements.hitboxBtn.MouseButton1Click:Connect(function()
    states.hitboxExpander = not states.hitboxExpander
    if states.hitboxExpander then
        updateButtonState(pvpElements.hitboxBtn, true, "Hit Box Expander: ON", "Hit Box Expander: OFF")
        expandHitBoxes(true)
    else
        updateButtonState(pvpElements.hitboxBtn, false, "Hit Box Expander: ON", "Hit Box Expander: OFF")
        expandHitBoxes(false)
    end
end)

pvpElements.antiKickBtn.MouseButton1Click:Connect(function()
    states.antiKick = not states.antiKick
    updateButtonState(pvpElements.antiKickBtn, states.antiKick, "Anti-Kick: ON", "Anti-Kick: OFF")
end)

pvpElements.antiDetectionBtn.MouseButton1Click:Connect(function()
    states.antiDetection = not states.antiDetection
    updateButtonState(pvpElements.antiDetectionBtn, states.antiDetection, "Anti-Detection: ON", "Anti-Detection: OFF")
end)

-- Utility functionality
utilityElements.rejoinBtn.MouseButton1Click:Connect(function()
    Services.TeleportService:Teleport(game.PlaceId, player)
end)

utilityElements.hopBtn.MouseButton1Click:Connect(function()
    -- Fixed server hop to find smallest server
    local success, response = pcall(function()
        return Services.HttpService:JSONDecode(game:HttpGet(
            ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100")
            :format(game.PlaceId)
        ))
    end)
    
    if success and response.data then
        -- Sort servers by player count (ascending)
        table.sort(response.data, function(a, b)
            return a.playing < b.playing
        end)
        
        -- Find the smallest server that's not the current one
        for _, srv in pairs(response.data) do
            if srv.id ~= game.JobId then
                Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, player)
                notify("Server Hop", "Found server with " .. srv.playing .. " players", 3, "success")
                return
            end
        end
        
        notify("Error", "No other servers found", 3, "error")
    else
        notify("Error", "Failed to find servers", 3, "error")
    end
end)

utilityElements.antiAfkBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(getconnections(player.Idled)) do
        v:Disable()
    end
    notify("Anti-AFK", "Successfully enabled!", 4, "success")
end)

utilityElements.fpsBtn.MouseButton1Click:Connect(function()
    if setfpscap then
        setfpscap(999)
        notify("FPS Unlock", "Successfully unlocked FPS!", 4, "success")
    else
        notify("Error", "Executor doesn't support setfpscap", 3, "error")
    end
end)

utilityElements.suncBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/HummingBird8/HummingRn/main/sUNCTestGET"))()
    notify("UNC Test", "sUNC test loaded", 3, "success")
end)

utilityElements.uncBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Global/UNC-Test.lua"))()
    notify("UNC Test", "UNC test loaded", 3, "success")
end)

-- CHARACTER RESPAWN HANDLING
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    applyCharacterSettings()
    
    -- Restore states after respawn
    task.wait(1)
    
    if states.flight then
        enableFlight()
        updateButtonState(mainElements.flightBtn, true, "Flight: ON", "Flight: OFF")
    end
    
    if states.noclip then
        enableNoclip()
        updateButtonState(mainElements.noclipBtn, true, "Noclip: ON", "Noclip: OFF")
    end
    
    if states.invincible then
        enableInvincibility()
    end
    
    if states.hitboxExpander then
        expandHitBoxes(true)
    end
    
    if espSettings.Enabled then
        setupESP()
    end
end)

-- Initialize character settings
applyCharacterSettings()

-- Anti-detection setup
if states.antiDetection and not Services.ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = Services.ReplicatedStorage
end

-- CORE LOOPS AND UPDATES
local lastUpdate = 0
Services.RunService.Heartbeat:Connect(function()
    local now = tick()
    
    -- Update character settings every frame
    applyCharacterSettings()
    
    -- Update ESP at reduced rate for performance
    if now - lastUpdate >= 0.1 and espSettings.Enabled and gui.screen.Enabled then
        lastUpdate = now
        updatePlayerESP()
    end
end)

-- Clean viewport scaling on resize
Services.Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    local newScale = calculateScale()
    if math.abs(newScale - config.guiScale) > 0.1 then
        config.guiScale = newScale
        
        -- Update GUI scaling smoothly
        local targetHeight = (tabHeights[config.currentTab] + config.titleBarHeight + config.tabBarHeight + 20) * config.guiScale
        createTween(gui.main, 0.3, {
            Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, targetHeight)
        }):Play()
        
        -- Update text sizes
        gui.title.TextSize = math.floor(16 * config.guiScale)
        versionLabel.TextSize = math.floor(9 * config.guiScale)
        gui.minimizeBtn.TextSize = math.floor(12 * config.guiScale)
        gui.closeBtn.TextSize = math.floor(12 * config.guiScale)
        
        for _, tab in pairs(tabButtons) do
            tab.TextSize = math.floor(9 * config.guiScale)
        end
    end
end)

-- CLEANUP ON GUI DESTRUCTION
gui.screen.Destroying:Connect(function()
    -- Clean up all connections
    for _, connection in pairs(connections) do
        if connection and typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        elseif connection and typeof(connection) == "thread" then
            task.cancel(connection)
        end
    end
    
    -- Clean up states
    if states.flight then
        disableFlight()
    end
    
    if states.noclip then
        disableNoclip()
    end
    
    clearAllESP()
    
    if states.invincible then
        disableInvincibility()
    end
    
    if states.hitboxExpander then
        expandHitBoxes(false)
    end
    
    if aimbotSettings.Connection then
        aimbotSettings.Connection:Disconnect()
    end
    
    if states.fakeLag then
        disableFakeLag()
    end
    
    -- Reset workspace settings
    Services.Workspace.FallenPartsDestroyHeight = scriptEnv.FPDH
    
    notify("s0ulz GUI", "GUI closed and cleaned up", 3)
end)

-- INITIAL GUI SETUP AND ANIMATION
task.wait(0.1)
gui.screen.Enabled = true
gui.main.Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, config.titleBarHeight)

-- Clean entry animation
local function initializeGUI()
    local targetHeight = (tabHeights[config.currentTab] + config.titleBarHeight + config.tabBarHeight + 20) * config.guiScale
    local sizeTween = createTween(gui.main, 0.5, {
        Size = UDim2.new(0, config.baseWidth * config.guiScale, 0, targetHeight),
        BackgroundTransparency = 0
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    
    sizeTween:Play()
    
    -- Animate shadow
    createTween(shadow, 0.5, {
        BackgroundTransparency = 0.6
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
    
    -- Stagger tab animations
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

-- Initialize with smooth animation
task.spawn(initializeGUI)

-- Welcome sequence
task.wait(1.2)
notify("s0ulz GUI V4", "loaded successfully! Have fun!", 5, "success")
task.wait(0.6)
notify("Info", "Click F4 to open/close the GUI")
