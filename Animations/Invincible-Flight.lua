
local savedSpeed = 50

local function gui()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local HRP = character:WaitForChild("HumanoidRootPart")
    local Camera = workspace.CurrentCamera

    local baseSpeed = savedSpeed
    local flySpeed = baseSpeed
    local flying = false
    local forwardHold = 0
    local inputFlags = { forward = false, back = false, left = false, right = false, up = false, down = false }

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlyScreenGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleFlyButton"
    toggleButton.Text = "Fly OFF"
    toggleButton.Size = UDim2.new(0, 100, 0, 50)
    toggleButton.Position = UDim2.new(1, -220, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextScaled = true
    toggleButton.BackgroundTransparency = 0.2
    toggleButton.Parent = screenGui

    local speedBox = Instance.new("TextBox")
    speedBox.Name = "SpeedBox"
    speedBox.Text = tostring(baseSpeed)
    speedBox.Size = UDim2.new(0, 100, 0, 50)
    speedBox.Position = UDim2.new(1, -110, 0, 10)
    speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextScaled = true
    speedBox.BackgroundTransparency = 0.2
    speedBox.Parent = screenGui

    local function newAnim(id)
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. id
        return anim
    end

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

    local function stopAll()
        for _, track in pairs(tracks) do
            track:Stop()
        end
    end

    local function startFlying()
        flying = true
        forwardHold = 0
        flySpeed = baseSpeed
        bodyVelocity.Parent = HRP
        bodyGyro.Parent = HRP
        humanoid.PlatformStand = true
    end

    local function stopFlying()
        flying = false
        bodyVelocity.Parent = nil
        bodyGyro.Parent = nil
        humanoid.PlatformStand = false
        stopAll()
    end

    toggleButton.MouseButton1Click:Connect(function()
        if flying then
            stopFlying()
            toggleButton.Text = "Fly OFF"
        else
            startFlying()
            toggleButton.Text = "Fly ON"
        end
    end)

    speedBox.FocusLost:Connect(function()
        local num = tonumber(speedBox.Text)
        if num and num > 0 then
            baseSpeed = num
            savedSpeed = num
            if flying then flySpeed = baseSpeed end
        else
            speedBox.Text = tostring(baseSpeed)
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

    RunService.RenderStepped:Connect(function(dt)
        if not flying then return end

        if not inputFlags.forward then forwardHold = 0 end

        local dir = Vector3.zero
        local camCF = Camera.CFrame

        if inputFlags.forward then dir += camCF.LookVector end
        if inputFlags.back then dir -= camCF.LookVector end
        if inputFlags.left then dir -= camCF.RightVector end
        if inputFlags.right then dir += camCF.RightVector end
        if inputFlags.up then dir += Vector3.yAxis end
        if inputFlags.down then dir -= Vector3.yAxis end

        if dir.Magnitude > 0 then dir = dir.Unit end

        bodyVelocity.Velocity = dir * flySpeed
        bodyGyro.CFrame = camCF

        -- Animation Logic
        if inputFlags.up then
            if not tracks.up.IsPlaying then stopAll(); tracks.up:Play() end
        elseif inputFlags.down then
            if not tracks.down.IsPlaying then stopAll(); tracks.down:Play() end
        elseif inputFlags.left then
            if not tracks.left1.IsPlaying then
                stopAll()
                tracks.left1:Play(); tracks.left1.TimePosition = 2.0; tracks.left1:AdjustSpeed(0)
                tracks.left2:Play(); tracks.left2.TimePosition = 0.5; tracks.left2:AdjustSpeed(0)
            end
        elseif inputFlags.right then
            if not tracks.right1.IsPlaying then
                stopAll()
                tracks.right1:Play(); tracks.right1.TimePosition = 1.1; tracks.right1:AdjustSpeed(0)
                tracks.right2:Play(); tracks.right2.TimePosition = 0.5; tracks.right2:AdjustSpeed(0)
            end
        elseif inputFlags.back then
            if not tracks.back1.IsPlaying then
                stopAll()
                tracks.back1:Play(); tracks.back1.TimePosition = 5.3; tracks.back1:AdjustSpeed(0)
                tracks.back2:Play(); tracks.back2:AdjustSpeed(0)
                tracks.back3:Play(); tracks.back3.TimePosition = 0.8; tracks.back3:AdjustSpeed(0)
                tracks.back4:Play(); tracks.back4.TimePosition = 1; tracks.back4:AdjustSpeed(0)
            end
        elseif inputFlags.forward then
            forwardHold += dt
            if forwardHold >= 3 then
                if not tracks.flyFast.IsPlaying then
                    stopAll()
                    flySpeed = baseSpeed * 1.3
                    tracks.flyFast:Play(); tracks.flyFast:AdjustSpeed(0.05)
                end
            else
                if not tracks.flyLow1.IsPlaying then
                    stopAll()
                    flySpeed = baseSpeed
                    tracks.flyLow1:Play()
                    tracks.flyLow2:Play()
                end
            end
        else
            if not tracks.idle1.IsPlaying then
                stopAll()
                tracks.idle1:Play(); tracks.idle1:AdjustSpeed(0)
            end
        end
    end)
end

gui()
