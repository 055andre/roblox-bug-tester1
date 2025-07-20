local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- GUI erstellen
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Flying GUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.5, 0, 0.5, 0)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0.9, 0, 0.8, 0)
toggle.Position = UDim2.new(0.05, 0, 0.1, 0)
toggle.Text = "Fly Mode"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggle.Parent = frame

-- Flug-Logik
local isFlying = false
local flySpeed = 75
local flyConnection = nil

local function startFlying()
    if isFlying then return end
    isFlying = true
    toggle.Text = "ON"
    toggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Parent = rootPart

    flyConnection = RunService.Heartbeat:Connect(function()
        if not isFlying then return end
        
        local direction = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + rootPart.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - rootPart.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - rootPart.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + rootPart.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction + Vector3.new(0, -1, 0)
        end

        if direction.Magnitude > 0 then
            bodyVelocity.Velocity = direction.Unit * flySpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function stopFlying()
    if not isFlying then return end
    isFlying = false
    toggle.Text = "OFF"
    toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    for _, v in ipairs(rootPart:GetChildren()) do
        if v:IsA("BodyVelocity") then
            v:Destroy()
        end
    end

    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end

toggle.MouseButton1Click:Connect(function()
    if isFlying then
        stopFlying()
    else
        startFlying()
    end
end)

-- Cleanup bei Respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    stopFlying()
end)

