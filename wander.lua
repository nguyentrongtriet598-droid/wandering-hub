repeat task.wait() until game:IsLoaded()

local P,R,T,S,V=game:GetService("Players"),game:GetService("RunService"),game:GetService("TextChatService"),game:GetService("StarterGui"),game:GetService("VirtualInputManager")
local L=P.LocalPlayer
repeat task.wait() until L

local E,TG,BV=false,nil,nil
local W={} 
local NF,HF,TPD=250,500,18

-- Hook Metatable để chặn tương tác với Whitelist
local mt=getrawmetatable(game)
setreadonly(mt,false)
local old=mt.__namecall
mt.__namecall=newcclosure(function(self,...)
    local m=getnamecallmethod()
    local a={...}
    if m=="FireServer" or m=="InvokeServer" then
        for _,p in pairs(W) do
            if p and p.Character then
                for _,v in pairs(a) do
                    if v==p or v==p.Character or (type(v)=="table" and rawget(v,"Instance")==p.Character) then
                        return nil
                    end
                end
            end
        end
    end
    return old(self,...)
end)
setreadonly(mt,true)

local function N(a,b)
    pcall(function() S:SetCore("SendNotification",{Title=a,Text=b,Duration=3}) end)
end

local function Tap(x,y)
    V:SendTouchEvent(0,Enum.UserInputState.Begin,x,y)
    V:SendTouchEvent(0,Enum.UserInputState.End,x,y)
end

local function Setup()
    local C=L.Character
    local H=C and C:FindFirstChild("HumanoidRootPart")
    if not H then return end
    if BV then BV:Destroy() end
    BV=Instance.new("BodyVelocity",H)
    BV.MaxForce=Vector3.new(9e9,9e9,9e9)
end

local function Find(n)
    n=n and n:lower()
    for _,p in ipairs(P:GetPlayers()) do
        if p~=L and (p.Name:lower():find(n) or p.DisplayName:lower():find(n)) then
            return p
        end
    end
end

local function Cmd(m)
    local a=m:split(" ")
    if a[1]:lower()~=";wander" then return end
    local cmd=a[2] and a[2]:lower()

    if cmd=="rage" then
        local p=Find(a[3])
        if p then TG,E=p,true Setup() N("WANDER RAGE","Target: "..p.DisplayName) end
    elseif cmd=="unrage" then
        E,TG=false,nil
        if BV then BV:Destroy() BV=nil end
        N("WANDER RAGE","Disabled")
    elseif cmd=="bv" then
        local p=Find(a[3])
        if p and not table.find(W,p) then
            table.insert(W,p)
            N("WHITELIST","Added: "..p.DisplayName)
        end
    elseif cmd=="unbv" then
        local p=Find(a[3])
        for i,v in pairs(W) do if v==p then table.remove(W,i) N("WHITELIST","Removed: "..p.DisplayName) break end end
    end
end

T.MessageReceived:Connect(function(m)
    local s=m.TextSource
    if s and P:GetPlayerByUserId(s.UserId)==L then Cmd(m.Text) end
end)

L.CharacterAdded:Connect(function()
    task.wait(1)
    if E then Setup() end
end)

R.Heartbeat:Connect(function()
    if E and not BV then Setup() end
end)

R.Stepped:Connect(function()
    if not E then return end
    local C=L.Character
    if not C then return end
    for _,v in ipairs(C:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide=false end
    end
end)

task.spawn(function()
    while true do
        task.wait(.08)
        if E and TG then
            local R1=L.Character and L.Character:FindFirstChild("HumanoidRootPart")
            local R2=TG.Character and TG.Character:FindFirstChild("HumanoidRootPart")
            if R1 and R2 and (R1.Position-R2.Position).Magnitude<25 then
                Tap(825,315)
                task.wait(.02)
                Tap(895,315)
            end
        end
    end
end)

R.Heartbeat:Connect(function()
    local C=L.Character
    local H=C and C:FindFirstChild("HumanoidRootPart")
    local HM=C and C:FindFirstChildOfClass("Humanoid")
    if not(H and HM) then return end

    if HM.JumpPower==0 then
        if BV then
            local Y=H.Position.Y
            for i=1,6 do
                task.wait(.03)
                local D=Vector3.new(math.random(-100,100)/100,.8,math.random(-100,100)/100)
                if D.Magnitude<.1 then D=Vector3.new(0,1,0) end
                D=D.Unit
                if H.Position.Y-Y>50 then D=Vector3.new(D.X,-.6,D.Z).Unit end
                BV.Velocity=D*500
            end
        end
        return
    end

    if E and TG and BV then
        local TCH=TG.Character
        local TR=TCH and TCH:FindFirstChild("HumanoidRootPart")
        if not TR then return end

        local Dist=(H.Position-TR.Position).Magnitude
        local Dir=(TR.Position-H.Position)
        if Dir.Magnitude<.1 then Dir=Vector3.new(0,.1,0) end
        Dir=Dir.Unit

        if Dist>TPD then
            BV.Velocity=Dir*((Dist<40 and NF) or HF)
        else
            BV.Velocity=Vector3.zero
            H.CFrame=TR.CFrame*CFrame.new(math.cos(tick()*220)*10, math.sin(tick()*150)*5, math.sin(tick()*220)*10)
        end
    end
end)

N("WANDER","Load")
local Player = game.Players.LocalPlayer
local RS, RunService, UIS = game:GetService("ReplicatedStorage"), game:GetService("RunService"), game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local CombatRemote = RS:WaitForChild("CombatRemote")
local ActionRemote = RS:WaitForChild("ActionRemote")

local IsTelePro, IsNoclip, IsInfJump, IsSpeedHack, IsAutoClick = false, false, true, true, false
local OX, OY, OZ = 0, 10, 0
local CurrentWS = 120
local IsHitboxAll, HBS, IgnoreList = true, 28, {}
local AutoFarmActive, SpamEActive = false, false
local TargetPos = Vector3.new(518.2, 4.2, 150.2)
local Speed = 300
local IsForceRespawn = false

--// TẠO GIAO DIỆN (UI)
local SG = Instance.new("ScreenGui", game.CoreGui)
local Toggle = Instance.new("TextButton", SG)
Toggle.Size = UDim2.new(0, 45, 0, 45)
Toggle.Position = UDim2.new(0, 10, 0.5, -22)
Toggle.Text = "S"
Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 260, 0, 360)
Main.Position = UDim2.new(0.5, -130, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 34)
Title.Text = "S TEAM"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(212, 175, 55)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22

local Tabs, Frames = {}, {}
local TabNames = {"COMBAT", "HITBOX", "KHÁC"}
for i = 1, 3 do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0, 80, 0, 28)
    b.Position = UDim2.new(0, (i - 1) * 85 + 5, 0, 35)
    b.Text = TabNames[i]
    b.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    b.TextColor3 = Color3.fromRGB(255, 230, 230)
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 14
    Instance.new("UICorner", b)
    Tabs[i] = b
    
    local f = Instance.new("Frame", Main)
    f.Size = UDim2.new(1, -10, 1, -70)
    f.Position = UDim2.new(0, 5, 0, 65)
    f.Visible = (i == 1)
    f.BackgroundTransparency = 1
    Frames[i] = f
end

local function Btn(p, t, y, w, c)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(0, w or 230, 0, 28)
    b.Position = UDim2.new(0, 0, 0, y)
    b.Text = t
    b.BackgroundColor3 = c
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    return b
end

local function Adj(p, y)
    local l = Instance.new("TextLabel", p)
    l.Size = UDim2.new(0, 90, 0, 28)
    l.Position = UDim2.new(0, 70, 0, y)
    l.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    l.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", l)
    local d = Btn(p, "-", y, 60, Color3.fromRGB(80, 30, 0)); d.Position = UDim2.new(0, 0, 0, y)
    local u = Btn(p, "+", y, 60, Color3.fromRGB(30, 80, 0)); u.Position = UDim2.new(0, 170, 0, y)
    return l, d, u
end

-- Tab 1: COMBAT
local inT = Instance.new("TextBox", Frames[1])
inT.Size = UDim2.new(0, 230, 0, 30)
inT.Text = "NHẬP TÊN..."
inT.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inT.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", inT)

local bTele = Btn(Frames[1], "TẤN CÔNG MỤC TIÊU", 40, 230, Color3.fromRGB(100, 0, 0))

local xl, xd, xu = Adj(Frames[1], 75)
local yl, yd, yu = Adj(Frames[1], 110)
local zl, zd, zu = Adj(Frames[1], 145)

local bAtk = Btn(Frames[1], "TỰ ĐỘNG ĐÁNH VÀ BLOCK", 185, 230, Color3.fromRGB(100, 60, 0))
local bAura = Btn(Frames[1], "ALBA SPAM", 220, 110, Color3.fromRGB(150, 0, 0))
local bEscape = Btn(Frames[1], "VÔ BLOCK", 220, 110, Color3.fromRGB(0, 80, 180))
bEscape.Position = UDim2.new(0, 120, 0, 220)

-- Tab 2: HITBOX
local IsAuraSpam = false
local bHB = Btn(Frames[2], "HITBOX VÀ LOẠI TRỪ", 0, 230, Color3.fromRGB(100, 100, 255))
local hl, hd, hu = Adj(Frames[2], 35)
local Scroll = Instance.new("ScrollingFrame", Frames[2])
Scroll.Size = UDim2.new(1, 0, 1, -80)
Scroll.Position = UDim2.new(0, 0, 0, 70)
Scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Scroll.ScrollBarThickness = 4
local Layout = Instance.new("UIListLayout", Scroll)

local function UpdateList()
    for _, v in pairs(Scroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player then
            local b = Instance.new("TextButton", Scroll)
            b.Size = UDim2.new(1, -10, 0, 28)
            b.Text = p.DisplayName
            b.BackgroundColor3 = IgnoreList[p.Name] and Color3.fromRGB(150, 50, 50) or Color3.fromRGB(40, 40, 45)
            b.TextColor3 = Color3.new(1, 1, 1)
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function()
                IgnoreList[p.Name] = not IgnoreList[p.Name]
                UpdateList()
            end)
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end

-- Tab 3: KHÁC
local bWS = Btn(Frames[3], "TỐC ĐỘ", 0, 230, Color3.fromRGB(150, 0, 150))
local wl, wd, wu = Adj(Frames[3], 35)
local bNc = Btn(Frames[3], "XUYÊN TƯỜNG", 70, 110, Color3.fromRGB(45, 45, 45))
local bIf = Btn(Frames[3], "NHẢY VÔ HẠN", 70, 110, Color3.fromRGB(0, 100, 0))
bIf.Position = UDim2.new(0, 120, 0, 70)
local bFarm = Btn(Frames[3], "TỰ ĐỘNG LAU XE", 110, 230, Color3.fromRGB(200, 0, 0))
local bE = Btn(Frames[3], "TỰ ĐỘNG E(CÓ THỂ MUA BÁNH VÀ NƯỚC)", 145, 230, Color3.fromRGB(200, 0, 0))

-- HÀM CẬP NHẬT TRẠNG THÁI GIAO DIỆN
local function UI()
    bAura.BackgroundColor3 = IsAuraSpam and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    bTele.BackgroundColor3 = IsTelePro and Color3.new(0, 0.8, 0) or Color3.fromRGB(100, 0, 0)
    bAtk.BackgroundColor3 = IsAutoClick and Color3.new(0, 0.8, 0) or Color3.fromRGB(100, 60, 0)
    bWS.Text = "TỐC ĐỘ " .. (IsSpeedHack and "BẬT" or "TẮT")
    bWS.BackgroundColor3 = IsSpeedHack and Color3.new(1, 0, 1) or Color3.fromRGB(150, 0, 150)
    bNc.BackgroundColor3 = IsNoclip and Color3.new(0.6, 0.6, 0.6) or Color3.fromRGB(45, 45, 45)
    bIf.BackgroundColor3 = IsInfJump and Color3.new(0, 0.8, 0) or Color3.fromRGB(0, 100, 0)
    bFarm.BackgroundColor3 = AutoFarmActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(200, 0, 0)
    bE.BackgroundColor3 = SpamEActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(200, 0, 0)
    wl.Text = "T/ĐỘ " .. CurrentWS
    xl.Text = "X " .. OX; yl.Text = "Y " .. OY; zl.Text = "Z " .. OZ
    hl.Text = "HB " .. HBS
end

-- KẾT NỐI SỰ KIỆN NÚT BẤM UI
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
for i, b in pairs(Tabs) do
    b.MouseButton1Click:Connect(function()
        for j, f in pairs(Frames) do f.Visible = (j == i) end
    end)
end

bTele.MouseButton1Click:Connect(function() IsTelePro = not IsTelePro; UI() end)

bAtk.MouseButton1Click:Connect(function() 
    IsAutoClick = not IsAutoClick 
    UI() 
    if not IsAutoClick then
        -- Tắt hẳn block khi hủy kích hoạt nút bấm để trả lại tự do di chuyển hoàn toàn
        pcall(function() CombatRemote:FireServer("Block", false) end)
        pcall(function() CombatRemote:FireServer("Guard", false) end)
        pcall(function() ActionRemote:FireServer("Block", false) end)
    end
end)

bWS.MouseButton1Click:Connect(function() IsSpeedHack = not IsSpeedHack; UI() end)
bNc.MouseButton1Click:Connect(function() IsNoclip = not IsNoclip; UI() end)
bIf.MouseButton1Click:Connect(function() IsInfJump = not IsInfJump; UI() end)
bHB.MouseButton1Click:Connect(function() IsHitboxAll = not IsHitboxAll end)
bFarm.MouseButton1Click:Connect(function() AutoFarmActive = not AutoFarmActive; SpamEActive = AutoFarmActive or SpamEActive; UI() end)
bE.MouseButton1Click:Connect(function() SpamEActive = not SpamEActive; UI() end)
wu.MouseButton1Click:Connect(function() CurrentWS += 10; UI() end)
wd.MouseButton1Click:Connect(function() CurrentWS = math.max(16, CurrentWS - 10); UI() end)
xu.MouseButton1Click:Connect(function() OX += 2; UI() end)
xd.MouseButton1Click:Connect(function() OX -= 2; UI() end)
yu.MouseButton1Click:Connect(function() OY += 2; UI() end)
yd.MouseButton1Click:Connect(function() OY -= 2; UI() end)
zu.MouseButton1Click:Connect(function() OZ += 2; UI() end)
zd.MouseButton1Click:Connect(function() OZ -= 2; UI() end)
hu.MouseButton1Click:Connect(function() HBS += 2; UI() end)
hd.MouseButton1Click:Connect(function() HBS = math.max(2, HBS - 2); UI() end)
bAura.MouseButton1Click:Connect(function() IsAuraSpam = not IsAuraSpam; UI() end)

bEscape.MouseButton1Click:Connect(function()
    local c = Player.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if h and root then
        local oldPower = h.JumpPower
        h.UseJumpPower = true
        h.JumpPower = 1500
        root.Velocity = Vector3.new(0, 1500, 0)
        task.wait(0.1)
        h.JumpPower = oldPower
    end
end)

UIS.JumpRequest:Connect(function()
    if IsInfJump and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--// VÒNG LẶP HỆ THỐNG (LOGIC CHÍNH)
RunService.Stepped:Connect(function()
    local c = Player.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local hrp = c.HumanoidRootPart
    local s = inT.Text:lower()
    local t = nil
    if s ~= "" and s ~= "nhập tên..." then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and (p.Name:lower():find(s) or p.DisplayName:lower():find(s)) then
                t = p; break
            end
        end
    end
    if IsTelePro and t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        local thrp = t.Character.HumanoidRootPart
        local tp = thrp.CFrame * CFrame.new(OX, OY, OZ)
        local dir = tp.Position - hrp.Position
        local dist = dir.Magnitude
        if dist > 20 then
            hrp.Velocity = dir.Unit * 200
        else
            hrp.CFrame = tp
            hrp.Velocity = Vector3.zero
        end
    end
    if IsNoclip or IsTelePro or AutoFarmActive then
        for _, v in pairs(c:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if AutoFarmActive then
        local hum = c:FindFirstChildOfClass("Humanoid")
        local hunger = c:FindFirstChild("Hunger")
        if hunger and hum and hunger.Value <= 0 and hum.Health > 0 and not IsForceRespawn then
            IsForceRespawn = true
            hum.Health = 0
        end
    end
end)

RunService.RenderStepped:Connect(function()
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

-- Vòng lặp tốc độ đi bộ
task.spawn(function()
    while task.wait(0.1) do
        local h = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if h and IsSpeedHack and not (IsAutoClick and h.WalkSpeed == 0) then 
            h.WalkSpeed = CurrentWS 
        end
    end
end)

-- ========================================================
-- SỬA ĐỔI CHÍNH: VÒNG LẶP COMBO NHẢ BLOCK SIÊU TỐC ĐỂ DI CHUYỂN
-- ========================================================
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        
        if IsAutoClick then
            pcall(function()
                -- 1. Bật Block trước để tối ưu thủ
                pcall(function() CombatRemote:FireServer("Block", true) end)
                pcall(function() ActionRemote:FireServer("Block", true) end)
                
                -- 2. Nhả Block trong một phần giây cực ngắn ngay tại frame này để game trả lại nút Nhảy/Di Chuyển
                RunService.RenderStepped:Wait()
                pcall(function() CombatRemote:FireServer("Block", false) end)
                pcall(function() ActionRemote:FireServer("Block", false) end)

                -- 3. Ngay lập tức tung chuỗi combo tấn công đấm đá liên tục
                for i = 1, 4 do
                    CombatRemote:FireServer("M1")
                    CombatRemote:FireServer("M2")
                end
                CombatRemote:FireServer("Kick")
                pcall(function() ActionRemote:FireServer("Kick") end)
                
                -- Tạo khoảng nghỉ siêu nhỏ để động tác đấm không bị lỗi animation gồng
                task.wait(0.02)
            end)
        end
    end
end)

-- Vòng lặp Spam E
task.spawn(function()
    while true do
        if SpamEActive then
            VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(1)
            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(0.1)
        end
        task.wait(0.1)
    end
end)

-- Vòng lặp Aura Farm
task.spawn(function()
    while task.wait(10) do
        if IsAuraSpam then
            pcall(function() ActionRemote:FireServer("Aura Farm") end)
        end
    end
end)

-- Vòng lặp di chuyển AutoFarm xe
RunService.Heartbeat:Connect(function(dt)
    local c = Player.Character
    local r = c and c:FindFirstChild("HumanoidRootPart")
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if not (AutoFarmActive and r and h) then return end
    h:ChangeState(Enum.HumanoidStateType.Physics)
    local dir = TargetPos - r.Position
    local dist = dir.Magnitude
    if dist > 2 then
        r.AssemblyLinearVelocity = dir.Unit * Speed
    else
        r.AssemblyLinearVelocity = Vector3.zero
    end
end)

Player.CharacterAdded:Connect(function() IsForceRespawn = false end)
UI()
UpdateList()
game.Players.PlayerAdded:Connect(function() task.wait(1) UpdateList() end)
game.Players.PlayerRemoving:Connect(function(player) IgnoreList[player.Name] = nil; UpdateList() end)

-- Hệ thống chống treo game (Anti-AFK)
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)repeat task.wait() until game:IsLoaded()
local P, R, T, S, V = game:GetService("Players"), game:GetService("RunService"), game:GetService("TextChatService"), game:GetService("StarterGui"), game:GetService("VirtualInputManager")
local L = P.LocalPlayer
local E, TG, BV, AngryMode = false, nil, nil, false
local AngryTime, AngryDelay = 0, 6

local function Setup()
    local C = L.Character
    local H = C and C:FindFirstChild("HumanoidRootPart")
    if not H then return end
    if BV then BV:Destroy() end
    BV = Instance.new("BodyVelocity", H)
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
end

local function GetTarget()
    local list = {}
    for _, p in pairs(P:GetPlayers()) do
        if p ~= L and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then table.insert(list, p) end
    end
    return #list > 0 and list[math.random(1, #list)] or nil
end

T.MessageReceived:Connect(function(m)
    local msg = m.Text:lower()
    if msg == ";wander angry" then
        AngryMode, E = true, true
        TG = GetTarget()
        AngryTime = tick()
        Setup()
    elseif msg == ";wander unrage" then
        E, TG, AngryMode = false, nil, false
        if BV then BV:Destroy(); BV = nil end
    end
end)

R.Heartbeat:Connect(function()
    if not E or not TG or not BV then return end
    local hum = L.Character and L.Character:FindFirstChildOfClass("Humanoid")
    local hrp, tr = L.Character and L.Character:FindFirstChild("HumanoidRootPart"), TG.Character and TG.Character:FindFirstChild("HumanoidRootPart")
    
    if not hrp or not tr then return end
    
    -- Anti-Stun bay lên
    if hum and hum.JumpPower == 0 then BV.Velocity = Vector3.new(0, 500, 0) return end
    
    -- Angry 6s & Orbit
    if AngryMode and (tick() - AngryTime >= AngryDelay or not TG.Character) then
        TG = GetTarget()
        AngryTime = tick()
    end
    
    local offset = Vector3.new(math.cos(tick() * 6) * 12, 4, math.sin(tick() * 6) * 12)
    local dir = (tr.Position + offset) - hrp.Position
    BV.Velocity = dir.Magnitude > 2 and dir.Unit * 300 or Vector3.zero
    hrp.CFrame = CFrame.lookAt(hrp.Position, tr.Position)
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if E and TG then
            local r1, r2 = L.Character and L.Character:FindFirstChild("HumanoidRootPart"), TG.Character and TG.Character:FindFirstChild("HumanoidRootPart")
            if r1 and r2 and (r1.Position - r2.Position).Magnitude < 30 then
                game:GetService("ReplicatedStorage").CombatRemote:FireServer("M1")
                game:GetService("ReplicatedStorage").CombatRemote:FireServer("Kick")
            end
        end
    end
end)
