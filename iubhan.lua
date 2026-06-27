Local Player = game.Players.LocalPlayer
local RS, RunService, UIS = game:GetService("ReplicatedStorage"), game:GetService("RunService"), game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local CombatRemote = RS:FindFirstChild("CombatRemote")
local ActionRemote = RS:FindFirstChild("ActionRemote")

-- BIẾN CẤU HÌNH
local IsTelePro, IsNoclip, IsInfJump, IsSpeedHack, IsAutoClick = false, false, true, true, false
local IsAntiStun = false; local NoclipTimer = 0; local CurrentWS = 120
local IsHitboxAll, HBS, IgnoreList = true, 28, {}
local AutoFarmActive, SpamEActive = false, false
local TargetPos = Vector3.new(518.2, 4.2, 150.2); local Speed = 300; local IsForceRespawn = false
local SpawnTime = tick() 

-- GIAO DIỆN
local SG = Instance.new("ScreenGui", game.CoreGui)
local Toggle = Instance.new("TextButton", SG); Toggle.Size = UDim2.new(0, 45, 0, 45); Toggle.Position = UDim2.new(0, 10, 0.5, -22); Toggle.Text = "W"; Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Toggle.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
local Main = Instance.new("Frame", SG); Main.Size = UDim2.new(0, 260, 0, 400); Main.Position = UDim2.new(0.5, -130, 0.5, -200); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Visible = true; Main.Active = true; Main.Draggable = true; Instance.new("UICorner", Main)
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 34); Title.Text = "HOMELESS VIP V2"; Title.BackgroundTransparency = 1; Title.TextColor3 = Color3.fromRGB(212, 175, 55); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 22

local Tabs, Frames = {}, {}
local TabNames = {"COMBAT", "HITBOX", "KHÁC"}
for i = 1, 3 do
    local b = Instance.new("TextButton", Main); b.Size = UDim2.new(0, 80, 0, 28); b.Position = UDim2.new(0, (i - 1) * 85 + 5, 0, 35); b.Text = TabNames[i]; b.BackgroundColor3 = Color3.fromRGB(120, 0, 0); b.TextColor3 = Color3.fromRGB(255, 230, 230); b.Font = Enum.Font.GothamBlack; b.TextSize = 14; Instance.new("UICorner", b); Tabs[i] = b
    local f = Instance.new("Frame", Main); f.Size = UDim2.new(1, -10, 1, -70); f.Position = UDim2.new(0, 5, 0, 65); f.Visible = (i == 1); f.BackgroundTransparency = 1; Frames[i] = f
end

local function Btn(p, t, y, w, c) local b = Instance.new("TextButton", p); b.Size = UDim2.new(0, w or 230, 0, 28); b.Position = UDim2.new(0, 5, 0, y); b.Text = t; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b); return b end
local inT = Instance.new("TextBox", Frames[1]); inT.Size = UDim2.new(0, 230, 0, 30); inT.Position = UDim2.new(0, 5, 0, 0); inT.Text = "NHẬP TÊN..."; inT.BackgroundColor3 = Color3.fromRGB(30, 30, 30); inT.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", inT)
local bTele = Btn(Frames[1], "TẤN CÔNG MỤC TIÊU", 40, 230, Color3.fromRGB(100, 0, 0))
local bAtk = Btn(Frames[1], "WANDER IMPACT (VIP)", 75, 230, Color3.fromRGB(100, 60, 0))

Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
bTele.MouseButton1Click:Connect(function() IsTelePro = not IsTelePro; bTele.BackgroundColor3 = IsTelePro and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 0, 0) end)
bAtk.MouseButton1Click:Connect(function() IsAutoClick = not IsAutoClick; bAtk.BackgroundColor3 = IsAutoClick and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 60, 0) end)

--// LOGIC CHÍNH: BÁM DÍNH TRỰC TIẾP (GIỐNG VIDEO)
RunService.Stepped:Connect(function() 
    local c = Player.Character; if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local hrp = c.HumanoidRootPart; local hum = c:FindFirstChildOfClass("Humanoid"); local s = inT.Text:lower()
    
    if IsTelePro and s ~= "" and s ~= "nhập tên..." then
        for _, p in pairs(game.Players:GetPlayers()) do 
            if p ~= Player and (p.Name:lower():find(s) or p.DisplayName:lower():find(s)) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
                local thrp = p.Character.HumanoidRootPart
                -- Ép trạng thái vật lý để không bị trọng lực kéo
                hum:ChangeState(Enum.HumanoidStateType.Physics)
                hrp.AssemblyLinearVelocity = Vector3.zero
                -- DÍNH CHẶT (OFFSET 1.2)
                hrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 1.2)
                break
            end 
        end
    end
end)

--// AUTO CLICK & AUTO BLOCK
task.spawn(function() while true do task.wait(0.01); if IsAutoClick and CombatRemote then pcall(function() CombatRemote:FireServer("M1"); if math.random(1, 4) == 4 then CombatRemote:FireServer("Kick") end end) end end end)
task.spawn(function() while true do task.wait(0.025); if IsAutoClick and CombatRemote then pcall(function() CombatRemote:FireServer("Block", false); RunService.Heartbeat:Wait(); CombatRemote:FireServer("Block", true) end) end end end)
