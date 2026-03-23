-- THANH DOAN HUB V1 ULTRA

if game.CoreGui:FindFirstChild("ThanhDoanHub") then
game.CoreGui.ThanhDoanHub:Destroy()
end

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- SAVE SYSTEM
local saveFile = "ThanhDoanHubUltra.json"
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
open.Size = UDim2.new(0,170,0,45)
open.Position = UDim2.new(0,20,0.5,-20)
open.Text = "Thành Đoàn Hub"
open.BackgroundColor3 = Color3.fromRGB(0,0,0)
open.TextColor3 = Color3.fromRGB(255,255,255)
open.Active = true
open.Draggable = true

Instance.new("UICorner",open)

-- MENU
local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,270,0,260)
frame.Position = UDim2.new(0.5,-135,0.5,-130)
frame.BackgroundColor3 = Color3.fromRGB(20,20,
