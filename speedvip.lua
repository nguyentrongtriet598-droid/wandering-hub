local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Cổng Remote xử lý đấm/block của game
local CombatRemote = ReplicatedStorage:FindFirstChild("CombatRemote")
local ActionRemote = ReplicatedStorage:FindFirstChild("ActionRemote")

-- --- 1. KHỞI TẠO SCREEN GUI ---
local ScreenGui = Instance.new("ScreenGui")
local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
ScreenGui.Parent = (success and coreGui) or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "HTGMxSpeedGui"
ScreenGui.ResetOnSpawn = false

-- --- 2. GIAO DIỆN MENU CHÍNH ---
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 240) -- Tăng chiều cao lên 240 để vừa đủ các nút mới
MainFrame.Position = UDim2.new(0, 20, 0, 50) 
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Tiêu đề menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "   SPEED HTGMx"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- --- 3. NÚT ĐIỀU KHIỂN (ẨN / HIỆN) ---
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 100, 0, 35)
OpenButton.Position = UDim2.new(0, 20, 0, 10)
OpenButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
OpenButton.Text = "Mở Menu"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 6)
OpenCorner.Parent = OpenButton

-- Nhãn chữ "Nhập tốc độ" cho gọn gàng
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 100, 0, 30)
SpeedLabel.Position = UDim2.new(0, 15, 0, 55)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Nhập tốc độ:"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MainFrame

-- --- 4. Ô NHẬP TỐC ĐỘ ---
local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(0, 110, 0, 30)
SpeedInput.Position = UDim2.new(1, -125, 0, 55)
SpeedInput.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
SpeedInput.Text = "50"
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.Font = Enum.Font.GothamBold
SpeedInput.TextSize = 14
SpeedInput.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = SpeedInput

-- --- 5. NÚT GOD IMPACT (VIP) ---
local AutoAttackButton = Instance.new("TextButton")
AutoAttackButton.Size = UDim2.new(1, -30, 0, 30)
AutoAttackButton.Position = UDim2.new(0, 15, 0, 95)
AutoAttackButton.BackgroundColor3 = Color3.fromRGB(100, 60, 0)
AutoAttackButton.Text = "GOD IMPACT (VIP): TẮT"
AutoAttackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoAttackButton.Font = Enum.Font.GothamBold
AutoAttackButton.TextSize = 13
AutoAttackButton.Parent = MainFrame

local AttackCorner = Instance.new("UICorner")
AttackCorner.CornerRadius = UDim.new(0, 6)
AttackCorner.Parent = AutoAttackButton

-- --- 6. NÚT AUTO BLOCK ---
local AutoBlockButton = Instance.new("TextButton")
AutoBlockButton.Size = UDim2.new(1, -30, 0, 30)
AutoBlockButton.Position = UDim2.new(0, 15, 0, 135)
AutoBlockButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
AutoBlockButton.Text = "AUTO BLOCK CHẶN ĐÒN: TẮT"
AutoBlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBlockButton.Font = Enum.Font.GothamBold
AutoBlockButton.TextSize = 13
AutoBlockButton.Parent = MainFrame

local BlockCorner = Instance.new("UICorner")
BlockCorner.CornerRadius = UDim.new(0, 6)
BlockCorner.Parent = AutoBlockButton

-- --- 7. NÚT BẬT/TẮT TỐC ĐỘ ---
local ToggleScriptButton = Instance.new("TextButton")
ToggleScriptButton.Size = UDim2.new(1, -30, 0, 40)
ToggleScriptButton.Position = UDim2.new(0, 15, 1, -55)
ToggleScriptButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
ToggleScriptButton.Text = "TRẠNG THÁI TỐC ĐỘ: TẮT"
ToggleScriptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleScriptButton.Font = Enum.Font.GothamBold
ToggleScriptButton.TextSize = 14
ToggleScriptButton.Parent = MainFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 8)
SpeedCorner.Parent = ToggleScriptButton


-- ==========================================
-- --- LOGIC HOẠT ĐỘNG ---
-- ==========================================

local isScriptOn = false
local isAttackOn = false
local isBlockOn = false
local targetSpeed = 50

-- Đóng/Mở Menu
local function setMenuState(visible)
    MainFrame.Visible = visible
    OpenButton.Visible = not visible
end

CloseButton.MouseButton1Click:Connect(function() setMenuState(false) end)
OpenButton.MouseButton1Click:Connect(function() setMenuState(true) end)

-- Cập nhật tốc độ từ ô nhập liệu
SpeedInput.FocusLost:Connect(function()
    local num = tonumber(SpeedInput.Text)
    if num then targetSpeed = num else SpeedInput.Text = tostring(targetSpeed) end
end)

-- Bật/Tắt thuộc tính Speed
ToggleScriptButton.MouseButton1Click:Connect(function()
    isScriptOn = not isScriptOn
    if isScriptOn then
        ToggleScriptButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        ToggleScriptButton.Text = "TRẠNG THÁI TỐC ĐỘ: BẬT"
    else
        ToggleScriptButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        ToggleScriptButton.Text = "TRẠNG THÁI TỐC ĐỘ: TẮT"
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        end
    end
end)

-- Ghi đè WalkSpeed liên tục theo mẫu script mới của bạn
RunService.Heartbeat:Connect(function()
    if isScriptOn then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = targetSpeed
        end
    end
end)

-- Luồng God Impact (Tấn công qua Remote)
AutoAttackButton.MouseButton1Click:Connect(function()
    isAttackOn = not isAttackOn
    if isAttackOn then
        AutoAttackButton.BackgroundColor3 = Color3.fromRGB(173, 216, 230)
        AutoAttackButton.Text = "GOD IMPACT (VIP): BẬT"
    else
        AutoAttackButton.BackgroundColor3 = Color3.fromRGB(100, 60, 0)
        AutoAttackButton.Text = "GOD IMPACT (VIP): TẮT"
        if CombatRemote then pcall(function() CombatRemote:FireServer("Block", false) end) end
    end
end)

task.spawn(function() 
    while true do 
        task.wait(0.09) 
        if isAttackOn and CombatRemote then 
            pcall(function() 
                CombatRemote:FireServer("M1") 
                if math.random(1, 3) == 3 then
                    CombatRemote:FireServer("Kick")
                    if ActionRemote then ActionRemote:FireServer("Kick") end
                end
            end) 
        end 
    end 
end)

-- Luồng Auto Block (Chặn đòn qua Remote)
AutoBlockButton.MouseButton1Click:Connect(function()
    isBlockOn = not isBlockOn
    if isBlockOn then
        AutoBlockButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        AutoBlockButton.Text = "AUTO BLOCK CHẶN ĐÒN: BẬT"
    else
        AutoBlockButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        AutoBlockButton.Text = "AUTO BLOCK CHẶN ĐÒN: TẮT"
        if CombatRemote then pcall(function() CombatRemote:FireServer("Block", false) end) end
    end
end)

task.spawn(function() 
    while true do 
        task.wait(0.05)
        if isBlockOn and CombatRemote then 
            pcall(function() 
                CombatRemote:FireServer("Block", true)
                if ActionRemote then ActionRemote:FireServer("Block", true) end
                task.wait(0.1)
                CombatRemote:FireServer("Block", false)
                if ActionRemote then ActionRemote:FireServer("Block", false) end
            end) 
        end 
    end 
end)
