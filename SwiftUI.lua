-- Clean UI Library for Roblox
-- Designed for smooth animations and modern aesthetics
-- Compatible with executors for testing

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Library Configuration
local UILibrary = {
    Version = "1.0.0",
    Theme = {
        Primary = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(100, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Success = Color3.fromRGB(50, 200, 100),
        Warning = Color3.fromRGB(255, 200, 50),
        Error = Color3.fromRGB(255, 100, 100),
        Shadow = Color3.fromRGB(0, 0, 0),
        Transparent = Color3.fromRGB(0, 0, 0)
    },
    Animations = {
        Duration = 0.3,
        EasingStyle = Enum.EasingStyle.Quart,
        EasingDirection = Enum.EasingDirection.Out
    }
}

-- Utility Functions
local function createTween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or UILibrary.Animations.Duration,
        easingStyle or UILibrary.Animations.EasingStyle,
        easingDirection or UILibrary.Animations.EasingDirection
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function addCorners(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function addStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or UILibrary.Theme.Accent
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

local function addShadow(parent, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = UILibrary.Theme.Shadow
    shadow.ImageTransparency = transparency or 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, size or 20, 1, size or 20)
    shadow.Position = UDim2.new(0, -(size or 20)/2, 0, -(size or 20)/2)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    return shadow
end

-- Main Library Object
local Library = {}

function Library:CreateWindow(title, subtitle)
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CleanUILibrary"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    -- Main Window Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.BackgroundColor3 = UILibrary.Theme.Primary
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    mainFrame.Size = UDim2.new(0, 600, 0, 500)
    mainFrame.Parent = screenGui
    
    addCorners(mainFrame, 12)
    addShadow(mainFrame, 30, 0.7)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = UILibrary.Theme.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.Parent = mainFrame
    
    addCorners(titleBar, 12)
    
    -- Title Bar Bottom Corner Fix
    local titleBarFix = Instance.new("Frame")
    titleBarFix.BackgroundColor3 = UILibrary.Theme.Secondary
    titleBarFix.BorderSizePixel = 0
    titleBarFix.Position = UDim2.new(0, 0, 1, -12)
    titleBarFix.Size = UDim2.new(1, 0, 0, 12)
    titleBarFix.Parent = titleBar
    
    -- Title Text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.Size = UDim2.new(1, -30, 0.6, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title or "UI Library"
    titleLabel.TextColor3 = UILibrary.Theme.Text
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Subtitle Text
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Name = "Subtitle"
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Position = UDim2.new(0, 15, 0.6, 0)
    subtitleLabel.Size = UDim2.new(1, -30, 0.4, 0)
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.Text = subtitle or "Modern UI Framework"
    subtitleLabel.TextColor3 = UILibrary.Theme.TextSecondary
    subtitleLabel.TextSize = 12
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.Parent = titleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.BackgroundColor3 = UILibrary.Theme.Error
    closeButton.BorderSizePixel = 0
    closeButton.Position = UDim2.new(1, -35, 0, 10)
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "×"
    closeButton.TextColor3 = UILibrary.Theme.Text
    closeButton.TextSize = 16
    closeButton.Parent = titleBar
    
    addCorners(closeButton, 6)
    
    -- Content Area
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "Content"
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.Size = UDim2.new(1, -20, 1, -70)
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = UILibrary.Theme.Accent
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.Parent = mainFrame
    
    -- Content Layout
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = contentFrame
    
    -- Auto-resize content
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
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
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        local tween = createTween(mainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.3)
        tween:Play()
        tween.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
    
    -- Entrance animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local entranceTween = createTween(mainFrame, {
        Size = UDim2.new(0, 600, 0, 500),
        Position = UDim2.new(0.5, -300, 0.5, -250)
    }, 0.5, Enum.EasingStyle.Back)
    
    wait(0.1)
    entranceTween:Play()
    
    -- Window object
    local Window = {
        Frame = mainFrame,
        Content = contentFrame,
        ScreenGui = screenGui
    }
    
    function Window:CreateButton(text, callback)
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.BackgroundColor3 = UILibrary.Theme.Secondary
        button.BorderSizePixel = 0
        button.Size = UDim2.new(1, 0, 0, 40)
        button.Font = Enum.Font.Gotham
        button.Text = text or "Button"
        button.TextColor3 = UILibrary.Theme.Text
        button.TextSize = 14
        button.Parent = contentFrame
        
        addCorners(button, 8)
        
        -- Hover effects
        button.MouseEnter:Connect(function()
            createTween(button, {BackgroundColor3 = UILibrary.Theme.Accent}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            createTween(button, {BackgroundColor3 = UILibrary.Theme.Secondary}):Play()
        end)
        
        -- Click effect
        button.MouseButton1Click:Connect(function()
            local originalSize = button.Size
            createTween(button, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, originalSize.Y.Scale, originalSize.Y.Offset - 4)}, 0.1):Play()
            wait(0.1)
            createTween(button, {Size = originalSize}, 0.1):Play()
            
            if callback then
                callback()
            end
        end)
        
        return button
    end
    
    function Window:CreateToggle(text, default, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "ToggleFrame"
        toggleFrame.BackgroundColor3 = UILibrary.Theme.Secondary
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Size = UDim2.new(1, 0, 0, 40)
        toggleFrame.Parent = contentFrame
        
        addCorners(toggleFrame, 8)
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Position = UDim2.new(0, 12, 0, 0)
        toggleLabel.Size = UDim2.new(1, -60, 1, 0)
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.Text = text or "Toggle"
        toggleLabel.TextColor3 = UILibrary.Theme.Text
        toggleLabel.TextSize = 14
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "ToggleButton"
        toggleButton.BackgroundColor3 = default and UILibrary.Theme.Accent or UILibrary.Theme.Primary
        toggleButton.BorderSizePixel = 0
        toggleButton.Position = UDim2.new(1, -35, 0.5, -8)
        toggleButton.Size = UDim2.new(0, 30, 0, 16)
        toggleButton.Text = ""
        toggleButton.Parent = toggleFrame
        
        addCorners(toggleButton, 8)
        
        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Name = "Indicator"
        toggleIndicator.BackgroundColor3 = UILibrary.Theme.Text
        toggleIndicator.BorderSizePixel = 0
        toggleIndicator.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        toggleIndicator.Size = UDim2.new(0, 12, 0, 12)
        toggleIndicator.Parent = toggleButton
        
        addCorners(toggleIndicator, 6)
        
        local toggled = default or false
        
        toggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            createTween(toggleButton, {
                BackgroundColor3 = toggled and UILibrary.Theme.Accent or UILibrary.Theme.Primary
            }):Play()
            
            createTween(toggleIndicator, {
                Position = toggled and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            }):Play()
            
            if callback then
                callback(toggled)
            end
        end)
        
        return {Frame = toggleFrame, Value = function() return toggled end}
    end
    
    function Window:CreateSlider(text, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "SliderFrame"
        sliderFrame.BackgroundColor3 = UILibrary.Theme.Secondary
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.Parent = contentFrame
        
        addCorners(sliderFrame, 8)
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Position = UDim2.new(0, 12, 0, 0)
        sliderLabel.Size = UDim2.new(1, -24, 0, 25)
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.Text = text or "Slider"
        sliderLabel.TextColor3 = UILibrary.Theme.Text
        sliderLabel.TextSize = 14
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        local sliderTrack = Instance.new("Frame")
        sliderTrack.Name = "Track"
        sliderTrack.BackgroundColor3 = UILibrary.Theme.Primary
        sliderTrack.BorderSizePixel = 0
        sliderTrack.Position = UDim2.new(0, 12, 0, 30)
        sliderTrack.Size = UDim2.new(1, -24, 0, 6)
        sliderTrack.Parent = sliderFrame
        
        addCorners(sliderTrack, 3)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "Fill"
        sliderFill.BackgroundColor3 = UILibrary.Theme.Accent
        sliderFill.BorderSizePixel = 0
        sliderFill.Size = UDim2.new(0, 0, 1, 0)
        sliderFill.Parent = sliderTrack
        
        addCorners(sliderFill, 3)
        
        local sliderKnob = Instance.new("TextButton")
        sliderKnob.Name = "Knob"
        sliderKnob.BackgroundColor3 = UILibrary.Theme.Text
        sliderKnob.BorderSizePixel = 0
        sliderKnob.Position = UDim2.new(0, -6, 0.5, -6)
        sliderKnob.Size = UDim2.new(0, 12, 0, 12)
        sliderKnob.Text = ""
        sliderKnob.Parent = sliderTrack
        
        addCorners(sliderKnob, 6)
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.BackgroundTransparency = 1
        valueLabel.Position = UDim2.new(1, -60, 0, 0)
        valueLabel.Size = UDim2.new(0, 48, 0, 25)
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.TextColor3 = UILibrary.Theme.TextSecondary
        valueLabel.TextSize = 12
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = sliderFrame
        
        local value = default or min or 0
        local dragging = false
        
        local function updateSlider(inputX)
            local trackX = sliderTrack.AbsolutePosition.X
            local trackWidth = sliderTrack.AbsoluteSize.X
            local relativeX = math.clamp((inputX - trackX) / trackWidth, 0, 1)
            
            value = math.floor(min + (max - min) * relativeX)
            valueLabel.Text = tostring(value)
            
            createTween(sliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1):Play()
            createTween(sliderKnob, {Position = UDim2.new(relativeX, -6, 0.5, -6)}, 0.1):Play()
            
            if callback then
                callback(value)
            end
        end
        
        -- Initialize slider
        local initialRatio = (value - min) / (max - min)
        sliderFill.Size = UDim2.new(initialRatio, 0, 1, 0)
        sliderKnob.Position = UDim2.new(initialRatio, -6, 0.5, -6)
        valueLabel.Text = tostring(value)
        
        sliderKnob.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                updateSlider(input.Position.X)
            end
        end)
        
        sliderTrack.MouseButton1Down:Connect(function()
            updateSlider(UserInputService:GetMouseLocation().X)
        end)
        
        return {Frame = sliderFrame, GetValue = function() return value end}
    end
    
    function Window:CreateTextBox(placeholder, callback)
        local textBoxFrame = Instance.new("Frame")
        textBoxFrame.Name = "TextBoxFrame"
        textBoxFrame.BackgroundColor3 = UILibrary.Theme.Secondary
        textBoxFrame.BorderSizePixel = 0
        textBoxFrame.Size = UDim2.new(1, 0, 0, 40)
        textBoxFrame.Parent = contentFrame
        
        addCorners(textBoxFrame, 8)
        addStroke(textBoxFrame, UILibrary.Theme.Primary, 2)
        
        local textBox = Instance.new("TextBox")
        textBox.BackgroundTransparency = 1
        textBox.Position = UDim2.new(0, 12, 0, 0)
        textBox.Size = UDim2.new(1, -24, 1, 0)
        textBox.Font = Enum.Font.Gotham
        textBox.PlaceholderText = placeholder or "Enter text..."
        textBox.Text = ""
        textBox.TextColor3 = UILibrary.Theme.Text
        textBox.TextSize = 14
        textBox.TextXAlignment = Enum.TextXAlignment.Left
        textBox.Parent = textBoxFrame
        
        local stroke = textBoxFrame:FindFirstChild("UIStroke")
        
        textBox.Focused:Connect(function()
            createTween(stroke, {Color = UILibrary.Theme.Accent}):Play()
        end)
        
        textBox.FocusLost:Connect(function()
            createTween(stroke, {Color = UILibrary.Theme.Primary}):Play()
            if callback then
                callback(textBox.Text)
            end
        end)
        
        return textBox
    end
    
    function Window:CreateLabel(text)
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Font = Enum.Font.Gotham
        label.Text = text or "Label"
        label.TextColor3 = UILibrary.Theme.Text
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = contentFrame
        
        return label
    end
    
    function Window:CreateSection(title)
        local section = Instance.new("Frame")
        section.Name = "Section"
        section.BackgroundColor3 = UILibrary.Theme.Primary
        section.BorderSizePixel = 0
        section.Size = UDim2.new(1, 0, 0, 35)
        section.Parent = contentFrame
        
        addCorners(section, 8)
        
        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Position = UDim2.new(0, 12, 0, 0)
        sectionLabel.Size = UDim2.new(1, -24, 1, 0)
        sectionLabel.Font = Enum.Font.GothamBold
        sectionLabel.Text = title or "Section"
        sectionLabel.TextColor3 = UILibrary.Theme.Accent
        sectionLabel.TextSize = 16
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Parent = section
        
        return section
    end
    
    return Window
end
