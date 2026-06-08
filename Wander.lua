local Player=game.Players.LocalPlayer
local RS,RunService,UIS=game:GetService("ReplicatedStorage"),game:GetService("RunService"),game:GetService("UserInputService")
local VIM=game:GetService("VirtualInputManager")
local CombatRemote=RS:WaitForChild("CombatRemote")
local ActionRemote = RS:WaitForChild("ActionRemote")

local IsTelePro,IsNoclip,IsInfJump,IsSpeedHack,IsAutoClick=false,false,true,true,false
local OX,OY,OZ=0,10,0
local CurrentWS=120
local IsHitboxAll,HBS,IgnoreList=true,28,{}
local AutoFarmActive,SpamEActive=false,false
local TargetPos=Vector3.new(518.2,4.2,150.2)
local Speed=300
local IsForceRespawn=false
local SG=Instance.new("ScreenGui",game.CoreGui)
local Toggle=Instance.new("TextButton",SG)
Toggle.Size=UDim2.new(0,45,0,45)
Toggle.Position=UDim2.new(0,10,0.5,-22)
Toggle.Text="W"
Toggle.BackgroundColor3=Color3.fromRGB(30,30,30)
Toggle.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",Toggle).CornerRadius=UDim.new(1,0)
local Main=Instance.new("Frame",SG)
Main.Size=UDim2.new(0,260,0,360)
Main.Position=UDim2.new(0.5,-130,0.5,-180)
Main.BackgroundColor3=Color3.fromRGB(15,15,15)
Main.Visible=false
Main.Active=true
Main.Draggable=true
Instance.new("UICorner",Main)
local Title=Instance.new("TextLabel",Main)
Title.Size=UDim2.new(1,0,0,34)
Title.Text = "wandering"
Title.Font = Enum.Font.GothamBlack
Title.TextColor3 = Color3.fromRGB(200, 0, 0)
Title.TextSize=22
local Tabs,Frames={},{}
local TabNames={"COMBAT","HITBOX","KHÁC"}
for i=1,3 do
    local b=Instance.new("TextButton",Main)
    b.Size=UDim2.new(0,80,0,28)
    b.Position=UDim2.new(0,(i-1)*85+5,0,35)
    b.Text=TabNames[i]
    b.BackgroundColor3=Color3.fromRGB(120,0,0)
    b.TextColor3=Color3.fromRGB(255,230,230)
    b.Font=Enum.Font.GothamBlack
    b.TextSize=14
    Instance.new("UICorner",b)
    Tabs[i]=b
    local f=Instance.new("Frame",Main)
    f.Size=UDim2.new(1,-10,1,-70)
    f.Position=UDim2.new(0,5,0,65)
    f.Visible=(i==1)
    f.BackgroundTransparency=1
    Frames[i]=f
end
local function Btn(p,t,y,w,c)
    local b=Instance.new("TextButton",p)
    b.Size=UDim2.new(0,w or 230,0,28)
    b.Position=UDim2.new(0,0,0,y)
    b.Text=t
    b.BackgroundColor3=c
    b.TextColor3=Color3.new(1,1,1)
    Instance.new("UICorner",b)
    return b
end
local function Adj(p,y)
    local l=Instance.new("TextLabel",p)
    l.Size=UDim2.new(0,90,0,28)
    l.Position=UDim2.new(0,70,0,y)
    l.BackgroundColor3=Color3.fromRGB(25,25,25)
    l.TextColor3=Color3.new(1,1,1)
    Instance.new("UICorner",l)
    local d=Btn(p,"-",y,60,Color3.fromRGB(80,30,0));d.Position=UDim2.new(0,0,0,y)
    local u=Btn(p,"+",y,60,Color3.fromRGB(30,80,0));u.Position=UDim2.new(0,170,0,y)
    return l,d,u
end
local inT=Instance.new("TextBox",Frames[1])
inT.Size=UDim2.new(0,230,0,30)
inT.Text="NHẬP TÊN..."
inT.BackgroundColor3=Color3.fromRGB(30,30,30)
inT.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",inT)
local bTele=Btn(Frames[1],"DỊCH CHUYỂN PRO",40,230,Color3.fromRGB(100,0,0))
local xl,xd,xu=Adj(Frames[1],75)
local yl,yd,yu=Adj(Frames[1],110)
local zl,zd,zu=Adj(Frames[1],145)
local bAtk=Btn(Frames[1],"TỰ ĐỘNG ĐÁNH",185,230,Color3.fromRGB(100,60,0))
local bAura = Btn(Frames[1],"AURA SPAM",220,110,Color3.fromRGB(150,0,0))
local bEscape = Btn(Frames[1],"TRỐN THOÁT",220,110,Color3.fromRGB(0,80,180))
bEscape.Position = UDim2.new(0,120,0,220)

local IsAuraSpam = false
local bHB=Btn(Frames[2],"HITBOX VÀ LOẠI TRỪ",0,230,Color3.fromRGB(100,100,255))
local hl,hd,hu=Adj(Frames[2],35)
local Scroll=Instance.new("ScrollingFrame",Frames[2])
Scroll.Size=UDim2.new(1,0,1,-80)
Scroll.Position=UDim2.new(0,0,0,70)
Scroll.BackgroundColor3=Color3.fromRGB(25,25,30)
Scroll.ScrollBarThickness=4
local Layout=Instance.new("UIListLayout",Scroll)
local function UpdateList()
    for _,v in pairs(Scroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    for _,p in pairs(game.Players:GetPlayers()) do
        if p~=Player then
            local b=Instance.new("TextButton",Scroll)
            b.Size=UDim2.new(1,-10,0,28)
            b.Text=p.DisplayName
            b.BackgroundColor3=IgnoreList[p.Name] and Color3.fromRGB(150,50,50) or Color3.fromRGB(40,40,45)
            b.TextColor3=Color3.new(1,1,1)
            Instance.new("UICorner",b)
            b.MouseButton1Click:Connect(function()
                IgnoreList[p.Name]=not IgnoreList[p.Name]
                UpdateList()
            end)
        end
    end
    Scroll.CanvasSize=UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y)
end
local bWS=Btn(Frames[3],"TỐC ĐỘ",0,230,Color3.fromRGB(150,0,150))
local wl,wd,wu=Adj(Frames[3],35)
local bNc=Btn(Frames[3],"XUYÊN TƯỜNG",70,110,Color3.fromRGB(45,45,45))
local bIf=Btn(Frames[3],"NHẢY VÔ HẠN",70,110,Color3.fromRGB(0,100,0))
bIf.Position=UDim2.new(0,120,0,70)
local bFarm=Btn(Frames[3],"TỰ ĐỘNG LAU XE",110,230,Color3.fromRGB(200,0,0))
local bE=Btn(Frames[3],"TỰ ĐỘNG E(CÓ THỂ MUA BÁNH VÀ NƯỚC)",145,230,Color3.fromRGB(200,0,0))
local function UI()
    bAura.BackgroundColor3 = IsAuraSpam and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
    bTele.BackgroundColor3=IsTelePro and Color3.new(0,0.8,0) or Color3.fromRGB(100,0,0)
    bAtk.BackgroundColor3=IsAutoClick and Color3.new(1,0.5,0) or Color3.fromRGB(100,60,0)
    bWS.Text="TỐC ĐỘ "..(IsSpeedHack and "BẬT" or "TẮT")
    bWS.BackgroundColor3=IsSpeedHack and Color3.new(1,0,1) or Color3.fromRGB(150,0,150)
    bNc.BackgroundColor3=IsNoclip and Color3.new(0.6,0.6,0.6) or Color3.fromRGB(45,45,45)
    bIf.BackgroundColor3=IsInfJump and Color3.new(0,0.8,0) or Color3.fromRGB(0,100,0)
    bFarm.BackgroundColor3=AutoFarmActive and Color3.fromRGB(0,150,0) or Color3.fromRGB(200,0,0)
    bE.BackgroundColor3=SpamEActive and Color3.fromRGB(0,150,0) or Color3.fromRGB(200,0,0)
    wl.Text="T/ĐỘ "..CurrentWS
    xl.Text="X "..OX; yl.Text="Y "..OY; zl.Text="Z "..OZ
    hl.Text="HB "..HBS
end
Toggle.MouseButton1Click:Connect(function() Main.Visible=not Main.Visible end)
for i,b in pairs(Tabs) do
    b.MouseButton1Click:Connect(function()
        for j,f in pairs(Frames) do
            f.Visible=(j==i)
        end
    end)
end
bTele.MouseButton1Click:Connect(function()IsTelePro=not IsTelePro;UI()end)
bAtk.MouseButton1Click:Connect(function()IsAutoClick=not IsAutoClick;UI()end)
bWS.MouseButton1Click:Connect(function()IsSpeedHack=not IsSpeedHack;UI()end)
bNc.MouseButton1Click:Connect(function()IsNoclip=not IsNoclip;UI()end)
bIf.MouseButton1Click:Connect(function()IsInfJump=not IsInfJump;UI()end)
bHB.MouseButton1Click:Connect(function()IsHitboxAll=not IsHitboxAll end)
bFarm.MouseButton1Click:Connect(function()AutoFarmActive=not AutoFarmActive;SpamEActive=AutoFarmActive or SpamEActive;UI()end)
bE.MouseButton1Click:Connect(function()SpamEActive=not SpamEActive;UI()end)
wu.MouseButton1Click:Connect(function()CurrentWS+=10;UI()end)
wd.MouseButton1Click:Connect(function()CurrentWS=math.max(16,CurrentWS-10);UI()end)
xu.MouseButton1Click:Connect(function()OX+=2;UI()end)
xd.MouseButton1Click:Connect(function()OX-=2;UI()end)
yu.MouseButton1Click:Connect(function()OY+=2;UI()end)
yd.MouseButton1Click:Connect(function()OY-=2;UI()end)
zu.MouseButton1Click:Connect(function()OZ+=2;UI()end)
zd.MouseButton1Click:Connect(function()OZ-=2;UI()end)
hu.MouseButton1Click:Connect(function()HBS+=2;UI()end)
hd.MouseButton1Click:Connect(function()HBS=math.max(2,HBS-2);UI()end)
bAura.MouseButton1Click:Connect(function()
    IsAuraSpam = not IsAuraSpam
    UI()
end)
bEscape.MouseButton1Click:Connect(function()
    local c = Player.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if h and root then
        local oldPower = h.JumpPower
        h.UseJumpPower = true
        h.JumpPower = 1500
        root.Velocity = Vector3.new(0,1500,0)
        task.wait(0.1)
        h.JumpPower = oldPower
    end
end)

UIS.JumpRequest:Connect(function()
    if IsInfJump and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
RunService.Stepped:Connect(function()
    local c=Player.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local hrp=c.HumanoidRootPart
    local s=inT.Text:lower()
    local t=nil
    if s~="" and s~="nhập tên..." then
        for _,p in pairs(game.Players:GetPlayers()) do
            if p~=Player and (p.Name:lower():find(s) or p.DisplayName:lower():find(s)) then
                t=p; break
            end
        end
    end
    if IsTelePro and not IsBringLoop and t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        local thrp=t.Character.HumanoidRootPart
        local tp=thrp.CFrame*CFrame.new(OX,OY,OZ)
        local dir=tp.Position-hrp.Position
        local dist=dir.Magnitude
        if dist>20 then
            hrp.Velocity=dir.Unit*200
        else
            hrp.CFrame=tp
            hrp.Velocity=Vector3.zero
        end
    end
    if IsNoclip or IsTelePro or AutoFarmActive then
        for _,v in pairs(c:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide=false
            end
        end
    end
    if AutoFarmActive then
        local hum=c:FindFirstChildOfClass("Humanoid")
        local hunger=c:FindFirstChild("Hunger")
        if hunger and hum and hunger.Value<=0 and hum.Health>0 and not IsForceRespawn then
            IsForceRespawn=true
            hum.Health=0
        end
    end
end)
RunService.RenderStepped:Connect(function()
    for _,p in pairs(game.Players:GetPlayers()) do
        if p~=Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp=p.Character.HumanoidRootPart
            if IsHitboxAll and not IgnoreList[p.Name] then
                hrp.Size=Vector3.new(HBS,HBS,HBS)
                hrp.Transparency=0.7
                hrp.CanCollide=false
            else
                hrp.Size=Vector3.new(2,2,1)
                hrp.Transparency=1
                hrp.CanCollide=true
            end
        end
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        local h=Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if h and IsSpeedHack then
            h.WalkSpeed=CurrentWS
        end
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        if IsAutoClick then
            CombatRemote:FireServer("M1")
            task.wait(0.1)
            CombatRemote:FireServer("M2")
        end
    end
end)
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
task.spawn(function()
    while task.wait(10) do
        if IsAuraSpam then
            pcall(function()
                ActionRemote:FireServer("Aura Farm")
            end)
        end
    end
end)

RunService.Heartbeat:Connect(function(dt)
    local c = Player.Character
    local r = c and c:FindFirstChild("HumanoidRootPart")
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if not (AutoFarmActive and r and h) then return end
    h:ChangeState(Enum.HumanoidStateType.Physics)

    local dir = TargetPos - r.Position
    local dist = dir.Magnitude

    if dist > 2 then
        local v = dir.Unit * Speed
        r.AssemblyLinearVelocity = v
    else
        r.AssemblyLinearVelocity = Vector3.zero
    end
end)
Player.CharacterAdded:Connect(function()
    IsForceRespawn=false
end)
UI()
UpdateList()
game.Players.PlayerAdded:Connect(function()
    task.wait(1) 
    UpdateList()
end)

game.Players.PlayerRemoving:Connect(function(player)
    IgnoreList[player.Name] = nil 
    UpdateList()
end)
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

--------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Admins = {"hachoangtu", "keocon", "kietlac", "nguyennhut", "khoylee"}
local LoopKill = false
local IsFrozen = false
local IsBringLoop = false
local ActiveAdmin = nil
local lastKillTime = 0

local mt_success, mt = pcall(getrawmetatable, game)
if mt_success and mt then
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if (IsFrozen or IsBringLoop) and (method == "FireServer" or method == "InvokeServer") then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end

local function IsAdmin(player)
    local name = string.lower(player.Name)
    local display = string.lower(player.DisplayName)
    for _, admin in pairs(Admins) do
        if name:find(admin) or display:find(admin) then return true end
    end
    return false
end

local function CleanOtherPhysics(root)
    for _, v in pairs(root:GetChildren()) do
        if (v:IsA("BodyMover") or v:IsA("LinearVelocity") or v:IsA("VectorForce") or v:IsA("AlignPosition")) 
        and v.Name ~= "BringForce" and v.Name ~= "BringAtt" then
            v:Destroy()
        end
    end
end

local function ExecuteCommand(msg, speaker)
    local args = string.split(string.lower(msg), " ")
    local cmd = args[1]
    local targetPart = args[2] or ""

    local myName = string.lower(LocalPlayer.Name)
    local myDisplay = string.lower(LocalPlayer.DisplayName)
    local isTarget = (targetPart ~= "" and (myName:find(targetPart) or myDisplay:find(targetPart))) or (targetPart == "")

    if not isTarget then return end

    if cmd == "kill" then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
        end
    elseif cmd == "loopkill" then
        LoopKill = true
    elseif cmd == "unloopkill" then
        LoopKill = false
    elseif cmd == "freeze" then
        IsFrozen = true
    elseif cmd == "unfreeze" then
        IsFrozen = false
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
    elseif cmd == "bring" then
        ActiveAdmin = speaker
        IsBringLoop = true
    elseif cmd == "unbring" then
        IsBringLoop = false
        ActiveAdmin = nil
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            if root:FindFirstChild("BringForce") then root.BringForce:Destroy() end
            if root:FindFirstChild("BringAtt") then root.BringAtt:Destroy() end
        end
    end
end

local function SetupChat(player)
    player.Chatted:Connect(function(msg)
        if IsAdmin(player) then ExecuteCommand(msg, player) end
    end)
end

for _, p in pairs(Players:GetPlayers()) do SetupChat(p) end
Players.PlayerAdded:Connect(SetupChat)

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        -- Loopkill delay 3s
        if LoopKill and hum and (tick() - lastKillTime) >= 3 then
            hum.Health = 0
            lastKillTime = tick()
        end
        
        if IsBringLoop and ActiveAdmin and ActiveAdmin.Character and ActiveAdmin.Character:FindFirstChild("HumanoidRootPart") then
            local adminRoot = ActiveAdmin.Character.HumanoidRootPart
            local targetCFrame = adminRoot.CFrame * CFrame.new(0, 0, -5)
            local targetPos = targetCFrame.p
            
            CleanOtherPhysics(root)
            
            local dist = (targetPos - root.Position).Magnitude
            
            -- Setup LinearVelocity (Luôn duy trì để triệt tiêu lực khác)
            local att = root:FindFirstChild("BringAtt") or Instance.new("Attachment", root)
            att.Name = "BringAtt"
            local lv = root:FindFirstChild("BringForce") or Instance.new("LinearVelocity", root)
            lv.Name = "BringForce"
            lv.MaxForce = 9999999
            lv.Attachment0 = att

            if dist > 20 then
                -- Trạng thái kéo từ xa
                lv.VectorVelocity = (targetPos - root.Position).Unit * 200
            else
                -- Trạng thái áp sát (< 20 stud): Kết hợp CFrame và Velocity cực mạnh
                root.CFrame = targetCFrame
                lv.VectorVelocity = Vector3.new(0,0,0)
                root.Velocity = Vector3.new(0,0,0)
                root.RotVelocity = Vector3.new(0,0,0)
            end
            
            -- Noclip liên tục
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            
            if IsFrozen then root.Anchored = false end
        elseif IsFrozen and not IsBringLoop then
            root.Anchored = true
            root.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)
repeat task.wait() until game:IsLoaded()

local P,R,T,S,V=
game:GetService("Players"),
game:GetService("RunService"),
game:GetService("TextChatService"),
game:GetService("StarterGui"),
game:GetService("VirtualInputManager")

local L=P.LocalPlayer
repeat task.wait() until L


local E=false
local TG=nil
local BV=nil


local RANGE=30
local EXIT=45

local IN_SPEED=750
local OUT_SPEED=1100

local Side=1
local Mode="IN"
local Time=0



local function N(a,b)

	pcall(function()

		S:SetCore(
			"SendNotification",
			{
				Title=a,
				Text=b,
				Duration=3
			}
		)

	end)

end



N(
	"😈 SYSTEM",
	"wandering_loadvip"
)


pcall(function()

	T:WaitForChild("TextChannels")
	:WaitForChild("RBXGeneral")
	:DisplaySystemMessage(
		"👑wandering_loadvip👑"
	)

end)



local function Setup()

	local C=L.Character
	local H=C and C:FindFirstChild("HumanoidRootPart")

	if not H then return end


	if BV then
		BV:Destroy()
	end


	BV=Instance.new(
		"BodyVelocity",
		H
	)

	BV.MaxForce=
	Vector3.new(
		9e9,
		9e9,
		9e9
	)

	BV.Velocity=Vector3.zero

end




local function Tap(x,y)

	V:SendTouchEvent(
		0,
		Enum.UserInputState.Begin,
		x,y
	)

	V:SendTouchEvent(
		0,
		Enum.UserInputState.End,
		x,y
	)

end




local function Find(n)

	if not n then return end

	n=n:lower()

	for _,p in ipairs(P:GetPlayers()) do

		if p~=L and
		(
			p.Name:lower():find(n)
			or
			p.DisplayName:lower():find(n)
		)
		then
			return p
		end

	end

end





local function Cmd(m)

	local a=m:split(" ")

	if not a[1]
	or a[1]:lower()~=";wander" then
		return
	end



	if a[2]
	and a[2]:lower()=="rage" then


		local p=Find(a[3])

		if p then

			TG=p
			E=true

			Mode="IN"
			Time=0

			Setup()


			N(
				"RAGE",
				p.DisplayName
			)

		end



	elseif a[2]
	and a[2]:lower()=="unrage" then


		E=false
		TG=nil


		if BV then
			BV:Destroy()
			BV=nil
		end


		N(
			"RAGE",
			"OFF"
		)

	end

end





T.MessageReceived:Connect(function(m)

	local s=m.TextSource

	if s and
	P:GetPlayerByUserId(s.UserId)==L then

		Cmd(m.Text)

	end

end)





L.CharacterAdded:Connect(function()

	task.wait(1)

	if E then
		Setup()
	end

end)





R.Stepped:Connect(function()

	if not E then return end

	local C=L.Character

	if not C then return end


	for _,v in ipairs(C:GetDescendants()) do

		if v:IsA("BasePart") then
			v.CanCollide=false
		end

	end

end)






-- AUTO TAP

task.spawn(function()

	while true do

		task.wait(.08)


		if E and TG then


			local A=
			L.Character
			and L.Character:FindFirstChild("HumanoidRootPart")


			local B=
			TG.Character
			and TG.Character:FindFirstChild("HumanoidRootPart")


			if A and B
			and (A.Position-B.Position).Magnitude<25 then


				Tap(825,315)

				task.wait(.02)

				Tap(895,315)

			end


		end

	end

end)








-- TARGET DASH Y+6

R.Heartbeat:Connect(function(dt)


	local C=L.Character
	local H=C and C:FindFirstChild("HumanoidRootPart")


	if not(H and E and TG and BV) then
		return
	end



	local TR=
	TG.Character
	and TG.Character:FindFirstChild("HumanoidRootPart")


	if not TR then return end



	Time+=dt



	if Time>=1 then

		Time=0
		Side=-Side

	end



	local Y6=
	Vector3.new(0,6,0)



	local side =
	TR.CFrame.RightVector*
	Side



	local enter =
	TR.Position+
	Y6+
	side*8



	local escape =
	TR.Position+
	Y6+
	side*EXIT




	local dist=
	(H.Position-TR.Position).Magnitude




	if dist>RANGE then


		local dir=
		enter-H.Position


		if dir.Magnitude>0 then

			BV.Velocity=
			BV.Velocity:Lerp(
				dir.Unit*IN_SPEED,
				0.18
			)

		end



	else


		local dir=
		escape-H.Position


		if dir.Magnitude>0 then

			BV.Velocity=
			BV.Velocity:Lerp(
				dir.Unit*OUT_SPEED,
				0.25
			)

		end



	end


end)
