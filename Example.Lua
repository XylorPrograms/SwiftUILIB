-- Example usage function
function SwiftUI:Example()
    local window = self:CreateWindow({
        Title = "SwiftUI Example",
        Size = UDim2.new(0, 650, 0, 450)
    })
    
    -- Main Tab
    local mainTab = window:CreateTab({
        Name = "Main",
        Icon = "🏠"
    })
    
    mainTab:CreateLabel({Text = "Welcome to SwiftUI!"})
    
    mainTab:CreateButton({
        Text = "Test Button",
        Callback = function()
            print("Button clicked!")
        end
    })
    
    mainTab:CreateToggle({
        Text = "Auto Aim",
        Default = false,
        Callback = function(value)
            print("Auto Aim:", value)
        end
    })
    
    -- Aimbot Tab
    local aimbotTab = window:CreateTab({
        Name = "Aimbot",
        Icon = "🎯"
    })
    
    aimbotTab:CreateToggle({
        Text = "Silent Aim",
        Default = true,
        Callback = function(value)
            print("Silent Aim:", value)
        end
    })
    
    aimbotTab:CreateToggle({
        Text = "FOV Circle",
        Default = false,
        Callback = function(value)
            print("FOV Circle:", value)
        end
    })
    
    aimbotTab:CreateButton({
        Text = "Reset Aimbot",
        Callback = function()
            print("Aimbot reset!")
        end
    })
    
    -- Visuals Tab
    local visualsTab = window:CreateTab({
        Name = "Visuals",
        Icon = "👁️"
    })
    
    visualsTab:CreateToggle({
        Text = "ESP",
        Default = false,
        Callback = function(value)
            print("ESP:", value)
        end
    })
    
    visualsTab:CreateToggle({
        Text = "Name Tags",
        Default = true,
        Callback = function(value)
            print("Name Tags:", value)
        end
    })
    
    -- Settings Tab
    local settingsTab = window:CreateTab({
        Name = "Settings",
        Icon = "⚙️"
    })
    
    settingsTab:CreateLabel({Text = "Configuration Options"})
    
    settingsTab:CreateButton({
        Text = "Save Config",
        Callback = function()
            print("Config saved!")
        end
    })
    
    settingsTab:CreateButton({
        Text = "Load Config",
        Callback = function()
            print("Config loaded!")
        end
    })
end
