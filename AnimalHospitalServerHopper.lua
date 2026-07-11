-- garbage source omfg
-- don't skid or do idc but skidding is bad id prefer you not

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local Fertilizer = loadstring(game:HttpGet("https://raw.githubusercontent.com/linear-org/linear/refs/heads/main/utilities/fertilizer.lua"))()
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/christmas-cookie/Main/refs/heads/main/WindUI-Boreal-Fix.lua"))()

local Values = {}

if isfile("linearhopperforah") then
    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile("linearhopperforah"))
    end)
    if success and type(result) == "table" then
        Values.Blacklist = result
    end
end

local Window = WindUI:CreateWindow({
    Title = "linear | Animal Hospital Hopper",
    Icon = Fertilizer.CustomImage({link = "https://raw.githubusercontent.com/christmas-cookie/linear/refs/heads/main/assets/image/icon.png"}),
    Folder = "linear",
    NewElements = true,
    SearchBar = true,
    Size = UDim2.fromOffset(550, 320),
    Transparent = true, 
    Theme = "Plant",
    User = {
        Enabled = true,
        Anonymous = false, 
    }, 
    OpenButton = {
		Title = "Open linear",
		CornerRadius = UDim.new(1, 0),
		StrokeThickness = 2,
		Enabled = true,
		Draggable = true,
		OnlyMobile = false,
		Scale = 0.67,
		Color = ColorSequence.new(
			Color3.fromHex("#1B362F"),
			Color3.fromHex("#13A777")
		),
	},
	Topbar = {
		Height = 44,
		ButtonsType = "Mac",
	},    
})

Window:Tag({
    Title = "stable-1",
    Icon = "github",
    Color = Color3.fromHex("#13A777"),
})

local InfoTab = Window:Tab({
    Title = "Information",
    Icon = "gravity:circle-info",
    Border = true,
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "gravity:house",
    Border = true,
})

MainTab:Select()

InfoTab:Paragraph({
    Title = "What is this?",
    Desc = "This is a script library made by the owners of linear to help you get a crazy amount of ‘furthest shift’ in 4 to 5 minutes. There's even a chance that you get into the leaderboard.",
})

InfoTab:Paragraph({
    Title = "How to use this?",
    Desc = "Click the button that says ‘Join Stacked Server’, it will teleport you into a server with a very high shift.",
})

InfoTab:Paragraph({
    Title = "What to do after joining one?",
    Desc = "After joining a stacked server, all you have to do is survive one singular shift. The counter on the top will show it as ‘Shift 1’, but the real shift you're in can be found in the main tab.",
})

InfoTab:Paragraph({
    Title = "I survived one shift, what now?",
    Desc = "If the shift value of that server reached is higher than your highest shift, your highest shift will now be that server's shift value, letting you reach crazy values like 500 and more.",
})

InfoTab:Paragraph({
    Title = "What's Job ID?",
    Desc = "It is an identifier of that server, if you got a job id, you can use that to instantly join that server, you can also share your own server's job id.",
})

InfoTab:Paragraph({
    Title = "What's blacklist?",
    Desc = "Blacklist permanently blacklists the server you're in, to prevent joining the same server over and over, if you'd like, you can turn it off or clear it.",
})

local Joiner = MainTab:Section({
    Title = "Joiner",
    Icon = "gravity:envelope-open",
    Box = true,
    BoxBorder = true,
    Opened = true,
})

local Shifty = Joiner:Paragraph({
    Title = "Shift: " .. tostring(Players:GetAttribute("Night") or "I don't know")
})

Players:GetAttributeChangedSignal("Night"):Connect(function()
    local new = Players:GetAttribute("Night")
    Shifty:SetTitle("Shift: " .. tostring(new))
end)

Joiner:Button({
    Title = "Join Stacked Server",
    Callback = function()
        local currentjob = game.JobId
        local placeid = game.PlaceId
        local blacklist = Values.Blacklist or {}
        local shallblacklist = true        
        if Values.ShallBlacklist ~= nil then
            shallblacklist = Values.ShallBlacklist
        end     
        if shallblacklist and not table.find(blacklist, currentjob) then
            table.insert(blacklist, currentjob)
            Values.Blacklist = blacklist
            pcall(function()
                writefile("linearhopperforah", HttpService:JSONEncode(blacklist))
            end)
        end       
        local apiurl = "https://games.roblox.com/v1/games/" .. placeid .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"
        local success, result = pcall(game.HttpGet, game, apiurl)        
        if success and result then
            local body = HttpService:JSONDecode(result)
            local targetserver = nil          
            if body and body.data then
                for fart, server in next, body.data do
                    if server.id ~= currentjob and not table.find(blacklist, server.id) then
                        if server.playing < server.maxPlayers then
                            targetserver = server.id
                            break
                        end
                    end
                end
            end           
            if targetserver then
                TeleportService:TeleportToPlaceInstance(placeid, targetserver, Players.LocalPlayer)
            end
        end
    end
})

Joiner:Toggle({
    Title = "Shall Blacklist",
    Value = Values.ShallBlacklist or true,
    Callback = function(state)
        Values.ShallBlacklist = state
    end
})

Joiner:Button({
    Title = "Clear Blacklist",
    Callback = function()
        Values.Blacklist = {}
        pcall(function()
            writefile("linearhopperforah", HttpService:JSONEncode({}))
        end)
    end
})

Joiner:Divider()

Joiner:Input({
    Title = "Job ID",
    Callback = function(text)
        Values.targetjob = text
    end
})

Joiner:Button({
    Title = "Join Server",
    Callback = function()
        if Values.targetjob and Values.targetjob ~= "" then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, Values.targetjob, Players.LocalPlayer)
            end)
        end
    end
})

Joiner:Button({
    Title = "Copy Job ID",
    Callback = function()
        toclipboard(game.JobId)
    end
})
