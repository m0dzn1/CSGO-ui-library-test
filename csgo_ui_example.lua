--[[
    CSGO UI Library - Example Usage
    
    This example shows how to use all features of the library
]]

-- Load the library
local Library = loadstring(game:HttpGet("YOUR_URL_HERE"))()

-- Create a window
local Window = Library:CreateWindow({
    Title = "CSGO Cheat v1.0",
    Size = UDim2.new(0, 650, 0, 450),
    Theme = "Dark" -- "Dark" or "Light"
})

-- ============================================
-- AIMBOT TAB
-- ============================================
local AimbotTab = Window:AddTab("Aimbot")

AimbotTab:AddLabel("Main Settings")

local aimbotEnabled = AimbotTab:AddToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(value)
        print("Aimbot enabled:", value)
        -- Your aimbot code here
    end
})

AimbotTab:AddDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "Random"},
    Default = "Head",
    Callback = function(option)
        print("Target part:", option)
    end
})

AimbotTab:AddSlider({
    Name = "FOV",
    Min = 0,
    Max = 360,
    Default = 90,
    Increment = 1,
    Callback = function(value)
        print("FOV:", value)
    end
})

AimbotTab:AddSlider({
    Name = "Smoothness",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        print("Smoothness:", value)
    end
})

AimbotTab:AddDivider()

AimbotTab:AddLabel("Advanced Settings")

AimbotTab:AddToggle({
    Name = "Visibility Check",
    Default = true,
    Callback = function(value)
        print("Visibility check:", value)
    end
})

AimbotTab:AddToggle({
    Name = "Team Check",
    Default = true,
    Callback = function(value)
        print("Team check:", value)
    end
})

AimbotTab:AddToggle({
    Name = "Prediction",
    Default = false,
    Callback = function(value)
        print("Prediction:", value)
    end
})

-- ============================================
-- VISUALS TAB
-- ============================================
local VisualsTab = Window:AddTab("Visuals")

VisualsTab:AddLabel("ESP Settings")

VisualsTab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(value)
        print("ESP enabled:", value)
    end
})

VisualsTab:AddToggle({
    Name = "Box ESP",
    Default = false,
    Callback = function(value)
        print("Box ESP:", value)
    end
})

VisualsTab:AddToggle({
    Name = "Name ESP",
    Default = false,
    Callback = function(value)
        print("Name ESP:", value)
    end
})

VisualsTab:AddToggle({
    Name = "Health ESP",
    Default = false,
    Callback = function(value)
        print("Health ESP:", value)
    end
})

VisualsTab:AddToggle({
    Name = "Distance ESP",
    Default = false,
    Callback = function(value)
        print("Distance ESP:", value)
    end
})

VisualsTab:AddColorPicker({
    Name = "Box Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Box color:", color)
    end
})

VisualsTab:AddDivider()

VisualsTab:AddLabel("Chams Settings")

VisualsTab:AddToggle({
    Name = "Enable Chams",
    Default = false,
    Callback = function(value)
        print("Chams enabled:", value)
    end
})

VisualsTab:AddSlider({
    Name = "Transparency",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Chams transparency:", value)
    end
})

-- ============================================
-- MISC TAB
-- ============================================
local MiscTab = Window:AddTab("Misc")

MiscTab:AddLabel("Movement")

MiscTab:AddToggle({
    Name = "Speed Boost",
    Default = false,
    Callback = function(value)
        print("Speed boost:", value)
        if value then
            -- Enable speed boost
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
        else
            -- Disable speed boost
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
})

MiscTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        print("Walk speed:", value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

MiscTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        print("Jump power:", value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end
})

MiscTab:AddDivider()

MiscTab:AddLabel("Teleportation")

local teleportInput = MiscTab:AddInput({
    Name = "Player Name",
    Placeholder = "Enter player name...",
    Callback = function(text)
        print("Player name:", text)
    end
})

MiscTab:AddButton({
    Name = "Teleport to Player",
    Callback = function()
        print("Teleporting...")
        Window:Notify({
            Title = "Teleport",
            Content = "Attempting to teleport...",
            Duration = 2
        })
    end
})

MiscTab:AddDivider()

MiscTab:AddLabel("Other")

MiscTab:AddToggle({
    Name = "Anti-AFK",
    Default = false,
    Callback = function(value)
        print("Anti-AFK:", value)
    end
})

MiscTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(value)
        print("Infinite jump:", value)
    end
})

-- ============================================
-- SETTINGS TAB
-- ============================================
local SettingsTab = Window:AddTab("Settings")

SettingsTab:AddLabel("UI Configuration")

SettingsTab:AddDropdown({
    Name = "Theme",
    Options = {"Dark", "Light"},
    Default = "Dark",
    Callback = function(option)
        print("Theme changed to:", option)
        Window:Notify({
            Title = "Theme Changed",
            Content = "Please reload the UI to apply the new theme",
            Duration = 3
        })
    end
})

SettingsTab:AddButton({
    Name = "Reset UI Position",
    Callback = function()
        print("Resetting UI position...")
        Window:Notify({
            Title = "UI Reset",
            Content = "UI position has been reset",
            Duration = 2
        })
    end
})

SettingsTab:AddDivider()

SettingsTab:AddLabel("Config")

local configName = SettingsTab:AddInput({
    Name = "Config Name",
    Placeholder = "default",
    Default = "default",
    Callback = function(text)
        print("Config name:", text)
    end
})

SettingsTab:AddButton({
    Name = "Save Config",
    Callback = function()
        print("Saving config...")
        Window:Notify({
            Title = "Config Saved",
            Content = "Configuration saved successfully!",
            Duration = 2
        })
    end
})

SettingsTab:AddButton({
    Name = "Load Config",
    Callback = function()
        print("Loading config...")
        Window:Notify({
            Title = "Config Loaded",
            Content = "Configuration loaded successfully!",
            Duration = 2
        })
    end
})

-- Welcome notification
Window:Notify({
    Title = "Welcome!",
    Content = "CSGO UI Library loaded successfully",
    Duration = 3
})

print("CSGO UI Library Example Loaded!")
