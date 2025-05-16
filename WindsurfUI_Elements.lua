--[[
    WindsurfUI Library - Elements Module
    
    Contains UI elements for the WindsurfUI library
]]

local TweenService = game:GetService("TweenService")

local Elements = {}

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

-- Button Element
function Elements:CreateButton(tab, config)
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

-- Toggle Element
function Elements:CreateToggle(tab, config)
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

-- Slider Element
function Elements:CreateSlider(tab, config)
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

-- ColorPicker Element
function Elements:CreateColorPicker(tab, config)
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
    
    -- This is a simplified version, a real color picker would need more components
    -- such as hue, saturation, value sliders - as seen in the reference images
    
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

-- Return the Elements module
return Elements
