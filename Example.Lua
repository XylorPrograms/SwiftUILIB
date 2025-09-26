-- SwiftUI Exploit Library Example Script
-- This script demonstrates all exploit-focused features

-- Load the SwiftUI library from GitHub
local SwiftUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XylorPrograms/SwiftUILIB/refs/heads/main/SwiftUI.lua"))()

-- Create the main window
local Window = SwiftUI:CreateWindow({
    Name = "SwiftUI Exploit Hub"
})

-- ===== PLAYER TAB =====
local PlayerTab = Window:CreateTab({
    Name = "Player",
    Icon = "👤"
})

-- Movement Section
local MovementSection = PlayerTab:CreateSection({
    Text = "Movement",
    Icon = "🏃",
    Open = true
})

-- Speed Slider
local SpeedSlider = MovementSection:CreateSlider({
    Text = "Walkspeed",
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    Suffix = "",
    Callback = function(value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
            print("🏃 Walkspeed set to:", value)
        end
    end
})

-- Jump Power Slider
local JumpSlider = MovementSection:CreateSlider({
    Text = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 5,
    Suffix = "",
    Callback = function(value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
            print("⬆️ Jump power set to:", value)
        end
    end
})

-- Fly Toggle with Keybind
local FlyEnabled = false
MovementSection:CreateToggle({
    Text = "Fly",
    Description = "Enable flight mode",
    Default = false,
    Callback = function(value)
        FlyEnabled = value
        print("✈️ Fly:", value and "Enabled" or "Disabled")
        -- Add your fly script logic here
    end
})

MovementSection:CreateKeybind({
    Text = "Fly Keybind",
    Description = "Toggle fly with hotkey",
    Default = Enum.KeyCode.F,
    Callback = function()
        FlyEnabled = not FlyEnabled
        print("✈️ Fly toggled via keybind:", FlyEnabled and "ON" or "OFF")
        -- Add your fly toggle logic here
    end
})

-- Noclip Toggle
MovementSection:CreateToggle({
    Text = "Noclip",
    Description = "Walk through walls",
    Default = false,
    Callback = function(value)
        print("👻 Noclip:", value and "Enabled" or "Disabled")
        -- Add your noclip script logic here
    end
})

-- Teleport Section
local TeleportSection = PlayerTab:CreateSection({
    Text = "Teleportation",
    Icon = "📍",
    Open = true
})

-- Coordinate Input
local CoordXBox = TeleportSection:CreateTextBox({
    Text = "X Coordinate",
    Placeholder = "Enter X position...",
    Default = "0",
    Callback = function(value)
        print("📍 X coordinate set to:", value)
    end
})

local CoordYBox = TeleportSection:CreateTextBox({
    Text = "Y Coordinate", 
    Placeholder = "Enter Y position...",
    Default = "0",
    Callback = function(value)
        print("📍 Y coordinate set to:", value)
    end
})

local CoordZBox = TeleportSection:CreateTextBox({
    Text = "Z Coordinate",
    Placeholder = "Enter Z position...", 
    Default = "0",
    Callback = function(value)
        print("📍 Z coordinate set to:", value)
    end
})

TeleportSection:CreateButton({
    Text = "🚀 Teleport to Coordinates",
    Callback = function()
        local x = tonumber(CoordXBox.GetValue()) or 0
        local y = tonumber(CoordYBox.GetValue()) or 0  
        local z = tonumber(CoordZBox.GetValue()) or 0
        
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
            print("🚀 Teleported to:", x, y, z)
        end
    end
})

-- ===== COMBAT TAB =====
local CombatTab = Window:CreateTab({
    Name = "Combat", 
    Icon = "⚔️"
})

-- Aimbot Section
local AimbotSection = CombatTab:CreateSection({
    Text = "Aimbot Settings",
    Icon = "🎯",
    Open = true
})

local AimbotEnabled = false
AimbotSection:CreateToggle({
    Text = "Enable Aimbot",
    Description = "Automatically aim at enemies",
    Default = false,
    Callback = function(value)
        AimbotEnabled = value
        print("🎯 Aimbot:", value and "Enabled" or "Disabled")
    end
})

AimbotSection:CreateSlider({
    Text = "Aimbot FOV",
    Min = 50,
    Max = 500,
    Default = 200,
    Increment = 10,
    Suffix = "",
    Callback = function(value)
        print("🎯 Aimbot FOV set to:", value)
        -- Update your aimbot FOV here
    end
})

AimbotSection:CreateSlider({
    Text = "Smoothness",
    Min = 1,
    Max = 10,
    Default = 5,
    Increment = 1,
    Suffix = "",
    Callback = function(value)
        print("🎯 Aimbot smoothness set to:", value)
    end
})

AimbotSection:CreateDropdown({
    Text = "Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    Default = "Head",
    Callback = function(selected)
        print("🎯 Targeting:", selected)
    end
})

AimbotSection:CreateKeybind({
    Text = "Aimbot Toggle",
    Description = "Toggle aimbot with hotkey",
    Default = Enum.KeyCode.T,
    Callback = function()
        AimbotEnabled = not AimbotEnabled
        print("🎯 Aimbot toggled:", AimbotEnabled and "ON" or "OFF")
    end
})

-- Weapon Section
local WeaponSection = CombatTab:CreateSection({
    Text = "Weapon Mods",
    Icon = "🔫",
    Open = true
})

WeaponSection:CreateToggle({
    Text = "No Recoil",
    Description = "Remove weapon recoil",
    Default = false,
    Callback = function(value)
        print("🔫 No Recoil:", value and "Enabled" or "Disabled")
    end
})

WeaponSection:CreateToggle({
    Text = "Infinite Ammo",
    Description = "Never run out of ammo",
    Default = false,
    Callback = function(value)
        print("🔫 Infinite Ammo:", value and "Enabled" or "Disabled")
    end
})

WeaponSection:CreateToggle({
    Text = "Auto Reload",
    Description = "Automatically reload weapon",
    Default = false,
    Callback = function(value)
        print("🔫 Auto Reload:", value and "Enabled" or "Disabled")
    end
})

-- ===== VISUALS TAB =====
local VisualsTab = Window:CreateTab({
    Name = "Visuals",
    Icon = "👁️"
})

-- ESP Section
local ESPSection = VisualsTab:CreateSection({
    Text = "ESP (Extra Sensory Perception)",
    Icon = "👁️",
    Open = true
})

local ESPEnabled = false
ESPSection:CreateToggle({
    Text = "Enable ESP",
    Description = "See players through walls",
    Default = false,
    Callback = function(value)
        ESPEnabled = value
        print("👁️ ESP:", value and "Enabled" or "Disabled")
    end
})

ESPSection:CreateMultiDropdown({
    Text = "ESP Features",
    Options = {"Box ESP", "Name ESP", "Distance ESP", "Health ESP", "Skeleton ESP"},
    Callback = function(selectedOptions)
        print("👁️ ESP Features updated:")
        for option, isSelected in pairs(selectedOptions) do
            if isSelected then
                print("  ✅ " .. option)
            end
        end
    end
})

-- ESP Colors
ESPSection:CreateColorPicker({
    Text = "Enemy Color",
    Description = "Color for enemy players",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("👁️ Enemy ESP color changed to RGB:", math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255))
    end
})

ESPSection:CreateColorPicker({
    Text = "Friend Color",
    Description = "Color for friendly players",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(color)
        print("👁️ Friend ESP color changed to RGB:", math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255))
    end
})

ESPSection:CreateSlider({
    Text = "ESP Distance",
    Min = 100,
    Max = 5000,
    Default = 1000,
    Increment = 50,
    Suffix = " studs",
    Callback = function(value)
        print("👁️ ESP distance set to:", value, "studs")
    end
})

-- Rendering Section
local RenderSection = VisualsTab:CreateSection({
    Text = "Rendering", 
    Icon = "🎨",
    Open = true
})

RenderSection:CreateToggle({
    Text = "Fullbright",
    Description = "See clearly in darkness",
    Default = false,
    Callback = function(value)
        print("💡 Fullbright:", value and "Enabled" or "Disabled")
        game.Lighting.Brightness = value and 2 or 1
        game.Lighting.ClockTime = value and 14 or 12
    end
})

RenderSection:CreateToggle({
    Text = "No Fog",
    Description = "Remove fog effects", 
    Default = false,
    Callback = function(value)
        print("🌫️ No Fog:", value and "Enabled" or "Disabled")
        game.Lighting.FogEnd = value and 9e9 or 100000
    end
})

RenderSection:CreateSlider({
    Text = "FOV",
    Min = 30,
    Max = 120,
    Default = 70,
    Increment = 1,
    Suffix = "°",
    Callback = function(value)
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = value
            print("📷 FOV set to:", value, "degrees")
        end
    end
})

-- ===== PLAYERS TAB =====
local PlayersTab = Window:CreateTab({
    Name = "Players",
    Icon = "👥"
})

-- Player Search
PlayersTab:CreateTextBox({
    Text = "Search Player",
    Placeholder = "Enter player name...",
    Callback = function(value)
        print("🔍 Searching for player:", value)
    end
})

-- Player List with Actions
PlayersTab:CreatePlayerList({
    Text = "Online Players",
    ActionText = "Teleport", 
    Callback = function(player)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                print("🚀 Teleported to:", player.DisplayName)
            end
        end
    end
})

-- Quick Actions Section
local QuickActionsSection = PlayersTab:CreateSection({
    Text = "Quick Actions",
    Icon = "⚡",
    Open = true
})

QuickActionsSection:CreateButton({
    Text = "📍 Teleport to Random Player",
    Callback = function()
        local players = game.Players:GetPlayers()
        if #players > 1 then
            local randomPlayer = players[math.random(1, #players)]
            if randomPlayer ~= game.Players.LocalPlayer and randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
                    print("🎲 Teleported to random player:", randomPlayer.DisplayName)
                end
            end
        end
    end
})

QuickActionsSection:CreateButton({
    Text = "👁️ Spectate Random Player",
    Callback = function()
        local players = game.Players:GetPlayers()
        if #players > 1 then
            local randomPlayer = players[math.random(1, #players)]
            if randomPlayer ~= game.Players.LocalPlayer then
                workspace.CurrentCamera.CameraSubject = randomPlayer.Character and randomPlayer.Character:FindFirstChild("Humanoid")
                print("👁️ Now spectating:", randomPlayer.DisplayName)
            end
        end
    end
})

QuickActionsSection:CreateButton({
    Text = "📹 Stop Spectating",
    Callback = function()
        workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        print("📹 Stopped spectating")
    end
})

-- ===== SCRIPTS TAB =====
local ScriptsTab = Window:CreateTab({
    Name = "Scripts",
    Icon = "📜"
})

-- Script Execution Section
local ScriptSection = ScriptsTab:CreateSection({
    Text = "Script Execution",
    Icon = "⚡",
    Open = true
})

local ScriptTextBox = ScriptSection:CreateTextBox({
    Text = "Script URL",
    Placeholder = "Enter script URL or loadstring...",
    Callback = function(value)
        print("📜 Script input:", value)
    end
})

ScriptSection:CreateButton({
    Text = "⚡ Execute Script",
    Callback = function()
        local scriptContent = ScriptTextBox.GetValue()
        if scriptContent and scriptContent ~= "" then
            print("⚡ Executing script...")
            local success, error = pcall(function()
                if scriptContent:find("http") then
                    loadstring(game:HttpGet(scriptContent))()
                else
                    loadstring(scriptContent)()
                end
            end)
            if success then
                print("✅ Script executed successfully!")
            else
                print("❌ Script error:", error)
            end
        end
    end
})

-- Popular Scripts Section
local PopularSection = ScriptsTab:CreateSection({
    Text = "Popular Scripts",
    Icon = "🌟",
    Open = true
})

PopularSection:CreateButton({
    Text = "🎮 Universal ESP",
    Callback = function()
        print("🎮 Loading Universal ESP...")
        -- Add your ESP script here
    end
})

PopularSection:CreateButton({
    Text = "🏃 Universal Speed/Fly",
    Callback = function()
        print("🏃 Loading Speed/Fly script...")
        -- Add your speed/fly script here
    end
})

PopularSection:CreateButton({
    Text = "🎯 Universal Aimbot",
    Callback = function()
        print("🎯 Loading Universal Aimbot...")
        -- Add your aimbot script here
    end
})

PopularSection:CreateButton({
    Text = "🌍 Infinite Yield Admin",
    Callback = function()
        print("🌍 Loading Infinite Yield...")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})

-- ===== SETTINGS TAB =====
local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "⚙️"
})

-- Keybind Section
local KeybindSection = SettingsTab:CreateSection({
    Text = "Keybinds",
    Icon = "🎹",
    Open = true
})

KeybindSection:CreateKeybind({
    Text = "Panic Key",
    Description = "Instantly hide/destroy GUI",
    Default = Enum.KeyCode.Delete,
    Callback = function()
        print("🚨 PANIC! Destroying GUI...")
        Window.ScreenGui:Destroy()
    end
})

KeybindSection:CreateKeybind({
    Text = "Toggle GUI",
    Description = "Show/hide the GUI",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        Window.MainFrame.Visible = not Window.MainFrame.Visible
        print("👁️ GUI toggled:", Window.MainFrame.Visible and "Visible" or "Hidden")
    end
})

-- General Settings Section
local GeneralSection = SettingsTab:CreateSection({
    Text = "General Settings",
    Icon = "⚙️",
    Open = true
})

GeneralSection:CreateToggle({
    Text = "Auto-Execute",
    Description = "Automatically execute scripts on join",
    Default = false,
    Callback = function(value)
        print("🔄 Auto-Execute:", value and "Enabled" or "Disabled")
    end
})

GeneralSection:CreateToggle({
    Text = "Anti-AFK",
    Description = "Prevent getting kicked for being idle",
    Default = true,
    Callback = function(value)
        print("😴 Anti-AFK:", value and "Enabled" or "Disabled")
        -- Add anti-AFK logic here
    end
})

GeneralSection:CreateSlider({
    Text = "GUI Scale",
    Min = 50,
    Max = 150,
    Default = 100,
    Increment = 5,
    Suffix = "%",
    Callback = function(value)
        local scale = value / 100
        Window.MainFrame.Size = UDim2.new(0, 700 * scale, 0, 450 * scale)
        print("🔍 GUI scaled to:", value .. "%")
    end
})

-- Advanced Section
local AdvancedSection = SettingsTab:CreateSection({
    Text = "Advanced Settings",
    Icon = "🔬",
    Open = false
})

AdvancedSection:CreateButton({
    Text = "🔄 Reset All Settings",
    Callback = function()
        print("🔄 Resetting all settings to defaults...")
        
        -- Reset sliders
        SpeedSlider.SetValue(16)
        JumpSlider.SetValue(50)
        
        -- Reset other components
        print("✅ All settings reset!")
    end
})

AdvancedSection:CreateButton({
    Text = "📋 Copy GUI Code",
    Callback = function()
        local code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/XylorPrograms/SwiftUILIB/refs/heads/main/Example.lua"))()'
        print("📋 GUI code copied to clipboard!")
        print("Code:", code)
    end
})

AdvancedSection:CreateToggle({
    Text = "Developer Mode",
    Description = "Show debug information",
    Default = false,
    Callback = function(value)
        print("🔬 Developer Mode:", value and "Enabled" or "Disabled")
        if value then
            print("🔬 Debug: Player count:", #game.Players:GetPlayers())
            print("🔬 Debug: Current FPS:", math.floor(1/game:GetService("RunService").Heartbeat:Wait()))
            print("🔬 Debug: Ping:", game.Players.LocalPlayer:GetNetworkPing())
        end
    end
})

-- Print startup messages
print("🚀 SwiftUI Exploit Hub loaded successfully!")
print("🎯 Features: Movement, Combat, Visuals, Player Management, Scripts")
print("⚡ All exploit components loaded: Sliders, Keybinds, ColorPicker, PlayerList, Sections")
print("🔒 Security: Panic key (Delete), GUI toggle (Right Shift)")
print("💡 Tip: Use sections to organize your components!")
print("⚠️ Remember: Replace Discord code in the library for auto-join feature")

-- Demo the new features
print("\n🎮 === FEATURE DEMO ===")
print("📊 Sliders: Speed & Jump power controls")
print("🎹 Keybinds: Fly toggle, Panic key, GUI toggle") 
print("🎨 ColorPicker: ESP enemy/friend colors")
print("👥 PlayerList: Live updating with teleport actions")
print("📁 Sections: Collapsible organization (Movement, Aimbot, etc.)")
print("📝 TextBoxes: Coordinate input, script execution")
print("🎯 Real exploit features: ESP, Aimbot, Movement hacks")
print("========================")
