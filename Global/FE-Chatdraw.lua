-- Color Emoji Pixel Art Drawer
if _G.CanOpenColorDraw == 'Y' or _G.CanOpenColorDraw == nil then
    _G.CanOpenColorDraw = 'N'
    
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local UIGradient = Instance.new("UIGradient")
    local UICorner = Instance.new("UICorner")
    local TitleBase = Instance.new("TextLabel") -- Main title
    local TitlePro = Instance.new("TextLabel") -- "Pro" text
    local chat = Instance.new("TextButton")
    local UICorner_2 = Instance.new("UICorner")
    local close = Instance.new("TextButton")
    local UICorner_3 = Instance.new("UICorner")
    local ColorPalette = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    
    -- Try to parent to CoreGui first, then fallback to PlayerGui
    local success, err = pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    Frame.Parent = ScreenGui
    Frame.Active = true
    Frame.Draggable = true
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.105488181, 0, 0.147911012, 0)
    Frame.Size = UDim2.new(0.320783861, 0, 0.456124362, 0) -- Made wider and taller for bigger title
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeXX
    
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(30, 30, 30)), 
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(45, 45, 45)), 
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 30, 30))
    }
    UIGradient.Rotation = 45
    UIGradient.Parent = Frame
    
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame
    
    -- Main title (Chat Draw) - Made much bigger
    TitleBase.Name = "TitleBase"
    TitleBase.Parent = Frame
    TitleBase.BackgroundTransparency = 1
    TitleBase.Position = UDim2.new(0.02, 0, 0.01, 0)
    TitleBase.Size = UDim2.new(0, 220, 0, 45)
    TitleBase.Font = Enum.Font.GothamBold
    TitleBase.Text = "Chat Draw"
    TitleBase.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleBase.TextSize = 32.000 -- Increased from 24 to 32
    TitleBase.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Pro text with yellow color and dark yellow outline effect - Made HUGE
    TitlePro.Name = "TitlePro"
    TitlePro.Parent = Frame
    TitlePro.BackgroundTransparency = 1
    TitlePro.Position = UDim2.new(0.5, 0, 0, 0) -- Positioned in the right half
    TitlePro.Size = UDim2.new(0, 120, 0, 55)
    TitlePro.Font = Enum.Font.GothamBlack -- Bolder font
    TitlePro.Text = "PRO"
    TitlePro.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold/Yellow color
    TitlePro.TextSize = 46.000 -- Increased from 32 to 46
    TitlePro.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Create outline effect for Pro text
    local outlineEffects = {}
    local outlineOffsets = {
        {-2, -2}, {0, -2}, {2, -2},
        {-2, 0},          {2, 0},
        {-2, 2},  {0, 2},  {2, 2}
    }
    
    for _, offset in ipairs(outlineOffsets) do
        local outline = Instance.new("TextLabel")
        outline.Name = "Outline"
        outline.Parent = TitlePro
        outline.BackgroundTransparency = 1
        outline.Position = UDim2.new(0, offset[1], 0, offset[2])
        outline.Size = UDim2.new(1, 0, 1, 0)
        outline.Font = Enum.Font.GothamBlack -- Matching the main text
        outline.Text = "PRO"
        outline.TextColor3 = Color3.fromRGB(180, 140, 0) -- Dark yellow/gold
        outline.TextSize = 46.000 -- Matching the main text
        outline.TextXAlignment = Enum.TextXAlignment.Left
        outline.ZIndex = TitlePro.ZIndex - 1
        table.insert(outlineEffects, outline)
    end
    
    -- Bring the main Pro text to front
    TitlePro.ZIndex = 10
    
    chat.Name = "chat"
    chat.Parent = Frame
    chat.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    chat.BorderColor3 = Color3.fromRGB(0, 0, 0)
    chat.BorderSizePixel = 0
    chat.Position = UDim2.new(0.75, -39, 0.880470445, 0)
    chat.Size = UDim2.new(0, 70, 0, 42) -- Made bigger
    chat.Font = Enum.Font.GothamBold
    chat.Text = "Chat"
    chat.TextColor3 = Color3.fromRGB(255, 255, 255)
    chat.TextSize = 18.000 -- Increased size
    
    UICorner_2.CornerRadius = UDim.new(0, 8)
    UICorner_2.Parent = chat
    
    close.Name = "close"
    close.Parent = Frame
    close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    close.BorderColor3 = Color3.fromRGB(0, 0, 0)
    close.BorderSizePixel = 0
    close.Position = UDim2.new(0.93, 0, 0, 0)
    close.Size = UDim2.new(0.070000001, 0, 0.100000001, 0)
    close.SizeConstraint = Enum.SizeConstraint.RelativeXX
    close.Font = Enum.Font.GothamBold
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.TextSize = 16.000
    
    UICorner_3.CornerRadius = UDim.new(0, 8)
    UICorner_3.Parent = close
    
    -- Create two color palette frames for more colors
    ColorPalette = Instance.new("Frame")
    ColorPalette.Name = "ColorPalette1"
    ColorPalette.Parent = Frame
    ColorPalette.BackgroundTransparency = 1
    ColorPalette.Position = UDim2.new(0.02, 0, 0.16, 0) -- Adjusted for bigger title
    ColorPalette.Size = UDim2.new(0.96, 0, 0.06, 0)
    
    UIListLayout.Parent = ColorPalette
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0.01, 0)
    
    local ColorPalette2 = Instance.new("Frame")
    ColorPalette2.Name = "ColorPalette2"
    ColorPalette2.Parent = Frame
    ColorPalette2.BackgroundTransparency = 1
    ColorPalette2.Position = UDim2.new(0.02, 0, 0.23, 0) -- Adjusted for bigger title
    ColorPalette2.Size = UDim2.new(0.96, 0, 0.06, 0)
    
    local UIListLayout2 = Instance.new("UIListLayout")
    UIListLayout2.Parent = ColorPalette2
    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Padding = UDim.new(0.01, 0)
    
    -- Extended color emoji mapping with more colors
    local colorEmojis = {
        -- First row (standard colors)
        {name = "red", emoji = "📕", color = Color3.fromRGB(255, 0, 0), row = 1},
        {name = "green", emoji = "📗", color = Color3.fromRGB(0, 255, 0), row = 1},
        {name = "blue", emoji = "📘", color = Color3.fromRGB(0, 0, 255), row = 1},
        {name = "yellow", emoji = "📙", color = Color3.fromRGB(255, 255, 0), row = 1},
        {name = "orange", emoji = "🟧", color = Color3.fromRGB(255, 165, 0), row = 1},
        {name = "purple", emoji = "🟪", color = Color3.fromRGB(128, 0, 128), row = 1},
        {name = "black", emoji = "⬛", color = Color3.fromRGB(0, 0, 0), row = 1},
        {name = "white", emoji = "⬜", color = Color3.fromRGB(255, 255, 255), row = 1},
        
        -- Second row (additional colors)
        {name = "brown", emoji = "🟫", color = Color3.fromRGB(139, 69, 19), row = 2},
        {name = "cyan", emoji = "🟦", color = Color3.fromRGB(0, 255, 255), row = 2},
        {name = "pink", emoji = "🌸", color = Color3.fromRGB(255, 105, 180), row = 2},
        {name = "lime", emoji = "🟢", color = Color3.fromRGB(50, 205, 50), row = 2},
        {name = "gray", emoji = "⚪", color = Color3.fromRGB(128, 128, 128), row = 2},
        {name = "maroon", emoji = "🔴", color = Color3.fromRGB(128, 0, 0), row = 2},
        {name = "navy", emoji = "🔵", color = Color3.fromRGB(0, 0, 128), row = 2},
        {name = "gold", emoji = "⭐", color = Color3.fromRGB(255, 215, 0), row = 2}
    }
    
    local selectedColor = colorEmojis[1]
    local colorButtons = {}
    
    -- Create color buttons
    for i, colorInfo in ipairs(colorEmojis) do
        local parentPalette = colorInfo.row == 1 and ColorPalette or ColorPalette2
        
        local colorButton = Instance.new("TextButton")
        colorButton.Name = colorInfo.name
        colorButton.Parent = parentPalette
        colorButton.BackgroundColor3 = colorInfo.color
        colorButton.BorderSizePixel = 0
        colorButton.Size = UDim2.new(0.115, 0, 1, 0)
        colorButton.Font = Enum.Font.GothamBold
        colorButton.Text = ""
        colorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 4)
        uiCorner.Parent = colorButton
        
        colorButtons[colorInfo.name] = colorButton
        
        colorButton.MouseButton1Click:Connect(function()
            selectedColor = colorInfo
            
            -- Update button appearance
            for _, button in pairs(colorButtons) do
                button.BorderSizePixel = 0
            end
            colorButton.BorderSizePixel = 2
            colorButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
        end)
    end
    
    -- Set initial selected color
    colorButtons["red"].BorderSizePixel = 2
    colorButtons["red"].BorderColor3 = Color3.fromRGB(255, 255, 255)
    
    -- Create grid container
    local gridContainer = Instance.new("Frame")
    gridContainer.Name = "GridContainer"
    gridContainer.BackgroundTransparency = 1
    gridContainer.Position = UDim2.new(0.05, 0, 0.31, 0) -- Adjusted for bigger title
    gridContainer.Size = UDim2.new(0.9, 0, 0.55, 0)
    gridContainer.Parent = Frame
    
    -- Create grid function
    local grid = {}
    local currentGridSize = 7 -- Default grid size
    local gridSizes = {
        {width = 7, height = 7, label = "7x7"},
        {width = 11, height = 11, label = "11x11"},
        {width = 11, height = 15, label = "11x15"},
        {width = 12, height = 17, label = "12x17"} -- New size added
    }
    local currentSizeIndex = 1
    
    local function createGrid(width, height)
        -- Clear existing grid
        for _, row in pairs(grid) do
            for _, cell in pairs(row) do
                if cell.button then
                    cell.button:Destroy()
                end
            end
        end
        grid = {}
        
        -- Calculate cell size to make the grid fill the container
        local cellWidth = 1 / width
        local cellHeight = 1 / height
        local cellPadding = 0.01 -- Small gap between cells
        local actualCellWidth = cellWidth - cellPadding
        local actualCellHeight = cellHeight - cellPadding
        
        for i = 1, height do
            grid[i] = {}
            for j = 1, width do
                local button = Instance.new("TextButton")
                button.Name = i.."_"..j
                button.Size = UDim2.new(actualCellWidth, 0, actualCellHeight, 0)
                button.Position = UDim2.new((j-1) * cellWidth, 0, (i-1) * cellHeight, 0)
                button.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White grid
                button.BorderSizePixel = 0
                button.Text = ""
                button.Font = Enum.Font.GothamBold
                
                -- Adjust text size based on grid size for better appearance
                if width >= 12 or height >= 15 then
                    button.TextSize = 14 -- Smaller text for larger grids
                else
                    button.TextSize = 18
                end
                
                button.Parent = gridContainer
                
                grid[i][j] = {
                    button = button,
                    color = nil,
                    emoji = ""
                }
                
                button.MouseButton1Click:Connect(function()
                    if grid[i][j].color == selectedColor.name then
                        -- Toggle off
                        button.Text = ""
                        grid[i][j].color = nil
                        grid[i][j].emoji = ""
                        button.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Reset to white
                    else
                        -- Set new color
                        button.Text = selectedColor.emoji
                        grid[i][j].color = selectedColor.name
                        grid[i][j].emoji = selectedColor.emoji
                        button.BackgroundColor3 = Color3.fromRGB(220, 220, 220) -- Slightly darker white to show selection
                    end
                end)
            end
        end
    end
    
    -- Create initial grid
    createGrid(gridSizes[currentSizeIndex].width, gridSizes[currentSizeIndex].height)
    
    -- Function to send messages to chat (with multiple methods for reliability)
    local function sendToChat(message)
        -- Method 1: Legacy chat system
        pcall(function()
            if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.LegacyChatService then
                game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(message, "All")
            else
                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(message)
            end
        end)
        
        -- Method 2: Players Chat method (direct player chat)
        pcall(function()
            game:GetService("Players").LocalPlayer:Chat(message)
        end)
    end
    
    -- Function to force the player to chat a message
    local function forcePlayerChat(message)
        -- This makes the player say the message directly
        game:GetService("Players").LocalPlayer:Chat(message)
    end
    
    -- Announce the script in chat when it starts
    task.spawn(function()
        wait(1) -- Short delay to ensure everything is loaded
        forcePlayerChat("CHAT DRAW PRO SCRIPT MADE BY MOONER")
    end)
    
    -- Chat button functionality
    chat.MouseButton1Click:Connect(function()
        local currentSize = gridSizes[currentSizeIndex]
        
        -- Create a message to indicate what's being sent
        local infoMessage = "Sending " .. currentSize.label .. " drawing..."
        sendToChat(infoMessage)
        wait(0.1)
        
        for i = 1, currentSize.height do
            local rowText = ""
            for j = 1, currentSize.width do
                if grid[i][j].emoji ~= "" then
                    rowText = rowText .. grid[i][j].emoji
                else
                    rowText = rowText .. "⬜" -- Empty cell
                end
            end
            sendToChat(rowText)
            wait(0.1) -- Small delay to prevent chat throttling
        end
        
        -- Send completion message
        wait(0.1)
        sendToChat("Drawing complete!")
    end)
    
    -- Close button functionality
    close.MouseButton1Click:Connect(function()
        _G.CanOpenColorDraw = 'Y'
        ScreenGui:Destroy()
    end)
    
    -- Add a clear button
    local clear = Instance.new("TextButton")
    clear.Name = "clear"
    clear.Parent = Frame
    clear.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
    clear.BorderColor3 = Color3.fromRGB(0, 0, 0)
    clear.BorderSizePixel = 0
    clear.Position = UDim2.new(0.05, 0, 0.880470445, 0)
    clear.Size = UDim2.new(0, 70, 0, 42) -- Made bigger
    clear.Font = Enum.Font.GothamBold
    clear.Text = "Clear"
    clear.TextColor3 = Color3.fromRGB(255, 255, 255)
    clear.TextSize = 18.000 -- Increased size
    
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 8)
    clearCorner.Parent = clear
    
    clear.MouseButton1Click:Connect(function()
        local currentSize = gridSizes[currentSizeIndex]
        for i = 1, currentSize.height do
            for j = 1, currentSize.width do
                local cell = grid[i][j]
                if cell and cell.button then
                    cell.button.Text = ""
                    cell.color = nil
                    cell.emoji = ""
                    cell.button.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Reset to white
                end
            end
        end
    end)
    
    -- Add a fill button
    local fill = Instance.new("TextButton")
    fill.Name = "fill"
    fill.Parent = Frame
    fill.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
    fill.BorderColor3 = Color3.fromRGB(0, 0, 0)
    fill.BorderSizePixel = 0
    fill.Position = UDim2.new(0.525, 0, 0.880470445, 0)
    fill.Size = UDim2.new(0, 70, 0, 42) -- Made bigger
    fill.Font = Enum.Font.GothamBold
    fill.Text = "Fill"
    fill.TextColor3 = Color3.fromRGB(255, 255, 255)
    fill.TextSize = 18.000 -- Increased size
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 8)
    fillCorner.Parent = fill
    
    -- Add a scale button
    local scale = Instance.new("TextButton")
    scale.Name = "scale"
    scale.Parent = Frame
    scale.BackgroundColor3 = Color3.fromRGB(80, 140, 180) -- Blue-ish color
    scale.BorderColor3 = Color3.fromRGB(0, 0, 0)
    scale.BorderSizePixel = 0
    scale.Position = UDim2.new(0.2875, 0, 0.880470445, 0) -- Position between Clear and Fill
    scale.Size = UDim2.new(0, 70, 0, 42) -- Made bigger
    scale.Font = Enum.Font.GothamBold
    scale.Text = gridSizes[currentSizeIndex].label
    scale.TextColor3 = Color3.fromRGB(255, 255, 255)
    scale.TextSize = 18.000 -- Increased size
    
    local scaleCorner = Instance.new("UICorner")
    scaleCorner.CornerRadius = UDim.new(0, 8)
    scaleCorner.Parent = scale
    
    -- Create tooltip for scale button
    local scaleTooltip = Instance.new("TextLabel")
    scaleTooltip.Name = "ScaleTooltip"
    scaleTooltip.Parent = Frame
    scaleTooltip.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    scaleTooltip.BorderSizePixel = 0
    scaleTooltip.Position = UDim2.new(0.2875, 0, 0.83, 0)
    scaleTooltip.Size = UDim2.new(0, 100, 0, 20)
    scaleTooltip.Font = Enum.Font.Gotham
    scaleTooltip.Text = "Grid Size"
    scaleTooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
    scaleTooltip.TextSize = 12.000
    scaleTooltip.Visible = false
    
    local tooltipCorner = Instance.new("UICorner")
    tooltipCorner.CornerRadius = UDim.new(0, 4)
    tooltipCorner.Parent = scaleTooltip
    
    -- Show tooltip on hover
    scale.MouseEnter:Connect(function()
        scaleTooltip.Visible = true
    end)
    
    scale.MouseLeave:Connect(function()
        scaleTooltip.Visible = false
    end)
    
    -- Scale button functionality
    scale.MouseButton1Click:Connect(function()
        -- Cycle through grid sizes
        currentSizeIndex = (currentSizeIndex % #gridSizes) + 1
        local newSize = gridSizes[currentSizeIndex]
        
        -- Update button text
        scale.Text = newSize.label
        
        -- Recreate grid with new size
        createGrid(newSize.width, newSize.height)
    end)
    
    fill.MouseButton1Click:Connect(function()
        local currentSize = gridSizes[currentSizeIndex]
        for i = 1, currentSize.height do
            for j = 1, currentSize.width do
                local cell = grid[i][j]
                if cell and cell.button then
                    cell.button.Text = selectedColor.emoji
                    cell.color = selectedColor.name
                    cell.emoji = selectedColor.emoji
                    cell.button.BackgroundColor3 = Color3.fromRGB(220, 220, 220) -- Slightly darker white
                end
            end
        end
    end)
    
    -- Animate gradient
    local function CVXH_fake_script()
        local script = Instance.new('LocalScript', UIGradient)
        
        local RunService = game:GetService("RunService")
        local ROTATE_SPEED = 15
        local uiGradient = script.Parent
        
        local function onRenderStep(deltaTime)
            local currentRotation = uiGradient.Rotation
            uiGradient.Rotation = (currentRotation + ROTATE_SPEED * deltaTime) % 360
        end
        
        RunService.RenderStepped:Connect(onRenderStep)
    end
    coroutine.wrap(CVXH_fake_script)()
    end
