-- SwiftUI Library Example Script
-- This script demonstrates all the features of the SwiftUI library

-- Load the SwiftUI library from GitHub
local SwiftUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XylorPrograms/SwiftUILIB/refs/heads/main/SwiftUI.lua"))()

-- Create the main window
local Window = SwiftUI:CreateWindow({
    Name = "SwiftUI Example"
})

-- Create the first tab (Main Features)
local MainTab = Window:CreateTab({
    Name = "Main Features"
})

-- Add a simple button
MainTab:CreateButton({
    Text = "Click Me!",
    Callback = function()
        print("Button was clicked!")
        -- You can add any code here that should run when the button is clicked
    end
})

-- Add a toggle
local MyToggle = MainTab:CreateToggle({
    Text = "Enable Feature",
    Default = false,
    Callback = function(value)
        print("Toggle is now:", value)
        -- The value parameter tells you if the toggle is on (true) or off (false)
    end
})

-- Add a regular dropdown
local MyDropdown = MainTab:CreateDropdown({
    Text = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3", "Option 4"},
    Default = "Option 1",
    Callback = function(selected)
        print("Selected option:", selected)
        -- The selected parameter tells you which option was chosen
    end
})

-- Add a multi-selection dropdown
local MyMultiDropdown = MainTab:CreateMultiDropdown({
    Text = "Select Multiple",
    Options = {"Feature A", "Feature B", "Feature C", "Feature D", "Feature E"},
    Callback = function(selectedOptions)
        print("Selected options:")
        for option, isSelected in pairs(selectedOptions) do
            if isSelected then
                print("  - " .. option)
            end
        end
    end
})

-- Create a second tab (Advanced Features)
local AdvancedTab = Window:CreateTab({
    Name = "Advanced"
})

-- More examples in the advanced tab
AdvancedTab:CreateButton({
    Text = "Advanced Action",
    Callback = function()
        print("Advanced button clicked!")
        
        -- Example: Programmatically set toggle value
        MyToggle.SetValue(true)
        print("Toggle has been enabled programmatically!")
        
        -- Example: Programmatically set dropdown value
        MyDropdown.SetValue("Option 3")
        print("Dropdown has been set to Option 3!")
        
        -- Example: Programmatically set multi-dropdown values
        MyMultiDropdown.SetValues({"Feature A", "Feature C"})
        print("Multi-dropdown has been set to Feature A and Feature C!")
    end
})

AdvancedTab:CreateToggle({
    Text = "Advanced Toggle",
    Default = true,
    Callback = function(value)
        if value then
            print("Advanced feature enabled!")
        else
            print("Advanced feature disabled!")
        end
    end
})

AdvancedTab:CreateDropdown({
    Text = "Game Mode",
    Options = {"Easy", "Normal", "Hard", "Expert"},
    Default = "Normal",
    Callback = function(selected)
        print("Game mode set to:", selected)
    end
})

-- Create a third tab (Settings)
local SettingsTab = Window:CreateTab({
    Name = "Settings"
})

SettingsTab:CreateToggle({
    Text = "Auto-Save",
    Default = true,
    Callback = function(value)
        print("Auto-save:", value and "Enabled" or "Disabled")
    end
})

SettingsTab:CreateToggle({
    Text = "Sound Effects",
    Default = true,
    Callback = function(value)
        print("Sound effects:", value and "On" or "Off")
    end
})

SettingsTab:CreateDropdown({
    Text = "Theme",
    Options = {"Dark", "Light", "Auto"},
    Default = "Dark",
    Callback = function(selected)
        print("Theme changed to:", selected)
    end
})

SettingsTab:CreateMultiDropdown({
    Text = "Notifications",
    Options = {"System Updates", "Friend Requests", "Game Invites", "Achievements", "News"},
    Callback = function(selectedOptions)
        print("Notification settings updated:")
        for option, isSelected in pairs(selectedOptions) do
            if isSelected then
                print("  ✓ " .. option)
            end
        end
    end
})

SettingsTab:CreateButton({
    Text = "Save Settings",
    Callback = function()
        print("Settings have been saved!")
        
        -- Example of getting current values
        print("Current toggle value:", MyToggle.GetValue())
        print("Current dropdown value:", MyDropdown.GetValue())
        
        local multiValues = MyMultiDropdown.GetValues()
        print("Current multi-dropdown values:")
        for _, value in ipairs(multiValues) do
            print("  - " .. value)
        end
    end
})

-- Print a message to let the user know the script loaded successfully
print("SwiftUI Example loaded successfully!")
print("The UI window should now be visible.")
print("Note: Make sure to replace 'your-discord-code-here' in the SwiftUI library with your actual Discord invite code for the auto-join feature to work.")
