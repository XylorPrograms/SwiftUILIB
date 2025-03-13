--[[
    Eclipse UI Library (v1.0)
    Designed for exploit environments
    Features: Key system, modern components, theme support
--]]

local Eclipse = {Elements = {}, Keys = {}}
local mouse = game:GetService("Players").LocalPlayer:GetMouse()
local writefile = writefile or function() end
local readfile = readfile or function() return "" end

-- Key System Implementation
function Eclipse:ValidateKey(key)
    if not isfile("eclipse_keys.txt") then writefile("eclipse_keys.txt", "") end
    
    local stored = readfile("eclipse_keys.txt"):gsub("%s+", ""):split(",")
    local validKeys = {
        "ECLIPSE-PERMA-1234", 
        "ECLIPSE-PERMA-5678"
    }
    
    -- Check permanent keys
    if table.find(validKeys, key) then
        return true, "permanent"
    end
    
    -- Check temporary keys
    for _, entry in ipairs(stored) do
        local parts = entry:split("|")
        if parts[1] == key and os.time() - tonumber(parts[2]) < 86400 then
            return true, "temporary"
        end
    end
    
    return false
end

function Eclipse:CreateKeySystem(config)
    local keyFrame = Drawing.new("Square")
    keyFrame.Size = Vector2.new(300, 200)
    keyFrame.Position = Vector2.new(config.X, config.Y)
    keyFrame.Color = config.Theme.Background
    keyFrame.Filled = true
    
    local inputBox = Drawing.new("Text")
    inputBox.Text = "Enter access key..."
    inputBox.Position = Vector2.new(config.X + 50, config.Y + 80)
    inputBox.Color = config.Theme.Text
    inputBox.Size = 18
    
    return {
        Submit = function(callback)
            game:GetService("UserInputService").InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    -- Handle key input
                end
            end)
        end
    }
end

-- Modern UI Components
function Eclipse:CreateWindow(name)
    local window = {
        Elements = {},
        Theme = {
            Background = Color3.fromRGB(30, 30, 30),
            Accent = Color3.fromRGB(0, 120, 215),
            Text = Color3.fromRGB(240, 240, 240)
        }
    }
    
    -- Window frame
    window.MainFrame = Drawing.new("Square")
    window.MainFrame.Size = Vector2.new(400, 500)
    window.MainFrame.Position = Vector2.new(200, 100)
    window.MainFrame.Color = window.Theme.Background
    window.MainFrame.Filled = true
    
    -- Title bar
    window.Title = Drawing.new("Text")
    window.Title.Text = name
    window.Title.Position = Vector2.new(210, 110)
    window.Title.Color = window.Theme.Accent
    window.Title.Size = 20
    
    function window:UpdateTheme(newTheme)
        self.Theme = newTheme
        self.MainFrame.Color = newTheme.Background
        self.Title.Color = newTheme.Accent
        -- Update other elements...
    end
    
    return window
end

function Eclipse:CreateButton(parent, config)
    local button = {
        Hover = false,
        Active = false
    }
    
    button.Frame = Drawing.new("Square")
    button.Frame.Size = Vector2.new(config.Width or 120, config.Height or 40)
    button.Frame.Position = Vector2.new(config.X, config.Y)
    button.Frame.Color = parent.Theme.Accent
    button.Frame.Filled = true
    
    button.Text = Drawing.new("Text")
    button.Text.Text = config.Text
    button.Text.Position = Vector2.new(config.X + 15, config.Y + 10)
    button.Text.Color = parent.Theme.Text
    button.Text.Size = 16
    
    -- Interactive effects
    game:GetService("RunService").RenderStepped:Connect(function()
        local mousePos = Vector2.new(mouse.X, mouse.Y)
        local hovering = mousePos.X > config.X and mousePos.X < config.X + button.Frame.Size.X and
                         mousePos.Y > config.Y and mousePos.Y < config.Y + button.Frame.Size.Y
        
        if hovering then
            button.Frame.Color = Color3.fromRGB(
                math.clamp(parent.Theme.Accent.R * 255 + 20, 0, 255),
                math.clamp(parent.Theme.Accent.G * 255 + 20, 0, 255),
                math.clamp(parent.Theme.Accent.B * 255 + 20, 0, 255)
            )
            if mouse1click then
                config.Callback()
            end
        else
            button.Frame.Color = parent.Theme.Accent
        end
    end)
    
    return button
end

-- Advanced Components
function Eclipse:CreateDropdown(parent, config)
    local dropdown = {
        Open = false,
        Options = config.Options,
        Selected = nil
    }
    
    -- Implementation with dynamic drawing objects
    -- ... (similar pattern to button but with more complex interactions)
    
    return dropdown
end

function Eclipse:CreateSlider(parent, config)
    local slider = {
        Value = config.Min or 0,
        Dragging = false
    }
    
    -- Implementation with mouse drag tracking
    -- ... (uses RenderStepped to update position)
    
    return slider
end

-- Theme Management
Eclipse.Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(0, 120, 215),
        Text = Color3.fromRGB(240, 240, 240)
    },
    Cyber = {
        Background = Color3.fromRGB(10, 10, 25),
        Accent = Color3.fromRGB(0, 255, 200),
        Text = Color3.fromRGB(200, 200, 255)
    }
}

return Eclipse
