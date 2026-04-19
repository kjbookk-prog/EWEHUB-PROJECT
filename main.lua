repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local folder = workspace:WaitForChild("Live", 10):WaitForChild("Friends", 10)

local selectedBlock = nil
local autoStealEnabled = false
local uiVisible = true

-- // CONFIGURATION
local CONFIG = {
    Primary = Color3.fromRGB(0, 255, 150),
    Secondary = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(255, 255, 255),
    Key = "EWEHUB" -- Ganti dengan Key dari LootLabs kamu
}

-- // UTILS
local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function round(obj, radius)
    create("UICorner", {CornerRadius = UDim.new(0, radius), Parent = obj})
end

local function addStroke(obj, color, thickness, trans)
    create("UIStroke", {
        Color = color,
        Thickness = thickness,
        Transparency = trans or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = obj
    })
end

-- // MAIN CONTAINER
local gui = create("ScreenGui", {Name = "EWEHUB_PREMIUM", Parent = CoreGui, ResetOnSpawn = false})

-- =========================================================
-- // 1. KEY SYSTEM INTERFACE
-- =========================================================
local keyFrame = create("Frame", {
    Name = "KeySystem",
    Parent = gui,
    Size = UDim2.new(0, 350, 0, 220),
    Position = UDim2.new(0.5, -175, 0.5, -110),
    BackgroundColor3 = CONFIG.Secondary,
    ClipsDescendants = true
})
round(keyFrame, 12)
addStroke(keyFrame, CONFIG.Primary, 1.5, 0.5)

create("TextLabel", {
    Parent = keyFrame,
    Size = UDim2.new(1, 0, 0, 50),
    Text = "EWEHUB | AUTHENTICATION",
    TextColor3 = CONFIG.Primary,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    BackgroundTransparency = 1
})

local keyInput = create("TextBox", {
    Parent = keyFrame,
    Size = UDim2.new(0, 280, 0, 45),
    Position = UDim2.new(0.5, -140, 0, 70),
    BackgroundColor3 = CONFIG.Accent,
    Text = "",
    PlaceholderText = "Enter Activation Key...",
    TextColor3 = CONFIG.Text,
    Font = Enum.Font.GothamMedium,
    TextSize = 14
})
round(keyInput, 8)
addStroke(keyInput, Color3.fromRGB(60, 60, 60), 1)

local getBtn = create("TextButton", {
    Parent = keyFrame,
    Size = UDim2.new(0, 135, 0, 40),
    Position = UDim2.new(0.5, -140, 0, 130),
    BackgroundColor3 = CONFIG.Accent,
    Text = "Get Key",
    TextColor3 = Color3.fromRGB(200, 200, 200),
    Font = Enum.Font.GothamBold,
    TextSize = 14
})
round(getBtn, 8)

local verifyBtn = create("TextButton", {
    Parent = keyFrame,
    Size = UDim2.new(0, 135, 0, 40),
    Position = UDim2.new(0.5, 5, 0, 130),
    BackgroundColor3 = CONFIG.Primary,
    Text = "Verify Key",
    TextColor3 = Color3.fromRGB(0, 0, 0),
    Font = Enum.Font.GothamBold,
    TextSize = 14
})
round(verifyBtn, 8)

-- =========================================================
-- // 2. MAIN HUB INTERFACE (HIDDEN AT START)
-- =========================================================
local mainHub = create("Frame", {
    Name = "MainHub",
    Parent = gui,
    Size = UDim2.new(0, 480, 0, 320),
    Position = UDim2.new(0.5, -240, 0.5, -160),
    BackgroundColor3 = CONFIG.Secondary,
    Visible = false,
    Draggable = true,
    Active = true
})
round(mainHub, 12)
addStroke(mainHub, CONFIG.Primary, 1.2, 0.6)

-- Sidebar Navigation
local sidebar = create("Frame", {
    Parent = mainHub,
    Size = UDim2.new(0, 140, 1, 0),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.5
})
round(sidebar, 12)

create("TextLabel", {
    Parent = sidebar,
    Size = UDim2.new(1, 0, 0, 60),
    Text = "EWEHUB",
    TextColor3 = CONFIG.Primary,
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    BackgroundTransparency = 1
})

-- Content Area
local content = create("Frame", {
    Parent = mainHub,
    Position = UDim2.new(0, 150, 0, 10),
    Size = UDim2.new(1, -160, 1, -20),
    BackgroundTransparency = 1
})

-- // Dropdown & Buttons (Premium Style)
local dropdownBtn = create("TextButton", {
    Parent = content,
    Size = UDim2.new(1, 0, 0, 45),
    Text = "Select Target Block  ▼",
    BackgroundColor3 = CONFIG.Accent,
    TextColor3 = Color3.fromRGB(200, 200, 200),
    Font = Enum.Font.GothamMedium,
    TextSize = 13
})
round(dropdownBtn, 8)

local listFrame = create("ScrollingFrame", {
    Parent = content,
    Position = UDim2.new(0, 0, 0, 50),
    Size = UDim2.new(1, 0, 0, 130),
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    Visible = false,
    ScrollBarThickness = 2,
    ZIndex = 5
})
round(listFrame, 8)
local layout = create("UIListLayout", {Parent = listFrame, Padding = UDim.new(0, 5)})

local autoStealBtn = create("TextButton", {
    Parent = content,
    Position = UDim2.new(0, 0, 1, -100),
    Size = UDim2.new(1, 0, 0, 45),
    Text = "AUTO STEAL: DISABLED",
    BackgroundColor3 = Color3.fromRGB(40, 20, 20),
    TextColor3 = Color3.fromRGB(255, 100, 100),
    Font = Enum.Font.GothamBold,
    TextSize = 13
})
round(autoStealBtn, 8)

local stealBtn = create("TextButton", {
    Parent = content,
    Position = UDim2.new(0, 0, 1, -45),
    Size = UDim2.new(1, 0, 0, 45),
    Text = "EXECUTE STEAL",
    BackgroundColor3 = CONFIG.Primary,
    TextColor3 = Color3.fromRGB(0, 0, 0),
    Font = Enum.Font.GothamBold,
    TextSize = 13
})
round(stealBtn, 8)

-- Toggle Button (Floating Logo)
local toggleBtn = create("TextButton", {
    Parent = gui,
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 20, 0.8, 0),
    Text = "EWE",
    BackgroundColor3 = CONFIG.Secondary,
    TextColor3 = CONFIG.Primary,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    Visible = false,
    Draggable = true
})
round(toggleBtn, 25)
addStroke(toggleBtn, CONFIG.Primary, 2)

-- =========================================================
-- // CORE FUNCTIONS
-- =========================================================

local function refreshList()
    if not folder then return end
    local counts = {}
    for _, v in pairs(folder:GetChildren()) do
        if v:FindFirstChild("RootPart") and v.RootPart:FindFirstChild("StealPrompt") then
            counts[v.Name] = (counts[v.Name] or 0) + 1
        end
    end

    for _, v in pairs(listFrame:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    for name, count in pairs(counts) do
        local b = create("TextButton", {
            Parent = listFrame,
            Size = UDim2.new(1, -5, 0, 35),
            Text = "  " .. name .. " (" .. count .. ")",
            BackgroundColor3 = CONFIG.Accent,
            TextColor3 = CONFIG.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6
        })
        round(b, 6)
        b.MouseButton1Click:Connect(function()
            selectedBlock = name
            dropdownBtn.Text = name .. " (" .. count .. ")"
            listFrame.Visible = false
        end)
    end
end

local function doSteal()
    local char = player.Character
    if not (char and selectedBlock and folder) then return end
    
    for _, v in pairs(folder:GetChildren()) do
        if v.Name == selectedBlock and v:FindFirstChild("RootPart") then
            local prompt = v.RootPart:FindFirstChild("StealPrompt")
            if prompt then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = v.RootPart.CFrame * CFrame.new(0, 0, 3)
                    task.wait(0.15)
                    fireproximityprompt(prompt)
                    task.wait(0.15)
                    hrp.CFrame = CFrame.new(-134.58, 1, 261.64)
                end
                break
            end
        end
    end
end

-- =========================================================
-- // LOGIC HANDLERS
-- =========================================================

getBtn.MouseButton1Click:Connect(function()
    setclipboard("https://creators.lootlabs.gg/your-link-here") -- Ganti link kamu
    getBtn.Text = "Link Copied!"
    task.wait(2)
    getBtn.Text = "Get Key"
end)

verifyBtn.MouseButton1Click:Connect(function()
    if keyInput.Text == CONFIG.Key then
        TweenService:Create(keyFrame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -175, 1, 50)}):Play()
        task.wait(0.5)
        keyFrame:Destroy()
        mainHub.Visible = true
        toggleBtn.Visible = true
        
        -- Start Background Loops
        task.spawn(function()
            while task.wait(5) do refreshList() end
        end)
        task.spawn(function()
            while task.wait(1.2) do if autoStealEnabled then doSteal() end end
        end)
    else
        verifyBtn.Text = "Invalid Key!"
        verifyBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        task.wait(1.5)
        verifyBtn.Text = "Verify Key"
        verifyBtn.BackgroundColor3 = CONFIG.Primary
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    mainHub.Visible = uiVisible
end)

dropdownBtn.MouseButton1Click:Connect(function()
    listFrame.Visible = not listFrame.Visible
end)

autoStealBtn.MouseButton1Click:Connect(function()
    autoStealEnabled = not autoStealEnabled
    autoStealBtn.Text = "AUTO STEAL: " .. (autoStealEnabled and "ENABLED" or "DISABLED")
    autoStealBtn.TextColor3 = autoStealEnabled and CONFIG.Primary or Color3.fromRGB(255, 100, 100)
    autoStealBtn.BackgroundColor3 = autoStealEnabled and Color3.fromRGB(20, 40, 30) or Color3.fromRGB(40, 20, 20)
end)

stealBtn.MouseButton1Click:Connect(doSteal)

-- Hotkey to Hide
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and (input.KeyCode == Enum.KeyCode.RightControl) then
        uiVisible = not uiVisible
        mainHub.Visible = uiVisible
    end
end)
