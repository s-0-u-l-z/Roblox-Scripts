local Targets = {"All"} -- "All", "Target Name", "arian_was_here"

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local AllBool = false

local function GetPlayer(Name)
    Name = Name:lower()
    if Name == "all" or Name == "others" then
        AllBool = true
        return
    elseif Name == "random" then
        local GetPlayers = Players:GetPlayers()
        table.remove(GetPlayers, table.find(GetPlayers, Player))
        return GetPlayers[math.random(#GetPlayers)]
    else
        for _, x in next, Players:GetPlayers() do
            if x ~= Player then
                if x.Name:lower():match("^" .. Name) or x.DisplayName:lower():match("^" .. Name) then
                    return x
                end
            end
        end
    end
end

local function Message(_Title, _Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = _Title,
        Text = _Text,
        Duration = Time
    })
end

local function SkidFling(TargetPlayer)
    if not TargetPlayer.Character then return end

    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit and not AllBool then
            return Message("Error Occurred", "Targeting is sitting", 5)
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end

        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(RootPart.CFrame)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        local SFBasePart = function(BasePart)
            local TimeToWait = 2
            local StartTime = tick()
            local Angle = 0

            repeat
                if not (RootPart and THumanoid) then break end

                local Vel = BasePart.Velocity.Magnitude
                Angle = Angle + 100

                if Vel < 50 then
                    for _, offset in ipairs({
                        CFrame.new(0, 1.5, 0),
                        CFrame.new(0, -1.5, 0),
                        CFrame.new(2.25, 1.5, -2.25),
                        CFrame.new(-2.25, -1.5, 2.25),
                        CFrame.new(0, 1.5, 0),
                        CFrame.new(0, -1.5, 0)
                    }) do
                        FPos(BasePart, offset + THumanoid.MoveDirection * Vel / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    end
                else
                    for _, offset in ipairs({
                        CFrame.new(0, 1.5, THumanoid.WalkSpeed),
                        CFrame.new(0, -1.5, -THumanoid.WalkSpeed),
                        CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25),
                        CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25),
                        CFrame.new(0, -1.5, 0),
                        CFrame.new(0, -1.5, 0),
                        CFrame.new(0, -1.5, 0)
                    }) do
                        FPos(BasePart, offset, CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                    end
                end
            until BasePart.Velocity.Magnitude > 500
                or BasePart.Parent ~= TargetPlayer.Character
                or TargetPlayer.Parent ~= Players
                or TargetPlayer.Character ~= TCharacter
                or (THumanoid and THumanoid.Sit)
                or Humanoid.Health <= 0
                or tick() > StartTime + TimeToWait
        end

        workspace.FallenPartsDestroyHeight = 0 / 0

        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        if TRootPart and THead and (TRootPart.Position - THead.Position).Magnitude > 5 then
            SFBasePart(THead)
        elseif TRootPart then
            SFBasePart(TRootPart)
        elseif THead then
            SFBasePart(THead)
        elseif Handle then
            SFBasePart(Handle)
        else
            return Message("Error Occurred", "Target is missing all parts", 5)
        end

        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid

        repeat
            local newPos = getgenv().OldPos * CFrame.new(0, .5, 0)
            RootPart.CFrame = newPos
            Character:SetPrimaryPartCFrame(newPos)
            Humanoid:ChangeState("GettingUp")

            for _, x in pairs(Character:GetChildren()) do
                if x:IsA("BasePart") then
                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                end
            end
            task.wait()
        until (RootPart.Position - getgenv().OldPos.Position).Magnitude < 25

        workspace.FallenPartsDestroyHeight = getgenv().FPDH or -500
    else
        Message("Error Occurred", "Invalid character state", 5)
    end
end

-- Initialization
if not getgenv().Welcome then
    Message("Script by AnthonyIsntHere", "Enjoy!", 5)
end
getgenv().Welcome = true

local PlayersToFling = {}

for _, name in next, Targets do
    local found = GetPlayer(name)
    if AllBool then break end
    if found and found ~= Player then
        if found.UserId ~= 1414978355 then
            table.insert(PlayersToFling, found)
        else
            Message("Error Occurred", "This user is whitelisted! (Owner)", 5)
        end
    elseif not found and not AllBool then
        Message("Error Occurred", "Username Invalid: " .. name, 5)
    end
end

if AllBool then
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then SkidFling(p) end
    end
else
    for _, p in pairs(PlayersToFling) do
        SkidFling(p)
    end
end
