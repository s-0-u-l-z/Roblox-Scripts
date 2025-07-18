local b = Instance.new("BindableFunction")
function b.OnInvoke(response) if response == "Copy Link" then if setclipboard then setclipboard("discord.gg/ujp5Uu6gKy") end end end
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Join discord server", Text = "This is mi new discord server :D", Duration = 5, Callback = b, Button1 = "Copy Link"})

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("SprinHub", "DarkTheme")

local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Main")
local Tab2 = Window:NewTab("Message")
local Section2 = Tab2:NewSection("MessageBot")
local Tab3 = Window:NewTab("Credits")
local Section3 = Tab3:NewSection("Discord Username")


Section:NewButton("GodMode", "GODMODE BRO WTF", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/MSZAznxp", true))()
end)
Section:NewButton("ControlTP", "Press control and click!!", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/rS2DBx4Y", true))()
end)
Section:NewButton("Give All TOOLS", "Detectable", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/ngVWmQ8m", true))()
end)
Section:NewButton("Instant Win", "Yeah! Finish", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.tower.sections.finish.exit.ParticleBrick.CFrame
end)
Section:NewButton("Inf Jump", "OMG JUMP JUMP", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/WUquqYN0", true))()
end) 
Section:NewSlider("WalkSpeed", "SliderInfo", 500, 0, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)
Section:NewSlider("JumpPower", "SliderInfo", 500, 0, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)
Section:NewButton("AntiKick", "Use this", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/BMGbkQ71", true))()
end)
Section:NewButton("Noclip (B)", "Noclip ok", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/Czgaerid", true))()
end)
Section:NewKeybind("KeybindText", "KeybindInfo", Enum.KeyCode.F, function()
	Library:ToggleUI()
end)
Section2:NewButton("Send Bot Message", "Okkk!!!!!", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/sqkeaRjG", true))()
end)
Section3:NewButton("Credits: Fe9z#0001", "Okkk!!!!!", function()
    print("Okkkkkkkkk")
end)

-- Game Functions --
if getconnections then
    for i,v in pairs(getconnections(game:GetService("ScriptContext").Error)) do
      v:Disable()
    end
  end
  if game.GameId == 1962086868 then
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/dqvh/dqvh/main/TohSprinHub'), true))()
    return
end
