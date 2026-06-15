local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local Whitelist = {} -- Bảng lưu trữ những người chơi được kích hoạt BV
local BV_Enabled = true -- Trạng thái Bật/Tắt tính năng BV (Mặc định là Bật)

-- Hàm thông báo hệ thống
local function Notify(title, text)
    pcall(function() 
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 3}) 
    end)
end

-- ====================================================================
-- HOOK METATABLE (Kiểm tra thêm biến BV_Enabled)
-- ====================================================================
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = { ... }
    
    -- Chỉ chạy cơ chế chặn nếu tính năng BV đang được BẬT
    if BV_Enabled and (method == "FireServer" or method == "InvokeServer") then
        for _, p in pairs(Whitelist) do
            if p and p.Character then
                for _, v in pairs(args) do
                    if v == p or v == p.Character or (type(v) == "table" and rawget(v, "Instance") == p.Character) then
                        return nil -- Chặn gói tin gửi lên Server liên quan đến mục tiêu
                    end
                end
            end
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- Hàm tìm kiếm người chơi theo tên
local function FindPlayer(name)
    name = name:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (p.Name:lower():find(name) or p.DisplayName:lower():find(name)) then
            return p
        end
    end
    return nil
end

-- ====================================================================
-- GIAO DIỆN MENU WHITELIST BV (ĐÃ DỊCH LÊN CAO)
-- ====================================================================
local SG = Instance.new("ScreenGui", CoreGui)

-- Nút tròn thu nhỏ/mở menu (Đã dịch lên cao hơn)
local Toggle = Instance.new("TextButton", SG)
Toggle.Size = UDim2.new(0, 40, 0, 40)
Toggle.Position = UDim2.new(0, 10, 0.5, -80) -- Thay -20 thành -80 để lên cao hơn
Toggle.Text = "BV"
Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 13
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

-- Khung menu chính (Đã dịch lên cao hơn)
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 230, 0, 280)
Main.Position = UDim2.new(0.5, -115, 0.5, -240) -- Thay -140 thành -240 để đẩy khung lên cao
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = true
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

-- Tiêu đề menu
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "WANDER WHITELIST BV"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(212, 175, 55)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14

-- Ô nhập tên người chơi
local InText = Instance.new("TextBox", Main)
InText.Size = UDim2.new(0, 145, 0, 30)
InText.Position = UDim2.new(0, 10, 0, 40)
InText.Text = "Nhập tên..."
InText.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InText.TextColor3 = Color3.new(1, 1, 1)
InText.Font = Enum.Font.Gotham
InText.TextSize = 13
Instance.new("UICorner", InText)

-- NÚT BẬT/TẮT (ON/OFF) BV 
local ToggleBVBtn = Instance.new("TextButton", Main)
ToggleBVBtn.Size = UDim2.new(0, 60, 0, 30)
ToggleBVBtn.Position = UDim2.new(0, 160, 0, 40)
ToggleBVBtn.Text = "BẬT"
ToggleBVBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
ToggleBVBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBVBtn.Font = Enum.Font.GothamBold
ToggleBVBtn.TextSize = 12
Instance.new("UICorner", ToggleBVBtn)

-- Nút Thêm vào Whitelist
local AddBtn = Instance.new("TextButton", Main)
AddBtn.Size = UDim2.new(1, -20, 0, 30)
AddBtn.Position = UDim2.new(0, 10, 0, 75)
AddBtn.Text = "THÊM VÀO WHITELIST"
AddBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
AddBtn.TextColor3 = Color3.new(1, 1, 1)
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextSize = 11
Instance.new("UICorner", AddBtn)

-- Danh sách cuộn hiển thị Whitelist
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -120)
Scroll.Position = UDim2.new(0, 10, 0, 110)
Scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Scroll.ScrollBarThickness = 3
Scroll.BorderSizePixel = 0
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 4)

-- Hàm cập nhật nút trạng thái BV
local function UpdateBVStatus()
    if BV_Enabled then
        ToggleBVBtn.Text = "BẬT"
        ToggleBVBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        ToggleBVBtn.Text = "TẮT"
        ToggleBVBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end

-- Cập nhật danh sách hiển thị trực quan trên giao diện
local function UpdateList()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for i, p in pairs(Whitelist) do
        local b = Instance.new("TextButton", Scroll)
        b.Size = UDim2.new(1, -5, 0, 26)
        b.Text = p.DisplayName .. " [X]"
        b.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.Gotham
        b.TextSize = 11
        Instance.new("UICorner", b)
        
        b.MouseButton1Click:Connect(function()
            table.remove(Whitelist, i)
            Notify("WHITELIST", "Đã xóa: " .. p.DisplayName)
            UpdateList()
        end)
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end

-- Sự kiện nhấn nút Bật/Tắt BV
ToggleBVBtn.MouseButton1Click:Connect(function()
    BV_Enabled = not BV_Enabled
    UpdateBVStatus()
    Notify("HỆ THỐNG", "Chức năng BV đã: " .. (BV_Enabled and "BẬT" or "TẮT"))
end)

-- Sự kiện nhấn nút Thêm người chơi
AddBtn.MouseButton1Click:Connect(function()
    local input = InText.Text
    if input ~= "" and input ~= "Nhập tên..." then
        local target = FindPlayer(input)
        if target then
            if not table.find(Whitelist, target) then
                table.insert(Whitelist, target)
                Notify("WHITELIST", "Đã thêm: " .. target.DisplayName)
                InText.Text = "Nhập tên..."
                UpdateList()
            else
                Notify("CẢNH BÁO", "Người chơi đã có trong danh sách!")
            end
        else
            Notify("THẤT BẠI", "Không tìm thấy người chơi.")
        end
    end
end)

-- Đóng/mở Giao diện bằng nút BV tròn
Toggle.MouseButton1Click:Connect(function() 
    Main.Visible = not Main.Visible 
end)

-- Tự động dọn dẹp danh sách khi có người thoát game
Players.PlayerRemoving:Connect(function(player)
    for i, p in pairs(Whitelist) do
        if p == player then
            table.remove(Whitelist, i)
            UpdateList()
            break
        end
    end
end)

-- Khởi tạo ban đầu
UpdateBVStatus()
UpdateList()
Notify("WANDER SYSTEM", "Menu Whitelist BV đã được đẩy lên cao!")
