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

-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Set WindUI Theme
WindUI:SetTheme("Dark")

-- UI
local Window = WindUI:CreateWindow({
    Title = "Ez Win v2.1",
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

-- =============== ENHANCED SETTINGS ===============
local HeadSize = 20
local Transparency = 70 -- Changed to percentage
local HitboxColor = Color3.fromRGB(0, 255, 0)
local IsEnabled = false
local HitboxTeamCheck = false  -- Separate team check for hitbox
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

-- Soft Aim Settings with separate team check and cursor movement
local SoftAimEnabled = false
local SoftAimKey = Enum.UserInputType.MouseButton2
local Smoothness = 15 -- Changed to percentage
local SoftAimTeamCheck = false  -- Separate team check for aimbot
local SoftAimToggled = false -- NEW: Toggle state for aimbot
local MoveCursor = true  -- NEW: Move actual cursor instead of camera

-- NEW: EzWin Settings
local LoopAutoKillEnabled = false
local AutoKillConnection = nil

-- NEW: Auto Shoot Settings
local AutoShootEnabled = false
local AutoShootConnection = nil
local ShotTargets = {} -- Track who we've already shot to prevent spam

-- =============== ESP STORAGE ===============
local SkeletonESP = {}
local HeadESP = {}
local BoxESP = {}
local CharmsESP = {}

-- ESP Update Connection
local ESPUpdateConnection = nil

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
                print("Animation stopped because player moved.")
                connection:Disconnect()
            end
        end)
    end)
end

-- =============== DECLARE FUNCTIONS FIRST (FIX FOR NIL ERRORS) ===============
local UpdateHitboxes
local ResetHitboxes
local GetClosestTarget
local CreateSkeletonESP
local CreateCharmsESP
local CreateHeadESP
local CreateBoxESP
local UpdateSkeletonESP
local UpdateHeadESP
local UpdateBoxESP
local ClearSkeletonESP
local ClearCharmsESP
local ClearHeadESP
local ClearBoxESP
local UpdateAllESP
local UpdateAllESPColors
local EnableFlight
local DisableFlight
local PerformKillOnPlayer
local GetEnemyPlayers
local LoopAutoKill
local StopAutoKill
local KillAllEnemies
local IsPlayerVisible
local AutoShootLoop

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
    Desc = "Aimbot/Triggerbot"
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

-- NEW: EzWin Tab (MOVED ABOVE EXTRA)
Tabs.EzWinTab = Tabs.EzWinSection:Tab({
    Title = "Autokill",
    Icon = "zap",
    Desc = "Advanced kill features"
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

-- =============== IMPROVED WALL DETECTION SYSTEM ===============
function IsPlayerVisible(targetPlayer)
    local isVisible = false
    pcall(function()
        if not LocalPlayer.Character or not targetPlayer.Character then
            return false
        end
        
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if not localRoot or not targetRoot then
            return false
        end
        
        -- First check if target is on screen
        local screenPos, onScreen = Camera:WorldToViewportPoint(targetRoot.Position)
        if not onScreen or screenPos.Z <= 0 then
            return false
        end
        
        -- Raycast to check for walls/obstacles
        local origin = localRoot.Position
        local direction = (targetRoot.Position - origin)
        local distance = direction.Magnitude
        direction = direction.Unit
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPlayer.Character}
        
        local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)
        
        -- If no obstacle hit, target is visible
        isVisible = raycastResult == nil
    end)
    return isVisible
end

-- =============== NEW: EZWIN FUNCTIONS ===============
function GetEnemyPlayers()
    local enemies = {}
    pcall(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
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
    end)
    return enemies
end

-- MODIFIED: Auto-equip weapon before performing kill
function PerformKillOnPlayer(targetPlayer)
    pcall(function()
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
    end)
end

-- FIXED: Loop Auto Kill - Now spams multiple times
function LoopAutoKill()
    if AutoKillConnection then
        AutoKillConnection:Disconnect()
        AutoKillConnection = nil
    end
    
    AutoKillConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
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
            
            -- SPAM KILL MULTIPLE TIMES (10x per frame)
            for i = 1, 10 do
                for _, enemy in ipairs(enemies) do
                    PerformKillOnPlayer(enemy)
                end
                task.wait(0.01) -- Very small delay between spam cycles
            end
        end)
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
    pcall(function()
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
    end)
end

-- FIXED: Auto Shoot Function with Proper Target Position
function AutoShootAtTarget(targetPlayer)
    pcall(function()
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
    end)
end

function AutoShootLoop()
    if AutoShootConnection then
        AutoShootConnection:Disconnect()
        AutoShootConnection = nil
    end
    
    AutoShootConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
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
    Desc = "Continuously kill all enemy players",
    Icon = "repeat",
    Value = false,
    Callback = function(val) 
        LoopAutoKillEnabled = val
        if val then
            LoopAutoKill()
            WindUI:Notify({
                Title = "Loop Auto Kill Enabled",
                Content = "Now spamming kills on all enemy players continuously",
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
    Desc = "⚠️ you better win lol!\n• Only problem is that players might not able to be shot/killed so becareful as you might lose your streak or something these EzWin features are still Beta!",
    Color = "Red",
    Image = "alert-triangle"
})

-- Hitbox Expander Function
function ResetHitboxes()
    pcall(function()
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
    end)
end

function UpdateHitboxes()
    pcall(function()
        if not IsEnabled then return end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    if HitboxTeamCheck and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                        -- Skip teammates if team check is enabled
                        root.Size = Vector3.new(2, 2, 1)
                        root.Transparency = 0
                        root.Color = Color3.fromRGB(255, 255, 255)
                        root.Material = Enum.Material.Plastic
                        root.CanCollide = true
                    else
                        root.Size = Vector3.new(HeadSize, HeadSize, HeadSize)
                        root.Transparency = Transparency / 100
                        root.Color = HitboxColor
                        root.Material = Enum.Material.Neon
                        root.CanCollide = false
                    end
                end
            end
        end
    end)
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

Tabs.HitboxTab:Colorpicker({
    Title = "Hitbox Color",
    Desc = "Color of the hitbox visualization",
    Default = HitboxColor,
    Callback = function(color) 
        HitboxColor = color 
    end
})

-- =============== AIM TAB (UPDATED) ===============
Tabs.AimTab:Section({ Title = "Aimbot Settings" })

Tabs.AimTab:Toggle({
    Title = "Silent Aim",
    Desc = "Enable toggle-based aimbot - Right click to toggle tracking on/off",
    Icon = "crosshair",
    Value = false,
    Callback = function(val) 
        SoftAimEnabled = val 
        if not val then
            SoftAimToggled = false -- Reset toggle when disabled
            WindUI:Notify({
                Title = "Silent Aim Disabled",
                Content = "Aimbot system turned off",
                Icon = "square",
                Duration = 2,
            })
        end
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
        Smoothness = val
    end
})

Tabs.AimTab:Toggle({
    Title = "Team Check",
    Desc = "Don't target teammates",
    Icon = "users",
    Value = false,
    Callback = function(val) 
        SoftAimTeamCheck = val 
    end
})

Tabs.AimTab:Keybind({
    Title = "Toggle Key",
    Desc = "Key to toggle Silent Aim tracking on/off",
    Value = "RightMouseButton",
    Callback = function(v)
        if v == "RightMouseButton" then
            SoftAimKey = Enum.UserInputType.MouseButton2
        elseif v == "LeftAlt" then
            SoftAimKey = Enum.KeyCode.LeftAlt
        elseif v == "LeftControl" then
            SoftAimKey = Enum.KeyCode.LeftControl
        elseif v == "F" then
            SoftAimKey = Enum.KeyCode.F
        end
    end
})

Tabs.AimTab:Section({ Title = "Auto Shoot" })

Tabs.AimTab:Toggle({
    Title = "Auto Shoot",
    Desc = "Automatically shoot visible enemies",
    Icon = "zap",
    Value = false,
    Callback = function(val) 
        AutoShootEnabled = val
        if val then
            AutoShootLoop()
            WindUI:Notify({
                Title = "Auto Shoot Enabled",
                Content = "Now targeting visible enemies",
                Icon = "crosshair",
                Duration = 3,
            })
        else
            StopAutoShoot()
            WindUI:Notify({
                Title = "Auto Shoot Disabled",
                Content = "Auto shooting stopped",
                Icon = "square",
                Duration = 3,
            })
        end
    end
})

-- =============== FIXED ESP FUNCTIONS ===============

-- Clear Functions
function ClearSkeletonESP(player)
    pcall(function()
        if player and SkeletonESP[player] then
            for _, connection in ipairs(SkeletonESP[player]) do
                if connection.line then
                    connection.line:Remove()
                end
            end
            SkeletonESP[player] = nil
        elseif not player then
            -- Clear all
            for _, connections in pairs(SkeletonESP) do
                for _, connection in ipairs(connections) do
                    if connection.line then
                        connection.line:Remove()
                    end
                end
            end
            SkeletonESP = {}
        end
    end)
end

function ClearHeadESP(player)
    pcall(function()
        if player and HeadESP[player] then
            if HeadESP[player].dot then
                HeadESP[player].dot:Remove()
            end
            HeadESP[player] = nil
        elseif not player then
            -- Clear all
            for _, data in pairs(HeadESP) do
                if data.dot then
                    data.dot:Remove()
                end
            end
            HeadESP = {}
        end
    end)
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
    pcall(function()
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
    end)
end

-- Create Functions
function CreateSkeletonESP(player)
    pcall(function()
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
    end)
end

function CreateCharmsESP(player)
    pcall(function()
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
    end)
end

function CreateHeadESP(player)
    pcall(function()
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
    end)
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

-- Update Functions
function UpdateSkeletonESP()
    pcall(function()
        for player, connections in pairs(SkeletonESP) do
            if not player or not player.Character or player.Character.Parent == nil then
                ClearSkeletonESP(player)
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
                        -- Update individual bone connections
                        for _, connection in ipairs(connections) do
                            if connection.part1 and connection.part2 and connection.part1.Parent and connection.part2.Parent then
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
                            else
                                connection.line.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end)
end

function UpdateHeadESP()
    pcall(function()
        for player, data in pairs(HeadESP) do
            if not player or not player.Character or player.Character.Parent == nil then
                ClearHeadESP(player)
            else
                if data.head and data.head.Parent then
                    local pos, onScreen = Camera:WorldToViewportPoint(data.head.Position)
                    -- Check if position is in front of camera and on screen
                    if onScreen and pos.Z > 0 and pos.X >= 0 and pos.Y >= 0 and pos.X <= Camera.ViewportSize.X and pos.Y <= Camera.ViewportSize.Y then
                        data.dot.Position = Vector2.new(pos.X, pos.Y)
                        data.dot.Visible = true
                        data.dot.Color = ESPColor
                    else
                        data.dot.Visible = false
                    end
                else
                    data.dot.Visible = false
                end
            end
        end
    end)
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
    pcall(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local shouldShowESP = true
                
                -- Check ESP team check (separate from other features)
                if ESPTeamCheck and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                    shouldShowESP = false
                end
                
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
    end)
end

function UpdateAllESPColors()
    pcall(function()
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
    end)
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
    Title = "Box ESP",
    Desc = "Show boxes around players",
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
    pcall(function()
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
            pcall(function()
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
        end)
        
        table.insert(FlightConnections, flyConnection)
    end)
end

function DisableFlight()
    pcall(function()
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
    end)
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
    Desc = "Ez Win v2.1 Enhanced\nConverted to WindUI with new features\nPress F4 to toggle UI",
    Color = "Blue",
    Image = "info"
})

-- =============== IMPROVED AIMBOT SYSTEM ===============
function GetClosestTarget()
    local shortest = math.huge
    local closest = nil
    local closestPos = nil
    
    pcall(function()
        if not LocalPlayer.Character then return end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    -- Check team first
                    if not (SoftAimTeamCheck and LocalPlayer.Team and player.Team == LocalPlayer.Team) then
                        -- Check if player is visible (not behind walls)
                        if IsPlayerVisible(player) then
                            local pos = player.Character.HumanoidRootPart.Position
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
    end)
    
    return closest, closestPos
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
end)

if LocalPlayer then
    LocalPlayer.CharacterAdded:Connect(OnLocalPlayerRespawned)
end

-- =============== INPUT HANDLING ===============
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    -- Handle aim toggle key
    if SoftAimEnabled and (input.UserInputType == SoftAimKey or input.KeyCode == SoftAimKey) then
        SoftAimToggled = not SoftAimToggled
        
        WindUI:Notify({
            Title = SoftAimToggled and "Silent Aim ON" or "Silent Aim OFF",
            Content = SoftAimToggled and "Now tracking closest visible enemy" or "Tracking stopped",
            Icon = SoftAimToggled and "crosshair" or "square",
            Duration = 2,
        })
    end
    
    -- Handle UI toggle
    if input.KeyCode == Enum.KeyCode.F4 then
        Window:SetToggleKey(Enum.KeyCode.F4)
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    
    -- No need for InputEnded handling with toggle system
end)

-- =============== START ESP UPDATE LOOP ===============
local function StartESPUpdateLoop()
    if ESPUpdateConnection then
        ESPUpdateConnection:Disconnect()
    end
    
    ESPUpdateConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            -- Update all ESP visuals
            if SkeletonESPEnabled then UpdateSkeletonESP() end
            if HeadESPEnabled then UpdateHeadESP() end
            if BoxESPEnabled then UpdateBoxESP() end
            -- Charms ESP updates automatically via Highlight objects
            
            -- Update ESP creation/removal for new players or respawns
            UpdateAllESP()
        end)
    end)
end

-- Start the ESP update loop
StartESPUpdateLoop()

-- =============== MAIN RENDER LOOP ===============
RunService.RenderStepped:Connect(function()
    pcall(function()
        -- Update hitboxes (with separate team check)
        if IsEnabled then 
            UpdateHitboxes() 
        end
        
        -- TOGGLE-BASED Silent Aim Implementation
        if SoftAimEnabled and SoftAimToggled and LocalPlayer.Character then
            local target, targetScreenPos = GetClosestTarget()
            if target and targetScreenPos then
                local currentMouse = UserInputService:GetMouseLocation()
                local targetMouse = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                
                -- Calculate smooth movement delta
                local deltaX = (targetMouse.X - currentMouse.X) * (Smoothness / 100)
                local deltaY = (targetMouse.Y - currentMouse.Y) * (Smoothness / 100)
                
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
            end
        end
    end)
end)

-- =============== CLEANUP ON SCRIPT UNLOAD ===============
game:BindToClose(function()
    -- Clean up ESP elements
    ClearSkeletonESP()
    ClearHeadESP()
    ClearBoxESP()
    ClearCharmsESP()
    
    -- Stop connections
    if ESPUpdateConnection then
        ESPUpdateConnection:Disconnect()
    end
    
    -- Stop auto kill
    StopAutoKill()
    
    -- Stop auto shoot
    StopAutoShoot()
    
    -- Disable flight
    if FlightEnabled then
        DisableFlight()
    end
    
    -- Reset hitboxes
    ResetHitboxes()
end)

-- =============== INITIALIZATION ===============
-- Set the toggle key
Window:SetToggleKey(Enum.KeyCode.F4)

-- Initial setup
task.spawn(function()
    task.wait(2) -- Wait for everything to load
    UpdateAllESP()
end)

-- Success notification
WindUI:Notify({
    Title = "YOU BETTER NOT LOSE with these cheats",
    Content = "All features loaded successfully! Press F4 To toggle UI Have FUN :D",
    Icon = "check",
    Duration = 5,
})
