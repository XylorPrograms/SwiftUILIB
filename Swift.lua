-- SwiftUILIB (Advanced UI Redesign v3.5)
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

local function addStroke(obj, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = color or Color3.fromRGB(50, 50, 50)
    stroke.Transparency = 0.4
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
end

function Swift:CreateWindow(title)
    local UI = {}

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SwiftUILIB"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 720, 0, 480)
    MainFrame.Position = UDim2.new(0.5, -360, 0.5, -240)
    MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    MainFrame.Active = true
    MainFrame.Draggable = true
    roundify(MainFrame, 14)
    addStroke(MainFrame)

    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, 0, 0, 44)
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    Header.Text = title or "SwiftUILIB"
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 18
    Header.TextColor3 = Color3.fromRGB(255, 255, 255)
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    roundify(Header, 14)
    addStroke(Header)

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, -44)
    Sidebar.Position = UDim2.new(0, 0, 0, 44)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    roundify(Sidebar, 10)
    addStroke(Sidebar)

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 6)
    SidebarLayout.Parent = Sidebar
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -150, 1, -44)
    TabContainer.Position = UDim2.new(0, 150, 0, 44)
    TabContainer.BackgroundColor3 = Color3.fromRGB(34, 34, 36)
    TabContainer.BorderSizePixel = 0
    TabContainer.ClipsDescendants = true
    TabContainer.Parent = MainFrame
    roundify(TabContainer, 10)
    addStroke(TabContainer)

    local tabs = {}
    local currentTab = nil
    local activeButton = nil

    function UI:Tab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -20, 0, 40)
        tabButton.Text = name
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 14
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        tabButton.BorderSizePixel = 0
        tabButton.Parent = Sidebar
        roundify(tabButton, 8)
        addStroke(tabButton)

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
        layout.Padding = UDim.new(0, 10)
        layout.Parent = contentFrame

        tabs[name] = contentFrame

        tabButton.MouseButton1Click:Connect(function()
            if currentTab then currentTab.Visible = false end
            if activeButton then
                TweenService:Create(activeButton, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(28, 28, 30)
                }):Play()
            end
            TweenService:Create(tabButton, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(40, 90, 255)
            }):Play()
            activeButton = tabButton
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
            addStroke(btn)

            -- Hover animation
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 62)
                }):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(50, 50, 52)
                }):Play()
            end)

            btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        return TabAPI
    end

    return UI
end

return Swift
