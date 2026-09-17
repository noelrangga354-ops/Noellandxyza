-- example script by https://github.com/mstudio45/LinoriaLib/blob/main/Example.lua and modified by deivid
-- Patched Example: this single file applies all UI changes to the library
-- at runtime, so you can just run it without any other local files.
-- No readfile needed, falls back to the GitHub repo.

local repo = "https://raw.githubusercontent.com/noelrangga354-ops/Noellandxyza/main/"

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
-- LOAD SRC.LUA DARI GITHUB LU SENDIRI
-- =====================================================
local srcRepo = "https://raw.githubusercontent.com/noelrangga354-ops/Noellandxyza/main/src.lua"

local success, err = pcall(function()
    local srcCode = game:HttpGet(srcRepo)
    local fn, compileErr = loadstring(srcCode)
    if not fn then
        error("Gagal compile src.lua: " .. tostring(compileErr))
    end
    fn() -- Jalankan script src.lua
end)

if not success then
    warn("[HyunjinHub] Gagal load src.lua:", err)
    Library:Notify({
        Title = "Error",
        Description = "Gagal load src.lua. Cek console.",
        Time = 5,
    })
end
