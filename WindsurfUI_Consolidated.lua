--[[
    WindsurfUI Library - Consolidated Version
    
    A modern, feature-rich UI library for Roblox exploit development
    All modules combined into a single file for easy distribution
]]

-- Initialize the WindsurfUI Library
local WindsurfUI = {}
WindsurfUI.__index = WindsurfUI

-- Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Constants
local TWEEN_SPEED = 0.25
local FONT = Enum.Font.GothamSemibold
local TEXT_SIZE = 14
local CORNER_RADIUS = UDim.new(0, 4)
local DEFAULT_THEME = {
    Background = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(0, 170, 255),
    LightContrast = Color3.fromRGB(35, 35, 35),
    DarkContrast = Color3.fromRGB(20, 20, 20),
    TextColor = Color3.fromRGB(240, 240, 240),
    PlaceholderColor = Color3.fromRGB(180, 180, 180)
}

-- UI Elements Storage
local Elements = {}
local ActiveWindow = nil

-- Utility Functions
local function Create(instanceType)
    return function(properties)
        local instance = Instance.new(instanceType)
        for property, value in pairs(properties) do
            if property ~= "Parent" then
                instance[property] = value
            end
        end
        if properties.Parent then
            instance.Parent = properties.Parent
        end
        return instance
    end
end

local function CreateCorner(parent, radius)
    local corner = Create("UICorner")({
        CornerRadius = radius or CORNER_RADIUS,
        Parent = parent
    })
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Create("UIStroke")({
        Color = color or Color3.fromRGB(50, 50, 50),
        Thickness = thickness or 1,
        Parent = parent
    })
    return stroke
end

-- Dragging Functionality
local function EnableDragging(frame)
    local dragging, dragInput, dragStart, startPos
    
    local function UpdatePosition(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            UpdatePosition(input)
        end
    end)
end

-- Initialize the UI library
function WindsurfUI.new(config)
    local config = config or {}
    local theme = config.Theme or DEFAULT_THEME
    
    -- Create main UI container
    local wsUI = {}
    setmetatable(wsUI, WindsurfUI)
    
    wsUI.Theme = theme
    wsUI.Windows = {}
    
    return wsUI
end

-- Window Creation Method
function WindsurfUI:CreateWindow(config)
    -- Validate config
    config = config or {}
    config.Title = config.Title or "WindsurfUI"
    config.Size = config.Size or UDim2.new(0, 550, 0, 350)
    config.Position = config.Position or UDim2.new(0.5, -275, 0.5, -175)
    
    -- Create window container
    local window = {}
    window.Tabs = {}
    window.ActiveTab = nil
    
    -- Create base GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WindsurfUI_" .. HttpService:GenerateGUID(false):sub(1, 8)
    ScreenGui.DisplayOrder = 100
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to parent to CoreGui (for exploits)
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
            ScreenGui.Parent = game.CoreGui
        elseif gethui then
            ScreenGui.Parent = gethui()
        else
            ScreenGui.Parent = game.CoreGui
        end
    end)
    
    -- If failed, parent to PlayerGui as fallback
    if not ScreenGui.Parent then
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Create main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = config.Size
    MainFrame.Position = config.Position
    MainFrame.BackgroundColor3 = self.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Create corner and shadow
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = MainFrame
    
    local MainShadow = Instance.new("ImageLabel")
    MainShadow.Name = "Shadow"
    MainShadow.Size = UDim2.new(1, 30, 1, 30)
    MainShadow.Position = UDim2.new(0, -15, 0, -15)
    MainShadow.BackgroundTransparency = 1
    MainShadow.Image = "rbxassetid://6014261993"
    MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    MainShadow.ImageTransparency = 0.8
    MainShadow.ScaleType = Enum.ScaleType.Slice
    MainShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    MainShadow.ZIndex = -1
    MainShadow.Parent = MainFrame
    
    -- Create title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = self.Theme.DarkContrast
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 6)
    TitleBarCorner.Parent = TitleBar
    
    local TitleBarBottomCover = Instance.new("Frame")
    TitleBarBottomCover.Name = "BottomCover"
    TitleBarBottomCover.Size = UDim2.new(1, 0, 0, 10)
    TitleBarBottomCover.Position = UDim2.new(0, 0, 1, -10)
    TitleBarBottomCover.BackgroundColor3 = self.Theme.DarkContrast
    TitleBarBottomCover.BorderSizePixel = 0
    TitleBarBottomCover.Parent = TitleBar
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.Size = UDim2.new(1, -40, 1, 0)
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = config.Title
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 16
    TitleText.TextColor3 = self.Theme.TextColor
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Close button
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(1, -30, 0, 8)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Image = "rbxassetid://6031094678"
    CloseButton.ImageColor3 = self.Theme.TextColor
    CloseButton.Parent = TitleBar
    
    CloseButton.MouseEnter:Connect(function()
        CloseButton.ImageColor3 = Color3.fromRGB(255, 50, 50)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CloseButton.ImageColor3 = self.Theme.TextColor
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Create content area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -35)
    ContentFrame.Position = UDim2.new(0, 0, 0, 35)
    ContentFrame.BackgroundColor3 = self.Theme.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    
    -- Create tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 140, 1, 0)
    TabContainer.BackgroundColor3 = self.Theme.LightContrast
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = ContentFrame
    
    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 6)
    TabContainerCorner.Parent = TabContainer
    
    local TabContainerRightCover = Instance.new("Frame")
    TabContainerRightCover.Name = "RightCover"
    TabContainerRightCover.Size = UDim2.new(0, 10, 1, 0)
    TabContainerRightCover.Position = UDim2.new(1, -10, 0, 0)
    TabContainerRightCover.BackgroundColor3 = self.Theme.LightContrast
    TabContainerRightCover.BorderSizePixel = 0
    TabContainerRightCover.Parent = TabContainer
    
    local TabsScrollFrame = Instance.new("ScrollingFrame")
    TabsScrollFrame.Name = "TabsScroll"
    TabsScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    TabsScrollFrame.BackgroundTransparency = 1
    TabsScrollFrame.BorderSizePixel = 0
    TabsScrollFrame.ScrollBarThickness = 0
    TabsScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    TabsScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabsScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabsScrollFrame.Parent = TabContainer
    
    local TabsListLayout = Instance.new("UIListLayout")
    TabsListLayout.Padding = UDim.new(0, 5)
    TabsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsListLayout.Parent = TabsScrollFrame
    
    local TabsPadding = Instance.new("UIPadding")
    TabsPadding.PaddingTop = UDim.new(0, 10)
    TabsPadding.PaddingBottom = UDim.new(0, 10)
    TabsPadding.Parent = TabsScrollFrame
    
    -- Create tab content area
    local TabContentFrame = Instance.new("Frame")
    TabContentFrame.Name = "TabContentFrame"
    TabContentFrame.Size = UDim2.new(1, -140, 1, 0)
    TabContentFrame.Position = UDim2.new(0, 140, 0, 0)
    TabContentFrame.BackgroundTransparency = 1
    TabContentFrame.BorderSizePixel = 0
    TabContentFrame.Parent = ContentFrame
    
    -- Enable dragging
    EnableDragging(TitleBar)
    
    -- Store UI components
    window.ScreenGui = ScreenGui
    window.MainFrame = MainFrame
    window.TabContainer = TabContainer
    window.TabsScrollFrame = TabsScrollFrame
    window.TabContentFrame = TabContentFrame
    
    -- Add to windows collection
    table.insert(self.Windows, window)
    
    -- Create tab method
    function window:CreateTab(info)
        info = info or {}
        info.Name = info.Name or "Tab"
        info.Icon = info.Icon or "rbxassetid://6031265976" -- Default icon
        
        local tab = {}
        tab.Elements = {}
        
        -- Create tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = info.Name .. "TabButton"
        TabButton.Size = UDim2.new(0, 120, 0, 32)
        TabButton.BackgroundColor3 = self.Theme.Background
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabsScrollFrame
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 4)
        TabButtonCorner.Parent = TabButton
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Size = UDim2.new(0, 18, 0, 18)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -9)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = info.Icon
        TabIcon.ImageColor3 = self.Theme.TextColor
        TabIcon.Parent = TabButton
        
        local TabText = Instance.new("TextLabel")
        TabText.Name = "TabText"
        TabText.Size = UDim2.new(1, -40, 1, 0)
        TabText.Position = UDim2.new(0, 35, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Text = info.Name
        TabText.Font = Enum.Font.GothamSemibold
        TabText.TextSize = 14
        TabText.TextColor3 = self.Theme.TextColor
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Parent = TabButton
        
        -- Create tab content container
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = info.Name .. "Content"
        TabContent.Size = UDim2.new(1, -10, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = self.Theme.Accent
        TabContent.ScrollingDirection = Enum.ScrollingDirection.Y
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Visible = false
        TabContent.Parent = TabContentFrame
        
        local ContentListLayout = Instance.new("UIListLayout")
        ContentListLayout.Padding = UDim.new(0, 8)
        ContentListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ContentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentListLayout.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 5)
        ContentPadding.Parent = TabContent
        
        -- Store UI components
        tab.TabButton = TabButton
        tab.TabContent = TabContent
        
        -- Tab selection logic
        local function SelectTab()
            -- Deselect all tabs
            for _, otherTab in pairs(window.Tabs) do
                otherTab.TabButton.BackgroundColor3 = self.Theme.Background
                otherTab.TabContent.Visible = false
            end
            
            -- Select this tab
            TabButton.BackgroundColor3 = self.Theme.Accent
            TabContent.Visible = true
            window.ActiveTab = tab
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        -- Add to tabs collection
        table.insert(window.Tabs, tab)
        
        -- If this is the first tab, select it
        if #window.Tabs == 1 then
            SelectTab()
        end
        
        -- UI Element Creation Methods
        function tab:CreateButton(config)
            config = config or {}
            config.Name = config.Name or "Button"
            config.Callback = config.Callback or function() end
            
            local element = {}
            
            -- Create button container
            local Button = Create("Frame")({
                Name = config.Name .. "_Button",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = self.Theme.LightContrast,
                BorderSizePixel = 0,
                Parent = tab.TabContent
            })
            
            local ButtonCorner = Create("UICorner")({
                CornerRadius = UDim.new(0, 4),
                Parent = Button
            })
            
            local ButtonTitle = Create("TextLabel")({
                Name = "Title",
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = config.Name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = self.Theme.TextColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button
            })
            
            local ClickButton = Create("TextButton")({
                Name = "ClickButton",
                Size = UDim2.new(0, 150, 0, 24),
                Position = UDim2.new(1, -160, 0, 8),
                BackgroundColor3 = self.Theme.DarkContrast,
                BorderSizePixel = 0,
                Text = config.Text or "Click",
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = self.Theme.TextColor,
                AutoButtonColor = false,
                Parent = Button
            })
            
            local ClickButtonCorner = Create("UICorner")({
                CornerRadius = UDim.new(0, 4),
                Parent = ClickButton
            })
            
            -- Hover and click effects
            ClickButton.MouseEnter:Connect(function()
                TweenService:Create(ClickButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = self.Theme.Accent
                }):Play()
            end)
            
            ClickButton.MouseLeave:Connect(function()
                TweenService:Create(ClickButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = self.Theme.DarkContrast
                }):Play()
            end)
            
            ClickButton.MouseButton1Down:Connect(function()
                TweenService:Create(ClickButton, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 145, 0, 22),
                    Position = UDim2.new(1, -157, 0, 9)
                }):Play()
            end)
            
            ClickButton.MouseButton1Up:Connect(function()
                TweenService:Create(ClickButton, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 150, 0, 24),
                    Position = UDim2.new(1, -160, 0, 8)
                }):Play()
            end)
            
            ClickButton.MouseButton1Click:Connect(function()
                config.Callback()
            end)
            
            element.Instance = Button
            return element
        end
        
        function tab:CreateToggle(config)
            config = config or {}
            config.Name = config.Name or "Toggle"
            config.Default = config.Default or false
            config.Callback = config.Callback or function(value) end
            
            local element = {}
            element.Value = config.Default
            
            -- Create toggle container
            local Toggle = Create("Frame")({
                Name = config.Name .. "_Toggle",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = self.Theme.LightContrast,
                BorderSizePixel = 0,
                Parent = tab.TabContent
            })
            
            local ToggleCorner = Create("UICorner")({
                CornerRadius = UDim.new(0, 4),
                Parent = Toggle
            })
            
            local ToggleTitle = Create("TextLabel")({
                Name = "Title",
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = config.Name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = self.Theme.TextColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Toggle
            })
            
            local ToggleDescription = Create("TextLabel")({
                Name = "Description",
                Size = UDim2.new(1, -170, 0, 16),
                Position = UDim2.new(0, 10, 1, -20),
                BackgroundTransparency = 1,
                Text = config.Description or "This is a toggle!",
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = self.Theme.PlaceholderColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Toggle
            })
            
            -- Create toggle switch
            local ToggleOuter = Create("Frame")({
                Name = "ToggleOuter",
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -55, 0, 10),
                BackgroundColor3 = self.Theme.DarkContrast,
                BorderSizePixel = 0,
                Parent = Toggle
            })
            
            local ToggleOuterCorner = Create("UICorner")({
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleOuter
            })
            
            local ToggleInner = Create("Frame")({
                Name = "ToggleInner",
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 2, 0, 2),
                BackgroundColor3 = self.Theme.TextColor,
                BorderSizePixel = 0,
                Parent = ToggleOuter
            })
            
            local ToggleInnerCorner = Create("UICorner")({
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleInner
            })
            
            -- Toggle functionality
            local function UpdateToggle()
                local pos = element.Value and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
                local color = element.Value and self.Theme.Accent or self.Theme.DarkContrast
                
                TweenService:Create(ToggleOuter, TweenInfo.new(0.2), {
                    BackgroundColor3 = color
                }):Play()
                
                TweenService:Create(ToggleInner, TweenInfo.new(0.2), {
                    Position = pos
                }):Play()
                
                config.Callback(element.Value)
            end
            
            ToggleOuter.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    element.Value = not element.Value
                    UpdateToggle()
                end
            end)
            
            -- Set default value visual
            if config.Default then
                ToggleOuter.BackgroundColor3 = self.Theme.Accent
                ToggleInner.Position = UDim2.new(1, -18, 0, 2)
            end
            
            -- Update method
            function element:SetValue(value)
                if type(value) ~= "boolean" then return end
                element.Value = value
                UpdateToggle()
            end
            
            element.Instance = Toggle
            return element
        end
        
        function tab:CreateSlider(config)
            config = config or {}
            config.Name = config.Name or "Slider"
            config.Min = config.Min or 0
            config.Max = config.Max or 100
            config.Default = config.Default or math.floor((config.Min + config.Max) / 2)
            config.Increment = config.Increment or 1
            config.Callback = config.Callback or function(value) end
            
            -- Validation
            config.Default = math.clamp(config.Default, config.Min, config.Max)
            
            local element = {}
            element.Value = config.Default
            
            -- Create slider container
            local Slider = Create("Frame")({
                Name = config.Name .. "_Slider",
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = self.Theme.LightContrast,
                BorderSizePixel = 0,
                Parent = tab.TabContent
            })
            
            local SliderCorner = Create("UICorner")({
                CornerRadius = UDim.new(0, 4),
                Parent = Slider
            })
            
            local SliderTitle = Create("TextLabel")({
                Name = "Title",
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = config.Name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = self.Theme.TextColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Slider
            })
            
            local SliderValue = Create("TextBox")({
                Name = "Value",
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -60, 0, 5),
                BackgroundColor3 = self.Theme.DarkContrast,
                BorderSizePixel = 0,
                Text = tostring(config.Default),
                Font = Enum.Font.GothamSemibold,
                TextSize = 12,
                TextColor3 = self.Theme.TextColor,
                TextWrapped = true,
                Parent = Slider
            })
            
            local SliderValueCorner = Create("UICorner")({
                CornerRadius = UDim.new(0, 4),
                Parent = SliderValue
            })
            
            -- Create slider bar
            local SliderBar = Create("Frame")({
                Name = "SliderBar",
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 35),
                BackgroundColor3 = self.Theme.DarkContrast,
                BorderSizePixel = 0,
                Parent = Slider
            })
            
            local SliderBarCorner = Create("UICorner")({
                CornerRadius = UDim.new(1, 0),
                Parent = SliderBar
            })
            
            local SliderFill = Create("Frame")({
                Name = "SliderFill",
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = self.Theme.Accent,
                BorderSizePixel = 0,
                Parent = SliderBar
            })
            
            local SliderFillCorner = Create("UICorner")({
                CornerRadius = UDim.new(1, 0),
                Parent = SliderFill
            })
            
            local SliderDrag = Create("Frame")({
                Name = "SliderDrag",
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0, -6, 0.5, -6),
                BackgroundColor3 = self.Theme.TextColor,
                BorderSizePixel = 0,
                Parent = SliderFill
            })
            
            local SliderDragCorner = Create("UICorner")({
                CornerRadius = UDim.new(1, 0),
                Parent = SliderDrag
            })
            
            -- Slider functionality
            local MinValue = config.Min
            local MaxValue = config.Max
            local dragging = false
            
            local function UpdateSlider(value)
                -- Round to increment
                value = math.floor(value / config.Increment + 0.5) * config.Increment
                value = math.clamp(value, MinValue, MaxValue)
                
                -- Convert to percentage
                local percent = (value - MinValue) / (MaxValue - MinValue)
                
                -- Update UI
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderValue.Text = tostring(value)
                
                -- Invoke callback
                element.Value = value
                config.Callback(value)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                    local sliderPos = SliderBar.AbsolutePosition.X
                    local sliderSize = SliderBar.AbsoluteSize.X
                    local relativePos = math.clamp((mousePos.X - sliderPos) / sliderSize, 0, 1)
                    
                    local value = MinValue + ((MaxValue - MinValue) * relativePos)
                    UpdateSlider(value)
                end
            end)
            
            SliderValue.FocusLost:Connect(function()
                local value = tonumber(SliderValue.Text)
                if value then
                    UpdateSlider(value)
                else
                    SliderValue.Text = tostring(element.Value)
                end
            end)
            
            -- Set default value visual
            UpdateSlider(config.Default)
            
            -- Update method
            function element:SetValue(value)
                UpdateSlider(value)
            end
            
            element.Instance = Slider
            return element
        end
        
        function tab:CreateColorPicker(config)
            config = config or {}
            config.Name = config.Name or "ColorPicker"
            config.Default = config.Default or Color3.fromRGB(255, 0, 0)
            config.Callback = config.Callback or function(color) end
            
            local element = {}
            element.Value = config.Default
            
            -- Create colorpicker container
            local ColorPicker = Create("Frame")({
                Name = config.Name .. "_ColorPicker",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = self.Theme.LightContrast,
                BorderSizePixel = 0,
                Parent = tab.TabContent
            })
            
            local ColorPickerCorner = Create("UICorner")({
                CornerRadius = UDim.new(0, 4),
                Parent = ColorPicker
            })
            
            local ColorPickerTitle = Create("TextLabel")({
                Name = "Title",
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = config.Name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = self.Theme.TextColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ColorPicker
            })
            
            -- Create color display
            local ColorDisplay = Create("Frame")({
                Name = "ColorDisplay",
                Size = UDim2.new(0, 30, 0, 22),
                Position = UDim2.new(1, -40, 0, 9),
                BackgroundColor3 = config.Default,
                BorderSizePixel = 0,
                Parent = ColorPicker
            })
            
            local ColorDisplayCorner = Create("UICorner")({
                CornerRadius = UDim.new(0, 4),
                Parent = ColorDisplay
            })
            
            -- Click functionality (basic implementation)
            ColorDisplay.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    -- In a full implementation, this would open a color picker popup
                    -- For this demo, we'll just cycle through some preset colors
                    local colors = {
                        Color3.fromRGB(255, 0, 0),   -- Red
                        Color3.fromRGB(0, 255, 0),   -- Green
                        Color3.fromRGB(0, 0, 255),   -- Blue
                        Color3.fromRGB(255, 255, 0), -- Yellow
                        Color3.fromRGB(255, 0, 255), -- Magenta
                        Color3.fromRGB(0, 255, 255)  -- Cyan
                    }
                    
                    -- Find the next color in the cycle
                    local currentIndex = 1
                    for i, color in ipairs(colors) do
                        if color == element.Value then
                            currentIndex = i
                            break
                        end
                    end
                    
                    local nextIndex = (currentIndex % #colors) + 1
                    element.Value = colors[nextIndex]
                    
                    -- Update display
                    ColorDisplay.BackgroundColor3 = element.Value
                    config.Callback(element.Value)
                end
            end)
            
            -- Update method
            function element:SetValue(color)
                if typeof(color) ~= "Color3" then return end
                element.Value = color
                ColorDisplay.BackgroundColor3 = color
                config.Callback(color)
            end
            
            element.Instance = ColorPicker
            return element
        end
        
        return tab
    end
    
    return window
end

-- Return the library
return WindsurfUI.new()
         
