-- THĐ SLOT TOOL (CLEAN VERSION)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Parent = playerGui

-- Nút mở menu
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,60,0,60)
toggle.Position = UDim2.new(0,20,0,200)
toggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Text = "THĐ"
toggle.Parent = gui

local corner = Instance.new("UICorner", toggle)
corner.CornerRadius = UDim.new(1,0)

-- Menu
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0,320,0,420)
menu.Position = UDim2.new(0,90,0,200)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.Visible = false
menu.Parent = gui

-- Title
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1,0,0,40)
title.Text = "THĐ SLOT TOOL"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- Status
local status = Instance.new("TextLabel", menu)
status.Size = UDim2.new(1,0,0,30)
status.Position = UDim2.new(0,0,0,100)
status.Text = "Status: Idle"
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1

-- ================= SLOT SYSTEM =================
local currentSlot = 1
local slotSwitchEnabled = false
local switchTime = 10
local lastSwitch = tick()

-- Slot inputs
local slot1 = Instance.new("TextBox", menu)
slot1.Size = UDim2.new(0,120,0,30)
slot1.Position = UDim2.new(0,20,0,200)
slot1.Text = "Slot 1"

local slot2 = Instance.new("TextBox", menu)
slot2.Size = UDim2.new(0,120,0,30)
slot2.Position = UDim2.new(0,160,0,200)
slot2.Text = "Slot 2"

local switchBox = Instance.new("TextBox", menu)
switchBox.Size = UDim2.new(0,260,0,30)
switchBox.Position = UDim2.new(0,20,0,240)
switchBox.Text = "10"

-- ON/OFF switch
local switchBtn = Instance.new("TextButton", menu)
switchBtn.Size = UDim2.new(0,200,0,30)
switchBtn.Position = UDim2.new(0,60,0,280)
switchBtn.Text = "SLOT SWITCH: OFF"

switchBtn.MouseButton1Click:Connect(function()
	slotSwitchEnabled = not slotSwitchEnabled

	if slotSwitchEnabled then
		switchBtn.Text = "SLOT SWITCH: ON"
		status.Text = "Slot Switch Running"
	else
		switchBtn.Text = "SLOT SWITCH: OFF"
		status.Text = "Slot Switch Stopped"
	end
end)

-- ================= CLICK POINT SYSTEM =================
local clickPoints = {}

local function createClickPoint()
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0,50,0,50)
	frame.Position = UDim2.new(0.5, math.random(-100,100), 0.5, math.random(-100,100))
	frame.BackgroundTransparency = 1
	frame.Parent = gui

	local stroke = Instance.new("UIStroke", frame)
	stroke.Color = Color3.fromRGB(255,0,0)

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0,60,0,25)
	box.Position = UDim2.new(0,0,0,0)
	box.Text = "0.2"
	box.Parent = frame

	local slotBox = Instance.new("TextBox")
	slotBox.Size = UDim2.new(0,60,0,25)
	slotBox.Position = UDim2.new(0,0,0,30)
	slotBox.Text = "1"
	slotBox.Parent = frame

	table.insert(clickPoints, {
		frame = frame,
		box = box,
		slot = slotBox
	})
end

-- ================= BUTTON =================
local addBtn = Instance.new("TextButton", menu)
addBtn.Size = UDim2.new(0,200,0,30)
addBtn.Position = UDim2.new(0,60,0,320)
addBtn.Text = "ADD POINT"

addBtn.MouseButton1Click:Connect(createClickPoint)

-- ================= SLOT LOOP =================
RunService.Heartbeat:Connect(function()
	local now = tick()

	switchTime = tonumber(switchBox.Text) or 10

	if slotSwitchEnabled then
		if now - lastSwitch >= switchTime then
			currentSlot = (currentSlot == 1) and 2 or 1
			lastSwitch = now
		end
	end

	status.Text = "Current Slot: " .. currentSlot
end)

-- ================= TOGGLE MENU =================
toggle.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)
