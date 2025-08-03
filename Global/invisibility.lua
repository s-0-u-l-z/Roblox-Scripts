-- Made by xXHaNdEROXx (modified by s0ulz)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local defaultSpeed = 16
local boostedSpeed = 48
local invisEnabled = false
local speedBoostEnabled = false

-- UI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "ModernUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 240, 0, 160)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Active = true
mainFrame.Draggable = true

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Invisibility Button
local invisButton = Instance.new("TextButton", mainFrame)
invisButton.Size = UDim2.new(1, -30, 0, 40)
invisButton.Position = UDim2.new(0, 15, 0, 15)
invisButton.BackgroundColor3 = Color3.fromRGB(32, 145, 255)
invisButton.Text = "Invisibility"
invisButton.TextColor3 = Color3.fromRGB(240, 240, 240)
invisButton.Font = Enum.Font.GothamSemibold
invisButton.TextScaled = true
invisButton.AutoButtonColor = false
Instance.new("UICorner", invisButton).CornerRadius = UDim.new(0, 6)

-- Speed Button
local speedButton = Instance.new("TextButton", mainFrame)
speedButton.Size = UDim2.new(1, -30, 0, 40)
speedButton.Position = UDim2.new(0, 15, 0, 65)
speedButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
speedButton.Text = "Speed Boost"
speedButton.TextColor3 = Color3.fromRGB(240, 240, 240)
speedButton.Font = Enum.Font.GothamSemibold
speedButton.TextScaled = true
speedButton.AutoButtonColor = false
Instance.new("UICorner", speedButton).CornerRadius = UDim.new(0, 6)

-- Labels
local creditLabel = Instance.new("TextLabel", mainFrame)
creditLabel.Size = UDim2.new(1, 0, 0, 20)
creditLabel.Position = UDim2.new(0, 0, 1, -20)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "made by xXHaNdEROXx"
creditLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
creditLabel.Font = Enum.Font.Gotham
creditLabel.TextScaled = true

local modifiedLabel = Instance.new("TextLabel", mainFrame)
modifiedLabel.Size = UDim2.new(1, 0, 0, 10)
modifiedLabel.Position = UDim2.new(0, 0, 1, -27)
modifiedLabel.BackgroundTransparency = 1
modifiedLabel.Text = "(modified by s0ulz)"
modifiedLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
modifiedLabel.Font = Enum.Font.Gotham
modifiedLabel.TextScaled = true
modifiedLabel.TextSize = 20

-- Close Button
local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 16, 0, 16)
closeButton.Position = UDim2.new(1, -22, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
closeButton.Text = ""
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(1, 0)

-- Sound
local sound = Instance.new("Sound", screenGui)
sound.SoundId = "rbxassetid://942127495"
sound.Volume = 1

-- Utility
local function setTransparency(char, value)
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") or part:IsA("Decal") then
			if part.Name ~= "HumanoidRootPart" then
				part.Transparency = value
			elseif part:IsA("Decal") then
				part.Transparency = value
			end
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end

local function notify(title, text)
	game.StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = text,
		Duration = 3
	})
end

-- Invisibility Logic
local function toggleInvisibility()
	invisEnabled = not invisEnabled
	sound:Play()

	local char = player.Character or player.CharacterAdded:Wait()

	if invisEnabled then
		local savedpos = char:WaitForChild("HumanoidRootPart").CFrame
		char:MoveTo(Vector3.new(-25.95, -5000, 3537.55))
		wait(0.15)
		local seat = Instance.new("Seat")
		seat.Anchored = false
		seat.CanCollide = false
		seat.Name = "invischair"
		seat.Transparency = 1
		seat.Position = Vector3.new(-25.95, 84, 3537.55)
		seat.Parent = workspace

		local weld = Instance.new("Weld")
		weld.Part0 = seat
		weld.Part1 = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
		weld.Parent = seat

		seat.CFrame = savedpos
		setTransparency(char, 0.6)
		notify("Invisibility", "Enabled")
	else
		local chair = workspace:FindFirstChild("invischair")
		if chair then chair:Destroy() end
		setTransparency(char, 0)
		notify("Invisibility", "Disabled")
	end
end

-- ✅ FIXED: Speed Boost Logic
local function toggleSpeedBoost()
	speedBoostEnabled = not speedBoostEnabled
	sound:Play()

	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:FindFirstChildWhichIsA("Humanoid")

	if humanoid then
		if speedBoostEnabled then
			humanoid.WalkSpeed = boostedSpeed
			speedButton.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
			notify("Speed Boost", "Enabled")
		else
			humanoid.WalkSpeed = defaultSpeed
			speedButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
			notify("Speed Boost", "Disabled")
		end
	end
end

-- Events
invisButton.MouseButton1Click:Connect(toggleInvisibility)
speedButton.MouseButton1Click:Connect(toggleSpeedBoost)
closeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

player.CharacterAdded:Connect(function(char)
	character = char
	speedBoostEnabled = false
	local humanoid = char:WaitForChild("Humanoid")
	humanoid.WalkSpeed = defaultSpeed
	speedButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)
