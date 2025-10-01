-- Always-On Hitbox Expander

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- Settings
local Size = 25               -- hitbox size
local TeamCheck = false       -- set true if you don’t want to expand teammates

RunService.Heartbeat:Connect(function()
    local localTeam = LocalPlayer.Team
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and (not TeamCheck or player.Team ~= localTeam) then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and hrp:IsDescendantOf(workspace) then
                    hrp.Size = Vector3.new(Size, Size, Size)
                    hrp.Transparency = 0.7
                    hrp.BrickColor = BrickColor.new("Really blue")
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                end
            end
        end
    end
end)
