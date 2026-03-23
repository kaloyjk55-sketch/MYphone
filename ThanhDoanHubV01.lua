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

local player
