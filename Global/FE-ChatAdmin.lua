-- Gui to Lua
-- Version: 3.2

-- Instances:

local ChatTroll = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Top = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Exit = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local Credits = Instance.new("TextLabel")
local Chat = Instance.new("Frame")
local UICorner_4 = Instance.new("UICorner")
local Dropdown = Instance.new("Frame")
local Btn = Instance.new("TextButton")
local Title_2 = Instance.new("TextLabel")
local Ico = Instance.new("ImageLabel")
local UICorner_5 = Instance.new("UICorner")
local Value = Instance.new("TextLabel")
local Holder = Instance.new("Frame")
local Layout = Instance.new("UIListLayout")
local Legacy = Instance.new("TextButton")
local UICorner_6 = Instance.new("UICorner")
local UIPadding = Instance.new("UIPadding")
local New = Instance.new("TextButton")
local Real = Instance.new("Frame")
local UICorner_7 = Instance.new("UICorner")
local TextBox = Instance.new("TextBox")
local Fake = Instance.new("Frame")
local UICorner_8 = Instance.new("UICorner")
local TextBox_2 = Instance.new("TextBox")
local Send = Instance.new("Frame")
local Btn_2 = Instance.new("TextButton")
local Circle = Instance.new("ImageLabel")
local UICorner_9 = Instance.new("UICorner")
local Presets = Instance.new("Frame")
local Btn_3 = Instance.new("TextButton")
local Circle_2 = Instance.new("ImageLabel")
local UICorner_10 = Instance.new("UICorner")
local Presets_2 = Instance.new("Frame")
local UICorner_11 = Instance.new("UICorner")
local Top_2 = Instance.new("Frame")
local UICorner_12 = Instance.new("UICorner")
local Frame_2 = Instance.new("Frame")
local Title_3 = Instance.new("TextLabel")
local List = Instance.new("Frame")
local UICorner_13 = Instance.new("UICorner")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local UIPadding_2 = Instance.new("UIPadding")

--Properties:

ChatTroll.Name = "ChatTroll"
ChatTroll.Parent = game:GetService("CoreGui")
ChatTroll.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ChatTroll.DisplayOrder = 67
ChatTroll.ResetOnSpawn = false

Main.Name = "Main"
Main.Parent = ChatTroll
Main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.714853048, 0, 0.322327048, 0)
Main.Size = UDim2.new(0, 300, 0, 225)

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Main

Top.Name = "Top"
Top.Parent = Main
Top.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Top.Size = UDim2.new(1, 0, 0, 44)

UICorner_2.CornerRadius = UDim.new(0, 12)
UICorner_2.Parent = Top

Frame.Parent = Top
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0, 0, 1, -16)
Frame.Size = UDim2.new(1, 0, 0, 16)

Title.Name = "Title"
Title.Parent = Top
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0, 16, 0.150000006, 0)
Title.Size = UDim2.new(0, 200, 0.699999988, 0)
Title.Font = Enum.Font.Gotham
Title.Text = "Chat Admin"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextSize = 14.000
Title.TextWrapped = true
Title.TextXAlignment = Enum.TextXAlignment.Left

Exit.Name = "Exit"
Exit.Parent = Top
Exit.BackgroundColor3 = Color3.fromRGB(255, 82, 82)
Exit.BorderSizePixel = 0
Exit.Position = UDim2.new(0, 270, 0.5, -4)
Exit.Size = UDim2.new(0, 8, 0, 8)
Exit.Font = Enum.Font.SourceSans
Exit.Text = ""
Exit.TextColor3 = Color3.fromRGB(0, 0, 0)
Exit.TextSize = 14.000

UICorner_3.CornerRadius = UDim.new(0, 64)
UICorner_3.Parent = Exit

Credits.Name = "Credits"
Credits.Parent = Main
Credits.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Credits.BackgroundTransparency = 1.000
Credits.BorderSizePixel = 0
Credits.Position = UDim2.new(0, 0, 1, -14)
Credits.Size = UDim2.new(1, 0, 0, 12)
Credits.Font = Enum.Font.Gotham
Credits.Text = "by hovac, v2.0"
Credits.TextColor3 = Color3.fromRGB(170, 170, 170)
Credits.TextScaled = true
Credits.TextSize = 14.000
Credits.TextWrapped = true

Chat.Name = "Chat"
Chat.Parent = Main
Chat.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Chat.Position = UDim2.new(0, 16, 0, 54)
Chat.Size = UDim2.new(1, -32, 0, 150)

UICorner_4.Parent = Chat

Dropdown.Name = "Dropdown"
Dropdown.Parent = Chat
Dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Dropdown.BackgroundTransparency = 1.000
Dropdown.Position = UDim2.new(0, 8, 0, 8)
Dropdown.Size = UDim2.new(1, -16, 0, 32)
Dropdown.ZIndex = 2

Btn.Name = "Btn"
Btn.Parent = Dropdown
Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Btn.Size = UDim2.new(1, 0, 0, 24)
Btn.ZIndex = 3
Btn.AutoButtonColor = false
Btn.Font = Enum.Font.SourceSans
Btn.Text = ""
Btn.TextColor3 = Color3.fromRGB(0, 0, 0)
Btn.TextSize = 14.000

Title_2.Name = "Title"
Title_2.Parent = Btn
Title_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title_2.BackgroundTransparency = 1.000
Title_2.Position = UDim2.new(0, 10, 0, 0)
Title_2.Selectable = true
Title_2.Size = UDim2.new(0, 1, 1, 0)
Title_2.ZIndex = 3
Title_2.Font = Enum.Font.Gotham
Title_2.Text = "Chat System"
Title_2.TextColor3 = Color3.fromRGB(255, 255, 255)
Title_2.TextSize = 14.000
Title_2.TextXAlignment = Enum.TextXAlignment.Left

Ico.Name = "Ico"
Ico.Parent = Btn
Ico.AnchorPoint = Vector2.new(1, 0.5)
Ico.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Ico.BackgroundTransparency = 1.000
Ico.Position = UDim2.new(1, -10, 0.5, 0)
Ico.Size = UDim2.new(0, 20, 0, 20)
Ico.ZIndex = 3
Ico.Image = "http://www.roblox.com/asset/?id=6034818379"
Ico.ImageTransparency = 0.400

UICorner_5.CornerRadius = UDim.new(0, 5)
UICorner_5.Parent = Btn

Value.Name = "Value"
Value.Parent = Btn
Value.AnchorPoint = Vector2.new(1, 0.5)
Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Value.BackgroundTransparency = 1.000
Value.Position = UDim2.new(1, -35, 0.5, 0)
Value.Selectable = true
Value.Size = UDim2.new(0, 1, 0, 32)
Value.ZIndex = 3
Value.Font = Enum.Font.Gotham
Value.Text = "Dropdown"
Value.TextColor3 = Color3.fromRGB(255, 255, 255)
Value.TextSize = 14.000
Value.TextTransparency = 0.400
Value.TextXAlignment = Enum.TextXAlignment.Right

Holder.Name = "Holder"
Holder.Parent = Dropdown
Holder.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
Holder.BackgroundTransparency = 1.000
Holder.ClipsDescendants = true
Holder.Position = UDim2.new(0, 0, 0, 19)
Holder.Size = UDim2.new(1, 0, 0, 5)
Holder.ZIndex = 2

Layout.Name = "Layout"
Layout.Parent = Holder
Layout.SortOrder = Enum.SortOrder.LayoutOrder

Legacy.Name = "Legacy"
Legacy.Parent = Holder
Legacy.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Legacy.BackgroundTransparency = 1.000
Legacy.BorderColor3 = Color3.fromRGB(27, 42, 53)
Legacy.BorderSizePixel = 0
Legacy.Size = UDim2.new(1, 0, 0, 32)
Legacy.ZIndex = 2
Legacy.Font = Enum.Font.Gotham
Legacy.Text = "Legacy"
Legacy.TextColor3 = Color3.fromRGB(255, 255, 255)
Legacy.TextSize = 14.000
Legacy.TextTransparency = 0.400

UICorner_6.CornerRadius = UDim.new(0, 5)
UICorner_6.Parent = Holder

UIPadding.Parent = Holder
UIPadding.PaddingTop = UDim.new(0, 5)

New.Name = "New"
New.Parent = Holder
New.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
New.BackgroundTransparency = 1.000
New.BorderColor3 = Color3.fromRGB(27, 42, 53)
New.BorderSizePixel = 0
New.Size = UDim2.new(1, 0, 0, 32)
New.ZIndex = 2
New.Font = Enum.Font.Gotham
New.Text = "New"
New.TextColor3 = Color3.fromRGB(255, 255, 255)
New.TextSize = 14.000
New.TextTransparency = 0.400

Real.Name = "Real"
Real.Parent = Chat
Real.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Real.Position = UDim2.new(0, 8, 0, 40)
Real.Size = UDim2.new(1, -16, 0, 24)

UICorner_7.CornerRadius = UDim.new(0, 5)
UICorner_7.Parent = Real

TextBox.Parent = Real
TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundTransparency = 1.000
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(0, 8, 1, -19)
TextBox.Size = UDim2.new(1, -14, 0, 14)
TextBox.ClearTextOnFocus = false
TextBox.Font = Enum.Font.Gotham
TextBox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
TextBox.PlaceholderText = "Put your disguise here"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 14.000
TextBox.TextWrapped = true
TextBox.TextXAlignment = Enum.TextXAlignment.Left

Fake.Name = "Fake"
Fake.Parent = Chat
Fake.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Fake.Position = UDim2.new(0, 8, 0, 71)
Fake.Size = UDim2.new(1, -16, 0, 24)

UICorner_8.CornerRadius = UDim.new(0, 5)
UICorner_8.Parent = Fake

TextBox_2.Parent = Fake
TextBox_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextBox_2.BackgroundTransparency = 1.000
TextBox_2.BorderSizePixel = 0
TextBox_2.Position = UDim2.new(0, 8, 1, -19)
TextBox_2.Size = UDim2.new(1, -16, 0, 14)
TextBox_2.ClearTextOnFocus = false
TextBox_2.Font = Enum.Font.Gotham
TextBox_2.MultiLine = true
TextBox_2.PlaceholderText = "Put the \"fake\" message here"
TextBox_2.Text = ""
TextBox_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox_2.TextScaled = true
TextBox_2.TextSize = 14.000
TextBox_2.TextWrapped = true
TextBox_2.TextXAlignment = Enum.TextXAlignment.Left

Send.Name = "Send"
Send.Parent = Chat
Send.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Send.BorderSizePixel = 0
Send.Position = UDim2.new(0, 8, 0, 110)
Send.Size = UDim2.new(0.694029868, -16, 0, 32)

Btn_2.Name = "Btn"
Btn_2.Parent = Send
Btn_2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Btn_2.BackgroundTransparency = 1.000
Btn_2.Size = UDim2.new(1, 0, 1, 0)
Btn_2.Font = Enum.Font.Gotham
Btn_2.Text = "Send"
Btn_2.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn_2.TextSize = 14.000



UICorner_9.CornerRadius = UDim.new(0, 5)
UICorner_9.Parent = Send

Presets.Name = "Presets"
Presets.Parent = Chat
Presets.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Presets.BorderSizePixel = 0
Presets.Position = UDim2.new(0, 185, 0, 110)
Presets.Size = UDim2.new(0.339552253, -16, 0, 32)

Btn_3.Name = "Btn"
Btn_3.Parent = Presets
Btn_3.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Btn_3.BackgroundTransparency = 1.000
Btn_3.Size = UDim2.new(1, 0, 1, 0)
Btn_3.Font = Enum.Font.Gotham
Btn_3.Text = "Presets"
Btn_3.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn_3.TextSize = 14.000

UICorner_10.CornerRadius = UDim.new(0, 5)
UICorner_10.Parent = Presets

Presets_2.Name = "Presets"
Presets_2.Parent = ChatTroll
Presets_2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Presets_2.BorderSizePixel = 0
Presets_2.ClipsDescendants = true
Presets_2.Position = UDim2.new(0.0452739783, 0, 0.322327048, 0)
Presets_2.Size = UDim2.new(0, 174, 0, 225)

UICorner_11.CornerRadius = UDim.new(0, 12)
UICorner_11.Parent = Presets_2

Top_2.Name = "Top"
Top_2.Parent = Presets_2
Top_2.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Top_2.Size = UDim2.new(1, 0, 0, 44)

UICorner_12.CornerRadius = UDim.new(0, 12)
UICorner_12.Parent = Top_2

Frame_2.Parent = Top_2
Frame_2.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0, 0, 1, -16)
Frame_2.Size = UDim2.new(1, 0, 0, 16)

Title_3.Name = "Title"
Title_3.Parent = Top_2
Title_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title_3.BackgroundTransparency = 1.000
Title_3.BorderSizePixel = 0
Title_3.Position = UDim2.new(0, 16, 0.150000006, 0)
Title_3.Size = UDim2.new(0, 200, 0.699999988, 0)
Title_3.Font = Enum.Font.Gotham
Title_3.Text = "Presets"
Title_3.TextColor3 = Color3.fromRGB(255, 255, 255)
Title_3.TextScaled = true
Title_3.TextSize = 14.000
Title_3.TextWrapped = true
Title_3.TextXAlignment = Enum.TextXAlignment.Left

List.Name = "List"
List.Parent = Presets_2
List.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
List.Position = UDim2.new(0, 16, 0, 58)
List.Size = UDim2.new(1, -32, 0, 150)

UICorner_13.Parent = List

ScrollingFrame.Parent = List
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame.BackgroundTransparency = 1.000
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Size = UDim2.new(1, -4, 1, 0)
ScrollingFrame.ScrollBarThickness = 6

UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

UIPadding_2.Parent = ScrollingFrame
UIPadding_2.PaddingTop = UDim.new(0, 5)

-- Scripts:

local function UPRZQSQ_fake_script() -- Main.Smooth 
	local script = Instance.new('LocalScript', Main)

	local UserInputService = game:GetService("UserInputService")
	local runService = (game:GetService("RunService"));
	
	local gui = script.Parent
	
	local dragging
	local dragInput
	local dragStart
	local startPos
	
	function Lerp(a, b, m)
		return a + (b - a) * m
	end;
	
	local lastMousePos
	local lastGoalPos
	local DRAG_SPEED = (8); -- // The speed of the UI darg.
	function Update(dt)
		if not (startPos) then return end;
		if not (dragging) and (lastGoalPos) then
			gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
			return 
		end;
	
		local delta = (lastMousePos - UserInputService:GetMouseLocation())
		local xGoal = (startPos.X.Offset - delta.X);
		local yGoal = (startPos.Y.Offset - delta.Y);
		lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
		gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
	end;
	
	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
			lastMousePos = UserInputService:GetMouseLocation()
	
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	runService.Heartbeat:Connect(Update)
end
coroutine.wrap(UPRZQSQ_fake_script)()
local function UNWSZB_fake_script() -- Exit.Close 
	local script = Instance.new('LocalScript', Exit)

	local v = false
	script.Parent.MouseButton1Down:Connect(function()
		if v == true then
			return
		end
		v = true
		script.Parent.Parent.Parent:TweenPosition(UDim2.new(.2,0,-1,-36))
		wait(1)
		script.Parent.Parent.Parent.Parent:Destroy()
	end)
end
coroutine.wrap(UNWSZB_fake_script)()
local function RCEU_fake_script() -- Btn_2.Ripple 
	local script = Instance.new('LocalScript', Btn_2)

	local Mouse = game.Players.LocalPlayer:GetMouse()
	local function CircleClick(Button, X, Y)
		coroutine.resume(coroutine.create(function()
	
			Button.ClipsDescendants = true
	
			local Circle = script:WaitForChild("Circle"):Clone()
			Circle.Parent = Button
			local NewX = X - Circle.AbsolutePosition.X
			local NewY = Y - Circle.AbsolutePosition.Y
			Circle.Position = UDim2.new(0, NewX, 0, NewY)
	
			local Size = 0
			if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
				Size = Button.AbsoluteSize.X*1.5
			elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
				Size = Button.AbsoluteSize.Y*1.5
			elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then																										Size = Button.AbsoluteSize.X*1.5
			end
	
			local Time = 0.5
			Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size/2, 0.5, -Size/2), "Out", "Quad", Time, false, nil)
			for i=0.8,1,0.01 do
				Circle.ImageTransparency = i
				wait(Time/10)
			end
			Circle:Destroy()
	
		end))
	end
	
	script.Parent.MouseButton1Down:connect(function()
		CircleClick(script.Parent, Mouse.X, Mouse.Y) 
	end)
	
	
	
end
coroutine.wrap(RCEU_fake_script)()
local function NIACXMB_fake_script() -- Chat.Manager 
	local script = Instance.new('LocalScript', Chat)

	local r
	local function s(v)
		script.Parent.Dropdown.Btn.Value.Text = v.Text
		r = v.Name
		if r == "Legacy" then
			script.Parent.Fake.TextBox.MultiLine = false
		elseif r == "New" then
			script.Parent.Fake.TextBox.MultiLine = true
		end
	end
	
	if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then
		s(script.Parent.Dropdown.Holder.New)
	else
		s(script.Parent.Dropdown.Holder.Legacy)
	end 
	
	local enabled = false
	local enabling = false
	script.Parent.Dropdown.Btn.MouseButton1Down:Connect(function()
		if enabling == true then
			return
		end
		enabling = true
		if enabled == false then
			script.Parent.Dropdown.Holder.Transparency = 0
			coroutine.wrap(function()
				for i = 0, 180, 10 do
					script.Parent.Dropdown.Btn.Ico.Rotation = i
					wait()
				end
			end)()
			local u = 0
			for i,v in pairs(script.Parent.Dropdown.Holder:GetChildren()) do
				if v:IsA("TextButton") then
					u = u + 1
				end
			end
			script.Parent.Dropdown.Holder:TweenSize(UDim2.new(1,0,0,10+(32*u)))
			wait(1)
		else
			coroutine.wrap(function()
				for i = 180, 0, -10 do
					script.Parent.Dropdown.Btn.Ico.Rotation = i
					wait()
				end
			end)()
			script.Parent.Dropdown.Holder:TweenSize(UDim2.new(1,0,0,5))
			wait(1)
			script.Parent.Dropdown.Holder.Transparency = 1
		end
		enabled = not enabled
	
		enabling = false
	end)
	for i,v in pairs(script.Parent.Dropdown.Holder:GetChildren()) do
		if v:IsA("TextButton") then
			v.MouseButton1Down:Connect(function()
				s(v)
			end)
		end
	end
	
	script.Parent.Send.Btn.MouseButton1Down:Connect(function()
		local real = script.Parent.Real.TextBox.Text
		local fake = script.Parent.Fake.TextBox.Text
		if r == "New" then
			fake = string.gsub(fake, "\n", "\r")
			game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(real..'\r'..fake)
		elseif r == "Legacy" then
			game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(real..string.sub("                                                                                                                                                           ",#real)..fake,"All")
		end
	end)
	
	script.Parent.Parent.Parent.Presets.Visible = false
	script.Parent.Presets.Btn.MouseButton1Down:Connect(function()
		script.Parent.Parent.Parent.Presets.Visible = not script.Parent.Parent.Parent.Presets.Visible
	end)
end

coroutine.wrap(NIACXMB_fake_script)()
local function KMAJZP_fake_script() -- Btn_3.Ripple 
	local script = Instance.new('LocalScript', Btn_3)

	local Mouse = game.Players.LocalPlayer:GetMouse()
	local function CircleClick(Button, X, Y)
		coroutine.resume(coroutine.create(function()
	
			Button.ClipsDescendants = true
	
			local Circle = script:WaitForChild("Circle"):Clone()
			Circle.Parent = Button
			local NewX = X - Circle.AbsolutePosition.X
			local NewY = Y - Circle.AbsolutePosition.Y
			Circle.Position = UDim2.new(0, NewX, 0, NewY)
	
			local Size = 0
			if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
				Size = Button.AbsoluteSize.X*1.5
			elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
				Size = Button.AbsoluteSize.Y*1.5
			elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then																										Size = Button.AbsoluteSize.X*1.5
			end
	
			local Time = 0.5
			Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size/2, 0.5, -Size/2), "Out", "Quad", Time, false, nil)
			for i=0.8,1,0.01 do
				Circle.ImageTransparency = i
				wait(Time/10)
			end
			Circle:Destroy()
	
		end))
	end
	
	script.Parent.MouseButton1Down:connect(function()
		CircleClick(script.Parent, Mouse.X, Mouse.Y) 
	end)
	
	
	
end
coroutine.wrap(KMAJZP_fake_script)()
local function XCOYQZF_fake_script() -- Presets_2.Smooth 
	local script = Instance.new('LocalScript', Presets_2)

	local UserInputService = game:GetService("UserInputService")
	local runService = (game:GetService("RunService"));
	
	local gui = script.Parent
	
	local dragging
	local dragInput
	local dragStart
	local startPos
	
	function Lerp(a, b, m)
		return a + (b - a) * m
	end;
	
	local lastMousePos
	local lastGoalPos
	local DRAG_SPEED = (8); -- // The speed of the UI darg.
	function Update(dt)
		if not (startPos) then return end;
		if not (dragging) and (lastGoalPos) then
			gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
			return 
		end;
	
		local delta = (lastMousePos - UserInputService:GetMouseLocation())
		local xGoal = (startPos.X.Offset - delta.X);
		local yGoal = (startPos.Y.Offset - delta.Y);
		lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
		gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
	end;
	
	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
			lastMousePos = UserInputService:GetMouseLocation()
	
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	runService.Heartbeat:Connect(Update)
end
coroutine.wrap(XCOYQZF_fake_script)()

Circle.Name = "Circle"
Circle.Parent = Btn_3:WaitForChild("LocalScript")
Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Circle.BackgroundTransparency = 1.000
Circle.ZIndex = 10
Circle.Image = "rbxassetid://266543268"
Circle.ImageColor3 = Color3.fromRGB(0, 0, 0)
Circle.ImageTransparency = 0.800

Circle_2.Name = "Circle"
Circle_2.Parent = Btn_2:WaitForChild("LocalScript")
Circle_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Circle_2.BackgroundTransparency = 1.000
Circle_2.ZIndex = 10
Circle_2.Image = "rbxassetid://266543268"
Circle_2.ImageColor3 = Color3.fromRGB(0, 0, 0)
Circle_2.ImageTransparency = 0.800

-- PRESETS

local TextButton = Instance.new("TextButton")
TextButton.Parent = ScrollingFrame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundTransparency = 1.000
TextButton.BorderSizePixel = 0
TextButton.Size = UDim2.new(1, -10, 0, 12)
TextButton.Font = Enum.Font.Gotham
TextButton.Text = "Fake admin all"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true
TextButton.MouseButton1Down:Connect(function()
	Real.TextBox.Text = ";admin all"
	Fake.TextBox.Text = "{Team} You are now on the 'Admins' team."
end)

local TextButton = Instance.new("TextButton")
TextButton.Parent = ScrollingFrame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundTransparency = 1.000
TextButton.BorderSizePixel = 0
TextButton.Size = UDim2.new(1, -10, 0, 12)
TextButton.Font = Enum.Font.Gotham
TextButton.Text = "Fake shutdown"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true
TextButton.MouseButton1Down:Connect(function()
	Real.TextBox.Text = ";shutdown"
	Fake.TextBox.Text = "[Server]: Shutting down in 60 seconds"
end)

local TextButton = Instance.new("TextButton")
TextButton.Parent = ScrollingFrame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundTransparency = 1.000
TextButton.BorderSizePixel = 0
TextButton.Size = UDim2.new(1, -10, 0, 12)
TextButton.Font = Enum.Font.Gotham
TextButton.Text = "Team join"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true
TextButton.MouseButton1Down:Connect(function()
	Real.TextBox.Text = ""
	Fake.TextBox.Text = "{Team} You are now on the 'put anything here' team."
end)

local TextButton = Instance.new("TextButton")
TextButton.Parent = ScrollingFrame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundTransparency = 1.000
TextButton.BorderSizePixel = 0
TextButton.Size = UDim2.new(1, -10, 0, 12)
TextButton.Font = Enum.Font.Gotham
TextButton.Text = "System message"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true
TextButton.MouseButton1Down:Connect(function()
	Real.TextBox.Text = ""
	Fake.TextBox.Text = "[Server]: "
end)
