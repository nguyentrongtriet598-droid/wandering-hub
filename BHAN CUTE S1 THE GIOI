local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Enabled = false
local Size = 150

local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

local btn = Instance.new("TextButton")
btn.Parent = gui
btn.Size = UDim2.new(0,100,0,50)
btn.Position = UDim2.new(0,20,0.7,0)
btn.Text = "LOCK OFF"

btn.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    btn.Text = Enabled and "LOCK ON" or "LOCK OFF"
end)

local plus = Instance.new("TextButton")
plus.Parent = gui
plus.Size = UDim2.new(0,50,0,50)
plus.Position = UDim2.new(0,130,0.7,0)
plus.Text = "+"

plus.MouseButton1Click:Connect(function()
    Size += 10
end)

local minus = Instance.new("TextButton")
minus.Parent = gui
minus.Size = UDim2.new(0,50,0,50)
minus.Position = UDim2.new(0,190,0.7,0)
minus.Text = "-"

minus.MouseButton1Click:Connect(function()
    Size = math.max(10, Size - 10)
end)

local circle = Drawing.new("Circle")
circle.Filled = false
circle.Thickness = 2

local function getTarget()
    local target = nil
    local closest = Size
    local center = Camera.ViewportSize / 2

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local pos, visible = Camera:WorldToViewportPoint(root.Position)

                if visible then
                    local dis = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                    if dis < closest then
                        closest = dis
                        target = root
                    end
                end
            end
        end
    end

    return target
end

RunService.RenderStepped:Connect(function()
    local center = Camera.ViewportSize / 2

    circle.Position = Vector2.new(center.X, center.Y)
    circle.Radius = Size
    circle.Visible = Enabled

    if Enabled then
        local target = getTarget()
        if target then
            Camera.CFrame = CFrame.lookAt(
                Camera.CFrame.Position,
                target.Position
            )
        end
    end
end)
