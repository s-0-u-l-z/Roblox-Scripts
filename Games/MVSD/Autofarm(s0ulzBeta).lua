-- Discord UI - Unified MAIN/ALT Script Controller
local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()

-- ===== SHARED CONFIG =====
local URL_BASE_MAIN = "http://10.0.244:3000"
local URL_BASE_ALT = "http://10.0.0.244:3000"
local RIGHT_PAD = CFrame.new(31.331600189208984, -114.50340270990094, 57.633598327663672)
local LEFT_PAD = CFrame.new(37.70157241821289, -114.503341796875, 57.47218322753906)
local POLL_INTERVAL = 3.0
local MAIN_COUNT = 5
local SHOOT_DELAY = 7
local TARGET_USERNAME = "imrockhard_123"
-- ===================

-- ===== SCRIPT STATE VARIABLES =====
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local scriptRunning = false
local currentMode = "MAIN"
local scriptCoroutine = nil

-- ===== HTTP REQUEST METHOD DETECTION =====
local REQ = nil

-- List of possible HTTP request functions
local httpChecks = {
    -- Base Roblox-like http libraries
    ["http.get"] = function()
        if http and type(http.get) == "function" then
            return pcall(function() return http.get("https://example.com") end)
        end
    end,
    ["http.request"] = function()
        if http and type(http.request) == "function" then
            return pcall(function() return http.request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["http_request"] = function()
        if type(http_request) == "function" then
            return pcall(function() return http_request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["request"] = function()
        if type(request) == "function" then
            return pcall(function() return request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["request_http"] = function()
        if type(request_http) == "function" then
            return pcall(function() return request_http({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["request.get"] = function()
        if request and type(request.get) == "function" then
            return pcall(function() return request.get("https://example.com") end)
        end
    end,

    -- Synapse and common executors
    ["syn.request"] = function()
        if syn and type(syn.request) == "function" then
            return pcall(function() return syn.request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["krnl.request"] = function()
        if krnl and type(krnl.request) == "function" then
            return pcall(function() return krnl.request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["oxygen.request"] = function()
        if oxygen and type(oxygen.request) == "function" then
            return pcall(function() return oxygen.request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["zenith.request"] = function()
        if zenith and type(zenith.request) == "function" then
            return pcall(function() return zenith.request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["solara.request"] = function()
        if solara and type(solara.request) == "function" then
            return pcall(function() return solara.request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["fluxus.request"] = function()
        if fluxus and type(fluxus.request) == "function" then
            return pcall(function() return fluxus.request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["electron.request"] = function()
        if electron and type(electron.request) == "function" then
            return pcall(function() return electron.request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["scriptware.request"] = function()
        if scriptware and type(scriptware.request) == "function" then
            return pcall(function() return scriptware.request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["delta.request"] = function()
        if delta and type(delta.request) == "function" then
            return pcall(function() return delta.request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["valyse.request"] = function()
        if valyse and type(valyse.request) == "function" then
            return pcall(function() return valyse.request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["codex.request"] = function()
        if codex and type(codex.request) == "function" then
            return pcall(function() return codex.request({Url="https://example.com", Method="GET"}) end)
        end
    end,
    ["requests.get"] = function()
        if requests and type(requests.get) == "function" then
            return pcall(function() return requests.get("https://example.com") end)
        end
    end,
}

-- Test each one and pick the first that works
for name, tester in pairs(httpChecks) do
    local ok, result = tester()
    if ok and result then
        print("✅ " .. name .. " works!")
        REQ = tester -- store the working method wrapper
        break
    else
        print("❌ " .. name .. " failed!")
    end
end

-- ===== SHARED FUNCTIONS =====
local function httpGet(url)
    if not REQ then return nil end
    local ok, res = pcall(function() return REQ({ Url = url, Method = "GET" }) end)
    if not ok or not res or tonumber(res.StatusCode) ~= 200 then return nil end
    return res.Body
end

local function httpPost(url, tbl)
    if not REQ then return nil end
    local body = HttpService:JSONEncode(tbl)
    local ok, res = pcall(function()
        return REQ({
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body
        })
    end)
    if not ok or not res or tonumber(res.StatusCode) ~= 200 then return nil end
    return res.Body
end

local function tpToPad(cf)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    pcall(function() hrp.CFrame = cf end)
end

local function isInGameByTeam()
    local team = LocalPlayer.Team
    if not team then return false end
    local name = tostring(team.Name or team)
    name = string.lower(name)
    return name == "1" or name == "2" or string.find(name, "1", 1, true) or string.find(name, "2", 1, true)
end

-- ===== MAIN SCRIPT FUNCTIONS =====
local function scanForTargetPlayer()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Name == TARGET_USERNAME then
            if player.Character and player.Character:FindFirstChild("LeftUpperArm") then
                local leftUpperArm = player.Character.LeftUpperArm
                if leftUpperArm:FindFirstChild("Part") then
                    return player, leftUpperArm.Part
                end
            end
            return player, nil
        end
    end
    return nil, nil
end

local function equipSecondWeapon()
    local inventory = LocalPlayer:FindFirstChild("Backpack")
    if not inventory then return false end

    local items = inventory:GetChildren()
    table.sort(items, function(a, b) return a:GetDebugId() < b:GetDebugId() end)

    if #items >= 2 then
        local secondWeapon = items[2]
        if secondWeapon then
            secondWeapon.Parent = LocalPlayer.Character
            return true
        end
    end
    return false
end

local function equipAndShootTarget(targetPlayer, targetPart)
    if not equipSecondWeapon() then return end
    
    local args = {
        vector.create(-174.95948791503906, 165.3748779296875, -1.7110586166381836),
        vector.create(-176.19561767578125, 144.7963409423828, 51.71797180175781),
        targetPart,
        vector.create(-175.43002319335938, 166.70974731445312, 6.782278537750244)
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ShootGun"):FireServer(unpack(args))
end

local function equipAndShoot()
    if not equipSecondWeapon() then return end
    
    local args = {
        vector.create(-174.95948791503906, 165.3748779296875, -1.7110586166381836),
        vector.create(-176.19561767578125, 144.7963409423828, 51.71797180175781),
        game:GetService("Players"):WaitForChild("AsianEatCatDog1").Character:WaitForChild("LeftUpperArm"):WaitForChild("Part"),
        vector.create(-175.43002319335938, 166.70974731445312, 6.782278537750244)
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ShootGun"):FireServer(unpack(args))
end

-- ===== MAIN SCRIPT LOGIC =====
local function runMainScript()
    local targetCFrame = RIGHT_PAD
    
    -- Continuous teleport loop
    spawn(function()
        while scriptRunning and currentMode == "MAIN" do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
            end
            task.wait(1)
        end
    end)
    
    while scriptRunning and currentMode == "MAIN" do
        tpToPad(RIGHT_PAD)
        task.wait(3)

        local inGameLocal = isInGameByTeam()

        local roundId, altCount
        while scriptRunning and currentMode == "MAIN" do
            local body = httpGet(URL_BASE_MAIN .. "/ingame")
            if body then
                local data; pcall(function() data = HttpService:JSONDecode(body) end)
                if data and data.ok and data.inGame and data.roundId and (data.count ~= nil) then
                    roundId = data.roundId
                    altCount = data.count
                    
                    task.wait(5)
                    
                    local targetPlayer, targetPart = scanForTargetPlayer()
                    if targetPlayer then
                        if targetPart then
                            equipAndShootTarget(targetPlayer, targetPart)
                        else
                            for i = 1, 3 do
                                task.wait(1)
                                _, targetPart = scanForTargetPlayer()
                                if targetPart then
                                    equipAndShootTarget(targetPlayer, targetPart)
                                    break
                                end
                            end
                        end
                    end
                    
                    break
                end
            end
            if not scriptRunning or currentMode ~= "MAIN" then return end
            task.wait(POLL_INTERVAL)
        end

        if not scriptRunning or currentMode ~= "MAIN" then return end

        while scriptRunning and currentMode == "MAIN" do
            local body = httpGet(URL_BASE_MAIN .. "/status")
            if body then
                local data; pcall(function() data = HttpService:JSONDecode(body) end)
                if data and data.ok and data.roundId == roundId and data.altDone then
                    break
                end
            end
            if not scriptRunning or currentMode ~= "MAIN" then return end
            task.wait(POLL_INTERVAL)
        end

        for i = 1, MAIN_COUNT do
            if not scriptRunning or currentMode ~= "MAIN" then return end
            task.wait(SHOOT_DELAY)
            equipAndShoot()
        end

        httpPost(URL_BASE_MAIN .. "/finish", { roundId = roundId })
        task.wait(POLL_INTERVAL)
    end
end

-- ===== ALT SCRIPT LOGIC =====
local function runAltScript()
    while scriptRunning and currentMode == "ALT" do
        tpToPad(LEFT_PAD)
        task.wait(8)
        
        local inGame = isInGameByTeam()
        if inGame then
            local count = math.random(0,4)
            local sent = httpPost(URL_BASE_ALT .. "/alt/ingame", { inGame = true, count = count })
            if sent then
                local resp; pcall(function() resp = HttpService:JSONDecode(sent) end)
                if resp and resp.ok and resp.roundId then
                    for i = 1, count do
                        if not scriptRunning or currentMode ~= "ALT" then return end
                        task.wait(math.random(1,7))
                    end
                    httpPost(URL_BASE_ALT .. "/alt/done", { roundId = resp.roundId })
                end
            end
        end
        if not scriptRunning or currentMode ~= "ALT" then return end
        task.wait(POLL_INTERVAL)
    end
end

-- ===== GUI CREATION =====
local win = DiscordLib:Window("MAIN/ALT Unified Controller")

-- Control Panel Server
local controlServ = win:Server("Control Panel", "")

-- Script Control Channel
local controlChannel = controlServ:Channel("Script Control")

controlChannel:Toggle("Enable Script", false, function(enabled)
    scriptRunning = enabled
    
    if scriptCoroutine then
        task.cancel(scriptCoroutine)
        scriptCoroutine = nil
    end
    
    if enabled then
        DiscordLib:Notification("Script Started", "Running in " .. currentMode .. " mode", "OK")
        if currentMode == "MAIN" then
            scriptCoroutine = task.spawn(runMainScript)
        else
            scriptCoroutine = task.spawn(runAltScript)
        end
    else
        DiscordLib:Notification("Script Stopped", "Script has been disabled", "OK")
    end
end)

controlChannel:Seperator()

controlChannel:Dropdown("Script Mode", {"MAIN", "ALT"}, function(selected)
    local wasRunning = scriptRunning
    
    -- Stop current script
    scriptRunning = false
    if scriptCoroutine then
        task.cancel(scriptCoroutine)
        scriptCoroutine = nil
    end
    
    task.wait(0.5)
    
    currentMode = selected
    DiscordLib:Notification("Mode Changed", "Switched to " .. selected .. " mode", "OK")
    
    -- Restart if it was running
    if wasRunning then
        scriptRunning = true
        if currentMode == "MAIN" then
            scriptCoroutine = task.spawn(runMainScript)
        else
            scriptCoroutine = task.spawn(runAltScript)
        end
    end
end)

-- Configuration Channel
local configChannel = controlServ:Channel("Configuration")

configChannel:Textbox("Target Username", TARGET_USERNAME, true, function(text)
    TARGET_USERNAME = text
    DiscordLib:Notification("Config Updated", "Target username: " .. text, "OK")
end)

configChannel:Textbox("Main Server URL", URL_BASE_MAIN, true, function(text)
    URL_BASE_MAIN = text
    DiscordLib:Notification("Config Updated", "Main server URL updated", "OK")
end)

configChannel:Textbox("Alt Server URL", URL_BASE_ALT, true, function(text)
    URL_BASE_ALT = text
    DiscordLib:Notification("Config Updated", "Alt server URL updated", "OK")
end)

configChannel:Slider("Shoot Delay", 1, 15, SHOOT_DELAY, function(value)
    SHOOT_DELAY = value
end)

configChannel:Slider("Main Kill Count", 1, 10, MAIN_COUNT, function(value)
    MAIN_COUNT = value
end)

configChannel:Slider("Poll Interval", 1, 10, POLL_INTERVAL, function(value)
    POLL_INTERVAL = value
end)

-- Actions Channel
local actionsChannel = controlServ:Channel("Manual Actions")

actionsChannel:Button("Manual Kill (MAIN)", function()
    if equipSecondWeapon() then
        equipAndShoot()
        DiscordLib:Notification("Manual Kill", "MAIN kill executed manually", "OK")
    else
        DiscordLib:Notification("Error", "Could not equip weapon", "OK")
    end
end)

actionsChannel:Button("Target Kill", function()
    local targetPlayer, targetPart = scanForTargetPlayer()
    if targetPlayer and targetPart then
        equipAndShootTarget(targetPlayer, targetPart)
        DiscordLib:Notification("Target Kill", "Killed target: " .. targetPlayer.Name, "OK")
    else
        DiscordLib:Notification("Target Kill", "Target player not found", "OK")
    end
end)

actionsChannel:Button("Test HTTP", function()
    if REQ then
        DiscordLib:Notification("HTTP Test", "HTTP method is working!", "OK")
    else
        DiscordLib:Notification("HTTP Test", "No HTTP method detected!", "Error")
    end
end)

actionsChannel:Button("Force Stop", function()
    scriptRunning = false
    if scriptCoroutine then
        task.cancel(scriptCoroutine)
        scriptCoroutine = nil
    end
    DiscordLib:Notification("Force Stop", "Script force stopped", "OK")
end)

-- Status Server
local statusServ = win:Server("Status", "")
local statusChannel = statusServ:Channel("Current Status")

statusChannel:Label("Script Status: Ready")
statusChannel:Label("HTTP Method: " .. (REQ and "Detected" or "Not Found"))
statusChannel:Label("Current Mode: " .. currentMode)
statusChannel:Label("Target Username: " .. TARGET_USERNAME)

-- Info Channel
local infoChannel = statusServ:Channel("Information")
infoChannel:Label("MAIN Mode: Targets specific player")
infoChannel:Label("ALT Mode: Random placeholder kills")
infoChannel:Label("Auto HTTP method detection")
infoChannel:Label("Real-time configuration")
infoChannel:Label("Manual control options")

-- Settings Server
local settingsServ = win:Server("Advanced Settings", "")
local debugChannel = settingsServ:Channel("Debug Options")

debugChannel:Button("Print All Players", function()
    print("=== PLAYER LIST ===")
    for _, player in pairs(Players:GetPlayers()) do
        print("Player: " .. player.Name .. " (Team: " .. tostring(player.Team) .. ")")
    end
    DiscordLib:Notification("Debug", "Player list printed to console", "OK")
end)

debugChannel:Button("Test Team Check", function()
    local inGame = isInGameByTeam()
    DiscordLib:Notification("Team Check", "In Game: " .. tostring(inGame), "OK")
end)

debugChannel:Button("Scan for Target", function()
    local targetPlayer, targetPart = scanForTargetPlayer()
    if targetPlayer then
        DiscordLib:Notification("Target Scan", "Found: " .. targetPlayer.Name, "OK")
    else
        DiscordLib:Notification("Target Scan", "Target not found", "OK")
    end
end)

-- Initialization
if REQ then
    DiscordLib:Notification("Initialization", "Script loaded successfully!", "OK")
else
    DiscordLib:Notification("Warning", "No HTTP method detected!", "OK")
end

print("[UNIFIED SCRIPT] Loaded successfully - Mode:", currentMode)
print("[HTTP DETECTION] Status:", REQ and "Working" or "Failed")
