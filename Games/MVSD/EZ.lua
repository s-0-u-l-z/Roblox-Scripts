repeat task.wait() until game:IsLoaded()

-- WINDUI LOADING
local WindUI
local success, result = pcall(function()
    local loaded = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    -- Handle both function and module returns
    if type(loaded) == "table" and type(loaded.SetTheme) == "function" then
        return loaded
    else
        return loaded
    end
end)

if not success then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "WindUI Error",
        Text = "Failed to load UI: " .. tostring(result),
        Duration = 6
    })
    return
end

if type(result) == "table" and type(result.SetTheme) == "function" then
    WindUI = result
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "WindUI Error",
        Text = "Invalid UI format: " .. type(result),
        Duration = 6
    })
    return
end

-- SERVICES - CACHED ONCE FOR PERFORMANCE
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- Set WindUI Theme
WindUI:SetTheme("Dark")

-- =============== EXECUTOR DETECTION SYSTEM ===============
local function DetectExecutor()
    local executorName = "Unknown"
    local isSupported = false
    
    -- Supported executors list
    local supportedExecutors = {
        "Zenith", "Wave", "Volcano", "Velocity", "Bunni", "Swift", "Hydrogen", "Solara"
    }
    
    -- Detect common executors
    if identifyexecutor then
        executorName = identifyexecutor()
    elseif getexecutorname then
        executorName = getexecutorname()
    elseif syn and syn.get_thread_identity then
        executorName = "Synapse X"
    elseif KRNL_LOADED then
        executorName = "KRNL"
    elseif getgenv().WRD_LOADED then
        executorName = "WeAreDevs"
    elseif getgenv().EVON_LOADED then
        executorName = "Evon"
    elseif getgenv().FLUXUS_LOADED then
        executorName = "Fluxus"
    elseif getgenv().SCRIPTWARE then
        executorName = "Script-Ware"
    elseif PROTOSMASHER_LOADED then
        executorName = "ProtoSmasher"
    elseif pebc_execute then
        executorName = "Panda"
    elseif getgenv().IS_VEGA_LOADED then
        executorName = "Vega X"
    elseif getgenv().JJSploit then
        executorName = "JJSploit"
    elseif getgenv().OXYGEN_LOADED then
        executorName = "Oxygen U"
    elseif Delta and Delta.Request then
        executorName = "Delta"
    elseif getgenv().COMET_LOADED then
        executorName = "Comet"
    elseif getgenv().COCO_LOADED then
        executorName = "Coco Z"
    elseif getgenv().Kitten then
        executorName = "Kitten"
    elseif arceus then
        executorName = "Arceus X"
    end
    
    -- Check if executor is supported
    for _, supportedName in ipairs(supportedExecutors) do
        if string.find(string.lower(executorName), string.lower(supportedName)) then
            isSupported = true
            break
        end
    end
    
    return executorName, isSupported
end

local function ShowExecutorDetectionUI()
    local executorName, isSupported = DetectExecutor()
    
    -- Create detection UI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ExecutorDetectionUI"
    screenGui.Parent = CoreGui
    screenGui.DisplayOrder = 999999
    
    local frame = Instance.new("Frame")
    frame.Name = "DetectionFrame"
    frame.Size = UDim2.new(0, 600, 0, 200)
    frame.Position = UDim2.new(0.5, -300, 0.5, -100)
    frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    -- Add border
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = isSupported and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.6, 0.2)
    stroke.Parent = frame
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0, 30, 0.5, -25)
    icon.BackgroundTransparency = 1
    icon.Text = isSupported and "✅" or "⚠️"
    icon.TextColor3 = Color3.new(1, 1, 1)
    icon.TextScaled = true
    icon.Font = Enum.Font.SourceSansBold
    icon.Parent = frame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 500, 0, 40)
    title.Position = UDim2.new(0, 90, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = isSupported and "SUPPORTED EXECUTOR DETECTED" or "UNSUPPORTED EXECUTOR"
    title.TextColor3 = isSupported and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.8, 0.6, 0.2)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    
    -- Executor name
    local executorLabel = Instance.new("TextLabel")
    executorLabel.Name = "ExecutorLabel"
    executorLabel.Size = UDim2.new(0, 500, 0, 30)
    executorLabel.Position = UDim2.new(0, 90, 0, 80)
    executorLabel.BackgroundTransparency = 1
    executorLabel.Text = executorName
    executorLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    executorLabel.TextScaled = true
    executorLabel.Font = Enum.Font.SourceSans
    executorLabel.TextXAlignment = Enum.TextXAlignment.Left
    executorLabel.Parent = frame
    
    -- Status message
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(0, 500, 0, 25)
    statusLabel.Position = UDim2.new(0, 90, 0, 120)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = isSupported and "FEATURES ARE COMPATIBLE" or "FEATURES MAY BE MORE BUGGY"
    statusLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = frame
    
    -- Fade in animation
    frame.BackgroundTransparency = 1
    stroke.Transparency = 1
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("TextLabel") then
            child.TextTransparency = 1
        end
    end
    
    local fadeInTween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.1})
    local strokeTween = TweenService:Create(stroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Transparency = 0})
    
    fadeInTween:Play()
    strokeTween:Play()
    
    for _, child in ipairs(frame:GetChildren()) do
        if child:IsA("TextLabel") then
            local textTween = TweenService:Create(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 0})
            textTween:Play()
        end
    end
    
    -- Auto-remove after 8 seconds with fade out
    task.spawn(function()
        task.wait(7.5)
        
        -- Fade out animation
        local fadeOutTween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
        local strokeOutTween = TweenService:Create(stroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Transparency = 1})
        
        fadeOutTween:Play()
        strokeOutTween:Play()
        
        for _, child in ipairs(frame:GetChildren()) do
            if child:IsA("TextLabel") then
                local textTween = TweenService:Create(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 1})
                textTween:Play()
            end
        end
        
        task.wait(0.5)
        screenGui:Destroy()
    end)
    
    return executorName, isSupported
end

-- Show executor detection immediately
local DETECTED_EXECUTOR, IS_EXECUTOR_SUPPORTED = ShowExecutorDetectionUI()
local DETECTION_TIMESTAMP = os.date("%Y-%m-%d %H:%M:%S")

-- =============== DIAGNOSTICS AND LOGGING SYSTEM ===============
local DiagnosticsSystem = {
    sessionLog = {},
    showDebugOverlay = false,
    logToConsole = false,
    saveSessionLog = false,
    debugVerbosity = "Medium", -- Low, Medium, High
    maxLogEntries = 1000,
    overlay = nil,
    telemetryData = {},
    lastFPSUpdate = 0,
    currentFPS = 0,
    frameTime = 0,
    cpuLoad = 0,
    samplingRate = 0.2, -- 200ms default
}

function DiagnosticsSystem:Log(level, message, category)
    local timestamp = os.date("%H:%M:%S")
    local logEntry = {
        timestamp = timestamp,
        level = level,
        message = message,
        category = category or "General",
        tick = tick()
    }
    
    table.insert(self.sessionLog, logEntry)
    
    -- Rotate logs to prevent memory overflow
    if #self.sessionLog > self.maxLogEntries then
        table.remove(self.sessionLog, 1)
    end
    
    -- Console logging
    if self.logToConsole then
        print(string.format("[%s] [%s] %s: %s", timestamp, level, category, message))
    end
    
    -- Update overlay if needed
    if self.showDebugOverlay then
        self:UpdateOverlay()
    end
end

function DiagnosticsSystem:UpdatePerformanceMetrics(deltaTime)
    local currentTime = tick()
    if currentTime - self.lastFPSUpdate >= self.samplingRate then
        -- Calculate FPS using deltaTime from heartbeat
        if deltaTime > 0 then
            self.currentFPS = math.floor(1 / deltaTime)
            self.frameTime = math.floor(deltaTime * 1000 * 100) / 100 -- Convert to ms and round to 2 decimal places
        else
            self.currentFPS = 60 -- Fallback
            self.frameTime = 16.67
        end
        
        -- Approximate CPU load using frame time
        -- Higher frame times indicate more CPU usage
        local normalizedFrameTime = deltaTime / (1/60) -- Normalize against 60 FPS
        self.cpuLoad = math.min(100, math.floor(normalizedFrameTime * 50))
        
        -- Alternative CPU load method using work simulation
        local workStartTime = tick()
        for i = 1, 100 do -- Reduced iterations to avoid lag
            math.sin(math.random() * math.pi)
        end
        local workEndTime = tick()
        local workTime = (workEndTime - workStartTime) * 1000 -- Convert to ms
        local alternativeCPULoad = math.min(100, math.floor(workTime * 200))
        
        -- Use the higher of the two methods
        self.cpuLoad = math.max(self.cpuLoad, alternativeCPULoad)
        
        self.lastFPSUpdate = currentTime
    end
end

function DiagnosticsSystem:CreateDebugOverlay()
    if self.overlay then
        self.overlay:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DiagnosticsOverlay"
    screenGui.Parent = CoreGui
    screenGui.DisplayOrder = 999998
    
    local frame = Instance.new("Frame")
    frame.Name = "OverlayFrame"
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0, 12, 0, 12)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = frame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        self.showDebugOverlay = false
        self:DestroyOverlay()
    end)
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "ContentLabel"
    contentLabel.Size = UDim2.new(1, -12, 1, -30)
    contentLabel.Position = UDim2.new(0, 6, 0, 6)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = ""
    contentLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    contentLabel.TextSize = 12
    contentLabel.Font = Enum.Font.RobotoMono
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.Parent = frame
    
    local hotKeyLabel = Instance.new("TextLabel")
    hotKeyLabel.Name = "HotkeyLabel"
    hotKeyLabel.Size = UDim2.new(1, -12, 0, 15)
    hotKeyLabel.Position = UDim2.new(0, 6, 1, -20)
    hotKeyLabel.BackgroundTransparency = 1
    hotKeyLabel.Text = "Press F9 to toggle overlay"
    hotKeyLabel.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    hotKeyLabel.TextSize = 10
    hotKeyLabel.Font = Enum.Font.SourceSans
    hotKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
    hotKeyLabel.Parent = frame
    
    self.overlay = screenGui
end

function DiagnosticsSystem:UpdateOverlay()
    if not self.overlay then return end
    
    local contentLabel = self.overlay.OverlayFrame.ContentLabel
    
    local content = {}
    table.insert(content, string.format("Executor: %s (%s)", DETECTED_EXECUTOR, IS_EXECUTOR_SUPPORTED and "Supported" or "Unsupported"))
    table.insert(content, string.format("Detected at: %s", DETECTION_TIMESTAMP))
    table.insert(content, string.format("FPS: %d", self.currentFPS))
    table.insert(content, string.format("Frame Time: %.2f ms", self.frameTime))
    table.insert(content, string.format("CPU Load: %d%%", self.cpuLoad))
    table.insert(content, "")
    table.insert(content, "=== LIVE TELEMETRY ===")
    
    -- Show recent telemetry data
    local maxEntries = self.debugVerbosity == "High" and 10 or (self.debugVerbosity == "Medium" and 6 or 3)
    local recentEntries = {}
    
    for i = math.max(1, #self.sessionLog - maxEntries + 1), #self.sessionLog do
        if self.sessionLog[i] then
            table.insert(recentEntries, self.sessionLog[i])
        end
    end
    
    for _, entry in ipairs(recentEntries) do
        table.insert(content, string.format("[%s] %s", entry.timestamp, entry.message))
    end
    
    contentLabel.Text = table.concat(content, "\n")
end

function DiagnosticsSystem:DestroyOverlay()
    if self.overlay then
        self.overlay:Destroy()
        self.overlay = nil
    end
end

function DiagnosticsSystem:ClearSessionLog()
    self.sessionLog = {}
    self:Log("INFO", "Session log cleared", "System")
end

function DiagnosticsSystem:ExportSessionLog()
    if #self.sessionLog == 0 then
        WindUI:Notify({
            Title = "Export Failed",
            Content = "No log entries to export",
            Icon = "alert-triangle",
            Duration = 3,
        })
        return
    end
    
    local logContent = {}
    table.insert(logContent, "=== EZ-WIN V3 SESSION LOG ===")
    table.insert(logContent, string.format("Generated: %s", os.date("%Y-%m-%d %H:%M:%S")))
    table.insert(logContent, string.format("Executor: %s", DETECTED_EXECUTOR))
    table.insert(logContent, "")
    
    for _, entry in ipairs(self.sessionLog) do
        table.insert(logContent, string.format("[%s] [%s] %s: %s", entry.timestamp, entry.level, entry.category, entry.message))
    end
    
    local finalLog = table.concat(logContent, "\n")
    
    -- Try to save to file if writefile exists
    if writefile then
        local filename = string.format("ezwin_log_%s.txt", os.date("%Y%m%d_%H%M%S"))
        pcall(function()
            writefile(filename, finalLog)
            WindUI:Notify({
                Title = "Log Exported",
                Content = "Saved as " .. filename,
                Icon = "check",
                Duration = 3,
            })
        end)
    else
        -- Copy to clipboard if setclipboard exists
        if setclipboard then
            pcall(function()
                setclipboard(finalLog)
                WindUI:Notify({
                    Title = "Log Copied",
                    Content = "Session log copied to clipboard",
                    Icon = "copy",
                    Duration = 3,
                })
            end)
        else
            WindUI:Notify({
                Title = "Export Unavailable",
                Content = "Executor doesn't support file operations",
                Icon = "x",
                Duration = 3,
            })
        end
    end
end

-- Initialize diagnostics
DiagnosticsSystem:Log("INFO", "Diagnostics system initialized", "System")
DiagnosticsSystem:Log("INFO", string.format("Executor detected: %s", DETECTED_EXECUTOR), "Detection")

-- UI
local Window = WindUI:CreateWindow({
    Title = "Ez-Win V3",
    Icon = "crosshair",
    Author = "Author: s0ulz",
    Folder = "ExoMVSD",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("User clicked")
        end,
    },
})

-- =============== PERFORMANCE OPTIMIZATION VARIABLES ===============
local MAIN_TICK_RATE = 60 -- Main update loop runs at 60 FPS
local ESP_TICK_RATE = 30 -- ESP updates at 30 FPS for better performance
local VISIBILITY_TICK_RATE = 10 -- Wall check raycasts at 10 FPS
local MAX_ESP_DISTANCE = 500 -- Don't render ESP beyond this distance
local LOD_DISTANCE = 150 -- Use lower detail beyond this distance

-- Performance counters
local mainTickCount = 0
local espTickCount = 0
local visibilityTickCount = 0
local playerRotationIndex = 1 -- For rotating through players in visibility checks

-- Object pools for reusing drawing objects
local LinePool = {}
local CirclePool = {}
local QuadPool = {}

-- Cached references for performance
local cachedPlayers = {}
local cachedPlayerDistances = {}
local cachedVisibilityResults = {}
local lastPlayerCacheUpdate = 0

-- =============== ENHANCED SETTINGS ===============
local HeadSize = 20
local Transparency = 70 -- Changed to percentage
local HitboxColor = Color3.fromRGB(0, 255, 0)
local IsEnabled = false
local HitboxTeamCheck = false  -- Separate team check for hitbox
local HitboxWallCheck = false  -- NEW: Wall check for hitbox
local FlightEnabled = false
local NoKnifeCooldown = false
local NoGunCooldown = false
local FlightSpeed = 50
local FlightConnections = {}
local FlightBodyVelocity = nil

-- ESP Settings with separate team check
local SkeletonESPEnabled = false
local HeadESPEnabled = false
local BoxESPEnabled = false
local CharmsESPEnabled = false  -- NEW: Charms ESP
local ESPColor = Color3.fromRGB(0, 255, 255)
local ESPTeamCheck = false  -- Separate team check for ESP

-- NEW: Tracers Settings
local TracersEnabled = false
local TracersColor = Color3.fromRGB(255, 255, 255)
local TracersThickness = 1
local TracersTeamCheck = false

-- SILENT AIM Settings
local SilentAimEnabled = false
local SilentAimKey = Enum.UserInputType.MouseButton2
local SilentAimSmoothness = 15 -- Changed to percentage
local SilentAimTeamCheck = false  -- Separate team check for aimbot
local SilentAimToggled = false -- NEW: Toggle state for aimbot
local SilentAimTarget = "HumanoidRootPart" -- NEW: Target part selection
local SilentAimRadius = 100
local SilentAimAutoKillDelay = 0.5 -- Delay between auto kills

-- NEW: FOV Circle Settings for Silent Aim
local SilentAimFOVEnabled = false
local SilentAimFOVRadius = 100
local SilentAimFOVColor = Color3.fromRGB(255, 255, 255)
local SilentAimFOVThickness = 1
local SilentAimFOVCircle = nil

-- PREDICTION AI Settings
local PredictionAIEnabled = false
local PredictionTimeAhead = 0.3 -- seconds
local PredictionProbability = 85 -- percentage
local PredictionModel = "Linear" -- Linear, Acceleration, Pattern-Learning
local PredictionDebugOverlay = false

-- Player tracking for prediction
local PlayerTrackingData = {} -- Stores position history for each player

-- NEW: EzWin Settings
local LoopAutoKillEnabled = false
local AutoKillConnection = nil
local AutoKillSpamRate = 0.1 -- NEW: Spam rate limiter in seconds
local AutoShootEnabled = false
local AutoShootConnection = nil
local ShotTargets = {} -- Track recently shot targets

-- NEW: Kill Aura Settings
local KillAuraEnabled = false
local KillAuraRadius = 50
local KillAuraColor = Color3.fromRGB(255, 0, 0)
local KillAuraThickness = 2
local KillAuraCircle = nil
local KillAuraConnection = nil
local KillAuraTargets = {} -- Track recently targeted players to prevent spam
local KillAuraRateLimit = 1.0 -- Rate limit in seconds
local LastKillAuraTime = 0

-- =============== ESP STORAGE ===============
local SkeletonESP = {}
local HeadESP = {}
local BoxESP = {}
local CharmsESP = {}
local TracersESP = {} -- NEW: Tracers storage

-- ESP Update Connection
local MainUpdateConnection = nil

-- =============== PREDICTION AI SYSTEM ===============
local PredictionAI = {
    playerData = {},
    maxHistorySize = 30, -- Store last 30 position samples
    minHistorySize = 3, -- Need at least 3 samples for prediction
}

function PredictionAI:UpdatePlayerData(player)
    if not player or not player.Character then return end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local currentTime = tick()
    local currentPosition = humanoidRootPart.Position
    
    if not self.playerData[player] then
        self.playerData[player] = {
            positionHistory = {},
            lastUpdate = currentTime,
            velocity = Vector3.new(0, 0, 0),
            acceleration = Vector3.new(0, 0, 0),
            confidence = 0
        }
    end
    
    local data = self.playerData[player]
    
    -- Add new position to history
    table.insert(data.positionHistory, {
        position = currentPosition,
        timestamp = currentTime
    })
    
    -- Keep smaller history for faster reaction
    if #data.positionHistory > 15 then
        table.remove(data.positionHistory, 1)
    end
    
    -- Calculate velocity + acceleration
    if #data.positionHistory >= 2 then
        local prev = data.positionHistory[#data.positionHistory - 1]
        local curr = data.positionHistory[#data.positionHistory]
        local deltaTime = curr.timestamp - prev.timestamp
        
        if deltaTime > 0 then
            local newVelocity = (curr.position - prev.position) / deltaTime
            
            -- Ignore crazy jump Y
            if math.abs(newVelocity.Y) > 40 then
                newVelocity = Vector3.new(newVelocity.X, 0, newVelocity.Z)
            end
            
            -- Faster smoothing (react quicker)
            data.velocity = data.velocity:Lerp(newVelocity, 0.8)
            
            if #data.positionHistory >= 3 then
                local prevVelocity = data.velocity
                data.acceleration = (newVelocity - prevVelocity) / deltaTime
            end
            
            -- Confidence scaling
            local velocityMagnitude = newVelocity.Magnitude
            if velocityMagnitude > 0.1 then
                data.confidence = math.min(100, data.confidence + 8) -- quicker ramp up
            else
                data.confidence = math.max(0, data.confidence - 4)
            end
        end
    end
    
    data.lastUpdate = currentTime
end


function PredictionAI:PredictPlayerPosition(player, timeAhead)
    if not self.playerData[player] or #self.playerData[player].positionHistory < self.minHistorySize then
        return nil, 0
    end
    
    local data = self.playerData[player]
    local latestEntry = data.positionHistory[#data.positionHistory]
    local currentPosition = latestEntry.position
    local velocity = data.velocity
    local acceleration = data.acceleration
    
    -- ✨ Fix jump spazzing: ignore huge vertical spikes
    if math.abs(velocity.Y) > 40 then
        velocity = Vector3.new(velocity.X, 0, velocity.Z)
    end
    
    local predictedPosition
    
    if PredictionModel == "Linear" then
        predictedPosition = currentPosition + velocity * timeAhead
    elseif PredictionModel == "Acceleration" then
        predictedPosition = currentPosition + velocity * timeAhead + 0.5 * acceleration * (timeAhead * timeAhead)
    elseif PredictionModel == "Pattern-Learning" then
        -- Weighted average of recent velocities
        local weightedVelocity = Vector3.new(0, 0, 0)
        local totalWeight = 0
        
        for i = math.max(1, #data.positionHistory - 5), #data.positionHistory - 1 do
            local weight = i / #data.positionHistory -- More recent = more weight
            if i < #data.positionHistory then
                local deltaPos = data.positionHistory[i + 1].position - data.positionHistory[i].position
                local deltaTime = data.positionHistory[i + 1].timestamp - data.positionHistory[i].timestamp
                if deltaTime > 0 then
                    weightedVelocity = weightedVelocity + (deltaPos / deltaTime) * weight
                    totalWeight = totalWeight + weight
                end
            end
        end
        
        if totalWeight > 0 then
            weightedVelocity = weightedVelocity / totalWeight
        end
        
        predictedPosition = currentPosition + weightedVelocity * timeAhead
    else
        predictedPosition = currentPosition
    end
    
    -- ✨ Adaptive smoothing: more confidence = snappier aim
    local blendFactor = math.clamp(data.confidence / 100, 0.5, 0.9)
    predictedPosition = currentPosition:Lerp(predictedPosition, blendFactor)
    
    return predictedPosition, data.confidence
end


function PredictionAI:GetPredictedAimPosition(player)
    if not PredictionAIEnabled then return nil end
    
    local predictedPos, confidence = self:PredictPlayerPosition(player, PredictionTimeAhead)
    if not predictedPos then return nil end
    
    -- Get current target position
    local targetPart = player.Character:FindFirstChild(SilentAimTarget)
    if not targetPart then return nil end
    
    local currentPos = targetPart.Position
    
    -- Blend predicted position with actual position based on probability
    local blendFactor = PredictionProbability / 100
    local finalPosition = predictedPos * blendFactor + currentPos * (1 - blendFactor)
    
    -- Log prediction data for diagnostics
    if confidence > 50 then
        DiagnosticsSystem:Log("DEBUG", 
            string.format("Player: %s | Pos: (%.1f,%.1f,%.1f) | Pred: (%.1f,%.1f,%.1f) | Vel: (%.1f,%.1f,%.1f) | Conf: %.0f%%", 
                player.Name, 
                currentPos.X, currentPos.Y, currentPos.Z,
                predictedPos.X, predictedPos.Y, predictedPos.Z,
                self.playerData[player].velocity.X, self.playerData[player].velocity.Y, self.playerData[player].velocity.Z,
                confidence
            ), 
            "Prediction"
        )
    end
    
    return finalPosition
end

function PredictionAI:CleanupDisconnectedPlayers()
    for player, _ in pairs(self.playerData) do
        if not player or not player.Parent or not Players:FindFirstChild(player.Name) then
            self.playerData[player] = nil
        end
    end
end

-- =============== OBJECT POOL MANAGEMENT (PERFORMANCE) ===============
local function GetLineFromPool()
    if #LinePool > 0 then
        return table.remove(LinePool)
    else
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Transparency = 0.5
        line.Visible = false
        return line
    end
end

local function ReturnLineToPool(line)
    if line then
        line.Visible = false
        table.insert(LinePool, line)
    end
end

local function GetCircleFromPool()
    if #CirclePool > 0 then
        return table.remove(CirclePool)
    else
        local circle = Drawing.new("Circle")
        circle.Thickness = 1
        circle.Filled = true
        circle.Transparency = 0.5
        circle.Visible = false
        circle.Radius = 4
        return circle
    end
end

local function ReturnCircleToPool(circle)
    if circle then
        circle.Visible = false
        table.insert(CirclePool, circle)
    end
end

local function GetQuadFromPool()
    if #QuadPool > 0 then
        return table.remove(QuadPool)
    else
        local quad = Drawing.new("Quad")
        quad.Thickness = 1
        quad.Filled = false
        quad.Transparency = 0.5
        quad.Visible = false
        return quad
    end
end

local function ReturnQuadToPool(quad)
    if quad then
        quad.Visible = false
        table.insert(QuadPool, quad)
    end
end

-- =============== CACHED PLAYER MANAGEMENT (PERFORMANCE) ===============
local function UpdatePlayerCache()
    local currentTime = tick()
    if currentTime - lastPlayerCacheUpdate < 0.5 then return end -- Update cache every 0.5 seconds
    
    lastPlayerCacheUpdate = currentTime
    cachedPlayers = {}
    cachedPlayerDistances = {}
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local localPos = LocalPlayer.Character.HumanoidRootPart.Position
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - localPos).Magnitude
            if distance <= MAX_ESP_DISTANCE then
                table.insert(cachedPlayers, player)
                cachedPlayerDistances[player] = distance
                
                -- Update prediction data
                if PredictionAIEnabled then
                    PredictionAI:UpdatePlayerData(player)
                end
            end
        end
    end
    
    -- Cleanup disconnected players from prediction system
    if PredictionAIEnabled then
        PredictionAI:CleanupDisconnectedPlayers()
    end
end

-- =============== ROTATION-BASED VISIBILITY CHECKING (PERFORMANCE) ===============
local function UpdateVisibilityForPlayer(player)
    if not player or not player.Character then
        cachedVisibilityResults[player] = false
        return
    end
    
    local isVisible = false
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        cachedVisibilityResults[player] = false
        return
    end
    
    local localRoot = LocalPlayer.Character.HumanoidRootPart
    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
    
    if not targetRoot then
        cachedVisibilityResults[player] = false
        return
    end
    
    -- First check if target is on screen
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetRoot.Position)
    if not onScreen or screenPos.Z <= 0 then
        cachedVisibilityResults[player] = false
        return
    end
    
    -- Raycast to check for walls/obstacles
    local origin = localRoot.Position
    local direction = (targetRoot.Position - origin)
    local distance = direction.Magnitude
    direction = direction.Unit
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
    
    local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)
    
    -- If no obstacle hit, target is visible
    isVisible = raycastResult == nil
    
    cachedVisibilityResults[player] = isVisible
end

local function UpdateRotationalVisibility()
    UpdatePlayerCache()
    
    if #cachedPlayers == 0 then return end
    
    -- Rotate through players to spread visibility checks across frames
    local playersToCheck = math.min(2, #cachedPlayers) -- Check max 2 players per frame
    
    for i = 1, playersToCheck do
        local playerIndex = ((playerRotationIndex - 1 + i - 1) % #cachedPlayers) + 1
        local player = cachedPlayers[playerIndex]
        if player then
            UpdateVisibilityForPlayer(player)
        end
    end
    
    playerRotationIndex = (playerRotationIndex + playersToCheck - 1) % #cachedPlayers + 1
end

-- =============== OPTIMIZED VISIBILITY CHECK ===============
local function IsPlayerVisible(targetPlayer)
    -- Use cached result if available
    if cachedVisibilityResults[targetPlayer] ~= nil then
        return cachedVisibilityResults[targetPlayer]
    end
    
    -- Fallback to immediate check
    UpdateVisibilityForPlayer(targetPlayer)
    return cachedVisibilityResults[targetPlayer] or false
end

-- =============== ANIMATION SYSTEM (NEW) ===============
-- Play animation until the player moves function
local function playAnimationUntilMove(animId)
    pcall(function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        local anim = Instance.new("Animation")
        anim.AnimationId = animId
        local track = humanoid:LoadAnimation(anim)
        track:Play()
        print("Playing animation:", animId)

        -- Stop when the player starts moving
        local connection
        connection = humanoid.Running:Connect(function(speed)
            if speed > 0 then
                track:Stop()
                connection:Disconnect()
            end
        end)
    end)
end

-- =============== DECLARE FUNCTIONS FIRST (FIX FOR NIL ERRORS) ===============
local UpdateHitboxes
local ResetHitboxes
local GetClosestTarget
local GetTargetsInFOV
local CreateSkeletonESP
local CreateCharmsESP
local CreateHeadESP
local CreateBoxESP
local CreateTracersESP
local UpdateSkeletonESP
local UpdateHeadESP
local UpdateBoxESP
local UpdateTracersESP
local ClearSkeletonESP
local ClearCharmsESP
local ClearHeadESP
local ClearBoxESP
local ClearTracersESP
local UpdateAllESP
local UpdateAllESPColors
local EnableFlight
local DisableFlight
local PerformKillOnPlayer
local GetEnemyPlayers
local LoopAutoKill
local StopAutoKill
local KillAllEnemies
local AutoShootLoop
local CreateSilentAimFOVCircle
local UpdateSilentAimFOVCircle
local RemoveSilentAimFOVCircle
local CreateKillAuraCircle
local UpdateKillAuraCircle
local RemoveKillAuraCircle
local StartKillAura
local StopKillAura

-- =============== CREATE TABS ===============
local Tabs = {}

-- Create Sections
Tabs.CombatSection = Window:Section({
    Title = "Combat Features",
    Icon = "sword",
    Opened = true,
})

Tabs.VisualSection = Window:Section({
    Title = "Visual Features", 
    Icon = "eye",
    Opened = true,
})

Tabs.ExtraSection = Window:Section({
    Title = "Extra Features",
    Icon = "plus",
    Opened = true,
})

-- NEW: EzWin Section
Tabs.EzWinSection = Window:Section({
    Title = "EzWin",
    Icon = "zap",
    Opened = true,
})

-- Create Tabs
Tabs.HitboxTab = Tabs.CombatSection:Tab({ 
    Title = "Hitbox", 
    Icon = "target",
    Desc = "Modify player hitboxes for easier targeting"
})

Tabs.AimTab = Tabs.CombatSection:Tab({ 
    Title = "Aim", 
    Icon = "crosshair",
    Desc = "Silent Aim and Prediction AI systems"
})

Tabs.CooldownTab = Tabs.CombatSection:Tab({ 
    Title = "Cooldown", 
    Icon = "clock",
    Desc = "Weapon cooldown features (Coming Soon)"
})

Tabs.ESPTab = Tabs.VisualSection:Tab({ 
    Title = "ESP", 
    Icon = "eye-off",
    Desc = "Extra sensory perception features"
})

-- NEW: Tracers Tab
Tabs.TracersTab = Tabs.VisualSection:Tab({
    Title = "Tracers",
    Icon = "git-branch",
    Desc = "Line tracers from player to enemies"
})

-- NEW: EzWin Tab (MOVED ABOVE EXTRA)
Tabs.EzWinTab = Tabs.EzWinSection:Tab({
    Title = "Autokill",
    Icon = "zap",
    Desc = "Advanced kill features"
})

-- NEW: Kill Aura Tab
Tabs.KillAuraTab = Tabs.EzWinSection:Tab({
    Title = "Kill Aura",
    Icon = "crosshair",
    Desc = "Automatic area-of-effect killing"
})

-- NEW: Emotes Tab (Added)
Tabs.EmotesTab = Tabs.ExtraSection:Tab({ 
    Title = "Emotes", 
    Icon = "music",
    Desc = "Play various character animations and emotes"
})

Tabs.ExtraTab = Tabs.ExtraSection:Tab({ 
    Title = "Extra", 
    Icon = "settings",
    Desc = "Additional utility features"
})

-- NEW: Performance Tab
Tabs.PerformanceTab = Tabs.ExtraSection:Tab({
    Title = "Performance",
    Icon = "activity",
    Desc = "Performance monitoring and optimization settings"
})

-- =============== SILENT AIM FOV CIRCLE FUNCTIONS ===============
function CreateSilentAimFOVCircle()
    pcall(function()
        if SilentAimFOVCircle then
            SilentAimFOVCircle:Remove()
        end
        
        SilentAimFOVCircle = GetCircleFromPool()
        SilentAimFOVCircle.Thickness = SilentAimFOVThickness
        SilentAimFOVCircle.NumSides = 100
        SilentAimFOVCircle.Filled = false
        SilentAimFOVCircle.Transparency = 0.7
        SilentAimFOVCircle.Color = SilentAimFOVColor
        SilentAimFOVCircle.Radius = SilentAimFOVRadius
        SilentAimFOVCircle.Visible = SilentAimFOVEnabled
    end)
end

function UpdateSilentAimFOVCircle()
    if not SilentAimFOVCircle or not SilentAimFOVEnabled then return end
    
    local mousePos = UserInputService:GetMouseLocation()
    SilentAimFOVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
    SilentAimFOVCircle.Color = SilentAimFOVColor
    SilentAimFOVCircle.Thickness = SilentAimFOVThickness
    SilentAimFOVCircle.Radius = SilentAimFOVRadius
    SilentAimFOVCircle.Visible = true
end

function RemoveSilentAimFOVCircle()
    if SilentAimFOVCircle then
        ReturnCircleToPool(SilentAimFOVCircle)
        SilentAimFOVCircle = nil
    end
end

-- =============== KILL AURA CIRCLE FUNCTIONS (FLAT GROUND DISC) ===============
function CreateKillAuraCircle()
    pcall(function()
        -- Remove old circle if it exists
        if KillAuraCircle then
            KillAuraCircle:Destroy()
        end
        
        -- Create a flat disc that will lay on the ground
        KillAuraCircle = Instance.new("Part")
        KillAuraCircle.Name = "KillAuraCircle"
        KillAuraCircle.Anchored = true
        KillAuraCircle.CanCollide = false
        KillAuraCircle.Material = Enum.Material.Neon
        KillAuraCircle.Shape = Enum.PartType.Cylinder
        KillAuraCircle.TopSurface = Enum.SurfaceType.Smooth
        KillAuraCircle.BottomSurface = Enum.SurfaceType.Smooth
        KillAuraCircle.Color = KillAuraColor
        KillAuraCircle.Transparency = 0.7
        -- Make it a very thin, flat disc (height is very small)
        KillAuraCircle.Size = Vector3.new(0.1, KillAuraRadius * 2, KillAuraRadius * 2)
        KillAuraCircle.Parent = workspace
    end)
end

-- Table to track last kill times per player
LastKillAuraTime = {}

function UpdateKillAuraCircle()
    if not KillAuraCircle or not KillAuraEnabled or not LocalPlayer.Character then return end
    
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Get the character's ground position by raycasting downward
    local characterPosition = humanoidRootPart.Position
    local rayOrigin = characterPosition
    local rayDirection = Vector3.new(0, -1000, 0) -- Cast downward
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, KillAuraCircle}
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    local groundPosition
    if raycastResult then
        -- Place disc directly on the ground surface
        groundPosition = Vector3.new(characterPosition.X, raycastResult.Position.Y + 0.05, characterPosition.Z)
    else
        -- Fallback to character position minus some height
        groundPosition = Vector3.new(characterPosition.X, characterPosition.Y - 5, characterPosition.Z)
    end
    
    -- Update circle properties (for Part type object)
    KillAuraCircle.Size = Vector3.new(0.1, KillAuraRadius * 2, KillAuraRadius * 2)
    KillAuraCircle.Color = KillAuraColor -- if KillAuraColor is Color3
    KillAuraCircle.Transparency = 0.7
    KillAuraCircle.CanCollide = false
    KillAuraCircle.Anchored = true
    
    -- Position the disc flat on the ground
    KillAuraCircle.CFrame = CFrame.new(groundPosition) * CFrame.Angles(0, 0, math.rad(90))
    
    -- Ensure the circle is in workspace
    if not KillAuraCircle.Parent then
        KillAuraCircle.Parent = workspace
    end
end

function RemoveKillAuraCircle()
    if KillAuraCircle then
        KillAuraCircle:Destroy()
        KillAuraCircle = nil
    end
end

function StartKillAura()
    if KillAuraConnection then
        KillAuraConnection:Disconnect()
        KillAuraConnection = nil
    end

    KillAuraConnection = RunService.Heartbeat:Connect(function()
        if not KillAuraEnabled or not LocalPlayer.Character then return end

        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        local myPosition = humanoidRootPart.Position
        local currentTime = tick()

        -- Update the aura circle position
        UpdateKillAuraCircle()

        for _, player in ipairs(cachedPlayers) do
            if player ~= LocalPlayer and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")

                if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                    -- Team check
                    if not LocalPlayer.Team or not player.Team or player.Team ~= LocalPlayer.Team then
                        local horizontalDistance = (Vector2.new(myPosition.X, myPosition.Z) - Vector2.new(targetRoot.Position.X, targetRoot.Position.Z)).Magnitude
                        
                        local radius = tonumber(KillAuraRadius) or 0
                        if horizontalDistance <= radius then
                            -- Only attack this player if cooldown expired
                            local rateLimit = tonumber(KillAuraRateLimit) or 0.5
                            if currentTime - (LastKillAuraTime[player] or 0) >= rateLimit then
                                PerformKillOnPlayer(player)
                                LastKillAuraTime[player] = currentTime

                                WindUI:Notify({
                                    Title = "Kill Aura",
                                    Content = "Attacked " .. player.Name .. " (" .. math.floor(horizontalDistance) .. " studs)",
                                    Icon = "crosshair",
                                    Duration = 1,
                                })

                                DiagnosticsSystem:Log("INFO", string.format("Kill Aura attacked %s", player.Name), "KillAura")
                            end
                        end
                    end
                end
            end
        end
    end)
end

function StopKillAura()
    if KillAuraConnection then
        KillAuraConnection:Disconnect()
        KillAuraConnection = nil
    end
    KillAuraTargets = {}
    LastKillAuraTime = {} -- Reset cooldowns
    RemoveKillAuraCircle()
end





-- =============== NEW: EZWIN FUNCTIONS ===============
function GetEnemyPlayers()
    local enemies = {}
    
    for _, player in ipairs(cachedPlayers) do
        if player.Character then
            -- Team check - only target enemies
            if not LocalPlayer.Team or not player.Team or player.Team ~= LocalPlayer.Team then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local leftUpperArm = player.Character:FindFirstChild("LeftUpperArm")
                    if leftUpperArm and leftUpperArm:FindFirstChild("Part") then
                        table.insert(enemies, player)
                    end
                end
            end
        end
    end
    
    return enemies
end

-- MODIFIED: Auto-equip weapon before performing kill
function PerformKillOnPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    -- AUTO-EQUIP WEAPON BEFORE KILL
    if LocalPlayer:WaitForChild("Backpack", 1) and LocalPlayer.Character then
        local backpack = LocalPlayer.Backpack
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        if humanoid then
            -- Grab the 2nd item in the Backpack
            local items = backpack:GetChildren()
            local secondItem = items[2]
            
            if secondItem then
                humanoid:EquipTool(secondItem)
            end
        end
    end
    
    local leftUpperArm = targetPlayer.Character:FindFirstChild("LeftUpperArm")
    if not leftUpperArm or not leftUpperArm:FindFirstChild("Part") then return end
    
    local shootGunRemote = ReplicatedStorage:FindFirstChild("Remotes")
    if shootGunRemote then
        shootGunRemote = shootGunRemote:FindFirstChild("ShootGun")
        if shootGunRemote then
            local args = {
                Vector3.new(-174.95948791503906, 165.3748779296875, -1.7110586166381836),
                Vector3.new(-176.19561767578125, 144.7963409423828, 51.71797180175781),
                leftUpperArm:FindFirstChild("Part"),
                Vector3.new(-175.43002319335938, 166.70974731445312, 6.782278537750244)
            }
            
            shootGunRemote:FireServer(unpack(args))
        end
    end
end

-- FIXED: Loop Auto Kill - Now with adjustable spam rate limiter
function LoopAutoKill()
    if AutoKillConnection then
        AutoKillConnection:Disconnect()
        AutoKillConnection = nil
    end
    
    AutoKillConnection = RunService.Heartbeat:Connect(function()
        if not LoopAutoKillEnabled then
            return
        end
        
        -- AUTO-EQUIP WEAPON BEFORE LOOP KILL
        if LocalPlayer:WaitForChild("Backpack", 1) and LocalPlayer.Character then
            local backpack = LocalPlayer.Backpack
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            
            if humanoid then
                -- Grab the 2nd item in the Backpack
                local items = backpack:GetChildren()
                local secondItem = items[2]
                
                if secondItem then
                    humanoid:EquipTool(secondItem)
                end
            end
        end
        
        local enemies = GetEnemyPlayers()
        
        -- Execute kill with spam rate limiter
        for _, enemy in ipairs(enemies) do
            PerformKillOnPlayer(enemy)
        end
        
        -- Wait for the specified spam rate before next execution
        task.wait(AutoKillSpamRate)
    end)
end

function StopAutoKill()
    if AutoKillConnection then
        AutoKillConnection:Disconnect()
        AutoKillConnection = nil
    end
end

-- MODIFIED: Auto-equip weapon before kill all
function KillAllEnemies()
    -- AUTO-EQUIP WEAPON BEFORE KILL ALL
    if LocalPlayer:WaitForChild("Backpack", 1) and LocalPlayer.Character then
        local backpack = LocalPlayer.Backpack
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        if humanoid then
            -- Grab the 2nd item in the Backpack
            local items = backpack:GetChildren()
            local secondItem = items[2]
            
            if secondItem then
                humanoid:EquipTool(secondItem)
            else
                warn("No second item found in inventory!")
                WindUI:Notify({
                    Title = "No Weapon Found",
                    Content = "No second item found in inventory! Cannot execute kill all.",
                    Icon = "alert-triangle",
                    Duration = 3,
                })
                return -- Don't proceed if no weapon
            end
        end
    end
    
    local enemies = GetEnemyPlayers()
    
    -- SPAM KILL ALL ENEMIES MULTIPLE TIMES (5x)
    for i = 1, 5 do
        for _, enemy in ipairs(enemies) do
            PerformKillOnPlayer(enemy)
        end
        task.wait(0.05) -- Small delay between spam cycles
    end
    
    WindUI:Notify({
        Title = "Kill All Executed",
        Content = "Targeted " .. #enemies .. " enemy players (spammed 5x)",
        Icon = "zap",
        Duration = 3,
    })
end

-- FIXED: Auto Shoot Function with Proper Target Position
function AutoShootAtTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    -- AUTO-EQUIP WEAPON BEFORE SHOOT
    if LocalPlayer:WaitForChild("Backpack", 1) and LocalPlayer.Character then
        local backpack = LocalPlayer.Backpack
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        if humanoid then
            -- Grab the 2nd item in the Backpack
            local items = backpack:GetChildren()
            local secondItem = items[2]
            
            if secondItem then
                humanoid:EquipTool(secondItem)
            else
                warn("No second item found in inventory!")
                return
            end
        end
    end
    
    local leftUpperArm = targetPlayer.Character:FindFirstChild("LeftUpperArm")
    if not leftUpperArm or not leftUpperArm:FindFirstChild("Part") then return end
    
    local shootGunRemote = ReplicatedStorage:FindFirstChild("Remotes")
    if shootGunRemote then
        shootGunRemote = shootGunRemote:FindFirstChild("ShootGun")
        if shootGunRemote then
            -- Use the actual target player's position instead of hardcoded values
            local targetPosition = targetRoot.Position
            local shootDirection = targetPosition + Vector3.new(0, 2, 0) -- Aim slightly higher
            
            local args = {
                LocalPlayer.Character.HumanoidRootPart.Position, -- Shooting from local player
                shootDirection, -- Direction to target
                leftUpperArm:FindFirstChild("Part"), -- Target part
                targetPosition -- Target position
            }
            
            shootGunRemote:FireServer(unpack(args))
            print("Auto Shot: " .. targetPlayer.Name .. " at position " .. tostring(targetPosition))
            
            -- Mark this target as shot to prevent spam
            ShotTargets[targetPlayer] = true
            
            -- Clear the shot marker after 2 seconds
            task.spawn(function()
                task.wait(2)
                ShotTargets[targetPlayer] = nil
            end)
        end
    end
end

function AutoShootLoop()
    if AutoShootConnection then
        AutoShootConnection:Disconnect()
        AutoShootConnection = nil
    end
    
    AutoShootConnection = RunService.Heartbeat:Connect(function()
        if not AutoShootEnabled then return end
        
        local enemies = GetEnemyPlayers()
        for _, enemy in ipairs(enemies) do
            -- Only shoot if we haven't shot this target recently and they are visible
            if not ShotTargets[enemy] and IsPlayerVisible(enemy) then
                AutoShootAtTarget(enemy)
                task.wait(0.1) -- Small delay between shots
                break -- Only shoot one target per frame to prevent lag
            end
        end
    end)
end

function StopAutoShoot()
    if AutoShootConnection then
        AutoShootConnection:Disconnect()
        AutoShootConnection = nil
    end
    -- Clear shot targets when stopping
    ShotTargets = {}
end

-- =============== EZWIN TAB SETUP ===============
Tabs.EzWinTab:Section({ Title = "Auto Kill Features" })

Tabs.EzWinTab:Toggle({
    Title = "Loop Auto Kill",
    Desc = "Continuously kill all enemy players with adjustable spam rate",
    Icon = "repeat",
    Value = false,
    Callback = function(val) 
        LoopAutoKillEnabled = val
        if val then
            LoopAutoKill()
            WindUI:Notify({
                Title = "Loop Auto Kill Enabled",
                Content = "Now killing enemies every " .. AutoKillSpamRate .. " seconds",
                Icon = "repeat",
                Duration = 3,
            })
        else
            StopAutoKill()
            WindUI:Notify({
                Title = "Loop Auto Kill Disabled",
                Content = "Auto kill loop stopped",
                Icon = "square",
                Duration = 3,
            })
        end
    end
})

Tabs.EzWinTab:Slider({
    Title = "Spam Rate Limiter",
    Desc = "How often to execute auto kill (in seconds)",
    Value = {
        Min = 0.1,
        Max = 5.0,
        Default = 0.1,
    },
    Step = 0.1,
    Callback = function(val) 
        AutoKillSpamRate = val
        WindUI:Notify({
            Title = "Spam Rate Updated",
            Content = "Auto kill will now execute every " .. val .. " seconds",
            Icon = "clock",
            Duration = 2,
        })
    end
})

Tabs.EzWinTab:Button({
    Title = "Kill All",
    Desc = "Execute kill on all enemy players once",
    Icon = "zap",
    Callback = function()
        KillAllEnemies()
    end
})

Tabs.EzWinTab:Section({ Title = "Information" })

Tabs.EzWinTab:Paragraph({
    Title = "EzWin Features",
    Desc = "YOU BETTER WIN with these cheats!\nOnly problem is that players might not be able to be shot/killed so be careful as you might lose your streak. These EzWin features are still Beta!",
    Color = "Red",
    Image = "alert-triangle"
})

-- =============== KILL AURA TAB SETUP ===============
Tabs.KillAuraTab:Section({ Title = "Kill Aura System" })

Tabs.KillAuraTab:Toggle({
    Title = "Enable Kill Aura",
    Desc = "Automatically attack enemies that enter your radius",
    Icon = "target",
    Value = false,
    Callback = function(val) 
        KillAuraEnabled = val
        if val then
            CreateKillAuraCircle()
            StartKillAura()
            WindUI:Notify({
                Title = "Kill Aura Enabled",
                Content = "Now attacking enemies within " .. KillAuraRadius .. " studs radius",
                Icon = "target",
                Duration = 3,
            })
        else
            RemoveKillAuraCircle()
            StopKillAura()
            WindUI:Notify({
                Title = "Kill Aura Disabled",
                Content = "Kill aura stopped",
                Icon = "square",
                Duration = 3,
            })
        end
    end
})

Tabs.KillAuraTab:Slider({
    Title = "Aura Radius",
    Desc = "Size of the kill aura area (in studs)",
    Value = {
        Min = 10,
        Max = 200,
        Default = 50,
    },
    Step = 5,
    Callback = function(val) 
        KillAuraRadius = val
        WindUI:Notify({
            Title = "Kill Aura Radius Updated",
            Content = "Radius set to " .. val .. " studs",
            Icon = "circle",
            Duration = 2,
        })
    end
})

Tabs.KillAuraTab:Slider({
    Title = "Attack Rate Limit",
    Desc = "How often to attack players in the circle (in seconds)",
    Value = {
        Min = 0.5,
        Max = 5.0,
        Default = 1.0,
    },
    Step = 0.1,
    Callback = function(val) 
        KillAuraRateLimit = val
        WindUI:Notify({
            Title = "Kill Aura Rate Updated",
            Content = "Will attack every " .. val .. " seconds",
            Icon = "clock",
            Duration = 2,
        })
    end
})

Tabs.KillAuraTab:Colorpicker({
    Title = "Circle Color",
    Desc = "Color of the kill aura visual circle",
    Default = KillAuraColor,
    Callback = function(color) 
        KillAuraColor = color
        if KillAuraCircle then
            KillAuraCircle.Color = color
        end
    end
})

-- Hitbox Expander Function with Wall Check
function ResetHitboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Size = Vector3.new(2, 2, 1)
                root.Transparency = 0
                root.Color = Color3.fromRGB(255, 255, 255)
                root.Material = Enum.Material.Plastic
                root.CanCollide = true
            end
        end
    end
end

function UpdateHitboxes()
    if not IsEnabled then return end
    
    for _, player in ipairs(cachedPlayers) do
        if player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local shouldExpandHitbox = true
                
                -- Team check
                if HitboxTeamCheck and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                    shouldExpandHitbox = false
                end
                
                -- Wall check using cached visibility
                if HitboxWallCheck and shouldExpandHitbox then
                    shouldExpandHitbox = IsPlayerVisible(player)
                end
                
                if shouldExpandHitbox then
                    root.Size = Vector3.new(HeadSize, HeadSize, HeadSize)
                    root.Transparency = Transparency / 100
                    root.Color = HitboxColor
                    root.Material = Enum.Material.Neon
                    root.CanCollide = false
                else
                    -- Reset to normal if team check or wall check prevents expansion
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 0
                    root.Color = Color3.fromRGB(255, 255, 255)
                    root.Material = Enum.Material.Plastic
                    root.CanCollide = true
                end
            end
        end
    end
end

-- =============== HITBOX TAB ===============
Tabs.HitboxTab:Section({ Title = "Hitbox Settings" })

Tabs.HitboxTab:Toggle({
    Title = "Enable Hitbox",
    Desc = "Expand player hitboxes",
    Icon = "target",
    Value = false,
    Callback = function(val) 
        IsEnabled = val 
        if not val then
            ResetHitboxes()
        end
    end
})

Tabs.HitboxTab:Slider({
    Title = "Hitbox Size",
    Desc = "Size of the expanded hitbox",
    Value = {
        Min = 1,
        Max = 50,
        Default = 20,
    },
    Callback = function(val) 
        HeadSize = val 
    end
})

Tabs.HitboxTab:Slider({
    Title = "Transparency",
    Desc = "Transparency of the hitbox visualization (percentage)",
    Value = {
        Min = 0,
        Max = 100,
        Default = 70,
    },
    Callback = function(val) 
        Transparency = val
    end
})

Tabs.HitboxTab:Toggle({
    Title = "Team Check",
    Desc = "Don't modify teammates' hitboxes",
    Icon = "users",
    Value = false,
    Callback = function(val) 
        HitboxTeamCheck = val 
    end
})

Tabs.HitboxTab:Toggle({
    Title = "Wall Check",
    Desc = "Only expand hitboxes of visible players (not behind walls)",
    Icon = "eye",
    Value = false,
    Callback = function(val) 
        HitboxWallCheck = val 
    end
})

Tabs.HitboxTab:Colorpicker({
    Title = "Hitbox Color",
    Desc = "Color of the hitbox visualization",
    Default = HitboxColor,
    Callback = function(color) 
        HitboxColor = color 
    end
})

-- =============== AIM TAB (UPDATED WITH SILENT AIM AND PREDICTION AI) ===============
Tabs.AimTab:Section({ Title = "Silent Aim" })

Tabs.AimTab:Toggle({
    Title = "Enable Silent Aim",
    Desc = "Standard FOV-based aiming system, Note not as good as the Prediction AI Aimbot",
    Icon = "crosshair",
    Value = false,
    Callback = function(val) 
        SilentAimEnabled = val 
        if not val then
            SilentAimToggled = false -- Reset toggle when disabled
            WindUI:Notify({
                Title = "Silent Aim Disabled",
                Content = "Aimbot system turned off",
                Icon = "square",
                Duration = 2,
            })
        else
            DiagnosticsSystem:Log("INFO", "Silent Aim enabled", "Aimbot")
        end
    end
})

Tabs.AimTab:Dropdown({
    Title = "Aim Target",
    Desc = "Choose which body part to target",
    Default = "HumanoidRootPart",
    Values = {"HumanoidRootPart", "Head"},
    Callback = function(val) 
        SilentAimTarget = val
        WindUI:Notify({
            Title = "Aim Target Changed",
            Content = "Now targeting: " .. val,
            Icon = "target",
            Duration = 2,
        })
    end
})


Tabs.AimTab:Slider({
    Title = "Smoothness",
    Desc = "How smooth the cursor movement is (percentage)",
    Value = {
        Min = 5,
        Max = 100,
        Default = 15,
    },
    Callback = function(val) 
        SilentAimSmoothness = val
    end
})

Tabs.AimTab:Toggle({
    Title = "Team Check",
    Desc = "Don't target teammates",
    Icon = "users",
    Value = false,
    Callback = function(val) 
        SilentAimTeamCheck = val 
    end
})

Tabs.AimTab:Toggle({
    Title = "FOV Circle",
    Desc = "Show field of view circle that follows cursor",
    Icon = "circle",
    Value = false,
    Callback = function(val) 
        SilentAimFOVEnabled = val
        if val then
            CreateSilentAimFOVCircle()
            WindUI:Notify({
                Title = "FOV Circle Enabled",
                Content = "Circle will follow your cursor and target players inside",
                Icon = "circle",
                Duration = 3,
            })
        else
            RemoveSilentAimFOVCircle()
            WindUI:Notify({
                Title = "FOV Circle Disabled",
                Content = "FOV Circle removed",
                Icon = "square",
                Duration = 2,
            })
        end
    end
})

Tabs.AimTab:Slider({
    Title = "FOV Radius",
    Desc = "Size of the FOV circle",
    Value = {
        Min = 30,
        Max = 300,
        Default = 100,
    },
    Callback = function(val) 
        SilentAimFOVRadius = val
        if SilentAimFOVCircle then
            SilentAimFOVCircle.Radius = val
        end
    end
})

Tabs.AimTab:Slider({
    Title = "Auto Kill Delay",
    Desc = "Delay between automatic kills (seconds)",
    Value = {
        Min = 0.1,
        Max = 3.0,
        Default = 0.5,
    },
    Step = 0.1,
    Callback = function(val) 
        SilentAimAutoKillDelay = val
    end
})

Tabs.AimTab:Keybind({
    Title = "Toggle Key",
    Desc = "Key to toggle Silent Aim tracking on/off",
    Value = "RightMouseButton",
    Callback = function(v)
        -- Map string values to actual keycodes
        if v == "RightMouseButton" then
            SilentAimKey = Enum.UserInputType.MouseButton2
        elseif v == "LeftAlt" then
            SilentAimKey = Enum.KeyCode.LeftAlt
        elseif v == "LeftControl" then
            SilentAimKey = Enum.KeyCode.LeftControl
        elseif v == "F" then
            SilentAimKey = Enum.KeyCode.F
        elseif v == "G" then
            SilentAimKey = Enum.KeyCode.G
        elseif v == "Q" then
            SilentAimKey = Enum.KeyCode.Q
        elseif v == "E" then
            SilentAimKey = Enum.KeyCode.E
        elseif v == "R" then
            SilentAimKey = Enum.KeyCode.R
        elseif v == "T" then
            SilentAimKey = Enum.KeyCode.T
        elseif v == "Y" then
            SilentAimKey = Enum.KeyCode.Y
        elseif v == "U" then
            SilentAimKey = Enum.KeyCode.U
        elseif v == "I" then
            SilentAimKey = Enum.KeyCode.I
        elseif v == "O" then
            SilentAimKey = Enum.KeyCode.O
        elseif v == "P" then
            SilentAimKey = Enum.KeyCode.P
        elseif v == "C" then
            SilentAimKey = Enum.KeyCode.C
        elseif v == "V" then
            SilentAimKey = Enum.KeyCode.V
        elseif v == "B" then
            SilentAimKey = Enum.KeyCode.B
        elseif v == "N" then
            SilentAimKey = Enum.KeyCode.N
        elseif v == "M" then
            SilentAimKey = Enum.KeyCode.M
        elseif v == "X" then
            SilentAimKey = Enum.KeyCode.X
        elseif v == "Z" then
            SilentAimKey = Enum.KeyCode.Z
        end
        
        WindUI:Notify({
            Title = "Keybind Updated",
            Content = "Silent Aim toggle key set to: " .. tostring(v),
            Icon = "keyboard",
            Duration = 2,
        })
    end
})

-- NEW: PREDICTION AI Section
Tabs.AimTab:Section({ Title = "AI Prediction Aimbot (Alpha)" })

Tabs.AimTab:Toggle({
    Title = "Enable Prediction AI",
    Desc = "AI-assisted prediction system for moving targets",
    Icon = "brain",
    Value = false,
    Callback = function(val) 
        PredictionAIEnabled = val
        if val then
            DiagnosticsSystem:Log("INFO", "Prediction AI enabled", "Prediction")
            WindUI:Notify({
                Title = "Prediction AI Enabled",
                Content = "Now using AI prediction for moving targets",
                Icon = "brain",
                Duration = 3,
            })
        else
            DiagnosticsSystem:Log("INFO", "Prediction AI disabled", "Prediction")
            WindUI:Notify({
                Title = "Prediction AI Disabled",
                Content = "Using standard targeting",
                Icon = "square",
                Duration = 2,
            })
        end
    end
})

Tabs.AimTab:Slider({
    Title = "Time Ahead",
    Desc = "How far ahead to predict target position (seconds)",
    Value = {
        Min = 0.1,
        Max = 2.0,
        Default = 0.3,
    },
    Step = 0.1,
    Callback = function(val) 
        PredictionTimeAhead = val
        DiagnosticsSystem:Log("DEBUG", string.format("Prediction time ahead set to %.1f seconds", val), "Prediction")
    end
})

Tabs.AimTab:Slider({
    Title = "Probability",
    Desc = "Blend between predicted and actual position (0-100%)",
    Value = {
        Min = 0,
        Max = 100,
        Default = 85,
    },
    Callback = function(val) 
        PredictionProbability = val
        DiagnosticsSystem:Log("DEBUG", string.format("Prediction probability set to %d%%", val), "Prediction")
    end
})

Tabs.AimTab:Dropdown({
    Title = "Prediction Model",
    Desc = "Algorithm used for position prediction",
    Default = "Linear",
    Values = {"Linear", "Acceleration", "Pattern-Learning"},
    Callback = function(val) 
        PredictionModel = val
        DiagnosticsSystem:Log("INFO", string.format("Prediction model changed to %s", val), "Prediction")
        WindUI:Notify({
            Title = "Prediction Model Updated",
            Content = "Now using " .. val .. " prediction",
            Icon = "settings",
            Duration = 2,
        })
    end
})


Tabs.AimTab:Toggle({
    Title = "Debug Overlay",
    Desc = "Show prediction debug information",
    Icon = "info",
    Value = false,
    Callback = function(val) 
        PredictionDebugOverlay = val
        if val then
            DiagnosticsSystem.showDebugOverlay = true
            if not DiagnosticsSystem.overlay then
                DiagnosticsSystem:CreateDebugOverlay()
            end
        else
            if not DiagnosticsSystem.showDebugOverlay then
                DiagnosticsSystem:DestroyOverlay()
            end
        end
    end
})

-- =============== OPTIMIZED TRACERS FUNCTIONS ===============
function ClearTracersESP(player)
    if player and TracersESP[player] then
        if TracersESP[player].line then
            ReturnLineToPool(TracersESP[player].line)
        end
        TracersESP[player] = nil
    elseif not player then
        -- Clear all
        for _, data in pairs(TracersESP) do
            if data.line then
                ReturnLineToPool(data.line)
            end
        end
        TracersESP = {}
    end
end

function CreateTracersESP(player)
    if TracersESP[player] then return end
    
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local line = GetLineFromPool()
    line.Thickness = TracersThickness
    line.Transparency = 0.8
    line.Color = TracersColor
    line.Visible = true
    
    TracersESP[player] = {
        root = root,
        line = line
    }
end

function UpdateTracersESP()
    if not LocalPlayer.Character then return end
    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    
    for player, data in pairs(TracersESP) do
        if not player or not player.Character or player.Character.Parent == nil then
            ClearTracersESP(player)
        else
            if data.root and data.root.Parent then
                -- Check if player is visible first
                if IsPlayerVisible(player) then
                    -- Get screen positions
                    local localScreenPos, localOnScreen = Camera:WorldToViewportPoint(localRoot.Position)
                    local targetScreenPos, targetOnScreen = Camera:WorldToViewportPoint(data.root.Position)
                    
                    -- Check if both positions are valid and target is in front of camera
                    if localOnScreen and targetOnScreen and targetScreenPos.Z > 0 and localScreenPos.Z > 0 then
                        -- Check if target is within camera view
                        local inView = targetScreenPos.X >= 0 and targetScreenPos.X <= Camera.ViewportSize.X and
                                      targetScreenPos.Y >= 0 and targetScreenPos.Y <= Camera.ViewportSize.Y
                        
                        if inView then
                            -- Draw line from center of screen to target
                            local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            data.line.From = centerScreen
                            data.line.To = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                            data.line.Visible = true
                            data.line.Color = TracersColor
                            data.line.Thickness = TracersThickness
                        else
                            data.line.Visible = false
                        end
                    else
                        data.line.Visible = false
                    end
                else
                    -- Player is not visible (behind wall or out of FOV)
                    data.line.Visible = false
                end
            else
                data.line.Visible = false
            end
        end
    end
end

-- =============== TRACERS TAB SETUP ===============
Tabs.TracersTab:Section({ Title = "Tracer Settings" })

Tabs.TracersTab:Toggle({
    Title = "Enable Tracers",
    Desc = "Show lines from center of screen to visible players only",
    Icon = "git-branch",
    Value = false,
    Callback = function(val) 
        TracersEnabled = val 
        if not val then 
            ClearTracersESP() -- Clear all
            WindUI:Notify({
                Title = "Tracers Disabled",
                Content = "All tracer lines removed",
                Icon = "square",
                Duration = 2,
            })
        else
            WindUI:Notify({
                Title = "Tracers Enabled",
                Content = "Now showing lines to visible players only",
                Icon = "git-branch",
                Duration = 3,
            })
        end
    end
})

Tabs.TracersTab:Slider({
    Title = "Line Thickness",
    Desc = "Thickness of the tracer lines",
    Value = {
        Min = 1,
        Max = 10,
        Default = 1,
    },
    Callback = function(val) 
        TracersThickness = val
        -- Update existing tracers
        for _, data in pairs(TracersESP) do
            if data.line then
                data.line.Thickness = val
            end
        end
    end
})

Tabs.TracersTab:Colorpicker({
    Title = "Line Color",
    Desc = "Color of the tracer lines",
    Default = TracersColor,
    Callback = function(color) 
        TracersColor = color
        -- Update existing tracers
        for _, data in pairs(TracersESP) do
            if data.line then
                data.line.Color = color
            end
        end
    end
})

Tabs.TracersTab:Toggle({
    Title = "Team Check",
    Desc = "Don't show tracers to teammates",
    Icon = "users",
    Value = false,
    Callback = function(val) 
        TracersTeamCheck = val 
        -- Force refresh tracers when team check changes
        if val then
            -- Clear tracers for teammates
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                    ClearTracersESP(player)
                end
            end
        end
    end
})

-- =============== OPTIMIZED ESP FUNCTIONS ===============

-- Clear Functions
function ClearSkeletonESP(player)
    if player and SkeletonESP[player] then
        for _, connection in ipairs(SkeletonESP[player]) do
            if connection.line then
                ReturnLineToPool(connection.line)
            end
        end
        SkeletonESP[player] = nil
    elseif not player then
        -- Clear all
        for _, connections in pairs(SkeletonESP) do
            for _, connection in ipairs(connections) do
                if connection.line then
                    ReturnLineToPool(connection.line)
                end
            end
        end
        SkeletonESP = {}
    end
end

function ClearHeadESP(player)
    if player and HeadESP[player] then
        if HeadESP[player].dot then
            ReturnCircleToPool(HeadESP[player].dot)
        end
        HeadESP[player] = nil
    elseif not player then
        -- Clear all
        for _, data in pairs(HeadESP) do
            if data.dot then
                ReturnCircleToPool(data.dot)
            end
        end
        HeadESP = {}
    end
end

function ClearBoxESP(player)
    pcall(function()
        if player and BoxESP[player] then
            if BoxESP[player].box then
                BoxESP[player].box:Remove()
            end
            BoxESP[player] = nil
        elseif not player then
            -- Clear all
            for _, data in pairs(BoxESP) do
                if data.box then
                    data.box:Remove()
                end
            end
            BoxESP = {}
        end
    end)
end

function ClearCharmsESP(player)
    if player and CharmsESP[player] then
        for _, highlight in ipairs(CharmsESP[player]) do
            if highlight then
                highlight:Destroy()
            end
        end
        CharmsESP[player] = nil
    elseif not player then
        -- Clear all
        for _, highlights in pairs(CharmsESP) do
            for _, highlight in ipairs(highlights) do
                if highlight then
                    highlight:Destroy()
                end
            end
        end
        CharmsESP = {}
    end
end

-- Create Functions
function CreateSkeletonESP(player)
    if SkeletonESP[player] then return end
    
    local connections = {}
    local char = player.Character
    if not char then return end
    
    local parts = {
        Head = char:FindFirstChild("Head"),
        UpperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"),
        LowerTorso = char:FindFirstChild("LowerTorso"),
        LeftUpperArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm"),
        LeftLowerArm = char:FindFirstChild("LeftLowerArm"),
        LeftHand = char:FindFirstChild("LeftHand"),
        RightUpperArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm"),
        RightLowerArm = char:FindFirstChild("RightLowerArm"),
        RightHand = char:FindFirstChild("RightHand"),
        LeftUpperLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg"),
        LeftLowerLeg = char:FindFirstChild("LeftLowerLeg"),
        LeftFoot = char:FindFirstChild("LeftFoot"),
        RightUpperLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg"),
        RightLowerLeg = char:FindFirstChild("RightLowerLeg"),
        RightFoot = char:FindFirstChild("RightFoot")
    }
    
    if not parts.Head or not parts.UpperTorso then return end
    
    local boneConnections = {
        {parts.Head, parts.UpperTorso},
        {parts.UpperTorso, parts.LowerTorso or parts.UpperTorso},
        {parts.UpperTorso, parts.LeftUpperArm},
        {parts.LeftUpperArm, parts.LeftLowerArm},
        {parts.LeftLowerArm, parts.LeftHand},
        {parts.UpperTorso, parts.RightUpperArm},
        {parts.RightUpperArm, parts.RightLowerArm},
        {parts.RightLowerArm, parts.RightHand},
        {parts.LowerTorso or parts.UpperTorso, parts.LeftUpperLeg},
        {parts.LeftUpperLeg, parts.LeftLowerLeg},
        {parts.LeftLowerLeg, parts.LeftFoot},
        {parts.LowerTorso or parts.UpperTorso, parts.RightUpperLeg},
        {parts.RightUpperLeg, parts.RightLowerLeg},
        {parts.RightLowerLeg, parts.RightFoot}
    }
    
    for _, connection in ipairs(boneConnections) do
        local part1, part2 = connection[1], connection[2]
        if part1 and part2 and part1 ~= part2 then
            local line = GetLineFromPool()
            line.Thickness = 1
            line.Transparency = 0.5
            line.Color = ESPColor
            line.Visible = true
            
            table.insert(connections, {
                part1 = part1,
                part2 = part2,
                line = line
            })
        end
    end
    
    SkeletonESP[player] = connections
end

function CreateCharmsESP(player)
    if CharmsESP[player] then return end
    if not player.Character then return end
    
    -- Create a single highlight for the entire character
    local highlight = Instance.new("Highlight")
    highlight.Adornee = player.Character
    highlight.FillColor = ESPColor
    highlight.OutlineColor = ESPColor
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character
    
    CharmsESP[player] = {highlight}
end

function CreateHeadESP(player)
    if HeadESP[player] then return end
    
    local char = player.Character
    if not char then return end
    
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local dot = GetCircleFromPool()
    dot.Thickness = 1
    dot.Filled = true
    dot.Transparency = 0.5
    dot.Color = ESPColor
    dot.Radius = 4
    dot.Visible = true
    
    HeadESP[player] = {
        head = head,
        dot = dot
    }
end

function CreateBoxESP(player)
    pcall(function()
        if BoxESP[player] then return end
        
        local char = player.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local box = Drawing.new("Quad")
        box.Thickness = 1
        box.Filled = false
        box.Transparency = 0.5
        box.Color = ESPColor
        box.Visible = true
        
        BoxESP[player] = {
            root = root,
            box = box
        }
    end)
end

-- Update Functions with LOD (Level of Detail) optimization
function UpdateSkeletonESP()
    for player, connections in pairs(SkeletonESP) do
        if not player or not player.Character or player.Character.Parent == nil then
            ClearSkeletonESP(player)
        else
            -- Get cached distance for LOD
            local distance = cachedPlayerDistances[player] or math.huge
            
            -- Skip if too far away
            if distance > MAX_ESP_DISTANCE then
                for _, connection in ipairs(connections) do
                    if connection.line then
                        connection.line.Visible = false
                    end
                end
            else
                -- Check if player is in field of view first
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if not root then
                    -- Hide all lines if no root part
                    for _, connection in ipairs(connections) do
                        if connection.line then
                            connection.line.Visible = false
                        end
                    end
                else
                    local rootPos, rootOnScreen = Camera:WorldToViewportPoint(root.Position)
                    local isPlayerVisible = rootOnScreen and rootPos.Z > 0
                    
                    if not isPlayerVisible then
                        -- Hide all lines if player is out of view
                        for _, connection in ipairs(connections) do
                            if connection.line then
                                connection.line.Visible = false
                            end
                        end
                    else
                        -- Use simplified skeleton for distant players (LOD)
                        local useSimplified = distance > LOD_DISTANCE
                        
                        -- Update individual bone connections
                        for i, connection in ipairs(connections) do
                            if connection.part1 and connection.part2 and connection.part1.Parent and connection.part2.Parent then
                                -- Skip some connections for distant players (LOD)
                                if useSimplified and (i > 6) then -- Only show major bones
                                    connection.line.Visible = false
                                else
                                    local pos1, onScreen1 = Camera:WorldToViewportPoint(connection.part1.Position)
                                    local pos2, onScreen2 = Camera:WorldToViewportPoint(connection.part2.Position)
                                    
                                    -- Only show line if both points are visible and in front of camera
                                    if onScreen1 and onScreen2 and pos1.Z > 0 and pos2.Z > 0 then
                                        connection.line.From = Vector2.new(pos1.X, pos1.Y)
                                        connection.line.To = Vector2.new(pos2.X, pos2.Y)
                                        connection.line.Visible = true
                                        connection.line.Color = ESPColor
                                    else
                                        connection.line.Visible = false
                                    end
                                end
                            else
                                connection.line.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end
end

function UpdateHeadESP()
    for player, data in pairs(HeadESP) do
        if not player or not player.Character or player.Character.Parent == nil then
            ClearHeadESP(player)
        else
            -- Distance culling
            local distance = cachedPlayerDistances[player] or math.huge
            if distance > MAX_ESP_DISTANCE then
                data.dot.Visible = false
            elseif data.head and data.head.Parent then
                local pos, onScreen = Camera:WorldToViewportPoint(data.head.Position)
                -- Check if position is in front of camera and on screen
                if onScreen and pos.Z > 0 and pos.X >= 0 and pos.Y >= 0 and pos.X <= Camera.ViewportSize.X and pos.Y <= Camera.ViewportSize.Y then
                    data.dot.Position = Vector2.new(pos.X, pos.Y)
                    data.dot.Visible = true
                    data.dot.Color = ESPColor
                    
                    -- Adjust size based on distance (LOD)
                    local scale = math.max(0.5, 100 / distance)
                    data.dot.Radius = math.max(2, 4 * scale)
                else
                    data.dot.Visible = false
                end
            else
                data.dot.Visible = false
            end
        end
    end
end

function UpdateBoxESP()
    pcall(function()
        for player, data in pairs(BoxESP) do
            -- invalid player / character -> remove and cleanup
            if not player or not player.Character or player.Character.Parent == nil then
                if data and data.box then
                    pcall(function() data.box:Remove() end)
                end
                BoxESP[player] = nil
            else
                -- ensure root exists
                if not data.root or not data.root.Parent then
                    if data and data.box then
                        pcall(function() data.box:Remove() end)
                    end
                    BoxESP[player] = nil
                else
                    -- choose head for detection, fallback to root
                    local head = player.Character:FindFirstChild("Head")
                    local checkPosition = head and head.Position or data.root.Position

                    local screenPos, onScreen = Camera:WorldToViewportPoint(checkPosition)
                    local inView = onScreen and screenPos.Z > 0 and
                                   screenPos.X >= 0 and screenPos.X <= Camera.ViewportSize.X and
                                   screenPos.Y >= 0 and screenPos.Y <= Camera.ViewportSize.Y

                    -- if the player center/head isn't clearly inside the viewport, remove the quad (prevents stuck visuals)
                    if not inView then
                        if data and data.box then
                            pcall(function() data.box:Remove() end)
                        end
                        BoxESP[player] = nil
                    else
                        -- player is in view – compute the 4 quad corners relative to the root
                        local cf = data.root.CFrame
                        local size = Vector3.new(3, 5, 0) -- tune to fit your character
                        local points = {
                            Vector3.new(-size.X, -size.Y, 0),
                            Vector3.new(size.X, -size.Y, 0),
                            Vector3.new(size.X, size.Y, 0),
                            Vector3.new(-size.X, size.Y, 0)
                        }

                        local points2D = {}
                        local allPointsValid = true

                        for i, point in ipairs(points) do
                            local worldPoint = cf:PointToWorldSpace(point)
                            local sp, pointVisible = Camera:WorldToViewportPoint(worldPoint)

                            if pointVisible and sp.Z > 0 then
                                points2D[i] = Vector2.new(sp.X, sp.Y)
                            else
                                allPointsValid = false
                                break
                            end
                        end

                        if allPointsValid and #points2D == 4 then
                            -- write coordinates to quad and show it
                            data.box.PointA = points2D[1]
                            data.box.PointB = points2D[2]
                            data.box.PointC = points2D[3]
                            data.box.PointD = points2D[4]
                            data.box.Visible = true
                            data.box.Color = ESPColor
                        else
                            -- If corners aren't valid, remove the quad to avoid remnants
                            if data and data.box then
                                pcall(function() data.box:Remove() end)
                            end
                            BoxESP[player] = nil
                        end
                    end
                end
            end
        end
    end)
end

-- Main ESP Management
function UpdateAllESP()
    for _, player in ipairs(cachedPlayers) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local shouldShowESP = true
            local shouldShowTracers = true
            
            -- Check ESP team check (separate from other features)
            if ESPTeamCheck and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                shouldShowESP = false
            end
            
            -- Check Tracers team check (separate from ESP)
            if TracersTeamCheck and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                shouldShowTracers = false
            end
            
            -- Handle ESP
            if shouldShowESP then
                if SkeletonESPEnabled and not SkeletonESP[player] then
                    CreateSkeletonESP(player)
                elseif not SkeletonESPEnabled and SkeletonESP[player] then
                    ClearSkeletonESP(player)
                end
                
                if HeadESPEnabled and not HeadESP[player] then
                    CreateHeadESP(player)
                elseif not HeadESPEnabled and HeadESP[player] then
                    ClearHeadESP(player)
                end
                
                if BoxESPEnabled and not BoxESP[player] then
                    CreateBoxESP(player)
                elseif not BoxESPEnabled and BoxESP[player] then
                    ClearBoxESP(player)
                end
                
                if CharmsESPEnabled and not CharmsESP[player] then
                    CreateCharmsESP(player)
                elseif not CharmsESPEnabled and CharmsESP[player] then
                    ClearCharmsESP(player)
                end
            else
                -- Clear ESP for teammates if team check is enabled
                if SkeletonESP[player] then ClearSkeletonESP(player) end
                if HeadESP[player] then ClearHeadESP(player) end
                if BoxESP[player] then ClearBoxESP(player) end
                if CharmsESP[player] then ClearCharmsESP(player) end
            end
            
            -- Handle Tracers (separate from ESP)
            if shouldShowTracers then
                if TracersEnabled and not TracersESP[player] then
                    CreateTracersESP(player)
                elseif not TracersEnabled and TracersESP[player] then
                    ClearTracersESP(player)
                end
            else
                -- Clear tracers for teammates if team check is enabled
                if TracersESP[player] then ClearTracersESP(player) end
            end
        end
    end
    
    -- Clean up disconnected players
    for player, _ in pairs(SkeletonESP) do
        if not player or not player.Parent or not Players:FindFirstChild(player.Name) then
            ClearSkeletonESP(player)
        end
    end
    for player, _ in pairs(HeadESP) do
        if not player or not player.Parent or not Players:FindFirstChild(player.Name) then
            ClearHeadESP(player)
        end
    end
    for player, _ in pairs(BoxESP) do
        if not player or not player.Parent or not Players:FindFirstChild(player.Name) then
            ClearBoxESP(player)
        end
    end
    for player, _ in pairs(CharmsESP) do
        if not player or not player.Parent or not Players:FindFirstChild(player.Name) then
            ClearCharmsESP(player)
        end
    end
    for player, _ in pairs(TracersESP) do
        if not player or not player.Parent or not Players:FindFirstChild(player.Name) then
            ClearTracersESP(player)
        end
    end
end

function UpdateAllESPColors()
    -- Update Skeleton ESP colors
    for player, connections in pairs(SkeletonESP) do
        for _, connection in ipairs(connections) do
            if connection.line then
                connection.line.Color = ESPColor
            end
        end
    end
    
    -- Update Head ESP colors
    for player, data in pairs(HeadESP) do
        if data.dot then
            data.dot.Color = ESPColor
        end
    end
    
    -- Update Box ESP colors
    for player, data in pairs(BoxESP) do
        if data.box then
            data.box.Color = ESPColor
        end
    end
    
    -- Update Charms ESP colors
    for player, highlights in pairs(CharmsESP) do
        for _, highlight in ipairs(highlights) do
            if highlight then
                highlight.FillColor = ESPColor
                highlight.OutlineColor = ESPColor
            end
        end
    end
    
    -- Tracers colors are updated separately via their own color picker
end

-- =============== ESP TAB ===============
Tabs.ESPTab:Section({ Title = "ESP Features" })

Tabs.ESPTab:Toggle({
    Title = "Skeleton ESP",
    Desc = "Show player skeleton outlines",
    Icon = "user",
    Value = false,
    Callback = function(val) 
        SkeletonESPEnabled = val 
        if not val then 
            ClearSkeletonESP() -- Clear all
        end
    end
})

Tabs.ESPTab:Toggle({
    Title = "Head ESP",
    Desc = "Show dots on player heads",
    Icon = "circle",
    Value = false,
    Callback = function(val) 
        HeadESPEnabled = val 
        if not val then 
            ClearHeadESP() -- Clear all
        end
    end
})

Tabs.ESPTab:Toggle({
    Title = "Box ESP (Performance Heavy)",
    Desc = "Show boxes around players (Not Recommended)",
    Icon = "square",
    Value = false,
    Callback = function(val) 
        BoxESPEnabled = val 
        if not val then 
            ClearBoxESP() -- Clear all
        end
    end
})

Tabs.ESPTab:Toggle({
    Title = "Chams ESP",
    Desc = "Highlight entire player models",
    Icon = "sparkles",
    Value = false,
    Callback = function(val) 
        CharmsESPEnabled = val 
        if not val then 
            ClearCharmsESP() -- Clear all
        end
    end
})

Tabs.ESPTab:Toggle({
    Title = "Team Check",
    Desc = "Don't show ESP on teammates",
    Icon = "users",
    Value = false,
    Callback = function(val) 
        ESPTeamCheck = val 
        -- Force refresh ESP when team check changes
        if val then
            -- Clear ESP for teammates
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                    ClearSkeletonESP(player)
                    ClearHeadESP(player)
                    ClearBoxESP(player)
                    ClearCharmsESP(player)
                end
            end
        end
    end
})

Tabs.ESPTab:Colorpicker({
    Title = "ESP Color",
    Desc = "Color of all ESP elements",
    Default = ESPColor,
    Callback = function(color) 
        ESPColor = color 
        UpdateAllESPColors()
    end
})

-- =============== COOLDOWN TAB (Coming Soon) ===============
Tabs.CooldownTab:Section({ Title = "Weapon Cooldowns" })

Tabs.CooldownTab:Paragraph({
    Title = "Coming Soon!",
    Desc = "Cooldown bypass features are currently in development.",
    Color = "Orange",
    Image = "clock"
})

-- =============== EMOTES TAB (NEW) ===============
Tabs.EmotesTab:Section({ Title = "Animation Controls" })

Tabs.EmotesTab:Paragraph({
    Title = "Emote Instructions",
    Desc = "Click emote and get free emote simple as that ngl",
    Color = "Blue",
    Image = "info"
})

Tabs.EmotesTab:Button({
    Title = "Rocky Step",
    Desc = "Play the Rocky Step emote animation",
    Callback = function()
        playAnimationUntilMove("rbxassetid://17493148164") -- rock step emote
        WindUI:Notify({
            Title = "Animation Started",
            Content = "Playing Rocky Step emote! Move to stop.",
            Icon = "music",
            Duration = 3,
        })
    end
})

Tabs.EmotesTab:Button({
    Title = "Zombie Walk",
    Desc = "Play the Zombie Walk animation",
    Callback = function()
        playAnimationUntilMove("rbxassetid://130586820736295") -- Zombie Walk
        WindUI:Notify({
            Title = "Animation Started",
            Content = "Playing Zombie Walk! Move to stop.",
            Icon = "music",
            Duration = 3,
        })
    end
})

Tabs.EmotesTab:Button({
    Title = "Russian Kicks",
    Desc = "Play the Russian Kicks dance animation",
    Callback = function()
        playAnimationUntilMove("rbxassetid://17467252077") -- Russian Kicks
        WindUI:Notify({
            Title = "Animation Started",
            Content = "Playing Russian Kicks! Move to stop.",
            Icon = "music",
            Duration = 3,
        })
    end
})

-- =============== FLIGHT SYSTEM ===============
function EnableFlight()
    if not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    humanoid.PlatformStand = true
    
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Clean up any existing BodyVelocity
    if FlightBodyVelocity then
        FlightBodyVelocity:Destroy()
    end
    
    FlightBodyVelocity = Instance.new("BodyVelocity")
    FlightBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlightBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    FlightBodyVelocity.Parent = root
    
    local flyConnection
    flyConnection = RunService.Heartbeat:Connect(function()
        if not FlightEnabled or not LocalPlayer.Character or not root.Parent or not FlightBodyVelocity then
            if FlightBodyVelocity then
                FlightBodyVelocity:Destroy()
                FlightBodyVelocity = nil
            end
            if flyConnection then flyConnection:Disconnect() end
            if humanoid then humanoid.PlatformStand = false end
            return
        end
        
        local camCF = Camera.CFrame
        local moveVec = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVec = moveVec + camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVec = moveVec - camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVec = moveVec + camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVec = moveVec - camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVec = moveVec + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveVec = moveVec - Vector3.new(0, 1, 0)
        end
        
        if moveVec.Magnitude > 0 then
            FlightBodyVelocity.Velocity = moveVec.Unit * FlightSpeed
        else
            FlightBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    table.insert(FlightConnections, flyConnection)
end

function DisableFlight()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
        
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, v in ipairs(root:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
    end
    
    if FlightBodyVelocity then
        FlightBodyVelocity:Destroy()
        FlightBodyVelocity = nil
    end
    
    for _, conn in ipairs(FlightConnections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    FlightConnections = {}
end

-- =============== EXTRA TAB ===============
Tabs.ExtraTab:Section({ Title = "Movement" })

Tabs.ExtraTab:Toggle({
    Title = "Flight (Ass)",
    Desc = "Im working on it :(",
    Icon = "plane",
    Value = false,
    Callback = function(val) 
        FlightEnabled = val
        if FlightEnabled then
            EnableFlight()
        else
            DisableFlight()
        end
    end
})

Tabs.ExtraTab:Slider({
    Title = "Flight Speed",
    Desc = "Speed of flight movement",
    Value = {
        Min = 10,
        Max = 200,
        Default = 50,
    },
    Step = 5,
    Callback = function(val) 
        FlightSpeed = val 
    end
})

Tabs.ExtraTab:Section({ Title = "Information" })

Tabs.ExtraTab:Paragraph({
    Title = "Script Info",
    Desc = "Ez Win v3 Performance Enhanced with Tracers, Silent Aim, and Prediction AI\nConverted to WindUI with advanced diagnostics\nPress F4 to toggle UI, F9 to toggle debug overlay",
    Color = "Blue",
    Image = "info"
})

Tabs.ExtraTab:Paragraph({
    Title = "IMPORTANT NOTICE",
    Desc = "If you are on an unsupported executor you may experience crashes or have be very buggy, we have tried our best to optimize for the lower sUNC executors like Solara, Xeno and have got decent performance but becareful!",
    Color = "Red",
    Image = "alert-triangle"
})

-- =============== ENHANCED PERFORMANCE TAB ===============
local performanceStats = {
    mainFPS = 0,
    espFPS = 0,
    playersRendered = 0,
    pooledObjects = 0,
    frameTime = 0,
    lastUpdateTime = 0
}

-- Create paragraph reference for updating
local performanceParagraph = nil

Tabs.PerformanceTab:Section({ Title = "Performance Monitoring" })

performanceParagraph = Tabs.PerformanceTab:Paragraph({
    Title = "Live Performance Stats",
    Desc = "FPS: 0 | Frame Time: 0.00 ms\nESP FPS: 0 | Players Rendered: 0\nPooled Objects: 0 | CPU Load: 0%",
    Color = "Green",
    Image = "activity"
})

-- Update it every frame
MainUpdateConnection = RunService.Heartbeat:Connect(function(dt)
    DiagnosticsSystem:UpdatePerformanceMetrics(dt)

    performanceParagraph:SetDesc(string.format(
        "FPS: %d | Frame Time: %.2f ms\nESP FPS: %d | CPU: %d%% | Players: %d",
        DiagnosticsSystem.currentFPS,
        DiagnosticsSystem.frameTime,
        ESP_TICK_RATE,
        DiagnosticsSystem.cpuLoad,
        #Players:GetPlayers()
    ))
end)

-- Start performance monitoring connection
local performanceUpdateConnection = RunService.Heartbeat:Connect(function()
    -- Update every 0.5 seconds to avoid spam
    local currentTime = tick()
    if currentTime - performanceStats.lastUpdateTime >= 0.5 then
        performanceStats.lastUpdateTime = currentTime
        
        -- Get current stats
        performanceStats.mainFPS = DiagnosticsSystem.currentFPS
        performanceStats.espFPS = ESP_TICK_RATE
        performanceStats.playersRendered = #cachedPlayers
        performanceStats.pooledObjects = #LinePool + #CirclePool + #QuadPool
        performanceStats.frameTime = DiagnosticsSystem.frameTime
        
        -- Update the paragraph display
        local statsText = string.format(
            "FPS: %d | Frame Time: %.2f ms\nESP FPS: %d | Players Rendered: %d\nPooled Objects: %d | CPU Load: %d%%",
            performanceStats.mainFPS,
            performanceStats.frameTime,
            performanceStats.espFPS,
            performanceStats.playersRendered,
            performanceStats.pooledObjects,
            DiagnosticsSystem.cpuLoad
        )
        
        -- Try to update paragraph if WindUI supports it
        pcall(function()
            if performanceParagraph and performanceParagraph.SetDesc then
                performanceParagraph:SetDesc(statsText)
            elseif performanceParagraph and performanceParagraph.UpdateDesc then
                performanceParagraph:UpdateDesc(statsText)
            end
        end)
    end
end)


Tabs.PerformanceTab:Section({ Title = "Optimization Settings" })

Tabs.PerformanceTab:Slider({
    Title = "LOD Distance",
    Desc = "Use simplified rendering beyond this distance (studs)",
    Value = {
        Min = 50,
        Max = 500,
        Default = 150,
    },
    Step = 25,
    Callback = function(val) 
        LOD_DISTANCE = val 
        DiagnosticsSystem:Log("DEBUG", string.format("LOD distance set to %d studs", val), "Performance")
    end
})

Tabs.PerformanceTab:Slider({
    Title = "ESP Tick Rate",
    Desc = "ESP update frequency (FPS)",
    Value = {
        Min = 10,
        Max = 60,
        Default = 30,
    },
    Step = 5,
    Callback = function(val) 
        ESP_TICK_RATE = val 
        DiagnosticsSystem:Log("INFO", string.format("ESP tick rate set to %d FPS", val), "Performance")
    end
})

Tabs.PerformanceTab:Button({
    Title = "Clear Object Pools",
    Desc = "Clear and reset all drawing object pools",
    Callback = function()
        -- Clear all pools
        for _, line in ipairs(LinePool) do
            if line then line:Remove() end
        end
        for _, circle in ipairs(CirclePool) do
            if circle then circle:Remove() end
        end
        for _, quad in ipairs(QuadPool) do
            if quad then quad:Remove() end
        end
        
        LinePool = {}
        CirclePool = {}
        QuadPool = {}
        
        DiagnosticsSystem:Log("INFO", "Object pools cleared and reset", "Performance")
        
        WindUI:Notify({
            Title = "Object Pools Cleared",
            Content = "All drawing object pools have been reset",
            Icon = "trash-2",
            Duration = 3,
        })
    end
})

-- NEW: Diagnostics & Logging Section
Tabs.PerformanceTab:Section({ Title = "Diagnostics & Logging" })

Tabs.PerformanceTab:Toggle({
    Title = "Show Debug Overlay",
    Desc = "Display diagnostic information overlay",
    Icon = "monitor",
    Value = false,
    Callback = function(val) 
        DiagnosticsSystem.showDebugOverlay = val
        if val then
            if not DiagnosticsSystem.overlay then
                DiagnosticsSystem:CreateDebugOverlay()
            end
            DiagnosticsSystem:Log("INFO", "Debug overlay enabled", "Diagnostics")
        else
            if not PredictionDebugOverlay then -- Only destroy if prediction debug is also off
                DiagnosticsSystem:DestroyOverlay()
            end
            DiagnosticsSystem:Log("INFO", "Debug overlay disabled", "Diagnostics")
        end
    end
})

Tabs.PerformanceTab:Toggle({
    Title = "Log To Console",
    Desc = "Output diagnostic messages to console",
    Icon = "terminal",
    Value = false,
    Callback = function(val) 
        DiagnosticsSystem.logToConsole = val
        DiagnosticsSystem:Log("INFO", val and "Console logging enabled" or "Console logging disabled", "Diagnostics")
    end
})

Tabs.PerformanceTab:Toggle({
    Title = "Save Session Log",
    Desc = "Keep session log in memory for export",
    Icon = "save",
    Value = false,
    Callback = function(val) 
        DiagnosticsSystem.saveSessionLog = val
        DiagnosticsSystem:Log("INFO", val and "Session logging enabled" or "Session logging disabled", "Diagnostics")
    end
})

Tabs.PerformanceTab:Dropdown({
    Title = "Debug Verbosity",
    Desc = "Control how much telemetry data is retained",
    Default = "Medium",
    Values = {"Low", "Medium", "High"},
    Callback = function(val) 
        DiagnosticsSystem.debugVerbosity = val
        DiagnosticsSystem:Log("INFO", string.format("Debug verbosity set to %s", val), "Diagnostics")
    end
})


Tabs.PerformanceTab:Button({
    Title = "Clear Session Log",
    Desc = "Clear all stored log entries",
    Icon = "trash-2",
    Callback = function()
        DiagnosticsSystem:ClearSessionLog()
        WindUI:Notify({
            Title = "Session Log Cleared",
            Content = "All log entries have been removed",
            Icon = "trash-2",
            Duration = 2,
        })
    end
})

Tabs.PerformanceTab:Button({
    Title = "Export Session Log",
    Desc = "Save session log to file or clipboard",
    Icon = "download",
    Callback = function()
        DiagnosticsSystem:ExportSessionLog()
    end
})

-- =============== IMPROVED AIMBOT SYSTEM WITH SILENT AIM AND PREDICTION AI ===============
function GetClosestTarget()
    local shortest = math.huge
    local closest = nil
    local closestPos = nil
    
    if not LocalPlayer.Character then return end
    
    for _, player in ipairs(cachedPlayers) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                -- Check team first
                if not (SilentAimTeamCheck and LocalPlayer.Team and player.Team == LocalPlayer.Team) then
                    -- Check if player is visible (not behind walls) using cached results
                    if IsPlayerVisible(player) then
                        local targetPart = player.Character:FindFirstChild(SilentAimTarget)
                        if targetPart then
                            local pos = targetPart.Position
                            
                            -- Use prediction if enabled
                            if PredictionAIEnabled then
                                local predictedPos = PredictionAI:GetPredictedAimPosition(player)
                                if predictedPos then
                                    pos = predictedPos
                                end
                            end
                            
                            local screenPos, visible = Camera:WorldToViewportPoint(pos)
                            if visible and screenPos.Z > 0 then
                                local mouse = UserInputService:GetMouseLocation()
                                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                                if dist < shortest then
                                    shortest = dist
                                    closest = player
                                    closestPos = screenPos
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closest, closestPos
end

-- NEW: Get targets within FOV Circle
function GetTargetsInFOV()
    local targets = {}
    
    if not LocalPlayer.Character or not SilentAimFOVEnabled then return {} end
    
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in ipairs(cachedPlayers) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                -- Check team first
                if not (SilentAimTeamCheck and LocalPlayer.Team and player.Team == LocalPlayer.Team) then
                    -- Check if player is visible (not behind walls) using cached results
                    if IsPlayerVisible(player) then
                        local targetPart = player.Character:FindFirstChild(SilentAimTarget)
                        if targetPart then
                            local pos = targetPart.Position
                            
                            -- Use prediction if enabled
                            if PredictionAIEnabled then
                                local predictedPos = PredictionAI:GetPredictedAimPosition(player)
                                if predictedPos then
                                    pos = predictedPos
                                end
                            end
                            
                            local screenPos, visible = Camera:WorldToViewportPoint(pos)
                            if visible and screenPos.Z > 0 then
                                -- Check if player is within FOV circle
                                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                                if distance <= SilentAimFOVRadius then
                                    table.insert(targets, {player = player, screenPos = screenPos, distance = distance})
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Sort targets by distance (closest first)
    table.sort(targets, function(a, b)
        return a.distance < b.distance
    end)
    
    return targets
end

-- Select first tab by default
Window:SelectTab(1)

-- =============== PERSISTENCE SYSTEM ===============
-- Handle player respawning to maintain features
local function OnPlayerAdded(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            task.wait(1) -- Wait for character to fully load
            UpdateAllESP()
        end)
        
        -- Also handle when character is removed
        player.CharacterRemoving:Connect(function()
            ClearSkeletonESP(player)
            ClearHeadESP(player)
            ClearBoxESP(player)
            ClearCharmsESP(player)
            ClearTracersESP(player)
        end)
    end
end

local function OnLocalPlayerRespawned(character)
    task.wait(1) -- Wait for character to fully load
    
    -- Restart flight if it was enabled
    if FlightEnabled then
        task.wait(0.5)
        EnableFlight()
    end
    
    -- Refresh all features
    UpdateAllESP()
end

-- Connect persistence events
for _, player in ipairs(Players:GetPlayers()) do
    OnPlayerAdded(player)
end

Players.PlayerAdded:Connect(OnPlayerAdded)

Players.PlayerRemoving:Connect(function(player)
    -- Clean up ESP when player leaves
    if SkeletonESP[player] then ClearSkeletonESP(player) end
    if HeadESP[player] then ClearHeadESP(player) end
    if BoxESP[player] then ClearBoxESP(player) end
    if CharmsESP[player] then ClearCharmsESP(player) end
    if TracersESP[player] then ClearTracersESP(player) end
    
    -- Clear from caches
    cachedVisibilityResults[player] = nil
    cachedPlayerDistances[player] = nil
    
    -- Clear from prediction system
    if PredictionAI.playerData[player] then
        PredictionAI.playerData[player] = nil
    end
end)

if LocalPlayer then
    LocalPlayer.CharacterAdded:Connect(OnLocalPlayerRespawned)
end

-- =============== OPTIMIZED INPUT HANDLING ===============
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    -- Handle Silent Aim toggle key (FIXED)
    if SilentAimEnabled then
        local keyPressed = false
        
        -- Check for UserInputType (mouse buttons)
        if input.UserInputType == SilentAimKey then
            keyPressed = true
        -- Check for KeyCode (keyboard keys)
        elseif input.KeyCode == SilentAimKey then
            keyPressed = true
        end
        
        if keyPressed then
            SilentAimToggled = not SilentAimToggled
            
            DiagnosticsSystem:Log("INFO", 
                string.format("Silent Aim %s", SilentAimToggled and "activated" or "deactivated"), 
                "Aimbot"
            )
            
            WindUI:Notify({
                Title = SilentAimToggled and "Silent Aim ON" or "Silent Aim OFF",
                Content = SilentAimToggled and "Now tracking targets" or "Tracking stopped",
                Icon = SilentAimToggled and "crosshair" or "square",
                Duration = 2,
            })
        end
    end
    
    -- Handle UI toggle
    if input.KeyCode == Enum.KeyCode.F4 then
        Window:SetToggleKey(Enum.KeyCode.F4)
    end
    
    -- Handle F9 for debug overlay toggle
    if input.KeyCode == Enum.KeyCode.F9 then
        DiagnosticsSystem.showDebugOverlay = not DiagnosticsSystem.showDebugOverlay
        if DiagnosticsSystem.showDebugOverlay then
            if not DiagnosticsSystem.overlay then
                DiagnosticsSystem:CreateDebugOverlay()
            end
        else
            if not PredictionDebugOverlay then -- Only destroy if prediction debug is also off
                DiagnosticsSystem:DestroyOverlay()
            end
        end
        
        DiagnosticsSystem:Log("INFO", 
            string.format("Debug overlay %s via F9 hotkey", DiagnosticsSystem.showDebugOverlay and "enabled" or "disabled"), 
            "Diagnostics"
        )
    end
end)

-- =============== CONSOLIDATED MAIN UPDATE LOOP (PERFORMANCE OPTIMIZATION) ===============
local function StartMainUpdateLoop()
    if performanceUpdateConnection then
        performanceUpdateConnection:Disconnect()
    end
    
    MainUpdateConnection = RunService.Heartbeat:Connect(function(dt)
        -- Update performance metrics
        DiagnosticsSystem:UpdatePerformanceMetrics(dt)

        -- Increment tick counters
        mainTickCount = mainTickCount + 1
        espTickCount = espTickCount + 1
        visibilityTickCount = visibilityTickCount + 1

        -- Main updates (run at full frame rate)
        if IsEnabled then 
            UpdateHitboxes() 
        end
        
        if SilentAimFOVEnabled then
            UpdateSilentAimFOVCircle()
        end
        
        if KillAuraEnabled then
            UpdateKillAuraCircle()
        end
        
        -- ESP updates (run at reduced frame rate for performance)
        if espTickCount >= (60 / ESP_TICK_RATE) then
            espTickCount = 0
            
            if SkeletonESPEnabled then UpdateSkeletonESP() end
            if HeadESPEnabled then UpdateHeadESP() end
            if BoxESPEnabled then UpdateBoxESP() end
            if TracersEnabled then UpdateTracersESP() end
            
            -- Update ESP creation/removal for new players or respawns
            UpdateAllESP()
            
            -- Log ESP performance metrics
            if DiagnosticsSystem.debugVerbosity == "High" then
                DiagnosticsSystem:Log("DEBUG", 
                    string.format("ESP Update - Players: %d, Distance Culled: %d", 
                        #cachedPlayers, 
                        #cachedPlayers - (Object.keys(SkeletonESP).length or 0)
                    ), 
                    "Performance"
                )
            end
        end
        
        -- Visibility checks (run at even lower frame rate)
        if visibilityTickCount >= (60 / VISIBILITY_TICK_RATE) then
            visibilityTickCount = 0
            UpdateRotationalVisibility()
        end
        
        -- TOGGLE-BASED Silent Aim Implementation with Prediction AI Integration
        if SilentAimEnabled and SilentAimToggled and LocalPlayer.Character then
            local target, targetScreenPos
            
            if SilentAimFOVEnabled then
                -- Use FOV circle targeting system
                local targetsInFOV = GetTargetsInFOV()
                if #targetsInFOV > 0 then
                    -- Get the closest target within FOV circle
                    target = targetsInFOV[1].player
                    targetScreenPos = targetsInFOV[1].screenPos
                end
            else
                -- Use original closest target system
                target, targetScreenPos = GetClosestTarget()
            end
            
            if target and targetScreenPos then
                local currentMouse = UserInputService:GetMouseLocation()
                local targetMouse = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                
                -- Apply prediction if enabled
                if PredictionAIEnabled then
                    local predictedPos = PredictionAI:GetPredictedAimPosition(target)
                    if predictedPos then
                        -- Convert predicted world position to screen position
                        local predScreenPos, visible = Camera:WorldToViewportPoint(predictedPos)
                        if visible and predScreenPos.Z > 0 then
                            -- Blend predicted position with actual position
                            local blendFactor = PredictionProbability / 100
                            targetMouse = Vector2.new(
                                predScreenPos.X * blendFactor + targetScreenPos.X * (1 - blendFactor),
                                predScreenPos.Y * blendFactor + targetScreenPos.Y * (1 - blendFactor)
                            )
                            
                            DiagnosticsSystem:Log("DEBUG", 
                                string.format("Applied prediction blend (%.0f%%) to target %s", PredictionProbability, target.Name), 
                                "Aimbot"
                            )
                        end
                    end
                end
                
                -- Calculate smooth movement delta
                local deltaX = (targetMouse.X - currentMouse.X) * (SilentAimSmoothness / 100)
                local deltaY = (targetMouse.Y - currentMouse.Y) * (SilentAimSmoothness / 100)
                
                -- Try multiple methods for mouse movement
                local success = false
                
                -- Method 1: Try mousemoverel if it exists
                if getgenv and getgenv().mousemoverel then
                    success = pcall(function()
                        getgenv().mousemoverel(deltaX, deltaY)
                    end)
                elseif mousemoverel then
                    success = pcall(function()
                        mousemoverel(deltaX, deltaY)
                    end)
                end
                
                -- Method 2: Try mouse1move if available
                if not success and mouse1move then
                    success = pcall(function()
                        mouse1move(targetMouse.X, targetMouse.Y)
                    end)
                end
                
                -- Method 3: Try direct mouse object manipulation if available
                if not success and getgenv and getgenv().mouse then
                    success = pcall(function()
                        local mouse = getgenv().mouse
                        mouse.X = currentMouse.X + deltaX
                        mouse.Y = currentMouse.Y + deltaY
                    end)
                end
                
                -- Method 4: Virtual input simulation (if supported by executor)
                if not success then
                    -- This method uses virtual input if the executor supports it
                    local virtualInput = game:GetService("VirtualInputManager")
                    if virtualInput then
                        pcall(function()
                            virtualInput:SendMouseMoveEvent(targetMouse.X, targetMouse.Y, game)
                        end)
                    end
                end
                
                -- Auto-kill functionality
                -- if success then
                    -- task.spawn(function()
                        -- task.wait(SilentAimAutoKillDelay)
                        -- if SilentAimToggled and target and target.Character then
                            -- PerformKillOnPlayer(target)
                            -- DiagnosticsSystem:Log("INFO", 
                                -- string.format("Auto-killed target: %s", target.Name), 
                                -- "Aimbot"
                            -- )
                        -- end
                    -- end)
                --end
            end
        end
        
        -- Update performance stats periodically
        if mainTickCount % 60 == 0 then -- Every second
            performanceStats.mainFPS = DiagnosticsSystem.currentFPS
            performanceStats.espFPS = ESP_TICK_RATE
            performanceStats.playersRendered = #cachedPlayers
            performanceStats.pooledObjects = #LinePool + #CirclePool + #QuadPool
            performanceStats.frameTime = DiagnosticsSystem.frameTime
            
            -- Update performance paragraph if it exists
            if performanceParagraph then
                local statsText = string.format(
                    "FPS: %d | Frame Time: %.2f ms\nESP FPS: %d | Players Rendered: %d\nPooled Objects: %d | CPU Load: %d%%",
                    DiagnosticsSystem.currentFPS,
                    DiagnosticsSystem.frameTime,
                    ESP_TICK_RATE,
                    #cachedPlayers,
                    #LinePool + #CirclePool + #QuadPool,
                    DiagnosticsSystem.cpuLoad
                )
                
                -- Update paragraph (this would need to be implemented based on WindUI's API)
                pcall(function()
                    -- performanceParagraph:UpdateDesc(statsText)
                end)
            end
        end
        
        -- Update diagnostic overlay if enabled
        if DiagnosticsSystem.showDebugOverlay or PredictionDebugOverlay then
            DiagnosticsSystem:UpdateOverlay()
        end
    end)
end

-- Start the main update loop
StartMainUpdateLoop()

-- =============== CLEANUP ON SCRIPT UNLOAD ===============
game:BindToClose(function()
    DiagnosticsSystem:Log("INFO", "Script unloading - performing cleanup", "System")
    
    -- Clean up ESP elements
    ClearSkeletonESP()
    ClearHeadESP()
    ClearBoxESP()
    ClearCharmsESP()
    ClearTracersESP()
    
    -- Remove FOV Circles
    RemoveSilentAimFOVCircle()
    
    -- Remove Kill Aura Circle
    RemoveKillAuraCircle()
    
    -- Clear object pools
    for _, line in ipairs(LinePool) do
        if line then pcall(function() line:Remove() end) end
    end
    for _, circle in ipairs(CirclePool) do
        if circle then pcall(function() circle:Remove() end) end
    end
    for _, quad in ipairs(QuadPool) do
        if quad then pcall(function() quad:Remove() end) end
    end
    
    -- Stop connections
    if MainUpdateConnection then
        MainUpdateConnection:Disconnect()
    end
    
    -- Stop auto kill
    StopAutoKill()
    
    -- Stop auto shoot
    StopAutoShoot()
    
    -- Stop kill aura
    StopKillAura()
    
    -- Disable flight
    if FlightEnabled then
        DisableFlight()
    end
    
    -- Reset hitboxes
    ResetHitboxes()
    
    -- Destroy diagnostics overlay
    DiagnosticsSystem:DestroyOverlay()
    
    -- Final cleanup log
    DiagnosticsSystem:Log("INFO", "Cleanup completed successfully", "System")
end)

-- =============== INITIALIZATION ===============
-- Set the toggle key
Window:SetToggleKey(Enum.KeyCode.F4)

-- Initial setup
task.spawn(function()
    task.wait(2) -- Wait for everything to load
    
    DiagnosticsSystem:Log("INFO", "Initializing system components", "System")
    
    UpdatePlayerCache()
    UpdateAllESP()
    
    -- Create FOV Circle if enabled
    if SilentAimFOVEnabled then
        CreateSilentAimFOVCircle()
    end
    
    -- Start performance monitoring
    DiagnosticsSystem:Log("INFO", 
        string.format("Performance monitoring started - Sampling rate: %.1fs", DiagnosticsSystem.samplingRate), 
        "Performance"
    )
    
    DiagnosticsSystem:Log("INFO", "All systems initialized successfully", "System")
end)

-- Success notification
WindUI:Notify({
    Title = "Ez-Win V3 Performance Loaded!",
    Content = "Press F4 to toggle UI, F9 for debug overlay. Enjoy responsibly!",
    Icon = "check",
    Duration = 5,
})

-- Performance debugging
DiagnosticsSystem:Log("INFO", "=== PERFORMANCE DEBUG INFO ===", "System")
DiagnosticsSystem:Log("INFO", string.format("Main Tick Rate: %d FPS", MAIN_TICK_RATE), "Performance")
DiagnosticsSystem:Log("INFO", string.format("ESP Tick Rate: %d FPS", ESP_TICK_RATE), "Performance")
DiagnosticsSystem:Log("INFO", string.format("Visibility Tick Rate: %d FPS", VISIBILITY_TICK_RATE), "Performance")
DiagnosticsSystem:Log("INFO", string.format("Max ESP Distance: %d studs", MAX_ESP_DISTANCE), "Performance")
DiagnosticsSystem:Log("INFO", string.format("LOD Distance: %d studs", LOD_DISTANCE), "Performance")
DiagnosticsSystem:Log("INFO", 
    string.format("Object Pools Initialized - Lines: %d, Circles: %d, Quads: %d", 
        #LinePool, #CirclePool, #QuadPool), 
    "Performance"
)
DiagnosticsSystem:Log("INFO", 
    string.format("Executor: %s (%s) - Detection timestamp: %s", 
        DETECTED_EXECUTOR, IS_EXECUTOR_SUPPORTED and "Supported" or "Unsupported", DETECTION_TIMESTAMP), 
    "System"
)

-- Final compatibility warning
DiagnosticsSystem:Log("WARNING", 
    "THIS SYSTEM IS FOR COMPATIBILITY, DIAGNOSTICS, AND TESTING ONLY. " ..
    "MUST NOT BE USED TO CIRCUMVENT ANTI-CHEAT SYSTEMS. " ..
    "Use responsibly and follow game rules and terms of service.", 
    "System"
)

print("--- Ez-Win V3 ---")
print("Performance optimizations: Active")
print("Diagnostics system: Ready")
print("All systems: Operational")
print("Press F4 to toggle UI, F9 to toggle debug overlay")
print("--- System Ready ---")
