-- SwiftUILIB (Advanced UI Redesign v4.1 with Darkrai Styling)
-- Author: XylorPrograms

local Swift = {}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function roundify(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
end

local function addStroke(obj, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = color or Color3.fromRGB(50, 50, 50)
    stroke.Transparency = 0.4
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
end

local function makeDraggable(topbar, target)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(target, TweenInfo.new(0.15), {Position = newPos}):Play()
    end

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = target.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function Swift:CreateWindow(title)
    local UI = {}

    local gui = Instance.new("ScreenGui")
    gui.Name = "SwiftUILIB"
    gui.Parent = CoreGui
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 656, 0, 400)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    main.Parent = gui
    roundify(main, 10)
    addStroke(main)

    main.Size = UDim2.new(0, 0, 0, 0)
    main:TweenSize(UDim2.new(0, 656, 0, 400), "Out", "Quad", 0.4, true)

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    header.Parent = main
    roundify(header, 8)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title or "SwiftUILIB"
    titleLabel.TextColor3 = Color3.fromRGB(147, 112, 219)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 16
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.Size = UDim2.new(0, 300, 1, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header

    makeDraggable(header, main)

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 150, 1, -30)
    sidebar.Position = UDim2.new(0, 0, 0, 30)
    sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    sidebar.Parent = main
    roundify(sidebar, 8)
    addStroke(sidebar)

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.Parent = sidebar

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -150, 1, -30)
    content.Position = UDim2.new(0, 150, 0, 30)
    content.BackgroundColor3 = Color3.fromRGB(38, 38, 40)
    content.Parent = main
    roundify(content, 8)
    addStroke(content)

    local pages = Instance.new("Folder")
    pages.Name = "Pages"
    pages.Parent = content

    local layout = Instance.new("UIPageLayout")
    layout.Parent = pages
    layout.EasingStyle = Enum.EasingStyle.Quad
    layout.EasingDirection = Enum.EasingDirection.InOut
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.TweenTime = 0.4

    local activeTab

    function UI:Tab(name)
        local button = Instance.new("TextButton")
        button.Text = name
        button.Font = Enum.Font.GothamSemibold
        button.TextSize = 14
        button.TextColor3 = Color3.fromRGB(220, 220, 220)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.Size = UDim2.new(1, -12, 0, 32)
        button.Parent = sidebar
        roundify(button, 6)

        local page = Instance.new("ScrollingFrame")
        page.Name = name
        page.Size = UDim2.new(1, 0, 1, 0)
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 6
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.Parent = pages

        local list = Instance.new("UIListLayout")
        list.Parent = page
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 10)

        button.MouseButton1Click:Connect(function()
            layout:JumpTo(page)
            if activeTab then
                TweenService:Create(activeTab, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end
            TweenService:Create(button, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(147, 112, 219)}):Play()
            activeTab = button
        end)

        local api = {}

        function api:Button(text, callback)
            local btn = Instance.new("TextButton")
            btn.Text = text
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.Size = UDim2.new(1, -12, 0, 32)
            btn.Parent = page
            roundify(btn, 6)

            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end)

            btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        return api
    end

    return UI
end

return Swift
