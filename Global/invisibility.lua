local key = Enum.KeyCode.X -- key to toggle invisibility

--// dont edit script below
local invis_on = false
local defaultSpeed = 16 -- Default walk speed
local boostedSpeed = 48 -- 3x the default speed (16 * 3)
local isSpeedBoosted = false

-- Создание GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", screenGui)
local toggleButton = Instance.new("TextButton", frame)
local closeButton = Instance.new("TextButton", frame)
local signatureLabel = Instance.new("TextLabel", frame)
local speedButton = Instance.new("TextButton", frame) -- Fixed typo: Instance.New to Instance.new

screenGui.ResetOnSpawn = false

frame.Size = UDim2.new(0, 100, 0, 110)
frame.Position = UDim2.new(0.5, -110, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Active = true
frame.Draggable = true

toggleButton.Size = UDim2.new(0, 80, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 30)
toggleButton.Text = "INVISIBLE"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextScaled = true

closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 123, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSans
closeButton.TextSize = 18

signatureLabel.Size = UDim2.new(0, 100, 0, 10)
signatureLabel.Position = UDim2.new(0, 0, 0.9, 0)
signatureLabel.Text = "By: xXHaNdEROXx TG@MK14CFG"
signatureLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
signatureLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
signatureLabel.Font = Enum.Font.SourceSans
signatureLabel.TextScaled = true
signatureLabel.Transparency = 0.3

speedButton.Size = UDim2.new(0, 80, 0, 30)
speedButton.Position = UDim2.new(0, 10, 0, 65) -- Adjusted position to avoid overlap
speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
speedButton.Text = "SPEED BOOST"
speedButton.TextScaled = true
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.SourceSans

-- Создание звукового объекта
local sound = Instance.new("Sound", player:WaitForChild("PlayerGui"))
sound.SoundId = "rbxassetid://942127495"
sound.Volume = 1

local function setTransparency(character, transparency)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = transparency
        end
    end
end

local function toggleInvisibility()
    invis_on = not invis_on
    sound:Play()
    if invis_on then
        local savedpos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        wait()
        game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-25.95, 84, 3537.55))
        wait(.15)
        local Seat = Instance.new('Seat', game.Workspace)
        Seat.Anchored = false
        Seat.CanCollide = false
        Seat.Name = 'invischair'
        Seat.Transparency = 1
        Seat.Position = Vector3.new(-25.95, 84, 3537.55) -- Fixed typo in position
        local Weld = Instance.new("Weld", Seat)
        Weld.Part0 = Seat
        Weld.Part1 = game.Players.LocalPlayer.Character:FindFirstChild("Torso") or game.Players.LocalPlayer.Character.UpperTorso
        wait()
        Seat.CFrame = savedpos
        setTransparency(game.Players.LocalPlayer.Character, 0.5)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Invis (on)",
            Duration = 3,
            Text = "STATUS:"
        })
    else
        local invisChair = workspace:FindFirstChild('invischair')
        if invisChair then
            invisChair:Destroy()
        end
        setTransparency(game.Players.LocalPlayer.Character, 0)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Invis (off)",
            Duration = 3,
            Text = "STATUS:"
        })
    end
end

local function toggleSpeedBoost()
    isSpeedBoosted = not isSpeedBoosted
    sound:Play()
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        if isSpeedBoosted then
            humanoid.WalkSpeed = boostedSpeed
            speedButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green when active
            game.StarterGui:SetCore("SendNotification", {
                Title = "Speed Boost (on)",
                Duration = 3,
                Text = "Speed: " .. boostedSpeed
            })
        else
            humanoid.WalkSpeed = defaultSpeed
            speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red when inactive
            game.StarterGui:SetCore("SendNotification", {
                Title = "Speed Boost (off)",
                Duration = 3,
                Text = "Speed: " .. defaultSpeed
            })
        end
    end
end

-- Подписка на события
toggleButton.MouseButton1Click:Connect(toggleInvisibility)
speedButton.MouseButton1Click:Connect(toggleSpeedBoost)
closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Reset speed when character respawns
player.CharacterAdded:Connect(function(character)
    isSpeedBoosted = false
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = defaultSpeed
    speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end)
