-- SwiftUILIB (Fluent-Inspired, Fully Styled)
-- Version 3.0 - Rounded, Animated, Polished UI
-- Author: XylorPrograms

local Swift = {}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local function roundify(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
end

function Swift:CreateWindow(title)
    local UI = {}

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SwiftUILIB"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    MainFrame.Active = true
    MainFrame.Draggable = true
    roundify(MainFrame, 12)

    -- Header Bar
    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    Header.Text = title or "SwiftUILIB"
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 18
    Header.TextColor3 = Color3.fromRGB(255, 255, 255)
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    roundify(Header, 12)

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    roundify(Sidebar, 12)

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 6)
    SidebarLayout.Parent = Sidebar

    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -140, 1, -40)
    TabContainer.Position = UDim2.new(0, 140, 0, 40)
    TabContainer.BackgroundColor3 = Color3.fromRGB(34, 34, 36)
    TabContainer.BorderSizePixel = 0
    TabContainer.ClipsDescendants = true
    TabContainer.Parent = MainFrame
    roundify(TabContainer, 12)

    local tabs = {}
    local currentTab = nil

    function UI:Tab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -10, 0, 40)
        tabButton.Text = name
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 14
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        tabButton.BorderSizePixel = 0
        tabButton.Parent = Sidebar
        roundify(tabButton, 8)

        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.ScrollBarThickness = 6
        contentFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 36)
        contentFrame.BorderSizePixel = 0
        contentFrame.Visible = false
        contentFrame.Parent = TabContainer

        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)
        layout.Parent = contentFrame

        tabs[name] = contentFrame

        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                TweenService:Create(currentTab, TweenInfo.new(0.3), {Visible = false}):Play()
            end
            contentFrame.Visible = true
            currentTab = contentFrame
        end)

        local TabAPI = {}

        function TabAPI:Button(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -12, 0, 40)
            btn.Text = text
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 52)
            btn.BorderSizePixel = 0
            btn.Parent = contentFrame
            roundify(btn, 8)

            btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        return TabAPI
    end

    return UI
end

return Swift
