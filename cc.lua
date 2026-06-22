Local Player = game.Players.LocalPlayer
local RS, RunService, UIS = game:GetService("ReplicatedStorage"), game:GetService("RunService"), game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local CombatRemote = RS:FindFirstChild("CombatRemote")
local ActionRemote = RS:FindFirstChild("ActionRemote")

local IsTelePro, IsNoclip, IsInfJump, IsSpeedHack, IsAutoClick = false, false, true, true, false
local IsAntiStun = true; local IsAutoBlock = false
local NoclipTimer = 0; local OX, OY, OZ = 0, 0, 0
local CurrentWS = 24 
local IsHitboxAll, HBS, IgnoreList = true, 15, {} 
local AutoFarmActive, SpamEActive = false, false
local TargetPos = Vector3.new(518.2, 4.2, 150.2); local Speed = 45
local BMode = 1 

--// GIAO DIỆN KHỎI TẠO KHUNG CHỨA
local SG = Instance.new("ScreenGui")
SG.Name = "HomelessV6_CFrameBypass"
SG.ResetOnSpawn = false
SG.Parent = game.CoreGui

--// GIAO DIỆN CHÍNH
local Main = Instance.new("Frame", SG); Main.Size = UDim2.new(0, 260, 0, 420); Main.Position = UDim2.new(0.5, -130, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Visible = true; Main.Active = true; Instance.new("UICorner", Main)
local Toggle = Instance.new("TextButton", SG); Toggle.Size = UDim2.new(0, 45, 0, 45); Toggle.Position = UDim2.new(0, 10, 0.5, -22); Toggle.Text = "W"; Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Toggle.TextColor3 = Color3.new(1, 1, 1); local ToggleCorner = Instance.new("UICorner", Toggle); ToggleCorner.CornerRadius = UDim.new(1, 0)

-- Kéo thả UI
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
Main.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 34); Title.Text = "HOMELESS VIP V6"; Title.BackgroundTransparency = 1; Title.TextColor3 = Color3.fromRGB(212, 175, 55); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 22

local Tabs, Frames = {}, {}
local TabNames = {"COMBAT", "HITBOX", "KHÁC"}
for i = 1, 3 do
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(0, 80, 0, 28); b.Position = UDim2.new(0, (i - 1) * 85 + 5, 0, 35); b.Text = TabNames[i]; b.BackgroundColor3 = Color3.fromRGB(120, 0, 0); b.TextColor3 = Color3.fromRGB(255, 230, 230); b.Font = Enum.Font.GothamBlack; b.TextSize = 14; Instance.new("UICorner", b); Tabs[i] = b
    local f = Instance.new("Frame", Main); f.Size = UDim2.new(1, -10, 1, -70); f.Position = UDim2.new(0, 5, 0, 65); f.Visible = (i == 1); f.BackgroundTransparency = 1; Frames[i] = f
end

local function Btn(p, t, y, w, c) local b = Instance.new("TextButton", p); b.Size = UDim2.new(0, w or 230, 0, 28); b.Position = UDim2.new(0, 5, 0, y); b.Text = t; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b); return b end
local function Adj(p, y) local l = Instance.new("TextLabel", p); l.Size = UDim2.new(0, 90, 0, 28); l.Position = UDim2.new(0, 70, 0, y); l.BackgroundColor3 = Color3.fromRGB(25, 25, 25); l.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", l); local d = Btn(p, "-", y, 60, Color3.fromRGB(80, 30, 0)); d.Position = UDim2.new(0, 5, 0, y); local u = Btn(p, "+", y, 60, Color3.fromRGB(30, 80, 0)); u.Position = UDim2.new(0, 175, 0, y); return l, d, u end

-- TAB 1: COMBAT
local inT = Instance.new("TextBox", Frames[1]); inT.Size = UDim2.new(0, 230, 0, 30); inT.Position = UDim2.new(0, 5, 0, 0); inT.Text = "nhập tên..."; inT.BackgroundColor3 = Color3.fromRGB(30, 30, 30); inT.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", inT)
local bTele = Btn(Frames[1], "TẤN CÔNG MỤC TIÊU", 40, 230, Color3.fromRGB(100, 0, 0))
local bMode = Btn(Frames[1], "CHẾ ĐỘ: KHÓA SAU LƯNG", 75, 230, Color3.fromRGB(0, 0, 150))
local xl, xd, xu = Adj(Frames[1], 110); local yl, yd, yu = Adj(Frames[1], 145); local zl, zd, zu = Adj(Frames[1], 180)
local bAtk = Btn(Frames[1], "WANDER IMPACT (VIP)", 220, 230, Color3.fromRGB(100, 60, 0))
local bBlk = Btn(Frames[1], "AUTO BLOCK CHẶN ĐÒN: TẮT", 255, 230, Color3.fromRGB(80, 80, 80))
local bAnti = Btn(Frames[1], "WANDER VB VIPPRO: TẮT", 290, 230, Color3.fromRGB(0, 80, 0))

-- TAB 2: HITBOX
local bHB = Btn(Frames[2], "WANDER HITBOX VIP: BẬT", 0, 230, Color3.fromRGB(0, 150, 0)); local hl, hd, hu = Adj(Frames[2], 35)
local Scroll = Instance.new("ScrollingFrame", Frames[2]); Scroll.Size = UDim2.new(1, 0, 1, -80); Scroll.Position = UDim2.new(0, 0, 0, 70); Scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Scroll.ScrollBarThickness = 4; local Layout = Instance.new("UIListLayout", Scroll)

local function UpdateList() 
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(game.Players:GetPlayers()) do 
        if p ~= Player then 
            local b = Instance.new("TextButton", Scroll); b.Size = UDim2.new(1, -10, 0, 28); b.Text = p.DisplayName; b.BackgroundColor3 = IgnoreList[p.Name] and Color3.fromRGB(150, 50, 50) or Color3.fromRGB(40, 40, 45); b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function() IgnoreList[p.Name] = not IgnoreList[p.Name]; UpdateList() end) 
        end 
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y) 
end

-- TAB 3: KHÁC
local bWS = Btn(Frames[3], "TỐC ĐỘ", 0, 230, Color3.fromRGB(150, 0, 150)); local wl, wd, wu = Adj(Frames[3], 35); local bNc = Btn(Frames[3], "XUYÊN TƯỜNG", 70, 110, Color3.fromRGB(45, 45, 45)); local bIf = Btn(Frames[3], "NHẢY VÔ HẠN", 70, 110, Color3.fromRGB(0, 100, 0)); bIf.Position = UDim2.new(0, 120, 0, 70); local bFarm = Btn(Frames[3], "TỰ ĐỘNG LAU XE", 110, 230, Color3.fromRGB(200, 0, 0)); local bE = Btn(Frames[3], "TỰ ĐỘNG E", 145, 230, Color3.fromRGB(200, 0, 0))

local function UI() 
    local modes = {"KHÓA SAU LƯNG", "LƠ LỬNG TRÊN ĐẦU", "XOAY VÒNG QUANH"}
    bMode.Text = "CHẾ ĐỘ: " .. modes[BMode]
    bTele.BackgroundColor3 = IsTelePro and Color3.new(0, 0.8, 0) or Color3.fromRGB(100, 0, 0)
    bAtk.BackgroundColor3 = IsAutoClick and Color3.fromRGB(173, 216, 230) or Color3.fromRGB(100, 60, 0)
    bBlk.BackgroundColor3 = IsAutoBlock and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(80, 80, 80)
    bBlk.Text = IsAutoBlock and "AUTO BLOCK CHẶN ĐÒN: BẬT" or "AUTO BLOCK CHẶN ĐÒN: TẮT"
    bAnti.BackgroundColor3 = IsAntiStun and Color3.fromRGB(144, 238, 144) or Color3.fromRGB(0, 80, 0)
    bAnti.Text = IsAntiStun and "WANDER VB VIPPRO: BẬT" or "WANDER VB VIPPRO: TẮT"
    bWS.Text = "TỐC ĐỘ " .. (IsSpeedHack and "BẬT" or "TẮT")
    bWS.BackgroundColor3 = IsSpeedHack and Color3.new(1, 0, 1) or Color3.fromRGB(150, 0, 150)
    bNc.BackgroundColor3 = IsNoclip and Color3.new(0.6, 0.6, 0.6) or Color3.fromRGB(45, 45, 45)
    bIf.BackgroundColor3 = IsInfJump and Color3.new(0, 0.8, 0) or Color3.fromRGB(0, 100, 0)
    bFarm.BackgroundColor3 = AutoFarmActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(200, 0, 0)
    bE.BackgroundColor3 = SpamEActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(200, 0, 0)
    bHB.Text = IsHitboxAll and "WANDER HITBOX VIP: BẬT" or "WANDER HITBOX VIP: TẮT"
    bHB.BackgroundColor3 = IsHitboxAll and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 100, 255)
    wl.Text = "T/ĐỘ " .. CurrentWS; xl.Text = "X " .. OX; yl.Text = "Y " .. OY; zl.Text = "Z " .. OZ; hl.Text = "HB " .. HBS 
end

Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
bAnti.MouseButton1Click:Connect(function() IsAntiStun = not IsAntiStun; UI() end)
for i, b in pairs(Tabs) do b.MouseButton1Click:Connect(function() for j, f in pairs(Frames) do f.Visible = (j == i) end end) end
bTele.MouseButton1Click:Connect(function() IsTelePro = not IsTelePro; UI() end)
bMode.MouseButton1Click:Connect(function() BMode = (BMode % 3) + 1; UI() end)
bAtk.MouseButton1Click:Connect(function() IsAutoClick = not IsAutoClick; UI() if not IsAutoClick and CombatRemote then pcall(function() CombatRemote:FireServer("Block", false) end) end end)
bBlk.MouseButton1Click:Connect(function() IsAutoBlock = not IsAutoBlock; UI() if not IsAutoBlock and CombatRemote then pcall(function() CombatRemote:FireServer("Block", false) end) end end)
bWS.MouseButton1Click:Connect(function() IsSpeedHack = not IsSpeedHack; UI() end)
bNc.MouseButton1Click:Connect(function() IsNoclip = not IsNoclip; UI() end)
bIf.MouseButton1Click:Connect(function() IsInfJump = not IsInfJump; UI() end)
bHB.MouseButton1Click:Connect(function() IsHitboxAll = not IsHitboxAll; UI() end)
hu.MouseButton1Click:Connect(function() HBS = math.min(100, HBS + 2); UI() end); hd.MouseButton1Click:Connect(function() HBS = math.max(2, HBS - 2); UI() end)
bFarm.MouseButton1Click:Connect(function() AutoFarmActive = not AutoFarmActive; UI() end); bE.MouseButton1Click:Connect(function() SpamEActive = not SpamEActive; UI() end)
wu.MouseButton1Click:Connect(function() CurrentWS = math.min(50, CurrentWS + 2); UI() end); wd.MouseButton1Click:Connect(function() CurrentWS = math.max(16, CurrentWS - 2); UI() end)
xu.MouseButton1Click:Connect(function() OX += 0.5; UI() end); xd.MouseButton1Click:Connect(function() OX -= 0.5; UI() end)
yu.MouseButton1Click:Connect(function() OY += 0.5; UI() end); yd.MouseButton1Click:Connect(function() OY -= 0.5; UI() end)
zu.MouseButton1Click:Connect(function() OZ += 0.5; UI() end); zd.MouseButton1Click:Connect(function() OZ -= 0.5; UI() end)

UIS.JumpRequest:Connect(function() if IsInfJump and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping) end end)

-- XUYÊN TƯỜNG (NOCLIP)
RunService.Stepped:Connect(function() 
    local c = Player.Character; if not c then return end
    if IsNoclip or IsTelePro or (tick() < NoclipTimer) then 
        for _, v in pairs(c:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end 
    end
end)

-- LUỒNG CHÍNH ĐỒNG BỘ HEARTBEAT (XỬ LÝ DỊCH CHUYỂN VÀ SPEEDHACK BYPASS)
RunService.Heartbeat:Connect(function(dt)
    local c = Player.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart")
    local hum = c and c:FindFirstChildOfClass("Humanoid") 
    if not hrp or not hum or hum.Health <= 0 then return end

    -- Anti-Stun
    if IsAntiStun and (hum.WalkSpeed == 0 or hum.JumpPower == 0 or hum:GetState() == Enum.HumanoidStateType.PlatformStanding) then
        hum:ChangeState(Enum.HumanoidStateType.Running); hum.PlatformStanding = false
    end

    -- CHỨC NĂNG SPEEDHACK CFRAME TWEENING BYPASS (ĐÃ CẬP NHẬT)
    if IsSpeedHack and hum.MoveDirection.Magnitude > 0 and not IsTelePro then
        -- Luôn giữ WalkSpeed nhân vật ở mức an toàn 16 để qua mặt Server Check
        hum.WalkSpeed = 16 
        
        -- Tính toán vận tốc cộng dồn chính xác dựa trên DeltaTime (dt)
        local extraSpeed = CurrentWS - 16
        if extraSpeed > 0 then
            -- Tịnh tiến tọa độ CFrame theo hướng di chuyển mượt mà từng khung hình
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (extraSpeed * dt))
        end
    end

    -- AutoFarm Lau Xe
    if AutoFarmActive and not IsTelePro then 
        hum:ChangeState(Enum.HumanoidStateType.Running)
        local dir = TargetPos - hrp.Position
        if dir.Magnitude > 2 then hrp.AssemblyLinearVelocity = dir.Unit * Speed else hrp.AssemblyLinearVelocity = Vector3.zero end 
        return
    end

    -- Khóa chặt mục tiêu (Combat Teleport)
    if IsTelePro then
        pcall(function()
            local s = string.lower(inT.Text)
            local t = nil
            if s ~= "" and s ~= "nhập tên..." and s ~= "nhap ten..." then 
                for _, p in pairs(game.Players:GetPlayers()) do 
                    if p ~= Player then
                        if string.lower(p.Name):find(s, 1, true) or string.lower(p.DisplayName):find(s, 1, true) then t = p; break end
                    end
                end 
            end
            
            if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
                local thrp = t.Character.HumanoidRootPart
                
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                
                local calculatedPos
                if BMode == 1 then 
                    calculatedPos = thrp.Position + (-thrp.CFrame.LookVector * (1.3 + OZ)) + Vector3.new(OX, OY, 0)
                elseif BMode == 2 then 
                    calculatedPos = thrp.Position + Vector3.new(OX, 3.2 + OY, OZ)
                else 
                    local timeAngle = tick() * 6
                    calculatedPos = thrp.Position + Vector3.new(math.sin(timeAngle) * 1.5 + OX, OY, math.cos(timeAngle) * 1.5 + OZ) 
                end
                
                hrp.CFrame = CFrame.lookAt(calculatedPos, thrp.Position)
            end
        end)
    end
end)

-- LUỒNG HITBOX KHỔNG LỒ
task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            for _, p in pairs(game.Players:GetPlayers()) do 
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
                    local hrp = p.Character.HumanoidRootPart
                    if IsHitboxAll and not IgnoreList[p.Name] then 
                        hrp.Size = Vector3.new(HBS, HBS, HBS)
                        hrp.Transparency = 0.7
                        hrp.CanCollide = false 
                    else 
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.CanCollide = true 
                    end 
                end 
            end
        end)
    end
end)

-- LUỒNG ĐẤM SIÊU TỐC
task.spawn(function() 
    while true do 
        task.wait(0.09) 
        if IsAutoClick and CombatRemote then 
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

-- LUỒNG AUTO BLOCK RIÊNG BIỆT
task.spawn(function() 
    while true do 
        task.wait(0.05)
        if IsAutoBlock and CombatRemote then 
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

task.spawn(function() while true do if SpamEActive then VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game); task.wait(1); VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game); task.wait(0.1) end; task.wait(0.1) end end)

Player.CharacterAdded:Connect(function() IsForceRespawn = false; UI() end)
UI(); UpdateList()
game.Players.PlayerAdded:Connect(function() task.wait(1); UpdateList() end)
game.Players.PlayerRemoving:Connect(function(player) IgnoreList[player.Name] = nil; UpdateList() end)

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame); task.wait(1); vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame) end)
