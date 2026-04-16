-- THĐ AUTOMATION TOOL - FINAL

local player = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- ================= SAVE =================
local configFile = "thd_config.json"
local HttpService = game:GetService("HttpService")

local config = {
    delay = 0.2,
    totalClicks = 0
}

pcall(function()
    if readfile and isfile and isfile(configFile) then
        config = HttpService:JSONDecode(readfile(configFile))
    end
end)

local function saveConfig()
    pcall(function()
        if writefile then
            writefile(configFile, HttpService:JSONEncode(config))
        end
    end)
end

-- ================= GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)

-- Nút tròn THĐ
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0,60,0,60)
toggle.Position = UDim2.new(0,20,0,200)
toggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Text = "THĐ"
toggle.TextScaled = true

local corner = Instance.new("UICorner", toggle)
corner.CornerRadius = UDim.new(1,0)

-- Menu
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0,320,0,420)
menu.Position = UDim2.new(0,90,0,200)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.Visible = false

-- TITLE
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1,0,0,40)
title.Text = "THĐ AUTOMATION TOOL"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- DESCRIPTION
local desc = Instance.new("TextLabel", menu)
desc.Size = UDim2.new(1,-20,0,60)
desc.Position = UDim2.new(0,10,0,40)
desc.Text = "Công cụ hỗ trợ tự động hóa thao tác giúp giảm lặp lại và nghiên cứu tương tác người-máy."
desc.TextWrapped = true
desc.TextColor3 = Color3.new(1,1,1)
desc.BackgroundTransparency = 1

-- STATUS
local status = Instance.new("TextLabel", menu)
status.Size = UDim2.new(1,0,0,30)
status.Position = UDim2.new(0,0,0,100)
status.Text = "Status: Idle"
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1

-- TIMER
local timer = Instance.new("TextLabel", menu)
timer.Size = UDim2.new(1,0,0,30)
timer.Position = UDim2.new(0,0,0,130)
timer.Text = "Time: 0s"
timer.TextColor3 = Color3.new(1,1,1)
timer.BackgroundTransparency = 1

-- CLICK COUNT
local clickLabel = Instance.new("TextLabel", menu)
clickLabel.Size = UDim2.new(1,0,0,30)
clickLabel.Position = UDim2.new(0,0,0,160)
clickLabel.Text = "Clicks: 0"
clickLabel.TextColor3 = Color3.new(1,1,1)
clickLabel.BackgroundTransparency = 1

-- AUTO CLICK BUTTON
local autoBtn = Instance.new("TextButton", menu)
autoBtn.Size = UDim2.new(0,200,0,30)
autoBtn.Position = UDim2.new(0,60,0,200)
autoBtn.Text = "AUTO CLICK: OFF"

-- ADD CLICK
local addBtn = Instance.new("TextButton", menu)
addBtn.Size = UDim2.new(0,200,0,30)
addBtn.Position = UDim2.new(0,60,0,240)
addBtn.Text = "ADD CLICK"

-- ================= LOGIC =================
local auto = false
local clickPoints = {}
local timeRunning = 0

-- tạo điểm click
local function createClickPoint()
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0,60,0,60)
    frame.Position = UDim2.new(0.5,-30,0.5,-30)
    frame.BackgroundTransparency = 1

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255,0,0)

    local box = Instance.new("TextBox", gui)
    box.Size = UDim2.new(0,50,0,25)
    box.Position = frame.Position + UDim2.new(0,65,0,15)
    box.Text = tostring(config.delay)

    table.insert(clickPoints, {
        frame = frame,
        box = box,
        last = 0
    })
end

addBtn.MouseButton1Click:Connect(createClickPoint)

autoBtn.MouseButton1Click:Connect(function()
    auto = not auto
    autoBtn.Text = auto and "AUTO CLICK: ON" or "AUTO CLICK: OFF"
end)

-- LOOP
RunService.Heartbeat:Connect(function(dt)
    if auto then
        timeRunning += dt
        timer.Text = "Time: "..math.floor(timeRunning).."s"
        status.Text = "Status: Running"
    else
        status.Text = "Status: Idle"
    end

    local now = tick()

    if auto then
        for _,v in pairs(clickPoints) do
            local d = tonumber(v.box.Text) or config.delay
            if now - v.last >= d then
                local pos = v.frame.AbsolutePosition + v.frame.AbsoluteSize/2

                VIM:SendMouseButtonEvent(pos.X,pos.Y,0,true,game,0)
                VIM:SendMouseButtonEvent(pos.X,pos.Y,0,false,game,0)

                v.last = now
                config.totalClicks += 1
                clickLabel.Text = "Clicks: "..config.totalClicks
            end
        end
    end
end)

-- SAVE định kỳ
task.spawn(function()
    while true do
        task.wait(5)
        saveConfig()
    end
end)

-- TOGGLE MENU
toggle.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)
