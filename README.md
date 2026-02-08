# CSGO-Style UI Library for Roblox

A professional, modern UI library inspired by CSGO cheat menus. Fully standalone and can be loaded with `loadstring()`.

## Features

✨ **Professional CSGO-style design**  
🎨 **Light & Dark themes**  
📱 **Fully responsive and draggable**  
🔧 **Easy to use API**  
⚡ **Smooth animations**  
🎯 **No dependencies required**

## Installation

```lua
local Library = loadstring(game:HttpGet("YOUR_URL_HERE"))()
```

## Quick Start

```lua
-- Create a window
local Window = Library:CreateWindow({
    Title = "My Cheat",
    Size = UDim2.new(0, 600, 0, 400),
    Theme = "Dark" -- "Dark" or "Light"
})

-- Add a tab
local Tab = Window:AddTab("Main")

-- Add elements
Tab:AddToggle({
    Name = "Enable Feature",
    Default = false,
    Callback = function(value)
        print("Toggled:", value)
    end
})
```

## API Reference

### Window

#### `Library:CreateWindow(config)`

Creates a new window.

**Parameters:**
- `config` (table)
  - `Title` (string) - Window title
  - `Size` (UDim2) - Window size
  - `Theme` (string) - "Dark" or "Light"

**Returns:** Window object

**Example:**
```lua
local Window = Library:CreateWindow({
    Title = "CSGO Cheat v1.0",
    Size = UDim2.new(0, 650, 0, 450),
    Theme = "Dark"
})
```

#### `Window:AddTab(name)`

Adds a new tab to the window.

**Parameters:**
- `name` (string) - Tab name

**Returns:** Tab object

**Example:**
```lua
local AimbotTab = Window:AddTab("Aimbot")
local VisualsTab = Window:AddTab("Visuals")
```

#### `Window:Notify(config)`

Shows a notification.

**Parameters:**
- `config` (table)
  - `Title` (string) - Notification title
  - `Content` (string) - Notification content
  - `Duration` (number) - Duration in seconds

**Example:**
```lua
Window:Notify({
    Title = "Success",
    Content = "Feature enabled!",
    Duration = 3
})
```

---

### Tab Elements

#### `Tab:AddToggle(config)`

Adds a toggle switch.

**Parameters:**
- `config` (table)
  - `Name` (string) - Toggle name
  - `Default` (boolean) - Default state
  - `Callback` (function) - Called when toggled

**Returns:** Toggle object with `Set(value)` method

**Example:**
```lua
local toggle = Tab:AddToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(value)
        print("Aimbot:", value)
    end
})

-- Programmatically set value
toggle:Set(true)
```

---

#### `Tab:AddButton(config)`

Adds a button.

**Parameters:**
- `config` (table)
  - `Name` (string) - Button text
  - `Callback` (function) - Called when clicked

**Example:**
```lua
Tab:AddButton({
    Name = "Execute",
    Callback = function()
        print("Button clicked!")
    end
})
```

---

#### `Tab:AddSlider(config)`

Adds a slider.

**Parameters:**
- `config` (table)
  - `Name` (string) - Slider name
  - `Min` (number) - Minimum value
  - `Max` (number) - Maximum value
  - `Default` (number) - Default value
  - `Increment` (number) - Step increment (optional, default: 1)
  - `Callback` (function) - Called when value changes

**Returns:** Slider object with `Set(value)` method

**Example:**
```lua
local slider = Tab:AddSlider({
    Name = "FOV",
    Min = 0,
    Max = 360,
    Default = 90,
    Increment = 5,
    Callback = function(value)
        print("FOV:", value)
    end
})

-- Programmatically set value
slider:Set(120)
```

---

#### `Tab:AddDropdown(config)`

Adds a dropdown menu.

**Parameters:**
- `config` (table)
  - `Name` (string) - Dropdown name
  - `Options` (table) - Array of options
  - `Default` (string) - Default option
  - `Callback` (function) - Called when selection changes

**Returns:** Dropdown object with `Set(option)` method

**Example:**
```lua
local dropdown = Tab:AddDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "Random"},
    Default = "Head",
    Callback = function(option)
        print("Selected:", option)
    end
})

-- Programmatically set option
dropdown:Set("Torso")
```

---

#### `Tab:AddInput(config)`

Adds a text input box.

**Parameters:**
- `config` (table)
  - `Name` (string) - Input name
  - `Placeholder` (string) - Placeholder text
  - `Default` (string) - Default text (optional)
  - `Callback` (function) - Called when focus is lost

**Returns:** Input object with `Set(text)` method

**Example:**
```lua
local input = Tab:AddInput({
    Name = "Username",
    Placeholder = "Enter username...",
    Default = "",
    Callback = function(text)
        print("Input:", text)
    end
})

-- Programmatically set text
input:Set("Player123")
```

---

#### `Tab:AddColorPicker(config)`

Adds a color picker.

**Parameters:**
- `config` (table)
  - `Name` (string) - Color picker name
  - `Default` (Color3) - Default color
  - `Callback` (function) - Called when color changes

**Returns:** ColorPicker object with `Set(color)` method

**Example:**
```lua
local colorPicker = Tab:AddColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Color:", color)
    end
})

-- Programmatically set color
colorPicker:Set(Color3.fromRGB(0, 255, 0))
```

---

#### `Tab:AddLabel(text)`

Adds a text label.

**Parameters:**
- `text` (string) - Label text

**Returns:** Label object with `Set(text)` method

**Example:**
```lua
local label = Tab:AddLabel("Settings")

-- Update label text
label:Set("New Settings")
```

---

#### `Tab:AddDivider()`

Adds a visual divider line.

**Example:**
```lua
Tab:AddDivider()
```

---

## Complete Example

```lua
-- Load library
local Library = loadstring(game:HttpGet("YOUR_URL_HERE"))()

-- Create window
local Window = Library:CreateWindow({
    Title = "CSGO Cheat v1.0",
    Size = UDim2.new(0, 650, 0, 450),
    Theme = "Dark"
})

-- Aimbot Tab
local AimbotTab = Window:AddTab("Aimbot")

AimbotTab:AddLabel("Main Settings")

AimbotTab:AddToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(value)
        _G.AimbotEnabled = value
    end
})

AimbotTab:AddDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "Random"},
    Default = "Head",
    Callback = function(option)
        _G.TargetPart = option
    end
})

AimbotTab:AddSlider({
    Name = "FOV",
    Min = 0,
    Max = 360,
    Default = 90,
    Callback = function(value)
        _G.AimbotFOV = value
    end
})

-- Visuals Tab
local VisualsTab = Window:AddTab("Visuals")

VisualsTab:AddToggle({
    Name = "ESP",
    Default = false,
    Callback = function(value)
        _G.ESPEnabled = value
    end
})

VisualsTab:AddColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        _G.ESPColor = color
    end
})

-- Misc Tab
local MiscTab = Window:AddTab("Misc")

MiscTab:AddInput({
    Name = "Whitelist",
    Placeholder = "Enter username...",
    Callback = function(text)
        _G.Whitelist = text
    end
})

MiscTab:AddButton({
    Name = "Execute",
    Callback = function()
        Window:Notify({
            Title = "Success",
            Content = "Script executed!",
            Duration = 2
        })
    end
})

-- Show welcome notification
Window:Notify({
    Title = "Welcome!",
    Content = "UI loaded successfully",
    Duration = 3
})
```

## Themes

### Dark Theme (Default)
- Modern dark UI
- Blue accent colors
- Professional look

### Light Theme
- Clean light UI
- Blue accent colors
- Easy on the eyes

Change theme when creating window:
```lua
local Window = Library:CreateWindow({
    Title = "My Cheat",
    Theme = "Light" -- or "Dark"
})
```

## Features

### Draggable Window
Click and drag the top bar to move the window.

### Smooth Animations
All elements feature smooth animations for a professional feel.

### Ripple Effects
Buttons have material design ripple effects on click.

### Responsive Design
UI scales properly and handles different resolutions.

### Notifications
Built-in notification system for user feedback.

## Tips

1. **Organization**: Use labels and dividers to organize your UI
2. **Callbacks**: Keep callback functions lightweight
3. **Default Values**: Always set sensible defaults
4. **Notifications**: Use notifications for user feedback
5. **Tabs**: Group related features in tabs

## License

Free to use for personal and commercial projects.

## Credits

Created with love for the Roblox exploiting community ❤️
