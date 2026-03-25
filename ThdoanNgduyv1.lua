--[[ 
████████████████████████████████████████
        Th.Đoàn N.Duy Hub - ULTIMATE
        Optimization + Mobile Support
████████████████████████████████████████
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- SETTINGS
getgenv().Aimbot = false
getgenv().LockTarget = false
getgenv().TPBehind = false
getgenv().ESP = false
local LockedTarget = nil

-- GUI CONTAINER
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThanhDoanHub_Ultimate"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- 1. SYSTEM INFO (GÓC MÀN HÌNH)
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = ScreenGui
InfoLabel.Size = UDim2.new(0, 250, 0, 30)
InfoLabel.Position = UDim2.new(1, -260, 0, 10)
InfoLabel.BackgroundTransparency = 0.5
InfoLabel.BackgroundColor3 = Color3.new(0,0,0)
InfoLabel.TextColor3 = Color3.new(1,1,1)
InfoLabel.Font = Enum.Font.Code
InfoLabel.TextSize = 14
InfoLabel.TextXAlignment = Enum.TextXAlignment.Right

local InfoCorner = Instance.new("UICorner", InfoLabel)
InfoCorner.CornerRadius = UDim.new(0, 8)

-- Cập nhật FPS và Giờ
local lastUpdate = 0
RunService.RenderStepped:Connect(function()
    local now = os.date("%H:%M:%S | %d/%m/%Y")
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    InfoLabel.Text = string.format("👤 %s | ⚡ %d FPS\n📅 %s ", LocalPlayer.Name, fps, now)
end)

-- 2. MAIN FRAME (MENU CHÍNH)
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 320, 0, 280)
Main.Position = UDim2.new(0.5, -160, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 15)

local MainGradient = Instance.new("UIGradient", Main)
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 0, 255))
}

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "🌌 Th.Đoàn N.Duy Hub v2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame")
Container.Parent = Main
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0, 0, 0, 250)

local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)

-- 3. NÚT MỞ MENU (MOBILE TOGGLE)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.Text = "MENU"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 10
ToggleBtn.Draggable = true -- Cho phép kéo thả trên điện thoại

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local BtnGradient = MainGradient:Clone()
BtnGradient.Parent = ToggleBtn

local menuOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    local targetSize = menuOpen and UDim2.new(0, 320, 0, 280) or UDim2.new(0, 0, 0, 0)
    TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = targetSize}):Play()
end)

-- 4. HÀM TẠO TOGGLE (PHONG CÁCH MỚI)
function createToggle(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = Container
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Text = text .. " : OFF"
    Btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 14
    
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = text .. (state and " : ON" or " : OFF")
        Btn.TextColor3 = state and Color3.new(1, 1, 1) or Color3.new(0.8, 0.8, 0.8)
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 170, 120) or Color3.fromRGB(40, 40, 40)}):Play()
        callback(state)
    end)
end

-- 5. LOGIC CHỨC NĂNG (TỐI ƯU)
function getClosest()
    local target, dist = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                dist = mag
                target = v
            end
        end
    end
    return target
end

-- Vòng lặp chính duy nhất (Tiết kiệm hiệu năng)
RunService.RenderStepped:Connect(function()
    -- Aimbot Logic
    if getgenv().Aimbot then
        if not (getgenv().LockTarget and LockedTarget) then
            LockedTarget = getClosest()
        end
        if LockedTarget and LockedTarget.Character and LockedTarget.Character:FindFirstChild("Head") then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, LockedTarget.Character.Head.Position), 0.15)
        end
    else
        LockedTarget = nil
    end

    -- TP Behind Logic
    if getgenv().TPBehind then
        local t = getClosest()
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end
end)

-- ESP (Sử dụng BillboardGui)
function applyESP(p)
    if p == LocalPlayer then return end
    p.CharacterAdded:Connect(function(char)
        local bgui = Instance.new("BillboardGui", char:WaitForChild("Head"))
        bgui.Size = UDim2.new(0, 100, 0, 50)
        bgui.AlwaysOnTop = true
        
        local text = Instance.new("TextLabel", bgui)
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.new(1, 0, 0)
        text.TextSize = 12
        text.Font = Enum.Font.GothamBold

        RunService.Heartbeat:Connect(function()
            if getgenv().ESP and char:FindFirstChild("Humanoid") then
                text.Visible = true
                text.Text = string.format("%s\nHP: %d", p.Name, math.floor(char.Humanoid.Health))
            else
                text.Visible = false
            end
        end)
    end)
end

for _, v in pairs(Players:GetPlayers()) do applyESP(v) end
Players.PlayerAdded:Connect(applyESP)

-- 6. KHỞI TẠO CÁC NÚT BẤM
createToggle("🎯 Aimbot", function(v) getgenv().Aimbot = v end)
createToggle("🧲 Lock Target", function(v) getgenv().LockTarget = v end)
createToggle("⚡ TP Behind", function(v) getgenv().TPBehind = v end)
createToggle("👁️ ESP Master", function(v) getgenv().ESP = v end)

-- Kéo thả Menu chính (Hỗ trợ cả Mobile)
local dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragStart = nil end
        end)
    end
end)
Main.InputChanged:Connect(function(input)
    if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
