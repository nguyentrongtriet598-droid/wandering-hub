-- Pink Love Full Effect (Delta X)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local SoundService = game:GetService("SoundService")
-- Xóa GUI cũ
if PlayerGui:FindFirstChild("PinkLoveGui") then
PlayerGui.PinkLoveGui:Destroy()
end
-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PinkLoveGui"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = PlayerGui
-- Background hồng
local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1,1)
bg.BackgroundColor3 = Color3.fromRGB(255,170,200)
bg.BorderSizePixel = 0
bg.Parent = gui
-- Text
local text = Instance.new("TextLabel")
text.AnchorPoint = Vector2.new(0.5,0.5)
text.Position = UDim2.fromScale(0.5,0.5)
text.Size = UDim2.fromScale(0.85,0.6)
text.BackgroundTransparency = 1
text.TextColor3 = Color3.new(1,1,1)
text.Font = Enum.Font.GothamMedium
text.TextWrapped = true
text.TextScaled = true
text.TextTransparency = 1
text.Parent = bg
text.Text =
"đọc là óc chó 😂🖕"
-- Hiện chữ mượt
for i = 1,0,-0.05 do
text.TextTransparency = i
task.wait(0.05)
end
-- Nhạc nền (Love Nwantiti – dễ chạy)
local music = Instance.new("Sound")
music.SoundId = "rbxassetid://7453158420"
music.Volume = 1
music.Looped = true
music.Parent = SoundService
music:Play()
-- Tim bay
spawn(function()
while true do
local heart = Instance.new("TextLabel")
heart.Text = "❤"
heart.Font = Enum.Font.GothamBold
heart.TextColor3 = Color3.fromRGB(255,80,120)
heart.TextScaled = true
heart.BackgroundTransparency = 1
heart.Size = UDim2.fromScale(0.05,0.05)
heart.Position = UDim2.fromScale(math.random(),1)
heart.Parent = bg
local tween = game:GetService("TweenService"):Create(
heart,
TweenInfo.new(3),
{Position = UDim2.fromScale(math.random(), -0.1), TextTransparency = 1}
)
tween:Play()
game.Debris:AddItem(heart,3)
task.wait(0.4)
end
end)
