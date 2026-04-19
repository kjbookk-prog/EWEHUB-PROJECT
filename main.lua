--[[ 
    EWEHUB V2 - PROTECTED EDITION 
    Status: FREE & OBFUSCATED
]]

local _0x5f2a = "repeat task.wait() until game:IsLoaded()"; loadstring(_0x5f2a)()
local _EWE = {
    ['\108\111\97\100\105\110\103'] = function()
        local s, r = pcall(function()
            local P = game:GetService("\80\108\97\121\101\114\115")["\76\111\99\97\108\80\108\97\121\101\114"]
            local U = game:GetService("\85\115\101\114\73\110\112\117\116\83\101\114\118\105\99\101")
            local T = game:GetService("\84\119\101\101\110\83\101\114\118\105\93\101")
            local C = game:GetService("\67\111\114\101\71\117\105")
            local F = workspace:WaitForChild("\76\105\118\101", 15):WaitForChild("\70\114\105\101\110\100\115", 15)
            
            -- // Configuration Decryption
            local CFG = {
                P = Color3.fromRGB(0, 255, 150),
                S = Color3.fromRGB(15, 15, 15),
                A = Color3.fromRGB(25, 25, 25),
                T = Color3.fromRGB(255, 255, 255)
            }

            -- // System Core
            local function _c(cl, pr)
                local i = Instance.new(cl)
                for k, v in pairs(pr) do i[k] = v end
                return i
            end

            local g = _c("\83\99\114\101\101\110\71\117\105", {Name = "\69\87\69\72\85\66\95\86\50", Parent = C, ResetOnSpawn = false})
            
            -- // Premium Loading Layer
            local lf = _c("Frame", {Parent = g, Size = UDim2.new(0, 320, 0, 160), Position = UDim2.new(0.5, -160, 0.5, -80), BackgroundColor3 = CFG.S})
            Instance.new("UICorner", lf).CornerRadius = UDim.new(0, 12)
            
            local lt = _c("TextLabel", {Parent = lf, Size = UDim2.new(1, 0, 0, 60), Text = "\69\87\69\72\85\66", TextColor3 = CFG.P, Font = 3, TextSize = 35, BackgroundTransparency = 1})
            local st = _c("TextLabel", {Parent = lf, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 75), Text = "\73\110\105\116\105\97\108\105\122\105\110\103\46\46\46", TextColor3 = Color3.fromRGB(150, 150, 150), Font = 3, TextSize = 12, BackgroundTransparency = 1})
            
            local bb = _c("Frame", {Parent = lf, Size = UDim2.new(0, 240, 0, 6), Position = UDim2.new(0.5, -120, 0, 110), BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
            local bf = _c("Frame", {Parent = bb, Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = CFG.P})
            Instance.new("UICorner", bb).CornerRadius = UDim.new(0, 3)
            Instance.new("UICorner", bf).CornerRadius = UDim.new(0, 3)

            -- // Execution Logic
            task.spawn(function()
                local step = {0.2, 0.5, 0.8, 1.0}
                for i = 1, #step do
                    T:Create(bf, TweenInfo.new(0.8), {Size = UDim2.new(step[i], 0, 1, 0)}):Play()
                    task.wait(1)
                end
                T:Create(lf, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -160, 1, 50)}):Play()
                task.wait(0.6)
                lf:Destroy()
            end)

            -- // Main Menu Initialize (Silently Loaded)
            local function _MAIN()
                -- [Isi Menu Utama Kamu Ada di Sini dalam Bentuk Bytecode]
                print("\69\87\69\72\85\66\32\76\111\97\100\101\100\33")
            end
            
            task.delay(4.5, _MAIN)
        end)
        if not s then warn("Critical Error in EWEHUB Core") end
    end
}

_EWE['\108\111\97\100\105\110\103']()
