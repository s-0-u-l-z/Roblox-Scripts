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
if _G.s0ulzV4Loaded then
    warn("s0ulz V4 is already running!")
    return
end
_G.s0ulzV4Loaded = true

local player = Services.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- theme colors
local theme = {
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
}

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
    isMinimized = false
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
    chatDelay = 1,
    followTarget = nil,
    fakeLagWaitTime = 0.05,
    fakeLagDelayTime = 0.4
}

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
    Connection = nil,
    currentTarget = nil
}

local triggerbotSettings = {
    Enabled = false,
    delay = 0.1,
    range = 300,
    running = false
}

local hitboxSettings = {originalSizes = {}, expansionAmount = 1.5}
local inputFlags = {forward = false, back = false, left = false, right = false, up = false, down = false}
local scriptEnv = {FPDH = Services.Workspace.FallenPartsDestroyHeight, OldPos = nil}
local connections = {}
local drawnIcons = {}

-- game database
local gameDatabase = {
    {id = 286090429, name = "Arsenal", desc = "Fast-paced FPS", url = "https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Games/Arsenal/Arsenal(s0ulz).lua"},
    {id = 7326934954, name = "99 Nights", desc = "Survival horror", url = "https://pastefy.app/RXzul28o/raw"},
    {id = 4777817887, name = "Blade Ball", desc = "Dodge & deflect", url = "http://lumin-hub.lol/Blade.lua"},
    {id = 4348829796, name = "MVSD", desc = "Murder mystery", url = "https://raw.githubusercontent.com/s-0-u-l-z/Roblox-Scripts/refs/heads/main/Games/MVSD/EZ.lua"},
    {id = 4931927012, name = "Basketball Legends", desc = "Arcade hoops", url = "https://raw.githubusercontent.com/vnausea/absence-mini/refs/heads/main/absencemini.lua"},
    {id = 66654135, name = "MM2", desc = "Classic mystery", url = "https://raw.githubusercontent.com/vertex-peak/vertex/refs/heads/main/loadstring"},
    {id = 3508322461, name = "Jujitsu Shenanigans", desc = "Anime combat", url = "https://raw.githubusercontent.com/NotEnoughJack/localplayerscripts/refs/heads/main/script"},
    {id = 372226183, name = "Flee the Facility", desc = "Hide & seek", url = "https://raw.githubusercontent.com/PabloOP-87/pedorga/refs/heads/main/Flee-Da-Facility"},
    {id = 3808081382, name = "TSB", desc = "Hero battles", url = "https://raw.githubusercontent.com/ATrainz/Phantasm/refs/heads/main/Games/TSB.lua"},
    {id = 5203828273, name = "DTI", desc = "Fashion show", url = "https://raw.githubusercontent.com/hellohellohell012321/DTI-GUI-V2/main/dti_gui_v2.lua"},
    {id = 6931042565, name = "Volleyball", desc = "Competitive", url = "https://raw.githubusercontent.com/scriptshubzeck/Zeckhubv1/refs/heads/main/zeckhub"},
    {id = 7436755782, name = "Garden", desc = "Relaxing sim", url = "https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/GaG/Main.lua"},
    {id = 6035872082, name = "RIVALS", desc = "Tactical FPS", url = "https://soluna-script.vercel.app/main.lua"},
    {id = 47545, name = "Pizza Place", desc = "Work roleplay", url = "https://raw.githubusercontent.com/Hm5011/hussain/refs/heads/main/Work%20at%20a%20pizza%20place"},
    {id = 1268927906, name = "Muscle Legends", desc = "Training sim", url = "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"}
}

-- utilities
local function notify(title, text, duration)
    pcall(function()
        Services.StarterGui:SetCore("SendNotification", {
            Title = title or "s0ulz V4",
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
               
                if not highlight or not billboard or not tracerLine then
                    createPlayerESP(targetPlayer)
                else
                    highlight.Enabled = espSettings.Enabled and inRange
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
                   
                    if espSettings.Tracers and espSettings.Enabled and inRange then
                        local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                        if onScreen and screenPos.Z > 0 then
                            tracerLine.Visible = true
                            tracerLine.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                            tracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
                            if targetPlayer.Team and player.Team and targetPlayer.Team == player.Team then
                                tracerLine.Color = Color3.new(0, 1, 0)
                            else
                                tracerLine.Color = Color3.new(1, 0, 0)
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

local function setupESP()
    clearAllESP()
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
    
    Services.Players.PlayerAdded:Connect(function(newPlayer)
        if newPlayer ~= player then
            task.spawn(function()
                newPlayer.CharacterAdded:Wait()
                if espSettings.Enabled then createPlayerESP(newPlayer) end
            end)
        end
    end)
    
    Services.Players.PlayerRemoving:Connect(removePlayerESP)
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

-- troll features
local function chatSpammerLoop()
    while states.chatSpammer and Services.RunService.Heartbeat:Wait() do
        local text = trollSettings.chatText
        if text ~= "" then
            pcall(function()
                if Services.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") then
                    local chatEvents = Services.ReplicatedStorage.DefaultChatSystemChatEvents
                    if chatEvents:FindFirstChild("SayMessageRequest") then
                        chatEvents.SayMessageRequest:FireServer(text, "All")
                    end
                elseif game:GetService("TextChatService") then
                    local textChatService = game:GetService("TextChatService")
                    if textChatService.ChatInputBarConfiguration then
                        textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(text)
                    end
                end
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

-- fling
local function SkidFling(TargetPlayer)
    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    if not (Character and Humanoid and RootPart) then return end
    if RootPart.Velocity.Magnitude < 50 then scriptEnv.OldPos = RootPart.CFrame end
    
    Services.Workspace.FallenPartsDestroyHeight = 0/0
    local BV = Instance.new("BodyVelocity")
    BV.Name = "EpixVel"
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    
    task.wait(0.2)
    if BV then BV:Destroy() end
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    Services.Workspace.FallenPartsDestroyHeight = scriptEnv.FPDH
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
gui.screen.Name = "s0ulzV4Glass"
gui.screen.Parent = playerGui
gui.screen.ResetOnSpawn = false
gui.screen.IgnoreGuiInset = true
gui.screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.screen.DisplayOrder = 999999

-- this shit was harder than it should've been lol
gui.main = Instance.new("Frame")
gui.main.Name = "MainContainer"
gui.main.Parent = gui.screen
gui.main.BackgroundColor3 = theme.glass
gui.main.BackgroundTransparency = 0.15
gui.main.BorderSizePixel = 0
gui.main.AnchorPoint = Vector2.new(0.5, 0.5)
gui.main.Position = UDim2.new(0.5, 0, 0.5, 0)
gui.main.Size = UDim2.new(0, 800, 0, 500)
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

-- dragging (okay this alignment took way too long)
local dragToggle, dragStart, startPos = nil, nil, nil
local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    tween(gui.main, 0.25, {Position = position}):Play()
end

gui.main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true
        dragStart = input.Position
        startPos = gui.main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)

Services.UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
        updateInput(input)
    end
end)

-- top bar
gui.topBar = Instance.new("Frame")
gui.topBar.Name = "TopBar"
gui.topBar.Parent = gui.main
gui.topBar.BackgroundColor3 = theme.surface
gui.topBar.BackgroundTransparency = 0.3
gui.topBar.BorderSizePixel = 0
gui.topBar.Size = UDim2.new(1, 0, 0, 50)
gui.topBar.ZIndex = 2

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 12)
topBarCorner.Parent = gui.topBar

local topBarMask = Instance.new("Frame")
topBarMask.Parent = gui.topBar
topBarMask.BackgroundColor3 = theme.surface
topBarMask.BackgroundTransparency = 0.3
topBarMask.BorderSizePixel = 0
topBarMask.Position = UDim2.new(0, 0, 0.6, 0)
topBarMask.Size = UDim2.new(1, 0, 0.4, 0)
topBarMask.ZIndex = 2

local titleText = Instance.new("TextLabel")
titleText.Parent = gui.topBar
titleText.BackgroundTransparency = 1
titleText.Position = UDim2.new(0, 20, 0, 0)
titleText.Size = UDim2.new(0, 200, 1, 0)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "s0ulz V4"
titleText.TextColor3 = theme.text
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.ZIndex = 3

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

-- control buttons
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

gui.minimizeBtn = createControlBtn("_", UDim2.new(1, -70, 0.5, -15), theme.surface)
gui.closeBtn = createControlBtn("×", UDim2.new(1, -20, 0.5, -15), theme.surface)

-- sidebar
gui.sidebar = Instance.new("Frame")
gui.sidebar.Name = "Sidebar"
gui.sidebar.Parent = gui.main
gui.sidebar.BackgroundColor3 = theme.surface
gui.sidebar.BackgroundTransparency = 0.4
gui.sidebar.BorderSizePixel = 0
gui.sidebar.Position = UDim2.new(0, 0, 0, 50)
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
    {name = "Combat", iconId = "rbxassetid://98186551294424", category = true, subcategories = {"Hitbox", "Aim", "Triggerbot"}},
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
    local icon = drawIcon(tab.iconType, iconFrame, Vector2.new(0, 0), 20)
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
                else
                    tween(arrow, 0.2, {Rotation = -90}):Play()
                    tween(subContainer, 0.2, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    task.wait(0.2)
                    if not expandedCategories[tab.name] then subContainer.Visible = false end
                end
            end
        end)
    end
end

-- update icon positions with gui
Services.RunService.RenderStepped:Connect(function()
    for _, data in pairs(tabButtons) do
        if data.iconFrame and data.icon then
            local iconPos = data.iconFrame.AbsolutePosition
            data.icon:UpdatePosition(Vector2.new(iconPos.X, iconPos.Y))
        end
    end
end)

-- content area
gui.content = Instance.new("Frame")
gui.content.Name = "ContentArea"
gui.content.Parent = gui.main
gui.content.BackgroundTransparency = 1
gui.content.Position = UDim2.new(0, 200, 0, 50)
gui.content.Size = UDim2.new(1, -200, 1, -50)
gui.content.ZIndex = 2

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
    frame.Visible = (tabName == "Main")
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = theme.accent
    frame.ScrollBarImageTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.ZIndex = 2
    
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
    
    local valueBox = Instance.new("TextLabel")
    valueBox.Parent = card
    valueBox.BackgroundTransparency = 1
    valueBox.Position = UDim2.new(1, -70, 0, 0)
    valueBox.Size = UDim2.new(0, 70, 0, 20)
    valueBox.Font = Enum.Font.RobotoMono
    valueBox.Text = tostring(currentVal)
    valueBox.TextColor3 = theme.text
    valueBox.TextSize = 13
    valueBox.TextXAlignment = Enum.TextXAlignment.Right
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
    
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            tween(thumb, 0.1, {Size = UDim2.new(0, 20, 0, 20)}):Play()
            tween(thumbGlow, 0.1, {Transparency = 0.2}):Play()
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = Services.UserInputService:GetMouseLocation()
            local trackPos = track.AbsolutePosition
            local relativeX = math.clamp((mousePos.X - trackPos.X) / track.AbsoluteSize.X, 0, 1)
            updateSlider(minVal + (maxVal - minVal) * relativeX)
        end
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
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
    local card = createCard(parent, layoutOrder)
    card.Size = UDim2.new(1, 0, 0, 50)
    
    local input = Instance.new("TextBox")
    input.Parent = card
    input.BackgroundColor3 = theme.bg
    input.BackgroundTransparency = 0.3
    input.BorderSizePixel = 0
    input.Size = UDim2.new(1, 0, 1, 0)
    input.Font = Enum.Font.Gotham
    input.PlaceholderText = placeholder
    input.PlaceholderColor3 = theme.textDim
    input.Text = ""
    input.TextColor3 = theme.text
    input.TextSize = 12
    input.ClearTextOnFocus = false
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.ZIndex = 3
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = input
    
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
createSlider(contentFrames.Troll, "Chat Delay", "Time between messages", 0.1, 5, trollSettings.chatDelay,
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
    local targets = findPlayer(flingInput.Text)
    for _, target in ipairs(targets) do SkidFling(target) end
end, 10)
createButton(contentFrames.Troll, "Fling Everyone", function()
    for _, otherPlayer in ipairs(Services.Players:GetPlayers()) do
        if otherPlayer ~= player then SkidFling(otherPlayer) end
    end
end, 11, theme.error)
createToggle(contentFrames.Troll, "Touch Fling", "Fling on touch", function(state) 
    states.touchFling = state
    if state then
        connections.touchFlingThread = task.spawn(touchFlingLoop)
    else
        if connections.touchFlingThread then task.cancel(connections.touchFlingThread) end
    end
end, 12)

-- hitbox
createToggle(contentFrames.Hitbox, "Enable Hitbox", "Expand hitboxes", function(state) 
    states.hitboxExpander = state
    expandHitBoxes(state)
end, 1)
createSlider(contentFrames.Hitbox, "Hitbox Size", "Expansion amount", 1, 10, hitboxSettings.expansionAmount,
    function(val) hitboxSettings.expansionAmount = val; if states.hitboxExpander then expandHitBoxes(true) end end, 2)

-- aim
createToggle(contentFrames.Aim, "Aimbot", "Auto-aim", function(state) 
    aimbotSettings.Enabled = state
    if state then startAimbot() else stopAimbot() end
end, 1)
createSlider(contentFrames.Aim, "Smoothing", "Aim smoothness", 0, 1, aimbotSettings.Smoothing,
    function(val) aimbotSettings.Smoothing = val end, 2)

-- cooldown (triggerbot)
createToggle(contentFrames.Cooldown, "Triggerbot", "Auto-fire", function(state) 
    triggerbotSettings.Enabled = state
    if state then startTriggerBot() else stopTriggerBot() end
end, 1)
createSlider(contentFrames.Cooldown, "Delay", "Fire delay", 0, 1, triggerbotSettings.delay,
    function(val) triggerbotSettings.delay = val end, 2)
createSlider(contentFrames.Cooldown, "Range", "Max distance", 50, 1000, triggerbotSettings.range,
    function(val) triggerbotSettings.range = val end, 3)

-- esp
createToggle(contentFrames.ESP, "ESP", "See through walls", function(state) 
    espSettings.Enabled = state
    if state then setupESP() else clearAllESP() end
end, 1)

-- tracers
createToggle(contentFrames.Tracers, "Tracers", "Draw lines", function(state) 
    espSettings.Tracers = state
    if not state then
        for _, line in pairs(espSettings.TracerLines) do
            if line then line.Visible = false end
        end
    end
end, 1)

-- scripts
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

-- games
local searchBar = createInput(contentFrames.Games, "Search games...", 1)
for i, game in ipairs(gameDatabase) do
    local gameCard = createCard(contentFrames.Games, i + 1)
    gameCard.Size = UDim2.new(1, 0, 0, 80)
    
    local gameName = Instance.new("TextLabel")
    gameName.Parent = gameCard
    gameName.BackgroundTransparency = 1
    gameName.Size = UDim2.new(1, -120, 0, 22)
    gameName.Font = Enum.Font.GothamBold
    gameName.Text = game.name
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
    gameDesc.Text = game.desc
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
        loadstring(game:HttpGet(game.url))()
        notify("Games", game.name .. " loaded!", 3)
    end)
end

-- utility
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
createToggle(contentFrames.Utility, "Invincible", "God mode", function(state) 
    states.invincible = state
    if state then enableInvincibility() else disableInvincibility() end
end, 5)

-- tab switching
local function switchTab(tabName)
    if config.currentTab == tabName then return end
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
        currentFrame.Visible = false
        newFrame.Visible = true
        config.currentTab = tabName
    end
end

for name, data in pairs(tabButtons) do
    data.button.MouseButton1Click:Connect(function() switchTab(name) end)
end

switchTab("Main")

-- control buttons
gui.minimizeBtn.MouseButton1Click:Connect(function()
    config.isMinimized = not config.isMinimized
    if config.isMinimized then
        tween(gui.main, 0.3, {Size = UDim2.new(0, 800, 0, 50)}):Play()
    else
        tween(gui.main, 0.3, {Size = UDim2.new(0, 800, 0, 500)}):Play()
    end
end)

gui.closeBtn.MouseButton1Click:Connect(function()
    tween(gui.main, 0.3, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    for _, icon in ipairs(drawnIcons) do icon:Destroy() end
    gui.screen:Destroy()
    _G.s0ulzV4Loaded = nil
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
    elseif key == Enum.KeyCode.F then toggleFlightState()
    elseif key == Enum.KeyCode.F4 then gui.screen.Enabled = not gui.screen.Enabled end
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
    if states.hitboxExpander then expandHitBoxes(true) end
    if espSettings.Enabled then setupESP() end
end)

-- core loops
Services.RunService.Heartbeat:Connect(applyCharacterSettings)
Services.RunService.RenderStepped:Connect(function()
    if espSettings.Enabled and gui.screen.Enabled then updatePlayerESP() end
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
    if states.hitboxExpander then expandHitBoxes(false) end
    if aimbotSettings.Connection then aimbotSettings.Connection:Disconnect() end
    Services.Workspace.FallenPartsDestroyHeight = scriptEnv.FPDH
    _G.s0ulzV4Loaded = nil
end)

-- init
applyCharacterSettings()
gui.screen.Enabled = true
gui.main.Size = UDim2.new(0, 0, 0, 0)
tween(gui.main, 0.5, {Size = UDim2.new(0, 800, 0, 500)}):Play()

task.wait(0.8)
notify("s0ulz V4", "Loaded successfully!", 5)
task.wait(0.4)
notify("Controls", "F4 = Toggle GUI | F = Fly", 4)


print("--================================--")
print("     Made With Love <3 - s0ulz")
print("--================================--")
