-- [[ EWEHUB - Rayfield UI Edition ]]
-- Game: Be a Lucky Block
-- Update: AFK Menu changed to Buttons & Added AFK Kekuatan

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- Variables & Configurations
local SPAWN_POS = CFrame.new(715, 39, -2122)
local FARM_TOKEN_POS = CFrame.new(705, 39, -2122) -- Home geser kiri 10 langkah
local AFK_KEKUATAN_POS = CFrame.new(735, 39, -2122) -- Home geser kanan 20 langkah
local WALK_POS = Vector3.new(710, 39, -2122)
local RESPAWN_POS = CFrame.new(737, 39, -2118)

_G.FarmBosses = {
    ["base14"] = false,
    ["base15"] = false,
    ["base16"] = false
}

-- Anti-Kick / Anti-AFK Roblox Core (Selalu aktif di background)
task.spawn(function()
    pcall(function()
        player.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end)
end)

-- ================= [ SERVICES / REMOTES ] ================= --
local KnitRF = ReplicatedStorage:WaitForChild("Packages", 5)
if KnitRF then
    KnitRF = KnitRF:WaitForChild("_Index", 5)
    if KnitRF then KnitRF = KnitRF:WaitForChild("sleitnick_knit@1.7.0", 5) end
    if KnitRF then KnitRF = KnitRF:WaitForChild("knit", 5) end
    if KnitRF then KnitRF = KnitRF:WaitForChild("Services", 5) end
end

local function GetRemote(serviceName, remoteName)
    if KnitRF then
        local service = KnitRF:FindFirstChild(serviceName)
        if service then
            local rf = service:FindFirstChild("RF")
            if rf then return rf:FindFirstChild(remoteName) end
        end
    end
    return nil
end

local claimGift = GetRemote("PlaytimeRewardService", "ClaimGift")
local rebirth = GetRemote("RebirthService", "Rebirth")
local upgrade = GetRemote("UpgradesService", "Upgrade")
local redeem = GetRemote("CodesService", "RedeemCode")
local collectEggRemote = GetRemote("EventService", "CollectEgg")

-- Helper for Brainrot Upgrades
local function FireUpgradeBrainrot(id)
    pcall(function()
        local args = { [1] = tostring(id) }
        game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.7.0").knit.Services.ContainerService.RF.UpgradeBrainrot:InvokeServer(unpack(args))
    end)
end

-- Helper for Finding Plot
local function GetMyPlot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:GetAttribute("OwnerId") == player.UserId then return plot end
        if plot:FindFirstChild(player.Name .. "_FloatingPlotSign", true) then return plot end
    end
    return nil
end

-- Boss Farm Logic Function
local function StartBossFarm(zoneName)
    task.spawn(function()
        while _G.FarmBosses[zoneName] do
            pcall(function()
                local char = player.Character or player.CharacterAdded:Wait()
                local root = char:WaitForChild("HumanoidRootPart", 5)
                local humanoid = char:WaitForChild("Humanoid", 5)
                local userId = player.UserId
                
                local modelsFolder = workspace:WaitForChild("RunningModels", 5)
                local zonesFolder = workspace:WaitForChild("CollectZones", 5)
                local target = zonesFolder and zonesFolder:WaitForChild(zoneName, 5)

                if not root or not humanoid or not modelsFolder or not target then return end

                root.CFrame = SPAWN_POS
                task.wait(0.3)
                
                humanoid:MoveTo(WALK_POS)
                
                local ownedModel = nil
                repeat
                    task.wait(0.3)
                    for _, obj in ipairs(modelsFolder:GetChildren()) do
                        if obj:IsA("Model") and obj:GetAttribute("OwnerId") == userId then
                            ownedModel = obj
                            break
                        end
                    end
                until ownedModel ~= nil or not _G.FarmBosses[zoneName]
                
                if not _G.FarmBosses[zoneName] then return end
                
                if ownedModel.PrimaryPart then
                    ownedModel:SetPrimaryPartCFrame(target.CFrame)
                else
                    local part = ownedModel:FindFirstChildWhichIsA("BasePart")
                    if part then part.CFrame = target.CFrame end
                end
                
                task.wait(0.7)
                
                if ownedModel and ownedModel.Parent == modelsFolder then
                    if ownedModel.PrimaryPart then
                        ownedModel:SetPrimaryPartCFrame(target.CFrame * CFrame.new(0, -5, 0))
                    else
                        local part = ownedModel:FindFirstChildWhichIsA("BasePart")
                        if part then part.CFrame = target.CFrame * CFrame.new(0, -5, 0) end
                    end
                end
                
                repeat task.wait(0.3) until not _G.FarmBosses[zoneName] or (ownedModel == nil or ownedModel.Parent ~= modelsFolder)
                if not _G.FarmBosses[zoneName] then return end
                
                local oldCharacter = player.Character
                repeat task.wait(0.2) until not _G.FarmBosses[zoneName] or (player.Character ~= oldCharacter and player.Character ~= nil)
                if not _G.FarmBosses[zoneName] then return end
                task.wait(0.4)
                
                local newChar = player.Character
                local newRoot = newChar and newChar:WaitForChild("HumanoidRootPart", 5)
                if newRoot then newRoot.CFrame = RESPAWN_POS end
                
                task.wait(2.1)
            end)
        end
    end)
end

-- ================= [ RAYFIELD UI SETUP ] ================= --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "EWEHUB | Be a Lucky Block",
    LoadingTitle = "EWEHUB Execution",
    LoadingSubtitle = "by EWEHUB Team",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "EWEHUB_Configs",
        FileName = "LuckyBlock_Config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- [[ TABS DECLARATION ]]
local MainTab = Window:CreateTab("Main", 4483362458)
local ZoneTab = Window:CreateTab("Zone", 4483362458)
local CollectTab = Window:CreateTab("Collect", 4483362458)
local AFKTab = Window:CreateTab("AFK Menu", 4483362458)
local DetailsTab = Window:CreateTab("Details", 4483362458)

-- ================= [ MAIN TAB FEATURES ] ================= --
MainTab:CreateSection("Core Exploit")

local SpeedValue = 50
local SpeedBypassActive = false
local SpeedConnection

MainTab:CreateToggle({
    Name = "Bypass Speed ⚡",
    CurrentValue = false,
    Flag = "BypassSpeedToggle",
    Callback = function(Value)
        SpeedBypassActive = Value
        if Value then
            task.spawn(function()
                while SpeedBypassActive do
                    pcall(function()
                        local RF = game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.7.0").knit.Services.RunningService.RF
                        RF.StartMove:InvokeServer()
                    end)
                    task.wait(1)
                end
            end)

            SpeedConnection = RunService.RenderStepped:Connect(function(deltaTime)
                pcall(function()
                    local char = player.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local hum = char:FindFirstChild("Humanoid")
                        if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                            local boost = (SpeedValue / 10) * (deltaTime * 60)
                            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * boost)
                        end
                    end
                end)
            end)
        else
            if SpeedConnection then
                SpeedConnection:Disconnect()
                SpeedConnection = nil
            end
        end
    end,
})

MainTab:CreateSlider({
    Name = "Speed Value",
    Range = {1, 1000},
    Increment = 1,
    Suffix = "Value",
    CurrentValue = 50,
    Flag = "SpeedValueSlider",
    Callback = function(Value)
        SpeedValue = Value
    end,
})

local removeDetectors = false
local storedParts = {}
MainTab:CreateToggle({
    Name = "Prevent Boss 🤖",
    CurrentValue = false,
    Flag = "PreventBossToggle",
    Callback = function(Value)
        removeDetectors = Value
        local folder = workspace:WaitForChild("BossTouchDetectors", 5)
        if folder then
            if removeDetectors then
                storedParts = {}
                for _, obj in ipairs(folder:GetChildren()) do
                    table.insert(storedParts, obj)
                    obj.Parent = nil
                end
            else
                for _, obj in ipairs(storedParts) do
                    if obj then obj.Parent = folder end
                end
                storedParts = {}
            end
        end
    end,
})

MainTab:CreateButton({
    Name = "Teleport Home 🏠",
    Callback = function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = SPAWN_POS
        end
    end,
})

local AutoCollectEgg = false
MainTab:CreateToggle({
    Name = "Auto Collect Egg & Hat 🥚🎩 (Fast)",
    CurrentValue = false,
    Flag = "AutoCollectEggHat",
    Callback = function(Value)
        AutoCollectEgg = Value
        if Value then
            task.spawn(function()
                while AutoCollectEgg do
                    task.spawn(function()
                        pcall(function()
                            if collectEggRemote then collectEggRemote:InvokeServer()
                            else game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.7.0").knit.Services.EventService.RF.CollectEgg:InvokeServer() end
                        end)
                        pcall(function() game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.7.0").knit.Services.EventService.RF.CollectHat:InvokeServer() end)
                    end)
                    task.wait()
                end
            end)
        end
    end,
})

-- ================= [ ZONE TAB FEATURES ] ================= --
ZoneTab:CreateSection("Auto Farm Bosses")

ZoneTab:CreateToggle({
    Name = "Auto Boss 14 🤖",
    CurrentValue = false,
    Flag = "Boss14Toggle",
    Callback = function(Value)
        _G.FarmBosses["base14"] = Value
        if Value then StartBossFarm("base14") end
    end,
})

ZoneTab:CreateToggle({
    Name = "Auto Boss 15 👾",
    CurrentValue = false,
    Flag = "Boss15Toggle",
    Callback = function(Value)
        _G.FarmBosses["base15"] = Value
        if Value then StartBossFarm("base15") end
    end,
})

ZoneTab:CreateToggle({
    Name = "Auto Boss 16 👑",
    CurrentValue = false,
    Flag = "Boss16Toggle",
    Callback = function(Value)
        _G.FarmBosses["base16"] = Value
        if Value then StartBossFarm("base16") end
    end,
})

-- ================= [ COLLECT TAB FEATURES ] ================= --
CollectTab:CreateSection("Auto Rewards & Upgrades")

local AutoCollectMoney = false
CollectTab:CreateToggle({
    Name = "Auto Collect Money 💸",
    CurrentValue = false,
    Flag = "AutoCollectMoney",
    Callback = function(Value)
        AutoCollectMoney = Value
        if Value then
            task.spawn(function()
                while AutoCollectMoney do
                    pcall(function()
                        local char = player.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        local searchArea = GetMyPlot() or workspace:FindFirstChild("Plots")
                        
                        if hrp and searchArea then
                            for _, obj in ipairs(searchArea:GetDescendants()) do
                                if not AutoCollectMoney then break end
                                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                                    if string.find(obj.Text, "%$") then
                                        local gui = obj:FindFirstAncestorWhichIsA("SurfaceGui") or obj:FindFirstAncestorWhichIsA("BillboardGui")
                                        if gui and gui.Parent and gui.Parent:IsA("BasePart") then
                                            local targetPart = gui.Parent
                                            if firetouchinterest then
                                                firetouchinterest(hrp, targetPart, 0)
                                                task.wait()
                                                firetouchinterest(hrp, targetPart, 1)
                                            else
                                                hrp.CFrame = targetPart.CFrame * CFrame.new(0, 2, 0)
                                                task.wait(0.1) 
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(1.5) 
                end
            end)
        end
    end,
})

local AutoClaimPlaytime = false
CollectTab:CreateToggle({
    Name = "Auto Ready 🎁",
    CurrentValue = false,
    Flag = "AutoReadyGift",
    Callback = function(Value)
        AutoClaimPlaytime = Value
        if Value and claimGift then
            task.spawn(function()
                while AutoClaimPlaytime do
                    for i = 1, 12 do
                        if not AutoClaimPlaytime then break end
                        pcall(function() claimGift:InvokeServer(i) end)
                        task.wait(0.2)
                    end
                    task.wait(5)
                end
            end)
        end
    end,
})

local AutoRebirth = false
CollectTab:CreateToggle({
    Name = "Auto Rebirth ♻️",
    CurrentValue = false,
    Flag = "AutoRebirth",
    Callback = function(Value)
        AutoRebirth = Value
        if Value and rebirth then
            task.spawn(function()
                while AutoRebirth do
                    pcall(function() rebirth:InvokeServer() end)
                    task.wait(1)
                end
            end)
        end
    end,
})

local AutoUpgradeSpeed = false
CollectTab:CreateToggle({
    Name = "Auto Upgrade Speed 👟",
    CurrentValue = false,
    Flag = "AutoUpgradeSpeed",
    Callback = function(Value)
        AutoUpgradeSpeed = Value
        if Value and upgrade then
            task.spawn(function()
                while AutoUpgradeSpeed do
                    pcall(function() upgrade:InvokeServer("MovementSpeed", 1) end)
                    task.wait(1)
                end
            end)
        end
    end,
})

local AutoUpgradeAllBrainrot = false
CollectTab:CreateToggle({
    Name = "Auto Upgrade All Brainrot 🧠",
    CurrentValue = false,
    Flag = "AutoUpgradeAllBrainrot",
    Callback = function(Value)
        AutoUpgradeAllBrainrot = Value
        if Value then
            task.spawn(function()
                while AutoUpgradeAllBrainrot do
                    for i = 1, 30 do
                        if not AutoUpgradeAllBrainrot then break end
                        FireUpgradeBrainrot(i)
                        task.wait(0.1) 
                    end
                    task.wait(0.5)
                end
            end)
        end
    end,
})

local AutoUpgradeSpecificBrainrot = false
local SpecificBrainrotID = 1

CollectTab:CreateToggle({
    Name = "Auto Upgrade Specific 🧠",
    CurrentValue = false,
    Flag = "AutoUpgradeSpecificBrainrot",
    Callback = function(Value)
        AutoUpgradeSpecificBrainrot = Value
        if Value then
            task.spawn(function()
                while AutoUpgradeSpecificBrainrot do
                    FireUpgradeBrainrot(SpecificBrainrotID)
                    task.wait(0.01)
                end
            end)
        end
    end,
})

CollectTab:CreateSlider({
    Name = "Specific Brainrot ID",
    Range = {1, 30},
    Increment = 1,
    Suffix = "ID",
    CurrentValue = 1,
    Flag = "SpecificBrainrotID",
    Callback = function(Value)
        SpecificBrainrotID = Value
    end,
})

CollectTab:CreateButton({
    Name = "Redeem All Code 🎁",
    Callback = function()
        if redeem then
            local codes = {"release", "lucky", "block", "free", "update", "gems"}
            task.spawn(function()
                for _, code in ipairs(codes) do
                    pcall(function() redeem:InvokeServer(code) end)
                    task.wait(0.3)
                end
            end)
        end
    end,
})

-- ================= [ AFK TAB FEATURES ] ================= --
AFKTab:CreateSection("Grinding / AFK Mode")

-- Tombol 1: Farm Token
AFKTab:CreateButton({
    Name = "Farm Token 🪙",
    Callback = function()
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = FARM_TOKEN_POS
            end
            
            Rayfield:Notify({
                Title = "EWEHUB AFK",
                Content = "Teleportasi ke Zona Farm Token Berhasil!",
                Duration = 3,
                Image = 4483362458,
            })
        end)
    end,
})

-- Tombol 2: AFK Kekuatan
AFKTab:CreateButton({
    Name = "AFK Kekuatan 💪",
    Callback = function()
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = AFK_KEKUATAN_POS
            end
            
            Rayfield:Notify({
                Title = "EWEHUB AFK",
                Content = "Teleportasi ke Zona AFK Kekuatan Berhasil!",
                Duration = 3,
                Image = 4483362458,
            })
        end)
    end,
})

-- ================= [ DETAILS TAB FEATURES ] ================= --
DetailsTab:CreateSection("About EWEHUB")
DetailsTab:CreateParagraph({Title = "Script Info", Content = "Be a Lucky Block Edition\nReconstructed with Rayfield Library."})
DetailsTab:CreateParagraph({Title = "Credits", Content = "Developed by EWEHUB Team\nOriginal Logic Powered by FARTEZ."})

Rayfield:Notify({
    Title = "EWEHUB Loaded Successfully!",
    Content = "Enjoy hacking with EWEHUB Premium UI.",
    Duration = 5,
    Image = 4483362458,
})
