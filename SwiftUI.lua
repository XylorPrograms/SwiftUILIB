local SwiftUI = {}
SwiftUI.__index = SwiftUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Auto Discord Join Function
local function AutoJoinDiscord()
    if syn and syn.request then
        syn.request({
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Origin"] = "https://discord.com"
            },
            Body = HttpService:JSONEncode({
                cmd = "INVITE_BROWSER",
                nonce = HttpService:GenerateGUID(false),
                args = {
                    code = "your-discord-code-here" -- Replace with your Discord invite code
                }
            })
        })
    end
end

-- Utility Functions
local function CreateTween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function RippleEffect(button, clickPos)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, clickPos.X - button.AbsolutePosition.X, 0, clickPos.Y - button.AbsolutePosition.Y)
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    local expandTween = CreateTween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0, clickPos.X - button.AbsolutePosition.X - maxSize/2, 0, clickPos.Y - button.AbsolutePosition.Y - maxSize/2),
        BackgroundTransparency = 1
    }, 0.6)
    
    expandTween:Play()
    expandTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Main Library Functions
function SwiftUI:CreateWindow(options)
    local window = {}
    options = options or {}
    
    -- Auto join Discord
    AutoJoinDiscord()
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SwiftUI"
    screenGui.Parent = CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 700, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    mainFrame.ClipsDescendants = true
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame
    
    -- Drop Shadow Effect
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = -1
    shadow.Parent = mainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow
    
    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 50)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 8)
    topCorner.Parent = topBar
    
    -- Fix bottom corners of top bar
    local topBarFix = Instance.new("Frame")
    topBarFix.Size = UDim2.new(1, 0, 0, 8)
    topBarFix.Position = UDim2.new(0, 0, 1, -8)
    topBarFix.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    topBarFix.BorderSizePixel = 0
    topBarFix.Parent = topBar
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = options.Name or "SwiftUI"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -45, 0, 7.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = topBar
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 6)
    closeBtnCorner.Parent = closeBtn
    
    closeBtn.MouseEnter:Connect(function()
        CreateTween(closeBtn, {BackgroundColor3 = Color3.fromRGB(255, 105, 105)}, 0.2):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        CreateTween(closeBtn, {BackgroundColor3 = Color3.fromRGB(255, 85, 85)}, 0.2):Play()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        local closeTween = CreateTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        closeTween:Play()
        closeTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 180, 1, -50)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    local tabScrollFrame = Instance.new("ScrollingFrame")
    tabScrollFrame.Name = "TabScrollFrame"
    tabScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    tabScrollFrame.BackgroundTransparency = 1
    tabScrollFrame.BorderSizePixel = 0
    tabScrollFrame.ScrollBarThickness = 4
    tabScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    tabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    tabScrollFrame.Parent = tabContainer
    
    local tabList = Instance.new("UIListLayout")
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 6)
    tabList.Parent = tabScrollFrame
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 15)
    tabPadding.PaddingLeft = UDim.new(0, 15)
    tabPadding.PaddingRight = UDim.new(0, 15)
    tabPadding.PaddingBottom = UDim.new(0, 15)
    tabPadding.Parent = tabScrollFrame
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -180, 1, -50)
    contentContainer.Position = UDim2.new(0, 180, 0, 50)
    contentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = mainFrame
    
    -- Make draggable
    local dragging = false
    local dragStart, startPos
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Entrance Animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    local entranceTween = CreateTween(mainFrame, {Size = UDim2.new(0, 700, 0, 450)}, 0.5, Enum.EasingStyle.Back)
    entranceTween:Play()
    
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.TabContainer = tabScrollFrame
    window.ContentContainer = contentContainer
    window.CurrentTab = nil
    window.Tabs = {}
    
    function window:CreateTab(options)
        local tab = {}
        options = options or {}
        
        -- Tab Button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = options.Name or "Tab"
        tabBtn.Size = UDim2.new(1, 0, 0, 42)
        tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = ""
        tabBtn.Parent = self.TabContainer
        
        local tabBtnCorner = Instance.new("UICorner")
        tabBtnCorner.CornerRadius = UDim.new(0, 6)
        tabBtnCorner.Parent = tabBtn
        
        -- Tab Icon (Optional)
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Name = "Icon"
        tabIcon.Size = UDim2.new(0, 20, 0, 20)
        tabIcon.Position = UDim2.new(0, 12, 0.5, -10)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text = options.Icon or "●"
        tabIcon.TextColor3 = Color3.fromRGB(120, 120, 130)
        tabIcon.TextSize = 16
        tabIcon.Font = Enum.Font.GothamBold
        tabIcon.TextXAlignment = Enum.TextXAlignment.Center
        tabIcon.Parent = tabBtn
        
        -- Tab Label
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Name = "Label"
        tabLabel.Size = UDim2.new(1, -40, 1, 0)
        tabLabel.Position = UDim2.new(0, 35, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = options.Name or "Tab"
        tabLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
        tabLabel.TextSize = 14
        tabLabel.Font = Enum.Font.Gotham
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Parent = tabBtn
        
        -- Tab Content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = options.Name or "TabContent"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 6
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.ScrollingDirection = Enum.ScrollingDirection.Y
        tabContent.Visible = false
        tabContent.Parent = self.ContentContainer
        
        local contentList = Instance.new("UIListLayout")
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 12)
        contentList.Parent = tabContent
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 20)
        contentPadding.PaddingLeft = UDim.new(0, 20)
        contentPadding.PaddingRight = UDim.new(0, 20)
        contentPadding.PaddingBottom = UDim.new(0, 20)
        contentPadding.Parent = tabContent
        
        -- Tab Selection
        tabBtn.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tabData in pairs(self.Tabs) do
                tabData.Content.Visible = false
                CreateTween(tabData.Button, {BackgroundColor3 = Color3.fromRGB(22, 22, 27)}, 0.2):Play()
                CreateTween(tabData.Icon, {TextColor3 = Color3.fromRGB(120, 120, 130)}, 0.2):Play()
                CreateTween(tabData.Label, {TextColor3 = Color3.fromRGB(180, 180, 190)}, 0.2):Play()
            end
            
            -- Show current tab
            tabContent.Visible = true
            self.CurrentTab = tab
            CreateTween(tabBtn, {BackgroundColor3 = Color3.fromRGB(85, 170, 255)}, 0.2):Play()
            CreateTween(tabIcon, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2):Play()
            CreateTween(tabLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2):Play()
        end)
        
        -- Hover effects
        tabBtn.MouseEnter:Connect(function()
            if self.CurrentTab ~= tab then
                CreateTween(tabBtn, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2):Play()
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if self.CurrentTab ~= tab then
                CreateTween(tabBtn, {BackgroundColor3 = Color3.fromRGB(22, 22, 27)}, 0.2):Play()
            end
        end)
        
        -- Select first tab by default
        if #self.Tabs == 0 then
            tabContent.Visible = true
            self.CurrentTab = tab
            tabBtn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
            tabIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        tab.Button = tabBtn
        tab.Icon = tabIcon
        tab.Label = tabLabel
        tab.Content = tabContent
        tab.Window = self
        
        table.insert(self.Tabs, tab)
        
        -- Tab Methods
        function tab:CreateButton(options)
            options = options or {}
            
            local buttonFrame = Instance.new("Frame")
            buttonFrame.Name = options.Name or "Button"
            buttonFrame.Size = UDim2.new(1, 0, 0, 45)
            buttonFrame.BackgroundTransparency = 1
            buttonFrame.Parent = self.Content
            
            local button = Instance.new("TextButton")
            button.Name = "ButtonElement"
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
            button.BorderSizePixel = 0
            button.Text = options.Text or "Button"
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.GothamBold
            button.ClipsDescendants = true
            button.Parent = buttonFrame
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 6)
            buttonCorner.Parent = button
            
            -- Hover Effects
            button.MouseEnter:Connect(function()
                CreateTween(button, {BackgroundColor3 = Color3.fromRGB(105, 190, 255)}, 0.2):Play()
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(button, {BackgroundColor3 = Color3.fromRGB(85, 170, 255)}, 0.2):Play()
            end)
            
            -- Click Effect
            button.MouseButton1Click:Connect(function()
                RippleEffect(button, Mouse.Hit.Position)
                if options.Callback then
                    options.Callback()
                end
            end)
            
            return button
        end
        
        function tab:CreateToggle(options)
            options = options or {}
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = options.Name or "Toggle"
            toggleFrame.Size = UDim2.new(1, 0, 0, 50)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Parent = self.Content
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 8)
            toggleCorner.Parent = toggleFrame
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Name = "Label"
            toggleLabel.Size = UDim2.new(1, -70, 1, -20)
            toggleLabel.Position = UDim2.new(0, 15, 0, 10)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = options.Text or "Toggle"
            toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleLabel.TextSize = 14
            toggleLabel.Font = Enum.Font.GothamBold
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.TextYAlignment = Enum.TextYAlignment.Top
            toggleLabel.Parent = toggleFrame
            
            local toggleDesc = Instance.new("TextLabel")
            toggleDesc.Name = "Description"
            toggleDesc.Size = UDim2.new(1, -70, 0, 15)
            toggleDesc.Position = UDim2.new(0, 15, 0, 28)
            toggleDesc.BackgroundTransparency = 1
            toggleDesc.Text = options.Description or ""
            toggleDesc.TextColor3 = Color3.fromRGB(150, 150, 160)
            toggleDesc.TextSize = 12
            toggleDesc.Font = Enum.Font.Gotham
            toggleDesc.TextXAlignment = Enum.TextXAlignment.Left
            toggleDesc.Parent = toggleFrame
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Name = "ToggleButton"
            toggleButton.Size = UDim2.new(0, 48, 0, 24)
            toggleButton.Position = UDim2.new(1, -60, 0.5, -12)
            toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            toggleButton.BorderSizePixel = 0
            toggleButton.Text = ""
            toggleButton.Parent = toggleFrame
            
            local toggleBtnCorner = Instance.new("UICorner")
            toggleBtnCorner.CornerRadius = UDim.new(0, 12)
            toggleBtnCorner.Parent = toggleButton
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Name = "Circle"
            toggleCircle.Size = UDim2.new(0, 20, 0, 20)
            toggleCircle.Position = UDim2.new(0, 2, 0, 2)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleCircle.BorderSizePixel = 0
            toggleCircle.Parent = toggleButton
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(0, 10)
            circleCorner.Parent = toggleCircle
            
            local toggled = options.Default or false
            
            local function updateToggle()
                if toggled then
                    CreateTween(toggleButton, {BackgroundColor3 = Color3.fromRGB(85, 170, 255)}, 0.3):Play()
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 26, 0, 2)}, 0.3):Play()
                else
                    CreateTween(toggleButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}, 0.3):Play()
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 2, 0, 2)}, 0.3):Play()
                end
                
                if options.Callback then
                    options.Callback(toggled)
                end
            end
            
            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)
            
            -- Initialize
            updateToggle()
            
            return {
                Frame = toggleFrame,
                SetValue = function(value)
                    toggled = value
                    updateToggle()
                end,
                GetValue = function()
                    return toggled
                end
            }
        end
        
        function tab:CreateDropdown(options)
            options = options or {}
            
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Name = options.Name or "Dropdown"
            dropdownFrame.Size = UDim2.new(1, 0, 0, 50)
            dropdownFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.ClipsDescendants = false
            dropdownFrame.Parent = self.Content
            
            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, 8)
            dropdownCorner.Parent = dropdownFrame
            
            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Name = "DropdownButton"
            dropdownBtn.Size = UDim2.new(1, 0, 0, 50)
            dropdownBtn.BackgroundTransparency = 1
            dropdownBtn.Text = ""
            dropdownBtn.Parent = dropdownFrame
            
            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.Name = "Label"
            dropdownLabel.Size = UDim2.new(1, -50, 0, 20)
            dropdownLabel.Position = UDim2.new(0, 15, 0, 8)
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Text = options.Text or "Dropdown"
            dropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropdownLabel.TextSize = 14
            dropdownLabel.Font = Enum.Font.GothamBold
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Parent = dropdownFrame
            
            local dropdownValue = Instance.new("TextLabel")
            dropdownValue.Name = "Value"
            dropdownValue.Size = UDim2.new(1, -50, 0, 15)
            dropdownValue.Position = UDim2.new(0, 15, 0, 28)
            dropdownValue.BackgroundTransparency = 1
            dropdownValue.Text = options.Default or "Select..."
            dropdownValue.TextColor3 = Color3.fromRGB(150, 150, 160)
            dropdownValue.TextSize = 12
            dropdownValue.Font = Enum.Font.Gotham
            dropdownValue.TextXAlignment = Enum.TextXAlignment.Left
            dropdownValue.Parent = dropdownFrame
            
            local dropdownArrow = Instance.new("TextLabel")
            dropdownArrow.Name = "Arrow"
            dropdownArrow.Size = UDim2.new(0, 20, 0, 20)
            dropdownArrow.Position = UDim2.new(1, -35, 0.5, -10)
            dropdownArrow.BackgroundTransparency = 1
            dropdownArrow.Text = "▼"
            dropdownArrow.TextColor3 = Color3.fromRGB(150, 150, 160)
            dropdownArrow.TextSize = 12
            dropdownArrow.Font = Enum.Font.Gotham
            dropdownArrow.TextXAlignment = Enum.TextXAlignment.Center
            dropdownArrow.Parent = dropdownFrame
            
            local dropdownList = Instance.new("Frame")
            dropdownList.Name = "DropdownList"
            dropdownList.Size = UDim2.new(1, 0, 0, 0)
            dropdownList.Position = UDim2.new(0, 0, 0, 55)
            dropdownList.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
            dropdownList.BorderSizePixel = 0
            dropdownList.ClipsDescendants = true
            dropdownList.Visible = false
            dropdownList.ZIndex = 10
            dropdownList.Parent = dropdownFrame
            
            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 8)
            listCorner.Parent = dropdownList
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Parent = dropdownList
            
            local isOpen = false
            local selectedOption = options.Default or ""
            
            local function createOption(optionText)
                local optionBtn = Instance.new("TextButton")
                optionBtn.Name = optionText
                optionBtn.Size = UDim2.new(1, 0, 0, 35)
                optionBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
                optionBtn.BorderSizePixel = 0
                optionBtn.Text = optionText
                optionBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                optionBtn.TextSize = 13
                optionBtn.Font = Enum.Font.Gotham
                optionBtn.TextXAlignment = Enum.TextXAlignment.Left
                optionBtn.Parent = dropdownList
                
                local optionPadding = Instance.new("UIPadding")
                optionPadding.PaddingLeft = UDim.new(0, 15)
                optionPadding.Parent = optionBtn
                
                optionBtn.MouseEnter:Connect(function()
                    CreateTween(optionBtn, {BackgroundColor3 = Color3.fromRGB(32, 32, 37)}, 0.2):Play()
                end)
                
                optionBtn.MouseLeave:Connect(function()
                    CreateTween(optionBtn, {BackgroundColor3 = Color3.fromRGB(22, 22, 27)}, 0.2):Play()
                end)
                
                optionBtn.MouseButton1Click:Connect(function()
                    selectedOption = optionText
                    dropdownValue.Text = selectedOption
                    
                    -- Close dropdown
                    isOpen = false
                    CreateTween(dropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3):Play()
                    CreateTween(dropdownArrow, {Rotation = 0}, 0.3):Play()
                    wait(0.3)
                    dropdownList.Visible = false
                    dropdownFrame.Size = UDim2.new(1, 0, 0, 50)
                    
                    if options.Callback then
                        options.Callback(selectedOption)
                    end
                end)
            end
            
            -- Create options
            if options.Options then
                for _, option in ipairs(options.Options) do
                    createOption(option)
                end
            end
            
            dropdownBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    local listHeight = #dropdownList:GetChildren() * 35 - 35 -- Subtract UIListLayout
                    dropdownList.Visible = true
                    dropdownFrame.Size = UDim2.new(1, 0, 0, 50 + listHeight + 5)
                    CreateTween(dropdownList, {Size = UDim2.new(1, 0, 0, listHeight)}, 0.3):Play()
                    CreateTween(dropdownArrow, {Rotation = 180}, 0.3):Play()
                else
                    CreateTween(dropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3):Play()
                    CreateTween(dropdownArrow, {Rotation = 0}, 0.3):Play()
                    wait(0.3)
                    dropdownList.Visible = false
                    dropdownFrame.Size = UDim2.new(1, 0, 0, 50)
                end
            end)
            
            return {
                Frame = dropdownFrame,
                SetValue = function(value)
                    selectedOption = value
                    dropdownValue.Text = selectedOption
                end,
                GetValue = function()
                    return selectedOption
                end
            }
        end
        
        function tab:CreateMultiDropdown(options)
            options = options or {}
            
            local multiDropdownFrame = Instance.new("Frame")
            multiDropdownFrame.Name = options.Name or "MultiDropdown"
            multiDropdownFrame.Size = UDim2.new(1, 0, 0, 50)
            multiDropdownFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
            multiDropdownFrame.BorderSizePixel = 0
            multiDropdownFrame.ClipsDescendants = false
            multiDropdownFrame.Parent = self.Content
            
            local multiDropdownCorner = Instance.new("UICorner")
            multiDropdownCorner.CornerRadius = UDim.new(0, 8)
            multiDropdownCorner.Parent = multiDropdownFrame
            
            local multiDropdownBtn = Instance.new("TextButton")
            multiDropdownBtn.Name = "MultiDropdownButton"
            multiDropdownBtn.Size = UDim2.new(1, 0, 0, 50)
            multiDropdownBtn.BackgroundTransparency = 1
            multiDropdownBtn.Text = ""
            multiDropdownBtn.Parent = multiDropdownFrame
            
            local multiDropdownLabel = Instance.new("TextLabel")
            multiDropdownLabel.Name = "Label"
            multiDropdownLabel.Size = UDim2.new(1, -50, 0, 20)
            multiDropdownLabel.Position = UDim2.new(0, 15, 0, 8)
            multiDropdownLabel.BackgroundTransparency = 1
            multiDropdownLabel.Text = options.Text or "Multi Dropdown"
            multiDropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            multiDropdownLabel.TextSize = 14
            multiDropdownLabel.Font = Enum.Font.GothamBold
            multiDropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            multiDropdownLabel.Parent = multiDropdownFrame
            
            local multiDropdownValue = Instance.new("TextLabel")
            multiDropdownValue.Name = "Value"
            multiDropdownValue.Size = UDim2.new(1, -50, 0, 15)
            multiDropdownValue.Position = UDim2.new(0, 15, 0, 28)
            multiDropdownValue.BackgroundTransparency = 1
            multiDropdownValue.Text = "None selected"
            multiDropdownValue.TextColor3 = Color3.fromRGB(150, 150, 160)
            multiDropdownValue.TextSize = 12
            multiDropdownValue.Font = Enum.Font.Gotham
            multiDropdownValue.TextXAlignment = Enum.TextXAlignment.Left
            multiDropdownValue.Parent = multiDropdownFrame
            
            local multiDropdownArrow = Instance.new("TextLabel")
            multiDropdownArrow.Name = "Arrow"
            multiDropdownArrow.Size = UDim2.new(0, 20, 0, 20)
            multiDropdownArrow.Position = UDim2.new(1, -35, 0.5, -10)
            multiDropdownArrow.BackgroundTransparency = 1
            multiDropdownArrow.Text = "▼"
            multiDropdownArrow.TextColor3 = Color3.fromRGB(150, 150, 160)
            multiDropdownArrow.TextSize = 12
            multiDropdownArrow.Font = Enum.Font.Gotham
            multiDropdownArrow.TextXAlignment = Enum.TextXAlignment.Center
            multiDropdownArrow.Parent = multiDropdownFrame
            
            local multiDropdownList = Instance.new("Frame")
            multiDropdownList.Name = "MultiDropdownList"
            multiDropdownList.Size = UDim2.new(1, 0, 0, 0)
            multiDropdownList.Position = UDim2.new(0, 0, 0, 55)
            multiDropdownList.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
            multiDropdownList.BorderSizePixel = 0
            multiDropdownList.ClipsDescendants = true
            multiDropdownList.Visible = false
            multiDropdownList.ZIndex = 10
            multiDropdownList.Parent = multiDropdownFrame
            
            local multiListCorner = Instance.new("UICorner")
            multiListCorner.CornerRadius = UDim.new(0, 8)
            multiListCorner.Parent = multiDropdownList
            
            local multiListLayout = Instance.new("UIListLayout")
            multiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            multiListLayout.Parent = multiDropdownList
            
            local isMultiOpen = false
            local selectedOptions = {}
            
            local function updateMultiLabel()
                local selectedText = ""
                local count = 0
                for option, selected in pairs(selectedOptions) do
                    if selected then
                        count = count + 1
                        if selectedText == "" then
                            selectedText = option
                        end
                    end
                end
                
                if count == 0 then
                    selectedText = "None selected"
                elseif count > 1 then
                    selectedText = selectedText .. " (+" .. (count - 1) .. " more)"
                end
                
                multiDropdownValue.Text = selectedText
            end
            
            local function createMultiOption(optionText)
                local optionFrame = Instance.new("Frame")
                optionFrame.Name = optionText
                optionFrame.Size = UDim2.new(1, 0, 0, 40)
                optionFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
                optionFrame.BorderSizePixel = 0
                optionFrame.Parent = multiDropdownList
                
                local optionBtn = Instance.new("TextButton")
                optionBtn.Name = "Button"
                optionBtn.Size = UDim2.new(1, -35, 1, 0)
                optionBtn.Position = UDim2.new(0, 15, 0, 0)
                optionBtn.BackgroundTransparency = 1
                optionBtn.Text = optionText
                optionBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                optionBtn.TextSize = 13
                optionBtn.Font = Enum.Font.Gotham
                optionBtn.TextXAlignment = Enum.TextXAlignment.Left
                optionBtn.Parent = optionFrame
                
                local checkBox = Instance.new("Frame")
                checkBox.Name = "CheckBox"
                checkBox.Size = UDim2.new(0, 18, 0, 18)
                checkBox.Position = UDim2.new(1, -25, 0.5, -9)
                checkBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                checkBox.BorderSizePixel = 0
                checkBox.Parent = optionFrame
                
                local checkCorner = Instance.new("UICorner")
                checkCorner.CornerRadius = UDim.new(0, 4)
                checkCorner.Parent = checkBox
                
                local checkMark = Instance.new("TextLabel")
                checkMark.Name = "CheckMark"
                checkMark.Size = UDim2.new(1, 0, 1, 0)
                checkMark.BackgroundTransparency = 1
                checkMark.Text = "✓"
                checkMark.TextColor3 = Color3.fromRGB(255, 255, 255)
                checkMark.TextSize = 12
                checkMark.Font = Enum.Font.GothamBold
                checkMark.TextXAlignment = Enum.TextXAlignment.Center
                checkMark.TextYAlignment = Enum.TextYAlignment.Center
                checkMark.Visible = false
                checkMark.Parent = checkBox
                
                selectedOptions[optionText] = false
                
                local function updateCheckBox()
                    if selectedOptions[optionText] then
                        CreateTween(checkBox, {BackgroundColor3 = Color3.fromRGB(85, 170, 255)}, 0.2):Play()
                        checkMark.Visible = true
                    else
                        CreateTween(checkBox, {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}, 0.2):Play()
                        checkMark.Visible = false
                    end
                    updateMultiLabel()
                end
                
                optionFrame.MouseEnter:Connect(function()
                    CreateTween(optionFrame, {BackgroundColor3 = Color3.fromRGB(32, 32, 37)}, 0.2):Play()
                end)
                
                optionFrame.MouseLeave:Connect(function()
                    CreateTween(optionFrame, {BackgroundColor3 = Color3.fromRGB(22, 22, 27)}, 0.2):Play()
                end)
                
                optionBtn.MouseButton1Click:Connect(function()
                    selectedOptions[optionText] = not selectedOptions[optionText]
                    updateCheckBox()
                    
                    if options.Callback then
                        options.Callback(selectedOptions)
                    end
                end)
                
                updateCheckBox()
            end
            
            -- Create options
            if options.Options then
                for _, option in ipairs(options.Options) do
                    createMultiOption(option)
                end
            end
            
            multiDropdownBtn.MouseButton1Click:Connect(function()
                isMultiOpen = not isMultiOpen
                
                if isMultiOpen then
                    local listHeight = #multiDropdownList:GetChildren() * 40 - 40 -- Subtract UIListLayout
                    multiDropdownList.Visible = true
                    multiDropdownFrame.Size = UDim2.new(1, 0, 0, 50 + listHeight + 5)
                    CreateTween(multiDropdownList, {Size = UDim2.new(1, 0, 0, listHeight)}, 0.3):Play()
                    CreateTween(multiDropdownArrow, {Rotation = 180}, 0.3):Play()
                else
                    CreateTween(multiDropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3):Play()
                    CreateTween(multiDropdownArrow, {Rotation = 0}, 0.3):Play()
                    wait(0.3)
                    multiDropdownList.Visible = false
                    multiDropdownFrame.Size = UDim2.new(1, 0, 0, 50)
                end
            end)
            
            updateMultiLabel()
            
            return {
                Frame = multiDropdownFrame,
                SetValues = function(values)
                    for option, _ in pairs(selectedOptions) do
                        selectedOptions[option] = false
                    end
                    for _, value in ipairs(values) do
                        if selectedOptions[value] ~= nil then
                            selectedOptions[value] = true
                        end
                    end
                    updateMultiLabel()
                    -- Update visual checkboxes
                    for _, child in ipairs(multiDropdownList:GetChildren()) do
                        if child:IsA("Frame") and child.Name ~= "UIListLayout" then
                            local checkBox = child:FindFirstChild("CheckBox")
                            local checkMark = checkBox:FindFirstChild("CheckMark")
                            if selectedOptions[child.Name] then
                                checkBox.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
                                checkMark.Visible = true
                            else
                                checkBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                                checkMark.Visible = false
                            end
                        end
                    end
                end,
                GetValues = function()
                    local selected = {}
                    for option, isSelected in pairs(selectedOptions) do
                        if isSelected then
                            table.insert(selected, option)
                        end
                    end
                    return selected
                end
            }
        end
        
        function tab:CreateLabel(options)
            options = options or {}
            
            local labelFrame = Instance.new("Frame")
            labelFrame.Name = options.Name or "Label"
            labelFrame.Size = UDim2.new(1, 0, 0, 25)
            labelFrame.BackgroundTransparency = 1
            labelFrame.Parent = self.Content
            
            local label = Instance.new("TextLabel")
            label.Name = "LabelText"
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = options.Text or "Label"
            label.TextColor3 = options.Color or Color3.fromRGB(255, 255, 255)
            label.TextSize = options.Size or 14
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = labelFrame
            
            return {
                Frame = labelFrame,
                SetText = function(text)
                    label.Text = text
                end,
                SetColor = function(color)
                    label.TextColor3 = color
                end
            }
        end
        
        return tab
    end
    
    return window
end

-- Return the library
return SwiftUI
