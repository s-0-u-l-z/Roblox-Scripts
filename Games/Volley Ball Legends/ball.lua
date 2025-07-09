local ID = game.PlaceId
local baseURL = "https://raw.githubusercontent.com/Zayn31214/name/refs/heads/main/"
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

function GetGame()
    if ID == 73956553001240 or ID == 134314141048307 or ID == 109684591839194 or ID == 86789627188240 or ID == 6931042565 or ID == 74691681039273 or ID == 79136731857959 then
        return "HaikyuLegends.lua"
    elseif ID == 126130304767531 then
        return "MallDrifters.lua"
    elseif ID == 115815718131154 then
        return "Kuroko.lua"
    elseif ID == 18668065416 or ID == 92517437168342 or ID == 82577947590704 or ID == 99999183305180 or ID == 115110570222234 or ID == 140149476595556 or ID == 90216279544722 then
        return "BLR.lua"
    elseif ID == 99995671928896 or ID == 10290054819 then
        return "Rune.lua"
    elseif ID == 8075399143 then
        return "NinjaTime.lua"
    elseif ID == 94647229517154 then
        return "AzureLatch.lua"
    elseif ID == 122678592501168 then
        return "beaks.lua"
    elseif ID == 130739873848552 or ID == 129230994638464 or ID == 73708914208963 then
        return "BBZ.lua"
    elseif ID == 139598620873181 then
        return "Mugen.lua"
    elseif ID == 137628283909891 then
        return "Goalbound.lua"
    else
        print("Game is not supported.")
        return nil
    end
end

local gameScript = GetGame()

if gameScript then
    loadstring(game:HttpGet(baseURL .. gameScript))()
end

for _, v in next, getconnections(plr.Idled) do
    v:Disable()
end

local VirtualUser = game:GetService("VirtualUser")
local status = getgenv().afk_toggle
if status == nil then
    getgenv().afk_toggle = false
end

if not plr then
    error("Failed to get LocalPlayer reference")
end

plr.Idled:Connect(function()
    if not getgenv().afk_toggle then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)
