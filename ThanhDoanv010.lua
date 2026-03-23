-- THANH DOAN HUB V1

if game.CoreGui:FindFirstChild("ThanhDoanHub") then
game.CoreGui.ThanhDoanHub:Destroy()
end

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local visitedServers = {}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "ThanhDoanHub"

-- BLUR
local blur = Instance.new("BlurEffect")
blur.Size = 18
blur.Parent = Lighting

-- FRAME (GLASS UI)
local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,320,0,300)
frame.Position = UDim2.new(0.5,-160,0.5,-150)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BackgroundTransparency = 0.25
frame.Active = true
frame.Draggable = true

-- GLOW
local stroke = Instance.new("UIStroke",frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0,255,255)

local gradient = Instance.new("UIGradient",frame)
gradient.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.fromRGB(0,255,255)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,255))
}

-- TITLE
local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "Thanh Đoàn Hub V1"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)

-- INFO
local info = Instance.new("TextLabel",frame)
info.Size = UDim2.new(1,0,0,30)
info.Position = UDim2.new(0,0,0,35)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.fromRGB(255,255,255)

-- BUTTON MAKER
local function button(text,pos)

local b = Instance.new("TextButton",frame)
b.Size = UDim2.new(1,-20,0,40)
b.Position = UDim2.new(0,10,0,pos)
b.Text = text
b.BackgroundColor3 = Color3.fromRGB(40,40,40)
b.TextColor3 = Color3.fromRGB(255,255,255)

return b

end

local hopBtn = button("Smart Server Hop",70)
local scanBtn = button("Scan Servers",120)
local fpsBtn = button("FPS Boost",170)
local afkBtn = button("Anti AFK",220)
local tpBtn = button("Teleport Map",270)

-- SMART SERVER HOP
local function hopServer()

local cursor = ""

repeat

local url =
"https://games.roblox.com/v1/games/"..
game.PlaceId..
"/servers/Public?sortOrder=Asc&limit=100&cursor="..cursor

local data = HttpService:JSONDecode(game:HttpGet(url))

for _,v in pairs(data.data) do

if v.playing < v.maxPlayers and not visitedServers[v.id] then

visitedServers[v.id] = true

TeleportService:TeleportToPlaceInstance(
game.PlaceId,
v.id,
player
)

return

end

end

cursor = data.nextPageCursor or ""

until cursor == ""

end

hopBtn.MouseButton1Click:Connect(hopServer)

-- SERVER SCANNER
scanBtn.MouseButton1Click:Connect(function()

local total = 0
local cursor = ""

repeat

local url =
"https://games.roblox.com/v1/games/"..
game.PlaceId..
"/servers/Public?sortOrder=Asc&limit=100&cursor="..cursor

local data = HttpService:JSONDecode(game:HttpGet(url))

for _,v in pairs(data.data) do
if v.playing < v.maxPlayers then
total = total + 1
end
end

cursor = data.nextPageCursor or ""

until cursor == ""

info.Text = "Servers Found: "..total

end)

-- FPS BOOST
fpsBtn.MouseButton1Click:Connect(function()

for _,v in pairs(game:GetDescendants()) do

if v:IsA("ParticleEmitter")
or v:IsA("Trail")
or v:IsA("Smoke")
or v:IsA("Fire") then
v.Enabled = false
end

if v:IsA("BasePart") then
v.Material = Enum.Material.Plastic
v.Reflectance = 0
end

end

Lighting.GlobalShadows = false
Lighting.FogEnd = 100000

info.Text = "FPS Boost Enabled"

end)

-- ANTI AFK
afkBtn.MouseButton1Click:Connect(function()

player.Idled:Connect(function()

VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)

end)

info.Text = "Anti AFK Enabled"

end)

-- TELEPORT MAP
tpBtn.MouseButton1Click:Connect(function()

local maps = {2753915549,4442272183,7449423635}

local random = maps[math.random(1,#maps)]

TeleportService:Teleport(random)

end)

-- FPS COUNTER
task.spawn(function()

local frames = 0
local last = tick()
local fps = 60

RunService.RenderStepped:Connect(function()

frames = frames + 1

if tick()-last >= 1 then
fps = frames
frames = 0
last = tick()
end

end)

while true do

task.wait(1)

info.Text =
player.Name.." | "..fps.." FPS"

end

end)
