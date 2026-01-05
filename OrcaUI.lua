-- Airflow UI Library
-- Advanced Roblox UI Library with smooth animations and modern design

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.__index = Library

-- Utility Functions
local function Tween(obj, props, duration, style, direction)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(frame, {Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)}, 0.1)
        end
    end)
end

-- Create Main Window
function Library:CreateWindow(config)
    config = config or {}
    config.Name = config.Name or "Airflow"
    config.Size = config.Size or UDim2.new(0, 750, 0, 550)
    config.Theme = config.Theme or {
        Background = Color3.fromRGB(20, 25, 30),
        Secondary = Color3.fromRGB(25, 30, 35),
        Accent = Color3.fromRGB(70, 200, 120),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 180)
    }
    
    local Window = {}
    Window.Tabs = {}
    Window.Theme = config.Theme
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AirflowUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = config.Size
    MainFrame.Position = UDim2.new(0.5, -config.Size.X.Offset/2, 0.5, -config.Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = Window.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- Shadow effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.7
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Window.Theme.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    local TopBarCover = Instance.new("Frame")
    TopBarCover.Size = UDim2.new(1, 0, 0, 8)
    TopBarCover.Position = UDim2.new(0, 0, 1, -8)
    TopBarCover.BackgroundColor3 = Window.Theme.Secondary
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Parent = TopBar
    
    -- Logo/Icon
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 30, 0, 30)
    Logo.Position = UDim2.new(0, 15, 0.5, -15)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://7734053495"
    Logo.ImageColor3 = Window.Theme.Accent
    Logo.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 55, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Name
    Title.TextColor3 = Window.Theme.Text
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Size = UDim2.new(0, 200, 0, 12)
    Subtitle.Position = UDim2.new(0, 55, 0, 25)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Main Features"
    Subtitle.TextColor3 = Window.Theme.SubText
    Subtitle.TextSize = 11
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = TopBar
    
    -- Search Box
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBox"
    SearchBox.Size = UDim2.new(0, 200, 0, 28)
    SearchBox.Position = UDim2.new(0.5, -100, 0.5, -14)
    SearchBox.BackgroundColor3 = Window.Theme.Background
    SearchBox.BorderSizePixel = 0
    SearchBox.Text = ""
    SearchBox.PlaceholderText = "Search"
    SearchBox.TextColor3 = Window.Theme.Text
    SearchBox.PlaceholderColor3 = Window.Theme.SubText
    SearchBox.TextSize = 13
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.ClearTextOnFocus = false
    SearchBox.Parent = TopBar
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchBox
    
    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Size = UDim2.new(0, 16, 0, 16)
    SearchIcon.Position = UDim2.new(0, 8, 0.5, -8)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = "rbxassetid://7072725342"
    SearchIcon.ImageColor3 = Window.Theme.SubText
    SearchIcon.Parent = SearchBox
    
    SearchBox.Focused:Connect(function()
        Tween(SearchBox, {BackgroundColor3 = Window.Theme.Secondary}, 0.2)
    end)
    
    SearchBox.FocusLost:Connect(function()
        Tween(SearchBox, {BackgroundColor3 = Window.Theme.Background}, 0.2)
    end)
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -40, 0, 5)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Window.Theme.Text
    CloseButton.TextSize = 24
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 75, 1, -45)
    Sidebar.Position = UDim2.new(0, 0, 0, 45)
    Sidebar.BackgroundColor3 = Window.Theme.Secondary
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.Parent = Sidebar
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.Parent = Sidebar
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -75, 1, -45)
    ContentArea.Position = UDim2.new(0, 75, 0, 45)
    ContentArea.BackgroundColor3 = Window.Theme.Background
    ContentArea.BorderSizePixel = 0
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = MainFrame
    
    -- Make draggable
    MakeDraggable(MainFrame, TopBar)
    
    -- Create Tab Function
    function Window:CreateTab(config)
        config = config or {}
        config.Name = config.Name or "Tab"
        config.Icon = config.Icon or "rbxassetid://7734053495"
        
        local Tab = {}
        Tab.Sections = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = config.Name
        TabButton.Size = UDim2.new(1, 0, 0, 60)
        TabButton.BackgroundColor3 = Window.Theme.Secondary
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Text = ""
        TabButton.Parent = Sidebar
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Size = UDim2.new(0, 28, 0, 28)
        TabIcon.Position = UDim2.new(0.5, -14, 0.5, -14)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = config.Icon
        TabIcon.ImageColor3 = Window.Theme.SubText
        TabIcon.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = config.Name .. "Content"
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Window.Theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentArea
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 10)
        ContentList.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Button Click
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button.Icon, {ImageColor3 = Window.Theme.SubText}, 0.2)
                tab.Button.BackgroundColor3 = Window.Theme.Secondary
            end
            
            TabContent.Visible = true
            Tween(TabIcon, {ImageColor3 = Window.Theme.Accent}, 0.2)
            Tween(TabButton, {BackgroundColor3 = Window.Theme.Background}, 0.2)
        end)
        
        -- Hover effect
        TabButton.MouseEnter:Connect(function()
            if not TabContent.Visible then
                Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(30, 35, 40)}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not TabContent.Visible then
                Tween(TabButton, {BackgroundColor3 = Window.Theme.Secondary}, 0.2)
            end
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Create Section Function
        function Tab:CreateSection(name)
            local Section = {}
            Section.Elements = {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name
            SectionFrame.Size = UDim2.new(0.48, 0, 0, 40)
            SectionFrame.BackgroundColor3 = Window.Theme.Secondary
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = SectionFrame
            
            -- Section Header
            local SectionHeader = Instance.new("TextButton")
            SectionHeader.Name = "Header"
            SectionHeader.Size = UDim2.new(1, 0, 0, 40)
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Text = ""
            SectionHeader.Parent = SectionFrame
            
            local SectionIcon = Instance.new("ImageLabel")
            SectionIcon.Name = "Icon"
            SectionIcon.Size = UDim2.new(0, 20, 0, 20)
            SectionIcon.Position = UDim2.new(0, 15, 0.5, -10)
            SectionIcon.BackgroundTransparency = 1
            SectionIcon.Image = "rbxassetid://7734053495"
            SectionIcon.ImageColor3 = Window.Theme.Accent
            SectionIcon.Parent = SectionHeader
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -100, 1, 0)
            SectionTitle.Position = UDim2.new(0, 45, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = name
            SectionTitle.TextColor3 = Window.Theme.Text
            SectionTitle.TextSize = 14
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionHeader
            
            local Arrow = Instance.new("ImageLabel")
            Arrow.Name = "Arrow"
            Arrow.Size = UDim2.new(0, 12, 0, 12)
            Arrow.Position = UDim2.new(1, -25, 0.5, -6)
            Arrow.BackgroundTransparency = 1
            Arrow.Image = "rbxassetid://7734052925"
            Arrow.ImageColor3 = Window.Theme.SubText
            Arrow.Rotation = 0
            Arrow.Parent = SectionHeader
            
            -- Section Content
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.Size = UDim2.new(1, -20, 1, -50)
            SectionContent.Position = UDim2.new(0, 10, 0, 45)
            SectionContent.BackgroundTransparency = 1
            SectionContent.ClipsDescendants = true
            SectionContent.Visible = true
            SectionContent.Parent = SectionFrame
            
            local ContentList = Instance.new("UIListLayout")
            ContentList.SortOrder = Enum.SortOrder.LayoutOrder
            ContentList.Padding = UDim.new(0, 8)
            ContentList.Parent = SectionContent
            
            local isOpen = true
            
            ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then
                    Tween(SectionFrame, {Size = UDim2.new(0.48, 0, 0, ContentList.AbsoluteContentSize.Y + 60)}, 0.3)
                end
            end)
            
            -- Toggle Section
            SectionHeader.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    Tween(Arrow, {Rotation = 0}, 0.3)
                    Tween(SectionFrame, {Size = UDim2.new(0.48, 0, 0, ContentList.AbsoluteContentSize.Y + 60)}, 0.3)
                    SectionContent.Visible = true
                else
                    Tween(Arrow, {Rotation = -90}, 0.3)
                    Tween(SectionFrame, {Size = UDim2.new(0.48, 0, 0, 40)}, 0.3)
                    wait(0.3)
                    SectionContent.Visible = false
                end
            end)
            
            Section.Frame = SectionFrame
            Section.Content = SectionContent
            
            -- Toggle
            function Section:CreateToggle(config)
                config = config or {}
                config.Name = config.Name or "Toggle"
                config.Default = config.Default or false
                config.Callback = config.Callback or function() end
                
                local Toggle = {}
                local toggled = config.Default
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = "Toggle"
                ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Parent = SectionContent
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.Position = UDim2.new(0, 0, 0.5, -10)
                ToggleButton.BackgroundColor3 = toggled and Window.Theme.Accent or Color3.fromRGB(40, 45, 50)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.AutoButtonColor = false
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(1, 0)
                ToggleCorner.Parent = ToggleButton
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "Indicator"
                ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
                ToggleIndicator.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleIndicator.BorderSizePixel = 0
                ToggleIndicator.Parent = ToggleButton
                
                local IndicatorCorner = Instance.new("UICorner")
                IndicatorCorner.CornerRadius = UDim.new(1, 0)
                IndicatorCorner.Parent = ToggleIndicator
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 50, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = config.Name
                ToggleLabel.TextColor3 = Window.Theme.Text
                ToggleLabel.TextSize = 13
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                function Toggle:Set(value)
                    toggled = value
                    
                    Tween(ToggleButton, {
                        BackgroundColor3 = toggled and Window.Theme.Accent or Color3.fromRGB(40, 45, 50)
                    }, 0.2)
                    
                    Tween(ToggleIndicator, {
                        Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    }, 0.2)
                    
                    pcall(config.Callback, toggled)
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    Toggle:Set(not toggled)
                end)
                
                if config.Default then
                    Toggle:Set(true)
                end
                
                return Toggle
            end
            
            -- Button
            function Section:CreateButton(config)
                config = config or {}
                config.Name = config.Name or "Button"
                config.Callback = config.Callback or function() end
                
                local ButtonFrame = Instance.new("TextButton")
                ButtonFrame.Name = "Button"
                ButtonFrame.Size = UDim2.new(1, 0, 0, 32)
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.AutoButtonColor = false
                ButtonFrame.Text = config.Name
                ButtonFrame.TextColor3 = Window.Theme.Text
                ButtonFrame.TextSize = 13
                ButtonFrame.Font = Enum.Font.GothamBold
                ButtonFrame.Parent = SectionContent
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = ButtonFrame
                
                ButtonFrame.MouseEnter:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Window.Theme.Accent}, 0.2)
                end)
                
                ButtonFrame.MouseLeave:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(30, 35, 40)}, 0.2)
                end)
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    pcall(config.Callback)
                    
                    Tween(ButtonFrame, {Size = UDim2.new(1, 0, 0, 28)}, 0.1)
                    wait(0.1)
                    Tween(ButtonFrame, {Size = UDim2.new(1, 0, 0, 32)}, 0.1)
                end)
                
                return ButtonFrame
            end
            
            -- Slider
            function Section:CreateSlider(config)
                config = config or {}
                config.Name = config.Name or "Slider"
                config.Min = config.Min or 0
                config.Max = config.Max or 100
                config.Default = config.Default or 50
                config.Increment = config.Increment or 1
                config.Callback = config.Callback or function() end
                
                local Slider = {}
                local value = config.Default
                local dragging = false
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = "Slider"
                SliderFrame.Size = UDim2.new(1, 0, 0, 50)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = SectionContent
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = config.Name
                SliderLabel.TextColor3 = Window.Theme.Text
                SliderLabel.TextSize = 13
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Size = UDim2.new(0.3, 0, 0, 20)
                SliderValue.Position = UDim2.new(0.7, 0, 0, 0)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Text = tostring(value)
                SliderValue.TextColor3 = Window.Theme.Accent
                SliderValue.TextSize = 13
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = SliderFrame
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(1, 0, 0, 6)
                SliderBar.Position = UDim2.new(0, 0, 0, 30)
                SliderBar.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
                SliderBar.BorderSizePixel = 0
                SliderBar.Parent = SliderFrame
                
                local SliderBarCorner = Instance.new("UICorner")
                SliderBarCorner.CornerRadius = UDim.new(1, 0)
                SliderBarCorner.Parent = SliderBar
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Size = UDim2.new((value - config.Min) / (config.Max - config.Min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Window.Theme.Accent
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBar
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(1, 0)
                SliderFillCorner.Parent = SliderFill
                
                local SliderButton = Instance.new("TextButton")
                SliderButton.Size = UDim2.new(0, 16, 0, 16)
                SliderButton.Position = UDim2.new((value - config.Min) / (config.Max - config.Min), -8, 0.5, -8)
                SliderButton.BackgroundColor3 = Window.Theme.Accent
                SliderButton.BorderSizePixel = 0
                SliderButton.AutoButtonColor = false
                SliderButton.Text = ""
                SliderButton.Parent = SliderBar
                
                local SliderButtonCorner = Instance.new("UICorner")
                SliderButtonCorner.CornerRadius = UDim.new(1, 0)
                SliderButtonCorner.Parent = SliderButton
                
                function Slider:Set(val)
                    value = math.clamp(math.floor((val / config.Increment) + 0.5) * config.Increment, config.Min, config.Max)
                    
                    SliderValue.Text = tostring(value)
                    
                    local percentage = (value - config.Min) / (config.Max - config.Min)
                    
                    Tween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                    Tween(SliderButton, {Position = UDim2.new(percentage, -8, 0.5, -8)}, 0.1)
                    
                    pcall(config.Callback, value)
                end
                
                SliderButton.MouseButton1Down:Connect(function()
                    dragging = true
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        
                        local percentage = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                        local newValue = config.Min + (percentage * (config.Max - config.Min))
                        Slider:Set(newValue)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percentage = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                        local newValue = config.Min + (percentage * (config.Max - config.Min))
                        Slider:Set(newValue)
                    end
                end)
                
                Slider:Set(config.Default)
                
                return Slider
            end
            
            -- Dropdown
            function Section:CreateDropdown(config)
                config = config or {}
                config.Name = config.Name or "Dropdown"
                config.Options = config.Options or {"Option 1", "Option 2"}
                config.Default = config.Default or config.Options[1]
                config.Callback = config.Callback or function() end
                
                local Dropdown = {}
                local selected = config.Default
                local isOpen = false
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = "Dropdown"
                DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.ClipsDescendants = true
                DropdownFrame.Parent = SectionContent
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 6)
                DropdownCorner.Parent = DropdownFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Size = UDim2.new(1, 0, 0, 35)
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Text = ""
                DropdownButton.Parent = DropdownFrame
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Size = UDim2.new(1, -50, 1, 0)
                DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = config.Name
                DropdownLabel.TextColor3 = Window.Theme.SubText
                DropdownLabel.TextSize = 11
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.TextYAlignment = Enum.TextYAlignment.Top
                DropdownLabel.Parent = DropdownButton
                
                local DropdownSelected = Instance.new("TextLabel")
                DropdownSelected.Size = UDim2.new(1, -50, 0, 15)
                DropdownSelected.Position = UDim2.new(0, 10, 0, 15)
                DropdownSelected.BackgroundTransparency = 1
                DropdownSelected.Text = selected
                DropdownSelected.TextColor3 = Window.Theme.Text
                DropdownSelected.TextSize = 13
                DropdownSelected.Font = Enum.Font.GothamBold
                DropdownSelected.TextXAlignment = Enum.TextXAlignment.Left
                DropdownSelected.Parent = DropdownButton
                
                local DropdownArrow = Instance.new("ImageLabel")
                DropdownArrow.Size = UDim2.new(0, 12, 0, 12)
                DropdownArrow.Position = UDim2.new(1, -25, 0, 12)
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Image = "rbxassetid://7734052925"
                DropdownArrow.ImageColor3 = Window.Theme.SubText
                DropdownArrow.Rotation = 0
                DropdownArrow.Parent = DropdownButton
                
                local DropdownList = Instance.new("ScrollingFrame")
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
                DropdownList.Position = UDim2.new(0, 0, 0, 40)
                DropdownList.BackgroundTransparency = 1
                DropdownList.BorderSizePixel = 0
                DropdownList.ScrollBarThickness = 3
                DropdownList.ScrollBarImageColor3 = Window.Theme.Accent
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, #config.Options * 30)
                DropdownList.Visible = false
                DropdownList.Parent = DropdownFrame
                
                local ListLayout = Instance.new("UIListLayout")
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Parent = DropdownList
                
                function Dropdown:Refresh(options, keepSelection)
                    DropdownList:ClearAllChildren()
                    
                    local ListLayout = Instance.new("UIListLayout")
                    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    ListLayout.Parent = DropdownList
                    
                    config.Options = options
                    
                    if not keepSelection or not table.find(options, selected) then
                        selected = options[1]
                        DropdownSelected.Text = selected
                    end
                    
                    DropdownList.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
                    
                    for _, option in ipairs(options) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Size = UDim2.new(1, 0, 0, 30)
                        OptionButton.BackgroundColor3 = option == selected and Window.Theme.Accent or Color3.fromRGB(35, 40, 45)
                        OptionButton.BorderSizePixel = 0
                        OptionButton.AutoButtonColor = false
                        OptionButton.Text = option
                        OptionButton.TextColor3 = Window.Theme.Text
                        OptionButton.TextSize = 12
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.Parent = DropdownList
                        
                        OptionButton.MouseEnter:Connect(function()
                            if option ~= selected then
                                Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(40, 45, 50)}, 0.2)
                            end
                        end)
                        
                        OptionButton.MouseLeave:Connect(function()
                            if option ~= selected then
                                Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(35, 40, 45)}, 0.2)
                            end
                        end)
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            for _, btn in ipairs(DropdownList:GetChildren()) do
                                if btn:IsA("TextButton") then
                                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(35, 40, 45)}, 0.2)
                                end
                            end
                            
                            selected = option
                            DropdownSelected.Text = selected
                            Tween(OptionButton, {BackgroundColor3 = Window.Theme.Accent}, 0.2)
                            
                            pcall(config.Callback, selected)
                            
                            -- Close dropdown
                            isOpen = false
                            Tween(DropdownArrow, {Rotation = 0}, 0.2)
                            Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                            Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.2)
                            wait(0.2)
                            DropdownList.Visible = false
                        end)
                    end
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    if isOpen then
                        DropdownList.Visible = true
                        Tween(DropdownArrow, {Rotation = 180}, 0.2)
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, math.min(#config.Options * 30, 120))}, 0.2)
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40 + math.min(#config.Options * 30, 120))}, 0.2)
                    else
                        Tween(DropdownArrow, {Rotation = 0}, 0.2)
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.2)
                        wait(0.2)
                        DropdownList.Visible = false
                    end
                end)
                
                Dropdown:Refresh(config.Options)
                
                return Dropdown
            end
            
            -- Label/Text
            function Section:CreateLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = Window.Theme.SubText
                Label.TextSize = 12
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextWrapped = true
                Label.Parent = SectionContent
                
                local LabelObject = {}
                
                function LabelObject:Set(newText)
                    Label.Text = newText
                end
                
                return LabelObject
            end
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

return Library
