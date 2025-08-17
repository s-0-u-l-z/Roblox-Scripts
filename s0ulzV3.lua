-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VoiceChatService = game:GetService("VoiceChatService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Local player reference
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables for functionality
local currentSpeed = 16
local currentJump = 50
local flightSpeed = 50

-- Apply character settings function
local function applyCharacterSettings()
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.WalkSpeed = currentSpeed
            humanoid.JumpPower = currentJump
        end
    end
end

-- Script environment for storing values
local scriptEnv = {
    FPDH = workspace.FallenPartsDestroyHeight,
    OldPos = nil
}

game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "s0ulz GUI";
    Text = "Jesus Loves you";
    Duration = 5
})

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Info";
    Text = "Click F4 to open and close the GUI";
    Duration = 10
})

-- Vibrant Color Scheme
local colors = {
    background = Color3.fromRGB(15, 15, 20),
    primary = Color3.fromRGB(0, 170, 255),   -- Bright blue
    secondary = Color3.fromRGB(30, 30, 40),
    text = Color3.fromRGB(240, 240, 240),
    error = Color3.fromRGB(255, 80, 80),      -- Bright red
    success = Color3.fromRGB(80, 255, 120),   -- Bright green
    warning = Color3.fromRGB(255, 200, 0),    -- Yellow
    noclip = Color3.fromRGB(0, 170, 255)
}

-- Font
local font = Enum.Font.GothamSemibold

-- Player search function
local function gplr(String)
    local Found = {}
    local strl = String:lower()
    if strl == "all" then
        for i,v in pairs(Players:GetPlayers()) do table.insert(Found,v) end
    elseif strl == "others" then
        for i,v in pairs(Players:GetPlayers()) do
            if v.Name ~= player.Name then table.insert(Found,v) end
        end 
    elseif strl == "me" then
        table.insert(Found, player)
    else
        for i,v in pairs(Players:GetPlayers()) do
            if v.Name:lower():sub(1, #String) == String:lower() then
                table.insert(Found,v)
            end
        end 
    end
    return Found 
end

-- Notification function
local function notif(str, dur)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "s0ulz GUI",
        Text = str,
        Duration = dur or 3
    })
end

-- Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.Enabled = false

-- Animation properties
local animationSpeed = 0.2
local hoverAnimationSpeed = 0.15

-- Increased main frame size to accommodate sliders
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = colors.background
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 400, 0, 550) -- Increased size to 400x550
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Parent = mainFrame
shadow.BackgroundTransparency = 1
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.ZIndex = -1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = colors.secondary
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 40)

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleBar
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Font = font
titleLabel.Text = "s0ulz GUI"
titleLabel.TextColor3 = colors.text
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Parent = titleBar
minimizeButton.BackgroundColor3 = colors.secondary
minimizeButton.Position = UDim2.new(1, -70, 0.5, -12)
minimizeButton.Size = UDim2.new(0, 24, 0, 24)
minimizeButton.Font = font
minimizeButton.Text = "-"
minimizeButton.TextColor3 = colors.text
minimizeButton.TextSize = 16
minimizeButton.ZIndex = 2

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Parent = titleBar
closeButton.BackgroundColor3 = colors.secondary
closeButton.Position = UDim2.new(1, -38, 0.5, -12)
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Font = font
closeButton.Text = "×"
closeButton.TextColor3 = colors.text
closeButton.TextSize = 16
closeButton.ZIndex = 2

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Button hover animations
local function setupButtonHover(button, hoverColor)
    local originalColor = button.BackgroundColor3
    hoverColor = hoverColor or Color3.new(
        math.min(originalColor.R * 1.3, 1),
        math.min(originalColor.G * 1.3, 1),
        math.min(originalColor.B * 1.3, 1)
    )
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(hoverAnimationSpeed), {
            BackgroundColor3 = hoverColor
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(hoverAnimationSpeed), {
            BackgroundColor3 = originalColor
        }):Play()
    end)
end

setupButtonHover(minimizeButton)
setupButtonHover(closeButton)

local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(mainFrame, TweenInfo.new(animationSpeed, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 400, 0, 40) -- Match new width
        }):Play()
        
        for _, child in pairs(mainFrame:GetChildren()) do
            if child ~= titleBar and child ~= corner and child ~= shadow and child.Name ~= "TabFrame" then
                TweenService:Create(child, TweenInfo.new(animationSpeed), {
                    BackgroundTransparency = 1
                }):Play()
            end
        end
        
        delay(animationSpeed, function()
            for _, child in pairs(mainFrame:GetChildren()) do
                if child ~= titleBar and child ~= corner and child ~= shadow and child.Name ~= "TabFrame" then
                    child.Visible = false
                end
            end
        end)
    else
        for _, child in pairs(mainFrame:GetChildren()) do
            if child ~= titleBar and child ~= corner and child ~= shadow and child.Name ~= "TabFrame" then
                child.Visible = true
                child.BackgroundTransparency = 1
            end
        end
        
        TweenService:Create(mainFrame, TweenInfo.new(animationSpeed, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 400, 0, 550) -- Match new size
        }):Play()
        
        delay(animationSpeed/2, function()
            for _, child in pairs(mainFrame:GetChildren()) do
                if child ~= titleBar and child ~= corner and child ~= shadow and child.Name ~= "TabFrame" then
                    TweenService:Create(child, TweenInfo.new(animationSpeed), {
                        BackgroundTransparency = 0
                    }):Play()
                end
            end
        end)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(animationSpeed), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    delay(animationSpeed, function()
        screenGui:Destroy()
    end)
end)

-- Tab System
local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.Parent = mainFrame
tabFrame.BackgroundTransparency = 1
tabFrame.Position = UDim2.new(0, 0, 0, 45)
tabFrame.Size = UDim2.new(1, 0, 0, 36)

-- Updated tabs to include UNC and Utility
local tabs = {"Main", "Teleport", "Troll", "Scripts", "Games", "PVP", "UNC", "Utility"}
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName .. "Tab"
    tabButton.Parent = tabFrame
    tabButton.BackgroundColor3 = colors.secondary
    tabButton.Position = UDim2.new((i-1) * (1/#tabs), 2, 0, 4)
    tabButton.Size = UDim2.new((1/#tabs) - 0.01, 0, 1, -8)
    tabButton.Font = font
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.TextSize = 12
    tabButton.TextScaled = true

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabButton
    
    setupButtonHover(tabButton)

    tabButtons[tabName] = tabButton
end

local contentArea = Instance.new("Frame")
contentArea.Parent = mainFrame
contentArea.BackgroundTransparency = 1
contentArea.Position = UDim2.new(0, 10, 0, 90)
contentArea.Size = UDim2.new(1, -20, 1, -100)

-- Main Tab Content
local mainContent = Instance.new("Frame")
mainContent.Name = "MainContent"
mainContent.Parent = contentArea
mainContent.BackgroundTransparency = 1
mainContent.Size = UDim2.new(1, 0, 1, 0)
mainContent.Visible = true
mainContent.BackgroundTransparency = 0
mainContent.BackgroundColor3 = colors.background
mainContent.ClipsDescendants = true

-- Enhanced Slider Creation Function (FIXED)
local function createEnhancedSlider(parent, labelText, minValue, maxValue, currentValue, callback)
    local container = Instance.new("Frame")
    container.Parent = parent
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 50) -- Increased height
    
    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = container
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.Font = font
    titleLabel.Text = labelText
    titleLabel.TextColor3 = colors.text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Value Label
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = container
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -40, 0, 0)
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Font = font
    valueLabel.Text = tostring(currentValue)
    valueLabel.TextColor3 = colors.text
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    -- Track
    local track = Instance.new("Frame")
    track.Parent = container
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    track.Position = UDim2.new(0, 0, 0, 30) -- Adjusted position
    track.Size = UDim2.new(1, 0, 0, 10) -- Increased height
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 5)
    trackCorner.Parent = track
    
    -- Fill
    local fill = Instance.new("Frame")
    fill.Parent = track
    fill.BackgroundColor3 = colors.primary
    fill.Size = UDim2.new((currentValue - minValue)/(maxValue - minValue), 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 5)
    fillCorner.Parent = fill
    
    -- Thumb
    local thumb = Instance.new("Frame")
    thumb.Parent = track
    thumb.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    thumb.Size = UDim2.new(0, 24, 0, 24) -- Increased size
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new((currentValue - minValue)/(maxValue - minValue), 0, 0.5, 0)
    thumb.ZIndex = 2
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    
    local thumbInner = Instance.new("Frame")
    thumbInner.Parent = thumb
    thumbInner.BackgroundColor3 = colors.primary
    thumbInner.Size = UDim2.new(0, 14, 0, 14) -- Increased size
    thumbInner.AnchorPoint = Vector2.new(0.5, 0.5)
    thumbInner.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local thumbInnerCorner = Instance.new("UICorner")
    thumbInnerCorner.CornerRadius = UDim.new(1, 0)
    thumbInnerCorner.Parent = thumbInner
    
    -- Dragging logic (FIXED to prevent GUI dragging)
    local dragging = false
    
    local function updateSlider(value)
        value = math.clamp(value, minValue, maxValue)
        local percent = (value - minValue)/(maxValue - minValue)
        
        -- Animate slider changes
        TweenService:Create(fill, TweenInfo.new(0.1), {
            Size = UDim2.new(percent, 0, 1, 0)
        }):Play()
        
        TweenService:Create(thumb, TweenInfo.new(0.1), {
            Position = UDim2.new(percent, 0, 0.5, 0)
        }):Play()
        
        valueLabel.Text = tostring(math.round(value))
        callback(value)
    end
    
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            -- Disable GUI dragging while slider is active
            mainFrame.Active = false
            
            -- Pulse animation
            TweenService:Create(thumb, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 28, 0, 28)
            }):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = track.AbsolutePosition
            local trackSize = track.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
            local value = minValue + (maxValue - minValue) * relativeX
            updateSlider(value)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            -- Re-enable GUI dragging
            mainFrame.Active = true
            
            -- Return to normal size
            TweenService:Create(thumb, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 24, 0, 24)
            }):Play()
        end
    end)
    
    -- Make entire track clickable
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = track.AbsolutePosition
            local trackSize = track.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
            local value = minValue + (maxValue - minValue) * relativeX
            updateSlider(value)
        end
    end)
    
    return updateSlider
end

-- Speed Slider
local speedContainer = Instance.new("Frame")
speedContainer.Parent = mainContent
speedContainer.BackgroundTransparency = 1
speedContainer.Position = UDim2.new(0, 0, 0, 10)
speedContainer.Size = UDim2.new(1, 0, 0, 50) -- Increased height

local updateSpeedSlider = createEnhancedSlider(speedContainer, "Speed", 16, 10000, 16, function(value)
    currentSpeed = value
    applyCharacterSettings()
end)

-- Jump Power Slider
local jumpContainer = Instance.new("Frame")
jumpContainer.Parent = mainContent
jumpContainer.BackgroundTransparency = 1
jumpContainer.Position = UDim2.new(0, 0, 0, 70) -- Adjusted position
jumpContainer.Size = UDim2.new(1, 0, 0, 50) -- Increased height

local updateJumpSlider = createEnhancedSlider(jumpContainer, "Jump Power", 50, 500, 50, function(value)
    currentJump = value
    applyCharacterSettings()
end)

-- Flight Speed Slider
local flightSpeedContainer = Instance.new("Frame")
flightSpeedContainer.Parent = mainContent
flightSpeedContainer.BackgroundTransparency = 1
flightSpeedContainer.Position = UDim2.new(0, 0, 0, 130) -- Adjusted position
flightSpeedContainer.Size = UDim2.new(1, 0, 0, 50) -- Increased height

local updateFlightSpeedSlider = createEnhancedSlider(flightSpeedContainer, "Flight Speed", 10, 200, 50, function(value)
    flightSpeed = value
    if flightEnabled then
        disableFlight()
        enableFlight()
    end
end)

-- Flight Toggle
local flightButton = Instance.new("TextButton")
flightButton.Parent = mainContent
flightButton.BackgroundColor3 = colors.secondary
flightButton.Position = UDim2.new(0, 0, 0, 190) -- Adjusted position
flightButton.Size = UDim2.new(1, 0, 0, 32)
flightButton.Font = font
flightButton.Text = "Flight: OFF"
flightButton.TextColor3 = colors.error
flightButton.TextSize = 14

local flightCorner = Instance.new("UICorner")
flightCorner.CornerRadius = UDim.new(0, 6)
flightCorner.Parent = flightButton

setupButtonHover(flightButton, colors.primary)

-- Noclip Toggle
local noclipButton = Instance.new("TextButton")
noclipButton.Parent = mainContent
noclipButton.BackgroundColor3 = colors.noclip
noclipButton.Position = UDim2.new(0, 0, 0, 230) -- Adjusted position
noclipButton.Size = UDim2.new(1, 0, 0, 32)
noclipButton.Font = font
noclipButton.Text = "Noclip: OFF"
noclipButton.TextColor3 = colors.text
noclipButton.TextSize = 14

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 6)
noclipCorner.Parent = noclipButton

setupButtonHover(noclipButton, Color3.new(0.8, 0.6, 0.9))

-- Teleport Tab Content
local teleportContent = Instance.new("Frame")
teleportContent.Name = "TeleportContent"
teleportContent.Parent = contentArea
teleportContent.BackgroundTransparency = 1
teleportContent.Size = UDim2.new(1, 0, 1, 0)
teleportContent.Visible = false
teleportContent.BackgroundTransparency = 0
teleportContent.BackgroundColor3 = colors.background
teleportContent.ClipsDescendants = true

local playerInput = Instance.new("TextBox")
playerInput.Parent = teleportContent
playerInput.BackgroundColor3 = colors.secondary
playerInput.Position = UDim2.new(0, 0, 0, 10)
playerInput.Size = UDim2.new(1, 0, 0, 32)
playerInput.Font = font
playerInput.PlaceholderText = "Enter player username..."
playerInput.Text = ""
playerInput.TextColor3 = colors.text
playerInput.TextSize = 14
playerInput.ClearTextOnFocus = false

local playerInputCorner = Instance.new("UICorner")
playerInputCorner.CornerRadius = UDim.new(0, 6)
playerInputCorner.Parent = playerInput

local teleportButton = Instance.new("TextButton")
teleportButton.Parent = teleportContent
teleportButton.BackgroundColor3 = colors.primary
teleportButton.Position = UDim2.new(0, 0, 0, 50)
teleportButton.Size = UDim2.new(1, 0, 0, 32)
teleportButton.Font = font
teleportButton.Text = "Teleport"
teleportButton.TextColor3 = colors.text
teleportButton.TextSize = 14

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 6)
teleportCorner.Parent = teleportButton

setupButtonHover(teleportButton)

local infiniteTeleportButton = Instance.new("TextButton")
infiniteTeleportButton.Parent = teleportContent
infiniteTeleportButton.BackgroundColor3 = colors.secondary
infiniteTeleportButton.Position = UDim2.new(0, 0, 0, 90)
infiniteTeleportButton.Size = UDim2.new(1, 0, 0, 32)
infiniteTeleportButton.Font = font
infiniteTeleportButton.Text = "Infinite Teleport: OFF"
infiniteTeleportButton.TextColor3 = colors.text
infiniteTeleportButton.TextSize = 14

local infTeleportCorner = Instance.new("UICorner")
infTeleportCorner.CornerRadius = UDim.new(0, 6)
infTeleportCorner.Parent = infiniteTeleportButton

setupButtonHover(infiniteTeleportButton)

-- Troll Tab Content
local trollContent = Instance.new("Frame")
trollContent.Name = "TrollContent"
trollContent.Parent = contentArea
trollContent.BackgroundTransparency = 1
trollContent.Size = UDim2.new(1, 0, 1, 0)
trollContent.Visible = false
trollContent.BackgroundTransparency = 0
trollContent.BackgroundColor3 = colors.background
trollContent.ClipsDescendants = true

-- Player Input for Fling
local playerFlingInput = Instance.new("TextBox")
playerFlingInput.Parent = trollContent
playerFlingInput.BackgroundColor3 = colors.secondary
playerFlingInput.Position = UDim2.new(0, 0, 0, 10)
playerFlingInput.Size = UDim2.new(1, 0, 0, 32)
playerFlingInput.Font = font
playerFlingInput.PlaceholderText = "Enter player username to fling..."
playerFlingInput.Text = ""
playerFlingInput.TextColor3 = colors.text
playerFlingInput.TextSize = 14
playerFlingInput.ClearTextOnFocus = false

local playerFlingInputCorner = Instance.new("UICorner")
playerFlingInputCorner.CornerRadius = UDim.new(0, 6)
playerFlingInputCorner.Parent = playerFlingInput

-- Fling Player Button
local flingPlayerButton = Instance.new("TextButton")
flingPlayerButton.Parent = trollContent
flingPlayerButton.BackgroundColor3 = colors.primary
flingPlayerButton.Position = UDim2.new(0, 0, 0, 50)
flingPlayerButton.Size = UDim2.new(1, 0, 0, 32)
flingPlayerButton.Font = font
flingPlayerButton.Text = "Fling Player"
flingPlayerButton.TextColor3 = colors.text
flingPlayerButton.TextSize = 14

local flingPlayerCorner = Instance.new("UICorner")
flingPlayerCorner.CornerRadius = UDim.new(0, 6)
flingPlayerCorner.Parent = flingPlayerButton

setupButtonHover(flingPlayerButton)

-- Fling All Button
local flingAllButton = Instance.new("TextButton")
flingAllButton.Parent = trollContent
flingAllButton.BackgroundColor3 = colors.error
flingAllButton.Position = UDim2.new(0, 0, 0, 90)
flingAllButton.Size = UDim2.new(1, 0, 0, 32)
flingAllButton.Font = font
flingAllButton.Text = "Fling Everyone"
flingAllButton.TextColor3 = colors.text
flingAllButton.TextSize = 14

local flingAllCorner = Instance.new("UICorner")
flingAllCorner.CornerRadius = UDim.new(0, 6)
flingAllCorner.Parent = flingAllButton

setupButtonHover(flingAllButton)

-- Touch Fling Button
local touchFlingButton = Instance.new("TextButton")
touchFlingButton.Parent = trollContent
touchFlingButton.BackgroundColor3 = colors.secondary
touchFlingButton.Position = UDim2.new(0, 0, 0, 130)
touchFlingButton.Size = UDim2.new(1, 0, 0, 32)
touchFlingButton.Font = font
touchFlingButton.Text = "Touch Fling: OFF"
touchFlingButton.TextColor3 = colors.text
touchFlingButton.TextSize = 14

local touchFlingCorner = Instance.new("UICorner")
touchFlingCorner.CornerRadius = UDim.new(0, 6)
touchFlingCorner.Parent = touchFlingButton

setupButtonHover(touchFlingButton)

-- Scripts Tab Content
local scriptsContent = Instance.new("Frame")
scriptsContent.Name = "ScriptsContent"
scriptsContent.Parent = contentArea
scriptsContent.BackgroundTransparency = 1
scriptsContent.Size = UDim2.new(1, 0, 1, 0)
scriptsContent.Visible = false
scriptsContent.BackgroundTransparency = 0
scriptsContent.BackgroundColor3 = colors.background
scriptsContent.ClipsDescendants = true

-- Create a scrolling frame for the scripts content
local scriptsScroll = Instance.new("ScrollingFrame")
scriptsScroll.Parent = scriptsContent
scriptsScroll.BackgroundTransparency = 1
scriptsScroll.Size = UDim2.new(1, 0, 1, 0)
scriptsScroll.CanvasSize = UDim2.new(0, 0, 0, 520)
scriptsScroll.ScrollBarThickness = 6
scriptsScroll.ScrollBarImageColor3 = colors.secondary

-- Use a list layout instead of grid
local scriptsListLayout = Instance.new("UIListLayout")
scriptsListLayout.Parent = scriptsScroll
scriptsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
scriptsListLayout.Padding = UDim.new(0, 10)

-- Create section label for regular scripts
local regularScriptsLabel = Instance.new("TextLabel")
regularScriptsLabel.Parent = scriptsScroll
regularScriptsLabel.BackgroundTransparency = 1
regularScriptsLabel.Size = UDim2.new(1, 0, 0, 20)
regularScriptsLabel.Font = font
regularScriptsLabel.Text = "Regular Scripts"
regularScriptsLabel.TextColor3 = colors.text
regularScriptsLabel.TextSize = 14
regularScriptsLabel.TextXAlignment = Enum.TextXAlignment.Left
regularScriptsLabel.LayoutOrder = 1

-- Invis button
local invisibilityButton = Instance.new("TextButton")
invisibilityButton.Parent = scriptsScroll
invisibilityButton.BackgroundColor3 = colors.secondary
invisibilityButton.Size = UDim2.new(1, 0, 0, 36)
invisibilityButton.Font = font
invisibilityButton.Text = "Invisibility"
invisibilityButton.TextColor3 = colors.text
invisibilityButton.TextSize = 14
invisibilityButton.LayoutOrder = 2

local invisibilityCorner = Instance.new("UICorner")
invisibilityCorner.CornerRadius = UDim.new(0, 6)
invisibilityCorner.Parent = invisibilityButton

setupButtonHover(invisibilityButton)

-- IY Button
local iyButton = Instance.new("TextButton")
iyButton.Parent = scriptsScroll
iyButton.BackgroundColor3 = colors.secondary
iyButton.Size = UDim2.new(1, 0, 0, 36)
iyButton.Font = font
iyButton.Text = "IY (Infinite Yield)"
iyButton.TextColor3 = colors.text
iyButton.TextSize = 14
iyButton.LayoutOrder = 3

local iyCorner = Instance.new("UICorner")
iyCorner.CornerRadius = UDim.new(0, 6)
iyCorner.Parent = iyButton

setupButtonHover(iyButton)

-- Bird Poop Button
local birdPoopButton = Instance.new("TextButton")
birdPoopButton.Parent = scriptsScroll
birdPoopButton.BackgroundColor3 = colors.secondary
birdPoopButton.Size = UDim2.new(1, 0, 0, 36)
birdPoopButton.Font = font
birdPoopButton.Text = "Bird Poop"
birdPoopButton.TextColor3 = colors.text
birdPoopButton.TextSize = 14
birdPoopButton.LayoutOrder = 4

local birdPoopCorner = Instance.new("UICorner")
birdPoopCorner.CornerRadius = UDim.new(0, 6)
birdPoopCorner.Parent = birdPoopButton

setupButtonHover(birdPoopButton)

-- ChatAdmin Button
local chatAdminButton = Instance.new("TextButton")
chatAdminButton.Parent = scriptsScroll
chatAdminButton.BackgroundColor3 = colors.secondary
chatAdminButton.Size = UDim2.new(1, 0, 0, 36)
chatAdminButton.Font = font
chatAdminButton.Text = "ChatAdmin"
chatAdminButton.TextColor3 = colors.text
chatAdminButton.TextSize = 14
chatAdminButton.LayoutOrder = 5

local chatAdminCorner = Instance.new("UICorner")
chatAdminCorner.CornerRadius = UDim.new(0, 6)
chatAdminCorner.Parent = chatAdminButton

setupButtonHover(chatAdminButton)

-- VC-Unban Button
local vcUnbanButton = Instance.new("TextButton")
vcUnbanButton.Parent = scriptsScroll
vcUnbanButton.BackgroundColor3 = colors.secondary
vcUnbanButton.Size = UDim2.new(1, 0, 0, 36)
vcUnbanButton.Font = font
vcUnbanButton.Text = "VC-Unban"
vcUnbanButton.TextColor3 = colors.text
vcUnbanButton.TextSize = 14
vcUnbanButton.LayoutOrder = 6

local vcUnbanCorner = Instance.new("UICorner")
vcUnbanCorner.CornerRadius = UDim.new(0, 6)
vcUnbanCorner.Parent = vcUnbanButton

setupButtonHover(vcUnbanButton)

-- Super Ring Parts Button
local superRingButton = Instance.new("TextButton")
superRingButton.Parent = scriptsScroll
superRingButton.BackgroundColor3 = colors.secondary
superRingButton.Size = UDim2.new(1, 0, 0, 36)
superRingButton.Font = font
superRingButton.Text = "Super Ring Parts"
superRingButton.TextColor3 = colors.text
superRingButton.TextSize = 14
superRingButton.LayoutOrder = 7

local superRingCorner = Instance.new("UICorner")
superRingCorner.CornerRadius = UDim.new(0, 6)
superRingCorner.Parent = superRingButton

setupButtonHover(superRingButton)

-- Create section label for bypassers
local bypassersLabel = Instance.new("TextLabel")
bypassersLabel.Parent = scriptsScroll
bypassersLabel.BackgroundTransparency = 1
bypassersLabel.Size = UDim2.new(1, 0, 0, 20)
bypassersLabel.Font = font
bypassersLabel.Text = "Bypassers"
bypassersLabel.TextColor3 = colors.text
bypassersLabel.TextSize = 14
bypassersLabel.TextXAlignment = Enum.TextXAlignment.Left
bypassersLabel.LayoutOrder = 8

-- SaturnBypasser Button
local saturnBypassButton = Instance.new("TextButton")
saturnBypassButton.Parent = scriptsScroll
saturnBypassButton.BackgroundColor3 = colors.secondary
saturnBypassButton.Size = UDim2.new(1, 0, 0, 36)
saturnBypassButton.Font = font
saturnBypassButton.Text = "SaturnBypasser"
saturnBypassButton.TextColor3 = colors.text
saturnBypassButton.TextSize = 14
saturnBypassButton.LayoutOrder = 9

local saturnBypassCorner = Instance.new("UICorner")
saturnBypassCorner.CornerRadius = UDim.new(0, 6)
saturnBypassCorner.Parent = saturnBypassButton

setupButtonHover(saturnBypassButton)

-- CatBypasser Button
local catBypassButton = Instance.new("TextButton")
catBypassButton.Parent = scriptsScroll
catBypassButton.BackgroundColor3 = colors.secondary
catBypassButton.Size = UDim2.new(1, 0, 0, 36)
catBypassButton.Font = font
catBypassButton.Text = "CatBypasser"
catBypassButton.TextColor3 = colors.text
catBypassButton.TextSize = 14
catBypassButton.LayoutOrder = 10

local catBypassCorner = Instance.new("UICorner")
catBypassCorner.CornerRadius = UDim.new(0, 6)
catBypassCorner.Parent = catBypassButton

setupButtonHover(catBypassButton)

-- BetterBypasser Button
local betterBypassButton = Instance.new("TextButton")
betterBypassButton.Parent = scriptsScroll
betterBypassButton.BackgroundColor3 = colors.secondary
betterBypassButton.Size = UDim2.new(1, 0, 0, 36)
betterBypassButton.Font = font
betterBypassButton.Text = "BetterBypasser"
betterBypassButton.TextColor3 = colors.text
betterBypassButton.TextSize = 14
betterBypassButton.LayoutOrder = 11

local betterBypassCorner = Instance.new("UICorner")
betterBypassCorner.CornerRadius = UDim.new(0, 6)
betterBypassCorner.Parent = betterBypassButton

setupButtonHover(betterBypassButton)

-- FeuralBypasser Button
local feuralBypassButton = Instance.new("TextButton")
feuralBypassButton.Parent = scriptsScroll
feuralBypassButton.BackgroundColor3 = colors.secondary
feuralBypassButton.Size = UDim2.new(1, 0, 0, 36)
feuralBypassButton.Font = font
feuralBypassButton.Text = "FeuralBypasser"
feuralBypassButton.TextColor3 = colors.text
feuralBypassButton.TextSize = 14
feuralBypassButton.LayoutOrder = 12

local feuralBypassCorner = Instance.new("UICorner")
feuralBypassCorner.CornerRadius = UDim.new(0, 6)
feuralBypassCorner.Parent = feuralBypassButton

setupButtonHover(feuralBypassButton)

-- Games Tab Content
local gamesContent = Instance.new("Frame")
gamesContent.Name = "GamesContent"
gamesContent.Parent = contentArea
gamesContent.BackgroundTransparency = 1
gamesContent.Size = UDim2.new(1, 0, 1, 0)
gamesContent.Visible = false
gamesContent.BackgroundTransparency = 0
gamesContent.BackgroundColor3 = colors.background
gamesContent.ClipsDescendants = true

local gamesScroll = Instance.new("ScrollingFrame")
gamesScroll.Parent = gamesContent
gamesScroll.BackgroundTransparency = 1
gamesScroll.Size = UDim2.new(1, 0, 1, 0)
gamesScroll.CanvasSize = UDim2.new(0, 0, 0, 270)
gamesScroll.ScrollBarThickness = 6
gamesScroll.ScrollBarImageColor3 = colors.secondary

-- Grid layout for game buttons
local gamesGridLayout = Instance.new("UIGridLayout")
gamesGridLayout.Parent = gamesScroll
gamesGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gamesGridLayout.CellPadding = UDim2.new(0, 5, 0, 10)
gamesGridLayout.CellSize = UDim2.new(0.5, -5, 0, 36)
gamesGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gamesGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
gamesGridLayout.StartCorner = Enum.StartCorner.TopLeft

-- Basketball Legends Button
local basketballButton = Instance.new("TextButton")
basketballButton.Parent = gamesScroll
basketballButton.BackgroundColor3 = colors.secondary
basketballButton.Font = font
basketballButton.Text = "Basketball Legends"
basketballButton.TextColor3 = colors.text
basketballButton.TextSize = 14
basketballButton.LayoutOrder = 1

local basketballCorner = Instance.new("UICorner")
basketballCorner.CornerRadius = UDim.new(0, 6)
basketballCorner.Parent = basketballButton

setupButtonHover(basketballButton)

-- Blox Fruits Button
local bloxFruitsButton = Instance.new("TextButton")
bloxFruitsButton.Parent = gamesScroll
bloxFruitsButton.BackgroundColor3 = colors.secondary
bloxFruitsButton.Font = font
bloxFruitsButton.Text = "Blox Fruits"
bloxFruitsButton.TextColor3 = colors.text
bloxFruitsButton.TextSize = 14
bloxFruitsButton.LayoutOrder = 2

local bloxFruitsCorner = Instance.new("UICorner")
bloxFruitsCorner.CornerRadius = UDim.new(0, 6)
bloxFruitsCorner.Parent = bloxFruitsButton

setupButtonHover(bloxFruitsButton)

-- TSB Button
local tsbButton = Instance.new("TextButton")
tsbButton.Parent = gamesScroll
tsbButton.BackgroundColor3 = colors.secondary
tsbButton.Font = font
tsbButton.Text = "TSB"
tsbButton.TextColor3 = colors.text
tsbButton.TextSize = 14
tsbButton.LayoutOrder = 3

local tsbCorner = Instance.new("UICorner")
tsbCorner.CornerRadius = UDim.new(0, 6)
tsbCorner.Parent = tsbButton

setupButtonHover(tsbButton)

-- DTI Button
local dtiButton = Instance.new("TextButton")
dtiButton.Parent = gamesScroll
dtiButton.BackgroundColor3 = colors.secondary
dtiButton.Font = font
dtiButton.Text = "DTI"
dtiButton.TextColor3 = colors.text
dtiButton.TextSize = 14
dtiButton.LayoutOrder = 4

local dtiCorner = Instance.new("UICorner")
dtiCorner.CornerRadius = UDim.new(0, 6)
dtiCorner.Parent = dtiButton

setupButtonHover(dtiButton)

-- Ink Game Button
local inkGameButton = Instance.new("TextButton")
inkGameButton.Parent = gamesScroll
inkGameButton.BackgroundColor3 = colors.secondary
inkGameButton.Font = font
inkGameButton.Text = "Ink Game"
inkGameButton.TextColor3 = colors.text
inkGameButton.TextSize = 14
inkGameButton.LayoutOrder = 5

local inkGameCorner = Instance.new("UICorner")
inkGameCorner.CornerRadius = UDim.new(0, 6)
inkGameCorner.Parent = inkGameButton

setupButtonHover(inkGameButton)

-- MM2 Button
local mm2Button = Instance.new("TextButton")
mm2Button.Parent = gamesScroll
mm2Button.BackgroundColor3 = colors.secondary
mm2Button.Font = font
mm2Button.Text = "MM2"
mm2Button.TextColor3 = colors.text
mm2Button.TextSize = 14
mm2Button.LayoutOrder = 6

local mm2Corner = Instance.new("UICorner")
mm2Corner.CornerRadius = UDim.new(0, 6)
mm2Corner.Parent = mm2Button

setupButtonHover(mm2Button)

-- PVP Tab Content
local pvpContent = Instance.new("Frame")
pvpContent.Name = "PVPContent"
pvpContent.Parent = contentArea
pvpContent.BackgroundTransparency = 1
pvpContent.Size = UDim2.new(1, 0, 1, 0)
pvpContent.Visible = false
pvpContent.BackgroundTransparency = 0
pvpContent.BackgroundColor3 = colors.background
pvpContent.ClipsDescendants = true

-- Create a scrolling frame for PVP content
local pvpScroll = Instance.new("ScrollingFrame")
pvpScroll.Parent = pvpContent
pvpScroll.BackgroundTransparency = 1
pvpScroll.Size = UDim2.new(1, 0, 1, 0)
pvpScroll.CanvasSize = UDim2.new(0, 0, 0, 280)
pvpScroll.ScrollBarThickness = 6
pvpScroll.ScrollBarImageColor3 = colors.secondary

-- ESP Toggle
local espToggle = Instance.new("TextButton")
espToggle.Parent = pvpScroll
espToggle.BackgroundColor3 = colors.secondary
espToggle.Position = UDim2.new(0, 0, 0, 10)
espToggle.Size = UDim2.new(1, 0, 0, 32)
espToggle.Font = font
espToggle.Text = "ESP: OFF"
espToggle.TextColor3 = colors.error
espToggle.TextSize = 14
espToggle.LayoutOrder = 1

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 6)
espCorner.Parent = espToggle

setupButtonHover(espToggle)

-- Tracer Toggle
local tracerToggle = Instance.new("TextButton")
tracerToggle.Parent = pvpScroll
tracerToggle.BackgroundColor3 = colors.secondary
tracerToggle.Position = UDim2.new(0, 0, 0, 50)
tracerToggle.Size = UDim2.new(1, 0, 0, 32)
tracerToggle.Font = font
tracerToggle.Text = "Tracers: OFF"
tracerToggle.TextColor3 = colors.error
tracerToggle.TextSize = 14
tracerToggle.LayoutOrder = 2

local tracerCorner = Instance.new("UICorner")
tracerCorner.CornerRadius = UDim.new(0, 6)
tracerCorner.Parent = tracerToggle

setupButtonHover(tracerToggle)

-- Invincible Toggle
local invincibleButton = Instance.new("TextButton")
invincibleButton.Parent = pvpScroll
invincibleButton.BackgroundColor3 = colors.secondary
invincibleButton.Position = UDim2.new(0, 0, 0, 90)
invincibleButton.Size = UDim2.new(1, 0, 0, 32)
invincibleButton.Font = font
invincibleButton.Text = "Invincible: OFF"
invincibleButton.TextColor3 = colors.error
invincibleButton.TextSize = 14
invincibleButton.LayoutOrder = 3

local invincibleCorner = Instance.new("UICorner")
invincibleCorner.CornerRadius = UDim.new(0, 6)
invincibleCorner.Parent = invincibleButton

setupButtonHover(invincibleButton)

-- Aimbot Toggle
local aimbotButton = Instance.new("TextButton")
aimbotButton.Parent = pvpScroll
aimbotButton.BackgroundColor3 = colors.secondary
aimbotButton.Position = UDim2.new(0, 0, 0, 130)
aimbotButton.Size = UDim2.new(1, 0, 0, 32)
aimbotButton.Font = font
aimbotButton.Text = "Aimbot: OFF"
aimbotButton.TextColor3 = colors.error
aimbotButton.TextSize = 14
aimbotButton.LayoutOrder = 4

local aimbotCorner = Instance.new("UICorner")
aimbotCorner.CornerRadius = UDim.new(0, 6)
aimbotCorner.Parent = aimbotButton

setupButtonHover(aimbotButton)

-- Triggerbot Toggle
local triggerbotButton = Instance.new("TextButton")
triggerbotButton.Parent = pvpScroll
triggerbotButton.BackgroundColor3 = colors.secondary
triggerbotButton.Position = UDim2.new(0, 0, 0, 170)
triggerbotButton.Size = UDim2.new(1, 0, 0, 32)
triggerbotButton.Font = font
triggerbotButton.Text = "Triggerbot: OFF"
triggerbotButton.TextColor3 = colors.error
triggerbotButton.TextSize = 14
triggerbotButton.LayoutOrder = 5

local triggerbotCorner = Instance.new("UICorner")
triggerbotCorner.CornerRadius = UDim.new(0, 6)
triggerbotCorner.Parent = triggerbotButton

setupButtonHover(triggerbotButton)

-- Hit Box Expander Toggle
local hitboxButton = Instance.new("TextButton")
hitboxButton.Parent = pvpScroll
hitboxButton.BackgroundColor3 = colors.secondary
hitboxButton.Position = UDim2.new(0, 0, 0, 210)
hitboxButton.Size = UDim2.new(1, 0, 0, 32)
hitboxButton.Font = font
hitboxButton.Text = "Hit Box Expander: OFF"
hitboxButton.TextColor3 = colors.error
hitboxButton.TextSize = 14
hitboxButton.LayoutOrder = 6

local hitboxCorner = Instance.new("UICorner")
hitboxCorner.CornerRadius = UDim.new(0, 6)
hitboxCorner.Parent = hitboxButton

setupButtonHover(hitboxButton)

-- Anti-Kick Toggle
local antiKickButton = Instance.new("TextButton")
antiKickButton.Parent = pvpScroll
antiKickButton.BackgroundColor3 = colors.secondary
antiKickButton.Position = UDim2.new(0, 0, 0, 250)
antiKickButton.Size = UDim2.new(1, 0, 0, 32)
antiKickButton.Font = font
antiKickButton.Text = "Anti-Kick: ON"
antiKickButton.TextColor3 = colors.success
antiKickButton.TextSize = 14
antiKickButton.LayoutOrder = 7

local antiKickCorner = Instance.new("UICorner")
antiKickCorner.CornerRadius = UDim.new(0, 6)
antiKickCorner.Parent = antiKickButton

setupButtonHover(antiKickButton)

-- Anti-Detection Toggle
local antiDetectionButton = Instance.new("TextButton")
antiDetectionButton.Parent = pvpScroll
antiDetectionButton.BackgroundColor3 = colors.secondary
antiDetectionButton.Position = UDim2.new(0, 0, 0, 290)
antiDetectionButton.Size = UDim2.new(1, 0, 0, 32)
antiDetectionButton.Font = font
antiDetectionButton.Text = "Anti-Detection: ON"
antiDetectionButton.TextColor3 = colors.success
antiDetectionButton.TextSize = 14
antiDetectionButton.LayoutOrder = 8

local antiDetectionCorner = Instance.new("UICorner")
antiDetectionCorner.CornerRadius = UDim.new(0, 6)
antiDetectionCorner.Parent = antiDetectionButton

setupButtonHover(antiDetectionButton)

-- UNC Tab Content
local uncContent = Instance.new("Frame")
uncContent.Name = "UNCContent"
uncContent.Parent = contentArea
uncContent.BackgroundTransparency = 1
uncContent.Size = UDim2.new(1, 0, 1, 0)
uncContent.Visible = false
uncContent.BackgroundTransparency = 0
uncContent.BackgroundColor3 = colors.background
uncContent.ClipsDescendants = true

-- Create a scrolling frame for UNC content
local uncScroll = Instance.new("ScrollingFrame")
uncScroll.Parent = uncContent
uncScroll.BackgroundTransparency = 1
uncScroll.Size = UDim2.new(1, 0, 1, 0)
uncScroll.CanvasSize = UDim2.new(0, 0, 0, 100)
uncScroll.ScrollBarThickness = 6
uncScroll.ScrollBarImageColor3 = colors.secondary

-- List layout for UNC buttons
local uncListLayout = Instance.new("UIListLayout")
uncListLayout.Parent = uncScroll
uncListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uncListLayout.Padding = UDim.new(0, 10)

-- sUNC Test Button
local sUNCTestButton = Instance.new("TextButton")
sUNCTestButton.Parent = uncScroll
sUNCTestButton.BackgroundColor3 = colors.secondary
sUNCTestButton.Size = UDim2.new(1, 0, 0, 36)
sUNCTestButton.Font = font
sUNCTestButton.Text = "sUNC Test"
sUNCTestButton.TextColor3 = colors.text
sUNCTestButton.TextSize = 14
sUNCTestButton.LayoutOrder = 1

local sUNCTestCorner = Instance.new("UICorner")
sUNCTestCorner.CornerRadius = UDim.new(0, 6)
sUNCTestCorner.Parent = sUNCTestButton

setupButtonHover(sUNCTestButton)

-- UNC Test Button
local UNCTestButton = Instance.new("TextButton")
UNCTestButton.Parent = uncScroll
UNCTestButton.BackgroundColor3 = colors.secondary
UNCTestButton.Size = UDim2.new(1, 0, 0, 36)
UNCTestButton.Font = font
UNCTestButton.Text = "UNC Test"
UNCTestButton.TextColor3 = colors.text
UNCTestButton.TextSize = 14
UNCTestButton.LayoutOrder = 2

local UNCTestCorner = Instance.new("UICorner")
UNCTestCorner.CornerRadius = UDim.new(0, 6)
UNCTestCorner.Parent = UNCTestButton

setupButtonHover(UNCTestButton)

-- Utility Tab Content
local utilityContent = Instance.new("Frame")
utilityContent.Name = "UtilityContent"
utilityContent.Parent = contentArea
utilityContent.BackgroundTransparency = 1
utilityContent.Size = UDim2.new(1, 0, 1, 0)
utilityContent.Visible = false
utilityContent.BackgroundTransparency = 0
utilityContent.BackgroundColor3 = colors.background
utilityContent.ClipsDescendants = true

-- Rejoin Button
local rejoinButton = Instance.new("TextButton")
rejoinButton.Parent = utilityContent
rejoinButton.BackgroundColor3 = colors.secondary
rejoinButton.Size = UDim2.new(1, 0, 0, 36)
rejoinButton.Text = "Rejoin Server"
rejoinButton.Font = font
rejoinButton.TextColor3 = colors.text
rejoinButton.TextSize = 14

local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0, 6)
rejoinCorner.Parent = rejoinButton

setupButtonHover(rejoinButton)

-- Server Hop Button
local hopButton = Instance.new("TextButton")
hopButton.Parent = utilityContent
hopButton.BackgroundColor3 = colors.secondary
hopButton.Position = UDim2.new(0, 0, 0, 40)
hopButton.Size = UDim2.new(1, 0, 0, 36)
hopButton.Text = "Server Hop (Smallest)"
hopButton.Font = font
hopButton.TextColor3 = colors.text
hopButton.TextSize = 14

local hopCorner = Instance.new("UICorner")
hopCorner.CornerRadius = UDim.new(0, 6)
hopCorner.Parent = hopButton

setupButtonHover(hopButton)

-- Anti-AFK Button
local antiAfk = Instance.new("TextButton")
antiAfk.Parent = utilityContent
antiAfk.BackgroundColor3 = colors.secondary
antiAfk.Position = UDim2.new(0, 0, 0, 80)
antiAfk.Size = UDim2.new(1, 0, 0, 36)
antiAfk.Text = "Anti-AFK"
antiAfk.Font = font
antiAfk.TextColor3 = colors.text
antiAfk.TextSize = 14

local antiAfkCorner = Instance.new("UICorner")
antiAfkCorner.CornerRadius = UDim.new(0, 6)
antiAfkCorner.Parent = antiAfk

setupButtonHover(antiAfk)

-- FPS Unlock Button
local fpsUnlock = Instance.new("TextButton")
fpsUnlock.Parent = utilityContent
fpsUnlock.BackgroundColor3 = colors.secondary
fpsUnlock.Position = UDim2.new(0, 0, 0, 120)
fpsUnlock.Size = UDim2.new(1, 0, 0, 36)
fpsUnlock.Text = "Unlock FPS"
fpsUnlock.Font = font
fpsUnlock.TextColor3 = colors.text
fpsUnlock.TextSize = 14

local fpsCorner = Instance.new("UICorner")
fpsCorner.CornerRadius = UDim.new(0, 6)
fpsCorner.Parent = fpsUnlock

setupButtonHover(fpsUnlock)


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

-- Invincibility variables
local invincibleEnabled = false
local healthConnection = nil

-- Triggerbot variables
local triggerbotEnabled = false
local triggerbotConnection = nil
local triggerbotDelay = 0.05
local triggerbotRange = 500

-- Hit Box Expander variables
local hitboxExpanderEnabled = false
local originalSizes = {}
local hitboxExpansionAmount = 1.5

-- Function to expand hit boxes
local function expandHitBoxes(enable)
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local char = otherPlayer.Character
            if char then
                if enable then
                    originalSizes[otherPlayer] = {}
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            originalSizes[otherPlayer][part] = part.Size
                            part.Size = part.Size * hitboxExpansionAmount
                        end
                    end
                else
                    if originalSizes[otherPlayer] then
                        for part, size in pairs(originalSizes[otherPlayer]) do
                            if part.Parent then part.Size = size end
                        end
                        originalSizes[otherPlayer] = nil
                    end
                end
            end
        end
    end
end

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
    billboard.Parent = screenGui
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
                            local camera = Workspace.CurrentCamera
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
    
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then createPlayerESP(otherPlayer) end
    end
    
    Players.PlayerAdded:Connect(function(newPlayer)
        if newPlayer ~= player then createPlayerESP(newPlayer) end
    end)
    
    Players.PlayerRemoving:Connect(removePlayerESP)
end

-- Invincibility functionality
local function enableInvincibility()
    if healthConnection then healthConnection:Disconnect() end

    local function maintainHealth()
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid.Health = humanoid.MaxHealth end
        end
    end

    maintainHealth()
    healthConnection = RunService.Heartbeat:Connect(maintainHealth)
end

local function disableInvincibility()
    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end
end

-- FIXED AIMBOT SYSTEM
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

local function isEnemy(targetPlayer)
    if not aimbotSettings.TeamCheck then return true end
    return player.Team ~= targetPlayer.Team
end

local function isVisible(character, targetPart)
    if not aimbotSettings.VisibleCheck then return true end
    
    local camera = Workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local target = targetPart.Position
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character, character}
    raycastParams.IgnoreWater = true
    
    local raycastResult = Workspace:Raycast(origin, target - origin, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        return hitPart and hitPart:IsDescendantOf(character)
    end
    
    return true
end

local function findClosestEnemy()
    if not player.Character then return nil end
    
    local camera = Workspace.CurrentCamera
    local closestEnemy = nil
    local closestAngle = math.rad(aimbotSettings.FOV)
    local closestDistance = math.huge
    
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
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
    local camera = Workspace.CurrentCamera
    local currentLook = camera.CFrame.LookVector
    local targetDirection = (targetPosition - camera.CFrame.Position).Unit
    
    local smoothingFactor = math.clamp(1 - aimbotSettings.Smoothing, 0.01, 0.99)
    local smoothedDirection = currentLook:Lerp(targetDirection, smoothingFactor)
    camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + smoothedDirection)
end

-- FLING FUNCTIONALITY
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

    if THead then workspace.CurrentCamera.CameraSubject = THead
    elseif Handle then workspace.CurrentCamera.CameraSubject = Handle
    elseif THumanoid and TRootPart then workspace.CurrentCamera.CameraSubject = THumanoid end

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
        until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= game.Player or 
              TargetPlayer.Character ~= TCharacter or (THumanoid and THumanoid.Sit) or Humanoid.Health <= 0 or tick() > Time + TimeToWait
    end

    workspace.FallenPartsDestroyHeight = 0/0

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
    workspace.CurrentCamera.CameraSubject = Humanoid

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

    workspace.FallenPartsDestroyHeight = scriptEnv.FPDH
end

-- Triggerbot functionality
local function isEnemyPlayer(character)
    if not character then return false end
    local targetPlayer = Players:GetPlayerFromCharacter(character)
    
    if targetPlayer and targetPlayer ~= player then
        if aimbotSettings.TeamCheck and player.Team and targetPlayer.Team then
            return player.Team ~= targetPlayer.Team
        end
        return true
    end
    return false
end

local function triggerbotLoop()
    while triggerbotEnabled and RunService.RenderStepped:Wait() do
        if not player.Character then continue end
        
        local camera = Workspace.CurrentCamera
        local mouse = player:GetMouse()
        
        if mouse.Target then
            local model = mouse.Target:FindFirstAncestorOfClass("Model")
            if model then
                local distance = (camera.CFrame.Position - mouse.Hit.Position).Magnitude
                if distance <= triggerbotRange and isEnemyPlayer(model) then
                    triggerbotButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(triggerbotDelay)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    task.wait(0.1)
                    if triggerbotEnabled then triggerbotButton.BackgroundColor3 = colors.secondary end
                end
            end
        end
    end
end

local function toggleTriggerbot()
    if triggerbotEnabled then
        triggerbotConnection = coroutine.wrap(triggerbotLoop)()
    else
        triggerbotConnection = nil
        triggerbotButton.BackgroundColor3 = colors.secondary
    end
end

-- Touch Fling functionality
local touchFlingEnabled = false
local touchFlingThread = nil

local function touchFlingLoop()
    while touchFlingEnabled and RunService.Heartbeat:Wait() do
        local character = player.Character
        if not character then continue end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        local originalVel = hrp.Velocity
        hrp.Velocity = originalVel * 10000 + Vector3.new(0, 10000, 0)
        RunService.RenderStepped:Wait()
        hrp.Velocity = originalVel
        RunService.Stepped:Wait()
        hrp.Velocity = originalVel + Vector3.new(0, 0.1, 0)
        RunService.Stepped:Wait()
        hrp.Velocity = originalVel - Vector3.new(0, 0.1, 0)
    end
end

touchFlingButton.MouseButton1Click:Connect(function()
    touchFlingEnabled = not touchFlingEnabled
    
    if touchFlingEnabled then
        touchFlingButton.Text = "Touch Fling: ON"
        touchFlingButton.BackgroundColor3 = colors.success
        touchFlingThread = coroutine.wrap(touchFlingLoop)()
        touchFlingThread()
    else
        touchFlingButton.Text = "Touch Fling: OFF"
        touchFlingButton.BackgroundColor3 = colors.secondary
        touchFlingThread = nil
    end
end)

if antiDetectionEnabled and not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

-- Variables for functionality
local flightEnabled = false
local infiniteTeleportEnabled = false
local flyBodyVelocity, flyBodyGyro = nil, nil
local teleportConnection = nil
local antiKickEnabled = true
local antiDetectionEnabled = true
local noclipEnabled = false
local noclipConnection = nil

player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    applyCharacterSettings()
    
    if flightEnabled then
        flightEnabled = false
        task.wait(0.5)
        flightEnabled = true
        enableFlight()
    end
    
    if noclipEnabled then task.wait(0.5); enableNoclip() end
    if invincibleEnabled then enableInvincibility() end
    if hitboxExpanderEnabled then expandHitBoxes(true) end
    if espSettings.Enabled then setupESP() end
end)

applyCharacterSettings()

-- Tab switching functionality
local contentFrames = {
    Main = mainContent,
    Teleport = teleportContent,
    Troll = trollContent,
    Scripts = scriptsContent,
    Games = gamesContent,
    PVP = pvpContent,
    UNC = uncContent,
    Utility = utilityContent
}
local currentTab = "Main"
local isAnimating = false

local function animateTabSwitch(fromFrame, toFrame)
    if isAnimating then return end
    isAnimating = true

    toFrame.Visible = true
    toFrame.BackgroundTransparency = 1
    toFrame.Position = UDim2.new(0, contentArea.AbsoluteSize.X, 0, 0)
    toFrame.ClipsDescendants = true

    local fromTween = TweenService:Create(
        fromFrame,
        TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1, Position = UDim2.new(0, -contentArea.AbsoluteSize.X, 0, 0)}
    )
    
    local toTween = TweenService:Create(
        toFrame,
        TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0)}
    )

    fromTween:Play()
    toTween:Play()

    fromTween.Completed:Wait()
    fromFrame.Visible = false
    fromFrame.Position = UDim2.new(0, 0, 0, 0)
    fromFrame.BackgroundTransparency = 0
    isAnimating = false
end

local function switchTab(tabName)
    if currentTab == tabName or isAnimating then return end
    for name, button in pairs(tabButtons) do
        if name == tabName then
            button.BackgroundColor3 = colors.primary
            button.TextColor3 = colors.text
        else
            button.BackgroundColor3 = colors.secondary
            button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    animateTabSwitch(contentFrames[currentTab], contentFrames[tabName])
    currentTab = tabName
end

for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function() switchTab(tabName) end)
end

-- Set initial state
mainContent.Visible = true
mainContent.Position = UDim2.new(0, 0, 0, 0)
mainContent.BackgroundTransparency = 0
teleportContent.Visible = false
trollContent.Visible = false
scriptsContent.Visible = false
gamesContent.Visible = false
pvpContent.Visible = false
uncContent.Visible = false
utilityContent.Visible = false
currentTab = "Main"

-- Noclip Functionality
local function enableNoclip()
    noclipEnabled = true
    noclipButton.Text = "Noclip: ON"
    noclipButton.TextColor3 = colors.text
    
    if noclipConnection then noclipConnection:Disconnect() end
    
    noclipConnection = RunService.Stepped:Connect(function()
        if noclipEnabled and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

local function disableNoclip()
    noclipEnabled = false
    noclipButton.Text = "Noclip: OFF"
    noclipButton.TextColor3 = colors.text
    
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

noclipButton.MouseButton1Click:Connect(function()
    if noclipEnabled then disableNoclip() else enableNoclip() end
end)

-- Flight functionality
local inputFlags = {
    forward = false,
    back = false,
    left = false,
    right = false,
    up = false,
    down = false
}
local forwardHold = 0
local flightTracks = {}

local function newAnim(id)
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. id
    return anim
end

local function loadFlightAnimations(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return nil end

    local animations = {
        forward = newAnim(90872539),
        up = newAnim(90872539),
        right1 = newAnim(136801964),
        right2 = newAnim(142495255),
        left1 = newAnim(136801964),
        left2 = newAnim(142495255),
        flyLow1 = newAnim(97169019),
        flyLow2 = newAnim(282574440),
        flyFast = newAnim(282574440),
        back1 = newAnim(136801964),
        back2 = newAnim(106772613),
        back3 = newAnim(42070810),
        back4 = newAnim(214744412),
        down = newAnim(233322916),
        idle1 = newAnim(97171309)
    }

    local tracks = {}
    for name, anim in pairs(animations) do tracks[name] = humanoid:LoadAnimation(anim) end
    return tracks
end

local function stopFlightAnimations()
    for _, track in pairs(flightTracks) do if track then track:Stop() end end
end

local function enableFlight()
    if not player.Character then return end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    flyBodyVelocity.P = 10000
    flyBodyVelocity.Parent = humanoidRootPart
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.D = 500
    flyBodyGyro.P = 10000
    flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyGyro.CFrame = humanoidRootPart.CFrame
    flyBodyGyro.Parent = humanoidRootPart
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.PlatformStand = true end
    
    flightButton.Text = "Flight: ON"
    flightButton.TextColor3 = colors.success
    flightTracks = loadFlightAnimations(player.Character) or {}
end

local function disableFlight()
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
    flightButton.Text = "Flight: OFF"
    flightButton.TextColor3 = colors.error
    stopFlightAnimations()
end

flightButton.MouseButton1Click:Connect(function()
    flightEnabled = not flightEnabled
    if flightEnabled then enableFlight() else disableFlight() end
end)

RunService.RenderStepped:Connect(function(dt)
    if not flightEnabled or not flyBodyVelocity then return end
    
    if not inputFlags.forward then forwardHold = 0 end

    local dir = Vector3.zero
    local camCF = Workspace.CurrentCamera.CFrame

    if inputFlags.forward then dir = dir + camCF.LookVector end
    if inputFlags.back then dir = dir - camCF.LookVector end
    if inputFlags.left then dir = dir - camCF.RightVector end
    if inputFlags.right then dir = dir + camCF.RightVector end
    if inputFlags.up then dir = dir + Vector3.new(0,1,0) end
    if inputFlags.down then dir = dir + Vector3.new(0,-1,0) end

    if dir.Magnitude > 0 then dir = dir.Unit end
    flyBodyVelocity.Velocity = dir * flightSpeed
    if flyBodyGyro then flyBodyGyro.CFrame = camCF end

    -- Animation Logic
    if inputFlags.up then
        if not flightTracks.up or not flightTracks.up.IsPlaying then
            stopFlightAnimations()
            if flightTracks.up then flightTracks.up:Play() end
        end
    elseif inputFlags.down then
        if not flightTracks.down or not flightTracks.down.IsPlaying then
            stopFlightAnimations()
            if flightTracks.down then flightTracks.down:Play() end
        end
    elseif inputFlags.left then
        if not flightTracks.left1 or not flightTracks.left1.IsPlaying then
            stopFlightAnimations()
            if flightTracks.left1 then
                flightTracks.left1:Play()
                flightTracks.left1.TimePosition = 2.0
                flightTracks.left1:AdjustSpeed(0)
            end
            if flightTracks.left2 then
                flightTracks.left2:Play()
                flightTracks.left2.TimePosition = 0.5
                flightTracks.left2:AdjustSpeed(0)
            end
        end
    elseif inputFlags.right then
        if not flightTracks.right1 or not flightTracks.right1.IsPlaying then
            stopFlightAnimations()
            if flightTracks.right1 then
                flightTracks.right1:Play()
                flightTracks.right1.TimePosition = 1.1
                flightTracks.right1:AdjustSpeed(0)
            end
            if flightTracks.right2 then
                flightTracks.right2:Play()
                flightTracks.right2.TimePosition = 0.5
                flightTracks.right2:AdjustSpeed(0)
            end
        end
    elseif inputFlags.back then
        if not flightTracks.back1 or not flightTracks.back1.IsPlaying then
            stopFlightAnimations()
            if flightTracks.back1 then
                flightTracks.back1:Play()
                flightTracks.back1.TimePosition = 5.3
                flightTracks.back1:AdjustSpeed(0)
            end
            if flightTracks.back2 then flightTracks.back2:Play(); flightTracks.back2:AdjustSpeed(0) end
            if flightTracks.back3 then
                flightTracks.back3:Play()
                flightTracks.back3.TimePosition = 0.8
                flightTracks.back3:AdjustSpeed(0)
            end
            if flightTracks.back4 then
                flightTracks.back4:Play()
                flightTracks.back4.TimePosition = 1
                flightTracks.back4:AdjustSpeed(0)
            end
        end
    elseif inputFlags.forward then
        forwardHold = forwardHold + dt
        if forwardHold >= 3 then
            if not flightTracks.flyFast or not flightTracks.flyFast.IsPlaying then
                stopFlightAnimations()
                if flightTracks.flyFast then
                    flightTracks.flyFast:Play()
                    flightTracks.flyFast:AdjustSpeed(0.05)
                end
            end
        else
            if not flightTracks.flyLow1 or not flightTracks.flyLow1.IsPlaying then
                stopFlightAnimations()
                if flightTracks.flyLow1 then flightTracks.flyLow1:Play() end
                if flightTracks.flyLow2 then flightTracks.flyLow2:Play() end
            end
        end
    else
        if not flightTracks.idle1 or not flightTracks.idle1.IsPlaying then
            stopFlightAnimations()
            if flightTracks.idle1 then
                flightTracks.idle1:Play()
                flightTracks.idle1:AdjustSpeed(0)
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W then inputFlags.forward = true end
    if input.KeyCode == Enum.KeyCode.S then inputFlags.back = true end
    if input.KeyCode == Enum.KeyCode.A then inputFlags.left = true end
    if input.KeyCode == Enum.KeyCode.D then inputFlags.right = true end
    if input.KeyCode == Enum.KeyCode.E then inputFlags.up = true end
    if input.KeyCode == Enum.KeyCode.Q then inputFlags.down = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then inputFlags.forward = false end
    if input.KeyCode == Enum.KeyCode.S then inputFlags.back = false end
    if input.KeyCode == Enum.KeyCode.A then inputFlags.left = false end
    if input.KeyCode == Enum.KeyCode.D then inputFlags.right = false end
    if input.KeyCode == Enum.KeyCode.E then inputFlags.up = false end
    if input.KeyCode == Enum.KeyCode.Q then inputFlags.down = false end
end)

-- Teleport functionality
local function teleportToPlayer(username)
    local targetPlayer = Players:FindFirstChild(username)
    if not targetPlayer then
        playerInput.Text = "Player not found!"
        task.wait(1.5)
        playerInput.Text = ""
        return
    end
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then humanoidRootPart.CFrame = targetRoot.CFrame end
end

teleportButton.MouseButton1Click:Connect(function() teleportToPlayer(playerInput.Text) end)

infiniteTeleportButton.MouseButton1Click:Connect(function()
    infiniteTeleportEnabled = not infiniteTeleportEnabled
    if infiniteTeleportEnabled then
        infiniteTeleportButton.Text = "Infinite Teleport: ON"
        infiniteTeleportButton.BackgroundColor3 = colors.success
        teleportConnection = RunService.Heartbeat:Connect(function()
            if playerInput.Text ~= "" then teleportToPlayer(playerInput.Text) end
        end)
    else
        infiniteTeleportButton.Text = "Infinite Teleport: OFF"
        infiniteTeleportButton.BackgroundColor3 = colors.secondary
        if teleportConnection then
            teleportConnection:Disconnect()
            teleportConnection = nil
        end
    end
end)

-- FLING FUNCTIONALITY
flingPlayerButton.MouseButton1Click:Connect(function()
    local username = playerFlingInput.Text
    local targetPlayers = gplr(username)
    if #targetPlayers > 0 then
        for _, targetPlayer in ipairs(targetPlayers) do SkidFling(targetPlayer) end
        notif("Flinging "..username, 3)
    else notif("Player not found!", 3) end
end)

flingAllButton.MouseButton1Click:Connect(function()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then SkidFling(otherPlayer) end
    end
    notif("Flinging everyone!", 3)
end)

-- Scripts tab functionality
saturnBypassButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet('https://getsaturn.pages.dev/sb.lua'))() end)
iyButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end)
invisibilityButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Global/invisibility.lua"))() end)
birdPoopButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Troll/FE-Bird-Poop.lua"))() end)
chatAdminButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Global/FE-ChatAdmin.lua"))() end)
vcUnbanButton.MouseButton1Click:Connect(function() VoiceChatService:joinVoice(); notif("Voice chat unban attempted", 3) end)
superRingButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://rscripts.net/raw/super-ring-parts-v4-by-lukas_1741980981842_td0ummjymf.txt",true))() end)
catBypassButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/shadow62x/catbypass/main/upfix"))() end)
betterBypassButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://github.com/Synergy-Networks/products/raw/main/BetterBypasser/loader.lua"))() end)
feuralBypassButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://zxfolix.github.io/feuralbypasser.lua"))() end)

-- Games tab functionality
basketballButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/vnausea/absence-mini/refs/heads/main/absencemini.lua"))() end)
bloxFruitsButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/GaG/Main.lua'))() end)
tsbButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ATrainz/Phantasm/refs/heads/main/Games/TSB.lua"))() end)
dtiButton.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/hellohellohell012321/DTI-GUI-V2/main/dti_gui_v2.lua",true))() end) end)
inkGameButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Games/Ink%20Game/ink.lua"))() end)
mm2Button.MouseButton1Click:Connect(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/Roman34296589/SnapSanixHUB/refs/heads/main/SnapSanixHUB.lua'))() end)

-- UNC tab functionality
sUNCTestButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/HummingBird8/HummingRn/main/sUNCTestGET"))() end)
UNCTestButton.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Global/UNC-Test.lua"))() end)

-- PVP tab functionality
espToggle.MouseButton1Click:Connect(function()
    espSettings.Enabled = not espSettings.Enabled
    if espSettings.Enabled then
        espToggle.Text = "ESP: ON"
        espToggle.BackgroundColor3 = colors.success
        espToggle.TextColor3 = colors.text
        setupESP()
    else
        espToggle.Text = "ESP: OFF"
        espToggle.BackgroundColor3 = colors.secondary
        espToggle.TextColor3 = colors.error
        clearAllESP()
    end
end)

tracerToggle.MouseButton1Click:Connect(function()
    espSettings.Tracers = not espSettings.Tracers
    if espSettings.Tracers then
        tracerToggle.Text = "Tracers: ON"
        tracerToggle.BackgroundColor3 = colors.success
        tracerToggle.TextColor3 = colors.text
    else
        tracerToggle.Text = "Tracers: OFF"
        tracerToggle.BackgroundColor3 = colors.secondary
        tracerToggle.TextColor3 = colors.error
        for _, tracerLine in pairs(espSettings.TracerLines) do
            if tracerLine then tracerLine.Visible = false end
        end
    end
end)

invincibleButton.MouseButton1Click:Connect(function()
    invincibleEnabled = not invincibleEnabled
    if invincibleEnabled then
        invincibleButton.Text = "Invincible: ON"
        invincibleButton.BackgroundColor3 = colors.success
        invincibleButton.TextColor3 = colors.text
        enableInvincibility()
    else
        invincibleButton.Text = "Invincible: OFF"
        invincibleButton.BackgroundColor3 = colors.secondary
        invincibleButton.TextColor3 = colors.error
        disableInvincibility()
    end
end)

aimbotButton.MouseButton1Click:Connect(function()
    aimbotSettings.Enabled = not aimbotSettings.Enabled
    if aimbotSettings.Enabled then
        aimbotButton.Text = "Aimbot: ON"
        aimbotButton.BackgroundColor3 = colors.success
        aimbotButton.TextColor3 = colors.text
        
        if aimbotSettings.Connection then aimbotSettings.Connection:Disconnect() end
        
        aimbotSettings.Connection = RunService.RenderStepped:Connect(function()
            aimbotSettings.Active = UserInputService:IsKeyDown(aimbotSettings.ActivationKey)
            if aimbotSettings.Active then
                local enemy = findClosestEnemy()
                if enemy then
                    local targetPart = enemy:FindFirstChild(aimbotSettings.TargetPart)
                    if targetPart then
                        smoothAim(targetPart.Position)
                        aimbotButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    end
                end
            else
                aimbotButton.BackgroundColor3 = colors.success
            end
        end)
    else
        aimbotButton.Text = "Aimbot: OFF"
        aimbotButton.BackgroundColor3 = colors.secondary
        aimbotButton.TextColor3 = colors.error
        if aimbotSettings.Connection then
            aimbotSettings.Connection:Disconnect()
            aimbotSettings.Connection = nil
        end
    end
end)

triggerbotButton.MouseButton1Click:Connect(function()
    triggerbotEnabled = not triggerbotEnabled
    if triggerbotEnabled then
        triggerbotButton.Text = "Triggerbot: ON"
        triggerbotButton.BackgroundColor3 = colors.success
        triggerbotButton.TextColor3 = colors.text
        toggleTriggerbot()
    else
        triggerbotButton.Text = "Triggerbot: OFF"
        triggerbotButton.BackgroundColor3 = colors.secondary
        triggerbotButton.TextColor3 = colors.error
        toggleTriggerbot()
    end
end)

hitboxButton.MouseButton1Click:Connect(function()
    hitboxExpanderEnabled = not hitboxExpanderEnabled
    if hitboxExpanderEnabled then
        hitboxButton.Text = "Hit Box Expander: ON"
        hitboxButton.BackgroundColor3 = colors.success
        hitboxButton.TextColor3 = colors.text
        expandHitBoxes(true)
    else
        hitboxButton.Text = "Hit Box Expander: OFF"
        hitboxButton.BackgroundColor3 = colors.secondary
        hitboxButton.TextColor3 = colors.error
        expandHitBoxes(false)
    end
end)

antiKickButton.MouseButton1Click:Connect(function()
    antiKickEnabled = not antiKickEnabled
    if antiKickEnabled then
        antiKickButton.Text = "Anti-Kick: ON"
        antiKickButton.BackgroundColor3 = colors.success
        antiKickButton.TextColor3 = colors.text
    else
        antiKickButton.Text = "Anti-Kick: OFF"
        antiKickButton.BackgroundColor3 = colors.secondary
        antiKickButton.TextColor3 = colors.error
    end
end)

antiDetectionButton.MouseButton1Click:Connect(function()
    antiDetectionEnabled = not antiDetectionEnabled
    if antiDetectionEnabled then
        antiDetectionButton.Text = "Anti-Detection: ON"
        antiDetectionButton.BackgroundColor3 = colors.success
        antiDetectionButton.TextColor3 = colors.text
    else
        antiDetectionButton.Text = "Anti-Detection: OFF"
        antiDetectionButton.BackgroundColor3 = colors.secondary
        antiDetectionButton.TextColor3 = colors.error
    end
end)

-- Utility tab functionality
rejoinButton.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

hopButton.MouseButton1Click:Connect(function()
    local servers = HttpService:JSONDecode(game:HttpGet(
        ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100")
        :format(game.PlaceId)
    ))
    for _,srv in pairs(servers.data) do
        if srv.playing < srv.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, player)
            break
        end
    end
end)

antiAfk.MouseButton1Click:Connect(function()
    for _, v in pairs(getconnections(player.Idled)) do
        v:Disable()
    end
    notif("Anti-AFK Enabled!", 5)
end)

fpsUnlock.MouseButton1Click:Connect(function()
    if setfpscap then
        setfpscap(999)
        notif("FPS Unlocked!", 5)
    else
        notif("Executor doesn’t support setfpscap.", 5)
    end
end)

-- GUI Visibility Toggle (F4 Key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F4 and not gameProcessed then
        if screenGui.Enabled then
            TweenService:Create(mainFrame, TweenInfo.new(animationSpeed), {
                BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            delay(animationSpeed, function()
                screenGui.Enabled = false
                mainFrame.Size = UDim2.new(0, 400, 0, 550)
                mainFrame.BackgroundTransparency = 0
            end)
        else
            screenGui.Enabled = true
            mainFrame.Size = UDim2.new(0, 400, 0, 40)
            TweenService:Create(mainFrame, TweenInfo.new(animationSpeed), {
                Size = UDim2.new(0, 400, 0, 550), BackgroundTransparency = 0
            }):Play()
        end
    end
end)

-- Animation for main frame on initial open
delay(0.5, function()
    if screenGui and screenGui.Parent then
        screenGui.Enabled = true
        mainFrame.Size = UDim2.new(0, 400, 0, 40)
        TweenService:Create(mainFrame, TweenInfo.new(animationSpeed), {
            Size = UDim2.new(0, 400, 0, 550), BackgroundTransparency = 0
        }):Play()
    end
end)

-- Cleanup when GUI is closed
screenGui.Destroying:Connect(function()
    disableFlight()
    disableNoclip()
    if teleportConnection then teleportConnection:Disconnect() end
    clearAllESP()
    disableInvincibility()
    expandHitBoxes(false)
    if aimbotSettings.Connection then aimbotSettings.Connection:Disconnect() end
    triggerbotEnabled = false
    if triggerbotConnection then triggerbotConnection = nil end
    touchFlingEnabled = false
    if touchFlingThread then touchFlingThread = nil end
end)

-- Character settings and ESP update
RunService.Heartbeat:Connect(function()
    applyCharacterSettings()
    if espSettings.Enabled then updatePlayerESP() end
end)

