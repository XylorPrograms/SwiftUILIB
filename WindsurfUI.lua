--[[
    WindsurfUI Library
    
    A modern, feature-rich UI library for Roblox exploit development
    Inspired by Rayfield and other modern UI libraries
]]

local WindsurfUI = {}
WindsurfUI.__index = WindsurfUI

-- Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")

-- Constants
local TWEEN_SPEED = 0.25
local FONT = Enum.Font.GothamSemibold
local TEXT_SIZE = 14
local CORNER_RADIUS = UDim.new(0, 4)
local DEFAULT_THEME = {
    Background = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(0, 170, 255),
    LightContrast = Color3.fromRGB(35, 35, 35),
    DarkContrast = Color3.fromRGB(20, 20, 20),
    TextColor = Color3.fromRGB(240, 240, 240),
    PlaceholderColor = Color3.fromRGB(180, 180, 180)
}

-- UI Elements Storage
local Elements = {}
local ActiveWindow = nil

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

local function CreateCorner(parent, radius)
    local corner = Create("UICorner")({
        CornerRadius = radius or CORNER_RADIUS,
        Parent = parent
    })
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Create("UIStroke")({
        Color = color or Color3.fromRGB(50, 50, 50),
        Thickness = thickness or 1,
        Parent = parent
    })
    return stroke
end

-- Dragging Functionality
local function EnableDragging(frame)
    local dragging, dragInput, dragStart, startPos
    
    local function UpdatePosition(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            UpdatePosition(input)
        end
    end)
end

-- Initialize the UI library
function WindsurfUI.new(config)
    local config = config or {}
    local theme = config.Theme or DEFAULT_THEME
    
    -- Create main UI container
    local wsUI = {}
    setmetatable(wsUI, WindsurfUI)
    
    wsUI.Theme = theme
    wsUI.Windows = {}
    
    return wsUI
end
