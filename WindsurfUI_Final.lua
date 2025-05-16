--[[
    WindsurfUI Library - Advanced Version
    A modern, feature-rich UI library for Roblox exploit scripts
    
    Features:
    - Smooth animations and transitions
    - Enhanced UI elements (buttons, toggles, sliders)
    - Customizable themes
    - Ripple effects and hover animations
    - Draggable interface
]]

-- Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Constants and Globals
local Library = {
    Flags = {},
    Theme = {},
    Connections = {},
    Elements = {}
}

-- Default Theme
Library.DefaultTheme = {
    Background = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(0, 170, 255),
    LightContrast = Color3.fromRGB(35, 35, 35),
    DarkContrast = Color3.fromRGB(20, 20, 20),
    TextColor = Color3.fromRGB(240, 240, 240),
    PlaceholderColor = Color3.fromRGB(180, 180, 180),
    BorderColor = Color3.fromRGB(60, 60, 60)
}

-- Animation presets
local AnimationPresets = {
    Window = {
        Open = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        Close = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    },
    Button = {
        Hover = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Press = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    },
    Toggle = {
        Switch = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    },
    Slider = {
        Drag = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    },
    Tab = {
        Select = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    }
}

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

-- Create a UIStroke with specified parameters
local function CreateStroke(parent, color, thickness, transparency)
    local stroke = Create("UIStroke")({
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = parent
    })
    return stroke
end

-- Tween helper function
local function Tween(instance, tweenInfo, properties)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Create a ripple effect on button press
local function CreateRipple(parent)
    local ripple = Create("Frame")({
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.85,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0, 0),
        Parent = parent,
        ZIndex = parent.ZIndex + 1
    })
    
    Create("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = ripple
    })
    
    return ripple
end

local function PlayRipple(button, mousePos)
    local ripple = CreateRipple(button)
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    local pos = UDim2.fromOffset(
        mousePos.X - button.AbsolutePosition.X,
        mousePos.Y - button.AbsolutePosition.Y
    )
    
    ripple.Position = pos
    
    Tween(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(size, size)
    })
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

-- Enhanced Dragging Functionality with animations
local function EnableDragging(frame)
    local dragging, dragInput, dragStart, startPos
    local dragEnded = false
    local dragRotation = 0
    
    -- Create a drag indicator
    local dragIndicator = Create("Frame")({
        Name = "DragIndicator",
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Library.Theme.Accent,
        BackgroundTransparency = 1,
        ZIndex = 10,
        Parent = frame
    })
    
    -- Function to update position with smooth animation if needed
    local function UpdatePosition(input)
        local delta = input.Position - dragStart
        local targetPosition = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
        
        frame.Position = targetPosition
    end
    
    -- Apply effects when dragging starts
    local function StartDragEffects()
        -- Show drag indicator with animation
        Tween(dragIndicator, AnimationPresets.Window.Open, {
            BackgroundTransparency = 0.7
        })
        
        -- Slight scale effect
        Tween(frame, AnimationPresets.Window.Open, {
            Size = UDim2.new(
                frame.Size.X.Scale, 
                frame.Size.X.Offset * 0.99, 
                frame.Size.Y.Scale, 
                frame.Size.Y.Offset * 0.99
            )
        })
    end
    
    -- Apply effects when dragging ends
    local function EndDragEffects()
        Tween(dragIndicator, AnimationPresets.Window.Close, {
            BackgroundTransparency = 1
        })
        
        Tween(frame, AnimationPresets.Window.Close, {
            Size = UDim2.new(
                frame.Size.X.Scale, 
                frame.Size.X.Offset / 0.99, 
                frame.Size.Y.Scale, 
                frame.Size.Y.Offset / 0.99
            )
        })
    end
    
    -- Handle input events
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragEnded = false
            dragStart = input.Position
            startPos = frame.Position
            
            StartDragEffects()
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    dragEnded = true
                    EndDragEffects()
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    -- Global input changed connection
    local connection = UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            UpdatePosition(input)
        end
    end)
    
    -- Store connection for potential cleanup
    table.insert(Library.Connections, connection)
    
    return connection
end

-- Window Creation with enhanced animations and styling
function Library:CreateWindow(config)
    -- Initialize configuration with defaults
    config = config or {}
    config.Title = config.Title or "WindsurfUI"
    config.Size = config.Size or UDim2.new(0, 550, 0, 350)
    config.Position = config.Position or UDim2.new(0.5, -275, 0.5, -175)
    
    -- Apply theme settings
    Library.Theme = {}
    for k, v in pairs(Library.DefaultTheme) do
        Library.Theme[k] = v
    end
    
    -- Apply custom theme if provided
    if config.Theme then
        for key, value in pairs(config.Theme) do
            Library.Theme[key] = value
        end
    end
    
    -- Create window container with more properties
    local window = {}
    window.Tabs = {}
    window.ActiveTab = nil
    window.Elements = {}
    window.Flags = Library.Flags
    
    -- Create base GUI with enhanced properties
    local ScreenGui = Create("ScreenGui")({
        Name = "WindsurfUI_" .. HttpService:GenerateGUID(false):sub(1, 8),
        DisplayOrder = 100,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    window.ScreenGui = ScreenGui
    
    -- Try to parent to CoreGui (for exploits) with better error handling
    local success = pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
            ScreenGui.Parent = CoreGui
        elseif gethui then
            ScreenGui.Parent = gethui()
        elseif hookgui then
            hookgui(ScreenGui)
            ScreenGui.Parent = CoreGui
        else
            ScreenGui.Parent = CoreGui
        end
    end)
    
    -- If failed, parent to PlayerGui as fallback
    if not success or not ScreenGui.Parent then
        pcall(function()
            ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        end)
    end
    
    -- Create main frame with enhanced styling
    local MainFrame = Create("Frame")({
        Name = "MainFrame",
        Size = config.Size,
        Position = config.Position,
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ScreenGui,
        BackgroundTransparency = 1, -- Start transparent for animation
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    
    window.MainFrame = MainFrame
    
    -- Create corner with slightly rounded edges for modern look
    local MainCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    
    -- Create enhanced shadow with better visual quality
    local MainShadow = Create("ImageLabel")({
        Name = "Shadow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 1, -- Start transparent for animation
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = -1,
        Parent = MainFrame
    })
    
    -- Add subtle stroke around main frame
    local MainStroke = CreateStroke(MainFrame, Library.Theme.BorderColor, 1, 0.5)
    
    -- Create title bar with gradient effect
    local TitleBar = Create("Frame")({
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40), -- Slightly taller for better proportions
        BackgroundColor3 = Library.Theme.DarkContrast,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    local TitleBarCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = TitleBar
    })
    
    -- Add gradient to titlebar for a more polished look
    local TitleBarGradient = Create("UIGradient")({
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(
                Library.Theme.DarkContrast.R * 255 + 15,
                Library.Theme.DarkContrast.G * 255 + 15,
                Library.Theme.DarkContrast.B * 255 + 15
            )),
            ColorSequenceKeypoint.new(1, Library.Theme.DarkContrast)
        }),
        Rotation = 90,
        Parent = TitleBar
    })
    
    -- Create bottom cover to hide corner intersection
    local TitleBarBottomCover = Create("Frame")({
        Name = "BottomCover",
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Library.Theme.DarkContrast,
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    
    -- Add accent bar at the top for visual interest
    local AccentBar = Create("Frame")({
        Name = "AccentBar",
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Library.Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = TitleBar
    })
    
    local AccentBarCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 2),
        Parent = AccentBar
    })
    
    -- Create title text with subtle shadow
    local TitleText = Create("TextLabel")({
        Name = "Title",
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Library.Theme.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar,
        TextTransparency = 1 -- Start transparent for animation
    })
    
    -- Add text shadow for depth
    local TitleShadow = Create("TextLabel")({
        Name = "TitleShadow",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        Text = config.Title,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 0.8,
        ZIndex = TitleText.ZIndex - 1,
        Parent = TitleText
    })
    
    -- Enhanced close button with animations
    local CloseButton = Create("ImageButton")({
        Name = "CloseButton",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0, 10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031094678",
        ImageColor3 = Library.Theme.TextColor,
        Parent = TitleBar,
        ImageTransparency = 1 -- Start transparent for animation
    })
    
    -- Add background for close button that appears on hover
    local CloseButtonBG = Create("Frame")({
        Name = "Background",
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        BackgroundTransparency = 1,
        ZIndex = CloseButton.ZIndex - 1,
        Parent = CloseButton
    })
    
    Create("UICorner")({
        CornerRadius = UDim.new(1, 0),
        Parent = CloseButtonBG
    })
    
    -- Add enhanced hover and click effects
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, AnimationPresets.Button.Hover, {
            ImageColor3 = Color3.fromRGB(255, 255, 255)
        })
        
        Tween(CloseButtonBG, AnimationPresets.Button.Hover, {
            BackgroundTransparency = 0.7
        })
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, AnimationPresets.Button.Hover, {
            ImageColor3 = Library.Theme.TextColor
        })
        
        Tween(CloseButtonBG, AnimationPresets.Button.Hover, {
            BackgroundTransparency = 1
        })
    end)
    
    CloseButton.MouseButton1Down:Connect(function()
        Tween(CloseButtonBG, AnimationPresets.Button.Press, {
            BackgroundTransparency = 0.5,
            Size = UDim2.new(0, 24, 0, 24)
        })
    end)
    
    CloseButton.MouseButton1Up:Connect(function()
        Tween(CloseButtonBG, AnimationPresets.Button.Hover, {
            BackgroundTransparency = 0.7,
            Size = UDim2.new(0, 26, 0, 26)
        })
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        -- Animate the UI closing
        Tween(MainFrame, AnimationPresets.Window.Close, {
            BackgroundTransparency = 1,
            Size = UDim2.new(config.Size.X.Scale, config.Size.X.Offset * 0.95, config.Size.Y.Scale, config.Size.Y.Offset * 0.95)
        })
        
        Tween(MainShadow, AnimationPresets.Window.Close, {
            ImageTransparency = 1
        })
        
        Tween(TitleText, AnimationPresets.Window.Close, {
            TextTransparency = 1
        })
        
        -- Cleanup after animation completes
        task.delay(0.3, function()
            -- Cleanup all connections
            for _, connection in ipairs(Library.Connections) do
                if connection then
                    connection:Disconnect()
                end
            end
            
            -- Destroy the UI
            ScreenGui:Destroy()
        end)
    end)
    
    -- Create enhanced content area with animations
    local ContentFrame = Create("Frame")({
        Name = "ContentFrame",
        Size = UDim2.new(1, 0, 1, -40), -- Adjusted for titlebar height
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        BackgroundTransparency = 1, -- Start transparent for animation
        ClipsDescendants = true, -- Ensure animations stay within bounds
        Parent = MainFrame
    })
    
    -- Create enhanced tab container with gradient and animations
    local TabContainer = Create("Frame")({
        Name = "TabContainer",
        Size = UDim2.new(0, 150, 1, 0),
        BackgroundColor3 = Library.Theme.LightContrast,
        BorderSizePixel = 0,
        BackgroundTransparency = 1, -- Start transparent for animation
        Parent = ContentFrame
    })
    
    local TabContainerCorner = Create("UICorner")({
        CornerRadius = UDim.new(0, 8),
        Parent = TabContainer
    })
    
    -- Add gradient to tab container for better aesthetics
    local TabContainerGradient = Create("UIGradient")({
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(
                Library.Theme.LightContrast.R * 255 + 10,
                Library.Theme.LightContrast.G * 255 + 10,
                Library.Theme.LightContrast.B * 255 + 10
            )),
            ColorSequenceKeypoint.new(1, Library.Theme.LightContrast)
        }),
        Rotation = 90,
        Parent = TabContainer
    })
    
    -- Add subtle stroke to tab container
    local TabContainerStroke = CreateStroke(TabContainer, Library.Theme.BorderColor, 1, 0.5)
    
    -- Cover for tab container corner intersection
    local TabContainerRightCover = Create("Frame")({
        Name = "RightCover",
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(1, -10, 0, 0),
        BackgroundColor3 = Library.Theme.LightContrast,
        BorderSizePixel = 0,
        BackgroundTransparency = 1, -- Start transparent for animation
        Parent = TabContainer
    })
    
    -- Tab header at the top of the container
    local TabHeader = Create("Frame")({
        Name = "TabHeader",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Library.Theme.DarkContrast,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Parent = TabContainer
    })
    
    local TabHeaderText = Create("TextLabel")({
        Name = "HeaderText",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "NAVIGATION",
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextColor3 = Library.Theme.PlaceholderColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1, -- Start transparent for animation
        Parent = TabHeader
    })
    
    -- Enhanced scrolling frame for tabs with smoother scrolling
    local TabsScrollFrame = Create("ScrollingFrame")({
        Name = "TabsScroll",
        Size = UDim2.new(1, -10, 1, -40), -- Adjusted for header
        Position = UDim2.new(0, 5, 0, 35),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Library.Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = TabContainer
    })
    
    -- Add smooth scrolling behavior
    local function SmoothScroll(content, endPosition, duration)
        local startPosition = content.CanvasPosition
        local change = endPosition - startPosition
        local clock = os.clock()
        local startTime = clock
        
        -- Disconnect existing scrolling connection if any
        if window.CurrentScrollConnection then
            window.CurrentScrollConnection:Disconnect()
        end
        
        -- Function to ease scrolling
        local function EaseOutQuad(t)
            return -t * (t - 2)
        end
        
        -- Create new scrolling connection
        window.CurrentScrollConnection = RunService.RenderStepped:Connect(function()
            local elapsed = clock() - startTime
            if elapsed >= duration then
                content.CanvasPosition = endPosition
                window.CurrentScrollConnection:Disconnect()
                window.CurrentScrollConnection = nil
                return
            end
            
            local t = elapsed / duration
            local easedT = EaseOutQuad(t)
            content.CanvasPosition = startPosition + (change * easedT)
        end)
    end
    
    -- Enhanced tab list layout with better spacing
    local TabsListLayout = Create("UIListLayout")({
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabsScrollFrame
    })
    
    -- Enhanced padding for better visual spacing
    local TabsPadding = Create("UIPadding")({
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = TabsScrollFrame
    })
    
    -- Create enhanced tab content area with better styling
    local TabContentFrame = Create("Frame")({
        Name = "TabContentFrame",
        Size = UDim2.new(1, -160, 1, 0), -- Slightly adjusted for spacing
        Position = UDim2.new(0, 160, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true, -- For better animations
        Parent = ContentFrame
    })
    
    -- Create a border effect on the left side of content area
    local ContentBorder = Create("Frame")({
        Name = "ContentBorder",
        Size = UDim2.new(0, 1, 1, -20),
        Position = UDim2.new(0, -5, 0, 10),
        BackgroundColor3 = Library.Theme.BorderColor,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Parent = TabContentFrame
    })
    
    -- Enable dragging with enhanced animations
    EnableDragging(TitleBar)
    
    -- Store UI components in window object
    window.ScreenGui = ScreenGui
    window.MainFrame = MainFrame
    window.TabContainer = TabContainer
    window.TabsScrollFrame = TabsScrollFrame
    window.TabContentFrame = TabContentFrame
    
    -- Play entrance animation
    Tween(MainFrame, AnimationPresets.Window.Open, {
        BackgroundTransparency = 0,
        Size = config.Size
    })
    
    Tween(MainShadow, AnimationPresets.Window.Open, {
        ImageTransparency = 0.8
    })
    
    Tween(ContentFrame, AnimationPresets.Window.Open, {
        BackgroundTransparency = 0
    })
    
    Tween(TabContainer, AnimationPresets.Window.Open, {
        BackgroundTransparency = 0
    })
    
    Tween(TabContainerRightCover, AnimationPresets.Window.Open, {
        BackgroundTransparency = 0
    })
    
    Tween(TitleText, AnimationPresets.Window.Open, {
        TextTransparency = 0
    })
    
    Tween(CloseButton, AnimationPresets.Window.Open, {
        ImageTransparency = 0
    })
    
    Tween(TabHeaderText, AnimationPresets.Window.Open, {
        TextTransparency = 0
    })
    
    -- Enhanced tab creation method with better animations and interactions
    function window:CreateTab(info)
        info = info or {}
        info.Name = info.Name or "Tab"
        info.Icon = info.Icon or "rbxassetid://6031265976" -- Default icon
        info.Description = info.Description or nil -- Optional description for tooltips
        
        local tab = {}
        tab.Elements = {}
        tab.Name = info.Name
        
        -- Create enhanced tab button with animations
        local TabButton = Create("TextButton")({
            Name = info.Name .. "TabButton",
            Size = UDim2.new(0, 130, 0, 36), -- Slightly larger for better touch targets
            BackgroundColor3 = Library.Theme.Background,
            BackgroundTransparency = 0.4, -- Semi-transparent background
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = TabsScrollFrame
        })
        
        -- Add better rounded corners
        local TabButtonCorner = Create("UICorner")({
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton
        })
        
        -- Add subtle stroke for definition
        local TabButtonStroke = CreateStroke(TabButton, Library.Theme.BorderColor, 1, 0.7)
        
        -- Add an accent indicator that shows when tab is active
        local TabIndicator = Create("Frame")({
            Name = "Indicator",
            Size = UDim2.new(0, 4, 0.7, 0),
            Position = UDim2.new(0, 0, 0.15, 0),
            BackgroundColor3 = Library.Theme.Accent,
            BorderSizePixel = 0,
            Transparency = 1, -- Hidden by default
            Parent = TabButton
        })
        
        local TabIndicatorCorner = Create("UICorner")({
            CornerRadius = UDim.new(0, 2),
            Parent = TabIndicator
        })
        
        -- Enhanced icon with subtle shadow
        local TabIcon = Create("ImageLabel")({
            Name = "Icon",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 10, 0, 8),
            BackgroundTransparency = 1,
            Image = info.Icon,
            ImageColor3 = Library.Theme.TextColor,
            ImageTransparency = 0.2, -- Slight transparency for subtle effect
            Parent = TabButton
        })
        
        -- Create subtle shadow behind icon
        local TabIconShadow = Create("ImageLabel")({
            Name = "IconShadow",
            Size = UDim2.new(1, 4, 1, 4),
            Position = UDim2.new(0, -2, 0, -2),
            BackgroundTransparency = 1,
            Image = info.Icon,
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.85,
            ZIndex = TabIcon.ZIndex - 1,
            Parent = TabIcon
        })
        
        -- Better tab title with improved spacing
        local TabTitle = Create("TextLabel")({
            Name = "Title",
            Size = UDim2.new(1, -40, 0.7, 0),
            Position = UDim2.new(0, 38, 0.15, 0),
            BackgroundTransparency = 1,
            Text = info.Name,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextColor3 = Library.Theme.TextColor,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        })
        
        -- Optional description label below title for larger tabs
        if info.Description then
            TabButton.Size = UDim2.new(0, 130, 0, 50) -- Make taller for description
            TabTitle.Size = UDim2.new(1, -40, 0.4, 0)
            TabTitle.Position = UDim2.new(0, 38, 0.12, 0)
            
            local TabDescription = Create("TextLabel")({
                Name = "Description",
                Size = UDim2.new(1, -40, 0.35, 0),
                Position = UDim2.new(0, 38, 0.55, 0),
                BackgroundTransparency = 1,
                Text = info.Description,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextColor3 = Library.Theme.PlaceholderColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = TabButton
            })
        end
        
        -- Create enhanced tab content container with improved scrolling
        local TabContent = Create("ScrollingFrame")({
            Name = info.Name .. "Content",
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Library.Theme.Accent,
            ScrollBarImageTransparency = 0.4,
            VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ClipsDescendants = true,
            Visible = false,
            BackgroundTransparency = 1, -- Start fully transparent for animation
            Parent = TabContentFrame
        })
        
        -- Add better spacing and layout for content
        local ContentListLayout = Create("UIListLayout")({
            Padding = UDim.new(0, 12), -- Increased padding for better visual separation
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabContent
        })
        
        -- Add padding around content for better spacing
        local ContentPadding = Create("UIPadding")({
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            Parent = TabContent
        })
        
        -- Store references for later use
        tab.TabContent = TabContent
        tab.TabButton = TabButton
        tab.TabIndicator = TabIndicator
        
        -- Add content size tracking to update scroll correctly
        ContentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentListLayout.AbsoluteContentSize.Y + 16)
        end)
        
        -- Define tab animation states
        local function SelectTab()
            -- Animate tab indicator
            Tween(TabIndicator, AnimationPresets.Tab.Select, {
                BackgroundTransparency = 0,
                Size = UDim2.new(0, 4, 0.7, 0)
            })
            
            -- Animate tab button
            Tween(TabButton, AnimationPresets.Tab.Select, {
                BackgroundColor3 = Library.Theme.Accent,
                BackgroundTransparency = 0.8
            })
            
            -- Brighten the icon and text
            Tween(TabIcon, AnimationPresets.Tab.Select, {
                ImageColor3 = Library.Theme.Accent,
                ImageTransparency = 0
            })
            
            Tween(TabTitle, AnimationPresets.Tab.Select, {
                TextColor3 = Library.Theme.Accent,
                TextTransparency = 0
            })
            
            -- Animate stroke to accent color
            Tween(TabButtonStroke, AnimationPresets.Tab.Select, {
                Color = Library.Theme.Accent,
                Transparency = 0.5
            })
            
            -- Fade in content with slight scale animation
            TabContent.Size = UDim2.new(0.98, 0, 1, -20)
            TabContent.Position = UDim2.new(0.01, 0, 0, 10)
            TabContent.BackgroundTransparency = 1
            TabContent.Visible = true
            
            Tween(TabContent, AnimationPresets.Tab.Select, {
                Size = UDim2.new(1, -20, 1, -20),
                Position = UDim2.new(0, 10, 0, 10),
                BackgroundTransparency = 1
            })
        end
        
        local function DeselectTab()
            -- Hide indicator
            Tween(TabIndicator, AnimationPresets.Tab.Select, {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 2, 0.4, 0)
            })
            
            -- Reset tab button
            Tween(TabButton, AnimationPresets.Tab.Select, {
                BackgroundColor3 = Library.Theme.Background,
                BackgroundTransparency = 0.4
            })
            
            -- Reset icon and text
            Tween(TabIcon, AnimationPresets.Tab.Select, {
                ImageColor3 = Library.Theme.TextColor,
                ImageTransparency = 0.2
            })
            
            Tween(TabTitle, AnimationPresets.Tab.Select, {
                TextColor3 = Library.Theme.TextColor,
                TextTransparency = 0
            })
            
            -- Reset stroke
            Tween(TabButtonStroke, AnimationPresets.Tab.Select, {
                Color = Library.Theme.BorderColor,
                Transparency = 0.7
            })
            
            -- Fade out content
            Tween(TabContent, AnimationPresets.Tab.Select, {
                Size = UDim2.new(0.98, 0, 1, -20),
                Position = UDim2.new(0.01, 0, 0, 10),
                BackgroundTransparency = 1
            })
            
            -- Hide after animation completes
            task.delay(0.2, function()
                if window.ActiveTab ~= tab then
                    TabContent.Visible = false
                end
            end)
        end
        
        -- Handle tab clicks with improved animations
        TabButton.MouseButton1Click:Connect(function()
            if window.ActiveTab == tab then return end
            
            -- Play ripple effect at click position
            local mousePos = UserInputService:GetMouseLocation() - TabButton.AbsolutePosition
            PlayRipple(TabButton, mousePos)
            
            -- Deselect all tabs
            for _, otherTab in pairs(window.Tabs) do
                if otherTab ~= tab then
                    DeselectTab(otherTab)
                end
            end
            
            -- Select current tab
            SelectTab()
            window.ActiveTab = tab
            
            -- Scroll to the tab if not visible (for many tabs)
            local tabPosition = TabButton.Position
            local scrollingFrameHeight = TabsScrollFrame.AbsoluteSize.Y
            local buttonHeight = TabButton.AbsoluteSize.Y
            
            if tabPosition.Y.Offset < TabsScrollFrame.CanvasPosition.Y or 
               tabPosition.Y.Offset + buttonHeight > TabsScrollFrame.CanvasPosition.Y + scrollingFrameHeight then
                local targetPosition = Vector2.new(0, tabPosition.Y.Offset - (scrollingFrameHeight / 2) + (buttonHeight / 2))
                targetPosition = Vector2.new(0, math.max(0, math.min(targetPosition.Y, TabsScrollFrame.CanvasSize.Y.Offset - scrollingFrameHeight)))
                SmoothScroll(TabsScrollFrame, targetPosition, 0.3)
            end
        end)
        
        -- Enhanced hover effects
        TabButton.MouseEnter:Connect(function()
            if window.ActiveTab ~= tab then
                Tween(TabButton, AnimationPresets.Button.Hover, {
                    BackgroundTransparency = 0.3,
                    BackgroundColor3 = Library.Theme.LightContrast
                })
                
                Tween(TabButtonStroke, AnimationPresets.Button.Hover, {
                    Transparency = 0.5
                })
                
                Tween(TabIcon, AnimationPresets.Button.Hover, {
                    ImageTransparency = 0
                })
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if window.ActiveTab ~= tab then
                Tween(TabButton, AnimationPresets.Button.Hover, {
                    BackgroundTransparency = 0.4,
                    BackgroundColor3 = Library.Theme.Background
                })
                
                Tween(TabButtonStroke, AnimationPresets.Button.Hover, {
                    Transparency = 0.7
                })
                
                Tween(TabIcon, AnimationPresets.Button.Hover, {
                    ImageTransparency = 0.2
                })
            end
        end)
        
        -- Enhanced Button Element with animations and ripple effect
        function tab:CreateButton(config)
            config = config or {}
            config.Name = config.Name or "Button"
            config.Description = config.Description or nil
            config.Icon = config.Icon or nil 
            config.Text = config.Text or "Click"
            config.Callback = config.Callback or function() end
            
            local element = {}
            element.Type = "Button"
            element.Name = config.Name
            
            -- Determine button height based on description
            local buttonHeight = config.Description and 60 or 40
            
            -- Create enhanced button container
            local Button = Create("Frame")({
                Name = config.Name .. "_Button",
                Size = UDim2.new(1, 0, 0, buttonHeight),
                BackgroundColor3 = Library.Theme.LightContrast,
                BorderSizePixel = 0,
                ClipsDescendants = true, -- Important for ripple effect
                Parent = tab.TabContent
            })
            
            -- Add rounded corners
            local ButtonCorner = Create("UICorner")({
                CornerRadius = UDim.new(0, 6),
                Parent = Button
            })
            
            -- Add subtle stroke for better definition
            local ButtonStroke = CreateStroke(Button, Library.Theme.BorderColor, 1, 0.5)
            
            -- Create button icon if provided
            if config.Icon then
                local ButtonIcon = Create("ImageLabel")({
                    Name = "Icon",
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, 15, 0, config.Description and 10 or 10),
                    BackgroundTransparency = 1,
                    Image = config.Icon,
                    ImageColor3 = Library.Theme.TextColor,
                    Parent = Button
                })
                
                -- Add shadow to icon for depth
                Create("ImageLabel")({
                    Name = "IconShadow",
                    Size = UDim2.new(1, 4, 1, 4),
                    Position = UDim2.new(0, -2, 0, -2),
                    BackgroundTransparency = 1,
                    Image = config.Icon,
                    ImageColor3 = Color3.fromRGB(0, 0, 0),
                    ImageTransparency = 0.85,
                    ZIndex = ButtonIcon.ZIndex - 1,
                    Parent = ButtonIcon
                })
            end
            
            -- Create title with adjusted position based on icon
            local textPositionX = config.Icon and 45 or 15
            
            local ButtonTitle = Create("TextLabel")({
                Name = "Title",
                Size = UDim2.new(1, -(textPositionX + 160), 0, 20),
                Position = UDim2.new(0, textPositionX, 0, config.Description and 10 or 10),
                BackgroundTransparency = 1,
                Text = config.Name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = Library.Theme.TextColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button
            })
            
            -- Create description if provided
            if config.Description then
                local ButtonDescription = Create("TextLabel")({
                    Name = "Description",
                    Size = UDim2.new(1, -(textPositionX + 160), 0, 16),
                    Position = UDim2.new(0, textPositionX, 0, 32),
                    BackgroundTransparency = 1,
                    Text = config.Description,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = Library.Theme.PlaceholderColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Parent = Button
                })
            end
            
            -- Create enhanced click button
            local ClickButton = Create("TextButton")({
                Name = "ClickButton",
                Size = UDim2.new(0, 150, 0, 26),
                Position = UDim2.new(1, -160, 0.5, -13),
                BackgroundColor3 = Library.Theme.DarkContrast,
                BorderSizePixel = 0,
                Text = config.Text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = Library.Theme.TextColor,
                AutoButtonColor = false,
                ClipsDescendants = true, -- For ripple effect
                Parent = Button
            })
            
            local ClickButtonCorner = Create("UICorner")({
                CornerRadius = UDim.new(0, 4),
                Parent = ClickButton
            })
            
            -- Add subtle stroke to click button
            local ClickButtonStroke = CreateStroke(ClickButton, Library.Theme.BorderColor, 1, 0.5)
            
            -- Add drop shadow for button
            local ClickButtonShadow = Create("Frame")({
                Name = "Shadow",
                Size = UDim2.new(1, 6, 1, 6),
                Position = UDim2.new(0, -3, 0, -3),
                BackgroundTransparency = 1,
                ZIndex = ClickButton.ZIndex - 1,
                Parent = ClickButton
            })
            
            local ClickButtonShadowCorner = Create("UICorner")({
                CornerRadius = UDim.new(0, 4),
                Parent = ClickButtonShadow
            })
            
            -- Hover and click effects with enhanced animations
            ClickButton.MouseEnter:Connect(function()
                Tween(ClickButton, AnimationPresets.Button.Hover, {
                    BackgroundColor3 = Library.Theme.Accent,
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                Tween(ClickButtonStroke, AnimationPresets.Button.Hover, {
                    Transparency = 0.2
                })
            end)
            
            ClickButton.MouseLeave:Connect(function()
                Tween(ClickButton, AnimationPresets.Button.Hover, {
                    BackgroundColor3 = Library.Theme.DarkContrast,
                    TextColor3 = Library.Theme.TextColor
                })
                
                Tween(ClickButtonStroke, AnimationPresets.Button.Hover, {
                    Transparency = 0.5
                })
            end)
            
            ClickButton.MouseButton1Down:Connect(function(x, y)
                -- Create ripple effect at click position
                local mousePos = Vector2.new(x, y)
                PlayRipple(ClickButton, mousePos)
                
                -- Animate button press with scale down effect
                Tween(ClickButton, AnimationPresets.Button.Press, {
                    Size = UDim2.new(0, 146, 0, 24),
                    Position = UDim2.new(1, -158, 0.5, -12)
                })
            end)
            
            ClickButton.MouseButton1Up:Connect(function()
                -- Animate button release with scale up effect
                Tween(ClickButton, AnimationPresets.Button.Press, {
                    Size = UDim2.new(0, 150, 0, 26),
                    Position = UDim2.new(1, -160, 0.5, -13)
                })
            end)
            
            ClickButton.MouseButton1Click:Connect(function()
                config.Callback()
            end)
            
            element.Instance = Button
            table.insert(tab.Elements, element)
            return element
        end
        
        -- Toggle Element
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
                BackgroundColor3 = THEME.LightContrast,
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
                TextColor3 = THEME.TextColor,
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
                TextColor3 = THEME.PlaceholderColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Toggle
            })
            
            -- Create toggle switch
            local ToggleOuter = Create("Frame")({
                Name = "ToggleOuter",
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -55, 0, 10),
                BackgroundColor3 = THEME.DarkContrast,
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
                BackgroundColor3 = THEME.TextColor,
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
                local color = element.Value and THEME.Accent or THEME.DarkContrast
                
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
                ToggleOuter.BackgroundColor3 = THEME.Accent
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
        
        -- Slider Element with enhanced animations and styling
        function tab:CreateSlider(config)
            config = config or {}
            config.Name = config.Name or "Slider"
            config.Min = config.Min or 0
            config.Max = config.Max or 100
            config.Default = config.Default or math.floor((config.Min + config.Max) / 2)
            config.Increment = config.Increment or 1
            config.Flag = config.Flag or config.Name:gsub(" ", "_"):lower()
            config.Callback = config.Callback or function() end
            config.Description = config.Description or nil
            config.Suffix = config.Suffix or ""
            
            -- Validate config
            config.Default = math.clamp(config.Default, config.Min, config.Max)
            
            local element = {}
            element.Type = "Slider"
            element.Name = config.Name
            element.Flag = config.Flag
            element.Value = config.Default
            element.Callback = config.Callback
            
            -- Register flag
            Library.Flags = Library.Flags or {}
            Library.Flags[config.Flag] = config.Default
            
            -- Determine slider height based on description
            local sliderHeight = config.Description and 70 or 50
            
            -- Create slider container with enhanced visuals
            local Slider = Create("Frame")({
                Name = config.Name .. "_Slider",
                Size = UDim2.new(1, 0, 0, sliderHeight),
                BackgroundColor3 = THEME.LightContrast,
                BorderSizePixel = 0,
                Parent = tab.TabContent
            })
            
            local SliderCorner = Create("UICorner")({
                CornerRadius = UDim.new(0, 4),
                Parent = Slider
            })
            
            -- Add a subtle stroke to enhance visual appeal
            local SliderStroke = Create("UIStroke")({
                Color = THEME.Background,
                Transparency = 0.5,
                Thickness = 1,
                Parent = Slider
            })
            
            local SliderTitle = Create("TextLabel")({
                Name = "Title",
                Size = UDim2.new(1, -160, 0, 20),
                Position = UDim2.new(0, 15, 0, config.Description and 10 or 5),
                BackgroundTransparency = 1,
                Text = config.Name,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextColor3 = THEME.TextColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Slider
            })
            
            -- Optional description
            if config.Description then
                local SliderDescription = Create("TextLabel")({
                    Name = "Description",
                    Size = UDim2.new(1, -160, 0, 16),
                    Position = UDim2.new(0, 15, 0, 32),
                    BackgroundTransparency = 1,
                    Text = config.Description,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = THEME.PlaceholderColor,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Parent = Slider
                })
            end
            
            -- Create value display with better styling
            local SliderValue = Create("TextBox")({
                Name = "Value",
                Size = UDim2.new(0, 60, 0, 20),
                Position = UDim2.new(1, -70, 0, 10),
                BackgroundColor3 = THEME.DarkContrast,
                BorderSizePixel = 0,
                Text = tostring(config.Default) .. config.Suffix,
                Font = Enum.Font.GothamSemibold,
                TextSize = 12,
                TextColor3 = THEME.TextColor,
                TextWrapped = true,
                ClipsDescendants = true,
                Parent = Slider
            })
            
            local SliderValueCorner = Create("UICorner")({
                CornerRadius = UDim.new(0, 4),
                Parent = SliderValue
            })
            
            local SliderValueStroke = Create("UIStroke")({
                Color = THEME.Background,
                Transparency = 0.5,
                Thickness = 1,
                Parent = SliderValue
            })
            
            -- Create slider bar with improved positioning
            local SliderBar = Create("Frame")({
                Name = "SliderBar",
                Size = UDim2.new(1, -30, 0, 6),
                Position = UDim2.new(0, 15, 0, config.Description and 55 or 35),
                BackgroundColor3 = THEME.DarkContrast,
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
                BackgroundColor3 = THEME.Accent,
                BorderSizePixel = 0,
                Parent = SliderBar
            })
            
            local SliderFillCorner = Create("UICorner")({
                CornerRadius = UDim.new(1, 0),
                Parent = SliderFill
            })
            
            -- Enhanced drag handle
            local SliderDrag = Create("Frame")({
                Name = "SliderDrag",
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0, -6, 0.5, -6),
                BackgroundColor3 = THEME.TextColor,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = SliderFill
            })
            
            local SliderDragCorner = Create("UICorner")({
                CornerRadius = UDim.new(1, 0),
                Parent = SliderDrag
            })
            
            -- Add a gradient to the drag handle for better visual appearance
            local SliderDragGradient = Create("UIGradient")({
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 220))
                }),
                Rotation = 90,
                Parent = SliderDrag
            })
            
            local SliderDragStroke = Create("UIStroke")({
                Color = THEME.Background,
                Transparency = 0.5,
                Thickness = 1,
                Parent = SliderDrag
            })
            
            -- Slider functionality
            local MinValue = config.Min
            local MaxValue = config.Max
            local dragging = false
            
            local function UpdateSlider(value, animate)
                -- Round to increment
                value = math.floor(value / config.Increment + 0.5) * config.Increment
                value = math.clamp(value, MinValue, MaxValue)
                
                -- Convert to percentage
                local percent = (value - MinValue) / (MaxValue - MinValue)
                
                -- Update visuals with animation
                if animate then
                    TweenService:Create(SliderFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(percent, 0, 1, 0)
                    }):Play()
                    
                    TweenService:Create(SliderValue, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0.5
                    }):Play()
                    
                    delay(0.1, function()
                        SliderValue.Text = tostring(value) .. config.Suffix
                        TweenService:Create(SliderValue, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            TextTransparency = 0
                        }):Play()
                    end)
                else
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderValue.Text = tostring(value) .. config.Suffix
                end
                
                -- Update value and invoke callback
                element.Value = value
                Library.Flags[config.Flag] = value
                config.Callback(value)
            end
            
            -- Handle mouse input for dragging with improved feedback
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    
                    -- Add ripple effect at click position if available
                    if PlayRipple then -- Check if ripple function exists
                        local mousePos = UserInputService:GetMouseLocation() - SliderBar.AbsolutePosition
                        PlayRipple(SliderBar, mousePos)
                    end
                    
                    -- Update slider immediately
                    local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local value = MinValue + ((MaxValue - MinValue) * relativeX)
                    UpdateSlider(value, true)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    -- Calculate value based on mouse position
                    local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local value = MinValue + ((MaxValue - MinValue) * relativeX)
                    UpdateSlider(value, true)
                end
            end)
            
            -- Handle text input with better validation
            SliderValue.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    local inputValue = tonumber(SliderValue.Text:gsub(config.Suffix, ""))
                    if inputValue then
                        UpdateSlider(inputValue, true)
                    else
                        SliderValue.Text = tostring(element.Value) .. config.Suffix
                    end
                end
            end)
            
            -- Hover effects for better feedback
            Slider.MouseEnter:Connect(function()
                TweenService:Create(Slider, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Color3.fromRGB(
                        THEME.LightContrast.R * 255 + 10,
                        THEME.LightContrast.G * 255 + 10,
                        THEME.LightContrast.B * 255 + 10
                    )
                }):Play()
                
                TweenService:Create(SliderStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = 0.2
                }):Play()
                
                TweenService:Create(SliderDrag, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0, -7, 0.5, -7)
                }):Play()
            end)
            
            Slider.MouseLeave:Connect(function()
                TweenService:Create(Slider, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = THEME.LightContrast
                }):Play()
                
                TweenService:Create(SliderStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = 0.5
                }):Play()
                
                TweenService:Create(SliderDrag, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(0, -6, 0.5, -6)
                }):Play()
            end)
            
            -- Set initial value
            UpdateSlider(config.Default, false)
            
            -- Public methods
            function element:SetValue(value, animate)
                UpdateSlider(value, animate or false)
            end
            
            element.Instance = Slider
            table.insert(tab.Elements, element)
            return element
        end
        
        -- ColorPicker Element
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
                BackgroundColor3 = THEME.LightContrast,
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
                TextColor3 = THEME.TextColor,
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
return Library
