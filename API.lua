discordId = '347818082787393539'


getgenv().sendReq = true

local Lib = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while not Lib.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end;

local Save = Lib.Save.Get
local Commas = Lib.Functions.Commas
local types = {}
local menus = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right
for i, v in pairs(menus:GetChildren()) do
    if v.ClassName == 'Frame' and v.Name ~= 'Rank' and not string.find(v.Name, "2") then
        table.insert(types, v.Name)
    end
end
currentStats = {}
function get(thistype)
    return Save()[thistype]
end
for i,v in pairs(types) do
    spawn(function()
        local megatable = {}
        local imaginaryi = 1
        local ptime = 0
        local last = tick()
        local now = last
        local TICK_TIME = 0.5
        while (getgenv().sendReq) do
            if ptime >= TICK_TIME then
                while ptime >= TICK_TIME do ptime = ptime - TICK_TIME end
                local currentbal = get(v)
                megatable[imaginaryi] = currentbal
                local diffy = currentbal - (megatable[imaginaryi-120] or megatable[1])
                imaginaryi = imaginaryi + 1
                currentStats[v] = tostring(Commas(diffy))
            end
            task.wait(0.001)
            now = tick()
            ptime = ptime + (now - last)
            last = now
        end
    end)
end

function connect()
    save = Lib.Save.Get()
    dataTable = {
        ["username"] = game:GetService("Players").LocalPlayer.Name,
        ["userid"] = tostring(game:GetService("Players").LocalPlayer.UserId),
        ["jobid"] = tostring(game.JobId),
        ["displayname"] = game:GetService("Players").LocalPlayer.DisplayName,
        ["totalpets"] = tostring(#save.Pets),
        ["gems"] = tostring(Commas(math.floor(save["Diamonds"]))),
        ["coins"] = tostring(Commas(math.floor(save["Coins"]))),
        ["tech"] = tostring(Commas(math.floor(save["Tech Coins"]))),
        ["fantasy"] = tostring(Commas(math.floor(save["Fantasy Coins"]))),
        ["stats"] = currentStats,
        ["discordid"] = discordId
    }
    sendTable = game:GetService("HttpService"):JSONEncode(dataTable)
    local headers = {
       ["content-type"] = "application/json"
    }
    request = http_request or request or HttpPost or syn.request
    sendData = {Url = "https://testdiscordbot.4lve.repl.co/newconnection", Body = sendTable, Method = "POST", Headers = headers}
    request(sendData)
end
connect()

wait(3)
while getgenv().sendReq do
	local headers = {
		["content-type"] = "application/json"
	}
    dataTable = {
        ["username"] = game:GetService("Players").LocalPlayer.Name,
        ["userid"] = tostring(game:GetService("Players").LocalPlayer.UserId),
        ["jobid"] = tostring(game.JobId),
        ["displayname"] = game:GetService("Players").LocalPlayer.DisplayName,
        ["totalpets"] = tostring(#save.Pets),
        ["gems"] = tostring(math.floor(save["Diamonds"])),
        ["coins"] = tostring(math.floor(save["Coins"])),
        ["tech"] = tostring(math.floor(save["Tech Coins"])),
        ["fantasy"] = tostring(math.floor(save["Fantasy Coins"])),
        ["stats"] = currentStats
    }
    sendTable = game:GetService("HttpService"):JSONEncode(dataTable)
    request = http_request or request or HttpPost or syn.request
    sendData = {Url = "https://testdiscordbot.4lve.repl.co/update", Body = sendTable, Method = "POST", Headers = headers}
    data = (request(sendData))
    if not data then
        wait(10)
        connect()
    end
    
    if (data["Body"] == "stop") then
        getgenv().sendReq = false
    elseif (data["Body"] == "reconnect") then
        connect()
    end
    wait(10)
end
