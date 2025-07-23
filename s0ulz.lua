-- Modern Roblox GUI Script (Enhanced with Animations)
-- Provides controls for player speed, jump power, flight, teleport, fling mechanics, extra utilities, and PVP features

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Local player reference
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Script environment for storing values
local scriptEnv = {
    FPDH = workspace.FallenPartsDestroyHeight,
    OldPos = nil
}

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "s0ulz GUI";
    Text = "All hail the certified ball sucker";
    Duration = 5
})

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Info";
    Text = "Click F4 to open and close the GUI";
    Duration = 10
})

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

-- Main Frame (Increased height for new features)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 350, 0, 470) -- Increased height
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

-- Add rounded corners to MainFrame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 36)

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleBar
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "s0ulz"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Parent = titleBar
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
minimizeButton.Position = UDim2.new(1, -65, 0.5, -10)
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 14
minimizeButton.ZIndex = 2

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 10)
minimizeCorner.Parent = minimizeButton

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Parent = titleBar
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Position = UDim2.new(1, -35, 0.5, -10)
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "ￃﾗ"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.ZIndex = 2

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

-- Button hover animations
local function setupButtonHover(button)
    local originalColor = button.BackgroundColor3
    local hoverColor = Color3.new(
        math.min(originalColor.R * 1.2, 1),
        math.min(originalColor.G * 1.2, 1),
        math.min(originalColor.B * 1.2, 1)
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

-- Minimize/restore with animations
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        -- Minimize animation
        TweenService:Create(mainFrame, TweenInfo.new(animationSpeed, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 350, 0, 36)
        }):Play()
        
        -- Fade out content
        for _, child in pairs(mainFrame:GetChildren()) do
            if child ~= titleBar and child ~= corner then
                TweenService:Create(child, TweenInfo.new(animationSpeed), {
                    BackgroundTransparency = 1
                }):Play()
            end
        end
        
        -- Hide content after animation
        delay(animationSpeed, function()
            for _, child in pairs(mainFrame:GetChildren()) do
                if child ~= titleBar and child ~= corner then
                    child.Visible = false
                end
            end
        end)
    else
        -- Show content before animation
        for _, child in pairs(mainFrame:GetChildren()) do
            if child ~= titleBar and child ~= corner then
                child.Visible = true
                child.BackgroundTransparency = 1
            end
        end
        
        -- Restore animation
        TweenService:Create(mainFrame, TweenInfo.new(animationSpeed, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 350, 0, 470)
        }):Play()
        
        -- Fade in content
        delay(animationSpeed/2, function()
            for _, child in pairs(mainFrame:GetChildren()) do
                if child ~= titleBar and child ~= corner then
                    TweenService:Create(child, TweenInfo.new(animationSpeed), {
                        BackgroundTransparency = 0
                    }):Play()
                end
            end
        end)
    end
end)

-- Close button with animation
closeButton.MouseButton1Click:Connect(function()
    -- Fade out animation
    TweenService:Create(mainFrame, TweenInfo.new(animationSpeed), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    -- Destroy after animation completes
    delay(animationSpeed, function()
        screenGui:Destroy()
    end)
end)

-- Tab System
local tabFrame = Instance.new("Frame")
tabFrame.Parent = mainFrame
tabFrame.BackgroundTransparency = 1
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.Size = UDim2.new(1, 0, 0, 32)

-- Changed "Fling" to "Troll"
local tabs = {"Main", "Teleport", "Troll", "Extra", "PVP"}
local tabButtons = {}

-- Create Tab Buttons (adjusted for 5 tabs)
for i, tabName in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName .. "Tab"
    tabButton.Parent = tabFrame
    tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    tabButton.Position = UDim2.new((i-1) * 0.2, 2, 0, 4)
    tabButton.Size = UDim2.new(0.2, -4, 1, -8)
    tabButton.Font = Enum.Font.Gotham
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.TextSize = 12
    tabButton.TextScaled = true

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabButton
    
    setupButtonHover(tabButton)

    tabButtons[tabName] = tabButton
end

-- Content Area (reduced vertical padding)
local contentArea = Instance.new("Frame")
contentArea.Parent = mainFrame
contentArea.BackgroundTransparency = 1
contentArea.Position = UDim2.new(0, 8, 0, 80)
contentArea.Size = UDim2.new(1, -16, 1, -90)

-- Main Tab Content
local mainContent = Instance.new("Frame")
mainContent.Name = "MainContent"
mainContent.Parent = contentArea
mainContent.BackgroundTransparency = 1
mainContent.Size = UDim2.new(1, 0, 1, 0)
mainContent.Visible = true
mainContent.BackgroundTransparency = 0
mainContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainContent.ClipsDescendants = true

-- Speed Slider
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainContent
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 0, 0, 10)
speedLabel.Size = UDim2.new(1, 0, 0, 22)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Speed: 16"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 14
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedSliderBg = Instance.new("Frame")
speedSliderBg.Parent = mainContent
speedSliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedSliderBg.Position = UDim2.new(0, 0, 0, 34)
speedSliderBg.Size = UDim2.new(1, 0, 0, 16)

local speedSliderBgCorner = Instance.new("UICorner")
speedSliderBgCorner.CornerRadius = UDim.new(0, 10)
speedSliderBgCorner.Parent = speedSliderBg

local speedSlider = Instance.new("Frame")
speedSlider.Parent = speedSliderBg
speedSlider.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
speedSlider.Position = UDim2.new(0, 0, 0, 0)
speedSlider.Size = UDim2.new(0.2, 0, 1, 0)

local speedSliderCorner = Instance.new("UICorner")
speedSliderCorner.CornerRadius = UDim.new(0, 10)
speedSliderCorner.Parent = speedSlider

-- Jump Power Slider
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Parent = mainContent
jumpLabel.BackgroundTransparency = 1
jumpLabel.Position = UDim2.new(0, 0, 0, 60)
jumpLabel.Size = UDim2.new(1, 0, 0, 22)
jumpLabel.Font = Enum.Font.Gotham
jumpLabel.Text = "Jump Power: 50"
jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpLabel.TextSize = 14
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left

local jumpSliderBg = Instance.new("Frame")
jumpSliderBg.Parent = mainContent
jumpSliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpSliderBg.Position = UDim2.new(0, 0, 0, 84)
jumpSliderBg.Size = UDim2.new(1, 0, 0, 16)

local jumpSliderBgCorner = Instance.new("UICorner")
jumpSliderBgCorner.CornerRadius = UDim.new(0, 10)
jumpSliderBgCorner.Parent = jumpSliderBg

local jumpSlider = Instance.new("Frame")
jumpSlider.Parent = jumpSliderBg
jumpSlider.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
jumpSlider.Position = UDim2.new(0, 0, 0, 0)
jumpSlider.Size = UDim2.new(0.2, 0, 1, 0)

local jumpSliderCorner = Instance.new("UICorner")
jumpSliderCorner.CornerRadius = UDim.new(0, 10)
jumpSliderCorner.Parent = jumpSlider

-- Flight Toggle
local flightButton = Instance.new("TextButton")
flightButton.Parent = mainContent
flightButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flightButton.Position = UDim2.new(0, 0, 0, 112)
flightButton.Size = UDim2.new(1, 0, 0, 32)
flightButton.Font = Enum.Font.GothamBold
flightButton.Text = "Flight: OFF"
flightButton.TextColor3 = Color3.fromRGB(255, 100, 100)
flightButton.TextSize = 16

local flightCorner = Instance.new("UICorner")
flightCorner.CornerRadius = UDim.new(0, 8)
flightCorner.Parent = flightButton

setupButtonHover(flightButton)

-- Teleport Tab Content
local teleportContent = Instance.new("Frame")
teleportContent.Name = "TeleportContent"
teleportContent.Parent = contentArea
teleportContent.BackgroundTransparency = 1
teleportContent.Size = UDim2.new(1, 0, 1, 0)
teleportContent.Visible = false
teleportContent.BackgroundTransparency = 0
teleportContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
teleportContent.ClipsDescendants = true

local playerInput = Instance.new("TextBox")
playerInput.Parent = teleportContent
playerInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
playerInput.Position = UDim2.new(0, 0, 0, 10)
playerInput.Size = UDim2.new(1, 0, 0, 28)
playerInput.Font = Enum.Font.Gotham
playerInput.PlaceholderText = "Enter player username..."
playerInput.Text = ""
playerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
playerInput.TextSize = 14

local playerInputCorner = Instance.new("UICorner")
playerInputCorner.CornerRadius = UDim.new(0, 8)
playerInputCorner.Parent = playerInput

local teleportButton = Instance.new("TextButton")
teleportButton.Parent = teleportContent
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
teleportButton.Position = UDim2.new(0, 0, 0, 44)
teleportButton.Size = UDim2.new(1, 0, 0, 28)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.Text = "Teleport"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextSize = 16

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 8)
teleportCorner.Parent = teleportButton

setupButtonHover(teleportButton)

local infiniteTeleportButton = Instance.new("TextButton")
infiniteTeleportButton.Parent = teleportContent
infiniteTeleportButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
infiniteTeleportButton.Position = UDim2.new(0, 0, 0, 80)
infiniteTeleportButton.Size = UDim2.new(1, 0, 0, 28)
infiniteTeleportButton.Font = Enum.Font.GothamBold
infiniteTeleportButton.Text = "Infinite Teleport: OFF"
infiniteTeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infiniteTeleportButton.TextSize = 16

local infTeleportCorner = Instance.new("UICorner")
infTeleportCorner.CornerRadius = UDim.new(0, 8)
infTeleportCorner.Parent = infiniteTeleportButton

setupButtonHover(infiniteTeleportButton)

-- Troll Tab Content (replaces Fling tab)
local trollContent = Instance.new("Frame")
trollContent.Name = "TrollContent"
trollContent.Parent = contentArea
trollContent.BackgroundTransparency = 1
trollContent.Size = UDim2.new(1, 0, 1, 0)
trollContent.Visible = false
trollContent.BackgroundTransparency = 0
trollContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
trollContent.ClipsDescendants = true

-- Player Input for Fling
local playerFlingInput = Instance.new("TextBox")
playerFlingInput.Parent = trollContent
playerFlingInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
playerFlingInput.Position = UDim2.new(0, 0, 0, 10)
playerFlingInput.Size = UDim2.new(1, 0, 0, 28)
playerFlingInput.Font = Enum.Font.Gotham
playerFlingInput.PlaceholderText = "Enter player username to fling..."
playerFlingInput.Text = ""
playerFlingInput.TextColor3 = Color3.fromRGB(255, 255, 255)
playerFlingInput.TextSize = 14

local playerFlingInputCorner = Instance.new("UICorner")
playerFlingInputCorner.CornerRadius = UDim.new(0, 8)
playerFlingInputCorner.Parent = playerFlingInput

-- Fling Player Button
local flingPlayerButton = Instance.new("TextButton")
flingPlayerButton.Parent = trollContent
flingPlayerButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
flingPlayerButton.Position = UDim2.new(0, 0, 0, 46)  -- Adjusted position
flingPlayerButton.Size = UDim2.new(1, 0, 0, 32)
flingPlayerButton.Font = Enum.Font.GothamBold
flingPlayerButton.Text = "Fling Player"
flingPlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flingPlayerButton.TextSize = 16

local flingPlayerCorner = Instance.new("UICorner")
flingPlayerCorner.CornerRadius = UDim.new(0, 8)
flingPlayerCorner.Parent = flingPlayerButton

setupButtonHover(flingPlayerButton)

-- Fling All Button
local flingAllButton = Instance.new("TextButton")
flingAllButton.Parent = trollContent
flingAllButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
flingAllButton.Position = UDim2.new(0, 0, 0, 82)  -- Adjusted position
flingAllButton.Size = UDim2.new(1, 0, 0, 32)
flingAllButton.Font = Enum.Font.GothamBold
flingAllButton.Text = "Fling Everyone"
flingAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flingAllButton.TextSize = 16

local flingAllCorner = Instance.new("UICorner")
flingAllCorner.CornerRadius = UDim.new(0, 8)
flingAllCorner.Parent = flingAllButton

setupButtonHover(flingAllButton)

-- Touch Fling Button
local touchFlingButton = Instance.new("TextButton")
touchFlingButton.Parent = trollContent
touchFlingButton.BackgroundColor3 = Color3.fromRGB(180, 80, 180)
touchFlingButton.Position = UDim2.new(0, 0, 0, 118)  -- Position below Fling Everyone
touchFlingButton.Size = UDim2.new(1, 0, 0, 32)
touchFlingButton.Font = Enum.Font.GothamBold
touchFlingButton.Text = "Touch Fling: OFF"
touchFlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
touchFlingButton.TextSize = 16

local touchFlingCorner = Instance.new("UICorner")
touchFlingCorner.CornerRadius = UDim.new(0, 8)
touchFlingCorner.Parent = touchFlingButton

setupButtonHover(touchFlingButton)

-- Extra Tab Content
local extraContent = Instance.new("Frame")
extraContent.Name = "ExtraContent"
extraContent.Parent = contentArea
extraContent.BackgroundTransparency = 1
extraContent.Size = UDim2.new(1, 0, 1, 0)
extraContent.Visible = false
extraContent.BackgroundTransparency = 0
extraContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
extraContent.ClipsDescendants = true

-- New Invisibility Button
local invisibilityButton = Instance.new("TextButton")
invisibilityButton.Parent = extraContent
invisibilityButton.BackgroundColor3 = Color3.fromRGB(80, 180, 180)
invisibilityButton.Position = UDim2.new(0, 0, 0, 10)
invisibilityButton.Size = UDim2.new(0.5, -4, 0, 28)
invisibilityButton.Font = Enum.Font.GothamBold
invisibilityButton.Text = "Invisibility"
invisibilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invisibilityButton.TextSize = 16

local invisibilityCorner = Instance.new("UICorner")
invisibilityCorner.CornerRadius = UDim.new(0, 8)
invisibilityCorner.Parent = invisibilityButton

setupButtonHover(invisibilityButton)

-- SaturnBypasser Button (Renamed from CatBypasser)
local saturnBypassButton = Instance.new("TextButton")
saturnBypassButton.Parent = extraContent
saturnBypassButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
saturnBypassButton.Position = UDim2.new(0.5, 4, 0, 10)
saturnBypassButton.Size = UDim2.new(0.5, -4, 0, 28)
saturnBypassButton.Font = Enum.Font.GothamBold
saturnBypassButton.Text = "SaturnBypasser"
saturnBypassButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saturnBypassButton.TextSize = 16

local saturnBypassCorner = Instance.new("UICorner")
saturnBypassCorner.CornerRadius = UDim.new(0, 8)
saturnBypassCorner.Parent = saturnBypassButton

setupButtonHover(saturnBypassButton)

-- IY Button
local iyButton = Instance.new("TextButton")
iyButton.Parent = extraContent
iyButton.BackgroundColor3 = Color3.fromRGB(180, 80, 180)
iyButton.Position = UDim2.new(0, 0, 0, 46)
iyButton.Size = UDim2.new(0.5, -4, 0, 28)
iyButton.Font = Enum.Font.GothamBold
iyButton.Text = "IY (Infinite Yield)"
iyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
iyButton.TextSize = 16

local iyCorner = Instance.new("UICorner")
iyCorner.CornerRadius = UDim.new(0, 8)
iyCorner.Parent = iyButton

setupButtonHover(iyButton)

-- Bird Poop Button
local birdPoopButton = Instance.new("TextButton")
birdPoopButton.Parent = extraContent
birdPoopButton.BackgroundColor3 = Color3.fromRGB(180, 100, 80)
birdPoopButton.Position = UDim2.new(0.5, 4, 0, 46)
birdPoopButton.Size = UDim2.new(0.5, -4, 0, 28)
birdPoopButton.Font = Enum.Font.GothamBold
birdPoopButton.Text = "Bird Poop"
birdPoopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
birdPoopButton.TextSize = 16

local birdPoopCorner = Instance.new("UICorner")
birdPoopCorner.CornerRadius = UDim.new(0, 8)
birdPoopCorner.Parent = birdPoopButton

setupButtonHover(birdPoopButton)

-- Basketball Button
local basketballButton = Instance.new("TextButton")
basketballButton.Parent = extraContent
basketballButton.BackgroundColor3 = Color3.fromRGB(80, 100, 180)
basketballButton.Position = UDim2.new(0, 0, 0, 82)
basketballButton.Size = UDim2.new(0.5, -4, 0, 28)
basketballButton.Font = Enum.Font.GothamBold
basketballButton.Text = "Basketball"
basketballButton.TextColor3 = Color3.fromRGB(255, 255, 255)
basketballButton.TextSize = 16

local basketballCorner = Instance.new("UICorner")
basketballCorner.CornerRadius = UDim.new(0, 8)
basketballCorner.Parent = basketballButton

setupButtonHover(basketballButton)

-- Fruit Button
local fruitButton = Instance.new("TextButton")
fruitButton.Parent = extraContent
fruitButton.BackgroundColor3 = Color3.fromRGB(100, 180, 80)
fruitButton.Position = UDim2.new(0.5, 4, 0, 82)
fruitButton.Size = UDim2.new(0.5, -4, 0, 28)
fruitButton.Font = Enum.Font.GothamBold
fruitButton.Text = "Fruit"
fruitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fruitButton.TextSize = 16

local fruitCorner = Instance.new("UICorner")
fruitCorner.CornerRadius = UDim.new(0, 8)
fruitCorner.Parent = fruitButton

setupButtonHover(fruitButton)

-- TSB Button
local tsbButton = Instance.new("TextButton")
tsbButton.Parent = extraContent
tsbButton.BackgroundColor3 = Color3.fromRGB(180, 80, 100)
tsbButton.Position = UDim2.new(0, 0, 0, 118)
tsbButton.Size = UDim2.new(0.5, -4, 0, 28)
tsbButton.Font = Enum.Font.GothamBold
tsbButton.Text = "TSB"
tsbButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tsbButton.TextSize = 16

local tsbCorner = Instance.new("UICorner")
tsbCorner.CornerRadius = UDim.new(0, 8)
tsbCorner.Parent = tsbButton

setupButtonHover(tsbButton)

-- ChatAdmin Button
local chatAdminButton = Instance.new("TextButton")
chatAdminButton.Parent = extraContent
chatAdminButton.BackgroundColor3 = Color3.fromRGB(80, 180, 180)
chatAdminButton.Position = UDim2.new(0.5, 4, 0, 118)
chatAdminButton.Size = UDim2.new(0.5, -4, 0, 28)
chatAdminButton.Font = Enum.Font.GothamBold
chatAdminButton.Text = "ChatAdmin"
chatAdminButton.TextColor3 = Color3.fromRGB(255, 255, 255)
chatAdminButton.TextSize = 16

local chatAdminCorner = Instance.new("UICorner")
chatAdminCorner.CornerRadius = UDim.new(0, 8)
chatAdminCorner.Parent = chatAdminButton

setupButtonHover(chatAdminButton)

-- PVP Tab Content
local pvpContent = Instance.new("Frame")
pvpContent.Name = "PVPContent"
pvpContent.Parent = contentArea
pvpContent.BackgroundTransparency = 1
pvpContent.Size = UDim2.new(1, 0, 1, 0)
pvpContent.Visible = false
pvpContent.BackgroundTransparency = 0
pvpContent.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
pvpContent.ClipsDescendants = true

-- ESP Toggle
local espToggle = Instance.new("TextButton")
espToggle.Parent = pvpContent
espToggle.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
espToggle.Position = UDim2.new(0, 0, 0, 10)
espToggle.Size = UDim2.new(1, 0, 0, 26)
espToggle.Font = Enum.Font.GothamBold
espToggle.Text = "ESP: OFF"
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.TextSize = 16

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 8)
espCorner.Parent = espToggle

setupButtonHover(espToggle)

-- Tracer Toggle
local tracerToggle = Instance.new("TextButton")
tracerToggle.Parent = pvpContent
tracerToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
tracerToggle.Position = UDim2.new(0, 0, 0, 44)
tracerToggle.Size = UDim2.new(1, 0, 0, 26)
tracerToggle.Font = Enum.Font.GothamBold
tracerToggle.Text = "Tracers: OFF"
tracerToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
tracerToggle.TextSize = 16

local tracerCorner = Instance.new("UICorner")
tracerCorner.CornerRadius = UDim.new(0, 8)
tracerCorner.Parent = tracerToggle

setupButtonHover(tracerToggle)

-- Invincible Toggle
local invincibleButton = Instance.new("TextButton")
invincibleButton.Parent = pvpContent
invincibleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
invincibleButton.Position = UDim2.new(0, 0, 0, 78)
invincibleButton.Size = UDim2.new(1, 0, 0, 26)
invincibleButton.Font = Enum.Font.GothamBold
invincibleButton.Text = "Invincible: OFF"
invincibleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invincibleButton.TextSize = 16

local invincibleCorner = Instance.new("UICorner")
invincibleCorner.CornerRadius = UDim.new(0, 8)
invincibleCorner.Parent = invincibleButton

setupButtonHover(invincibleButton)

-- Aimbot Toggle
local aimbotButton = Instance.new("TextButton")
aimbotButton.Parent = pvpContent
aimbotButton.BackgroundColor3 = Color3.fromRGB(180, 80, 180)
aimbotButton.Position = UDim2.new(0, 0, 0, 112)
aimbotButton.Size = UDim2.new(1, 0, 0, 26)
aimbotButton.Font = Enum.Font.GothamBold
aimbotButton.Text = "Aimbot: OFF"
aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.TextSize = 16

local aimbotCorner = Instance.new("UICorner")
aimbotCorner.CornerRadius = UDim.new(0, 8)
aimbotCorner.Parent = aimbotButton

setupButtonHover(aimbotButton)

-- Triggerbot Toggle
local triggerbotButton = Instance.new("TextButton")
triggerbotButton.Parent = pvpContent
triggerbotButton.BackgroundColor3 = Color3.fromRGB(180, 180, 80)
triggerbotButton.Position = UDim2.new(0, 0, 0, 146)
triggerbotButton.Size = UDim2.new(1, 0, 0, 26)
triggerbotButton.Font = Enum.Font.GothamBold
triggerbotButton.Text = "Triggerbot: OFF"
triggerbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
triggerbotButton.TextSize = 16

local triggerbotCorner = Instance.new("UICorner")
triggerbotCorner.CornerRadius = UDim.new(0, 8)
triggerbotCorner.Parent = triggerbotButton

setupButtonHover(triggerbotButton)

-- Hit Box Expander Toggle
local hitboxButton = Instance.new("TextButton")
hitboxButton.Parent = pvpContent
hitboxButton.BackgroundColor3 = Color3.fromRGB(100, 80, 180)
hitboxButton.Position = UDim2.new(0, 0, 0, 180)
hitboxButton.Size = UDim2.new(1, 0, 0, 26)
hitboxButton.Font = Enum.Font.GothamBold
hitboxButton.Text = "Hit Box Expander: OFF"
hitboxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxButton.TextSize = 16

local hitboxCorner = Instance.new("UICorner")
hitboxCorner.CornerRadius = UDim.new(0, 8)
hitboxCorner.Parent = hitboxButton

setupButtonHover(hitboxButton)

-- Anti-Kick Toggle
local antiKickButton = Instance.new("TextButton")
antiKickButton.Parent = pvpContent
antiKickButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
antiKickButton.Position = UDim2.new(0, 0, 0, 214)
antiKickButton.Size = UDim2.new(1, 0, 0, 26)
antiKickButton.Font = Enum.Font.GothamBold
antiKickButton.Text = "Anti-Kick: ON"
antiKickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
antiKickButton.TextSize = 16

local antiKickCorner = Instance.new("UICorner")
antiKickCorner.CornerRadius = UDim.new(0, 8)
antiKickCorner.Parent = antiKickButton

setupButtonHover(antiKickButton)

-- Anti-Detection Toggle
local antiDetectionButton = Instance.new("TextButton")
antiDetectionButton.Parent = pvpContent
antiDetectionButton.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
antiDetectionButton.Position = UDim2.new(0, 0, 0, 248)
antiDetectionButton.Size = UDim2.new(1, 0, 0, 26)
antiDetectionButton.Font = Enum.Font.GothamBold
antiDetectionButton.Text = "Anti-Detection: ON"
antiDetectionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
antiDetectionButton.TextSize = 16

local antiDetectionCorner = Instance.new("UICorner")
antiDetectionCorner.CornerRadius = UDim.new(0, 8)
antiDetectionCorner.Parent = antiDetectionButton

setupButtonHover(antiDetectionButton)

-- ===== FIXED ESP AND TRACER SYSTEM =====
local espSettings = {
    Enabled = false,
    Tracers = false,
    Players = {},
    Highlights = {},
    Billboards = {},
    TracerLines = {},
    TeamCheck = true,
    MaxDistance = 500,
    HighlightColor = Color3.fromRGB(255, 255, 255)  -- White highlight
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
local hitboxExpansionAmount = 1.5 -- 50% larger hitboxes

-- Function to expand hit boxes
local function expandHitBoxes(enable)
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local char = otherPlayer.Character
            if char then
                if enable then
                    -- Store original sizes and expand
                    originalSizes[otherPlayer] = {}
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            originalSizes[otherPlayer][part] = part.Size
                            part.Size = part.Size * hitboxExpansionAmount
                        end
                    end
                else
                    -- Revert to original sizes
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

-- ===== FIXED TRACER SYSTEM =====
local function createPlayerESP(targetPlayer)
    if espSettings.Players[targetPlayer] then return end
    
    local character = targetPlayer.Character
    if not character then
        -- Wait for character to load
        targetPlayer.CharacterAdded:Wait()
        character = targetPlayer.Character
    end
    
    -- Create highlight
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
            or TargetPlayer.Parent ~= Players
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
                        triggerbotButton.BackgroundColor3 = Color3.fromRGB(180, 180, 80)
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
        triggerbotButton.BackgroundColor3 = Color3.fromRGB(180, 180, 80)
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
        touchFlingButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Start the fling loop in a separate thread
        touchFlingThread = coroutine.wrap(touchFlingLoop)()
        touchFlingThread()
    else
        touchFlingButton.Text = "Touch Fling: OFF"
        touchFlingButton.BackgroundColor3 = Color3.fromRGB(180, 80, 180)
        
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
local infiniteTeleportEnabled = false
local flyBodyVelocity, flyBodyGyro = nil, nil
local teleportConnection = nil
local flightSpeed = 50

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
    Extra = extraContent,
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
            button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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
extraContent.Visible = false
extraContent.Position = UDim2.new(0, 0, 0, 0)
extraContent.BackgroundTransparency = 0
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

-- Flight functionality
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
    flightButton.TextColor3 = Color3.fromRGB(100, 255, 100)
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
    flightButton.TextColor3 = Color3.fromRGB(255, 100, 100)
end

flightButton.MouseButton1Click:Connect(function()
    flightEnabled = not flightEnabled
    if flightEnabled then
        enableFlight()
    else
        disableFlight()
    end
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
        infiniteTeleportButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        teleportConnection = RunService.Heartbeat:Connect(function()
            if playerInput.Text ~= "" then
                teleportToPlayer(playerInput.Text)
            end
        end)
    else
        infiniteTeleportButton.Text = "Infinite Teleport: OFF"
        infiniteTeleportButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
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

-- Extra tab functionality
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
    loadstring(game:HttpGet("https://pastebin.com/raw/vP6CrQJj"))()
end)

-- New scripts functionality
birdPoopButton.MouseButton1Click:Connect(function()
    -- Bird Poop script
    loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Troll/FE-Bird-Poop.lua"))()
end)

basketballButton.MouseButton1Click:Connect(function()
    -- Basketball script
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vnausea/absence-mini/refs/heads/main/absencemini.lua"))()
end)

fruitButton.MouseButton1Click:Connect(function()
    -- Fruit script
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/GaG/Main.lua'))()
end)

tsbButton.MouseButton1Click:Connect(function()
    -- TSB script
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ATrainz/Phantasm/refs/heads/main/Games/TSB.lua"))()
end)

chatAdminButton.MouseButton1Click:Connect(function()
    -- ChatAdmin script
    loadstring(game:HttpGet("https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Global/FE-ChatAdmin.lua"))()
end)

-- PVP tab functionality
espToggle.MouseButton1Click:Connect(function()
    espSettings.Enabled = not espSettings.Enabled
    
    if espSettings.Enabled then
        espToggle.Text = "ESP: ON"
        espToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        setupESP()
    else
        espToggle.Text = "ESP: OFF"
        espToggle.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
        clearAllESP()
    end
end)

-- Tracer button functionality
tracerToggle.MouseButton1Click:Connect(function()
    espSettings.Tracers = not espSettings.Tracers
    
    if espSettings.Tracers then
        tracerToggle.Text = "Tracers: ON"
        tracerToggle.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    else
        tracerToggle.Text = "Tracers: OFF"
        tracerToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        -- Hide all tracers immediately
        for _, tracerLine in pairs(espSettings.TracerLines) do
            if tracerLine then
                tracerLine.Visible = false
            end
        end
    end
end)

-- Invincible button functionality
invincibleButton.MouseButton1Click:Connect(function()
    invincibleEnabled = not invincibleEnabled
    
    if invincibleEnabled then
        invincibleButton.Text = "Invincible: ON"
        invincibleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        enableInvincibility()
    else
        invincibleButton.Text = "Invincible: OFF"
        invincibleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
        disableInvincibility()
    end
end)

-- Aimbot button functionality (fixed)
aimbotButton.MouseButton1Click:Connect(function()
    aimbotSettings.Enabled = not aimbotSettings.Enabled
    
    if aimbotSettings.Enabled then
        aimbotButton.Text = "Aimbot: ON"
        aimbotButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
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
                aimbotButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            end
        end)
    else
        aimbotButton.Text = "Aimbot: OFF"
        aimbotButton.BackgroundColor3 = Color3.fromRGB(180, 80, 180)
        if aimbotSettings.Connection then
            aimbotSettings.Connection:Disconnect()
            aimbotSettings.Connection = nil
        end
    end
end)

-- Triggerbot button functionality
triggerbotButton.MouseButton1Click:Connect(function()
    triggerbotEnabled = not triggerbotEnabled
    
    if triggerbotEnabled then
        triggerbotButton.Text = "Triggerbot: ON"
        triggerbotButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        toggleTriggerbot()
    else
        triggerbotButton.Text = "Triggerbot: OFF"
        triggerbotButton.BackgroundColor3 = Color3.fromRGB(180, 180, 80)
        toggleTriggerbot()
    end
end)

-- Hit Box Expander functionality
hitboxButton.MouseButton1Click:Connect(function()
    hitboxExpanderEnabled = not hitboxExpanderEnabled
    
    if hitboxExpanderEnabled then
        hitboxButton.Text = "Hit Box Expander: ON"
        hitboxButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        expandHitBoxes(true)
    else
        hitboxButton.Text = "Hit Box Expander: OFF"
        hitboxButton.BackgroundColor3 = Color3.fromRGB(100, 80, 180)
        expandHitBoxes(false)
    end
end)

-- Anti-Kick button functionality
antiKickButton.MouseButton1Click:Connect(function()
    antiKickEnabled = not antiKickEnabled
    
    if antiKickEnabled then
        antiKickButton.Text = "Anti-Kick: ON"
        antiKickButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    else
        antiKickButton.Text = "Anti-Kick: OFF"
        antiKickButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    end
end)

-- Anti-Detection button functionality
antiDetectionButton.MouseButton1Click:Connect(function()
    antiDetectionEnabled = not antiDetectionEnabled
    
    if antiDetectionEnabled then
        antiDetectionButton.Text = "Anti-Detection: ON"
        antiDetectionButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    else
        antiDetectionButton.Text = "Anti-Detection: OFF"
        antiDetectionButton.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
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
                mainFrame.Size = UDim2.new(0, 350, 0, 470)
                mainFrame.BackgroundTransparency = 0
            end)
        else
            -- Open animation
            screenGui.Enabled = true
            mainFrame.Size = UDim2.new(0, 350, 0, 36)
            TweenService:Create(mainFrame, TweenInfo.new(animationSpeed), {
                Size = UDim2.new(0, 350, 0, 470),
                BackgroundTransparency = 0
            }):Play()
        end
    end
end)

-- Animation for main frame on initial open
delay(0.5, function()
    if screenGui and screenGui.Parent then
        screenGui.Enabled = true
        mainFrame.Size = UDim2.new(0, 350, 0, 36)
        TweenService:Create(mainFrame, TweenInfo.new(animationSpeed), {
            Size = UDim2.new(0, 350, 0, 470),
            BackgroundTransparency = 0
        }):Play()
    end
end)

-- Cleanup when GUI is closed
screenGui.Destroying:Connect(function()
    disableFlight()
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

-- Flight movement
RunService.Heartbeat:Connect(function()
    if not flightEnabled or not flyBodyVelocity then return end
    local moveDirection = Vector3.new(0, 0, 0)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + Workspace.CurrentCamera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - Workspace.CurrentCamera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - Workspace.CurrentCamera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + Workspace.CurrentCamera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveDirection = moveDirection + Vector3.new(0, -1, 0)
    end
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * flightSpeed
    end
    flyBodyVelocity.Velocity = moveDirection
    if flyBodyGyro and moveDirection.Magnitude > 0 then
        local lookVector = Vector3.new(moveDirection.X, 0, moveDirection.Z)
        if lookVector.Magnitude > 0 then
            flyBodyGyro.CFrame = CFrame.new(Vector3.new(), lookVector)
        end
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
