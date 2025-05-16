--[[
    WindsurfUI Library - Windows Module
    
    Contains window creation and management functionality
]]

-- Import the main library
local WindsurfUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/WindsurfUI/main/WindsurfUI.lua"))()

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
    ScreenGui.Name = "WindsurfUI_" .. game:GetService("HttpService"):GenerateGUID(false):sub(1, 8)
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
        TabButton.BackgroundColor3 = WindsurfUI.Theme.Background
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
        TabIcon.ImageColor3 = WindsurfUI.Theme.TextColor
        TabIcon.Parent = TabButton
        
        local TabText = Instance.new("TextLabel")
        TabText.Name = "TabText"
        TabText.Size = UDim2.new(1, -40, 1, 0)
        TabText.Position = UDim2.new(0, 35, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Text = info.Name
        TabText.Font = Enum.Font.GothamSemibold
        TabText.TextSize = 14
        TabText.TextColor3 = WindsurfUI.Theme.TextColor
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Parent = TabButton
        
        -- Create tab content container
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = info.Name .. "Content"
        TabContent.Size = UDim2.new(1, -10, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = WindsurfUI.Theme.Accent
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
                otherTab.TabButton.BackgroundColor3 = WindsurfUI.Theme.Background
                otherTab.TabContent.Visible = false
            end
            
            -- Select this tab
            TabButton.BackgroundColor3 = WindsurfUI.Theme.Accent
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
        
        return tab
    end
    
    return window
end

-- Make available to other modules
return WindsurfUI
