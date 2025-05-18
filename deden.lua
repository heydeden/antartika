local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Expedition Antarctica Script",
   Icon = 0,
   LoadingTitle = "Deden Wirjadinata",
   LoadingSubtitle = "by Deden",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ExpeditionAntarcticaConfig",
      FileName = "Settings"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

-- Main Tab
local MainTab = Window:CreateTab("Main", nil)
local Section = MainTab:CreateSection("Movement")

-- Speed Slider
local CurrentSpeed = 16
MainTab:CreateSlider({
    Name = "keceptan jalan",
    Range = {16, 200},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 16,
    Flag = "SpeedSlider",
    Callback = function(Value)
        CurrentSpeed = Value
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
        end
    end
})

-- Jump Power Slider
local CurrentJump = 50
MainTab:CreateSlider({
    Name = "loncatan super cuy",
    Range = {50, 200},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 50,
    Flag = "JumpSlider",
    Callback = function(Value)
        CurrentJump = Value
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = Value
        end
    end
})

-- Apply speed/jump when character respawns
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
    wait(0.5)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = CurrentSpeed
        humanoid.JumpPower = CurrentJump
    end
end)

-- Infinite Jump
local jumpConnection
MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfiniteJumpToggle",
   Callback = function(Value)
        _G.infinjump = Value
        
        if Value and _G.infinJumpStarted == nil then
            _G.infinJumpStarted = true
            
            Rayfield:Notify({
                Title = "Infinite Jump", 
                Content = "Press space to infinite jump!", 
                Duration = 5,
                Image = nil
            })

            local plr = game:GetService('Players').LocalPlayer
            local m = plr:GetMouse()
            jumpConnection = m.KeyDown:Connect(function(k)
                if _G.infinjump and k:byte() == 32 then
                    local humanoid = plr.Character:FindFirstChildOfClass('Humanoid')
                    if humanoid then
                        humanoid:ChangeState('Jumping')
                        wait()
                        humanoid:ChangeState('Seated')
                    end
                end
            end)
        elseif not Value and jumpConnection then
            jumpConnection:Disconnect()
        end
   end,
})

-- Auto Farm System
local AutoFarmActive = false
local AutoFarmConnection = nil
local FarmPosition = CFrame.new(3733.94189, 1508.68774, -184.84581, 0.814204156, 5.19907921e-08, 0.580578625, -6.29331876e-09, 1, -8.07241989e-08, -0.580578625, 6.20722105e-08, 0.814204156)

local function AutoFarmLoop()
    while AutoFarmActive do
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        -- Wait for the character and HumanoidRootPart to load
        repeat task.wait() until character:FindFirstChild("HumanoidRootPart") and character:FindFirstChildOfClass("Humanoid")

        local humanoid = character:FindFirstChildOfClass("Humanoid")

        -- Check if humanoid is alive
        if humanoid and humanoid.Health > 0 then
            -- Teleport to farm location
            character.HumanoidRootPart.CFrame = FarmPosition
            task.wait(0.5)

            -- Move left
            character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(-7, 0, 0)
            task.wait(1)

            -- Move right
            character.HumanoidRootPart.CFrame = FarmPosition * CFrame.new(7, 0, 0)
            task.wait(1)

            -- Return to center
            character.HumanoidRootPart.CFrame = FarmPosition
            task.wait(1)

            -- Reset character
            humanoid:ChangeState(Enum.HumanoidStateType.Dead)
        end

        -- Wait until the character respawns and is alive
        repeat task.wait() until player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0
    end
end

MainTab:CreateToggle({
    Name = "auto dapat uang",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        AutoFarmActive = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Farm Started",
                Content = "Running continuous farming loop...",
                Duration = 3,
                Image = nil
            })
            AutoFarmConnection = task.spawn(AutoFarmLoop)
        else
            if AutoFarmConnection then
                task.cancel(AutoFarmConnection)
            end
            Rayfield:Notify({
                Title = "Auto Farm Stopped",
                Content = "Farming has been disabled",
                Duration = 3,
                Image = nil
            })
        end
    end
})

-- Misc Tab
local MiscTab = Window:CreateTab("ðŸ”§ Misc", nil)
local MiscSection = MiscTab:CreateSection("Utilities")

-- FPS Booster
MiscTab:CreateButton({
    Name = "FPS Booster",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Decal") or v:IsA("Smoke") or v:IsA("Fire") then
                v:Destroy()
            end
        end
        
        settings().Rendering.QualityLevel = 1
        game:GetService("Lighting").GlobalShadows = false
        
        Rayfield:Notify({
            Title = "FPS Boost Applied",
            Content = "Graphics optimized for performance",
            Duration = 3,
            Image = nil
        })
    end
})

-- FOV Changer
MiscTab:CreateSlider({
    Name = "ipad view",
    Range = {70, 120},
    Increment = 1,
    Suffix = "Â°",
    CurrentValue = 70,
    Flag = "FOVSlider",
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end
})

-- NoClip System
local NoclipActive = false
local NoclipConnection = nil

local function UpdateNoclip()
    if NoclipActive and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

MiscTab:CreateToggle({
    Name = "jalan tembus dinding cuy",
    CurrentValue = false,
    Flag = "NoClipToggle",
    Callback = function(Value)
        NoclipActive = Value
        
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end
        
        if Value then
            NoclipConnection = game:GetService("RunService").Stepped:Connect(UpdateNoclip)
            Rayfield:Notify({
                Title = "NoClip Enabled",
                Content = "You can now walk through walls",
                Duration = 3,
                Image = nil
            })
        else
            Rayfield:Notify({
                Title = "NoClip Disabled",
                Content = "Collisions restored",
                Duration = 3,
                Image = nil
            })
        end
    end
})

-- Fullbright
MiscTab:CreateToggle({
    Name = "hapus kegelapan cuy",
    CurrentValue = false,
    Flag = "FullbrightToggle",
    Callback = function(Value)
        if Value then
            game.Lighting.Ambient = Color3.new(1, 1, 1)
            game.Lighting.FogEnd = 100000
            Rayfield:Notify({
                Title = "Fullbright Enabled",
                Content = "Darkness removed from the game",
                Duration = 3,
                Image = nil
            })
        else
            game.Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            game.Lighting.FogEnd = 10000
            Rayfield:Notify({
                Title = "Fullbright Disabled",
                Content = "Default lighting restored",
                Duration = 3,
                Image = nil
            })
        end
    end
})

-- Remove Fog Toggle
local FogRemoved = false
local OriginalFogStart = game.Lighting.FogStart
local OriginalFogEnd = game.Lighting.FogEnd

MiscTab:CreateToggle({
    Name = "hapus kabut anjir",
    CurrentValue = false,
    Flag = "RemoveFogToggle",
    Callback = function(Value)
        FogRemoved = Value
        if Value then
            OriginalFogStart = game.Lighting.FogStart
            OriginalFogEnd = game.Lighting.FogEnd
            game.Lighting.FogStart = 0
            game.Lighting.FogEnd = 100000
            Rayfield:Notify({
                Title = "hapus kabut",
                Content = "sukses hapus kabut cok",
                Duration = 3,
                Image = nil
            })
        else
            game.Lighting.FogStart = OriginalFogStart
            game.Lighting.FogEnd = OriginalFogEnd
            Rayfield:Notify({
                Title = "balikan kabut",
                Content = "kabut kembali ke stelan default",
                Duration = 3,
                Image = nil
            })
        end
    end
})

-- Initial notification
Rayfield:Notify({
   Title = "Script Loaded!",
   Content = "Expedition Antarctica Script by Deden",
   Duration = 6.5,
   Image = nil,
})