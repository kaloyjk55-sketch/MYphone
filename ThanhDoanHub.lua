-- THANH DOAN HUB V1.5

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- SAVE
local saveFile = "ThanhDoanHubV15.json"
local data = {hop=false,time=600}

pcall(function()
if isfile(saveFile) then
data = HttpService:JSONDecode(readfile(saveFile))
end
end)

local function save()
pcall(function()
writefile(saveFile,HttpService:JSONEncode(data))
end)
end

-- GUI
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "ThanhDoanHub"

-- OPEN BUTTON
local open = Instance.new("TextButton",gui)
open.Size = UDim2.new(0,160,0,40)
open.Position = UDim2.new(0,20,0.5,-20)
open.Text = "Thanh Đoàn Hub"
open.BackgroundColor3 = Color3.fromRGB(0,0,0)
open.TextColor3 = Color3.fromRGB(255,255,255)
open.Active = true
open.Draggable = true
Instance.new("UICorner",open)

-- MENU
local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,260,0,260)
frame.Position = UDim2.new(0.5,-130,0.5,-130)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

-- TITLE
local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Thanh Đoàn Hub V1.5"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)

-- AUTO HOP
local auto = Instance.new("TextButton",frame)
auto.Size = UDim2.new(1,-20,0,40)
auto.Position = UDim2.new(0,10,0,40)
auto.Text = "Auto Hop: OFF"
auto.BackgroundColor3 = Color3.fromRGB(40,40,40)
auto.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner",auto)

-- HOP NOW
local hop = Instance.new("TextButton",frame)
hop.Size = UDim2.new(1,-20,0,40)
hop.Position = UDim2.new(0,10,0,90)
hop.Text = "Hop Server Now"
hop.BackgroundColor3 = Color3.fromRGB(0,170,255)
hop.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner",hop)

-- TIME BOX
local box = Instance.new("TextBox",frame)
box.Size = UDim2.new(1,-20,0,35)
box.Position = UDim2.new(0,10,0,140)
box.Text = tostring(data.time)
box.BackgroundColor3 = Color3.fromRGB(30,30,30)
box.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner",box)

-- RESET SAVE
local reset = Instance.new("TextButton",frame)
reset.Size = UDim2.new(1,-20,0,35)
reset.Position = UDim2.new(0,10,0,180)
reset.Text = "Reset Save"
reset.BackgroundColor3 = Color3.fromRGB(120,0,0)
reset.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner",reset)

-- INFO TEXT
local info = Instance.new("TextLabel",gui)
info.Size = UDim2.new(0,250,0,40)
info.Position = UDim2.new(0.5,-125,0,10)
info.BackgroundTransparency = 1
info.TextScaled = true

-- RAINBOW COLOR
spawn(function()
while true do
for i=0,1,0.01 do
info.TextColor3 = Color3.fromHSV(i,1,1)
task.wait()
end
end
end)

-- MENU ANIMATION
open.MouseButton1Click:Connect(function()
frame.Visible = true
frame.Size = UDim2.new(0,0,0,0)

TweenService:Create(
frame,
TweenInfo.new(0.3,Enum.EasingStyle.Back),
{Size = UDim2.new(0,260,0,260)}
):Play()
end)

-- AUTO HOP
auto.MouseButton1Click:Connect(function()
data.hop = not data.hop
auto.Text = "Auto Hop: "..(data.hop and "ON" or "OFF")
save()
end)

-- CHANGE TIME
box.FocusLost:Connect(function()
local num = tonumber(box.Text)
if num then
data.time = num
save()
end
end)

-- RESET SAVE
reset.MouseButton1Click:Connect(function()
data = {hop=false,time=600}
save()
end)

-- SMART SERVER HOP
local function hopServer()
pcall(function()

local servers = HttpService:JSONDecode(
game:HttpGet(
"https://games.roblox.com/v1/games/"..
game.PlaceId..
"/servers/Public?sortOrder=Asc&limit=100"
)
)

for i,v in pairs(servers.data) do
if v.playing < v.maxPlayers then
TeleportService:TeleportToPlaceInstance(game.PlaceId,v.id,player)
break
end
end

end)
end

hop.MouseButton1Click:Connect(hopServer)

-- FPS + TIMER
spawn(function()

local frames = 0
local last = tick()
local fps = 60
local timer = data.time

RunService.RenderStepped:Connect(function()
frames += 1
if tick()-last >= 1 then
fps = frames
frames = 0
last = tick()
end
end)

while true do
task.wait(1)

info.Text = player.Name.." | "..fps.." FPS | "..timer.."s"

if data.hop then
timer -= 1
if timer <= 0 then
hopServer()
timer = data.time
end
end

end
end)
