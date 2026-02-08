--[[
    Example recreating the exact CSGO cheat menu from the image
    
    Features shown:
    - RAGEBOT, LEGITBOT, VISUALS, MISC, PLIST, CONFIGS tabs
    - AIMBOT, ANTI-AIM, AUTO STUFF, RESOLVER, FAKE LAG, ADVANCED subtabs
    - Two-column layout with checkboxes, sliders, and dropdowns
]]

-- Load the library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/m0dzn1/CSGO-ui-library-test/refs/heads/main/csgo_ui_library.lua"))()

-- Create window matching the screenshot
local Window = Library:CreateWindow({
    Title = "BLAXED.COM - RECODED VERSION!",
    Size = UDim2.new(0, 720, 0, 520)
})

-- ============================================
-- RAGEBOT TAB
-- ============================================
local RagebotTab = Window:AddTab("RAGEBOT")

-- AIMBOT SubTab
local AimbotSubTab = RagebotTab:AddSubTab("AIMBOT")

-- Left Column
AimbotSubTab:AddCheckbox("AUTO FIRE", true, function(v)
    print("Auto Fire:", v)
end)

AimbotSubTab:AddCheckbox("AUTO WALL", true, function(v)
    print("Auto Wall:", v)
end)

AimbotSubTab:AddSlider("MIN DAMAGE", 0, 100, 34, function(v)
    print("Min Damage:", v)
end)

AimbotSubTab:AddSlider("HITCHANCE", 0, 100, 15, function(v)
    print("Hitchance:", v)
end)

AimbotSubTab:AddLabel("BODY-AIM")

AimbotSubTab:AddCheckbox("FPS ADAPTIVE", true, function(v)
    print("FPS Adaptive:", v)
end)

AimbotSubTab:AddCheckbox("IGNORE HEAD", true, function(v)
    print("Ignore Head:", v)
end)

AimbotSubTab:AddCheckbox("IGNORE ARMS & LEGS", true, function(v)
    print("Ignore Arms & Legs:", v)
end)

AimbotSubTab:AddCheckbox("HS ONLY", true, function(v)
    print("HS Only:", v)
end)

AimbotSubTab:AddCheckbox("HS ONLY IF RESOLVED", true, function(v)
    print("HS Only if Resolved:", v)
end)

AimbotSubTab:AddCheckbox("HS ONLY AT MOVING TARGETS", true, function(v)
    print("HS Only at Moving Targets:", v)
end)

AimbotSubTab:AddCheckbox("SMART AIM", true, function(v)
    print("Smart Aim:", v)
end)

AimbotSubTab:AddCheckbox("PREFER BAIM", true, function(v)
    print("Prefer BAIM:", v)
end)

AimbotSubTab:AddCheckbox("BAIM ON LOW HITCHANCE", true, function(v)
    print("BAIM on Low Hitchance:", v)
end)

AimbotSubTab:AddCheckbox("AUTO BAIM", true, function(v)
    print("Auto BAIM:", v)
end)

AimbotSubTab:AddDropdown("MULTIBOX", {"NONE", "MULTIBOX", "ADAPTIVE"}, function(v)
    print("Multibox:", v)
end)

-- Switch to right column
AimbotSubTab:SwitchColumn()

-- Right Column
AimbotSubTab:AddCheckbox("ACCURACY BOOST", true, function(v)
    print("Accuracy Boost:", v)
end, "right")

AimbotSubTab:AddCheckbox("DELAY SHOOT", true, function(v)
    print("Delay Shoot:", v)
end, "right")

AimbotSubTab:AddLabel("PSILENT", "right")

AimbotSubTab:AddCheckbox("ANTI PSILENT", true, function(v)
    print("Anti Psilent:", v)
end, "right")

AimbotSubTab:AddCheckbox("AUTO REVOLVER", true, function(v)
    print("Auto Revolver:", v)
end, "right")

AimbotSubTab:AddCheckbox("NO RECOIL", true, function(v)
    print("No Recoil:", v)
end, "right")

AimbotSubTab:AddCheckbox("AUTO SCOPE", true, function(v)
    print("Auto Scope:", v)
end, "right")

AimbotSubTab:AddCheckbox("AUTO STOP", true, function(v)
    print("Auto Stop:", v)
end, "right")

AimbotSubTab:AddCheckbox("AUTO CROUCH", true, function(v)
    print("Auto Crouch:", v)
end, "right")

-- ANTI-AIM SubTab
local AntiAimSubTab = RagebotTab:AddSubTab("ANTI-AIM")

AntiAimSubTab:AddCheckbox("ENABLE ANTI-AIM", false, function(v)
    print("Enable Anti-Aim:", v)
end)

AntiAimSubTab:AddDropdown("YAW MODE", {"NONE", "STATIC", "DYNAMIC"}, function(v)
    print("Yaw Mode:", v)
end)

AntiAimSubTab:AddSlider("YAW OFFSET", -180, 180, 0, function(v)
    print("Yaw Offset:", v)
end)

-- Switch to right column
AntiAimSubTab:SwitchColumn()

AntiAimSubTab:AddCheckbox("FAKE DUCK", false, function(v)
    print("Fake Duck:", v)
end, "right")

AntiAimSubTab:AddCheckbox("SLOW WALK", false, function(v)
    print("Slow Walk:", v)
end, "right")

-- AUTO STUFF SubTab
local AutoStuffSubTab = RagebotTab:AddSubTab("AUTO STUFF")

AutoStuffSubTab:AddCheckbox("AUTO ACCEPT", false, function(v)
    print("Auto Accept:", v)
end)

AutoStuffSubTab:AddCheckbox("AUTO BUY", false, function(v)
    print("Auto Buy:", v)
end)

AutoStuffSubTab:AddCheckbox("CLAN TAG SPAMMER", false, function(v)
    print("Clan Tag Spammer:", v)
end)

-- RESOLVER SubTab
local ResolverSubTab = RagebotTab:AddSubTab("RESOLVER")

ResolverSubTab:AddCheckbox("ENABLE RESOLVER", true, function(v)
    print("Enable Resolver:", v)
end)

ResolverSubTab:AddDropdown("RESOLVER MODE", {"NONE", "BASIC", "ADVANCED"}, function(v)
    print("Resolver Mode:", v)
end)

-- FAKE LAG SubTab
local FakeLagSubTab = RagebotTab:AddSubTab("FAKE LAG")

FakeLagSubTab:AddCheckbox("ENABLE FAKE LAG", false, function(v)
    print("Enable Fake Lag:", v)
end)

FakeLagSubTab:AddSlider("FAKE LAG AMOUNT", 0, 15, 5, function(v)
    print("Fake Lag Amount:", v)
end)

-- ADVANCED SubTab
local AdvancedSubTab = RagebotTab:AddSubTab("ADVANCED")

AdvancedSubTab:AddCheckbox("BACKTRACK", true, function(v)
    print("Backtrack:", v)
end)

AdvancedSubTab:AddSlider("BACKTRACK TICKS", 0, 15, 10, function(v)
    print("Backtrack Ticks:", v)
end)

-- ============================================
-- LEGITBOT TAB
-- ============================================
local LegitbotTab = Window:AddTab("LEGITBOT")

local LegitAimSubTab = LegitbotTab:AddSubTab("AIM ASSIST")

LegitAimSubTab:AddCheckbox("ENABLE AIM ASSIST", false, function(v)
    print("Enable Aim Assist:", v)
end)

LegitAimSubTab:AddSlider("SMOOTHNESS", 0, 100, 50, function(v)
    print("Smoothness:", v)
end)

LegitAimSubTab:AddSlider("FOV", 0, 180, 45, function(v)
    print("FOV:", v)
end)

-- ============================================
-- VISUALS TAB
-- ============================================
local VisualsTab = Window:AddTab("VISUALS")

local ESPSubTab = VisualsTab:AddSubTab("ESP")

ESPSubTab:AddCheckbox("ENABLE ESP", false, function(v)
    print("Enable ESP:", v)
end)

ESPSubTab:AddCheckbox("BOX ESP", false, function(v)
    print("Box ESP:", v)
end)

ESPSubTab:AddCheckbox("NAME ESP", false, function(v)
    print("Name ESP:", v)
end)

ESPSubTab:AddCheckbox("HEALTH ESP", false, function(v)
    print("Health ESP:", v)
end)

ESPSubTab:AddCheckbox("DISTANCE ESP", false, function(v)
    print("Distance ESP:", v)
end)

ESPSubTab:SwitchColumn()

ESPSubTab:AddCheckbox("SKELETON ESP", false, function(v)
    print("Skeleton ESP:", v)
end, "right")

ESPSubTab:AddCheckbox("GLOW ESP", false, function(v)
    print("Glow ESP:", v)
end, "right")

ESPSubTab:AddCheckbox("TRACERS", false, function(v)
    print("Tracers:", v)
end, "right")

local ChamsSubTab = VisualsTab:AddSubTab("CHAMS")

ChamsSubTab:AddCheckbox("ENABLE CHAMS", false, function(v)
    print("Enable Chams:", v)
end)

ChamsSubTab:AddSlider("TRANSPARENCY", 0, 100, 50, function(v)
    print("Chams Transparency:", v)
end)

-- ============================================
-- MISC TAB
-- ============================================
local MiscTab = Window:AddTab("MISC")

local MovementSubTab = MiscTab:AddSubTab("MOVEMENT")

MovementSubTab:AddCheckbox("BUNNY HOP", false, function(v)
    print("Bunny Hop:", v)
end)

MovementSubTab:AddCheckbox("AUTO STRAFE", false, function(v)
    print("Auto Strafe:", v)
end)

MovementSubTab:AddSlider("SPEED", 16, 100, 16, function(v)
    print("Speed:", v)
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

MovementSubTab:SwitchColumn()

MovementSubTab:AddCheckbox("INFINITE JUMP", false, function(v)
    print("Infinite Jump:", v)
end, "right")

MovementSubTab:AddCheckbox("NO FALL DAMAGE", false, function(v)
    print("No Fall Damage:", v)
end, "right")

local OtherSubTab = MiscTab:AddSubTab("OTHER")

OtherSubTab:AddCheckbox("REMOVE RECOIL", false, function(v)
    print("Remove Recoil:", v)
end)

OtherSubTab:AddCheckbox("REMOVE SPREAD", false, function(v)
    print("Remove Spread:", v)
end)

OtherSubTab:AddCheckbox("THIRDPERSON", false, function(v)
    print("Thirdperson:", v)
end)

-- ============================================
-- PLIST TAB
-- ============================================
local PListTab = Window:AddTab("PLIST")

local WhitelistSubTab = PListTab:AddSubTab("WHITELIST")

WhitelistSubTab:AddLabel("Manage your whitelist here")
WhitelistSubTab:AddSpace(10)
WhitelistSubTab:AddCheckbox("ENABLE WHITELIST", false, function(v)
    print("Enable Whitelist:", v)
end)

-- ============================================
-- CONFIGS TAB
-- ============================================
local ConfigsTab = Window:AddTab("CONFIGS")

local ConfigSubTab = ConfigsTab:AddSubTab("CONFIG")

ConfigSubTab:AddLabel("Configuration Management")
ConfigSubTab:AddSpace(10)

ConfigSubTab:AddDropdown("SELECT CONFIG", {"DEFAULT", "RAGE", "LEGIT", "HVH"}, function(v)
    print("Selected Config:", v)
end)

ConfigSubTab:AddSpace(5)
ConfigSubTab:AddCheckbox("AUTO SAVE", true, function(v)
    print("Auto Save:", v)
end)

print("CSGO Cheat Menu loaded successfully!")
print("Exact recreation of BLAXED.COM menu")
