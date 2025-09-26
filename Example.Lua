-- Load the library from your GitHub
local SwiftUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XylorPrograms/SwiftUILIB/refs/heads/main/SwiftUI.lua"))()

-- Create a window
local window = SwiftUI:CreateWindow({
    Title = "My Script Hub",
    Size = UDim2.new(0, 650, 0, 450)
})

-- Create tabs
local mainTab = window:CreateTab({
    Name = "Main",
    Icon = "🏠"
})

local aimbotTab = window:CreateTab({
    Name = "Aimbot", 
    Icon = "🎯"
})

-- Add components to tabs
mainTab:CreateToggle({
    Text = "Auto Hit",
    Default = true,
    Callback = function(value)
        print("Auto Hit:", value)
    end
})

aimbotTab:CreateToggle({
    Text = "Silent Aim",
    Default = false,
    Callback = function(value)
        print("Silent Aim:", value)
    end
})
