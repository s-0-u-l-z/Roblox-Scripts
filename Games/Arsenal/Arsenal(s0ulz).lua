local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera
local settings = {
    Aimbot = {
        Enabled = true,
        Smoothing = 0.15,
        TargetPart = "Head",
        TeamCheck = true,
        VisibleCheck = true,
        LockMode = true
    },
    TriggerBot = {
        Enabled = false,
        Delay = 0.1,
        Range = 300
    },
    Flight = {
        Enabled = false,
        Speed = 50
    },
    ESP = {
        Enabled = false,
        ShowNames = true,
        ShowDistance = true,
        ShowHealth = true,
        BoxESP = true,
        TeamCheck = true
    },
    Tracers = {
        Enabled = false,
        FromCenter = true,
        TeamCheck = true,
        Thickness = 2
    },
    Hotkeys = {
        ToggleGUI = Enum.KeyCode.F4,
        FlightToggle = Enum.KeyCode.F
    }
}
local currentTarget = nil
local triggerbotRunning = false
local aimbotConnection = nil
local triggerbotConnection = nil
local flightActive = false
local flyBodyVelocity, flyBodyGyro = nil, nil
local flightSpeed = settings.Flight.Speed

-- Dragging variables
local dragging = false
local dragStart = nil
local startPos = nil

-- ESP variables
local espObjects = {}
local tracerObjects = {}

local function getDistance(point1, point2)
    return (point1 - point2).Magnitude
end
local function getScreenPosition(position)
    local screenPos, onScreen = Camera:WorldToScreenPoint(position)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen
end
local function isVisible(targetPart)
    if not settings.Aimbot.VisibleCheck then return true end
    if not LocalPlayer.Character then return false end
    local origin = Camera.CFrame.Position
    local targetPos = targetPart.Position
    local direction = (targetPos - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
    if raycastResult then
        local hitPart = raycastResult.Instance
        local hitCharacter = hitPart.Parent
        if hitCharacter and hitCharacter:FindFirstChild("Humanoid") then
            local targetCharacter = targetPart.Parent
            if hitCharacter == targetCharacter then
                return true
            end
        end
        if not hitCharacter:FindFirstChild("Humanoid") then
            return false
        end
        return false
    end
    return true
end
local function isValidTarget(player)
    if not player or player == LocalPlayer then return false end
    if not player.Character then return false end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if settings.Aimbot.TeamCheck then
        if LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
            return false
        end
    end
    return true
end
local function getClosestTarget()
    local closestTarget = nil
    local closestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if isValidTarget(player) then
            local targetPart = player.Character:FindFirstChild(settings.Aimbot.TargetPart)
            if targetPart then
                local distance = (Camera.CFrame.Position - targetPart.Position).Magnitude
                if distance < closestDistance then
                    if isVisible(targetPart) then
                        closestDistance = distance
                        closestTarget = targetPart
                    end
                end
            end
        end
    end
    return closestTarget
end
local function smoothAim(targetPart)
    if not targetPart or not targetPart.Parent then return end
    local targetPosition = targetPart.Position
    local cameraPosition = Camera.CFrame.Position
    local direction = (targetPosition - cameraPosition).Unit
    local currentDirection = Camera.CFrame.LookVector
    local smoothFactor = 1 - settings.Aimbot.Smoothing
    local newDirection = currentDirection:Lerp(direction, smoothFactor)
    Camera.CFrame = CFrame.new(cameraPosition, cameraPosition + newDirection)
end
local function getTargetAtCrosshair()
    local target = Mouse.Target
    if not target then return nil end
    local character = target.Parent
    if not character or not character:FindFirstChild("Humanoid") then
        character = target.Parent.Parent
        if not character or not character:FindFirstChild("Humanoid") then
            return nil
        end
    end
    local player = Players:GetPlayerFromCharacter(character)
    if not player or player == LocalPlayer then return nil end
    if settings.Aimbot.TeamCheck then
        if LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
            return nil
        end
    end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil end
    local distance = getDistance(Camera.CFrame.Position, target.Position)
    if distance > settings.TriggerBot.Range then return nil end
    return character
end
local function fireWeapon()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end
local function enableFlight()
    if not LocalPlayer.Character then return end
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
    end
    flightActive = true
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
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    flightActive = false
end
local function startFlight()
    if flightActive then return end
    enableFlight()
end
local function stopFlight()
    if not flightActive then return end
    disableFlight()
end
local function startAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
    end
    aimbotConnection = RunService.Heartbeat:Connect(function()
        if not settings.Aimbot.Enabled then return end
        local target = getClosestTarget()
        if target then
            currentTarget = target
            smoothAim(target)
        else
            currentTarget = nil
        end
    end)
end
local function stopAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    currentTarget = nil
end
local function startTriggerBot()
    if triggerbotConnection then
        triggerbotConnection:Disconnect()
    end
    triggerbotConnection = RunService.Heartbeat:Connect(function()
        if not settings.TriggerBot.Enabled then return end
        if triggerbotRunning then return end
        local target = getTargetAtCrosshair()
        if target then
            triggerbotRunning = true
            fireWeapon()
            task.wait(settings.TriggerBot.Delay)
            triggerbotRunning = false
        end
    end)
end
local function stopTriggerBot()
    if triggerbotConnection then
        triggerbotConnection:Disconnect()
        triggerbotConnection = nil
    end
    triggerbotRunning = false
end

-- ESP Functions
local function createESP(player)
    if not player.Character then return end
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Clean up existing ESP for this player
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            if obj then obj:Destroy() end
        end
    end
    
    espObjects[player] = {}
    
    -- Create highlight for entire character
    if settings.ESP.BoxESP then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.7
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        espObjects[player].highlight = highlight
    end
    
    -- Create BillboardGui for names and info
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_GUI"
    billboardGui.Adornee = humanoidRootPart
    billboardGui.Size = UDim2.new(0, 200, 0, 100)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = CoreGui
    
    -- Name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Parent = billboardGui
    
    -- Distance label
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0, 15)
    distanceLabel.Position = UDim2.new(0, 0, 0, 20)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0m"
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 12
    distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distanceLabel.Parent = billboardGui
    
    -- Health label
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0, 15)
    healthLabel.Position = UDim2.new(0, 0, 0, 35)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "100 HP"
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.TextSize = 12
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextStrokeTransparency = 0
    healthLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    healthLabel.Parent = billboardGui
    
    espObjects[player].billboardGui = billboardGui
    espObjects[player].nameLabel = nameLabel
    espObjects[player].distanceLabel = distanceLabel
    espObjects[player].healthLabel = healthLabel
end

local function createTracer(player)
    if not player.Character then return end
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Clean up existing tracer
    if tracerObjects[player] then
        tracerObjects[player]:Destroy()
    end
    
    -- Check if Drawing API exists
    if Drawing then
        local tracer = Drawing.new("Line")
        tracer.Visible = true
        tracer.Color = Color3.new(1, 1, 1)
        tracer.Thickness = settings.Tracers.Thickness
        tracer.Transparency = 0.8
        tracerObjects[player] = tracer
    else
        -- Fallback: Use GUI-based tracer
        local tracerGui = Instance.new("ScreenGui")
        tracerGui.Name = "TracerGUI_" .. player.Name
        tracerGui.Parent = CoreGui
        tracerGui.IgnoreGuiInset = true
        
        local tracerFrame = Instance.new("Frame")
        tracerFrame.Size = UDim2.new(0, 2, 0, 100)
        tracerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        tracerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tracerFrame.BorderSizePixel = 0
        tracerFrame.Parent = tracerGui
        
        tracerObjects[player] = {gui = tracerGui, frame = tracerFrame, type = "gui"}
    end
end

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Team check for ESP
            if settings.ESP.TeamCheck and LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
                if espObjects[player] then
                    for _, obj in pairs(espObjects[player]) do
                        if obj and obj.Visible then obj.Visible = false end
                    end
                end
                continue
            end
            
            if settings.ESP.Enabled then
                if not espObjects[player] then
                    createESP(player)
                end
                
                if espObjects[player] then
                    -- Update visibility
                    for _, obj in pairs(espObjects[player]) do
                        if obj and obj.Visible ~= nil then obj.Visible = true end
                    end
                    
                    -- Update distance
                    if settings.ESP.ShowDistance and espObjects[player].distanceLabel then
                        local distance = math.floor((Camera.CFrame.Position - player.Character.HumanoidRootPart.Position).Magnitude)
                        espObjects[player].distanceLabel.Text = distance .. "m"
                    end
                    
                    -- Update health
                    if settings.ESP.ShowHealth and espObjects[player].healthLabel then
                        local humanoid = player.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            local health = math.floor(humanoid.Health)
                            espObjects[player].healthLabel.Text = health .. " HP"
                            -- Color based on health
                            local healthPercent = health / humanoid.MaxHealth
                            if healthPercent > 0.6 then
                                espObjects[player].healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                            elseif healthPercent > 0.3 then
                                espObjects[player].healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                            else
                                espObjects[player].healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                            end
                        end
                    end
                    
                    -- Update name visibility
                    if espObjects[player].nameLabel then
                        espObjects[player].nameLabel.Visible = settings.ESP.ShowNames
                    end
                end
            else
                -- Hide ESP
                if espObjects[player] then
                    for _, obj in pairs(espObjects[player]) do
                        if obj and obj.Visible ~= nil then obj.Visible = false end
                    end
                end
            end
        end
    end
end

local function updateTracers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Team check for tracers
            if settings.Tracers.TeamCheck and LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
                if tracerObjects[player] then
                    if tracerObjects[player].type == "gui" then
                        tracerObjects[player].gui.Enabled = false
                    else
                        tracerObjects[player].Visible = false
                    end
                end
                continue
            end
            
            if settings.Tracers.Enabled then
                if not tracerObjects[player] then
                    createTracer(player)
                end
                
                if tracerObjects[player] then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local screenPos, onScreen = Camera:WorldToScreenPoint(humanoidRootPart.Position)
                        
                        if onScreen then
                            if tracerObjects[player].type == "gui" then
                                -- GUI-based tracer
                                local tracer = tracerObjects[player]
                                tracer.gui.Enabled = true
                                
                                local startPos = settings.Tracers.FromCenter and 
                                    Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) or
                                    Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                
                                local endPos = Vector2.new(screenPos.X, screenPos.Y)
                                local distance = (endPos - startPos).Magnitude
                                local angle = math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X)
                                
                                tracer.frame.Size = UDim2.new(0, distance, 0, settings.Tracers.Thickness)
                                tracer.frame.Position = UDim2.new(0, startPos.X, 0, startPos.Y)
                                tracer.frame.Rotation = math.deg(angle)
                                tracer.frame.AnchorPoint = Vector2.new(0, 0.5)
                            else
                                -- Drawing API tracer
                                tracerObjects[player].Visible = true
                                tracerObjects[player].To = Vector2.new(screenPos.X, screenPos.Y)
                                
                                if settings.Tracers.FromCenter then
                                    tracerObjects[player].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                                else
                                    tracerObjects[player].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                end
                            end
                        else
                            if tracerObjects[player].type == "gui" then
                                tracerObjects[player].gui.Enabled = false
                            else
                                tracerObjects[player].Visible = false
                            end
                        end
                    end
                end
            else
                if tracerObjects[player] then
                    if tracerObjects[player].type == "gui" then
                        tracerObjects[player].gui.Enabled = false
                    else
                        tracerObjects[player].Visible = false
                    end
                end
            end
        end
    end
end

local function cleanupESP(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            if obj then obj:Destroy() end
        end
        espObjects[player] = nil
    end
    
    if tracerObjects[player] then
        if tracerObjects[player].type == "gui" then
            tracerObjects[player].gui:Destroy()
        else
            tracerObjects[player]:Remove()
        end
        tracerObjects[player] = nil
    end
end

-- Drag functionality
local function makeDraggable(frame, dragHandle)
    local function startDrag(input)
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
    
    local function updateDrag(input)
        if dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
    
    local function endDrag()
        dragging = false
    end
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            startDrag(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            updateDrag(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag()
        end
    end)
end

local existingGui = CoreGui:FindFirstChild("ModernAimbotGUI")
if existingGui then
    existingGui:Destroy()
end
local gui = Instance.new("ScreenGui")
gui.Name = "ModernAimbotGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

-- Centered notification banner
local banner = Instance.new("Frame")
banner.Size = UDim2.new(0, 380, 0, 40)
banner.Position = UDim2.new(0.5, -190, 0.5, -20) -- Centered on screen
banner.AnchorPoint = Vector2.new(0.5, 0.5)
banner.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
banner.BackgroundTransparency = 0.2
banner.BorderSizePixel = 0
banner.ClipsDescendants = true
banner.Parent = gui
local bannerCorner = Instance.new("UICorner")
bannerCorner.CornerRadius = UDim.new(0, 8)
bannerCorner.Parent = banner
local bannerStroke = Instance.new("UIStroke")
bannerStroke.Color = Color3.fromRGB(50, 50, 50)
bannerStroke.Thickness = 1
bannerStroke.Parent = banner
local bannerText = Instance.new("TextLabel")
bannerText.Size = UDim2.new(1, -20, 1, 0)
bannerText.Position = UDim2.new(0, 10, 0, 0)
bannerText.BackgroundTransparency = 1
bannerText.Text = "✔ Arsenal Aimbot Loaded — Press F4 to open GUI"
bannerText.Font = Enum.Font.GothamMedium
bannerText.TextSize = 14
bannerText.TextColor3 = Color3.fromRGB(220, 255, 220)
bannerText.TextXAlignment = Enum.TextXAlignment.Center -- Centered text
bannerText.Parent = banner
spawn(function()
    wait(3)
    local tween = TweenService:Create(banner, TweenInfo.new(1.5, Enum.EasingStyle.Quint), {
        Position = UDim2.new(0.5, -190, -0.1, -20), -- Slides up off screen
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Wait()
    banner:Destroy()
end)

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 380) -- Made slightly wider and taller
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = false
mainFrame.Parent = gui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(50, 50, 50)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
header.BorderSizePixel = 0
header.Parent = mainFrame
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Make the header draggable
makeDraggable(mainFrame, header)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ARSENAL AIMBOT"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.Parent = header
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 0, 30)
tabContainer.Position = UDim2.new(0, 10, 0, 45)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame
local tabs = {"Aimbot", "TriggerBot", "Flight", "ESP", "Tracers"}
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -90)
contentContainer.Position = UDim2.new(0, 10, 0, 80)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame
local tabButtons = {}
local function createTabButton(name, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.19, -2, 1, 0) -- Adjusted for 5 tabs
    btn.Position = UDim2.new((index-1) * 0.2, 0, 0, 0) -- Adjusted spacing
    btn.BackgroundColor3 = index == 1 and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(20, 20, 20)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12 -- Smaller text to fit
    btn.TextColor3 = index == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    btn.Parent = tabContainer
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    btn.MouseButton1Click:Connect(function()
        for _, content in ipairs(contentContainer:GetChildren()) do
            if content:IsA("Frame") then
                content.Visible = false
            end
        end
        if contentContainer:FindFirstChild(name) then
            contentContainer:FindFirstChild(name).Visible = true
        end
        for _, tab in ipairs(tabButtons) do
            tab.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            tab.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    table.insert(tabButtons, btn)
    return btn
end
local function createContentFrame(name)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = name == "Aimbot"
    frame.Name = name
    frame.Parent = contentContainer
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame
    return frame
end
for i, tabName in ipairs(tabs) do
    createTabButton(tabName, i)
    createContentFrame(tabName)
end
local function createModernToggle(parent, name, state, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 30)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #parent:GetChildren()
    container.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -50, 0.5, -12.5)
    toggle.BackgroundColor3 = state and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(60, 60, 60)
    toggle.Parent = container
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggle
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 21, 0, 21)
    toggleBtn.Position = state and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    toggleBtn.Text = ""
    toggleBtn.Parent = toggle
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = toggleBtn
    local enabled = state
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        local tween = TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
            Position = enabled and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        })
        tween:Play()
        toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(60, 60, 60)
        callback(enabled)
    end)
    return container
end
local function createSlider(parent, name, min, max, step, defaultValue, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #parent:GetChildren()
    container.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, 0, 0, 6)
    sliderTrack.Position = UDim2.new(0, 0, 0, 25)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = container
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderTrack
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 15, 0, 15)
    sliderBtn.Position = UDim2.new(0, 0, 0.5, -7.5)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderTrack
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = sliderBtn
    local currentValue = defaultValue
    local function updateSlider(val)
        currentValue = math.clamp(math.floor(val / step + 0.5) * step, min, max)
        local percent = (currentValue - min) / (max - min)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderBtn.Position = UDim2.new(percent, -7.5, 0.5, -7.5)
        valueLabel.Text = tostring(currentValue)
        callback(currentValue)
    end
    updateSlider(defaultValue)
    local dragging = false
    sliderBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = Players.LocalPlayer:GetMouse()
            local relativeX = mouse.X - sliderTrack.AbsolutePosition.X
            local percent = math.clamp(relativeX / sliderTrack.AbsoluteSize.X, 0, 1)
            updateSlider(min + percent * (max - min))
        end
    end)
    return container
end
spawn(function()
    wait(0.5)
    local aimbotTab = contentContainer:FindFirstChild("Aimbot")
    if aimbotTab then
        createModernToggle(aimbotTab, "Aimbot Enabled", settings.Aimbot.Enabled, function(v)
            settings.Aimbot.Enabled = v
            if v then
                startAimbot()
            else
                stopAimbot()
            end
        end)
        createModernToggle(aimbotTab, "Team Check", settings.Aimbot.TeamCheck, function(v)
            settings.Aimbot.TeamCheck = v
        end)
        createModernToggle(aimbotTab, "Visible Check", settings.Aimbot.VisibleCheck, function(v)
            settings.Aimbot.VisibleCheck = v
        end)
        createModernToggle(aimbotTab, "Constant Lock", settings.Aimbot.LockMode, function(v)
            settings.Aimbot.LockMode = v
        end)
        createSlider(aimbotTab, "Smoothing", 0, 1, 0.01, settings.Aimbot.Smoothing, function(v)
            settings.Aimbot.Smoothing = v
        end)
    end
    local triggerTab = contentContainer:FindFirstChild("TriggerBot")
    if triggerTab then
        createModernToggle(triggerTab, "TriggerBot Enabled", settings.TriggerBot.Enabled, function(v)
            settings.TriggerBot.Enabled = v
            if v then
                startTriggerBot()
            else
                stopTriggerBot()
            end
        end)
        createSlider(triggerTab, "Trigger Delay", 0, 1, 0.01, settings.TriggerBot.Delay, function(v)
            settings.TriggerBot.Delay = v
        end)
        createSlider(triggerTab, "Trigger Range", 50, 1000, 50, settings.TriggerBot.Range, function(v)
            settings.TriggerBot.Range = v
        end)
    end
    local flightTab = contentContainer:FindFirstChild("Flight")
    if flightTab then
        createModernToggle(flightTab, "Flight Enabled", settings.Flight.Enabled, function(v)
            settings.Flight.Enabled = v
            if v then
                startFlight()
            else
                stopFlight()
            end
        end)
        createSlider(flightTab, "Flight Speed", 16, 200, 1, settings.Flight.Speed, function(v)
            settings.Flight.Speed = v
            flightSpeed = v
        end)
    end
    
    local espTab = contentContainer:FindFirstChild("ESP")
    if espTab then
        createModernToggle(espTab, "ESP Enabled", settings.ESP.Enabled, function(v)
            settings.ESP.Enabled = v
        end)
        createModernToggle(espTab, "Show Names", settings.ESP.ShowNames, function(v)
            settings.ESP.ShowNames = v
        end)
        createModernToggle(espTab, "Show Distance", settings.ESP.ShowDistance, function(v)
            settings.ESP.ShowDistance = v
        end)
        createModernToggle(espTab, "Show Health", settings.ESP.ShowHealth, function(v)
            settings.ESP.ShowHealth = v
        end)
        createModernToggle(espTab, "Box ESP", settings.ESP.BoxESP, function(v)
            settings.ESP.BoxESP = v
        end)
        createModernToggle(espTab, "Team Check", settings.ESP.TeamCheck, function(v)
            settings.ESP.TeamCheck = v
        end)
    end
    
    local tracersTab = contentContainer:FindFirstChild("Tracers")
    if tracersTab then
        createModernToggle(tracersTab, "Tracers Enabled", settings.Tracers.Enabled, function(v)
            settings.Tracers.Enabled = v
        end)
        createModernToggle(tracersTab, "From Center", settings.Tracers.FromCenter, function(v)
            settings.Tracers.FromCenter = v
        end)
        createModernToggle(tracersTab, "Team Check", settings.Tracers.TeamCheck, function(v)
            settings.Tracers.TeamCheck = v
        end)
        createSlider(tracersTab, "Line Thickness", 1, 5, 1, settings.Tracers.Thickness, function(v)
            settings.Tracers.Thickness = v
            -- Update existing tracers
            for _, tracer in pairs(tracerObjects) do
                if tracer then
                    if tracer.type == "gui" then
                        tracer.frame.Size = UDim2.new(tracer.frame.Size.X.Scale, tracer.frame.Size.X.Offset, 0, v)
                    else
                        tracer.Thickness = v
                    end
                end
            end
        end)
    end
    if #tabButtons > 0 then
        tabButtons[1].BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == settings.Hotkeys.ToggleGUI then
        mainFrame.Visible = not mainFrame.Visible
    end
    if input.KeyCode == settings.Hotkeys.FlightToggle then
        settings.Flight.Enabled = not settings.Flight.Enabled
        if settings.Flight.Enabled then
            startFlight()
        else
            stopFlight()
        end
    end
end)
if settings.Aimbot.Enabled then
    startAimbot()
end

-- Start ESP and Tracers update loop
spawn(function()
    -- Check if Drawing API is available
    if not Drawing then
        warn("Drawing API not available - using GUI-based tracers instead")
    end
    
    while true do
        updateESP()
        updateTracers()
        wait(0.1) -- Update every 0.1 seconds for performance
    end
end)

-- Clean up when players leave
Players.PlayerRemoving:Connect(function(player)
    cleanupESP(player)
end)
RunService.Heartbeat:Connect(function()
    if not flightActive then return end
    local moveDirection = Vector3.new(0, 0, 0)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + Camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - Camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - Camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + Camera.CFrame.RightVector
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
    if flyBodyVelocity then
        flyBodyVelocity.Velocity = moveDirection
    end
    if flyBodyGyro and moveDirection.Magnitude > 0 then
        local lookVector = Vector3.new(moveDirection.X, 0, moveDirection.Z)
        if lookVector.Magnitude > 0 then
            flyBodyGyro.CFrame = CFrame.new(Vector3.new(), lookVector)
        end
    end
end)
LocalPlayer.CharacterAdded:Connect(function(character)
    if flightActive then
        task.wait(0.5)
        startFlight()
    end
end)
gui.Destroying:Connect(function()
    stopFlight()
end)
print("[INFO] Arsenal Aimbot v1.2 initialized — GUI: F4")
print("[DEV] Script by s-0-u-l-z")
