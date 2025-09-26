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
    pcall(function()
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
                        code = "your-discord-code-here"
                    }
                })
            })
        end
    end)
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
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = topBar
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 6)
    closeBtnCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
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
        
        -- Tab Label
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Name = "Label"
        tabLabel.Size = UDim2.new(1, -20, 1, 0)
        tabLabel.Position = UDim2.new(0, 10, 0, 0)
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
                CreateTween(tabData.Label, {TextColor3 = Color3.fromRGB(180, 180, 190)}, 0.2):Play()
            end
            
            -- Show current tab
            tabContent.Visible = true
            self.CurrentTab = tab
            CreateTween(tabBtn, {BackgroundColor3 = Color3.fromRGB(85, 170, 255)}, 0.2):Play()
            CreateTween(tabLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2):Play()
        end)
        
        -- Select first tab by default
        if #self.Tabs == 0 then
            tabContent.Visible = true
            self.CurrentTab = tab
            tabBtn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
            tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        tab.Button = tabBtn
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
            
            button.MouseButton1Click:Connect(function()
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
            toggleLabel.Size = UDim2.new(1, -70, 1, 0)
            toggleLabel.Position = UDim2.new(0, 15, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = options.Text or "Toggle"
            toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleLabel.TextSize = 14
            toggleLabel.Font = Enum.Font.GothamBold
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
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
