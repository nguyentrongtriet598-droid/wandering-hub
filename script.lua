repeat task.wait() until game:IsLoaded()

local P,R,T,S,V=game:GetService("Players"),game:GetService("RunService"),game:GetService("TextChatService"),game:GetService("StarterGui"),game:GetService("VirtualInputManager")
local L=P.LocalPlayer
repeat task.wait() until L

local E,TG,BV=false,nil,nil
local NF,HF,TPD=250,500,18

local function N(a,b)
	pcall(function()
		S:SetCore("SendNotification",{Title=a,Text=b,Duration=3})
	end)
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

	if a[2] and a[2]:lower()=="rage" then
		local p=Find(a[3])
		if p then
			TG,E=p,true
			Setup()
			N("WANDER RAGE","Target: "..p.DisplayName)
		end
	elseif a[2] and a[2]:lower()=="unrage" then
		E,TG=false,nil
		if BV then BV:Destroy() BV=nil end
		N("WANDER RAGE","Disabled")
	end
end

T.MessageReceived:Connect(function(m)
	local s=m.TextSource
	if s and P:GetPlayerByUserId(s.UserId)==L then
		Cmd(m.Text)
	end
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
				if H.Position.Y-Y>50 then
					D=Vector3.new(D.X,-.6,D.Z).Unit
				end
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
			H.CFrame=TR.CFrame*CFrame.new(
				math.cos(tick()*220)*10,
				math.sin(tick()*150)*5,
				math.sin(tick()*220)*10
			)
		end
	end
end)

N("SYSTEM","Wander Loaded.")
