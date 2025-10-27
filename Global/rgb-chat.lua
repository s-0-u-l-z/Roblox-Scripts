local s1 = game:GetService("TextChatService")
local s2 = game:GetService("RunService")
local s3 = game:GetService("CoreGui")

local v1 = 0.45
local t1 = {}

local function f1()
    local c = s1:FindFirstChildOfClass("BubbleChatConfiguration")
    if c then
        
        c.BackgroundColor3 = Color3.fromRGB(40, 40, 40)-- bg color cfg
        c.MaxDistance = c.MaxDistance * 2 -- bubble chat distance
        c.VerticalStudsOffset = 0.3 -- vert offset
        
        local g = c:FindFirstChildOfClass("UIGradient")
        if g then
            g:Destroy()
        end
    end
end

local function f2(i)
    if i and i:IsA("TextLabel") and i.Name == "Text" then
        if i.Parent and i.Parent.Name == "ChatBubbleFrame" then
            return true
        end
    end
    return false
end

local function f3(l)
    if t1[l] then return end
    t1[l] = true
    task.spawn(function()
        while t1[l] and l.Parent do
            local h = (tick() * v1) % 1
            l.TextColor3 = Color3.fromHSV(h, 1, 1)
            s2.Heartbeat:Wait()
        end
    end)
    l.AncestryChanged:Once(function(_, p)
        if not p then
            t1[l] = nil
        end
    end)
end

local function f4(d)
    if f2(d) then
        f3(d)
    end
end

f1()
local r = s3:FindFirstChild("ExperienceChat")
if r then
    r.DescendantAdded:Connect(f4)
    for _, d in ipairs(r:GetDescendants()) do
        if f2(d) then
            f3(d)
        end
    end
end
