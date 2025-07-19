-- Roblox Bug Testing Script (Nur für autorisierte Tests)
local function testMovementBug()
    local player = game:GetService("Players").LocalPlayer
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 50 -- Testet erhöhte Geschwindigkeit (falls erlaubt)
            print("Movement Bug Test aktiviert: WalkSpeed = 50")
        end
    end
end

local function testTeleportBug(position)
    local player = game:GetService("Players").LocalPlayer
    if player.Character then
        player.Character:SetPrimaryPartCFrame(CFrame.new(position))
        print("Teleport Bug Test: Position geändert zu", position)
    end
end

-- GUI-Test für mögliche Fehler
local function testGuiBug()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = "GUI-Bug-Test"
    textLabel.Size = UDim2.new(0, 200, 0, 50)
    textLabel.Position = UDim2.new(0.5, -100, 0.5, -25)
    textLabel.Parent = screenGui
    
    print("GUI-Bug-Test aktiviert")
end

-- Hauptfunktionen exportieren
return {
    testMovementBug = testMovementBug,
    testTeleportBug = testTeleportBug,
    testGuiBug = testGuiBug
}
