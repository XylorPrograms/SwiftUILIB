-- SwiftUI Library v1.1
-- A clean UI library for Roblox with sidebar tabs and smooth animations

local SwiftUI = {}
SwiftUI.__index = SwiftUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Animation settings
local TWEEN_INFO = TweenInfo.new(
    0.3, -- Duration
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out,
    0, -- Repeat count
    false, -- Reverses
    0 -- Delay
)

local FAST_TWEEN = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- Utility Functions
local function CreateTween(object, properties)
    return TweenService:Create(object, TWEEN_INFO, properties)
end

local function FastTween(object, properties)
    return TweenService:Create(object, FAST_TWEEN, properties)
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Color3.fromRGB(60, 60, 60)
    stroke.Parent = parent
    return stroke
end

-- Main Library Functions
function SwiftUI:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "SwiftUI Window"
    local windowSize = config.Size or UDim2.new(0, 600, 0, 450)
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SwiftUI_" .. windowTitle
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = windowSize
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    CreateCorner(mainFrame, 12)
    CreateStroke(mainFrame, 1, Color3.fromRGB(40, 40, 40))
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    CreateCorner(titleBar, 12)
    
    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = windowTitle
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.Parent = titleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0.5, 0)
    closeButton.AnchorPoint = Vector2.new(0, 0.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    CreateCorner(closeButton, 4)
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 140, 1, -45)
    sidebar.Position = UDim2.new(0, 10, 0, 40)
    sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    
    CreateCorner(sidebar, 8)
    CreateStroke(sidebar, 1, Color3.fromRGB(35, 35, 35))
    
    -- Sidebar ScrollFrame
    local sidebarScroll = Instance.new("ScrollingFrame")
    sidebarScroll.Name = "SidebarScroll"
    sidebarScroll.Size = UDim2.new(1, -10, 1, -10)
    sidebarScroll.Position = UDim2.new(0, 5, 0, 5)
    sidebarScroll.BackgroundTransparency = 1
    sidebarScroll.BorderSizePixel = 0
    sidebarScroll.ScrollBarThickness = 0
    sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebarScroll.Parent = sidebar
    
    -- Sidebar List Layout
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 5)
    sidebarLayout.Parent = sidebarScroll
    
    -- Auto-resize sidebar canvas
    sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -170, 1, -55)
    contentContainer.Position = UDim2.new(0, 160, 0, 45)
    contentContainer.BackgroundTransparency = 1
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = mainFrame
    
    -- Window object
    local window = {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        ContentContainer = contentContainer,
        Sidebar = sidebar,
        SidebarScroll = sidebarScroll,
        TitleBar = titleBar,
        CloseButton = closeButton,
        Tabs = {},
        CurrentTab = nil
    }
    
    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            FastTween(mainFrame, {Position = newPos}):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        CreateTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        CreateTween(mainFrame, {BackgroundTransparency = 1}):Play()
        wait(0.3)
        screenGui:Destroy()
    end)
    
    -- Button hover effects
    closeButton.MouseEnter:Connect(function()
        FastTween(closeButton, {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        FastTween(closeButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    
    -- Tab creation function
    function window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or "⚙️"
        
        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "Tab_" .. tabName
        tabButton.Size = UDim2.new(1, 0, 0, 30)
        tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        tabButton.Text = ""
        tabButton.BorderSizePixel = 0
        tabButton.Parent = sidebarScroll
        
        CreateCorner(tabButton, 6)
        
        -- Tab Icon
        local tabIconLabel = Instance.new("TextLabel")
        tabIconLabel.Size = UDim2.new(0, 20, 1, 0)
        tabIconLabel.Position = UDim2.new(0, 8, 0, 0)
        tabIconLabel.BackgroundTransparency = 1
        tabIconLabel.Text = tabIcon
        tabIconLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        tabIconLabel.TextSize = 14
        tabIconLabel.Font = Enum.Font.Gotham
        tabIconLabel.Parent = tabButton
        
        -- Tab Label
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -35, 1, 0)
        tabLabel.Position = UDim2.new(0, 28, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = tabName
        tabLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        tabLabel.TextSize = 12
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Font = Enum.Font.Gotham
        tabLabel.Parent = tabButton
        
        -- Tab Content Frame
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = "TabContent_" .. tabName
        tabContent.Size = UDim2.new(1, -10, 1, -10)
        tabContent.Position = UDim2.new(0, 5, 0, 5)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
        tabContent.Parent = contentContainer
        
        -- Content List Layout
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 8)
        contentLayout.Parent = tabContent
        
        -- Auto-resize content canvas
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab object
        local tab = {
            Button = tabButton,
            Content = tabContent,
            IconLabel = tabIconLabel,
            Label = tabLabel,
            Name = tabName,
            IsActive = false
        }
        
        -- Tab switching logic
        local function setActiveTab(targetTab)
            -- Deactivate all tabs
            for _, existingTab in pairs(window.Tabs) do
                existingTab.IsActive = false
                existingTab.Content.Visible = false
                FastTween(existingTab.Button, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                FastTween(existingTab.IconLabel, {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
                FastTween(existingTab.Label, {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            end
            
            -- Activate target tab
            targetTab.IsActive = true
            targetTab.Content.Visible = true
            window.CurrentTab = targetTab
            FastTween(targetTab.Button, {BackgroundColor3 = Color3.fromRGB(60, 120, 255)}):Play()
            FastTween(targetTab.IconLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            FastTween(targetTab.Label, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end
        
        tabButton.MouseButton1Click:Connect(function()
            setActiveTab(tab)
        end)
        
        -- Tab hover effects
        tabButton.MouseEnter:Connect(function()
            if not tab.IsActive then
                FastTween(tabButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if not tab.IsActive then
                FastTween(tabButton, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
            end
        end)
        
        -- Tab methods
        function tab:CreateButton(config)
            config = config or {}
            local buttonText = config.Text or "Button"
            local callback = config.Callback or function() end
            
            local button = Instance.new("TextButton")
            button.Name = "Button_" .. buttonText
            button.Size = UDim2.new(1, -10, 0, 35)
            button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            button.Text = buttonText
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.Gotham
            button.BorderSizePixel = 0
            button.Parent = tabContent
            
            CreateCorner(button, 6)
            CreateStroke(button, 1, Color3.fromRGB(50, 50, 50))
            
            -- Button animations
            button.MouseEnter:Connect(function()
                FastTween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end)
            
            button.MouseLeave:Connect(function()
                FastTween(button, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            end)
            
            button.MouseButton1Down:Connect(function()
                FastTween(button, {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
            end)
            
            button.MouseButton1Up:Connect(function()
                FastTween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end)
            
            button.MouseButton1Click:Connect(callback)
            
            return button
        end
        
        function tab:CreateToggle(config)
            config = config or {}
            local toggleText = config.Text or "Toggle"
            local defaultValue = config.Default or false
            local callback = config.Callback or function() end
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = "Toggle_" .. toggleText
            toggleFrame.Size = UDim2.new(1, -10, 0, 35)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Parent = tabContent
            
            CreateCorner(toggleFrame, 6)
            CreateStroke(toggleFrame, 1, Color3.fromRGB(50, 50, 50))
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(1, -50, 1, 0)
            toggleLabel.Position = UDim2.new(0, 10, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = toggleText
            toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleLabel.TextSize = 14
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.Parent = toggleFrame
            
            local toggleButton = Instance.new("Frame")
            toggleButton.Size = UDim2.new(0, 40, 0, 20)
            toggleButton.Position = UDim2.new(1, -45, 0.5, 0)
            toggleButton.AnchorPoint = Vector2.new(0, 0.5)
            toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(60, 150, 255) or Color3.fromRGB(60, 60, 60)
            toggleButton.BorderSizePixel = 0
            toggleButton.Parent = toggleFrame
            
            CreateCorner(toggleButton, 10)
            
            local toggleIndicator = Instance.new("Frame")
            toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            toggleIndicator.Position = defaultValue and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            toggleIndicator.AnchorPoint = Vector2.new(0, 0.5)
            toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleIndicator.BorderSizePixel = 0
            toggleIndicator.Parent = toggleButton
            
            CreateCorner(toggleIndicator, 8)
            
            local isToggled = defaultValue
            
            local function updateToggle()
                if isToggled then
                    CreateTween(toggleButton, {BackgroundColor3 = Color3.fromRGB(60, 150, 255)}):Play()
                    CreateTween(toggleIndicator, {Position = UDim2.new(1, -18, 0.5, 0)}):Play()
                else
                    CreateTween(toggleButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                    CreateTween(toggleIndicator, {Position = UDim2.new(0, 2, 0.5, 0)}):Play()
                end
                callback(isToggled)
            end
            
            local clickDetector = Instance.new("TextButton")
            clickDetector.Size = UDim2.new(1, 0, 1, 0)
            clickDetector.BackgroundTransparency = 1
            clickDetector.Text = ""
            clickDetector.Parent = toggleFrame
            
            clickDetector.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                updateToggle()
            end)
            
            return {Frame = toggleFrame, GetValue = function() return isToggled end}
        end
        
        function tab:CreateLabel(config)
            config = config or {}
            local labelText = config.Text or "Label"
            
            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.Size = UDim2.new(1, -10, 0, 25)
            label.BackgroundTransparency = 1
            label.Text = labelText
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = tabContent
            
            return label
        end
        
        -- Store tab and activate first one
        window.Tabs[tabName] = tab
        if not window.CurrentTab then
            setActiveTab(tab)
        end
        
        return tab
    end
    
    -- Entrance animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundTransparency = 1
    
    CreateTween(mainFrame, {Size = windowSize}):Play()
    CreateTween(mainFrame, {BackgroundTransparency = 0}):Play()
    
    return window
end

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

return SwiftUI
