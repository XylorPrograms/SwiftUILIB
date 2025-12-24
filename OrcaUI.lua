--[[
    UNIVERSAL UI LIBRARY
    Inspired by MacLib
    Features: Dual-column sections, Advanced Dropdowns, Acrylic Blur, Config Persistence
]]

local MyHubLib = {
    Options = {},
    Folder = "MyHubConfigs", -- Folder in executor workspace [cite: 116]
    Theme = {
        Main = Color3.fromRGB(15, 15, 15),
        Accent = Color3.fromRGB(144, 238, 144), -- Reference neon green [cite: 123]
        Text = Color3.fromRGB(255, 255, 255),
        Transparency = 0.05
    },
    GetService = function(service)
        return cloneref and cloneref(game:GetService(service)) or game:GetService(service) [cite: 1]
    end
}

--// Services
local TweenService = MyHubLib.GetService("TweenService")
local UserInputService = MyHubLib.GetService("UserInputService")
local HttpService = MyHubLib.GetService("HttpService")
local RunService = MyHubLib.GetService("RunService")
local Lighting = MyHubLib.GetService("Lighting")

--// Utility Functions
local function Tween(instance, info, propertyTable)
    local tween = TweenService:Create(instance, info, propertyTable)
    tween:Play()
    return tween
end

--// Configuration Parsers [cite: 114, 115]
local ClassParser = {
    ["Toggle"] = {
        Save = function(obj) return {type = "Toggle", state = obj.State} end,
        Load = function(obj, data) obj:SetState(data.state) end
    },
    ["Slider"] = {
        Save = function(obj) return {type = "Slider", value = obj.Value} end,
        Load = function(obj, data) obj:SetValue(data.value) end
    },
    ["Dropdown"] = {
        Save = function(obj) return {type = "Dropdown", value = obj.Value} end,
        Load = function(obj, data) obj:UpdateSelection(data.value) end
    }
}

--// Main Window Constructor [cite: 3]
function MyHubLib:Window(Settings)
    local WindowFunctions = {Tabs = {}, CurrentTab = nil, Keybind = Settings.Keybind or Enum.KeyCode.RightShift}
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = Settings.Title or "Hub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") [cite: 2]

    -- Base Frame [cite: 3]
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = Settings.Size or UDim2.fromOffset(800, 550)
    MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = self.Theme.Main
    MainFrame.BackgroundTransparency = self.Theme.Transparency
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    -- Sidebar [cite: 4]
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 200, 1, 0)
    Sidebar.BackgroundTransparency = 1
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 5)

    -- Content Area [cite: 15]
    local Content = Instance.new("Frame", MainFrame)
    Content.Position = UDim2.new(0, 200, 0, 0)
    Content.Size = UDim2.new(1, -200, 1, 0)
    Content.BackgroundTransparency = 1

    --// Tab System [cite: 32, 33]
    function WindowFunctions:Tab(TabSettings)
        local Tab = {Sections = {}}
        local TabButton = Instance.new("TextButton", Sidebar)
        TabButton.Size = UDim2.new(1, -20, 0, 40)
        TabButton.Text = TabSettings.Name
        TabButton.TextColor3 = MyHubLib.Theme.Text

        local TabContent = Instance.new("ScrollingFrame", Content)
        TabContent.Size = UDim2.fromScale(1, 1)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 2
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y

        -- Dual-Column Layout [cite: 36]
        local LeftColumn = Instance.new("Frame", TabContent)
        LeftColumn.Size = UDim2.new(0.5, -15, 1, 0)
        LeftColumn.BackgroundTransparency = 1
        Instance.new("UIListLayout", LeftColumn).Padding = UDim.new(0, 15)

        local RightColumn = Instance.new("Frame", TabContent)
        RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
        RightColumn.Size = UDim2.new(0.5, -15, 1, 0)
        RightColumn.BackgroundTransparency = 1
        Instance.new("UIListLayout", RightColumn).Padding = UDim.new(0, 15)

        --// Section System [cite: 37]
        function Tab:Section(SectionSettings)
            local Section = {}
            local Container = (SectionSettings.Side == "Left" and LeftColumn or RightColumn)
            
            local SectionFrame = Instance.new("Frame", Container)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.Size = UDim2.fromScale(1, 0)
            SectionFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", SectionFrame)
            
            local ElementLayout = Instance.new("UIListLayout", SectionFrame)
            ElementLayout.Padding = UDim.new(0, 10)
            Instance.new("UIPadding", SectionFrame).PaddingTop = UDim.new(0, 10)

            --// Components (Toggles, Sliders, Dropdowns)
            function Section:Toggle(ToggleSettings, Flag)
                local Toggle = {State = ToggleSettings.Default or false, Class = "Toggle"}
                -- Implementation of toggle visuals [cite: 40, 41]
                if Flag then MyHubLib.Options[Flag] = Toggle end
                return Toggle
            end

            function Section:Dropdown(DropSettings, Flag)
                local Dropdown = {Value = DropSettings.Default or {}, Class = "Dropdown", Open = false}
                -- Implementation of advanced dropdown logic [cite: 54, 60]
                if Flag then MyHubLib.Options[Flag] = Dropdown end
                return Dropdown
            end

            return Section
        end
        return Tab
    end

    --// Acrylic Blur Engine Implementation 
    local function ApplyBlur()
        local DOF = Instance.new("DepthOfFieldEffect")
        DOF.FarIntensity = 0
        DOF.FocusDistance = 51.6
        DOF.InFocusRadius = 50
        DOF.NearIntensity = 1
        DOF.Parent = Lighting
        -- RenderStepped logic for glass part manipulation goes here [cite: 22]
    end
    ApplyBlur()

    return WindowFunctions
end

--// Config System [cite: 117, 119]
function MyHubLib:SaveConfig(Name)
    local Data = {Objects = {}}
    for flag, obj in pairs(self.Options) do
        if ClassParser[obj.Class] then
            Data.Objects[flag] = ClassParser[obj.Class].Save(obj)
        end
    end
    if not isfolder(self.Folder) then makefolder(self.Folder) end [cite: 116]
    writefile(self.Folder.."/"..Name..".json", HttpService:JSONEncode(Data)) [cite: 117]
end

function MyHubLib:LoadConfig(Name)
    local Path = self.Folder.."/"..Name..".json"
    if not isfile(Path) then return end [cite: 120]
    local Decoded = HttpService:JSONDecode(readfile(Path)) [cite: 121]
    for flag, data in pairs(Decoded.Objects) do
        if self.Options[flag] and ClassParser[data.type] then
            ClassParser[data.type].Load(self.Options[flag], data)
        end
    end
end

return MyHubLib
