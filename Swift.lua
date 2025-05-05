-- SwiftUILIB (Advanced UI Redesign v4.5 with Full Component Suite)
-- Author: XylorPrograms | Component Expansion by ChatGPT

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
    stroke.Color = color or Color3.fromRGB(255, 255, 255) -- white for theming
    stroke.Transparency = 0.1
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

    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "SwiftUILIB" then gui:Destroy() end
    end

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

    local contentWrapper = Instance.new("Frame")
    contentWrapper.Size = UDim2.new(1, -150, 1, -30)
    contentWrapper.Position = UDim2.new(0, 150, 0, 30)
    contentWrapper.BackgroundColor3 = Color3.fromRGB(38, 38, 40)
    contentWrapper.Parent = main
    roundify(contentWrapper, 8)
    addStroke(contentWrapper)
    contentWrapper.ClipsDescendants = true

    local pages = Instance.new("Frame")
    pages.Size = UDim2.new(1, 0, 1, 0)
    pages.BackgroundTransparency = 1
    pages.ClipsDescendants = true
    pages.Parent = contentWrapper

    local activeTab, activePage
    local pageCount = 0
    local pageRegistry = {}

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
        addStroke(button)

        local page = Instance.new("ScrollingFrame")
        page.Name = name
        page.Size = UDim2.new(1, 0, 1, 0)
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 6
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.LayoutOrder = pageCount
        page.ClipsDescendants = true
        page.Visible = false
        page.Parent = pages
        pageCount += 1
        pageRegistry[name] = page

        local list = Instance.new("UIListLayout")
        list.Parent = page
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 10)

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 12)
        padding.PaddingRight = UDim.new(0, 12)
        padding.PaddingTop = UDim.new(0, 12)
        padding.Parent = page

        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 24)
        end)

        button.MouseButton1Click:Connect(function()
            if activePage and activePage ~= page then
                TweenService:Create(activePage, TweenInfo.new(0.2), {
                    Rotation = 90,
                    Size = UDim2.new(0, 0, 1, 0)
                }):Play()
                task.wait(0.2)
                activePage.Visible = false
                activePage.Rotation = 0
                activePage.Size = UDim2.new(1, 0, 1, 0)
            end

            page.Visible = true
            page.Size = UDim2.new(0, 0, 1, 0)
            page.Rotation = -90
            TweenService:Create(page, TweenInfo.new(0.2), {
                Rotation = 0,
                Size = UDim2.new(1, 0, 1, 0)
            }):Play()
            activePage = page

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
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.Parent = page
            roundify(btn, 6)
            addStroke(btn)

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

        function api:Label(text)
            local lbl = Instance.new("TextLabel")
            lbl.Text = text
            lbl.Font = Enum.Font.GothamSemibold
            lbl.TextSize = 16
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(1, 0, 0, 28)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = page
        end

        function api:Separator()
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            line.BorderSizePixel = 0
            line.Parent = page
        end

        function api:Toggle(text, default, callback)
            local toggle = Instance.new("TextButton")
            toggle.Text = ""
            toggle.Size = UDim2.new(1, 0, 0, 32)
            toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggle.Parent = page
            roundify(toggle, 6)
            addStroke(toggle)

            local state = default
            local label = Instance.new("TextLabel")
            label.Text = text
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, -50, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = toggle

            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 24, 0, 24)
            indicator.Position = UDim2.new(1, -34, 0.5, -12)
            indicator.BackgroundColor3 = default and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(100, 100, 100)
            indicator.Parent = toggle
            roundify(indicator, 6)
            addStroke(indicator)

            toggle.MouseButton1Click:Connect(function()
                state = not state
                indicator.BackgroundColor3 = state and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(100, 100, 100)
                pcall(callback, state)
            end)
        end

        function api:Slider(text, min, max, default, callback)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, 0, 0, 48)
            holder.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            holder.Parent = page
            roundify(holder, 6)
            addStroke(holder)

            local label = Instance.new("TextLabel")
            label.Text = text .. ": " .. tostring(default)
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.Size = UDim2.new(1, -12, 0, 20)
            label.Position = UDim2.new(0, 6, 0, 4)
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = holder

            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(1, -24, 0, 6)
            sliderBar.Position = UDim2.new(0, 12, 0, 30)
            sliderBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            sliderBar.Parent = holder

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
            fill.BorderSizePixel = 0
            fill.Parent = sliderBar

            local dragging = false

            local function update(input)
                local rel = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                rel = math.clamp(rel, 0, 1)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                local val = math.floor((min + (max - min) * rel) + 0.5)
                label.Text = text .. ": " .. val
                pcall(callback, val)
            end

            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input)
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
        end

        return api
    end

    
        function api:Dropdown(text, options, callback)
            local dropdown = Instance.new("Frame")
            dropdown.Size = UDim2.new(1, 0, 0, 32)
            dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdown.Parent = page
            roundify(dropdown, 6)
            addStroke(dropdown)

            local selected = Instance.new("TextLabel")
            selected.Text = text .. ": [None]"
            selected.Font = Enum.Font.Gotham
            selected.TextSize = 14
            selected.TextColor3 = Color3.fromRGB(255, 255, 255)
            selected.Size = UDim2.new(1, -32, 1, 0)
            selected.Position = UDim2.new(0, 10, 0, 0)
            selected.BackgroundTransparency = 1
            selected.TextXAlignment = Enum.TextXAlignment.Left
            selected.Parent = dropdown

            local dropButton = Instance.new("TextButton")
            dropButton.Text = "▼"
            dropButton.Size = UDim2.new(0, 24, 1, 0)
            dropButton.Position = UDim2.new(1, -28, 0, 0)
            dropButton.BackgroundTransparency = 1
            dropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropButton.Font = Enum.Font.Gotham
            dropButton.TextSize = 14
            dropButton.Parent = dropdown

            local list = Instance.new("Frame")
            list.Visible = false
            list.Size = UDim2.new(1, 0, 0, #options * 28)
            list.Position = UDim2.new(0, 0, 1, 0)
            list.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            list.Parent = dropdown
            addStroke(list)
            roundify(list, 6)

            for _, option in ipairs(options) do
                local btn = Instance.new("TextButton")
                btn.Text = option
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Size = UDim2.new(1, 0, 0, 28)
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                btn.Parent = list
                btn.MouseButton1Click:Connect(function()
                    selected.Text = text .. ": " .. option
                    list.Visible = false
                    callback(option)
                end)
            end

            dropButton.MouseButton1Click:Connect(function()
                list.Visible = not list.Visible
            end)
        end

        function api:MultiDropdown(text, options, callback)
            local dropdown = Instance.new("Frame")
            dropdown.Size = UDim2.new(1, 0, 0, 32)
            dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdown.Parent = page
            roundify(dropdown, 6)
            addStroke(dropdown)

            local selected = {}
            local display = Instance.new("TextLabel")
            display.Text = text .. ": [0 selected]"
            display.Font = Enum.Font.Gotham
            display.TextSize = 14
            display.TextColor3 = Color3.fromRGB(255, 255, 255)
            display.Size = UDim2.new(1, -32, 1, 0)
            display.Position = UDim2.new(0, 10, 0, 0)
            display.BackgroundTransparency = 1
            display.TextXAlignment = Enum.TextXAlignment.Left
            display.Parent = dropdown

            local dropButton = Instance.new("TextButton")
            dropButton.Text = "▼"
            dropButton.Size = UDim2.new(0, 24, 1, 0)
            dropButton.Position = UDim2.new(1, -28, 0, 0)
            dropButton.BackgroundTransparency = 1
            dropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropButton.Font = Enum.Font.Gotham
            dropButton.TextSize = 14
            dropButton.Parent = dropdown

            local list = Instance.new("Frame")
            list.Visible = false
            list.Size = UDim2.new(1, 0, 0, #options * 28)
            list.Position = UDim2.new(0, 0, 1, 0)
            list.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            list.Parent = dropdown
            addStroke(list)
            roundify(list, 6)

            for _, option in ipairs(options) do
                local btn = Instance.new("TextButton")
                btn.Text = "☐ " .. option
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Size = UDim2.new(1, 0, 0, 28)
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                btn.Parent = list
                local selectedFlag = false
                btn.MouseButton1Click:Connect(function()
                    selectedFlag = not selectedFlag
                    if selectedFlag then
                        table.insert(selected, option)
                        btn.Text = "☑ " .. option
                    else
                        for i, v in ipairs(selected) do
                            if v == option then table.remove(selected, i) break end
                        end
                        btn.Text = "☐ " .. option
                    end
                    display.Text = text .. ": [" .. tostring(#selected) .. " selected]"
                    callback(selected)
                end)
            end

            dropButton.MouseButton1Click:Connect(function()
                list.Visible = not list.Visible
            end)
        end

        function api:Textbox(placeholder, callback)
            local box = Instance.new("TextBox")
            box.Text = ""
            box.PlaceholderText = placeholder
            box.Font = Enum.Font.Gotham
            box.TextSize = 14
            box.TextColor3 = Color3.fromRGB(255, 255, 255)
            box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            box.Size = UDim2.new(1, 0, 0, 32)
            box.ClearTextOnFocus = false
            box.Parent = page
            roundify(box, 6)
            addStroke(box)

            box.FocusLost:Connect(function(enter)
                if enter then
                    callback(box.Text)
                end
            end)
        end

    

        return api
    end

    function Swift:Notify(message, duration)
    duration = duration or 4
    local gui = CoreGui:FindFirstChild("SwiftUILIB")
    if not gui then return end

    local toast = Instance.new("TextLabel")
    toast.Text = message
    toast.Size = UDim2.new(0, 300, 0, 40)
    toast.Position = UDim2.new(1, -310, 1, -50)
    toast.AnchorPoint = Vector2.new(0, 1)
    toast.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toast.TextColor3 = Color3.fromRGB(255, 255, 255)
    toast.Font = Enum.Font.GothamSemibold
    toast.TextSize = 14
    toast.TextWrapped = true
    toast.ZIndex = 10
    toast.Parent = gui
    roundify(toast, 10)
    addStroke(toast)

    TweenService:Create(toast, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
    task.delay(duration, function()
        TweenService:Create(toast, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        task.wait(0.25)
        toast:Destroy()
    end)
end

return Swift
