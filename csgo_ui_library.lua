--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              CSGO-Style UI Library v1.0                   ║
    ║              Professional Cheat Menu Interface            ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Usage:
    local Library = loadstring(game:HttpGet("YOUR_URL_HERE"))()
    
    local Window = Library:CreateWindow({
        Title = "My Cheat",
        Size = UDim2.new(0, 600, 0, 400),
        Theme = "Dark" -- "Dark" or "Light"
    })
    
    local Tab = Window:AddTab("Aimbot")
    
    Tab:AddToggle({
        Name = "Enable Aimbot",
        Default = false,
        Callback = function(value)
            print("Aimbot:", value)
        end
    })
    
    Tab:AddSlider({
        Name = "FOV",
        Min = 0,
        Max = 360,
        Default = 90,
        Callback = function(value)
            print("FOV:", value)
        end
    })
    
    Tab:AddDropdown({
        Name = "Target Part",
        Options = {"Head", "Torso", "Random"},
        Default = "Head",
        Callback = function(option)
            print("Target:", option)
        end
    })
    
    Tab:AddButton({
        Name = "Execute",
        Callback = function()
            print("Button clicked!")
        end
    })
    
    Tab:AddInput({
        Name = "Whitelist",
        Placeholder = "Enter username...",
        Callback = function(text)
            print("Input:", text)
        end
    })
    
    Tab:AddColorPicker({
        Name = "ESP Color",
        Default = Color3.fromRGB(255, 0, 0),
        Callback = function(color)
            print("Color:", color)
        end
    })
]]

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Utility Functions
local function Tween(instance, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragFrame)
    local dragging = false
    local dragInput, dragStart, startPos
    
    dragFrame = dragFrame or frame
    
    dragFrame.InputBegan:Connect(function(input)
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
    
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(frame, {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }, 0.1, Enum.EasingStyle.Linear)
        end
    end)
end

local function RippleEffect(button, clickPos)
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, clickPos.X, 0, clickPos.Y)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.5
    ripple.BorderSizePixel = 0
    ripple.ZIndex = 10
    ripple.Parent = button
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = ripple
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    Tween(ripple, {
        Size = UDim2.new(0, size, 0, size),
        BackgroundTransparency = 1
    }, 0.5)
    
    game:GetService("Debris"):AddItem(ripple, 0.5)
end

-- Theme System
local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(30, 30, 35),
        Accent = Color3.fromRGB(70, 130, 255),
        AccentHover = Color3.fromRGB(90, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(40, 40, 45),
        Success = Color3.fromRGB(80, 200, 120),
        Warning = Color3.fromRGB(255, 170, 50),
        Error = Color3.fromRGB(255, 80, 80),
        Shadow = Color3.fromRGB(0, 0, 0)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 245),
        Secondary = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(60, 120, 240),
        AccentHover = Color3.fromRGB(80, 140, 255),
        Text = Color3.fromRGB(20, 20, 25),
        TextDark = Color3.fromRGB(100, 100, 105),
        Border = Color3.fromRGB(220, 220, 225),
        Success = Color3.fromRGB(60, 180, 100),
        Warning = Color3.fromRGB(240, 150, 30),
        Error = Color3.fromRGB(240, 60, 60),
        Shadow = Color3.fromRGB(0, 0, 0)
    }
}

-- Create Window
function Library:CreateWindow(config)
    config = config or {}
    local WindowTitle = config.Title or "UI Library"
    local WindowSize = config.Size or UDim2.new(0, 600, 0, 400)
    local ThemeName = config.Theme or "Dark"
    local Theme = Themes[ThemeName] or Themes.Dark
    
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Theme = Theme
    }
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CSGOLibrary"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = WindowSize
    MainFrame.Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Shadow.ImageColor3 = Theme.Shadow
    Shadow.ImageTransparency = 0.7
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Theme.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    local TopBarCover = Instance.new("Frame")
    TopBarCover.Size = UDim2.new(1, 0, 0, 8)
    TopBarCover.Position = UDim2.new(0, 0, 1, -8)
    TopBarCover.BackgroundColor3 = Theme.Secondary
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = WindowTitle
    Title.TextColor3 = Theme.Text
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Theme.Text
    CloseButton.TextSize = 24
    CloseButton.Parent = TopBar
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundTransparency = 0.9}, 0.2)
        CloseButton.BackgroundColor3 = Theme.Error
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundTransparency = 1}, 0.2)
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -50)
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -170, 1, -50)
    ContentContainer.Position = UDim2.new(0, 165, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = MainFrame
    
    -- Make Draggable
    MakeDraggable(MainFrame, TopBar)
    
    -- Add Tab Function
    function Window:AddTab(tabName)
        local Tab = {
            Name = tabName,
            Elements = {},
            Window = Window
        }
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = Theme.Secondary
        TabButton.BorderSizePixel = 0
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = "  " .. tabName
        TabButton.TextColor3 = Theme.TextDark
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 8)
        ContentList.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingLeft = UDim.new(0, 5)
        ContentPadding.PaddingRight = UDim.new(0, 5)
        ContentPadding.PaddingTop = UDim.new(0, 5)
        ContentPadding.Parent = TabContent
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Button, {
                    BackgroundColor3 = Theme.Secondary,
                    TextColor3 = Theme.TextDark
                }, 0.2)
                tab.Content.Visible = false
            end
            
            Tween(TabButton, {
                BackgroundColor3 = Theme.Accent,
                TextColor3 = Theme.Text
            }, 0.2)
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Theme.Border}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Theme.Secondary}, 0.2)
            end
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        
        table.insert(Window.Tabs, Tab)
        
        -- Select first tab by default
        if #Window.Tabs == 1 then
            TabButton.BackgroundColor3 = Theme.Accent
            TabButton.TextColor3 = Theme.Text
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end
        
        -- Add Toggle
        function Tab:AddToggle(config)
            config = config or {}
            local ToggleName = config.Name or "Toggle"
            local Default = config.Default or false
            local Callback = config.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
            ToggleFrame.BackgroundColor3 = Theme.Secondary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.Text = ToggleName
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 44, 0, 24)
            ToggleButton.Position = UDim2.new(1, -54, 0.5, -12)
            ToggleButton.BackgroundColor3 = Theme.Border
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
            ToggleCircle.Position = UDim2.new(0, 3, 0.5, -9)
            ToggleCircle.BackgroundColor3 = Theme.Text
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local toggled = Default
            
            local function UpdateToggle(state)
                toggled = state
                if toggled then
                    Tween(ToggleButton, {BackgroundColor3 = Theme.Accent}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -21, 0.5, -9)}, 0.2)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Theme.Border}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.2)
                end
                Callback(toggled)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                UpdateToggle(not toggled)
            end)
            
            UpdateToggle(Default)
            
            return {
                Set = UpdateToggle
            }
        end
        
        -- Add Button
        function Tab:AddButton(config)
            config = config or {}
            local ButtonName = config.Name or "Button"
            local Callback = config.Callback or function() end
            
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Size = UDim2.new(1, -10, 0, 40)
            ButtonFrame.BackgroundColor3 = Theme.Accent
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.Font = Enum.Font.GothamBold
            ButtonFrame.Text = ButtonName
            ButtonFrame.TextColor3 = Theme.Text
            ButtonFrame.TextSize = 14
            ButtonFrame.ClipsDescendants = true
            ButtonFrame.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = ButtonFrame
            
            ButtonFrame.MouseButton1Click:Connect(function()
                local mousePos = UserInputService:GetMouseLocation()
                local buttonPos = ButtonFrame.AbsolutePosition
                local relativePos = Vector2.new(mousePos.X - buttonPos.X, mousePos.Y - buttonPos.Y - 36)
                RippleEffect(ButtonFrame, relativePos)
                Callback()
            end)
            
            ButtonFrame.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Theme.AccentHover}, 0.2)
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Accent}, 0.2)
            end)
        end
        
        -- Add Slider
        function Tab:AddSlider(config)
            config = config or {}
            local SliderName = config.Name or "Slider"
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or Min
            local Increment = config.Increment or 1
            local Callback = config.Callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -10, 0, 60)
            SliderFrame.BackgroundColor3 = Theme.Secondary
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -24, 0, 20)
            SliderLabel.Position = UDim2.new(0, 12, 0, 8)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.Text = SliderName
            SliderLabel.TextColor3 = Theme.Text
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 20)
            SliderValue.Position = UDim2.new(1, -62, 0, 8)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.Text = tostring(Default)
            SliderValue.TextColor3 = Theme.Accent
            SliderValue.TextSize = 14
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -24, 0, 6)
            SliderBar.Position = UDim2.new(0, 12, 1, -18)
            SliderBar.BackgroundColor3 = Theme.Border
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.BackgroundColor3 = Theme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local SliderDot = Instance.new("Frame")
            SliderDot.Size = UDim2.new(0, 16, 0, 16)
            SliderDot.Position = UDim2.new(0, -8, 0.5, -8)
            SliderDot.BackgroundColor3 = Theme.Text
            SliderDot.BorderSizePixel = 0
            SliderDot.Parent = SliderFill
            
            local DotCorner = Instance.new("UICorner")
            DotCorner.CornerRadius = UDim.new(1, 0)
            DotCorner.Parent = SliderDot
            
            local dragging = false
            local value = Default
            
            local function UpdateSlider(val)
                value = math.clamp(math.floor((val / Increment) + 0.5) * Increment, Min, Max)
                local percent = (value - Min) / (Max - Min)
                
                SliderValue.Text = tostring(value)
                Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1, Enum.EasingStyle.Linear)
                Callback(value)
            end
            
            local function OnInput(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local pos = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                    local val = Min + ((Max - Min) * pos)
                    UpdateSlider(val)
                end
            end
            
            SliderBar.InputBegan:Connect(OnInput)
            SliderDot.InputBegan:Connect(OnInput)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                    local val = Min + ((Max - Min) * pos)
                    UpdateSlider(val)
                end
            end)
            
            UpdateSlider(Default)
            
            return {
                Set = UpdateSlider
            }
        end
        
        -- Add Dropdown
        function Tab:AddDropdown(config)
            config = config or {}
            local DropdownName = config.Name or "Dropdown"
            local Options = config.Options or {"Option 1", "Option 2"}
            local Default = config.Default or Options[1]
            local Callback = config.Callback or function() end
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, -10, 0, 40)
            DropdownFrame.BackgroundColor3 = Theme.Secondary
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = false
            DropdownFrame.ZIndex = 2
            DropdownFrame.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -40, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.Text = DropdownName
            DropdownLabel.TextColor3 = Theme.Text
            DropdownLabel.TextSize = 14
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 1, 0)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = DropdownFrame
            
            local DropdownValue = Instance.new("TextLabel")
            DropdownValue.Size = UDim2.new(0, 100, 1, 0)
            DropdownValue.Position = UDim2.new(1, -112, 0, 0)
            DropdownValue.BackgroundTransparency = 1
            DropdownValue.Font = Enum.Font.Gotham
            DropdownValue.Text = Default
            DropdownValue.TextColor3 = Theme.Accent
            DropdownValue.TextSize = 13
            DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
            DropdownValue.Parent = DropdownFrame
            
            local DropdownIcon = Instance.new("TextLabel")
            DropdownIcon.Size = UDim2.new(0, 20, 1, 0)
            DropdownIcon.Position = UDim2.new(1, -25, 0, 0)
            DropdownIcon.BackgroundTransparency = 1
            DropdownIcon.Font = Enum.Font.GothamBold
            DropdownIcon.Text = "▼"
            DropdownIcon.TextColor3 = Theme.TextDark
            DropdownIcon.TextSize = 10
            DropdownIcon.Parent = DropdownFrame
            
            local DropdownContainer = Instance.new("Frame")
            DropdownContainer.Size = UDim2.new(1, 0, 0, 0)
            DropdownContainer.Position = UDim2.new(0, 0, 1, 5)
            DropdownContainer.BackgroundColor3 = Theme.Secondary
            DropdownContainer.BorderSizePixel = 0
            DropdownContainer.ClipsDescendants = true
            DropdownContainer.Visible = false
            DropdownContainer.ZIndex = 3
            DropdownContainer.Parent = DropdownFrame
            
            local DropdownContainerCorner = Instance.new("UICorner")
            DropdownContainerCorner.CornerRadius = UDim.new(0, 6)
            DropdownContainerCorner.Parent = DropdownContainer
            
            local DropdownList = Instance.new("UIListLayout")
            DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownList.Padding = UDim.new(0, 2)
            DropdownList.Parent = DropdownContainer
            
            local DropdownPadding = Instance.new("UIPadding")
            DropdownPadding.PaddingTop = UDim.new(0, 5)
            DropdownPadding.PaddingBottom = UDim.new(0, 5)
            DropdownPadding.Parent = DropdownContainer
            
            local isOpen = false
            local selectedOption = Default
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    DropdownContainer.Visible = true
                    Tween(DropdownContainer, {Size = UDim2.new(1, 0, 0, (#Options * 32) + 10)}, 0.2)
                    Tween(DropdownIcon, {Rotation = 180}, 0.2)
                else
                    Tween(DropdownContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    Tween(DropdownIcon, {Rotation = 0}, 0.2)
                    task.wait(0.2)
                    DropdownContainer.Visible = false
                end
            end)
            
            for _, option in ipairs(Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, -10, 0, 30)
                OptionButton.BackgroundColor3 = option == selectedOption and Theme.Accent or Theme.Background
                OptionButton.BorderSizePixel = 0
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = "  " .. option
                OptionButton.TextColor3 = Theme.Text
                OptionButton.TextSize = 13
                OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                OptionButton.AutoButtonColor = false
                OptionButton.ZIndex = 4
                OptionButton.Parent = DropdownContainer
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 4)
                OptionCorner.Parent = OptionButton
                
                OptionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    DropdownValue.Text = option
                    
                    for _, child in ipairs(DropdownContainer:GetChildren()) do
                        if child:IsA("TextButton") then
                            Tween(child, {BackgroundColor3 = Theme.Background}, 0.2)
                        end
                    end
                    
                    Tween(OptionButton, {BackgroundColor3 = Theme.Accent}, 0.2)
                    
                    isOpen = false
                    Tween(DropdownContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    Tween(DropdownIcon, {Rotation = 0}, 0.2)
                    task.wait(0.2)
                    DropdownContainer.Visible = false
                    
                    Callback(option)
                end)
                
                OptionButton.MouseEnter:Connect(function()
                    if option ~= selectedOption then
                        Tween(OptionButton, {BackgroundColor3 = Theme.Border}, 0.2)
                    end
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    if option ~= selectedOption then
                        Tween(OptionButton, {BackgroundColor3 = Theme.Background}, 0.2)
                    end
                end)
            end
            
            Callback(Default)
            
            return {
                Set = function(option)
                    if table.find(Options, option) then
                        selectedOption = option
                        DropdownValue.Text = option
                        
                        for _, child in ipairs(DropdownContainer:GetChildren()) do
                            if child:IsA("TextButton") then
                                if child.Text:match("%s*(.+)") == option then
                                    Tween(child, {BackgroundColor3 = Theme.Accent}, 0.2)
                                else
                                    Tween(child, {BackgroundColor3 = Theme.Background}, 0.2)
                                end
                            end
                        end
                        
                        Callback(option)
                    end
                end
            }
        end
        
        -- Add Input
        function Tab:AddInput(config)
            config = config or {}
            local InputName = config.Name or "Input"
            local Placeholder = config.Placeholder or "Enter text..."
            local Default = config.Default or ""
            local Callback = config.Callback or function() end
            
            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(1, -10, 0, 70)
            InputFrame.BackgroundColor3 = Theme.Secondary
            InputFrame.BorderSizePixel = 0
            InputFrame.Parent = TabContent
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 6)
            InputCorner.Parent = InputFrame
            
            local InputLabel = Instance.new("TextLabel")
            InputLabel.Size = UDim2.new(1, -24, 0, 20)
            InputLabel.Position = UDim2.new(0, 12, 0, 8)
            InputLabel.BackgroundTransparency = 1
            InputLabel.Font = Enum.Font.Gotham
            InputLabel.Text = InputName
            InputLabel.TextColor3 = Theme.Text
            InputLabel.TextSize = 14
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left
            InputLabel.Parent = InputFrame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(1, -24, 0, 32)
            InputBox.Position = UDim2.new(0, 12, 1, -40)
            InputBox.BackgroundColor3 = Theme.Background
            InputBox.BorderSizePixel = 0
            InputBox.Font = Enum.Font.Gotham
            InputBox.PlaceholderText = Placeholder
            InputBox.PlaceholderColor3 = Theme.TextDark
            InputBox.Text = Default
            InputBox.TextColor3 = Theme.Text
            InputBox.TextSize = 13
            InputBox.TextXAlignment = Enum.TextXAlignment.Left
            InputBox.ClearTextOnFocus = false
            InputBox.Parent = InputFrame
            
            local InputBoxCorner = Instance.new("UICorner")
            InputBoxCorner.CornerRadius = UDim.new(0, 4)
            InputBoxCorner.Parent = InputBox
            
            local InputBoxPadding = Instance.new("UIPadding")
            InputBoxPadding.PaddingLeft = UDim.new(0, 8)
            InputBoxPadding.PaddingRight = UDim.new(0, 8)
            InputBoxPadding.Parent = InputBox
            
            InputBox.FocusLost:Connect(function(enterPressed)
                Callback(InputBox.Text)
            end)
            
            InputBox.Focused:Connect(function()
                Tween(InputBox, {BackgroundColor3 = Theme.Border}, 0.2)
            end)
            
            InputBox.FocusLost:Connect(function()
                Tween(InputBox, {BackgroundColor3 = Theme.Background}, 0.2)
            end)
            
            return {
                Set = function(text)
                    InputBox.Text = text
                    Callback(text)
                end
            }
        end
        
        -- Add ColorPicker
        function Tab:AddColorPicker(config)
            config = config or {}
            local ColorName = config.Name or "Color Picker"
            local Default = config.Default or Color3.fromRGB(255, 0, 0)
            local Callback = config.Callback or function() end
            
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Size = UDim2.new(1, -10, 0, 40)
            ColorFrame.BackgroundColor3 = Theme.Secondary
            ColorFrame.BorderSizePixel = 0
            ColorFrame.Parent = TabContent
            
            local ColorCorner = Instance.new("UICorner")
            ColorCorner.CornerRadius = UDim.new(0, 6)
            ColorCorner.Parent = ColorFrame
            
            local ColorLabel = Instance.new("TextLabel")
            ColorLabel.Size = UDim2.new(1, -60, 1, 0)
            ColorLabel.Position = UDim2.new(0, 12, 0, 0)
            ColorLabel.BackgroundTransparency = 1
            ColorLabel.Font = Enum.Font.Gotham
            ColorLabel.Text = ColorName
            ColorLabel.TextColor3 = Theme.Text
            ColorLabel.TextSize = 14
            ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
            ColorLabel.Parent = ColorFrame
            
            local ColorDisplay = Instance.new("Frame")
            ColorDisplay.Size = UDim2.new(0, 40, 0, 24)
            ColorDisplay.Position = UDim2.new(1, -50, 0.5, -12)
            ColorDisplay.BackgroundColor3 = Default
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Parent = ColorFrame
            
            local ColorDisplayCorner = Instance.new("UICorner")
            ColorDisplayCorner.CornerRadius = UDim.new(0, 4)
            ColorDisplayCorner.Parent = ColorDisplay
            
            local ColorButton = Instance.new("TextButton")
            ColorButton.Size = UDim2.new(1, 0, 1, 0)
            ColorButton.BackgroundTransparency = 1
            ColorButton.Text = ""
            ColorButton.Parent = ColorDisplay
            
            local selectedColor = Default
            
            ColorButton.MouseButton1Click:Connect(function()
                -- Simple RGB input dialog
                local r = math.floor(selectedColor.R * 255)
                local g = math.floor(selectedColor.G * 255)
                local b = math.floor(selectedColor.B * 255)
                
                -- You could implement a color picker UI here
                -- For now, this is a placeholder
                print(string.format("Current Color: RGB(%d, %d, %d)", r, g, b))
                print("Color picker UI would open here")
            end)
            
            Callback(Default)
            
            return {
                Set = function(color)
                    selectedColor = color
                    ColorDisplay.BackgroundColor3 = color
                    Callback(color)
                end
            }
        end
        
        -- Add Label
        function Tab:AddLabel(text)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Size = UDim2.new(1, -10, 0, 30)
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -24, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Theme.TextDark
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.Parent = LabelFrame
            
            return {
                Set = function(newText)
                    Label.Text = newText
                end
            }
        end
        
        -- Add Divider
        function Tab:AddDivider()
            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, -10, 0, 1)
            Divider.BackgroundColor3 = Theme.Border
            Divider.BorderSizePixel = 0
            Divider.Parent = TabContent
        end
        
        return Tab
    end
    
    -- Notification System
    function Window:Notify(config)
        config = config or {}
        local Title = config.Title or "Notification"
        local Content = config.Content or "Notification content"
        local Duration = config.Duration or 3
        
        local NotifContainer = ScreenGui:FindFirstChild("NotificationContainer")
        if not NotifContainer then
            NotifContainer = Instance.new("Frame")
            NotifContainer.Name = "NotificationContainer"
            NotifContainer.Size = UDim2.new(0, 300, 1, 0)
            NotifContainer.Position = UDim2.new(1, -310, 0, 10)
            NotifContainer.BackgroundTransparency = 1
            NotifContainer.Parent = ScreenGui
            
            local NotifList = Instance.new("UIListLayout")
            NotifList.SortOrder = Enum.SortOrder.LayoutOrder
            NotifList.Padding = UDim.new(0, 10)
            NotifList.Parent = NotifContainer
        end
        
        local Notif = Instance.new("Frame")
        Notif.Size = UDim2.new(1, 0, 0, 0)
        Notif.BackgroundColor3 = Theme.Secondary
        Notif.BorderSizePixel = 0
        Notif.ClipsDescendants = true
        Notif.Parent = NotifContainer
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 6)
        NotifCorner.Parent = Notif
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -20, 0, 20)
        NotifTitle.Position = UDim2.new(0, 10, 0, 8)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.Text = Title
        NotifTitle.TextColor3 = Theme.Text
        NotifTitle.TextSize = 14
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.Parent = Notif
        
        local NotifContent = Instance.new("TextLabel")
        NotifContent.Size = UDim2.new(1, -20, 1, -36)
        NotifContent.Position = UDim2.new(0, 10, 0, 28)
        NotifContent.BackgroundTransparency = 1
        NotifContent.Font = Enum.Font.Gotham
        NotifContent.Text = Content
        NotifContent.TextColor3 = Theme.TextDark
        NotifContent.TextSize = 12
        NotifContent.TextXAlignment = Enum.TextXAlignment.Left
        NotifContent.TextYAlignment = Enum.TextYAlignment.Top
        NotifContent.TextWrapped = true
        NotifContent.Parent = Notif
        
        Tween(Notif, {Size = UDim2.new(1, 0, 0, 70)}, 0.3)
        
        task.delay(Duration, function()
            Tween(Notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
            task.wait(0.3)
            Notif:Destroy()
        end)
    end
    
    return Window
end

return Library
