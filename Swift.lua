local UILib = {}

local function createDraggableFrame(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MyUILib"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 400, 0, 300)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Frame.Active = true
    Frame.Draggable = true

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Title.Text = title or "My UI Library"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Parent = Frame

    return Frame
end

function UILib:CreateWindow(settings)
    local self = {}
    local frame = createDraggableFrame(settings.Title or "Window")
    self.Frame = frame

    function self:Button(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.Position = UDim2.new(0, 10, 0, 50 + (#frame:GetChildren() - 1) * 45)
        btn.Text = name or "Button"
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 18
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.BorderSizePixel = 0
        btn.Parent = frame
        btn.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
    end

    return self
end

return UILib
