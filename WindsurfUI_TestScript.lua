--[[
    WindsurfUI Library Test Script
    
    This script demonstrates the functionality of the WindsurfUI library
    Run this in your exploit to see the UI in action
]]

-- Load the WindsurfUI library from GitHub repository
local WindsurfUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XylorPrograms/SwiftUILIB/main/WindsurfUI.lua"))()

-- Create a window
local Window = WindsurfUI:CreateWindow({
    Title = "Windsurf UI Library",
    Size = UDim2.new(0, 550, 0, 400),
    Position = UDim2.new(0.5, -275, 0.5, -200)
})

-- Create tabs
local HomeTab = Window:CreateTab({
    Name = "Home",
    Icon = "rbxassetid://6026568198" -- Home icon
})

local CombatTab = Window:CreateTab({
    Name = "Combat",
    Icon = "rbxassetid://6034509993" -- Combat icon
})

local ESPTab = Window:CreateTab({
    Name = "ESP",
    Icon = "rbxassetid://6031763426" -- Eye icon
})

local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "rbxassetid://6031280882" -- Settings icon
})

-- Add elements to Home tab
HomeTab:CreateButton({
    Name = "Button Example",
    Text = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})

HomeTab:CreateToggle({
    Name = "Toggle Example",
    Description = "This is a toggle!",
    Default = false,
    Callback = function(Value)
        print("Toggle switched to:", Value)
    end
})

HomeTab:CreateSlider({
    Name = "Slider Example",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(Value)
        print("Slider changed to:", Value)
    end
})

HomeTab:CreateColorPicker({
    Name = "Color Picker",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        print("Color changed to:", Value)
    end
})

-- Add Combat tab elements
CombatTab:CreateToggle({
    Name = "Silent Aim",
    Description = "Automatically hit targets without aiming",
    Default = false,
    Callback = function(Value)
        print("Silent Aim:", Value)
    end
})

CombatTab:CreateToggle({
    Name = "Wallbang",
    Description = "Shoot through walls",
    Default = false,
    Callback = function(Value)
        print("Wallbang:", Value)
    end
})

CombatTab:CreateSlider({
    Name = "Hitbox Size",
    Min = 1,
    Max = 10,
    Default = 2,
    Increment = 0.1,
    Callback = function(Value)
        print("Hitbox Size:", Value)
    end
})

CombatTab:CreateSlider({
    Name = "FOV Circle",
    Min = 0,
    Max = 500,
    Default = 100,
    Increment = 10,
    Callback = function(Value)
        print("FOV Circle:", Value)
    end
})

-- Add ESP tab elements
ESPTab:CreateToggle({
    Name = "Player ESP",
    Description = "Show ESP for players",
    Default = false,
    Callback = function(Value)
        print("Player ESP:", Value)
    end
})

ESPTab:CreateToggle({
    Name = "Box ESP",
    Description = "Show boxes around players",
    Default = false,
    Callback = function(Value)
        print("Box ESP:", Value)
    end
})

ESPTab:CreateToggle({
    Name = "Name ESP",
    Description = "Show player names",
    Default = false,
    Callback = function(Value)
        print("Name ESP:", Value)
    end
})

ESPTab:CreateToggle({
    Name = "Distance ESP",
    Description = "Show distance to players",
    Default = false,
    Callback = function(Value)
        print("Distance ESP:", Value)
    end
})

ESPTab:CreateColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value)
        print("ESP Color:", Value)
    end
})

-- Add Settings tab elements
SettingsTab:CreateButton({
    Name = "Destroy GUI",
    Text = "Close",
    Callback = function()
        print("Destroying GUI...")
        if Window.ScreenGui then
            Window.ScreenGui:Destroy()
        end
    end
})

SettingsTab:CreateToggle({
    Name = "Save Settings",
    Description = "Auto-save your settings",
    Default = true,
    Callback = function(Value)
        print("Save Settings:", Value)
    end
})

-- Notification to show the UI is loaded
print("WindsurfUI Test Script Loaded!")
print("If you don't see the UI, check for errors in your exploit's console.")
