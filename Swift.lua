-- SwiftUILIB v4.0 (Darkrai-Inspired Full Redesign)
-- Author: XylorPrograms
-- Structure: Modular, polished, and expandable

local Swift = {}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local function roundify(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
end

local function addStroke(obj, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = color or Color3.fromRGB(50, 50, 50)
    stroke.Transparency = 0.3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
end

function Swift:CreateWindow(title)
    local UI = {}

    local gui = Instance.new("ScreenGui")
    gui.Name = "SwiftUILIB"
    gui.Parent = CoreGui
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 680, 0, 430)
    main.Position = UDim2.new(0.5, -340, 0.5, -215)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Active = true
    main.Draggable = true
    main.Parent = gui
    roundify(main, 12)
    addStroke(main)

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    header.Text = title or "SwiftUILIB"
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 17
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.BorderSizePixel = 0
    header.Parent = main
    roundify(header, 12)
    addStroke(header)

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 140, 1, -36)
    sidebar.Position = UDim2.new(0, 0, 0, 36)
    sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    roundify(sidebar, 10)

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -140, 1, -36)
    tabContainer.Position = UDim2.new(0, 140, 0, 36)
    tabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = main
    roundify(tabContainer, 10)

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Parent = sidebar
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 6)

    local tabs = {}
    local currentTab = nil

    function UI:Tab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -10, 0, 38)
        tabButton.Text = name
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        tabButton.BorderSizePixel = 0
        tabButton.Parent = sidebar
        roundify(tabButton, 8)
        addStroke(tabButton)

        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.ScrollBarThickness = 6
        contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
        contentFrame.BorderSizePixel = 0
        contentFrame.Visible = false
        contentFrame.Parent = tabContainer
        roundify(contentFrame, 10)

        local layout = Instance.new("UIListLayout")
        layout.Parent = contentFrame
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 10)

        tabs[name] = contentFrame

        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
            end
            for _, btn in ipairs(sidebar:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 30)}):Play()
                end
            end
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 90, 255)}):Play()
            currentTab = contentFrame
            currentTab.Visible = true
        end)

        local TabAPI = {}

        function TabAPI:Button(text, callback)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -14, 0, 38)
            button.Text = text
            button.Font = Enum.Font.Gotham
            button.TextSize = 14
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 52)
            button.BorderSizePixel = 0
            button.Parent = contentFrame
            roundify(button, 8)
            addStroke(button)

            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 62)
                }):Play()
            end)
            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(50, 50, 52)
                }):Play()
            end)

            button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        return TabAPI
    end

    return UI
end

return Swift
