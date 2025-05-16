--[[
    WindsurfUI Advanced Test Script
    
    This script demonstrates all the enhanced features of the WindsurfUI library.
    Load this script in your Roblox exploit to see the improved UI in action.
]]

-- Load the library from GitHub repository
local WindsurfUI = loadstring(game:HttpGet("https://github.com/XylorPrograms/SwiftUILIB/raw/main/WindsurfUI_Final.lua"))()

-- Create a window with enhanced styling
local Window = WindsurfUI:CreateWindow({
    Title = "WindsurfUI Advanced Demo",
    Size = UDim2.new(0, 600, 0, 450),
    Theme = {
        Background = Color3.fromRGB(25, 25, 25),
        Accent = Color3.fromRGB(0, 170, 255),
        LightContrast = Color3.fromRGB(35, 35, 35),
        DarkContrast = Color3.fromRGB(20, 20, 20),
        TextColor = Color3.fromRGB(240, 240, 240),
        PlaceholderColor = Color3.fromRGB(180, 180, 180),
        BorderColor = Color3.fromRGB(60, 60, 60)
    }
})

-- Create tabs with descriptions for better organization
local HomeTab = Window:CreateTab({
    Name = "Home",
    Icon = "rbxassetid://6026568198", -- Home icon
    Description = "Overview and welcome"
})

local VisualsTab = Window:CreateTab({
    Name = "Visuals",
    Icon = "rbxassetid://6034509993" -- Visual settings icon
})

local FeaturesTab = Window:CreateTab({
    Name = "Features",
    Icon = "rbxassetid://6031075931" -- Features icon
})

local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "rbxassetid://6031280882" -- Settings icon
})

-- Add elements to Home tab
HomeTab:CreateButton({
    Name = "Welcome to WindsurfUI",
    Description = "This is an advanced demo of the enhanced library",
    Text = "Hello!",
    Icon = "rbxassetid://6026568198",
    Callback = function()
        print("Welcome button clicked!")
    end
})

HomeTab:CreateButton({
    Name = "Enhanced Button",
    Description = "Showcases ripple effects and animations",
    Text = "Click Me",
    Icon = "rbxassetid://6031075931",
    Callback = function()
        print("Enhanced button clicked - notice the ripple effect!")
    end
})

HomeTab:CreateToggle({
    Name = "Feature Toggle",
    Description = "Toggle with smooth animation effects",
    Default = true,
    Callback = function(Value)
        print("Feature toggled: " .. tostring(Value))
    end
})

HomeTab:CreateSlider({
    Name = "Opacity Control",
    Description = "Showcases the enhanced slider with animations",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Suffix = "%",
    Callback = function(Value)
        print("Slider value changed: " .. Value .. "%")
    end
})

-- Add elements to Visuals tab to showcase UI components
VisualsTab:CreateToggle({
    Name = "ESP Enabled",
    Description = "Enable player ESP features",
    Default = false,
    Callback = function(Value)
        print("ESP toggled: " .. tostring(Value))
    end
})

VisualsTab:CreateToggle({
    Name = "Box ESP",
    Description = "Show boxes around players",
    Default = false,
    Callback = function(Value)
        print("Box ESP: " .. tostring(Value))
    end
})

VisualsTab:CreateToggle({
    Name = "Name ESP",
    Description = "Show player names through walls",
    Default = false,
    Callback = function(Value)
        print("Name ESP: " .. tostring(Value))
    end
})

VisualsTab:CreateToggle({
    Name = "Health ESP",
    Description = "Show player health information",
    Default = false,
    Callback = function(Value)
        print("Health ESP: " .. tostring(Value))
    end
})

VisualsTab:CreateSlider({
    Name = "ESP Distance",
    Description = "Maximum distance to render ESP elements",
    Min = 50,
    Max = 2000,
    Default = 500,
    Increment = 50,
    Suffix = "m",
    Callback = function(Value)
        print("ESP distance set to: " .. Value .. "m")
    end
})

VisualsTab:CreateSlider({
    Name = "ESP Thickness",
    Description = "Adjust the thickness of ESP lines",
    Min = 1,
    Max = 5,
    Default = 1.5,
    Increment = 0.5,
    Callback = function(Value)
        print("ESP thickness set to: " .. Value)
    end
})

VisualsTab:CreateColorPicker({
    Name = "ESP Color",
    Description = "Choose the color for ESP elements",
    Default = Color3.fromRGB(0, 170, 255),
    Callback = function(Color)
        print("ESP color set to: ", Color)
    end
})

-- Add elements to Features tab to showcase more complex UI elements
FeaturesTab:CreateButton({
    Name = "Aimbot",
    Description = "Configure automatic aiming features",
    Text = "Configure",
    Icon = "rbxassetid://6034509993",
    Callback = function()
        print("Aimbot configuration opened")
    end
})

FeaturesTab:CreateToggle({
    Name = "Silent Aim",
    Description = "Bullets hit targets without visible aiming",
    Default = false,
    Callback = function(Value)
        print("Silent aim: " .. tostring(Value))
    end
})

FeaturesTab:CreateSlider({
    Name = "Aim FOV",
    Description = "Field of view for target selection",
    Min = 0,
    Max = 500,
    Default = 100,
    Increment = 5,
    Suffix = "°",
    Callback = function(Value)
        print("Aim FOV set to: " .. Value .. "°")
    end
})

FeaturesTab:CreateSlider({
    Name = "Aim Smoothness",
    Description = "How smooth the aim movement appears",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Increment = 0.05,
    Callback = function(Value)
        print("Aim smoothness set to: " .. Value)
    end
})

FeaturesTab:CreateToggle({
    Name = "Wallbang",
    Description = "Shoot through walls",
    Default = false,
    Callback = function(Value)
        print("Wallbang: " .. tostring(Value))
    end
})

FeaturesTab:CreateButton({
    Name = "Movement Features",
    Description = "Configure player movement enhancements",
    Text = "Configure",
    Callback = function()
        print("Movement configuration opened")
    end
})

FeaturesTab:CreateSlider({
    Name = "Speed Multiplier",
    Description = "Adjust your character's movement speed",
    Min = 1,
    Max = 10,
    Default = 1,
    Increment = 0.5,
    Callback = function(Value)
        print("Speed multiplier set to: " .. Value .. "x")
        -- In a real script, you might do something like:
        -- if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        --     game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 * Value
        -- end
    end
})

-- Add elements to Settings tab
SettingsTab:CreateToggle({
    Name = "Auto-Save Config",
    Description = "Automatically save your settings",
    Default = true,
    Callback = function(Value)
        print("Auto-save config: " .. tostring(Value))
    end
})

SettingsTab:CreateToggle({
    Name = "Show Notifications",
    Description = "Show popup notifications when events occur",
    Default = true,
    Callback = function(Value)
        print("Show notifications: " .. tostring(Value))
    end
})

SettingsTab:CreateSlider({
    Name = "UI Transparency",
    Description = "Adjust the transparency of the UI",
    Min = 0,
    Max = 0.9,
    Default = 0,
    Increment = 0.05,
    Callback = function(Value)
        print("UI transparency set to: " .. Value)
    end
})

SettingsTab:CreateButton({
    Name = "Reset All Settings",
    Description = "Reset all settings to their default values",
    Text = "Reset",
    Callback = function()
        print("All settings have been reset")
    end
})

SettingsTab:CreateButton({
    Name = "Destroy GUI",
    Description = "Close the interface completely",
    Text = "Close",
    Callback = function()
        print("Destroying GUI...")
        if Window.ScreenGui then
            Window.ScreenGui:Destroy()
        end
    end
})

-- Print a confirmation message when the script loads
print("WindsurfUI Advanced Demo has been loaded successfully!")
print("Explore the tabs to see all the enhanced features!")
