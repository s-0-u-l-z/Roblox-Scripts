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

-- Local player reference
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

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
    accent = Color3.fromRGB(0, 255, 200),     -- Cyan
    text = Color3.fromRGB(240, 240, 240),
    error = Color3.fromRGB(255, 80, 80),      -- Bright red
    success = Color3.fromRGB(80, 255, 120),   -- Bright green
    warning = Color3.fromRGB(255, 200, 0),    -- Yellow
    noclip = Color3.fromRGB(180, 100, 255)    -- Purple
}

-- Font
local font = Enum.Font.GothamSemibold

-- Player search function
local function gplr(String)
    local Found = {}
    local strl = String:lower()
    if strl == "all" then
        for i,v in pairs(Players:GetPlayers()) do
            table.insert(Found,v)
        end
    elseif strl == "others" then
        for i,v in pairs(Players:GetPlayers()) do
            if v.Name ~= player.Name then
                table.insert(Found,v)
            end
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
screenGui.Enabled = false -- Start hidden

-- Animation properties
local animationSpeed = 0.2
local hoverAnimationSpeed = 0.15

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = colors.background
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 380, 0, 500)
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
            Size = UDim2.new(0, 380, 0, 40)
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
        -- Show content before animation
        for _, child in pairs(mainFrame:GetChildren()) do
            if child ~= titleBar and child ~= corner and child ~= shadow and child.Name ~= "TabFrame" then
                child.Visible = true
                child.BackgroundTransparency = 1
            end
        end
        
        
        TweenService:Create(mainFrame, TweenInfo.new(animationSpeed, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 380, 0, 500)
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


local tabs = {"Main", "Teleport", "Troll", "Scripts", "Games", "PVP"}
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

-- Speed Slider
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainContent
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 0, 0, 10)
speedLabel.Size = UDim2.new(1, 0, 0, 22)
speedLabel.Font = font
speedLabel.Text = "Speed: 16"
speedLabel.TextColor3 = colors.text
speedLabel.TextSize = 14
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedSliderBg = Instance.new("Frame")
speedSliderBg.Parent = mainContent
speedSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
speedSliderBg.Position = UDim2.new(0, 0, 0, 36)
speedSliderBg.Size = UDim2.new(1, 0, 0, 8)

local speedSliderBgCorner = Instance.new("UICorner")
speedSliderBgCorner.CornerRadius = UDim.new(0, 4)
speedSliderBgCorner.Parent = speedSliderBg

local speedSlider = Instance.new("Frame")
speedSlider.Parent = speedSliderBg
speedSlider.BackgroundColor3 = colors.primary
speedSlider.Position = UDim2.new(0, 0, 0, 0)
speedSlider.Size = UDim2.new(0.2, 0, 1, 0)

local speedSliderCorner = Instance.new("UICorner")
speedSliderCorner.CornerRadius = UDim.new(0, 4)
speedSliderCorner.Parent = speedSlider

-- Jump Power Slider
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Parent = mainContent
jumpLabel.BackgroundTransparency = 1
jumpLabel.Position = UDim2.new(0, 0, 0, 60)
jumpLabel.Size = UDim2.new(1, 0, 0, 22)
jumpLabel.Font = font
jumpLabel.Text = "Jump Power: 50"
jumpLabel.TextColor3 = colors.text
jumpLabel.TextSize = 14
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left

local jumpSliderBg = Instance.new("Frame")
jumpSliderBg.Parent = mainContent
jumpSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
jumpSliderBg.Position = UDim2.new(0, 0, 0, 86)
jumpSliderBg.Size = UDim2.new(1, 0, 0, 8)

local jumpSliderBgCorner = Instance.new("UICorner")
jumpSliderBgCorner.CornerRadius = UDim.new(0, 4)
jumpSliderBgCorner.Parent = jumpSliderBg

local jumpSlider = Instance.new("Frame")
jumpSlider.Parent = jumpSliderBg
jumpSlider.BackgroundColor3 = colors.primary
jumpSlider.Position = UDim2.new(0, 0, 0, 0)
jumpSlider.Size = UDim2.new(0.2, 0, 1, 0)

local jumpSliderCorner = Instance.new("UICorner")
jumpSliderCorner.CornerRadius = UDim.new(0, 4)
jumpSliderCorner.Parent = jumpSlider

-- Flight Speed Slider 
local flightSpeedLabel = Instance.new("TextLabel")
flightSpeedLabel.Parent = mainContent
flightSpeedLabel.BackgroundTransparency = 1
flightSpeedLabel.Position = UDim2.new(0, 0, 0, 112) -- Positioned above flight button
flightSpeedLabel.Size = UDim2.new(1, 0, 0, 22)
flightSpeedLabel.Font = font
flightSpeedLabel.Text = "Flight Speed: 50"
flightSpeedLabel.TextColor3 = colors.text
flightSpeedLabel.TextSize = 14
flightSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local flightSpeedSliderBg = Instance.new("Frame")
flightSpeedSliderBg.Parent = mainContent
flightSpeedSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
flightSpeedSliderBg.Position = UDim2.new(0, 0, 0, 138)
flightSpeedSliderBg.Size = UDim2.new(1, 0, 0, 8)

local flightSpeedSliderBgCorner = Instance.new("UICorner")
flightSpeedSliderBgCorner.CornerRadius = UDim.new(0, 4)
flightSpeedSliderBgCorner.Parent = flightSpeedSliderBg

local flightSpeedSlider = Instance.new("Frame")
flightSpeedSlider.Parent = flightSpeedSliderBg
flightSpeedSlider.BackgroundColor3 = colors.accent -- Different color for distinction
flightSpeedSlider.Position = UDim2.new(0, 0, 0, 0)
flightSpeedSlider.Size = UDim2.new(0.5, 0, 1, 0) -- Start at 50% (value 50)

local flightSpeedSliderCorner = Instance.new("UICorner")
flightSpeedSliderCorner.CornerRadius = UDim.new(0, 4)
flightSpeedSliderCorner.Parent = flightSpeedSlider

-- Flight Toggle
local flightButton = Instance.new("TextButton")
flightButton.Parent = mainContent
flightButton.BackgroundColor3 = colors.secondary
flightButton.Position = UDim2.new(0, 0, 0, 152) -- Moved down below flight speed
flightButton.Size = UDim2.new(1, 0, 0, 32)
flightButton.Font = font
flightButton.Text = "Flight: OFF"
flightButton.TextColor3 = colors.error
flightButton.TextSize = 14

local flightCorner = Instance.new("UICorner")
flightCorner.CornerRadius = UDim.new(0, 6)
flightCorner.Parent = flightButton

setupButtonHover(flightButton, colors.accent)

-- Noclip Toggle
local noclipButton = Instance.new("TextButton")
noclipButton.Parent = mainContent
noclipButton.BackgroundColor3 = colors.noclip -- Purple color for noclip
noclipButton.Position = UDim2.new(0, 0, 0, 192) -- Positioned below flight button
noclipButton.Size = UDim2.new(1, 0, 0, 32)
noclipButton.Font = font
noclipButton.Text = "Noclip: OFF"
noclipButton.TextColor3 = colors.text
noclipButton.TextSize = 14

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 6)
noclipCorner.Parent = noclipButton

setupButtonHover(noclipButton, Color3.new(0.8, 0.6, 0.9)) -- Light purple hover

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
flingPlayerButton.Position = UDim2.new(0, 0, 0, 50)  -- Adjusted position
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
flingAllButton.Position = UDim2.new(0, 0, 0, 90)  -- Adjusted position
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

-- Scripts Tab Content (renamed from Extra)
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
scriptsScroll.CanvasSize = UDim2.new(0, 0, 0, 420)
scriptsScroll.ScrollBarThickness = 6
scriptsScroll.ScrollBarImageColor3 = colors.secondary

-- Grid layout for buttons
local scriptsGridLayout = Instance.new("UIGridLayout")
scriptsGridLayout.Parent = scriptsScroll
scriptsGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
scriptsGridLayout.CellPadding = UDim2.new(0, 5, 0, 10)
scriptsGridLayout.CellSize = UDim2.new(0.5, -5, 0, 36)
scriptsGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
scriptsGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
scriptsGridLayout.StartCorner = Enum.StartCorner.TopLeft

-- Invis button
local invisibilityButton = Instance.new("TextButton")
invisibilityButton.Parent = scriptsScroll
invisibilityButton.BackgroundColor3 = colors.secondary
invisibilityButton.Font = font
invisibilityButton.Text = "Invisibility"
invisibilityButton.TextColor3 = colors.text
invisibilityButton.TextSize = 14
invisibilityButton.LayoutOrder = 1

local invisibilityCorner = Instance.new("UICorner")
invisibilityCorner.CornerRadius = UDim.new(0, 6)
invisibilityCorner.Parent = invisibilityButton

setupButtonHover(invisibilityButton)

-- SaturnBypasser Button
local saturnBypassButton = Instance.new("TextButton")
saturnBypassButton.Parent = scriptsScroll
saturnBypassButton.BackgroundColor3 = colors.secondary
saturnBypassButton.Font = font
saturnBypassButton.Text = "SaturnBypasser"
saturnBypassButton.TextColor3 = colors.text
saturnBypassButton.TextSize = 14
saturnBypassButton.LayoutOrder = 2

local saturnBypassCorner = Instance.new("UICorner")
saturnBypassCorner.CornerRadius = UDim.new(0, 6)
saturnBypassCorner.Parent = saturnBypassButton

setupButtonHover(saturnBypassButton)

-- IY Button
local iyButton = Instance.new("TextButton")
iyButton.Parent = scriptsScroll
iyButton.BackgroundColor3 = colors.secondary
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
vcUnbanButton.Font = font
vcUnbanButton.Text = "VC-Unban"
vcUnbanButton.TextColor3 = colors.text
vcUnbanButton.TextSize = 14
vcUnbanButton.LayoutOrder = 6

local vcUnbanCorner = Instance.new("UICorner")
vcUnbanCorner.CornerRadius = UDim.new(0, 6)
vcUnbanCorner.Parent = vcUnbanButton

setupButtonHover(vcUnbanButton)

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

-- Basketball Button (moved to Games tab)
local basketballButton = Instance.new("TextButton")
basketballButton.Parent = gamesScroll
basketballButton.BackgroundColor3 = colors.secondary
basketballButton.Font = font
basketballButton.Text = "Basketball"
basketballButton.TextColor3 = colors.text
basketballButton.TextSize = 14
basketballButton.LayoutOrder = 1

local basketballCorner = Instance.new("UICorner")
basketballCorner.CornerRadius = UDim.new(0, 6)
basketballCorner.Parent = basketballButton

setupButtonHover(basketballButton)

-- Blox Fruits Button (renamed from Fruit)
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

-- TSB Button (moved to Games tab)
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
pvpScroll.CanvasSize = UDim2.new(0, 0, 0, 280) -- Will adjust based on content
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
local triggerbotDelay = 0.05 -- Seconds between shots
local triggerbotRange = 500 -- Max distance to trigger

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
                            if part.Parent then
                                part.Size = size
                            end
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
    highlight.FillTransparency = 1  -- Make fill transparent
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    highlight.Adornee = character
    highlight.Enabled = espSettings.Enabled
    
    -- Create info billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = targetPlayer.Name .. "_Billboard"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Adornee = character:WaitForChild("Head")
    billboard.Parent = screenGui
    billboard.Enabled = espSettings.Enabled
    
    -- Create background frame
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.3
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BorderSizePixel = 0
    frame.Parent = billboard
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    -- Create text label
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
    
    -- Create tracer line (using Drawing library for better performance)
    local tracerLine = Drawing.new("Line")
    tracerLine.Visible = false
    tracerLine.Thickness = 2
    tracerLine.Color = Color3.new(1, 1, 1) -- Default white
    
    -- Store components
    espSettings.Players[targetPlayer] = true
    espSettings.Highlights[targetPlayer] = highlight
    espSettings.Billboards[targetPlayer] = billboard
    espSettings.TracerLines[targetPlayer] = tracerLine
end

local function removePlayerESP(targetPlayer)
    if not espSettings.Players[targetPlayer] then return end
    
    local highlight = espSettings.Highlights[targetPlayer]
    if highlight then
        highlight:Destroy()
    end
    
    local billboard = espSettings.Billboards[targetPlayer]
    if billboard then
        billboard:Destroy()
    end
    
    local tracerLine = espSettings.TracerLines[targetPlayer]
    if tracerLine then
        tracerLine:Remove()
    end
    
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
                -- Check distance
                local distance = 0
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    distance = (rootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                end
                
                -- Get highlight and billboard
                local highlight = espSettings.Highlights[targetPlayer]
                local billboard = espSettings.Billboards[targetPlayer]
                local tracerLine = espSettings.TracerLines[targetPlayer]
                
                if not highlight or not billboard or not tracerLine then
                    createPlayerESP(targetPlayer)
                else
                    -- Update highlight visibility
                    highlight.Enabled = espSettings.Enabled and (distance <= espSettings.MaxDistance)
                    
                    -- Update billboard visibility and content
                    if billboard then
                        billboard.Enabled = espSettings.Enabled and (distance <= espSettings.MaxDistance)
                        
                        if billboard.Enabled then
                            local health = math.floor(humanoid.Health)
                            local maxHealth = math.floor(humanoid.MaxHealth)
                            local text = string.format("%s\n%d/%dHP\n%d studs", 
                                targetPlayer.Name, health, maxHealth, math.floor(distance))
                            
                            -- Find text label
                            local frame = billboard:FindFirstChild("Frame")
                            if frame then
                                local textLabel = frame:FindFirstChild("TextLabel")
                                if textLabel then
                                    textLabel.Text = text
                                end
                            end
                        end
                    end
                    
                    -- Update tracer line
                    if tracerLine and espSettings.Tracers then
                        tracerLine.Visible = espSettings.Enabled and (distance <= espSettings.MaxDistance)
                        
                        if tracerLine.Visible then
                            -- Get screen positions
                            local camera = Workspace.CurrentCamera
                            local rootPos = rootPart.Position
                            local screenPos, onScreen = camera:WorldToViewportPoint(rootPos)
                            
                            if onScreen then
                                -- Draw from bottom center directly to player
                                local bottomCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                                
                                -- Set tracer properties
                                tracerLine.From = bottomCenter
                                tracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
                                
                                -- Set color based on team
                                if targetPlayer.Team and player.Team then
                                    if targetPlayer.Team == player.Team then
                                        tracerLine.Color = Color3.new(0, 1, 0) -- Green for teammates
                                    else
                                        tracerLine.Color = Color3.new(1, 0, 0) -- Red for enemies
                                    end
                                else
                                    tracerLine.Color = Color3.new(1, 1, 1) -- White for no teams
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
    -- Clear existing ESP
    clearAllESP()
    
    -- Create ESP for existing players
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            createPlayerESP(otherPlayer)
        end
    end
    
    -- Handle new players
    Players.PlayerAdded:Connect(function(newPlayer)
        if newPlayer ~= player then
            createPlayerESP(newPlayer)
        end
    end)
    
    -- Handle leaving players
    Players.PlayerRemoving:Connect(function(removedPlayer)
        removePlayerESP(removedPlayer)
    end)
end

-- Invincibility functionality
local function enableInvincibility()
    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end

    -- Function to set health to max
    local function maintainHealth()
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end

    -- Set health immediately
    maintainHealth()

    -- Set up connection to maintain health
    healthConnection = RunService.Heartbeat:Connect(maintainHealth)
end

local function disableInvincibility()
    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end
end

-- ===== FIXED AIMBOT SYSTEM =====
local aimbotSettings = {
    Enabled = false,
    ActivationKey = Enum.KeyCode.RightControl,
    Smoothing = 0.3,
    FOV = 120, -- Degrees
    TargetPart = "Head",
    TeamCheck = true,
    VisibleCheck = true,
    Connection = nil,
    Active = false
}

-- Team check function
local function isEnemy(targetPlayer)
    if not aimbotSettings.TeamCheck then return true end
    return player.Team ~= targetPlayer.Team
end

-- Visibility check
local function isVisible(character, targetPart)
    if not aimbotSettings.VisibleCheck then return true end
    
    local camera = Workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local target = targetPart.Position
    
    -- Raycast to check visibility
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

-- Find the closest enemy to crosshair
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

-- Smooth aim function
local function smoothAim(targetPosition)
    local camera = Workspace.CurrentCamera
    local currentLook = camera.CFrame.LookVector
    local targetDirection = (targetPosition - camera.CFrame.Position).Unit
    
    -- Calculate smoothed direction
    local smoothingFactor = math.clamp(1 - aimbotSettings.Smoothing, 0.01, 0.99)
    local smoothedDirection = currentLook:Lerp(targetDirection, smoothingFactor)
    
    -- Calculate new CFrame
    camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + smoothedDirection)
end

-- NEW FLING FUNCTIONALITY (SkidFling)
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

    if not (Character and Humanoid and RootPart) then
        return
    end

    if RootPart.Velocity.Magnitude < 50 then
        scriptEnv.OldPos = RootPart.CFrame
    end

    if THumanoid and THumanoid.Sit then
        return
    end

    if THead then
        workspace.CurrentCamera.CameraSubject = THead
    elseif Handle then
        workspace.CurrentCamera.CameraSubject = Handle
    elseif THumanoid and TRootPart then
        workspace.CurrentCamera.CameraSubject = THumanoid
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
                    Angle += 100
                    for _, offset in ipairs({
                        CFrame.new(0, 1.5, 0),
                        CFrame.new(0, -1.5, 0),
                        CFrame.new(2.25, 1.5, -2.25),
                        CFrame.new(-2.25, -1.5, 2.25),
                        CFrame.new(0, 1.5, 0),
                        CFrame.new(0, -1.5, 0)
                    }) do
                        FPos(BasePart, offset + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    end
                else
                    for _, offset in ipairs({
                        CFrame.new(0, 1.5, THumanoid.WalkSpeed),
                        CFrame.new(0, -1.5, -THumanoid.WalkSpeed),
                        CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25),
                        CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25),
                        CFrame.new(0, -1.5, 0),
                        CFrame.new(0, -1.5, 0),
                        CFrame.new(0, -1.5, 0)
                    }) do
                        FPos(BasePart, offset, CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                    end
                end
            else
                break
            end
        until BasePart.Velocity.Magnitude > 500
            or BasePart.Parent ~= TargetPlayer.Character
            or TargetPlayer.Parent ~= game.Player
            or TargetPlayer.Character ~= TCharacter
            or (THumanoid and THumanoid.Sit)
            or Humanoid.Health <= 0
            or tick() > Time + TimeToWait
    end

    workspace.FallenPartsDestroyHeight = 0/0

    local BV = Instance.new("BodyVelocity")
    BV.Name = "EpixVel"
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    if TRootPart and THead then
        if (TRootPart.Position - THead.Position).Magnitude > 5 then
            SFBasePart(THead)
        else
            SFBasePart(TRootPart)
        end
    elseif TRootPart then
        SFBasePart(TRootPart)
    elseif THead then
        SFBasePart(THead)
    elseif Handle then
        SFBasePart(Handle)
    end

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
        -- Team check
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
        
        -- Get camera and mouse
        local camera = Workspace.CurrentCamera
        local mouse = player:GetMouse()
        
        -- Check if we have a target
        if mouse.Target then
            -- Get the character model
            local model = mouse.Target:FindFirstAncestorOfClass("Model")
            if model then
                -- Check if it's an enemy player within range
                local distance = (camera.CFrame.Position - mouse.Hit.Position).Magnitude
                if distance <= triggerbotRange and isEnemyPlayer(model) then
                    -- Visual feedback
                    triggerbotButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    
                    -- Simulate mouse click
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(triggerbotDelay)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    
                    -- Reset visual feedback after delay
                    task.wait(0.1)
                    if triggerbotEnabled then
                        triggerbotButton.BackgroundColor3 = colors.secondary
                    end
                end
            end
        end
    end
end

local function toggleTriggerbot()
    if triggerbotEnabled then
        -- Start the triggerbot loop
        triggerbotConnection = coroutine.wrap(triggerbotLoop)()
    else
        -- Stop the triggerbot loop
        if triggerbotConnection then
            triggerbotConnection = nil
        end
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
        
        -- Save original velocity
        local originalVel = hrp.Velocity
        
        -- Apply fling velocity pattern
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
        
        -- Start the fling loop in a separate thread
        touchFlingThread = coroutine.wrap(touchFlingLoop)()
        touchFlingThread()
    else
        touchFlingButton.Text = "Touch Fling: OFF"
        touchFlingButton.BackgroundColor3 = colors.secondary
        
        -- Stop the fling loop
        touchFlingThread = nil
    end
end)

-- Add anti-detection for the fling method
if antiDetectionEnabled and not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

-- Variables for functionality
local currentSpeed = 16
local currentJump = 50
local flightEnabled = false
local flightSpeed = 50
local infiniteTeleportEnabled = false
local flyBodyVelocity, flyBodyGyro = nil, nil
local teleportConnection = nil

-- Anti-cheat protection variables
local antiKickEnabled = true
local antiDetectionEnabled = true

-- Apply character settings
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

player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    applyCharacterSettings()
    
    -- Re-enable flight if it was active
    if flightEnabled then
        flightEnabled = false
        task.wait(0.5)
        flightEnabled = true
        enableFlight()
    end
    
    -- Re-enable noclip if it was active
    if noclipEnabled then
        task.wait(0.5)
        enableNoclip()
    end
    
    -- Re-enable invincibility if it was active
    if invincibleEnabled then
        enableInvincibility()
    end
    
    -- Re-apply hit box expansion if active
    if hitboxExpanderEnabled then
        expandHitBoxes(true)
    end
    
    -- Re-create ESP
    if espSettings.Enabled then
        setupESP()
    end
end)

applyCharacterSettings()

-- Tab switching functionality with animation
local contentFrames = {
    Main = mainContent,
    Teleport = teleportContent,
    Troll = trollContent,
    Scripts = scriptsContent,
    Games = gamesContent,
    PVP = pvpContent
}
local currentTab = "Main"
local isAnimating = false

local function animateTabSwitch(fromFrame, toFrame)
    if isAnimating then return end
    isAnimating = true

    -- Prepare toFrame for animation
    toFrame.Visible = true
    toFrame.BackgroundTransparency = 1
    toFrame.Position = UDim2.new(0, contentArea.AbsoluteSize.X, 0, 0)
    toFrame.ClipsDescendants = true

    -- Animate fromFrame out (slide left and fade out)
    local fromTween = TweenService:Create(
        fromFrame,
        TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, -contentArea.AbsoluteSize.X, 0, 0)
        }
    )
    -- Animate toFrame in (slide from right and fade in)
    local toTween = TweenService:Create(
        toFrame,
        TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {
            BackgroundTransparency = 0,
            Position = UDim2.new(0, 0, 0, 0)
        }
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
    local fromFrame = contentFrames[currentTab]
    local toFrame = contentFrames[tabName]
    animateTabSwitch(fromFrame, toFrame)
    currentTab = tabName
end

for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

-- Set initial state
mainContent.Visible = true
mainContent.Position = UDim2.new(0, 0, 0, 0)
mainContent.BackgroundTransparency = 0
teleportContent.Visible = false
teleportContent.Position = UDim2.new(0, 0, 0, 0)
teleportContent.BackgroundTransparency = 0
trollContent.Visible = false
trollContent.Position = UDim2.new(0, 0, 0, 0)
trollContent.BackgroundTransparency = 0
scriptsContent.Visible = false
scriptsContent.Position = UDim2.new(0, 0, 0, 0)
scriptsContent.BackgroundTransparency = 0
gamesContent.Visible = false
gamesContent.Position = UDim2.new(0, 0, 0, 0)
gamesContent.BackgroundTransparency = 0
pvpContent.Visible = false
pvpContent.Position = UDim2.new(0, 0, 0, 0)
pvpContent.BackgroundTransparency = 0
currentTab = "Main"

-- Slider functionality
local function createSliderLogic(sliderBg, slider, label, minValue, maxValue, currentValue, updateFunction)
    local dragging = false
    local function updateSlider(value)
        local roundedValue = math.round(value)
        local percent = (roundedValue - minValue) / (maxValue - minValue)
        percent = math.clamp(percent, 0, 1)
        slider.Size = UDim2.new(percent, 0, 1, 0)
        local baseText = label.Text:match("^(.-%:)") or ""
        label.Text = baseText .. " " .. tostring(roundedValue)
        updateFunction(roundedValue)
    end
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = sliderBg.AbsolutePosition
            local sliderSize = sliderBg.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            local value = minValue + (maxValue - minValue) * relativeX
            updateSlider(value)
        end
    end)
    updateSlider(currentValue)
end

createSliderLogic(
    speedSliderBg, 
    speedSlider, 
    speedLabel, 
    16, 
    200, 
    currentSpeed, 
    function(value) 
        currentSpeed = value
        applyCharacterSettings()
    end
)

createSliderLogic(
    jumpSliderBg, 
    jumpSlider, 
    jumpLabel, 
    50, 
    500, 
    currentJump, 
    function(value) 
        currentJump = value
        applyCharacterSettings()
    end
)

createSliderLogic(
    flightSpeedSliderBg, 
    flightSpeedSlider, 
    flightSpeedLabel, 
    10,  -- Minimum flight speed
    200, -- Maximum flight speed
    flightSpeed, 
    function(value) 
        flightSpeed = value
        -- Update flight immediately if active
        if flightEnabled then
            disableFlight()
            enableFlight()
        end
    end
)

-- Noclip Functionality
local noclipEnabled = false
local noclipConnection = nil

local function enableNoclip()
    noclipEnabled = true
    noclipButton.Text = "Noclip: ON"
    noclipButton.TextColor3 = colors.text
    
    if noclipConnection then
        noclipConnection:Disconnect()
    end
    
    noclipConnection = RunService.Stepped:Connect(function()
        if noclipEnabled and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
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
    
    -- Restore collision when disabled
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

noclipButton.MouseButton1Click:Connect(function()
    if noclipEnabled then
        disableNoclip()
    else
        enableNoclip()
    end
end)

-- Flight functionality with animations
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
    for name, anim in pairs(animations) do
        tracks[name] = humanoid:LoadAnimation(anim)
    end

    return tracks
end

local function stopFlightAnimations()
    for _, track in pairs(flightTracks) do
        if track then
            track:Stop()
        end
    end
end

local function enableFlight()
    if not player.Character then return end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Clean up any existing flight objects
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
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    flightButton.Text = "Flight: ON"
    flightButton.TextColor3 = colors.success
    
    -- Load flight animations
    flightTracks = loadFlightAnimations(player.Character) or {}
end

local function disableFlight()
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    flightButton.Text = "Flight: OFF"
    flightButton.TextColor3 = colors.error
    
    -- Stop flight animations
    stopFlightAnimations()
end

flightButton.MouseButton1Click:Connect(function()
    flightEnabled = not flightEnabled
    if flightEnabled then
        enableFlight()
    else
        disableFlight()
    end
end)

-- Flight movement with animations
RunService.RenderStepped:Connect(function(dt)
    if not flightEnabled or not flyBodyVelocity then return end
    
    if not inputFlags.forward then
        forwardHold = 0
    end

    local dir = Vector3.zero
    local camCF = Workspace.CurrentCamera.CFrame

    if inputFlags.forward then dir = dir + camCF.LookVector end
    if inputFlags.back then dir = dir - camCF.LookVector end
    if inputFlags.left then dir = dir - camCF.RightVector end
    if inputFlags.right then dir = dir + camCF.RightVector end
    if inputFlags.up then dir = dir + Vector3.new(0,1,0) end
    if inputFlags.down then dir = dir + Vector3.new(0,-1,0) end

    if dir.Magnitude > 0 then
        dir = dir.Unit
    end

    flyBodyVelocity.Velocity = dir * flightSpeed
    if flyBodyGyro then
        flyBodyGyro.CFrame = camCF
    end

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
            if flightTracks.back2 then
                flightTracks.back2:Play()
                flightTracks.back2:AdjustSpeed(0)
            end
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

-- Flight input handling
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
    if humanoidRootPart then
        humanoidRootPart.CFrame = targetRoot.CFrame
    end
end

teleportButton.MouseButton1Click:Connect(function()
    teleportToPlayer(playerInput.Text)
end)

infiniteTeleportButton.MouseButton1Click:Connect(function()
    infiniteTeleportEnabled = not infiniteTeleportEnabled
    if infiniteTeleportEnabled then
        infiniteTeleportButton.Text = "Infinite Teleport: ON"
        infiniteTeleportButton.BackgroundColor3 = colors.success
        teleportConnection = RunService.Heartbeat:Connect(function()
            if playerInput.Text ~= "" then
                teleportToPlayer(playerInput.Text)
            end
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
        for _, targetPlayer in ipairs(targetPlayers) do
            SkidFling(targetPlayer)
        end
        notif("Flinging "..username, 3)
    else
        notif("Player not found!", 3)
    end
end)

flingAllButton.MouseButton1Click:Connect(function()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            SkidFling(otherPlayer)
        end
    end
    notif("Flinging everyone!", 3)
end)

-- Scripts tab functionality
saturnBypassButton.MouseButton1Click:Connect(function()
    -- SaturnBypasser script
    loadstring(game:HttpGet('https://getsaturn.pages.dev/sb.lua'))()
end)

iyButton.MouseButton1Click:Connect(function()
    -- Infinite Yield script
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

invisibilityButton.MouseButton1Click:Connect(function()
    -- Invisibility script
    loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Global/invisibility.lua"))()
end)

birdPoopButton.MouseButton1Click:Connect(function()
    -- Bird Poop script
    loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Troll/FE-Bird-Poop.lua"))()
end)

chatAdminButton.MouseButton1Click:Connect(function()
    -- ChatAdmin script
    loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Global/FE-ChatAdmin.lua"))()
end)

-- NEW VC-Unban functionality
vcUnbanButton.MouseButton1Click:Connect(function()
    VoiceChatService:joinVoice()
    notif("Voice chat unban attempted", 3)
end)

-- Games tab functionality
basketballButton.MouseButton1Click:Connect(function()
    -- Basketball script
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vnausea/absence-mini/refs/heads/main/absencemini.lua"))()
end)

bloxFruitsButton.MouseButton1Click:Connect(function()
    -- Blox Fruits script
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/GaG/Main.lua'))()
end)

tsbButton.MouseButton1Click:Connect(function()
    -- TSB script
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ATrainz/Phantasm/refs/heads/main/Games/TSB.lua"))()
end)

-- NEW GAMES BUTTONS
dtiButton.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hellohellohell012321/DTI-GUI-V2/main/dti_gui_v2.lua",true))()
    end)
end)

inkGameButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Games/Ink%20Game/ink.lua"))()
end)

mm2Button.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Roman34296589/SnapSanixHUB/refs/heads/main/SnapSanixHUB.lua'))()
end)

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
        -- Hide all tracers immediately
        for _, tracerLine in pairs(espSettings.TracerLines) do
            if tracerLine then
                tracerLine.Visible = false
            end
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
        
        -- Start aimbot loop
        if aimbotSettings.Connection then
            aimbotSettings.Connection:Disconnect()
        end
        
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

-- GUI Visibility Toggle (F4 Key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F4 and not gameProcessed then
        if screenGui.Enabled then
            -- Close animation
            TweenService:Create(mainFrame, TweenInfo.new(animationSpeed), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            delay(animationSpeed, function()
                screenGui.Enabled = false
                mainFrame.Size = UDim2.new(0, 380, 0, 500)
                mainFrame.BackgroundTransparency = 0
            end)
        else
            -- Open animation
            screenGui.Enabled = true
            mainFrame.Size = UDim2.new(0, 380, 0, 40)
            TweenService:Create(mainFrame, TweenInfo.new(animationSpeed), {
                Size = UDim2.new(0, 380, 0, 500),
                BackgroundTransparency = 0
            }):Play()
        end
    end
end)

-- Animation for main frame on initial open
delay(0.5, function()
    if screenGui and screenGui.Parent then
        screenGui.Enabled = true
        mainFrame.Size = UDim2.new(0, 380, 0, 40)
        TweenService:Create(mainFrame, TweenInfo.new(animationSpeed), {
            Size = UDim2.new(0, 380, 0, 500),
            BackgroundTransparency = 0
        }):Play()
    end
end)

-- Cleanup when GUI is closed
screenGui.Destroying:Connect(function()
    disableFlight()
    disableNoclip()
    if teleportConnection then
        teleportConnection:Disconnect()
    end
    clearAllESP()
    disableInvincibility()
    expandHitBoxes(false)
    
    -- Disable aimbot
    if aimbotSettings.Connection then
        aimbotSettings.Connection:Disconnect()
        aimbotSettings.Connection = nil
    end
    
    -- Disable triggerbot
    triggerbotEnabled = false
    if triggerbotConnection then
        triggerbotConnection = nil
    end
    
    -- Disable touch fling
    touchFlingEnabled = false
    if touchFlingThread then
        touchFlingThread = nil
    end
end)

-- Character settings and ESP update
RunService.Heartbeat:Connect(function()
    applyCharacterSettings()
    
    if espSettings.Enabled then
        updatePlayerESP()
    end
end)

-- Improved dragging functionality
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

local bannerLines = {
    "       _______        .__                         ________  ",
    "  _____\\   _  \\  __ __|  | ________         ___  _\\_____  \\ ",
    " /  ___/  /_\\  \\|  |  \\  | \\___   /  ______ \\  \\/ //  ____/ ",
    " \\___ \\\\  \\_/   \\  |  /  |  /    /  /_____/  \\   / \\___ \\  ",
    " /____  >\\___|  /____/|____/_____ \\         \\_/  /____  > ",
    "      \\/      \\/                 \\/                   \\/  "
}

for _, line in ipairs(bannerLines) do
    print(line)
end

