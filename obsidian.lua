-- example script by https://github.com/mstudio45/LinoriaLib/blob/main/Example.lua and modified by deivid
-- Patched Example: this single file applies all UI changes to the library
-- at runtime, so you can just run it without any other local files.
-- No readfile needed, falls back to the GitHub repo.

local repo = "https://raw.githubusercontent.com/noelrangga354-ops/Obsidianplus/main/"

-- Loads local files first (so your local Library.lua changes are used),
-- and falls back to the GitHub repo if readfile is unavailable.
local function LoadFile(Path)
	if isfile and isfile(Path) then
		return readfile(Path)
	end

	return game:HttpGet(repo .. Path)
end

local function EscapeMagic(S)
	return S:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

local function Patch(Code, Changes)
	for _, Change in ipairs(Changes) do
		local NewCode, Count = Code:gsub(EscapeMagic(Change[1]), Change[2])

		if Count == 0 then
			warn("[Example] Patch NOT applied:", Change[1])
		else
			Code = NewCode
		end
	end

	return Code
end

local LibraryCode = Patch(LoadFile("Library.lua"), {
	{ "DropdownTransitionInfo = TweenInfo.new(0.18,", "DropdownTransitionInfo = TweenInfo.new(0.1," },
	{ "Dropdown = false", "Dropdown = true" },
	{ "BackgroundImage = \"\",", "BackgroundImage = \"\",\n        Glow = true," },
	{ "BackgroundImage = \"\"\n    },", "BackgroundImage = \"\",\n        WindowGlow = true,\n    }," },
	{ "Library.Scheme.Font = WindowInfo.Font", "Library.Scheme.Font = WindowInfo.Font\n    Library.Scheme.WindowGlow = WindowInfo.Glow" },
	{ "Library:MakeLine(MainFrame, {\n            Position = UDim2.fromOffset(0, 48),\n            Size = UDim2.new(1, 0, 0, 1),\n        })\n\n        DividerLine = New(\"Frame\", {", "Library:MakeLine(MainFrame, {\n            Position = UDim2.fromOffset(0, 48),\n            Size = UDim2.new(1, 0, 0, 1),\n        })\n\n        Glow = New(\"ImageLabel\", {\n            BackgroundTransparency = 1,\n            Position = UDim2.fromOffset(-20.8, -20.8),\n            Size = UDim2.new(1, 41.6, 1, 41.6),\n            ZIndex = -1,\n            Image = \"rbxassetid://88645182616510\",\n            ImageColor3 = function()\n                return Library.Scheme.AccentColor\n            end,\n            Visible = Library.Scheme.WindowGlow,\n            Parent = MainFrame,\n        })\n\n        DividerLine = New(\"Frame\", {" },
	{ "end\n\nfunction Library:UpdateNotificationPositions", "end\n\nfunction Library:SetGlow(State)\n    Library.Scheme.WindowGlow = State\n    if Library.Window and Glow then\n        Glow.Visible = State\n    end\n\n    Library:UpdateColorsUsingRegistry()\nend\n\nfunction Library:UpdateNotificationPositions" },
	{ "function Window:SetFooter(Footer: string)", "function Window:SetGlow(State: boolean)\n        return Library:SetGlow(State)\n    end\n\n    function Window:SetFooter(Footer: string)" },
	{ "TabButton.MouseEnter:Connect(function()\n            Tab:Hover(true)\n        end)", "TabButton.MouseEnter:Connect(function()\n            Tab:Hover(true)\n            if not IsCompact then\n                return\n            end\n\n            for _, TabEntry in Library.TabButtons do\n                if TabEntry.Button == TabButton and not TabEntry.Tooltip then\n                    TabEntry.Tooltip = Library:AddTooltip(Name, nil, TabButton)\n                end\n            end\n        end)" },
	{ "table.insert(Library.TabButtons, {\n                Label = TabLabel,\n                Padding = ButtonPadding,\n                Icon = TabIcon,\n            })", "table.insert(Library.TabButtons, {\n                Button = TabButton,\n                Label = TabLabel,\n                Padding = ButtonPadding,\n                Icon = TabIcon,\n                Tooltip = nil,\n            })" },
	{ "for _, Button in Library.TabButtons do\n            if not Button.Icon then\n                continue\n            end", "for _, Button in Library.TabButtons do\n            if Button.Tooltip then\n                Button.Tooltip.Disabled = not IsCompact\n            end\n\n            if not Button.Icon then\n                continue\n            end" },
})

local ThemeManagerCode = Patch(LoadFile("addons/ThemeManager.lua"), {
	{ "local FontColor = CreateColorOption(\"Font color\", \"FontColor\")", "local FontColor = CreateColorOption(\"Font color\", \"FontColor\")\n\n    Themesbox:AddToggle(\"WindowGlow\", {\n        Text = \"Window Glow\",\n        Default = ThemeManager.Library.Scheme.WindowGlow\n    })\n\n    ThemeManager.Library.Toggles.WindowGlow:OnChanged(function(Value)\n        ThemeManager.Library:SetGlow(Value)\n    end)" },
})

local SaveManagerCode = Patch(LoadFile("addons/SaveManager.lua"), {
	{ "ConfigurationBox:AddButton(\"Refresh list\", RefreshList)\n\n    --// Autoload Config", "ConfigurationBox:AddButton(\"Refresh list\", RefreshList)\n\n    ConfigurationBox:AddDivider()\n\n    --// Import\n    ConfigurationBox:AddInput(\"SaveManager_ImportData\", { Text = \"Import Configuration:\" })\n    ConfigurationBox:AddButton(\"Import Config\", function()\n        local ConfigData = SaveManager.Library.Options.SaveManager_ImportData.Value\n\n        if IsStringEmpty(ConfigData) then\n            SaveManager.Library:Notify({\n                Title = \"Warning\",\n                Description = \"No config data provided.\",\n                Time = 3,\n                Icon = \"triangle-alert\"\n            })\n            return\n        end\n\n        local Success, ErrorMessage = SaveManager:ImportConfig(ConfigData)\n        if not Success then\n            SaveManager.Library:Notify({\n                Title = \"Error\",\n                Description = string.format(\"Failed to import config: %%s.\", ErrorMessage),\n                Icon = \"circle-x\"\n            })\n            return\n        end\n\n        SaveManager.Library:Notify({\n            Title = \"Success\",\n            Description = \"Config imported and applied.\",\n            Time = 3,\n            Icon = \"circle-check\"\n        })\n    end)\n\n    --// Autoload Config" },
})

local Library = loadstring(LibraryCode)()
local ThemeManager = loadstring(ThemeManagerCode)()
local SaveManager = loadstring(SaveManagerCode)()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false -- Forces AddToggle to AddCheckbox
Library.ShowToggleFrameInKeybinds = true -- Make toggle keybinds work inside the keybinds UI (aka adds a toggle to the UI). Good for mobile users (Default value = true)

-- ============================================================
-- ✅ DEFAULT: Apply DPI 75% & Corner Radius 20 right after creation
-- ============================================================
local DEFAULT_DPI = 75
local DEFAULT_CORNER_RADIUS = 20

local Window = Library:CreateWindow({
	-- Set Center to true if you want the menu to appear in the center
	-- Set AutoShow to true if you want the menu to appear when it is created
	-- Set Resizable to true if you want to have in-game resizable Window
	-- Set MobileButtonsSide to "Left" or "Right" if you want the ui toggle & lock buttons to be on the left or right side of the window
	-- Set ShowCustomCursor to false if you don't want to use the Linoria cursor
	-- NotifySide = Changes the side of the notifications (Left, Right) (Default value = Left)
	-- Position and Size are also valid options here
	-- but you do not need to define them unless you are changing them :)

	-- Compact = true -> tabs start hidden/collapsed (only icons are shown in the sidebar)
	-- EnableSidebarResize = true -> you can drag the sidebar divider to expand/collapse the tabs
	-- When the sidebar is collapsed, hovering over a tab icon shows the tab name
	Compact = true,
	EnableSidebarResize = true,
	Title = "Hyunjin",
	Footer = "version: 3.5.4",
	Icon = "terminal",
	NotifySide = "Right",
	ShowCustomCursor = true,

	-- NEW: Window Glow
	Glow = true,

	-- NEW: smooth dropdown animation
	Animations = {
		Dropdown = true,
	},
})

-- ✅ Apply default DPI & Corner Radius immediately on load
Library:SetDPIScale(DEFAULT_DPI)
Window:SetCornerRadius(DEFAULT_CORNER_RADIUS)

-- NEW: smooth dropdown animation, 0.1s (default is 0.2s)
Library.DropdownTransitionInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- CALLBACK NOTE:
-- Passing in callback functions via the initial element parameters (i.e. Callback = function(Value)...) works
-- HOWEVER, using Toggles/Options.INDEX:OnChanged(function(Value) ... ) is the RECOMMENDED way to do this.
-- I strongly recommend decoupling UI code from logic code. i.e. Create your UI elements FIRST, and THEN setup :OnChanged functions later.

-- You do not have to set your tabs & groups up this way, just a prefrence.
-- You can find more icons in https://lucide.dev/
local Tabs = {
	["Visual"] = Window:AddTab("Visual", "eye", "Fitur visual ESP, Camera, Lighting"),
	["House"] = Window:AddTab("House", "house", "Game info panel"),
	["Main"] = Window:AddTab("Main", "cpu", "Fitur utama"),
	["Aim"] = Window:AddTab("Aim", "crosshair", "Aimbot & Silent Aim"),
	["Mapping"] = Window:AddTab("Mapping", "map", "Teleport & Radar"),
	["Player"] = Window:AddTab("Player", "user", "Player movement & misc"),
	["UI Settings"] = Window:AddTab("UI Settings", "settings", "UI settings and configurations"),
}

-- UI Settings
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

	MenuGroup:AddToggle("WindowGlowToggle", { -- NEW: Window Glow on/off
		Text = "Window Glow",
		Default = true,
		Callback = function(Value)
			Library:SetGlow(Value)
		end,
	})

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = Library.ShowCustomCursor,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",

	Text = "Notification Side",

	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "75%", -- ✅ CHANGED: default 75%

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})

MenuGroup:AddSlider("UICornerSlider", {
	Text = "Corner Radius",
	Default = 20, -- ✅ CHANGED: default 20
	Min = 0,
	Max = 20,
	Rounding = 0,
	Callback = function(value)
		Window:SetCornerRadius(value)
	end
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place") -- if the game has multiple places inside of it (for example: DOORS)
-- you can use this to save configs for those places separately
-- The path in this script would be: MyScriptHub/specific-game/settings/specific-place
-- [ This is optional ]

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs["UI Settings"])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs["UI Settings"])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

-- =====================================================
-- ADAPTER: ModernV2 → Obsidian
-- =====================================================
-- Fungsi ini membuat objek palsu yang menerima API ModernV2
-- (AddToggle, AddSlider, dll) tapi memanggil Obsidian di baliknya.

local function MakeAdapter(groupbox)
    local adapter = {}
    
    function adapter:AddToggle(cfg)
        groupbox:AddToggle(cfg.Flag or cfg.Name, {
            Text = cfg.Name or cfg.Flag,
            Default = cfg.Default or false,
            Callback = cfg.Callback,
            Tooltip = cfg.Description or cfg.Tooltip,
        })
    end
    
    function adapter:AddSlider(cfg)
        local round = 0
        if cfg.Increment and cfg.Increment < 1 then
            round = 2
        elseif cfg.Decimals then
            round = cfg.Decimals
        end
        groupbox:AddSlider(cfg.Flag or cfg.Name, {
            Text = cfg.Name or cfg.Flag,
            Default = cfg.Default or cfg.Min or 0,
            Min = cfg.Min or 0,
            Max = cfg.Max or 100,
            Rounding = round,
            Suffix = cfg.Suffix,
            Callback = cfg.Callback,
        })
    end
    
    function adapter:AddDropdown(cfg)
        groupbox:AddDropdown(cfg.Flag or cfg.Name, {
            Text = cfg.Name or cfg.Flag,
            Values = cfg.Values or {},
            Default = cfg.Default,
            Multi = cfg.Multi or false,
            AllowNone = cfg.AllowNone,
            Callback = cfg.Callback,
        })
    end
    
    function adapter:AddButton(cfg)
        groupbox:AddButton({
            Text = cfg.Name or "Button",
            Func = cfg.Callback,
            DoubleClick = false,
        })
    end
    
    function adapter:AddDivider(cfg)
        groupbox:AddDivider()
    end
    
    function adapter:AddLabel(cfg)
        return groupbox:AddLabel(cfg.Name or cfg.Text or "")
    end
    
    function adapter:AddKeybind(cfg)
        -- Obsidian pakai Label + AddKeyPicker
        local label = groupbox:AddLabel(cfg.Name or "Keybind")
        if label and label.AddKeyPicker then
            label:AddKeyPicker(cfg.Flag or cfg.Name, {
                Default = cfg.Default or "None",
                Text = cfg.Name,
                Callback = cfg.Callback,
            })
        end
        return label
    end
    
    function adapter:AddColorPicker(cfg)
        -- Obsidian v3 pakai AddColorPicker di groupbox langsung
        if groupbox.AddColorPicker then
            groupbox:AddColorPicker(cfg.Flag or cfg.Name, {
                Title = cfg.Name or "Color",
                Default = cfg.Default or Color3.fromRGB(255, 255, 255),
                Callback = cfg.Callback,
            })
        else
            -- Fallback: pakai Label + ColorPicker
            local label = groupbox:AddLabel(cfg.Name or "Color")
            if label and label.AddColorPicker then
                label:AddColorPicker(cfg.Flag or cfg.Name, {
                    Default = cfg.Default or Color3.fromRGB(255, 255, 255),
                    Title = cfg.Name or "Color",
                    Callback = cfg.Callback,
                })
            end
        end
    end
    
    function adapter:AddSection(cfg)
        -- Nested section: return adapter baru ke groupbox yang sama
        return adapter
    end
    
    return adapter
end

print("[HyunjinHub] Adapter ready")

-- =====================================================
-- VD CONFIG 
-- =====================================================
getgenv().VD = getgenv().VD or {}

local VD = getgenv().VD

-- Reset semua flag ke default (false) setiap kali script di-run
VD.Destroyed             = false

-- Visual
VD.Fullbright            = false
VD.NO_Fog                = false
VD.VIS_WeatherTheme      = "Default"

-- Camera
VD.CAM_FOVEnabled        = false
VD.CAM_FOV               = 90
VD.CAM_ThirdPerson       = false
VD.CAM_ShiftLock         = false
VD.CAM_InfinityZoom      = false
VD.NoCutscene            = false
VD.SURV_FirstPerson      = false

-- Crosshair
VD.CROSS_Enabled         = false
VD.CROSS_Style           = "Dot"
VD.CROSS_Size            = 3
VD.CROSS_Thickness       = 4
VD.CROSS_Gap             = 6
VD.CROSS_PosX            = 0
VD.CROSS_PosY            = 0
VD.CROSS_Color           = Color3.fromRGB(255, 255, 255)

-- Game Info
VD.VIS_KystKiller        = false
VD.VIS_SpectatorCounter  = false
VD.VIS_KillerPerks       = false
VD.VIS_PredictMap        = false
VD.VIS_HideSurvivorIcon  = false
VD.VIS_ShowPingFPS       = false
VD.VIS_ShowHookCounter   = false

-- Survivor
VD.SURV_WarnKiller       = false

print("[HyunjinHub] VD config ready")

-- =====================================================
-- SERVICES & HELPERS
-- =====================================================
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local Lighting          = game:GetService("Lighting")
local Stats             = game:GetService("Stats")
local UserInputService  = game:GetService("UserInputService")
local LocalPlayer       = Players.LocalPlayer

-- Helper: parent GUI yang aman (CoreGui / gethui / PlayerGui)
local function GetSafeGuiParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core then return core end
    return LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
end

-- Helper: notifikasi
local function VD_Notify(title, content, duration)
    pcall(function()
        Library:Notify({
            Title = title,
            Description = content,
            Time = duration or 3,
        })
    end)
end

print("[HyunjinHub] Services ready")

-- =====================================================
-- HIGHLIGHT ESP V2 (dari KysHub)
-- =====================================================
do
    if getgenv().KYS_VD_VisualESP_Cleanup then
        pcall(getgenv().KYS_VD_VisualESP_Cleanup)
    end

    local LP = LocalPlayer
    local KYS_Dead = false

    local KYS_ESPState = {
        PlayerMasterESP = false,
        WorldMasterESP = false,
        ESPFillTransparency = 0.95,
        ESPOutlineTransparency = 0.3,
        ESPTextSize = 12,

        SurvivorESP = false,
        KillerESP = false,
        SpectatorESP = false,
        Nametags = false,
        DistanceESP = false,
        SurvivorItemsESP = false,

        SurvivorColor = Color3.fromRGB(0, 255, 0),
        KillerColor = Color3.fromRGB(255, 0, 0),
        SpectatorColor = Color3.fromRGB(255, 255, 255),

        GeneratorESP = false,
        HookESP = false,
        GateESP = false,
        WindowESP = false,
        PalletESP = false,
        SCPZombieESP = false,
        WorldNametags = false,
        WorldDistanceESP = false,

        GeneratorColor = Color3.fromRGB(0, 170, 255),
        HookColor = Color3.fromRGB(255, 0, 0),
        GateColor = Color3.fromRGB(255, 225, 0),
        WindowColor = Color3.fromRGB(255, 255, 255),
        PalletColor = Color3.fromRGB(255, 140, 0),
        SCPZombieColor = Color3.fromRGB(128, 0, 128),
    }

    getgenv().KYS_VD_VisualESP_State = KYS_ESPState

    getgenv().KYS_WorldReg = {
        Generator = {}, Hook = {}, Gate = {}, Window = {},
        Palletwrong = {}, SCPZombie = {},
    }
    local KYS_WorldReg = getgenv().KYS_WorldReg

    local KYS_MapAdd, KYS_MapRem = {}, {}
    local KYS_PlayerConns = {}
    local KYS_Connections = {}
    local KYS_PalletState = setmetatable({}, { __mode = "k" })
    local KYS_WindowState = setmetatable({}, { __mode = "k" })
    local KYS_InstanceIds = setmetatable({}, { __mode = "k" })
    local KYS_KystId = 0
    local KYS_PlayerLoopThread = nil
    local KYS_WorldLoopThread = nil
    local KYS_ESPFolder = nil

    local KYS_DisplayNames = {
        ["Motion Tracker"] = true, ["Gate"] = true, ["Flashlight"] = true,
        ["Bandage"] = true, ["Parrying Dagger"] = true, ["Adrenaline Shot"] = true,
        ["Twist of Fate"] = true, ["Shadow Clone"] = true, ["Holy Water"] = true,
        ["WaxBound Candle"] = true, ["Riot Shield"] = true, ["Emperor"] = true, ["AWP"] = true,
    }

    local function KYS_Alive(inst)
        if not inst then return false end
        local ok, parent = pcall(function() return inst.Parent end)
        return ok and parent ~= nil
    end

    local function KYS_Clamp(n, lo, hi)
        n = tonumber(n) or lo
        if n < lo then return lo end
        if n > hi then return hi end
        return n
    end

    local function KYS_PlayerKey(player)
        local id = player and player.UserId
        if id and id ~= 0 then return tostring(id) end
        return tostring(player and player.Name or "Unknown")
    end

    local function KYS_EspId(inst)
        if not inst then return "nil" end
        local id = KYS_InstanceIds[inst]
        if id then return id end
        KYS_KystId = KYS_KystId + 1
        id = tostring(KYS_KystId)
        KYS_InstanceIds[inst] = id
        return id
    end

    local function KYS_GetESPParent()
        local okCore, core = pcall(function() return game:GetService("CoreGui") end)
        if okCore and core then return core end
        if gethui then
            local okHui, hui = pcall(gethui)
            if okHui and hui then return hui end
        end
        local playerGui = LP and LP:FindFirstChildOfClass("PlayerGui")
        if playerGui then return playerGui end
        return Workspace
    end

    local function KYS_GetESPFolder()
        if KYS_ESPFolder and KYS_ESPFolder.Parent then return KYS_ESPFolder end

        local parent = KYS_GetESPParent()
        local old = parent:FindFirstChild("Hyunjin_VisualESP")
        if old then old:Destroy() end

        local folder = Instance.new("Folder")
        folder.Name = "Hyunjin_VisualESP"
        folder.Parent = parent
        KYS_ESPFolder = folder
        return folder
    end

    local function KYS_ClearPrefix(prefix, keepName)
        local folder = KYS_GetESPFolder()
        local keptExact = false
        for _, child in ipairs(folder:GetChildren()) do
            if child.Name:sub(1, #prefix) == prefix then
                if child.Name == keepName and not keptExact then
                    keptExact = true
                else
                    child:Destroy()
                end
            end
        end
    end

    local function KYS_ValidPart(part)
        return part and KYS_Alive(part) and part:IsA("BasePart")
    end

    local function KYS_FirstBasePart(inst)
        if not KYS_Alive(inst) then return nil end
        if inst:IsA("BasePart") then return inst end
        if inst:IsA("Model") then
            if inst.PrimaryPart and inst.PrimaryPart:IsA("BasePart") and KYS_Alive(inst.PrimaryPart) then
                return inst.PrimaryPart
            end
            local part = inst:FindFirstChildWhichIsA("BasePart", true)
            if KYS_ValidPart(part) then return part end
        end
        if inst:IsA("Tool") then
            local handle = inst:FindFirstChild("Handle") or inst:FindFirstChildWhichIsA("BasePart")
            if KYS_ValidPart(handle) then return handle end
        end
        return nil
    end

    local function KYS_GetRole(player)
        local teamName = player.Team and player.Team.Name and player.Team.Name:lower() or ""
        if teamName:find("killer") then return "Killer" end
        if teamName:find("survivor") then return "Survivor" end
        if teamName:find("spect") then return "Spectator" end
        return "Survivor"
    end

    local function KYS_PlayerRoleEnabled(player)
        local role = KYS_GetRole(player)
        if role == "Killer" then return KYS_ESPState.KillerESP end
        if role == "Spectator" then return KYS_ESPState.SpectatorESP end
        return KYS_ESPState.SurvivorESP
    end

    local function KYS_PlayerColor(player)
        local role = KYS_GetRole(player)
        if role == "Killer" then return KYS_ESPState.KillerColor end
        if role == "Spectator" then return KYS_ESPState.SpectatorColor end
        return KYS_ESPState.SurvivorColor
    end

    -- Simpan semua fungsi ini di getgenv supaya bisa diakses UI
    getgenv().KYS_ESPState = KYS_ESPState
    getgenv().KYS_GetRole = KYS_GetRole
    getgenv().KYS_PlayerRoleEnabled = KYS_PlayerRoleEnabled
    getgenv().KYS_PlayerColor = KYS_PlayerColor
    getgenv().KYS_ValidPart = KYS_ValidPart
    getgenv().KYS_Alive = KYS_Alive
    getgenv().KYS_Clamp = KYS_Clamp
    getgenv().KYS_PlayerKey = KYS_PlayerKey
    getgenv().KYS_EspId = KYS_EspId
    getgenv().KYS_GetESPFolder = KYS_GetESPFolder
    getgenv().KYS_ClearPrefix = KYS_ClearPrefix
    getgenv().KYS_FirstBasePart = KYS_FirstBasePart
    getgenv().KYS_DisplayNames = KYS_DisplayNames
    getgenv().KYS_WorldReg = KYS_WorldReg
    getgenv().KYS_PalletState = KYS_PalletState
    getgenv().KYS_WindowState = KYS_WindowState

    print("[HyunjinHub] ESP State initialized")
end

-- =====================================================
-- ESP RENDERING FUNCTIONS
-- =====================================================
do
    local KYS_ESPState = getgenv().KYS_ESPState
    local KYS_WorldReg = getgenv().KYS_WorldReg
    local KYS_GetESPFolder = getgenv().KYS_GetESPFolder
    local KYS_ClearPrefix = getgenv().KYS_ClearPrefix
    local KYS_ValidPart = getgenv().KYS_ValidPart
    local KYS_Alive = getgenv().KYS_Alive
    local KYS_PlayerKey = getgenv().KYS_PlayerKey
    local KYS_EspId = getgenv().KYS_EspId
    local KYS_GetRole = getgenv().KYS_GetRole
    local KYS_PlayerRoleEnabled = getgenv().KYS_PlayerRoleEnabled
    local KYS_PlayerColor = getgenv().KYS_PlayerColor
    local KYS_FirstBasePart = getgenv().KYS_FirstBasePart
    local KYS_PalletState = getgenv().KYS_PalletState
    local KYS_WindowState = getgenv().KYS_WindowState
    local KYS_Clamp = getgenv().KYS_Clamp
    local KYS_DisplayNames = getgenv().KYS_DisplayNames

    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LP = Players.LocalPlayer

    -- Fungsi: highlight entity
    local function KYS_EnsureHighlight(name, adornee, color, isPlayer)
        if not (adornee and KYS_Alive(adornee)) then return nil end
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix(name, name)

        local hl = folder:FindFirstChild(name)
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = name
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = folder
        end

        hl.Adornee = adornee
        hl.FillColor = color
        hl.OutlineColor = color
        if isPlayer then
            hl.FillTransparency = KYS_ESPState.ESPFillTransparency
            hl.OutlineTransparency = KYS_ESPState.ESPOutlineTransparency
        else
            hl.FillTransparency = 0.98
            hl.OutlineTransparency = 0.5
        end
        hl.Enabled = true
        return hl
    end

    local function KYS_DestroyChild(name)
        local folder = KYS_GetESPFolder()
        local child = folder:FindFirstChild(name)
        if child then child:Destroy() end
    end

    local function KYS_ClearPlayerESP(player)
        if not player or player == LP then return end
        local key = KYS_PlayerKey(player)
        KYS_DestroyChild("KYS_PlayerHL_" .. key)
        KYS_DestroyChild("KYS_PlayerTag_" .. key)
        KYS_DestroyChild("KYS_PlayerItem_" .. key)
    end

    local function KYS_ClearAllPlayerESP()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then KYS_ClearPlayerESP(player) end
        end
    end

    local function KYS_SetBillboardLine(parent, index, count, data)
        local label = parent:FindFirstChild("Line" .. index)
        if not label then
            label = Instance.new("TextLabel")
            label.Name = "Line" .. index
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.Font = Enum.Font.Gotham
            label.TextStrokeTransparency = 0.65
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.Parent = parent
        end
        label.Size = UDim2.new(1, 0, 1 / count, 0)
        label.Position = UDim2.new(0, 0, (index - 1) / count, 0)
        label.TextSize = KYS_ESPState.ESPTextSize
        label.TextColor3 = data.Color
        label.Text = data.Text
    end

    local function KYS_PruneBillboardLines(parent, count)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("TextLabel") then
                local index = tonumber(child.Name:match("%d+"))
                if index and index > count then child:Destroy() end
            end
        end
    end

    local function KYS_UpdatePlayerTag(player, character, head, color)
        local key = KYS_PlayerKey(player)
        local tagName = "KYS_PlayerTag_" .. key
        local folder = KYS_GetESPFolder()
        KYS_ClearPrefix("KYS_PlayerTag_" .. key, tagName)

        if not KYS_ValidPart(head) then
            KYS_DestroyChild(tagName)
            return
        end

        local lines = {}
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
        local distanceText = ""
        if KYS_ESPState.DistanceESP and root and targetRoot then
            distanceText = "[" .. tostring(math.floor((root.Position - targetRoot.Position).Magnitude)) .. "m]"
        end

        local nameText = KYS_ESPState.Nametags and player.Name or ""
        local mainLine = ""
        if nameText ~= "" and distanceText ~= "" then
            mainLine = nameText .. " " .. distanceText
        elseif nameText ~= "" then
            mainLine = nameText
        elseif distanceText ~= "" then
            mainLine = distanceText
        end

        if mainLine ~= "" then
            table.insert(lines, { Text = mainLine, Color = color })
        end

        if #lines == 0 then
            KYS_DestroyChild(tagName)
            return
        end

        local tag = folder:FindFirstChild(tagName)
        if not tag then
            tag = Instance.new("BillboardGui")
            tag.Name = tagName
            tag.AlwaysOnTop = true
            tag.LightInfluence = 0
            tag.MaxDistance = 0
            tag.Parent = folder
        end

        tag.Adornee = head
        tag.Enabled = true
        tag.Size = UDim2.new(0, 220, 0, #lines * 20)
        tag.StudsOffset = Vector3.new(0, 2.65, 0)

        for i, data in ipairs(lines) do
            KYS_SetBillboardLine(tag, i, #lines, data)
        end
        KYS_PruneBillboardLines(tag, #lines)
    end

    local function KYS_ApplyPlayerESP(player)
    if not player or player == LP then return end
    local character = player.Character
    if not (character and KYS_Alive(character)) then
        KYS_ClearPlayerESP(player)
        return
    end

    local key = KYS_PlayerKey(player)
    local enabled = KYS_ESPState.PlayerMasterESP and KYS_PlayerRoleEnabled(player)
    print("[DEBUG] Player:", player.Name, "| MasterESP:", KYS_ESPState.PlayerMasterESP, "| RoleEnabled:", KYS_PlayerRoleEnabled(player), "| Role:", KYS_GetRole(player))
    if not enabled then
        KYS_ClearPlayerESP(player)
        return
    end

        local color = KYS_PlayerColor(player)
        local head = character:FindFirstChild("Head")
        local torso = character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChild("UpperTorso")
            or character:FindFirstChild("Torso")

        KYS_EnsureHighlight("KYS_PlayerHL_" .. key, character, color, true)
        KYS_UpdatePlayerTag(player, character, head, color)
    end

    local function KYS_RefreshAllPlayers()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then pcall(KYS_ApplyPlayerESP, player) end
        end
    end

    local function KYS_StartPlayerLoop()
        if getgenv().KYS_PlayerLoopThread then return end
        getgenv().KYS_PlayerLoopThread = task.spawn(function()
            while KYS_ESPState.PlayerMasterESP do
                KYS_RefreshAllPlayers()
                task.wait(0.25)
            end
            getgenv().KYS_PlayerLoopThread = nil
        end)
    end

    local function KYS_WatchPlayer(player)
        if player == LP then return end
        if getgenv().KYS_PlayerConns and getgenv().KYS_PlayerConns[player] then
            for _, conn in ipairs(getgenv().KYS_PlayerConns[player]) do
                if conn then pcall(function() conn:Disconnect() end) end
            end
        end
        getgenv().KYS_PlayerConns = getgenv().KYS_PlayerConns or {}
        getgenv().KYS_PlayerConns[player] = {}

        table.insert(getgenv().KYS_PlayerConns[player], player.CharacterAdded:Connect(function()
            KYS_ClearPlayerESP(player)
            task.delay(0.15, function() pcall(KYS_ApplyPlayerESP, player) end)
        end))
        table.insert(getgenv().KYS_PlayerConns[player], player.CharacterRemoving:Connect(function()
            KYS_ClearPlayerESP(player)
        end))
        table.insert(getgenv().KYS_PlayerConns[player], player:GetPropertyChangedSignal("Team"):Connect(function()
            KYS_ClearPlayerESP(player)
            pcall(KYS_ApplyPlayerESP, player)
        end))

        if player.Character then pcall(KYS_ApplyPlayerESP, player) end
    end

    -- Simpan ke getgenv supaya bisa dipakai UI
    getgenv().KYS_RefreshAllPlayers = KYS_RefreshAllPlayers
    getgenv().KYS_StartPlayerLoop = KYS_StartPlayerLoop
    getgenv().KYS_ClearAllPlayerESP = KYS_ClearAllPlayerESP
    getgenv().KYS_WatchPlayer = KYS_WatchPlayer
    getgenv().KYS_EnsureHighlight = KYS_EnsureHighlight

    -- Watch player yang sudah ada & yang baru join
    for _, player in ipairs(Players:GetPlayers()) do
        KYS_WatchPlayer(player)
    end
    Players.PlayerAdded:Connect(KYS_WatchPlayer)

    print("[HyunjinHub] ESP Render functions ready")
end

-- =====================================================
-- ESP UI CONTROLS (Highlight ESP)
-- =====================================================
do
    local KYS_ESPState = getgenv().KYS_ESPState

    -- Groupbox ESP di tab Visual
    local GroupESP = Tabs.Visual:AddLeftGroupbox("Highlight ESP", "eye")
    local AdapterESP = MakeAdapter(GroupESP)

    -- === PLAYER ESP ===
    AdapterESP:AddToggle({
        Name = "Enable Player ESP",
        Flag = "KYS_Enable_Player_ESP",
        Default = false,
        Callback = function(state)
            KYS_ESPState.PlayerMasterESP = state
            if state then
                getgenv().KYS_StartPlayerLoop()
                getgenv().KYS_RefreshAllPlayers()
            else
                getgenv().KYS_ClearAllPlayerESP()
            end
        end,
    })

    AdapterESP:AddDropdown({
        Name = "Player ESP Filter",
        Flag = "KYS_Player_ESP_Filter",
        Values = { "Survivor ESP", "Killer ESP", "Spectator ESP" },
        Multi = true,
        AllowNone = true,
        Default = {},
        Callback = function(selected)
            local function selected_has(name)
                if type(selected) ~= "table" then return false end
                for _, v in pairs(selected) do
                    if v == name then return true end
                end
                return false
            end
            KYS_ESPState.SurvivorESP = selected_has("Survivor ESP")
            KYS_ESPState.KillerESP = selected_has("Killer ESP")
            KYS_ESPState.SpectatorESP = selected_has("Spectator ESP")
            if KYS_ESPState.PlayerMasterESP then
                getgenv().KYS_RefreshAllPlayers()
            end
        end,
    })

    AdapterESP:AddToggle({
        Name = "Player Nametags",
        Flag = "KYS_Player_Nametags",
        Default = false,
        Callback = function(state)
            KYS_ESPState.Nametags = state
            if KYS_ESPState.PlayerMasterESP then getgenv().KYS_RefreshAllPlayers() end
        end,
    })

    AdapterESP:AddToggle({
        Name = "Player Distance",
        Flag = "KYS_Player_Distance",
        Default = false,
        Callback = function(state)
            KYS_ESPState.DistanceESP = state
            if KYS_ESPState.PlayerMasterESP then getgenv().KYS_RefreshAllPlayers() end
        end,
    })

    AdapterESP:AddDivider({})

    AdapterESP:AddSlider({
        Name = "ESP Fill Transparency",
        Flag = "KYS_ESP_Fill_Transparency",
        Min = 0, Max = 1, Default = 0.95, Increment = 0.01,
        Callback = function(v)
            KYS_ESPState.ESPFillTransparency = v
            if KYS_ESPState.PlayerMasterESP then getgenv().KYS_RefreshAllPlayers() end
        end,
    })

    AdapterESP:AddSlider({
        Name = "ESP Outline Transparency",
        Flag = "KYS_ESP_Outline_Transparency",
        Min = 0, Max = 1, Default = 0.3, Increment = 0.01,
        Callback = function(v)
            KYS_ESPState.ESPOutlineTransparency = v
            if KYS_ESPState.PlayerMasterESP then getgenv().KYS_RefreshAllPlayers() end
        end,
    })

    AdapterESP:AddSlider({
        Name = "ESP Text Size",
        Flag = "KYS_ESP_Text_Size",
        Min = 8, Max = 22, Default = 12, Increment = 1,
        Callback = function(v)
            KYS_ESPState.ESPTextSize = v
            if KYS_ESPState.PlayerMasterESP then getgenv().KYS_RefreshAllPlayers() end
        end,
    })

    print("[HyunjinHub] ESP UI created")
end
