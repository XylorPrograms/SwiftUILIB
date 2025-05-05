-- SwiftUILIB (Modern Sidebar UI Inspired by Fluent)
-- Version 2.0 Redesign
-- Author: XylorPrograms

local Swift = {}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function Swift:CreateWindow(title)
    local UI = {}

    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SwiftUILIB"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 120, 1, 0)
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.Parent = Sidebar

    -- Tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -120, 1, 0)
    TabContainer.Position = UDim2.new(0, 120, 0, 0)
    TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame

    local tabs = {}
    local currentTab = nil

    function UI:Tab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.Text = name
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        tabButton.BorderSizePixel = 0
        tabButton.Parent = Sidebar

        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.ScrollBarThickness = 6
        contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        contentFrame.BorderSizePixel = 0
        contentFrame.Visible = false
        contentFrame.Parent = TabContainer

        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        layout.Parent = contentFrame

        tabs[name] = contentFrame

        tabButton.MouseButton1Click:Connect(function()
            if currentTab then currentTab.Visible = false end
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
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.BorderSizePixel = 0
            btn.Parent = contentFrame

            btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        return TabAPI
    end

    return UI
end

return Swift
