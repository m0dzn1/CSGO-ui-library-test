--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║          Authentic CSGO Cheat Menu UI Library             ║
    ║          Exact recreation of professional cheat UI        ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Usage:
    local Library = loadstring(game:HttpGet("YOUR_URL"))()
    
    local Window = Library:CreateWindow({
        Title = "CHEAT.COM - VERSION!",
        Size = UDim2.new(0, 700, 0, 500)
    })
    
    local MainTab = Window:AddTab("RAGEBOT")
    local SubTab = MainTab:AddSubTab("AIMBOT")
    
    SubTab:AddCheckbox("AUTO FIRE", false, function(v) end)
    SubTab:AddSlider("MIN DAMAGE", 0, 100, 34, function(v) end)
    SubTab:AddDropdown("MULTIBOX", {"NONE", "OPTION1"}, function(v) end)
]]

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Colors matching CSGO cheat menu
local Colors = {
    Background = Color3.fromRGB(25, 27, 29),
    TopBar = Color3.fromRGB(18, 20, 22),
    TabBar = Color3.fromRGB(22, 24, 26),
    SubTabBar = Color3.fromRGB(28, 30, 32),
    ActiveTab = Color3.fromRGB(45, 140, 195),
    InactiveTab = Color3.fromRGB(35, 37, 39),
    Border = Color3.fromRGB(15, 17, 19),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Checkmark = Color3.fromRGB(160, 160, 160),
    SliderFill = Color3.fromRGB(55, 120, 175),
    SliderBackground = Color3.fromRGB(35, 37, 39),
    DropdownArrow = Color3.fromRGB(140, 140, 140)
}

-- Utility Functions
local function Tween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.15, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragFrame)
    local dragging, dragInput, dragStart, startPos
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
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Create Window
function Library:CreateWindow(config)
    config = config or {}
    local WindowTitle = config.Title or "CHEAT.COM - VERSION!"
    local WindowSize = config.Size or UDim2.new(0, 700, 0, 500)
    
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        CurrentSubTab = nil
    }
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CSGOCheatMenu"
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
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderColor3 = Colors.Border
    MainFrame.BorderSizePixel = 1
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 28)
    TopBar.BackgroundColor3 = Colors.TopBar
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.Code
    Title.Text = WindowTitle
    Title.TextColor3 = Colors.Text
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Debug Button (Top Right)
    local DebugButton = Instance.new("TextButton")
    DebugButton.Name = "DebugButton"
    DebugButton.Size = UDim2.new(0, 70, 1, 0)
    DebugButton.Position = UDim2.new(1, -70, 0, 0)
    DebugButton.BackgroundTransparency = 1
    DebugButton.Font = Enum.Font.Code
    DebugButton.Text = "▼ DEBUG"
    DebugButton.TextColor3 = Colors.Text
    DebugButton.TextSize = 11
    DebugButton.Parent = TopBar
    
    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1, 0, 0, 30)
    TabBar.Position = UDim2.new(0, 0, 0, 28)
    TabBar.BackgroundColor3 = Colors.TabBar
    TabBar.BorderSizePixel = 0
    TabBar.Parent = MainFrame
    
    local TabBarList = Instance.new("UIListLayout")
    TabBarList.FillDirection = Enum.FillDirection.Horizontal
    TabBarList.SortOrder = Enum.SortOrder.LayoutOrder
    TabBarList.Parent = TabBar
    
    -- Sub Tab Bar
    local SubTabBar = Instance.new("Frame")
    SubTabBar.Name = "SubTabBar"
    SubTabBar.Size = UDim2.new(1, 0, 0, 28)
    SubTabBar.Position = UDim2.new(0, 0, 0, 58)
    SubTabBar.BackgroundColor3 = Colors.SubTabBar
    SubTabBar.BorderSizePixel = 0
    SubTabBar.Visible = false
    SubTabBar.Parent = MainFrame
    
    local SubTabBarList = Instance.new("UIListLayout")
    SubTabBarList.FillDirection = Enum.FillDirection.Horizontal
    SubTabBarList.SortOrder = Enum.SortOrder.LayoutOrder
    SubTabBarList.Padding = UDim.new(0, 2)
    SubTabBarList.Parent = SubTabBar
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, 0, 1, -86)
    ContentContainer.Position = UDim2.new(0, 0, 0, 86)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = MainFrame
    
    MakeDraggable(MainFrame, TopBar)
    
    -- Add Tab Function
    function Window:AddTab(tabName)
        local Tab = {
            Name = tabName,
            SubTabs = {},
            Window = Window
        }
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(0, 110, 1, 0)
        TabButton.BackgroundColor3 = Colors.InactiveTab
        TabButton.BorderSizePixel = 0
        TabButton.Font = Enum.Font.Code
        TabButton.Text = tabName:upper()
        TabButton.TextColor3 = Colors.Text
        TabButton.TextSize = 11
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabBar
        
        Tab.Button = TabButton
        Tab.SubTabBar = SubTabBar
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            -- Deselect all tabs
            for _, tab in pairs(Window.Tabs) do
                tab.Button.BackgroundColor3 = Colors.InactiveTab
                for _, subtab in pairs(tab.SubTabs) do
                    subtab.Button.Visible = false
                    subtab.Content.Visible = false
                end
            end
            
            -- Select this tab
            TabButton.BackgroundColor3 = Colors.ActiveTab
            Window.CurrentTab = Tab
            
            -- Show subtabs
            if #Tab.SubTabs > 0 then
                SubTabBar.Visible = true
                for _, subtab in pairs(Tab.SubTabs) do
                    subtab.Button.Visible = true
                end
                -- Select first subtab
                if Tab.SubTabs[1] then
                    Tab.SubTabs[1].Button.BackgroundColor3 = Colors.ActiveTab
                    Tab.SubTabs[1].Content.Visible = true
                    Window.CurrentSubTab = Tab.SubTabs[1]
                end
            else
                SubTabBar.Visible = false
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        
        -- Select first tab
        if #Window.Tabs == 1 then
            TabButton.BackgroundColor3 = Colors.ActiveTab
            Window.CurrentTab = Tab
        end
        
        -- Add SubTab Function
        function Tab:AddSubTab(subTabName)
            local SubTab = {
                Name = subTabName,
                Elements = {},
                Tab = Tab
            }
            
            -- SubTab Button
            local SubTabButton = Instance.new("TextButton")
            SubTabButton.Name = subTabName
            SubTabButton.Size = UDim2.new(0, 100, 1, 0)
            SubTabButton.BackgroundColor3 = Colors.InactiveTab
            SubTabButton.BorderSizePixel = 0
            SubTabButton.Font = Enum.Font.Code
            SubTabButton.Text = subTabName:upper()
            SubTabButton.TextColor3 = Colors.Text
            SubTabButton.TextSize = 10
            SubTabButton.AutoButtonColor = false
            SubTabButton.Visible = false
            SubTabButton.Parent = SubTabBar
            
            -- SubTab Content (Two Column Layout)
            local SubTabContent = Instance.new("Frame")
            SubTabContent.Name = subTabName .. "Content"
            SubTabContent.Size = UDim2.new(1, 0, 1, 0)
            SubTabContent.BackgroundTransparency = 1
            SubTabContent.Visible = false
            SubTabContent.Parent = ContentContainer
            
            -- Left Column
            local LeftColumn = Instance.new("ScrollingFrame")
            LeftColumn.Name = "LeftColumn"
            LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
            LeftColumn.Position = UDim2.new(0, 5, 0, 0)
            LeftColumn.BackgroundTransparency = 1
            LeftColumn.BorderSizePixel = 0
            LeftColumn.ScrollBarThickness = 2
            LeftColumn.ScrollBarImageColor3 = Colors.SliderFill
            LeftColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
            LeftColumn.Parent = SubTabContent
            
            local LeftList = Instance.new("UIListLayout")
            LeftList.SortOrder = Enum.SortOrder.LayoutOrder
            LeftList.Padding = UDim.new(0, 4)
            LeftList.Parent = LeftColumn
            
            LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                LeftColumn.CanvasSize = UDim2.new(0, 0, 0, LeftList.AbsoluteContentSize.Y + 5)
            end)
            
            -- Right Column
            local RightColumn = Instance.new("ScrollingFrame")
            RightColumn.Name = "RightColumn"
            RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
            RightColumn.Position = UDim2.new(0.5, 0, 0, 0)
            RightColumn.BackgroundTransparency = 1
            RightColumn.BorderSizePixel = 0
            RightColumn.ScrollBarThickness = 2
            RightColumn.ScrollBarImageColor3 = Colors.SliderFill
            RightColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
            RightColumn.Parent = SubTabContent
            
            local RightList = Instance.new("UIListLayout")
            RightList.SortOrder = Enum.SortOrder.LayoutOrder
            RightList.Padding = UDim.new(0, 4)
            RightList.Parent = RightColumn
            
            RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                RightColumn.CanvasSize = UDim2.new(0, 0, 0, RightList.AbsoluteContentSize.Y + 5)
            end)
            
            SubTab.Button = SubTabButton
            SubTab.Content = SubTabContent
            SubTab.LeftColumn = LeftColumn
            SubTab.RightColumn = RightColumn
            SubTab.CurrentColumn = LeftColumn
            
            -- SubTab Selection
            SubTabButton.MouseButton1Click:Connect(function()
                -- Deselect all subtabs
                for _, subtab in pairs(Tab.SubTabs) do
                    subtab.Button.BackgroundColor3 = Colors.InactiveTab
                    subtab.Content.Visible = false
                end
                
                -- Select this subtab
                SubTabButton.BackgroundColor3 = Colors.ActiveTab
                SubTabContent.Visible = true
                Window.CurrentSubTab = SubTab
            end)
            
            table.insert(Tab.SubTabs, SubTab)
            
            -- Show subtab bar if this is first subtab
            if #Tab.SubTabs == 1 and Window.CurrentTab == Tab then
                SubTabBar.Visible = true
                SubTabButton.Visible = true
                SubTabButton.BackgroundColor3 = Colors.ActiveTab
                SubTabContent.Visible = true
                Window.CurrentSubTab = SubTab
            end
            
            -- Helper to switch columns
            function SubTab:SwitchColumn()
                if self.CurrentColumn == self.LeftColumn then
                    self.CurrentColumn = self.RightColumn
                else
                    self.CurrentColumn = self.LeftColumn
                end
            end
            
            -- Add Checkbox
            function SubTab:AddCheckbox(text, default, callback, column)
                callback = callback or function() end
                local parent = column == "right" and self.RightColumn or self.CurrentColumn
                
                local CheckboxFrame = Instance.new("Frame")
                CheckboxFrame.Size = UDim2.new(1, -10, 0, 18)
                CheckboxFrame.BackgroundTransparency = 1
                CheckboxFrame.Parent = parent
                
                local CheckboxButton = Instance.new("TextButton")
                CheckboxButton.Size = UDim2.new(0, 14, 0, 14)
                CheckboxButton.Position = UDim2.new(0, 0, 0, 2)
                CheckboxButton.BackgroundColor3 = Colors.SliderBackground
                CheckboxButton.BorderColor3 = Colors.Border
                CheckboxButton.BorderSizePixel = 1
                CheckboxButton.Text = ""
                CheckboxButton.AutoButtonColor = false
                CheckboxButton.Parent = CheckboxFrame
                
                local Checkmark = Instance.new("TextLabel")
                Checkmark.Size = UDim2.new(1, 0, 1, 0)
                Checkmark.BackgroundTransparency = 1
                Checkmark.Font = Enum.Font.Code
                Checkmark.Text = "✓"
                Checkmark.TextColor3 = Colors.Checkmark
                Checkmark.TextSize = 12
                Checkmark.Visible = default
                Checkmark.Parent = CheckboxButton
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -20, 1, 0)
                Label.Position = UDim2.new(0, 20, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Font = Enum.Font.Code
                Label.Text = text:upper()
                Label.TextColor3 = Colors.Text
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = CheckboxFrame
                
                local toggled = default
                
                CheckboxButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    Checkmark.Visible = toggled
                    callback(toggled)
                end)
                
                return {
                    Set = function(value)
                        toggled = value
                        Checkmark.Visible = value
                        callback(value)
                    end
                }
            end
            
            -- Add Slider
            function SubTab:AddSlider(text, min, max, default, callback, column)
                callback = callback or function() end
                local parent = column == "right" and self.RightColumn or self.CurrentColumn
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, -10, 0, 40)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = parent
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -40, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Font = Enum.Font.Code
                Label.Text = text:upper()
                Label.TextColor3 = Colors.Text
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = SliderFrame
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0, 35, 0, 16)
                ValueLabel.Position = UDim2.new(1, -35, 0, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Font = Enum.Font.Code
                ValueLabel.Text = tostring(default)
                ValueLabel.TextColor3 = Colors.Text
                ValueLabel.TextSize = 11
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = SliderFrame
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(1, 0, 0, 16)
                SliderBar.Position = UDim2.new(0, 0, 0, 20)
                SliderBar.BackgroundColor3 = Colors.SliderBackground
                SliderBar.BorderColor3 = Colors.Border
                SliderBar.BorderSizePixel = 1
                SliderBar.Parent = SliderFrame
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.BackgroundColor3 = Colors.SliderFill
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBar
                
                local value = default
                local dragging = false
                
                local function UpdateSlider(val)
                    value = math.clamp(math.floor(val), min, max)
                    local percent = (value - min) / (max - min)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    ValueLabel.Text = tostring(value)
                    callback(value)
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local pos = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                        local val = min + ((max - min) * pos)
                        UpdateSlider(val)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local pos = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                        local val = min + ((max - min) * pos)
                        UpdateSlider(val)
                    end
                end)
                
                UpdateSlider(default)
                
                return {
                    Set = UpdateSlider
                }
            end
            
            -- Add Dropdown
            function SubTab:AddDropdown(text, options, callback, column)
                callback = callback or function() end
                options = options or {"NONE"}
                local parent = column == "right" and self.RightColumn or self.CurrentColumn
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Size = UDim2.new(1, -10, 0, 22)
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.ZIndex = 2
                DropdownFrame.Parent = parent
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Size = UDim2.new(0, 120, 0, 18)
                DropdownButton.BackgroundColor3 = Colors.SliderBackground
                DropdownButton.BorderColor3 = Colors.Border
                DropdownButton.BorderSizePixel = 1
                DropdownButton.Font = Enum.Font.Code
                DropdownButton.Text = options[1]:upper()
                DropdownButton.TextColor3 = Colors.Text
                DropdownButton.TextSize = 10
                DropdownButton.AutoButtonColor = false
                DropdownButton.Parent = DropdownFrame
                
                local Arrow = Instance.new("TextLabel")
                Arrow.Size = UDim2.new(0, 16, 1, 0)
                Arrow.Position = UDim2.new(1, -16, 0, 0)
                Arrow.BackgroundTransparency = 1
                Arrow.Font = Enum.Font.Code
                Arrow.Text = "▼"
                Arrow.TextColor3 = Colors.DropdownArrow
                Arrow.TextSize = 8
                Arrow.Parent = DropdownButton
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0, 80, 1, 0)
                Label.Position = UDim2.new(1, 5, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Font = Enum.Font.Code
                Label.Text = text:upper()
                Label.TextColor3 = Colors.Text
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = DropdownFrame
                
                local DropdownList = Instance.new("Frame")
                DropdownList.Size = UDim2.new(0, 120, 0, 0)
                DropdownList.Position = UDim2.new(0, 0, 1, 2)
                DropdownList.BackgroundColor3 = Colors.Background
                DropdownList.BorderColor3 = Colors.Border
                DropdownList.BorderSizePixel = 1
                DropdownList.Visible = false
                DropdownList.ZIndex = 10
                DropdownList.ClipsDescendants = true
                DropdownList.Parent = DropdownFrame
                
                local ListLayout = Instance.new("UIListLayout")
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Parent = DropdownList
                
                local isOpen = false
                local selectedOption = options[1]
                
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        DropdownList.Visible = true
                        DropdownList.Size = UDim2.new(0, 120, 0, #options * 18)
                    else
                        DropdownList.Size = UDim2.new(0, 120, 0, 0)
                        task.wait(0.1)
                        DropdownList.Visible = false
                    end
                end)
                
                for _, option in ipairs(options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Size = UDim2.new(1, 0, 0, 18)
                    OptionButton.BackgroundColor3 = Colors.SliderBackground
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Font = Enum.Font.Code
                    OptionButton.Text = option:upper()
                    OptionButton.TextColor3 = Colors.Text
                    OptionButton.TextSize = 10
                    OptionButton.AutoButtonColor = false
                    OptionButton.ZIndex = 11
                    OptionButton.Parent = DropdownList
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        selectedOption = option
                        DropdownButton.Text = option:upper()
                        isOpen = false
                        DropdownList.Size = UDim2.new(0, 120, 0, 0)
                        task.wait(0.1)
                        DropdownList.Visible = false
                        callback(option)
                    end)
                    
                    OptionButton.MouseEnter:Connect(function()
                        OptionButton.BackgroundColor3 = Colors.ActiveTab
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        OptionButton.BackgroundColor3 = Colors.SliderBackground
                    end)
                end
                
                callback(options[1])
                
                return {
                    Set = function(option)
                        if table.find(options, option) then
                            selectedOption = option
                            DropdownButton.Text = option:upper()
                            callback(option)
                        end
                    end
                }
            end
            
            -- Add Label
            function SubTab:AddLabel(text, column)
                local parent = column == "right" and self.RightColumn or self.CurrentColumn
                
                local LabelFrame = Instance.new("Frame")
                LabelFrame.Size = UDim2.new(1, -10, 0, 16)
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.Parent = parent
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Font = Enum.Font.Code
                Label.Text = text
                Label.TextColor3 = Colors.TextDark
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = LabelFrame
            end
            
            -- Add Space
            function SubTab:AddSpace(height, column)
                local parent = column == "right" and self.RightColumn or self.CurrentColumn
                
                local Space = Instance.new("Frame")
                Space.Size = UDim2.new(1, 0, 0, height or 10)
                Space.BackgroundTransparency = 1
                Space.Parent = parent
            end
            
            return SubTab
        end
        
        return Tab
    end
    
    return Window
end

return Library
