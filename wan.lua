local Player = game.Players.LocalPlayer
local RS, RunService, UIS = game:GetService("ReplicatedStorage"), game:GetService("RunService"), game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local CombatRemote = RS:FindFirstChild("CombatRemote")
local ActionRemote = RS:FindFirstChild("ActionRemote")

local IsTelePro, IsNoclip, IsInfJump, IsSpeedHack, IsAutoClick = false, false, true, true, false
local IsAntiStun = false; local NoclipTimer = 0; local OX, OY, OZ = 0, 10, 0; local CurrentWS = 120
local IsHitboxAll, HBS, IgnoreList = true, 28, {}
local AutoFarmActive, SpamEActive = false, false
local TargetPos = Vector3.new(518.2, 4.2, 150.2); local Speed = 300; local IsForceRespawn = false
local BMode = 1 
local SpawnTime = tick() 

--// GIAO DIỆN KHỞI TẠO KHUNG CHỨA
local SG = Instance.new("ScreenGui", game.CoreGui)

--// GIAO DIỆN CHÍNH (Chạy trực tiếp, không mật khẩu)
local Toggle = Instance.new("TextButton", SG); Toggle.Size = UDim2.new(0, 45, 0, 45); Toggle.Position = UDim2.new(0, 10, 0.5, -22); Toggle.Text = "W"; Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Toggle.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
local Main = Instance.new("Frame", SG); Main.Size = UDim2.new(0, 260, 0, 400); Main.Position = UDim2.new(0.5, -130, 0.5, -200); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Visible = true; Main.Active = true; Main.Draggable = true; Instance.new("UICorner", Main)
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 34); Title.Text = "WANDERING VIP"; Title.BackgroundTransparency = 1; Title.TextColor3 = Color3.fromRGB(212, 175, 55); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 22

local Tabs, Frames = {}, {}
local TabNames = {"COMBAT", "HITBOX", "KHÁC"}
for i = 1, 3 do
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(0, 80, 0, 28); b.Position = UDim2.new(0, (i - 1) * 85 + 5, 0, 35); b.Text = TabNames[i]; b.BackgroundColor3 = Color3.fromRGB(120, 0, 0); b.TextColor3 = Color3.fromRGB(255, 230, 230); b.Font = Enum.Font.GothamBlack; b.TextSize = 14; Instance.new("UICorner", b); Tabs[i] = b
    local f = Instance.new("Frame", Main); f.Size = UDim2.new(1, -10, 1, -70); f.Position = UDim2.new(0, 5, 0, 65); f.Visible = (i == 1); f.BackgroundTransparency = 1; Frames[i] = f
end

local function Btn(p, t, y, w, c) local b = Instance.new("TextButton", p); b.Size = UDim2.new(0, w or 230, 0, 28); b.Position = UDim2.new(0, 5, 0, y); b.Text = t; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b); return b end
local function Adj(p, y) local l = Instance.new("TextLabel", p); l.Size = UDim2.new(0, 90, 0, 28); l.Position = UDim2.new(0, 70, 0, y); l.BackgroundColor3 = Color3.fromRGB(25, 25, 25); l.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", l); local d = Btn(p, "-", y, 60, Color3.fromRGB(80, 30, 0)); d.Position = UDim2.new(0, 5, 0, y); local u = Btn(p, "+", y, 60, Color3.fromRGB(30, 80, 0)); u.Position = UDim2.new(0, 175, 0, y); return l, d, u end

-- TAB 1: COMBAT
local inT = Instance.new("TextBox", Frames[1]); inT.Size = UDim2.new(0, 230, 0, 30); inT.Position = UDim2.new(0, 5, 0, 0); inT.Text = "NHẬP TÊN..."; inT.BackgroundColor3 = Color3.fromRGB(30, 30, 30); inT.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", inT)
local bTele = Btn(Frames[1], "TẤN CÔNG MỤC TIÊU", 40, 230, Color3.fromRGB(100, 0, 0))
local bMode = Btn(Frames[1], "CHẾ ĐỘ: LOẠN", 75, 230, Color3.fromRGB(0, 0, 150))
local xl, xd, xu = Adj(Frames[1], 110); local yl, yd, yu = Adj(Frames[1], 145); local zl, zd, zu = Adj(Frames[1], 180)
local bAtk = Btn(Frames[1], "WANDER IMPACT (VIP)", 220, 230, Color3.fromRGB(100, 60, 0)); local bAnti = Btn(Frames[1], "WANDER VB VIPPRO: TẮT", 255, 230, Color3.fromRGB(0, 80, 0))

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

-- CẬP NHẬT TRẠNG THÁI UI
local function UI() 
    local modes = {"LOẠN", "LƠ LỬNG", "XOAY TRÒN"}
    bMode.Text = "CHẾ ĐỘ: " .. modes[BMode]
    bTele.BackgroundColor3 = IsTelePro and Color3.new(0, 0.8, 0) or Color3.fromRGB(100, 0, 0)
    bAtk.BackgroundColor3 = IsAutoClick and Color3.fromRGB(173, 216, 230) or Color3.fromRGB(100, 60, 0)
    bAnti.BackgroundColor3 = IsAntiStun and Color3.fromRGB(144, 238, 144) or Color3.fromRGB(0, 80, 0)
    bAnti.Text = IsAntiStun and "WANDER VB VIPPRO: BẬT" or "WANDER VB VIPPRO: TẮT"
    bWS.Text = "TỐC ĐỘ " .. (IsSpeedHack and "BẬT" or "TẮT")
    bWS.BackgroundColor3 = IsSpeedHack and Color3.new(1, 0, 1) or Color3.fromRGB(150, 0, 150)
    bNc.BackgroundColor3 = IsNoclip and Color3.new(0.6, 0.6, 0.6) or Color3.fromRGB(45, 45, 45)
    bIf.BackgroundColor3 = IsInfJump and Color3.new(0, 0.8, 0) or Color3.fromRGB(0, 100, 0)
    bFarm.BackgroundColor3 = AutoFarmActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(200, 0, 0)
    bE.BackgroundColor3 = SpamEActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(200, 0, 0)
    
    -- Cập nhật chữ On/Off và đổi màu cho nút Hitbox VIP
    bHB.Text = IsHitboxAll and "WANDER HITBOX VIP: BẬT" or "WANDER HITBOX VIP: TẮT"
    bHB.BackgroundColor3 = IsHitboxAll and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 100, 255)
    
    wl.Text = "T/ĐỘ " .. CurrentWS
    xl.Text = "X " .. OX; yl.Text = "Y " .. OY; zl.Text = "Z " .. OZ
    hl.Text = "HB " .. HBS 
end

-- KẾT NỐI SỰ KIỆN NÚT BẤM
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
bAnti.MouseButton1Click:Connect(function() IsAntiStun = not IsAntiStun; UI() end)
for i, b in pairs(Tabs) do b.MouseButton1Click:Connect(function() for j, f in pairs(Frames) do f.Visible = (j == i) end end) end
bTele.MouseButton1Click:Connect(function() IsTelePro = not IsTelePro; UI() end)
bMode.MouseButton1Click:Connect(function() BMode = (BMode % 3) + 1; UI() end)
bAtk.MouseButton1Click:Connect(function() IsAutoClick = not IsAutoClick; UI(); if not IsAutoClick and CombatRemote then pcall(function() CombatRemote:FireServer("Block", false); ActionRemote:FireServer("Block", false) end) end end)
bWS.MouseButton1Click:Connect(function() IsSpeedHack = not IsSpeedHack; UI() end)
bNc.MouseButton1Click:Connect(function() IsNoclip = not IsNoclip; UI() end)
bIf.MouseButton1Click:Connect(function() IsInfJump = not IsInfJump; UI() end)

-- Sự kiện click nút WANDER HITBOX VIP
bHB.MouseButton1Click:Connect(function() IsHitboxAll = not IsHitboxAll; UI() end)
hu.MouseButton1Click:Connect(function() HBS = math.min(100, HBS + 2); UI() end)
hd.MouseButton1Click:Connect(function() HBS = math.max(2, HBS - 2); UI() end)

bFarm.MouseButton1Click:Connect(function() AutoFarmActive = not AutoFarmActive; UI() end)
bE.MouseButton1Click:Connect(function() SpamEActive = not SpamEActive; UI() end)
wu.MouseButton1Click:Connect(function() CurrentWS += 10; UI() end)
wd.MouseButton1Click:Connect(function() CurrentWS = math.max(16, CurrentWS - 10); UI() end)
xu.MouseButton1Click:Connect(function() OX += 2; UI() end); xd.MouseButton1Click:Connect(function() OX -= 2; UI() end)
yu.MouseButton1Click:Connect(function() OY += 2; UI() end); yd.MouseButton1Click:Connect(function() OY -= 2; UI() end)
zu.MouseButton1Click:Connect(function() OZ += 2; UI() end); zd.MouseButton1Click:Connect(function() OZ -= 2; UI() end)

-- VÒNG LẶP XỬ LÝ GAMEPLAY
UIS.JumpRequest:Connect(function() if IsInfJump and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping) end end)

RunService.Stepped:Connect(function() 
    local c = Player.Character; if not c or not c:FindFirstChild("HumanoidRootPart") or not c:FindFirstChildOfClass("Humanoid") then return end
    local hrp = c.HumanoidRootPart; local hum = c:FindFirstChildOfClass("Humanoid"); local s = inT.Text:lower(); local t = nil
    local isStunned = (hum.WalkSpeed == 0 or hum.JumpPower == 0)
    local recentlySpawned = (tick() - SpawnTime < 3)
    
    if IsNoclip or IsTelePro or (tick() < NoclipTimer) then for _, v in pairs(c:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if s ~= "" and s ~= "nhập tên..." then for _, p in pairs(game.Players:GetPlayers()) do if p ~= Player and (p.Name:lower():find(s) or p.DisplayName:lower():find(s)) then t = p; break end end end
    
    if IsTelePro and t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and not (isStunned and not recentlySpawned) then 
        local thrp = t.Character.HumanoidRootPart; local targetPos
        if BMode == 1 then targetPos = thrp.Position + Vector3.new(math.random(-30,30)+OX, math.random(-15,15)+OY, math.random(-30,30)+OZ)
        elseif BMode == 2 then targetPos = thrp.Position + Vector3.new(OX, 5 + OY, OZ)
        else local time = tick() * 6; targetPos = thrp.Position + Vector3.new(math.sin(time)*7 + OX, OY, math.cos(time)*7 + OZ) end
        
        local direction = (targetPos - hrp.Position)
        if direction.Magnitude > 2 then hrp.AssemblyLinearVelocity = direction.Unit * 260 
        else hrp.AssemblyLinearVelocity = Vector3.zero end
        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(thrp.Position.X, hrp.Position.Y, thrp.Position.Z))
    elseif isStunned and IsTelePro and not recentlySpawned then
        hrp.AssemblyLinearVelocity = Vector3.new(math.random(-500, 500), 200, math.random(-500, 500))
    end
    if AutoFarmActive then local hum = c:FindFirstChildOfClass("Humanoid"); local hunger = c:FindFirstChild("Hunger") if hunger and hum and hunger.Value <= 0 and hum.Health > 0 and not IsForceRespawn then IsForceRespawn = true; hum.Health = 0 end end 
end)

RunService.Heartbeat:Connect(function(dt) local c = Player.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); local h = c and c:FindFirstChildOfClass("Humanoid") if not r or not h then return end if IsAntiStun and (h.WalkSpeed == 0 or h.JumpPower == 0) and (tick() - SpawnTime > 3) then NoclipTimer = tick() + 0.5; r.AssemblyLinearVelocity = Vector3.new(math.random(-500, 500), 200, math.random(-500, 500)) end if AutoFarmActive then h:ChangeState(Enum.HumanoidStateType.Physics); local dir = TargetPos - r.Position; if dir.Magnitude > 2 then r.AssemblyLinearVelocity = dir.Unit * Speed else r.AssemblyLinearVelocity = Vector3.zero end end end)

RunService.RenderStepped:Connect(function() 
    for _, p in pairs(game.Players:GetPlayers()) do 
        if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
            local hrp = p.Character.HumanoidRootPart; 
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

task.spawn(function() while task.wait(0.1) do local h = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") if h and IsSpeedHack and not (IsAutoClick and h.WalkSpeed == 0) then h.WalkSpeed = CurrentWS end end end)
task.spawn(function() while true do RunService.Heartbeat:Wait(); if IsAutoClick and CombatRemote then pcall(function() pcall(function() CombatRemote:FireServer("Block", true); ActionRemote:FireServer("Block", true) end); RunService.RenderStepped:Wait(); pcall(function() CombatRemote:FireServer("Block", false); ActionRemote:FireServer("Block", false) end); for i = 1, 4 do CombatRemote:FireServer("M1"); CombatRemote:FireServer("M2") end; CombatRemote:FireServer("Kick"); pcall(function() ActionRemote:FireServer("Kick") end); task.wait(0.02) end) end end end)
task.spawn(function() while true do if SpamEActive then VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game); task.wait(1); VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game); task.wait(0.1) end; task.wait(0.1) end end)

Player.CharacterAdded:Connect(function() SpawnTime = tick(); IsForceRespawn = false; UI() end); 
UI(); UpdateList(); 
game.Players.PlayerAdded:Connect(function() task.wait(1); UpdateList() end); 
game.Players.PlayerRemoving:Connect(function(player) IgnoreList[player.Name] = nil; UpdateList() end)

local vu = game:GetService("VirtualUser"); game:GetService("Players").LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame); task.wait(1); vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame) end)

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:IsLoaded()

local P, R, T, S, V = game:GetService("Players"), game:GetService("RunService"), game:GetService("TextChatService"), game:GetService("StarterGui"), game:GetService("VirtualInputManager")
local L = P.LocalPlayer
repeat task.wait() until L

local E, TG, BV = false, nil, nil
local W = {} 
local NF, HF, TPD = 250, 500, 18

-- Hook Metatable để chặn tương tác với Whitelist
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local m = getnamecallmethod()
    local a = { ... }
    if m == "FireServer" or m == "InvokeServer" then
        for _, p in pairs(W) do
            if p and p.Character then
                for _, v in pairs(a) do
                    if v == p or v == p.Character or (type(v) == "table" and rawget(v, "Instance") == p.Character) then
                        return nil
                    end
                end
            end
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

local function N(a, b)
    pcall(function() S:SetCore("SendNotification", {Title = a, Text = b, Duration = 3}) end)
end

local function Tap(x, y)
    V:SendTouchEvent(0, Enum.UserInputState.Begin, x, y)
    V:SendTouchEvent(0, Enum.UserInputState.End, x, y)
end

local function Setup()
    local C = L.Character
    local H = C and C:FindFirstChild("HumanoidRootPart")
    if not H then return end
    if BV then BV:Destroy() end
    BV = Instance.new("BodyVelocity", H)
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
end

local function Find(n)
    n = n and n:lower()
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= L and (p.Name:lower():find(n) or p.DisplayName:lower():find(n)) then
            return p
        end
    end
end

-- Xử lý lệnh qua chat
T.MessageReceived:Connect(function(m)
    local s = m.TextSource
    if s and P:GetPlayerByUserId(s.UserId) == L then
        local a = m.Text:split(" ")
        if a[1]:lower() == ";wander" then
            local cmd = a[2] and a[2]:lower()
            if cmd == "rage" then
                local p = Find(a[3])
                if p then TG, E = p, true Setup() N("WANDER RAGE", "Target: " .. p.DisplayName) end
            elseif cmd == "unrage" then
                E, TG = false, nil
                if BV then BV:Destroy() BV = nil end
                N("WANDER RAGE", "Disabled")
            elseif cmd == "bv" then
                local p = Find(a[3])
                if p and not table.find(W, p) then table.insert(W, p) N("WHITELIST", "Added: " .. p.DisplayName) end
            elseif cmd == "unbv" then
                local p = Find(a[3])
                for i, v in pairs(W) do if v == p then table.remove(W, i) N("WHITELIST", "Removed: " .. p.DisplayName) break end end
            end
        end
    end
end)

-- Vòng lặp chính
L.CharacterAdded:Connect(function() task.wait(1) if E then Setup() end end)
R.Heartbeat:Connect(function() if E and not BV then Setup() end end)
R.Stepped:Connect(function()
    if not E then return end
    local C = L.Character
    if C then for _, v in ipairs(C:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
end)

task.spawn(function()
    while true do
        task.wait(.08)
        if E and TG then
            local R1 = L.Character and L.Character:FindFirstChild("HumanoidRootPart")
            local R2 = TG.Character and TG.Character:FindFirstChild("HumanoidRootPart")
            if R1 and R2 and (R1.Position - R2.Position).Magnitude < 25 then
                Tap(825, 315) task.wait(.02) Tap(895, 315)
            end
        end
    end
end)

R.Heartbeat:Connect(function()
    local C = L.Character
    local H = C and C:FindFirstChild("HumanoidRootPart")
    local HM = C and C:FindFirstChildOfClass("Humanoid")
    if not (H and HM) then return end

    if HM.JumpPower == 0 and BV then
        local Y = H.Position.Y
        for i = 1, 6 do
            task.wait(.03)
            local D = Vector3.new(math.random(-100, 100) / 100, .8, math.random(-100, 100) / 100).Unit
            if H.Position.Y - Y > 50 then D = Vector3.new(D.X, -.6, D.Z).Unit end
            BV.Velocity = D * 500
        end
        return
    end

    if E and TG and BV then
        local TCH = TG.Character
        local TR = TCH and TCH:FindFirstChild("HumanoidRootPart")
        if TR then
            local Dist = (H.Position - TR.Position).Magnitude
            local Dir = (TR.Position - H.Position)
            Dir = (Dir.Magnitude < .1 and Vector3.new(0, .1, 0) or Dir).Unit
            if Dist > TPD then
                BV.Velocity = Dir * ((Dist < 40 and NF) or HF)
            else
                BV.Velocity = Vector3.zero
                H.CFrame = TR.CFrame * CFrame.new(math.cos(tick() * 220) * 10, math.sin(tick() * 150) * 5, math.sin(tick() * 220) * 10)
            end
        end
    end
end)

N("WANDER", "System Loaded")
