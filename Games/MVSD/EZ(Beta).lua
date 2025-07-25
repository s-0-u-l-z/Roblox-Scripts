-- MVSD Exo Script with Rayfield UI (SiriusSoftware Ltd branch)
repeat task.wait() until game:IsLoaded()

-- SAFE RAYFIELD LOADING
local Rayfield
local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/source.lua", true))
end)

if not success or typeof(result) ~= "function" then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Rayfield Error",
        Text = "Executor does not support loadstring.",
        Duration = 6
    })
    return
end

Rayfield = result()

-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- UI
local Window = Rayfield:CreateWindow({
    Name = "Ezzzzz MVSD",
    LoadingTitle = "Loading Ezz...",
    LoadingSubtitle = "Ezzzzzzz win",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- =============== SETTINGS ===============
local HeadSize = 20
local Transparency = 0.7
local HitboxColor = Color3.fromRGB(0, 255, 0)
local IsEnabled = false
local TeamCheck = false
local FlightEnabled = false
local NoKnifeCooldown = false
local NoGunCooldown = false
local FlightSpeed = 50
local FlightConnections = {}

-- ESP Settings
local SkeletonESPEnabled = false
local HeadESPEnabled = false
local BoxESPEnabled = false
local ESPColor = Color3.fromRGB(0, 255, 255)
local ESPTeamCheck = false

-- Soft Aim Settings
local SoftAimEnabled = false
local SoftAimKey = Enum.UserInputType.MouseButton2
local Smoothness = 0.15
local SoftAimTeamCheck = false
local SoftAimRange = 1000

-- =============== HITBOX TAB ===============
local HitboxTab = Window:CreateTab("Hitbox", 4483362458)

HitboxTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {1, 50},
    Increment = 1,
    CurrentValue = HeadSize,
    Callback = function(val) HeadSize = val end
})

HitboxTab:CreateSlider({
    Name = "Transparency",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = Transparency * 100,
    Callback = function(val) Transparency = val / 100 end
})

HitboxTab:CreateToggle({
    Name = "Enable Hitbox",
    CurrentValue = false,
    Callback = function(val) IsEnabled = val end
})

HitboxTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(val) TeamCheck = val end
})

HitboxTab:CreateColorPicker({
    Name = "Hitbox Color",
    Color = HitboxColor,
    Callback = function(color) HitboxColor = color end
})

-- =============== AIM TAB ===============
local AimTab = Window:CreateTab("Aim", 4483362458)

AimTab:CreateToggle({
    Name = "Soft Aim",
    CurrentValue = false,
    Callback = function(val) SoftAimEnabled = val end
})

AimTab:CreateSlider({
    Name = "Smoothness",
    Range = {0.05, 1},
    Increment = 0.05,
    CurrentValue = Smoothness,
    Callback = function(val) Smoothness = val end
})

AimTab:CreateSlider({
    Name = "Max Distance",
    Range = {100, 2000},
    Increment = 50,
    CurrentValue = SoftAimRange,
    Callback = function(val) SoftAimRange = val end
})

AimTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(val) SoftAimTeamCheck = val end
})

AimTab:CreateKeybind({
    Name = "Aim Key",
    CurrentKeybind = "RightMouseButton",
    HoldToInteract = true,
    Callback = function(key) 
        if key == "MouseButton2" then
            SoftAimKey = Enum.UserInputType.MouseButton2
        elseif key == "LeftAlt" then
            SoftAimKey = Enum.KeyCode.LeftAlt
        elseif key == "LeftControl" then
            SoftAimKey = Enum.KeyCode.LeftControl
        end
    end
})

-- =============== ESP TAB ===============
local ESPTab = Window:CreateTab("ESP", 4483362458)

ESPTab:CreateToggle({
    Name = "Skeleton ESP",
    CurrentValue = false,
    Callback = function(val) 
        SkeletonESPEnabled = val 
        if not val then ClearSkeletonESP() end
    end
})

ESPTab:CreateToggle({
    Name = "Head ESP",
    CurrentValue = false,
    Callback = function(val) 
        HeadESPEnabled = val 
        if not val then ClearHeadESP() end
    end
})

ESPTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Callback = function(val) 
        BoxESPEnabled = val 
        if not val then ClearBoxESP() end
    end
})

ESPTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(val) ESPTeamCheck = val end
})

ESPTab:CreateColorPicker({
    Name = "ESP Color",
    Color = ESPColor,
    Callback = function(color) 
        ESPColor = color 
        UpdateAllESP()
    end
})

-- =============== COOLDOWN TAB ===============
local CoolTab = Window:CreateTab("Cooldown", 4483362458)

CoolTab:CreateToggle({
    Name = "No Knife Cooldown",
    CurrentValue = false,
    Callback = function(val) NoKnifeCooldown = val end
})

CoolTab:CreateToggle({
    Name = "No Gun Cooldown",
    CurrentValue = false,
    Callback = function(val) NoGunCooldown = val end
})

-- =============== EXTRA TAB ===============
local ExtraTab = Window:CreateTab("Extra", 4483362458)

ExtraTab:CreateToggle({
    Name = "Flight",
    CurrentValue = false,
    Callback = function(val) 
        FlightEnabled = val
        if FlightEnabled then
            EnableFlight()
        else
            DisableFlight()
        end
    end
})

ExtraTab:CreateSlider({
    Name = "Flight Speed",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = FlightSpeed,
    Callback = function(val) FlightSpeed = val end
})

-- =============== FLIGHT SYSTEM ===============
local function EnableFlight()
    if not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    humanoid.PlatformStand = true
    
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Parent = root
    
    local flyConnection
    flyConnection = RunService.Heartbeat:Connect(function()
        if not FlightEnabled or not LocalPlayer.Character or not root.Parent then
            bodyVelocity:Destroy()
            flyConnection:Disconnect()
            humanoid.PlatformStand = false
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
            bodyVelocity.Velocity = moveVec.Unit * FlightSpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    table.insert(FlightConnections, flyConnection)
end

local function DisableFlight()
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
    
    for _, conn in ipairs(FlightConnections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    FlightConnections = {}
end

-- =============== HITBOX LOGIC ===============
local function UpdateHitboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if TeamCheck and player.Team == LocalPlayer.Team then
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 0
                    root.Color = Color3.fromRGB(255, 255, 255)
                    root.Material = Enum.Material.Plastic
                    root.CanCollide = true
                else
                    root.Size = Vector3.new(HeadSize, HeadSize, HeadSize)
                    root.Transparency = Transparency
                    root.Color = HitboxColor
                    root.Material = Enum.Material.Neon
                    root.CanCollide = false
                end
            end
        end
    end
end

local function ResetHitboxes()
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

-- =============== SOFT AIM ===============
local function GetClosestTarget()
    local shortest = math.huge
    local closest = nil
    local closestPos = nil
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local pos = player.Character.HumanoidRootPart.Position
                local distance = (pos - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                
                if distance <= SoftAimRange then
                    if not (SoftAimTeamCheck and player.Team == LocalPlayer.Team) then
                        local screenPos, visible = Camera:WorldToViewportPoint(pos)
                        if visible then
                            local mouse = UserInputService:GetMouseLocation()
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                            if dist < shortest then
                                shortest = dist
                                closest = player
                                closestPos = pos
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closest, closestPos
end

-- =============== ESP SYSTEMS ===============
local SkeletonESP = {}
local HeadESP = {}
local BoxESP = {}

-- Skeleton ESP
local function CreateSkeletonESP(player)
    if SkeletonESP[player] then return end
    
    local connections = {}
    local char = player.Character
    if not char then return end
    
    local parts = {
        Head = char:FindFirstChild("Head"),
        UpperTorso = char:FindFirstChild("UpperTorso"),
        LowerTorso = char:FindFirstChild("LowerTorso"),
        LeftUpperArm = char:FindFirstChild("LeftUpperArm"),
        LeftLowerArm = char:FindFirstChild("LeftLowerArm"),
        LeftHand = char:FindFirstChild("LeftHand"),
        RightUpperArm = char:FindFirstChild("RightUpperArm"),
        RightLowerArm = char:FindFirstChild("RightLowerArm"),
        RightHand = char:FindFirstChild("RightHand"),
        LeftUpperLeg = char:FindFirstChild("LeftUpperLeg"),
        LeftLowerLeg = char:FindFirstChild("LeftLowerLeg"),
        LeftFoot = char:FindFirstChild("LeftFoot"),
        RightUpperLeg = char:FindFirstChild("RightUpperLeg"),
        RightLowerLeg = char:FindFirstChild("RightLowerLeg"),
        RightFoot = char:FindFirstChild("RightFoot")
    }
    
    if not parts.Head or not parts.UpperTorso then return end
    
    local boneConnections = {
        {parts.Head, parts.UpperTorso},
        {parts.UpperTorso, parts.LowerTorso},
        {parts.UpperTorso, parts.LeftUpperArm},
        {parts.LeftUpperArm, parts.LeftLowerArm},
        {parts.LeftLowerArm, parts.LeftHand},
        {parts.UpperTorso, parts.RightUpperArm},
        {parts.RightUpperArm, parts.RightLowerArm},
        {parts.RightLowerArm, parts.RightHand},
        {parts.LowerTorso, parts.LeftUpperLeg},
        {parts.LeftUpperLeg, parts.LeftLowerLeg},
        {parts.LeftLowerLeg, parts.LeftFoot},
        {parts.LowerTorso, parts.RightUpperLeg},
        {parts.RightUpperLeg, parts.RightLowerLeg},
        {parts.RightLowerLeg, parts.RightFoot}
    }
    
    for _, connection in ipairs(boneConnections) do
        local part1, part2 = connection[1], connection[2]
        if part1 and part2 then
            local line = Drawing.new("Line")
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

local function UpdateSkeletonESP()
    for player, connections in pairs(SkeletonESP) do
        if not player or not player.Character or player.Character.Parent == nil then
            ClearSkeletonESP(player)
        else
            for _, connection in ipairs(connections) do
                if connection.part1 and connection.part2 and connection.part1.Parent and connection.part2.Parent then
                    local pos1 = Camera:WorldToViewportPoint(connection.part1.Position)
                    local pos2 = Camera:WorldToViewportPoint(connection.part2.Position)
                    
                    if pos1.Z > 0 and pos2.Z > 0 then
                        connection.line.From = Vector2.new(pos1.X, pos1.Y)
                        connection.line.To = Vector2.new(pos2.X, pos2.Y)
                        connection.line.Visible = true
                    else
                        connection.line.Visible = false
                    end
                else
                    connection.line.Visible = false
                end
            end
        end
    end
end

local function ClearSkeletonESP(player)
    if player then
        if SkeletonESP[player] then
            for _, connection in ipairs(SkeletonESP[player]) do
                if connection.line then
                    connection.line:Remove()
                end
            end
            SkeletonESP[player] = nil
        end
    else
        for _, connections in pairs(SkeletonESP) do
            for _, connection in ipairs(connections) do
                if connection.line then
                    connection.line:Remove()
                end
            end
        end
        SkeletonESP = {}
    end
end

-- Head ESP
local function CreateHeadESP(player)
    if HeadESP[player] then return end
    
    local char = player.Character
    if not char then return end
    
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local dot = Drawing.new("Circle")
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

local function UpdateHeadESP()
    for player, data in pairs(HeadESP) do
        if not player or not player.Character or player.Character.Parent == nil then
            ClearHeadESP(player)
        else
            if data.head and data.head.Parent then
                local pos = Camera:WorldToViewportPoint(data.head.Position)
                if pos.Z > 0 then
                    data.dot.Position = Vector2.new(pos.X, pos.Y)
                    data.dot.Visible = true
                else
                    data.dot.Visible = false
                end
            else
                data.dot.Visible = false
            end
        end
    end
end

local function ClearHeadESP(player)
    if player then
        if HeadESP[player] and HeadESP[player].dot then
            HeadESP[player].dot:Remove()
        end
        HeadESP[player] = nil
    else
        for _, data in pairs(HeadESP) do
            if data.dot then
                data.dot:Remove()
            end
        end
        HeadESP = {}
    end
end

-- Box ESP
local function CreateBoxESP(player)
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
end

local function UpdateBoxESP()
    for player, data in pairs(BoxESP) do
        if not player or not player.Character or player.Character.Parent == nil then
            ClearBoxESP(player)
        else
            if data.root and data.root.Parent then
                local cf = data.root.CFrame
                local size = Vector3.new(3, 5, 0)
                
                local points = {
                    Vector3.new(-size.X, -size.Y, 0),
                    Vector3.new(size.X, -size.Y, 0),
                    Vector3.new(size.X, size.Y, 0),
                    Vector3.new(-size.X, size.Y, 0)
                }
                
                local points2D = {}
                local allVisible = true
                
                for i, point in ipairs(points) do
                    local worldPoint = cf:PointToWorldSpace(point)
                    local screenPoint = Camera:WorldToViewportPoint(worldPoint)
                    if screenPoint.Z > 0 then
                        points2D[i] = Vector2.new(screenPoint.X, screenPoint.Y)
                    else
                        allVisible = false
                        break
                    end
                end
                
                if allVisible and #points2D == 4 then
                    data.box.PointA = points2D[1]
                    data.box.PointB = points2D[2]
                    data.box.PointC = points2D[3]
                    data.box.PointD = points2D[4]
                    data.box.Visible = true
                else
                    data.box.Visible = false
                end
            else
                data.box.Visible = false
            end
        end
    end
end

local function ClearBoxESP(player)
    if player then
        if BoxESP[player] and BoxESP[player].box then
            BoxESP[player].box:Remove()
        end
        BoxESP[player] = nil
    else
        for _, data in pairs(BoxESP) do
            if data.box then
                data.box:Remove()
            end
        end
        BoxESP = {}
    end
end

-- ESP Management
local function UpdateAllESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPTeamCheck or player.Team ~= LocalPlayer.Team then
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
            end
        end
    end
end

-- =============== COOLDOWN BYPASS ===============
local function HookTools()
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            -- Remove existing connections to prevent duplicates
            for _, conn in ipairs(getconnections(tool.Activated)) do
                conn:Disable()
            end
            
            tool.Activated:Connect(function()
                if NoKnifeCooldown and (tool.Name:lower():find("knife") or tool.Name:lower():find("melee")) then
                    -- Bypass knife cooldown
                    tool:SetAttribute("LastUsed", 0)
                    if tool:FindFirstChild("Cooldown") then
                        tool.Cooldown.Value = 0
                    end
                elseif NoGunCooldown and tool.Name:lower():find("gun") then
                    -- Bypass gun cooldown
                    tool:SetAttribute("LastUsed", 0)
                    if tool:FindFirstChild("Cooldown") then
                        tool.Cooldown.Value = 0
                    end
                end
            end)
        end
    end
end

local function HookCharacterTools(character)
    if character then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                -- Remove existing connections to prevent duplicates
                for _, conn in ipairs(getconnections(tool.Activated)) do
                    conn:Disable()
                end
                
                tool.Activated:Connect(function()
                    if NoKnifeCooldown and (tool.Name:lower():find("knife") or tool.Name:lower():find("melee")) then
                        -- Bypass knife cooldown
                        tool:SetAttribute("LastUsed", 0)
                        if tool:FindFirstChild("Cooldown") then
                            tool.Cooldown.Value = 0
                        end
                    elseif NoGunCooldown and tool.Name:lower():find("gun") then
                        -- Bypass gun cooldown
                        tool:SetAttribute("LastUsed", 0)
                        if tool:FindFirstChild("Cooldown") then
                            tool.Cooldown.Value = 0
                        end
                    end
                end)
            end
        end
    end
end

-- Hook tools when character is added
LocalPlayer.CharacterAdded:Connect(function(character)
    HookCharacterTools(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            HookCharacterTools(character)
        end
    end)
end)

-- Hook initial tools
HookTools()
if LocalPlayer.Character then
    HookCharacterTools(LocalPlayer.Character)
end

-- =============== MAIN LOOPS ===============
RunService.RenderStepped:Connect(function()
    -- Update hitboxes
    if IsEnabled then 
        UpdateHitboxes() 
    else 
        ResetHitboxes() 
    end
    
    -- Update ESP
    UpdateAllESP()
    if SkeletonESPEnabled then UpdateSkeletonESP() end
    if HeadESPEnabled then UpdateHeadESP() end
    if BoxESPEnabled then UpdateBoxESP() end
    
    -- Soft Aim
    if SoftAimEnabled and UserInputService:IsMouseButtonPressed(SoftAimKey) then
        local target, targetPos = GetClosestTarget()
        if target and targetPos then
            local currentCF = Camera.CFrame
            local targetCF = CFrame.new(currentCF.Position, targetPos)
            
            -- Smooth aiming
            Camera.CFrame = currentCF:Lerp(targetCF, Smoothness)
        end
    end
end)

-- TOGGLE UI
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.F4 and not gpe then
        Rayfield:Toggle()
    end
end)

-- Notification
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Exo MVSD",
        Text = "Features Loaded! Press F4",
        Duration = 6
    })
end)
