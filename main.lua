-- =================================================================================
-- Hyunjin GUI - WindUI Edition (Violence District) - Optimized & Enhanced Version
-- =================================================================================

-- Load Fiskha's Backend Modules for Auto Carry, Auto Hook, Emotes, & Animations
task.spawn(function()
    pcall(function()
        local fiskhaScripts = {
            'Killer/AutoCarry.lua',
            'Emotes/Emotes.lua',
            'Emotes/AnimationSpeed.lua',
            'Emotes/CustomAnim.lua',
        }
        local fiskhaBaseUrl = 'https://raw.githubusercontent.com/Fishka132312/Violence-District/refs/heads/main/Things/'
        for _, scriptName in ipairs(fiskhaScripts) do
            pcall(function()
                local code = game:HttpGet(fiskhaBaseUrl .. scriptName)
                if code then loadstring(code)() end
            end)
        end
    end)
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local CollectionService = game:GetService("CollectionService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

-- Helper Functions
local function getRoot()
    local char = Player.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
end

local function GetGameValue(obj, name)
    if not obj then return nil end
    local success, val = pcall(function()
        if obj:GetAttribute(name) ~= nil then return obj:GetAttribute(name) end
        local stats = obj:FindFirstChild("leaderstats") or obj:FindFirstChild("Data") or obj:FindFirstChild("Stats")
        if stats and stats:FindFirstChild(name) then return stats:FindFirstChild(name).Value end
        local child = obj:FindFirstChild(name)
        if child and child.Value ~= nil then return child.Value end
        return nil
    end)
    if success then return val end
    return nil
end

local function applyCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
end

local function applyStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(45, 45, 45)
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.3
    stroke.Parent = parent
end

local function TriggerMobileAction(pathName)
    local current = PlayerGui
    for segment in string.gmatch(pathName, "[^%.]+") do
        current = current and current:FindFirstChild(segment)
    end
    if current and current:IsA("GuiObject") then
        local p, s, i = current.AbsolutePosition, current.AbsoluteSize, game:GetService("GuiService"):GetGuiInset()
        local cx, cy = p.X + (s.X/2) + i.X, p.Y + (s.Y/2) + i.Y
        pcall(function()
            VirtualInputManager:SendTouchEvent(8822, 0, cx, cy)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(8822, 2, cx, cy)
        end)
    end
end

-- Secure Global Input Handler for Scrolling Frame Protection
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        pcall(function()
            for _, gui in ipairs({PlayerGui, CoreGui}) do
                for _, desc in ipairs(gui:GetDescendants()) do
                    if desc:IsA("ScrollingFrame") then
                        desc.ScrollingEnabled = true
                    end
                end
            end
        end)
    end
end)

-- Load WindUI securely
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Define Custom Themes
WindUI:AddTheme({
    Name = "DarkDark",
    Accent = "#333333",
    Outline = "#1f1f1f",
    Text = "#f5f5f5",
    Placeholder = "#888888",
    Background = "#0b0b0b",
    Window = "#0f0f0f",
    Button = "#141414",
    Icon = "#888888",
})

WindUI:AddTheme({
    Name = "DarkWhite",
    Accent = "#e0e0e0",
    Outline = "#333333",
    Text = "#ffffff",
    Placeholder = "#aaaaaa",
    Background = "#111111",
    Window = "#161616",
    Button = "#1e1e1e",
    Icon = "#aaaaaa",
})

WindUI:AddTheme({
    Name = "DarkPurple",
    Accent = "#9b59b6",
    Outline = "#2c1b33",
    Text = "#f5f5f5",
    Placeholder = "#9a8ca0",
    Background = "#100c14",
    Window = "#150f1b",
    Button = "#1c1226",
    Icon = "#9a8ca0",
})

WindUI:AddTheme({
    Name = "DarkRedModern",
    Accent = "#e12d4b",
    Outline = "#321920",
    Text = "#f5f5f5",
    Placeholder = "#a08c91",
    Background = "#120c0e",
    Window = "#180f12",
    Button = "#1e1216",
    Icon = "#a08c91",
})

WindUI:SetTheme("DarkDark")

-- Create Main Window
local Window = WindUI:CreateWindow({
    Title = "Hyunjin GUI",
    Author = "VIOLENCE DISTRICT",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 480),
    Acrylic = true,
    Theme = "DarkDark",
    Transparent = true,
    Resizable = true,
    MaximizeButton = true,
    MinimizeButton = true,
    Icon = "chevron-first",
    SideBarWidth = 180,
    HasOutline = true,
    HideSearchBar = false,
})

-- TOPBAR BUTTON
pcall(function()
    Window.Topbar:Button({
        Name = "HealRemoteButton",
        Icon = "briefcase-medical",
        LayoutOrder = 1,
        IconThemed = true,
        Callback = function()
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local healingFolder = remotes and remotes:FindFirstChild("Healing")
                local healEvent = healingFolder and healingFolder:FindFirstChild("HealEvent")
                local char = Player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if healEvent and hrp then
                    healEvent:FireServer(hrp, true)
                    WindUI:Notify({ Title = "Heal Remote", Content = "Berhasil menembak remote heal 1x!", Duration = 1.5 })
                else
                    WindUI:Notify({ Title = "Heal Remote", Content = "Remote heal tidak ditemukan!", Duration = 1.5 })
                end
            end)
        end
    })
end)

-- TABS DEFINITION
local HomeTab = Window:Tab({ Title = "Home", Icon = "house" })
local SurvivorTab = Window:Tab({ Title = "Survivor", Icon = "user" })
local KillerTab = Window:Tab({ Title = "Killer", Icon = "sword" })
local VisualTab = Window:Tab({ Title = "Visual", Icon = "eye" })
local UpdateTab = Window:Tab({ Title = "Update", Icon = "terminal" })
local LocationTab = Window:Tab({ Title = "Location", Icon = "map-pin" })
local CheckTab = Window:Tab({ Title = "Misc", Icon = "settings" })
local HvHTab = Window:Tab({ Title = "About", Icon = "info" })

-- PRELOAD SURVIVOR MODULES
task.spawn(function()
    pcall(function()
        local modulesFolder = ReplicatedStorage:FindFirstChild("Modules")
        if modulesFolder then
            local survModules = modulesFolder:FindFirstChild("Survivors")
            if survModules then
                survModules:WaitForChild("SurvivorActions", 2)
                survModules:WaitForChild("SurvivorAnimationsController", 2)
                survModules:WaitForChild("SurvivorConfig", 2)
                survModules:WaitForChild("SurvivorController", 2)
                survModules:WaitForChild("SurvivorProximity", 2)
            end
        end
    end)
end)

-- INTEGRATED BACKEND SYSTEMS
local Movement = {
    JumpPowerEnabled = false,
    JumpPowerValue = 100,
    OriginalJumpPower = 50,
    WalkSpeedEnabled = false,
    WalkSpeedValue = 20,
    OriginalWalkSpeed = 16,
}

local function applyJumpPower()
    if not Movement.JumpPowerEnabled then return end
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = Movement.JumpPowerValue end
end

local function applyWalkSpeed()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and Movement.WalkSpeedEnabled then
        hum.WalkSpeed = Movement.WalkSpeedValue
    end
end

RunService.Heartbeat:Connect(function()
    if Movement.WalkSpeedEnabled then
        local char = Player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= Movement.WalkSpeedValue then
            hum.WalkSpeed = Movement.WalkSpeedValue
        end
    end
end)

Player.CharacterAdded:Connect(function()
    task.wait(0.8)
    applyJumpPower()
    applyWalkSpeed()
end)

-- Advanced Avatar Stealer Engine
local AvatarStealer = { TargetUsername = "" }
local function vzImqwp(vnqDZuQ0XQ)
    if not vnqDZuQ0XQ or vnqDZuQ0XQ:gsub("%s+", "") == "" then return end
    vnqDZuQ0XQ = vnqDZuQ0XQ:gsub("%s+", "")
    task.spawn(function()
        local num1 = tonumber(vnqDZuQ0XQ)
        if not num1 then
            local success = pcall(function()
                num1 = Players:GetUserIdFromNameAsync(vnqDZuQ0XQ)
            end)
            if not success or not num1 then return end
        end

        local inst105 = Player.Character
        local char95 = inst105 and inst105:FindFirstChildOfClass("Humanoid")
        if not inst105 or not char95 then return end

        local char96 = Players:GetHumanoidDescriptionFromUserId(num1)
        if not char96 then return end

        local inst106 = Players:CreateHumanoidModelFromDescription(char96, char95.RigType)
        if not inst106 then return end

        for _, Qx_UXQb_N in ipairs(inst105:GetChildren()) do
            if Qx_UXQb_N:IsA("Accessory") or Qx_UXQb_N:IsA("Shirt") or Qx_UXQb_N:IsA("Pants") or Qx_UXQb_N:IsA("ShirtGraphic") or Qx_UXQb_N:IsA("BodyColors") or Qx_UXQb_N:IsA("CharacterMesh") then
                Qx_UXQb_N:Destroy()
            end
        end

        for _, MWzUWQqDZnOHmW in ipairs(inst105:GetChildren()) do
            if MWzUWQqDZnOHmW:IsA("BasePart") then
                for _, pbmxO1WZI in ipairs(MWzUWQqDZnOHmW:GetChildren()) do
                    if pbmxO1WZI:IsA("SpecialMesh") or pbmxO1WZI:IsA("Decal") or pbmxO1WZI:IsA("Texture") or pbmxO1WZI:IsA("SurfaceAppearance") then
                        pbmxO1WZI:Destroy()
                    end
                end
            end
        end

        local color18 = inst106:FindFirstChildOfClass("BodyColors")
        if color18 then
            color18:Clone().Parent = inst105
            local inst107 = {
                Head = color18.HeadColor3, Torso = color18.TorsoColor3,
                ["Left Arm"] = color18.LeftArmColor3, ["Right Arm"] = color18.RightArmColor3,
                ["Left Leg"] = color18.LeftLegColor3, ["Right Leg"] = color18.RightLegColor3,
                UpperTorso = color18.TorsoColor3, LowerTorso = color18.TorsoColor3,
                LeftHand = color18.LeftArmColor3, RightHand = color18.RightArmColor3,
                LeftLowerArm = color18.LeftArmColor3, RightLowerArm = color18.RightLowerArmColor3,
                LeftUpperArm = color18.LeftArmColor3, RightUpperArm = color18.RightUpperArmColor3,
                LeftFoot = color18.LeftLegColor3, RightFoot = color18.RightLegColor3,
                LeftLowerLeg = color18.LeftLegColor3, RightLowerLeg = color18.RightLowerLegColor3,
                LeftUpperLeg = color18.LeftLegColor3, RightUpperLeg = color18.RightUpperLegColor3,
            }
            for oIW0OxMHIZH, QuqHOQ1lQ_zQv in pairs(inst107) do
                local color19 = inst105:FindFirstChild(oIW0OxMHIZH)
                if color19 then
                    pcall(function() color19.Color = QuqHOQ1lQ_zQv end)
                end
            end
        end

        for _, wIl1lxpxZlHnMo in ipairs(inst106:GetChildren()) do
            if wIl1lxpxZlHnMo:IsA("Shirt") or wIl1lxpxZlHnMo:IsA("Pants") or wIl1lxpxZlHnMo:IsA("ShirtGraphic") or wIl1lxpxZlHnMo:IsA("CharacterMesh") then
                wIl1lxpxZlHnMo:Clone().Parent = inst105
            end
        end

        for _, NvuqulXXlbzn in ipairs(inst106:GetChildren()) do
            if NvuqulXXlbzn:IsA("BasePart") then
                local part18 = inst105:FindFirstChild(NvuqulXXlbzn.Name)
                if part18 and part18:IsA("BasePart") then
                    for _, MIM_Oxx in ipairs(NvuqulXXlbzn:GetChildren()) do
                        if MIM_Oxx:IsA("SpecialMesh") or MIM_Oxx:IsA("Decal") or MIM_Oxx:IsA("Texture") or MIM_Oxx:IsA("SurfaceAppearance") then
                            MIM_Oxx:Clone().Parent = part18
                        end
                    end
                end
            end
        end

        local function _HHzNQXb(OpXUnWomU)
            local inst108 = OpXUnWomU:Clone()
            inst108.Parent = inst105
            local inst109 = inst108:FindFirstChild("Handle")
            if not inst109 then return end
            inst109.Anchored = false
            inst109.CanCollide = false
            pcall(function() inst109.Massless = true end)
            for _, lXO0Qo in ipairs(inst109:GetChildren()) do
                if lXO0Qo:IsA("Weld") or lXO0Qo:IsA("WeldConstraint") or lXO0Qo:IsA("Motor6D") then
                    lXO0Qo:Destroy()
                end
            end
            pcall(function() char95:AddAccessory(inst108) end)
        end

        for _, WzNZNDWoUMm in ipairs(inst106:GetChildren()) do
            if WzNZNDWoUMm:IsA("Accessory") then
                pcall(function() _HHzNQXb(WzNZNDWoUMm) end)
            end
        end
        inst106:Destroy()
        WindUI:Notify({ Title = "Avatar Copy", Content = "Berhasil menyalin avatar target!", Duration = 2 })
    end)
end

-- PERSISTENT CACHE VARIABLES (HOME TAB)
local cachedLevel = "1"
local cachedGears = "0"
local cachedScrews = "0"
local cachedKC = "0"
local currentMapStr = "Menunggu..."
local currentKillerStr = "Mencari..."
local currentGenStr = "0 / 7"

local MapCoords = {
    ["scp"] = {{-53.2, 284.9, -551.7}},
    ["club"] = {{1560.1, 153.1, -789.0}},
    ["firelinkshrine"] = {{-680.4, 133.7, -7879.8}},
    ["rooftophospital"] = {{3019.2, 455.8, -5410.6}},
    ["asylum"] = {{-1825.7, 173.8, -3313.4}},
    ["harbor"] = {{-1364.3, 59.7, -1324.3}},
    ["re4"] = {{1187.9, -18.1, -186.2}},
    ["forest"] = {{-212.2, 29.9, -1486.4}},
}

local currentMapKey = "club"

-- ==========================================
-- 1. HOME TAB (PLAYER CARDS & MATCH STATUS)
-- ==========================================
local PlayersCardsParagraph = HomeTab:Paragraph({
    Title = "Players In Game",
    Desc = "",
    Image = "users",
    ImageSize = 20,
})

local PlayerCardsContainer = Instance.new("Frame")
PlayerCardsContainer.Name = "PlayerCardsContainer"
PlayerCardsContainer.Size = UDim2.new(1, 0, 0, 135)
PlayerCardsContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
PlayerCardsContainer.BorderSizePixel = 0
applyCorner(PlayerCardsContainer, 8)
applyStroke(PlayerCardsContainer, Color3.fromRGB(45, 45, 45), 1)

local HorizontalScrollFrame = Instance.new("ScrollingFrame")
HorizontalScrollFrame.Name = "PlayerCardsScrollFrame"
HorizontalScrollFrame.Size = UDim2.new(1, -8, 1, -8)
HorizontalScrollFrame.Position = UDim2.new(0, 4, 0, 4)
HorizontalScrollFrame.BackgroundTransparency = 1
HorizontalScrollFrame.BorderSizePixel = 0
HorizontalScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
HorizontalScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
HorizontalScrollFrame.ScrollingDirection = Enum.ScrollingDirection.X
HorizontalScrollFrame.ScrollBarThickness = 3
HorizontalScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(225, 45, 75)
HorizontalScrollFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.None
HorizontalScrollFrame.Parent = PlayerCardsContainer

local CardsListLayout = Instance.new("UIListLayout")
CardsListLayout.FillDirection = Enum.FillDirection.Horizontal
CardsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
CardsListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
CardsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
CardsListLayout.Padding = UDim.new(0, 8)
CardsListLayout.Parent = HorizontalScrollFrame

local CardsPadding = Instance.new("UIPadding")
CardsPadding.PaddingLeft = UDim.new(0, 4)
CardsPadding.PaddingRight = UDim.new(0, 4)
CardsPadding.PaddingTop = UDim.new(0, 2)
CardsPadding.PaddingBottom = UDim.new(0, 2)
CardsPadding.Parent = HorizontalScrollFrame

task.spawn(function()
    task.wait(0.3)
    pcall(function()
        local targetParent = nil
        for _, gui in ipairs({CoreGui, PlayerGui}) do
            for _, desc in ipairs(gui:GetDescendants()) do
                if desc:IsA("TextLabel") and desc.Text == "Players In Game" then
                    targetParent = desc.Parent and desc.Parent.Parent and desc.Parent.Parent.Parent
                    break
                end
            end
            if targetParent then break end
        end
        if targetParent then
            PlayerCardsContainer.Parent = targetParent
        end
    end)
end)

local function UpdatePlayerCards(playerDataList)
    local activeKeys = {}
    for i, data in ipairs(playerDataList) do
        local cardKey = data.Name
        activeKeys[cardKey] = true

        local card = HorizontalScrollFrame:FindFirstChild("Card_" .. cardKey)
        local userId = data.Player and data.Player.UserId or 1
        local thumb = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150"

        if not card then
            card = Instance.new("Frame")
            card.Name = "Card_" .. cardKey
            card.Size = UDim2.new(0, 110, 0, 124)
            card.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            card.Parent = HorizontalScrollFrame

            applyCorner(card, 8)
            applyStroke(card, Color3.fromRGB(45, 45, 45), 1)

            local progressContainer = Instance.new("Frame")
            progressContainer.Name = "ProgressContainer"
            progressContainer.Size = UDim2.new(0, 44, 0, 44)
            progressContainer.Position = UDim2.new(0.5, -22, 0, 2)
            progressContainer.BackgroundTransparency = 1
            progressContainer.Visible = false
            progressContainer.Parent = card

            local aspect = Instance.new("UIAspectRatioConstraint")
            aspect.AspectRatio = 1
            aspect.Parent = progressContainer

            local frame1 = Instance.new("Frame")
            frame1.Name = "Frame1"
            frame1.Size = UDim2.new(0.5, 0, 1, 0)
            frame1.Position = UDim2.new(0, 0, 0, 0)
            frame1.BackgroundTransparency = 1
            frame1.ClipsDescendants = true
            frame1.Parent = progressContainer

            local img1 = Instance.new("ImageLabel")
            img1.Size = UDim2.new(2, 0, 1, 0)
            img1.Position = UDim2.new(0, 0, 0, 0)
            img1.BackgroundTransparency = 1
            img1.Image = "rbxassetid://6071575925"
            img1.ImageColor3 = Color3.fromRGB(225, 45, 75)
            img1.Parent = frame1

            local grad1 = Instance.new("UIGradient")
            grad1.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(0.51, 1),
                NumberSequenceKeypoint.new(1, 1)
            })
            grad1.Rotation = 180
            grad1.Parent = img1

            local frame2 = Instance.new("Frame")
            frame2.Name = "Frame2"
            frame2.Size = UDim2.new(0.5, 0, 1, 0)
            frame2.Position = UDim2.new(0.5, 0, 0, 0)
            frame2.BackgroundTransparency = 1
            frame2.ClipsDescendants = true
            frame2.Parent = progressContainer

            local img2 = Instance.new("ImageLabel")
            img2.Size = UDim2.new(2, 0, 1, 0)
            img2.Position = UDim2.new(-1, 0, 0, 0)
            img2.BackgroundTransparency = 1
            img2.Image = "rbxassetid://6071575925"
            img2.ImageColor3 = Color3.fromRGB(225, 45, 75)
            img2.Parent = frame2

            local grad2 = Instance.new("UIGradient")
            grad2.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(0.51, 1),
                NumberSequenceKeypoint.new(1, 1)
            })
            grad2.Rotation = 180
            grad2.Parent = img2

            local img = Instance.new("ImageLabel")
            img.Name = "Avatar"
            img.Size = UDim2.new(0, 36, 0, 36)
            img.Position = UDim2.new(0.5, -18, 0, 6)
            img.BackgroundTransparency = 1
            img.Image = thumb
            img.Parent = card
            applyCorner(img, 18)
            applyStroke(img, Color3.fromRGB(225, 45, 75), 1)

            local antiHealLbl = Instance.new("TextLabel")
            antiHealLbl.Name = "Antiheal"
            antiHealLbl.Size = UDim2.new(0, 14, 0, 14)
            antiHealLbl.Position = UDim2.new(0, 4, 0, 4)
            antiHealLbl.BackgroundTransparency = 1
            antiHealLbl.Text = "🛡️"
            antiHealLbl.TextSize = 10
            antiHealLbl.Visible = false
            antiHealLbl.Parent = card

            local hookLbl = Instance.new("TextLabel")
            hookLbl.Name = "Counter"
            hookLbl.Size = UDim2.new(0, 24, 0, 14)
            hookLbl.Position = UDim2.new(1, -28, 0, 4)
            hookLbl.BackgroundTransparency = 1
            hookLbl.Text = ""
            hookLbl.TextColor3 = Color3.fromRGB(255, 60, 80)
            hookLbl.TextSize = 10
            hookLbl.Font = Enum.Font.GothamBold
            hookLbl.Parent = card

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Name = "Name"
            nameLbl.Size = UDim2.new(1, -8, 0, 14)
            nameLbl.Position = UDim2.new(0, 4, 0, 44)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = data.Name
            nameLbl.TextColor3 = Color3.fromRGB(245, 245, 245)
            nameLbl.TextSize = 10
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.TextXAlignment = Enum.TextXAlignment.Center
            nameLbl.Parent = card

            local lvlLbl = Instance.new("TextLabel")
            lvlLbl.Name = "Level"
            lvlLbl.Size = UDim2.new(1, -8, 0, 12)
            lvlLbl.Position = UDim2.new(0, 4, 0, 59)
            lvlLbl.BackgroundTransparency = 1
            lvlLbl.Text = "Lvl: " .. data.Level
            lvlLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
            lvlLbl.TextSize = 9
            lvlLbl.Font = Enum.Font.Gotham
            lvlLbl.TextXAlignment = Enum.TextXAlignment.Center
            lvlLbl.Parent = card

            local kcLbl = Instance.new("TextLabel")
            kcLbl.Name = "KC"
            kcLbl.Size = UDim2.new(1, -8, 0, 12)
            kcLbl.Position = UDim2.new(0, 4, 0, 73)
            kcLbl.BackgroundTransparency = 1
            kcLbl.Text = "💀 " .. data.KC .. "%"
            kcLbl.TextColor3 = Color3.fromRGB(225, 45, 75)
            kcLbl.TextSize = 9
            kcLbl.Font = Enum.Font.GothamBold
            kcLbl.TextXAlignment = Enum.TextXAlignment.Center
            kcLbl.Parent = card

            local roleBadge = Instance.new("Frame")
            roleBadge.Name = "RoleBadge"
            roleBadge.Size = UDim2.new(1, -12, 0, 16)
            roleBadge.Position = UDim2.new(0, 6, 0, 92)
            if data.Role == "KILLER" then
                roleBadge.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            elseif data.Role == "SPECTATOR" then
                roleBadge.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            else
                roleBadge.BackgroundColor3 = Color3.fromRGB(40, 120, 220)
            end
            roleBadge.Parent = card
            applyCorner(roleBadge, 4)

            local tagLbl = Instance.new("TextLabel")
            tagLbl.Name = "Tag"
            tagLbl.Size = UDim2.new(1, 0, 1, 0)
            tagLbl.BackgroundTransparency = 1
            tagLbl.Text = data.Role
            tagLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
            tagLbl.TextSize = 8
            tagLbl.Font = Enum.Font.GothamBold
            tagLbl.TextXAlignment = Enum.TextXAlignment.Center
            tagLbl.Parent = roleBadge

            local progressBarBg = Instance.new("Frame")
            progressBarBg.Name = "ProgressBarBg"
            progressBarBg.Size = UDim2.new(1, -12, 0, 4)
            progressBarBg.Position = UDim2.new(0, 6, 1, -8)
            progressBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            progressBarBg.BorderSizePixel = 0
            progressBarBg.Visible = false
            progressBarBg.Parent = card
            applyCorner(progressBarBg, 2)

            local progressBarFill = Instance.new("Frame")
            progressBarFill.Name = "Fill"
            progressBarFill.Size = UDim2.new(0, 0, 1, 0)
            progressBarFill.BackgroundColor3 = Color3.fromRGB(74, 255, 181)
            progressBarFill.BorderSizePixel = 0
            progressBarFill.Parent = progressBarBg
            applyCorner(progressBarFill, 2)
        else
            local lvlLbl = card:FindFirstChild("Level")
            if lvlLbl then lvlLbl.Text = "Lvl: " .. data.Level end

            local kcLbl = card:FindFirstChild("KC")
            if kcLbl then kcLbl.Text = "💀 " .. data.KC .. "%" end

            local roleBadge = card:FindFirstChild("RoleBadge")
            if roleBadge then
                if data.Role == "KILLER" then
                    roleBadge.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
                elseif data.Role == "SPECTATOR" then
                    roleBadge.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
                else
                    roleBadge.BackgroundColor3 = Color3.fromRGB(40, 120, 220)
                end
            end

            local tagLbl = roleBadge and roleBadge:FindFirstChild("Tag") or card:FindFirstChild("Tag")
            if tagLbl then
                tagLbl.Text = data.Role
                tagLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
            end
            applyStroke(card, Color3.fromRGB(45, 45, 45), 1)
        end

        pcall(function()
            local plrObj = data.Player
            local char = plrObj and plrObj.Character
            if char then
                local isRepairing = char:GetAttribute("IsRepairing") or char:GetAttribute("Repairing") or false
                local progressVal = tonumber(char:GetAttribute("RepairProgress") or char:GetAttribute("Progress") or 0) or 0
                local isAntiHeal = char:GetAttribute("AntiHeal") or char:GetAttribute("Anti-Heal") or false
                local hookCount = tonumber(char:GetAttribute("HookCount") or char:GetAttribute("Hooks") or char:GetAttribute("HookedCount") or 0) or 0

                local progContainer = card:FindFirstChild("ProgressContainer")
                if progContainer then
                    if isRepairing and progressVal > 0 then
                        progContainer.Visible = true
                        local angle = (progressVal / 100) * 360
                        local g1 = progContainer.Frame1.ImageLabel.UIGradient
                        local g2 = progContainer.Frame2.ImageLabel.UIGradient
                        if angle <= 180 then
                            g1.Rotation = angle
                            g2.Rotation = 0
                        else
                            g1.Rotation = 180
                            g2.Rotation = angle - 180
                        end
                    else
                        progContainer.Visible = false
                    end
                end

                local progBg = card:FindFirstChild("ProgressBarBg")
                local progFill = progBg and progBg:FindFirstChild("Fill")
                if progBg and progFill then
                    if isRepairing and progressVal > 0 then
                        progBg.Visible = true
                        progFill.Size = UDim2.new(math.clamp(progressVal / 100, 0, 1), 0, 1, 0)
                    else
                        progBg.Visible = false
                    end
                end

                local antiHealLbl = card:FindFirstChild("Antiheal")
                if antiHealLbl then
                    antiHealLbl.Visible = (isAntiHeal == true)
                end

                local hookLbl = card:FindFirstChild("Counter")
                if hookLbl then
                    if hookCount == 1 then hookLbl.Text = "|"
                    elseif hookCount == 2 then hookLbl.Text = "||"
                    elseif hookCount >= 3 then hookLbl.Text = "|||"
                    else hookLbl.Text = "" end
                end
            end
        end)

        card.LayoutOrder = i
    end

    for _, child in ipairs(HorizontalScrollFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name:sub(1, 5) == "Card_" then
            local k = child.Name:sub(6)
            if not activeKeys[k] then
                child:Destroy()
            end
        end
    end
end

local MatchStatusParagraph = HomeTab:Paragraph({
    Title = "Match Status | Lobby",
    Desc = "Next Map : " .. currentMapStr .. "\nNext Killer : " .. currentKillerStr .. "\nGenerators : " .. currentGenStr,
    Image = "map",
    ImageSize = 24,
})

HomeTab:Button({
    Title = "ESCAPE", Icon = "log-out",
    Desc = "Instantly teleports your character to the active map coordinates.",
    Callback = function()
        pcall(function()
            local coords = MapCoords[currentMapKey]
            local hrp = getRoot()
            if hrp then
                if coords and coords[1] then
                    hrp.CFrame = CFrame.new(table.unpack(coords[1]))
                else
                    hrp.CFrame = CFrame.new(0, 50, 0)
                end
            end
        end)
        WindUI:Notify({ Title = "Escape", Content = "Teleported to map coordinates!", Duration = 2 })
    end
})

HomeTab:Divider()

HomeTab:Button({
    Title = "Rejoin Server",
    Desc = "Re-connects you to the current game session.",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
    end
})

HomeTab:Button({
    Title = "Server Hop",
    Desc = "Jumps into a random public server.",
    Callback = function()
        pcall(function()
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _, s in ipairs(servers.data) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, Player)
                    break
                end
            end
        end)
    end
})

HomeTab:Button({
    Title = "Small Server Hop",
    Desc = "Finds and joins a server with the lowest player count.",
    Callback = function()
        pcall(function()
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            local targetServer = nil
            for _, s in ipairs(servers.data) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then
                    if not targetServer or s.playing < targetServer.playing then targetServer = s end
                end
            end
            if targetServer then TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer.id, Player) end
        end)
    end
})

HomeTab:Button({
    Title = "Reset Character",
    Desc = "Forces your character to reset/die.",
    Callback = function()
        pcall(function()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.Health = 0
            end
        end)
    end
})

-- ==========================================
-- 2. SURVIVOR TAB
-- ==========================================
SurvivorTab:Section({ Title = "Movement", Icon = "sport-shoe" })

SurvivorTab:Toggle({
    Title = "Walk Speed",
    Default = false,
    Callback = function(v)
        Movement.WalkSpeedEnabled = v
        if v then applyWalkSpeed() end
    end
})

SurvivorTab:Slider({
    Title = "WalkSpeed Value",
    Value = { Min = 16, Max = 40, Default = 20, Step = 0.1 },
    Callback = function(v)
        Movement.WalkSpeedValue = v
        if Movement.WalkSpeedEnabled then applyWalkSpeed() end
    end
})

_G.FastVault = false
_G.VaultSpeed = 3

SurvivorTab:Toggle({
    Title = "Vault",
    Default = false,
    Callback = function(v) _G.FastVault = v end
})

SurvivorTab:Slider({
    Title = "Animation Speed",
    Value = { Min = 1, Max = 10, Default = 3, Step = 0.1 },
    Callback = function(v) _G.VaultSpeed = v end
})

SurvivorTab:Toggle({
    Title = "Jump button",
    Default = false,
    Callback = function(v)
        Movement.JumpPowerEnabled = v
        if v then applyJumpPower() end
    end
})

SurvivorTab:Slider({
    Title = "Jump Value",
    Value = { Min = 0, Max = 300, Default = 100, Step = 1 },
    Callback = function(v)
        Movement.JumpPowerValue = v
        if Movement.JumpPowerEnabled then applyJumpPower() end
    end
})

SurvivorTab:Divider()

SurvivorTab:Section({ Title = "Generator System", Icon = "cpu" })

local remote8 = {active = false, target = nil, generator = nil}
pcall(function()
    local inst35 = ReplicatedStorage.Remotes.KillerPerks.kingscourge:WaitForChild("KingScourgeStart")
    local remote9 = ReplicatedStorage.Remotes.KillerPerks.kingscourge:WaitForChild("KingScourgeEnd")
    inst35.OnClientEvent:Connect(function(WOHbMonN, MOqXmo, _DzI0UblIDqXnU)
        remote8.active = true
        remote8.target = MOqXmo
        remote8.generator = WOHbMonN
    end)
    remote9.OnClientEvent:Connect(function()
        remote8.active = false
        remote8.target = nil
        remote8.generator = nil
    end)
end)

local function gen1_func()
    for _, QXuowX_bv in ipairs({"SkillCheckPromptGui", "SkillCheckPromptGui-con"}) do
        local inst36 = PlayerGui:FindFirstChild(QXuowX_bv, true)
        if inst36 then
            local inst37 = inst36:FindFirstChild("Check", true)
            if inst37 and inst37.Visible then
                return inst37:FindFirstChild("Line", true), inst37:FindFirstChild("Goal", true)
            end
        end
    end
end

local inst38 = nil
local function IXXqZQbU()
    if inst38 and inst38.Parent then
        return inst38
    end
    local inst39 = PlayerGui:FindFirstChild("Survivor-mob", true)
    if not inst39 then return nil end
    local inst40 = inst39:FindFirstChild("Controls", true)
    if not inst40 then return nil end
    local inst41 = inst40:FindFirstChild("action")
    if inst41 and inst41:IsA("GuiButton") then
        inst38 = inst41
        return inst41
    end
    inst41 = inst40:FindFirstChild("Gui-mob")
    if inst41 and inst41:IsA("GuiButton") then
        inst38 = inst41
        return inst41
    end
    return nil
end

local function gui2_func()
    local btn1 = IXXqZQbU()
    if btn1 and type(firesignal) == "function" then
        firesignal(btn1.MouseButton1Down)
        task.delay(0.05, function()
            if btn1 and btn1.Parent then
                firesignal(btn1.MouseButton1Up)
                firesignal(btn1.MouseButton1Click)
            end
        end)
        return
    end
    local plplxbp = PlayerGui:FindFirstChild("check", true)
    if plplxbp and plplxbp:IsA("GuiObject") and plplxbp.Visible then
        local inst42 = plplxbp.AbsolutePosition
        local inst43 = plplxbp.AbsoluteSize
        local btn2 = GuiService.GetGuiInset(GuiService)
        local btn3 = inst42.X + (inst43.X / 2) + btn2.X
        local btn4 = inst42.Y + (inst43.Y / 2) + btn2.Y
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(btn3, btn4, 0, true, game, 1)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(btn3, btn4, 0, false, game, 1)
        end)
    else
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end

-- State variables for Auto Generator loop
local AutoGeneratorState = {
    autoGenerator = false,
    autoGeneratorMode = "Instant", -- Options: "Instant", "Perfect", "Normal", "Gacha"
    lastPressTime = 0,
    lastSkillHit = 0,
    lastGoalRot = nil,
    prevLr = nil,
    instantLastVisible = false,
    randomIsNeutral = false
}

-- Main Auto Generator Logic Loop (can be run via RunService.Heartbeat or task.spawn loop)
task.spawn(function()
    while true do
        task.wait()
        if AutoGeneratorState.autoGenerator then
            local Gen1, bvq0NXowOHZO_ = gen1_func()
            if not (Gen1 and bvq0NXowOHZO_) then
                AutoGeneratorState.instantLastVisible = false
                AutoGeneratorState.lastGoalRot = nil
                AutoGeneratorState.prevLr = nil
            else
                local gen8 = bvq0NXowOHZO_.Rotation
                local esp29 = Gen1.Rotation
                local esp30 = tick()
                local gen9 = remote8.active and 0.05 or 0.1
                
                if esp30 - AutoGeneratorState.lastPressTime >= gen9 then
                    if AutoGeneratorState.autoGeneratorMode == "Instant" then
                        if not AutoGeneratorState.instantLastVisible or gen8 ~= AutoGeneratorState.lastGoalRot then
                            Gen1.Rotation = gen8 + 109
                            AutoGeneratorState.lastGoalRot = gen8
                            AutoGeneratorState.instantLastVisible = true
                            AutoGeneratorState.lastPressTime = esp30
                            AutoGeneratorState.lastSkillHit = esp30
                            gui2_func()
                        end
                    else
                        local esp31 = (esp29 - gen8) % 360
                        local esp32 = -1
                        if AutoGeneratorState.prevLr and AutoGeneratorState.lastGoalRot == gen8 then
                            esp32 = (AutoGeneratorState.prevLr - gen8) % 360
                        end
                        AutoGeneratorState.lastGoalRot = gen8
                        
                        local Gen2, _lpIZ1OX
                        if AutoGeneratorState.autoGeneratorMode == "Perfect" then
                            Gen2 = 102
                            _lpIZ1OX = 116
                        elseif AutoGeneratorState.autoGeneratorMode == "Normal" then
                            Gen2 = 116
                            _lpIZ1OX = 159
                        elseif AutoGeneratorState.autoGeneratorMode == "Gacha" then
                            if not AutoGeneratorState.randomIsNeutral then
                                Gen2 = 102
                                _lpIZ1OX = 116
                            else
                                Gen2 = 116
                                _lpIZ1OX = 159
                            end
                        else
                            return
                        end
                        
                        local esp33 = esp31 >= Gen2 and esp31 <= _lpIZ1OX
                        local esp34 = esp32 >= 0 and esp32 < Gen2 and esp31 > _lpIZ1OX
                        if esp33 or esp34 then
                            if esp34 then
                                Gen1.Rotation = gen8 + (Gen2 + _lpIZ1OX) / 2
                            end
                            AutoGeneratorState.lastPressTime = esp30
                            AutoGeneratorState.lastSkillHit = esp30
                            gui2_func()
                            if AutoGeneratorState.autoGeneratorMode == "Gacha" then
                                AutoGeneratorState.randomIsNeutral = not AutoGeneratorState.randomIsNeutral
                            end
                        end
                    end
                    AutoGeneratorState.prevLr = esp29
                end
            end
        end
    end
end)

SurvivorTab:Toggle({
    Title = "Auto Generator",
    Default = false,
    Callback = function(v)
        AutoGeneratorState.autoGenerator = v
    end
})

SurvivorTab:Dropdown({
    Title = "Auto Generator Mode",
    Values = {"Instant", "Perfect", "Normal", "Gacha"},
    Default = "Instant",
    Callback = function(v)
        AutoGeneratorState.autoGeneratorMode = v
    end
})

local AutoGenGui = Instance.new("ScreenGui")
AutoGenGui.Name = "HyunjinAutoGenGui"
AutoGenGui.ResetOnSpawn = false
AutoGenGui.Parent = CoreGui
AutoGenGui.Enabled = false

local AutoGenButton = Instance.new("TextButton")
AutoGenButton.Name = "AutoGenButton"
AutoGenButton.Size = UDim2.new(0, 110, 0, 35)
AutoGenButton.Position = UDim2.new(1, -125, 0, 15)
AutoGenButton.BackgroundColor3 = Color3.fromRGB(30, 18, 22)
AutoGenButton.Text = "Auto Gen: OFF"
AutoGenButton.TextColor3 = Color3.fromRGB(160, 140, 145)
AutoGenButton.TextSize = 11
AutoGenButton.Font = Enum.Font.GothamBold
AutoGenButton.Parent = AutoGenGui

applyCorner(AutoGenButton, 6)
applyStroke(AutoGenButton, Color3.fromRGB(50, 25, 32), 1)

AutoGenButton.MouseButton1Click:Connect(function()
    _G.AutoGen = not _G.AutoGen
    AutoGenButton.Text = _G.AutoGen and "Auto Gen: ON" or "Auto Gen: OFF"
    AutoGenButton.BackgroundColor3 = _G.AutoGen and Color3.fromRGB(225, 45, 75) or Color3.fromRGB(30, 18, 22)
    AutoGenButton.TextColor3 = _G.AutoGen and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(160, 140, 145)
end)

SurvivorTab:Toggle({
    Title = "Auto Gen",
    Default = false,
    Callback = function(v)
        AutoGenGui.Enabled = v
        if not v then _G.AutoGen = false AutoGenButton.Text = "Auto Gen: OFF" AutoGenButton.BackgroundColor3 = Color3.fromRGB(30, 18, 22) AutoGenButton.TextColor3 = Color3.fromRGB(160, 140, 145) end
    end
})

-- OPTIMIZED: Throttle loop to 0.2s to prevent lag spike
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoGen then
            pcall(function()
                local repairRemote = ReplicatedStorage:FindFirstChild("Remotes") 
                    and ReplicatedStorage.Remotes:FindFirstChild("Generator") 
                    and ReplicatedStorage.Remotes.Generator:FindFirstChild("RepairEvent")
                if repairRemote then
                    local map = workspace:FindFirstChild("Map") or workspace:FindFirstChild("WorkspaceMap") or workspace
                    for _, obj in ipairs(map:GetDescendants()) do
                        if obj:IsA("BasePart") and obj.Name == "GeneratorPoint2" then
                            repairRemote:FireServer(obj, false)
                        elseif obj:IsA("Model") and obj.Name:lower():find("generator") then
                            local pt2 = obj:FindFirstChild("GeneratorPoint2")
                            if pt2 and pt2:IsA("BasePart") then
                                repairRemote:FireServer(pt2, false)
                            else
                                repairRemote:FireServer(obj, false)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

local function GetNearestActiveGenerator()
    local root = getRoot()
    if not root then return nil, nil end

    local map = workspace:FindFirstChild("Map") or workspace:FindFirstChild("WorkspaceMap")
    if not map then return nil, nil end

    local nearestGen, nearestPoint, nearestDist = nil, nil, math.huge

    for _, obj in ipairs(map:GetDescendants()) do
        if obj.Name:lower():find("generator") and obj:IsA("Model") then
            local progress = obj:GetAttribute("RepairProgress") or obj:GetAttribute("Progress") or 0
            if typeof(progress) == "number" and progress < 100 then
                local point = nil
                for _, child in ipairs(obj:GetDescendants()) do
                    if child:IsA("BasePart") and child.Name:match("^GeneratorPoint%d+$") then
                        point = child
                        break
                    end
                end
                if not point then
                    point = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                end
                if point then
                    local d = (point.Position - root.Position).Magnitude
                    if d < nearestDist then
                        nearestDist = d
                        nearestGen = obj
                        nearestPoint = point
                    end
                end
            end
        end
    end
    return nearestGen, nearestPoint
end

local VaultReplaceMap = {
    ["rbxassetid://83873880822918"] = "rbxassetid://136962284480779"
}
local VaultTracks = {}

local function hookVault(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    animator.AnimationPlayed:Connect(function(track)
        if not _G.FastVault then return end
        local anim = track.Animation
        if not anim or not anim.AnimationId then return end

        local idNum = tostring(anim.AnimationId):match("%d+")
        local fullId = "rbxassetid://" .. (idNum or "")
        local replaceId = VaultReplaceMap[fullId]
        if not replaceId then return end

        if VaultTracks[track] then return end
        VaultTracks[track] = true

        track:Stop()

        local newAnim = Instance.new("Animation")
        newAnim.AnimationId = replaceId
        local newTrack = animator:LoadAnimation(newAnim)
        newTrack.Priority = Enum.AnimationPriority.Action
        newTrack:Play()
        newTrack:AdjustSpeed(_G.VaultSpeed)

        newTrack.Stopped:Connect(function()
            VaultTracks[track] = nil
        end)
    end)
end

Player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    hookVault(char)
end)
if Player.Character then
    hookVault(Player.Character)
end

SurvivorTab:Section({ Title = "Evasion", Icon = "swords" })

_G.AuraHeal = { Enabled = false }
SurvivorTab:Toggle({
    Title = "Healing",
    Default = false,
    Callback = function(v) _G.AuraHeal.Enabled = v end
})

-- OPTIMIZED: Throttle AuraHeal loop
task.spawn(function()
    while task.wait(0.3) do
        if _G.AuraHeal.Enabled then
            pcall(function()
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if not remotes then return end
                local healingFolder = remotes:FindFirstChild("Healing")
                if not healingFolder then return end
                local healEvent = healingFolder:FindFirstChild("HealEvent")

                local char = Player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    char:SetAttribute("IsHealing", true)
                    char:SetAttribute("HealingProgress", 50)
                    if healEvent and hrp then healEvent:FireServer(hrp, true) end
                end

                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= Player and plr.Character then
                        local pChar = plr.Character
                        local pHum = pChar:FindFirstChildOfClass("Humanoid")
                        local pHrp = pChar:FindFirstChild("HumanoidRootPart")
                        if pHum and pHrp and (pHum.Health < pHum.MaxHealth or pChar:GetAttribute("NeedsHelp") or pChar:GetAttribute("IsDowned")) then
                            pChar:SetAttribute("IsHealing", true)
                            pChar:SetAttribute("HealingProgress", 50)
                            if healEvent then healEvent:FireServer(pHrp, true) end
                        end
                    end
                end
            end)
        end
    end
end)

_G.GodMode = false
_G.Noclip = false
local godConnection, noclipConn

SurvivorTab:Toggle({
    Title = "God Mode",
    Default = false,
    Callback = function(v)
        _G.GodMode = v
        if godConnection then godConnection:Disconnect() end
        if v then
            godConnection = RunService.Heartbeat:Connect(function()
                local char = Player.Character
                if not char then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = hum.MaxHealth end
            end)
        end
    end
})

SurvivorTab:Toggle({
    Title = "Noclip",
    Default = false,
    Callback = function(v)
        _G.Noclip = v
        if noclipConn then noclipConn:Disconnect() end
        if v then
            noclipConn = RunService.Stepped:Connect(function()
                local char = Player.Character
                if not char then return end
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        end
    end
})

-- Auto Drop Nearby Pallet
_G.AutoDropPallets = false
local PalletPointsCache = {}
local LastPalletScan = 0
local PalletDropCooldown = false

SurvivorTab:Toggle({
    Title = "Auto Drop Nearby Pallet",
    Default = false,
    Callback = function(v)
        _G.AutoDropPallets = v
        if v then PalletPointsCache = {} end
    end
})

-- OPTIMIZED: Throttle Pallet scan & check
task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoDropPallets and not PalletDropCooldown then
            pcall(function()
                local char = Player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local palletRemote = remotes and remotes:FindFirstChild("Pallet") and remotes.Pallet:FindFirstChild("PalletDropEvent")
                if not palletRemote then return end

                if not PalletPointsCache or (tick() - LastPalletScan > 5) then
                    LastPalletScan = tick()
                    PalletPointsCache = {}
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        local name = obj.Name
                        if name == "PalletPointSlide" or name == "palletDropPoint" or name == "PalletDropPoint" or name == "PalletPoint" then
                            table.insert(PalletPointsCache, obj)
                        end
                    end
                end

                local nearestPoint = nil
                local nearestDist = math.huge
                for _, point in ipairs(PalletPointsCache) do
                    if point and point.Parent then
                        local pos = nil
                        if point:IsA("BasePart") then pos = point.Position
                        elseif point:IsA("Model") then pos = point:GetPivot().Position
                        elseif point:IsA("Attachment") then pos = point.WorldPosition end
                        
                        if pos then
                            local dist = (pos - hrp.Position).Magnitude
                            if dist < nearestDist then
                                nearestDist = dist
                                nearestPoint = point
                            end
                        end
                    end
                end

                if nearestPoint and nearestDist <= 6 then
                    palletRemote:FireServer(nearestPoint)
                    PalletDropCooldown = true
                    task.delay(1.5, function() PalletDropCooldown = false end)
                end
            end)
        end
    end
end)

_G.AutoFlee = false
SurvivorTab:Toggle({
    Title = "Auto Flee Killer",
    Default = false,
    Callback = function(v) _G.AutoFlee = v end
})

local function GetNearestKiller()
    local root = getRoot()
    if not root then return nil, math.huge end
    local closest, shortest = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player and p.Team and (p.Team.Name:lower():find("killer") or p.Team.Name:lower():find("slayer")) and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = hrp
                end
            end
        end
    end
    return closest, shortest
end

local function GetFarthestGeneratorPoint(killerRoot)
    if not killerRoot then return nil end
    local bestPoint = nil
    local farthestDistance = 0
    local map = workspace:FindFirstChild("Map") or workspace:FindFirstChild("WorkspaceMap") or workspace
    for _, obj in ipairs(map:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:match("^GeneratorPoint%d+$")) then
            local dist = (obj.Position - killerRoot.Position).Magnitude
            if dist > farthestDistance then
                farthestDistance = dist
                bestPoint = obj
            end
        end
    end
    return bestPoint
end

local LastFlee = 0
task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoFlee then
            pcall(function()
                local root = getRoot()
                if root then
                    local killerRoot, distance = GetNearestKiller()
                    if killerRoot and distance <= 50 and tick() - LastFlee > 0.5 then
                        local point = GetFarthestGeneratorPoint(killerRoot)
                        if point then
                            LastFlee = tick()
                            root.CFrame = point.CFrame + Vector3.new(0, 5, 0)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Crouch / Auto Evade Killer
local HyunjinSettings = {
    autoCrouchExclusive = false,
    autoCrouchRadiusExclusive = 22,
}

local killerAnimationIds = {
    105374834496520, 113255068724446, 118907603246885, 129784271201071, 
    117042998468241, 122812055447896, 78935059863801, 74968262036854, 
    78432063483146, 132817836308238, 133963973694098, 111920872708571, 
    80411309607666, 98163597193511, 82666958311998, 110355011987939, 
    139369275981139, 135002183282873, 121216847022485, 130593238885843, 
    117070354890871, 106871536134254, 138720291317243
}

local function setCrouchState(state)
    pcall(function()
        local char = Player.Character
        if char then
            char:SetAttribute("Crouchingserver", state)
            char:SetAttribute("Crouching", state)
        end
        ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouchingserver", state)
        ReplicatedStorage.Remotes.Mechanics.ChangeAttribute:FireServer("Crouching", state)
    end)
end

-- OPTIMIZED: Throttle Auto Evade loop to 0.1s
task.spawn(function()
    while task.wait(0.1) do
        if HyunjinSettings.autoCrouchExclusive then
            pcall(function()
                local char = Player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then return end

                local shouldEvade = false
                local killerHrp = nil
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= Player and plr.Character then
                        local pChar = plr.Character
                        local pRoot = pChar:FindFirstChild("HumanoidRootPart")
                        local pHum = pChar:FindFirstChildOfClass("Humanoid")
                        if pRoot and pHum and pHum.Health > 0 then
                            local teamName = (plr.Team and plr.Team.Name:lower()) or ""
                            if teamName:find("killer") or pChar:FindFirstChild("Killer") then
                                local dist = (pRoot.Position - root.Position).Magnitude
                                if dist <= HyunjinSettings.autoCrouchRadiusExclusive then
                                    killerHrp = pRoot
                                    local animAnimator = pHum:FindFirstChildOfClass("Animator") or pChar:FindFirstChildOfClass("Animator")
                                    if animAnimator then
                                        for _, track in ipairs(animAnimator:GetPlayingAnimationTracks()) do
                                            if track and track.Animation then
                                                local animId = tonumber(string.match(track.Animation.AnimationId, "%d+"))
                                                if animId then
                                                    for _, id in ipairs(killerAnimationIds) do
                                                        if animId == id then
                                                            shouldEvade = true
                                                            break
                                                        end
                                                    end
                                                end
                                            end
                                            if shouldEvade then break end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                setCrouchState(shouldEvade)
                if shouldEvade and killerHrp then
                    local evadeDir = (root.Position - killerHrp.Position).Unit
                    root.CFrame = CFrame.new(root.Position + evadeDir * 4, root.Position + evadeDir * 10 + Vector3.new(0, root.Position.Y, 0))
                end
            end)
        end
    end
end)

SurvivorTab:Toggle({
    Title = "Auto Evade killer",
    Default = false,
    Callback = function(v)
        HyunjinSettings.autoCrouchExclusive = v
        if not v then setCrouchState(false) end
    end
})

_G.BypassGates = false
SurvivorTab:Toggle({ Title = "Bypass Gates", Default = false, Callback = function(v) _G.BypassGates = v end })

local originalStates = {}
local lastState = nil

local function updateGates(enable)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("gate") or obj:FindFirstChild("ExitLever")) then
            for _, descendant in ipairs(obj:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    local lever = obj:FindFirstChild("ExitLever")
                    if lever and descendant:IsDescendantOf(lever) then continue end
                    if enable then
                        if not originalStates[descendant] then
                            originalStates[descendant] = {
                                Transparency = descendant.Transparency,
                                CanCollide = descendant.CanCollide
                            }
                        end
                        descendant.Transparency = 1
                        descendant.CanCollide = false
                    else
                        if originalStates[descendant] then
                            descendant.Transparency = originalStates[descendant].Transparency
                            descendant.CanCollide = originalStates[descendant].CanCollide
                        end
                    end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if _G.BypassGates ~= lastState then
        lastState = _G.BypassGates
        updateGates(_G.BypassGates)
    end
end)

-- Gun System Section & Silent Aim
SurvivorTab:Section({ Title = "Gun System", Icon = "crosshair" })

_G.GunSystem = {
    Enabled = false,
    Holding = false,
    AimPart = "HumanoidRootPart",
    FOV = 250,
    PredictStrength = 0,
    ShowBeam = false,
    ShowFOV = false,
    TargetPanelEnabled = false,
}

_G.SilentAim = { TargetModes = {Survivor = false, Killer = true, SCP = true} }

local TwistEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Items"):WaitForChild("Twist of Fate"):WaitForChild("Fire")

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local survivorMob = PlayerGui:FindFirstChild("Survivor-mob")
            if survivorMob and survivorMob:FindFirstChild("Controls") then
                local guiMob = survivorMob.Controls:FindFirstChild("Gui-mob")
                if guiMob and guiMob:FindFirstChild("icon") then
                    local gunIcon = guiMob.icon
                    if gunIcon and gunIcon:IsA("GuiObject") and not gunIcon:FindFirstChild("_AutoGunConnected") then
                        gunIcon.InputBegan:Connect(function(input)
                            if _G.GunSystem.Enabled and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                                _G.GunSystem.Holding = true
                            end
                        end)
                        gunIcon.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                _G.GunSystem.Holding = false
                            end
                        end)
                        local marker = Instance.new("BoolValue")
                        marker.Name = "_AutoGunConnected"
                        marker.Parent = gunIcon
                    end
                end
            end
        end)
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if _G.GunSystem.Enabled and input.UserInputType == Enum.UserInputType.MouseButton2 then
        _G.GunSystem.Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        _G.GunSystem.Holding = false
    end
end)

local AimBeamDrawing = Drawing.new("Line")
AimBeamDrawing.Visible = false
AimBeamDrawing.Color = Color3.fromRGB(255, 45, 75)
AimBeamDrawing.Thickness = 2

local currentLockedTarget = nil

task.spawn(function()
    while task.wait(0.1) do
        if _G.GunSystem.Enabled and _G.GunSystem.Holding then
            pcall(function()
                local char = Player.Character
                local gunTool = (char and char:FindFirstChild("Twist of Fate")) or (Player.Backpack and Player.Backpack:FindFirstChild("Twist of Fate"))
                if gunTool then
                    local rightArmGun = gunTool:FindFirstChild("Right Arm") and gunTool["Right Arm"]:FindFirstChild("gun")
                    if not rightArmGun then
                        for _, desc in ipairs(gunTool:GetDescendants()) do
                            if desc.Name == "gun" and desc:IsA("BasePart") then
                                rightArmGun = desc
                                break
                            end
                        end
                    end
                    if rightArmGun then
                        local fireVector = Vector3.new(-0.70498096942902, 0.65654039382935, -0.26824736595154)
                        if currentLockedTarget then
                            local targetPos = currentLockedTarget.Position
                            if _G.GunSystem.PredictStrength > 0 then
                                targetPos = targetPos + (currentLockedTarget.AssemblyLinearVelocity * _G.GunSystem.PredictStrength)
                            end
                            fireVector = (targetPos - rightArmGun.Position).Unit
                        end
                        TwistEvent:FireServer(gunTool, fireVector)
                    end
                end
            end)
        end
    end
end)

SurvivorTab:Toggle({
    Title = "Gun",
    Default = false,
    Callback = function(v)
        _G.GunSystem.Enabled = v
    end
})

local TargetPanelGui = Instance.new("ScreenGui")
TargetPanelGui.Name = "HyunjinTargetPanelGui"
TargetPanelGui.ResetOnSpawn = false
TargetPanelGui.Parent = CoreGui
TargetPanelGui.Enabled = false

local TargetPanel = Instance.new("Frame")
TargetPanel.Name = "TargetPanel"
TargetPanel.Size = UDim2.new(0, 240, 0, 45)
TargetPanel.Position = UDim2.new(0.5, -120, 0, 85)
TargetPanel.BackgroundColor3 = Color3.fromRGB(30, 18, 22)
TargetPanel.Parent = TargetPanelGui

applyCorner(TargetPanel, 8)
applyStroke(TargetPanel, Color3.fromRGB(50, 25, 32), 1)

local tpDragging, tpDragStart, tpStartPos
TargetPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        tpDragging = true
        tpDragStart = input.Position
        tpStartPos = TargetPanel.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if tpDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - tpDragStart
        TargetPanel.Position = UDim2.new(tpStartPos.X.Scale, tpStartPos.X.Offset + delta.X, tpStartPos.Y.Scale, tpStartPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        tpDragging = false
    end
end)

local PanelLayout = Instance.new("UIListLayout")
PanelLayout.FillDirection = Enum.FillDirection.Horizontal
PanelLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
PanelLayout.VerticalAlignment = Enum.VerticalAlignment.Center
PanelLayout.SortOrder = Enum.SortOrder.LayoutOrder
PanelLayout.Padding = UDim.new(0, 8)
PanelLayout.Parent = TargetPanel

local function createCheckbox(name, defaultState, callback)
    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(0, 70, 0, 30)
    cb.BackgroundColor3 = defaultState and Color3.fromRGB(225, 45, 75) or Color3.fromRGB(14, 9, 11)
    cb.AutoButtonColor = false
    cb.Text = name
    cb.TextColor3 = defaultState and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(160, 140, 145)
    cb.TextSize = 11
    cb.Font = Enum.Font.GothamBold
    cb.Parent = TargetPanel
    applyCorner(cb, 6)
    applyStroke(cb, Color3.fromRGB(50, 25, 32), 1)

    local state = defaultState
    cb.MouseButton1Click:Connect(function()
        state = not state
        cb.TextColor3 = state and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(160, 140, 145)
        cb.BackgroundColor3 = state and Color3.fromRGB(225, 45, 75) or Color3.fromRGB(14, 9, 11)
        if callback then callback(state) end
    end)
end

createCheckbox("Survivor", false, function(v) _G.SilentAim.TargetModes.Survivor = v end)
createCheckbox("Killer", true, function(v) _G.SilentAim.TargetModes.Killer = v end)
createCheckbox("SCP", true, function(v) _G.SilentAim.TargetModes.SCP = v end)

SurvivorTab:Toggle({
    Title = "Target Panel",
    Default = false,
    Callback = function(v)
        _G.GunSystem.TargetPanelEnabled = v
        TargetPanelGui.Enabled = v
    end
})

SurvivorTab:Toggle({
    Title = "Show Aim Beam",
    Default = false,
    Callback = function(v)
        _G.GunSystem.ShowBeam = v
        AimBeamDrawing.Visible = v
    end
})

local FovDrawing = Drawing.new("Circle")
FovDrawing.Visible = false
FovDrawing.Filled = false
FovDrawing.Thickness = 1.5
FovDrawing.Color = Color3.fromRGB(255, 45, 75)
FovDrawing.NumSides = 64

SurvivorTab:Toggle({
    Title = "Show Aim FOV",
    Default = false,
    Callback = function(v)
        _G.GunSystem.ShowFOV = v
        FovDrawing.Visible = v
    end
})

SurvivorTab:Dropdown({
    Title = "Aim Part",
    Values = {"Head", "Torso", "HumanoidRootPart"},
    Default = "HumanoidRootPart",
    Callback = function(v) _G.GunSystem.AimPart = v end
})

SurvivorTab:Slider({
    Title = "Aim FOV size",
    Value = { Min = 50, Max = 500, Default = 250, Step = 1 },
    Callback = function(v) _G.GunSystem.FOV = v end
})

SurvivorTab:Slider({
    Title = "Prediction Strength",
    Value = { Min = 0, Max = 50, Default = 0, Step = 1 },
    Callback = function(v) _G.GunSystem.PredictStrength = v / 100 end
})

-- Silent Aim Section
SurvivorTab:Section({ Title = "Silent Aim (Twist of Fate)", Icon = "crosshair" })

SurvivorTab:Toggle({
    Title = "Silent Aim",
    Default = false,
    Callback = function(v)
        ESPState.silentAimEnabled = v
    end
})

SurvivorTab:Toggle({
    Title = "FOV Circle",
    Default = false,
    Callback = function(v)
        ESPState.silentAimFovVisible = v
    end
})

SurvivorTab:Toggle({
    Title = "Laser ESP",
    Default = false,
    Callback = function(v)
        ESPState.laserEspEnabled = v
    end
})

SurvivorTab:Slider({
    Title = "Aim FOV Radius",
    Value = { Min = 30, Max = 500, Default = 150, Step = 5 },
    Callback = function(v)
        Settings.silentAimFovRadius = v
    end
})

-- Auto Parry Section
SurvivorTab:Section({ Title = "Auto Parry", Icon = "sword" })

_G.AutoParryEnabled = false
_G.ParryRadius = 6
_G.ParryVisualizerEnabled = false
_G.ParryTransparency = 0.5
_G.ParrySensitivity = 1.0
_G.ParryCircleOutline = "Classic"

SurvivorTab:Toggle({ Title = "Auto Parry", Default = false, Callback = function(v) _G.AutoParryEnabled = v end })
SurvivorTab:Toggle({ Title = "Visual Radius", Default = false, Callback = function(v) _G.ParryVisualizerEnabled = v end })

SurvivorTab:Slider({
    Title = "Visual Radius",
    Value = { Min = 2, Max = 30, Default = 6, Step = 1 },
    Callback = function(v) _G.ParryRadius = v end
})

SurvivorTab:Slider({
    Title = "Transparansi",
    Value = { Min = 0, Max = 10, Default = 5, Step = 1 },
    Callback = function(v) _G.ParryTransparency = v / 10 end
})

SurvivorTab:Dropdown({
    Title = "circle outline",
    Values = {"Classic", "Arcane", "RGB"},
    Default = "Classic",
    Callback = function(v) _G.ParryCircleOutline = v end
})

local parryRingAdornment = nil
local function updateParryVisualizer()
    pcall(function()
        if _G.ParryVisualizerEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            if not parryRingAdornment or not parryRingAdornment.Parent then
                parryRingAdornment = Instance.new("CylinderHandleAdornment")
                parryRingAdornment.Name = "ParryHollowRing"
                parryRingAdornment.AlwaysOnTop = true
                parryRingAdornment.ZIndex = 10
                parryRingAdornment.Parent = workspace
            end

            local hrp = Player.Character.HumanoidRootPart
            parryRingAdornment.Adornee = hrp
            parryRingAdornment.CFrame = CFrame.new(0, -hrp.Size.Y/2 - 0.2, 0) * CFrame.Angles(math.rad(90), 0, 0)
            
            local r = _G.ParryRadius
            parryRingAdornment.Radius = r
            parryRingAdornment.InnerRadius = r - 0.25
            parryRingAdornment.Height = 0.05
            parryRingAdornment.Transparency = math.clamp(_G.ParryTransparency, 0.1, 1)

            if _G.ParryCircleOutline == "Arcane" then
                parryRingAdornment.Color3 = Color3.fromRGB(140, 50, 255)
            elseif _G.ParryCircleOutline == "RGB" then
                local t = tick() * 2
                parryRingAdornment.Color3 = Color3.fromHSV(t % 1, 1, 1)
            else
                parryRingAdornment.Color3 = Color3.fromRGB(255, 65, 85)
            end
        else
            if parryRingAdornment then
                parryRingAdornment:Destroy()
                parryRingAdornment = nil
            end
        end
    end)
end

local function triggerGameParryIcon()
    TriggerMobileAction("Survivor-mob.Controls.Gui-mob.icon")
end

local function checkKillerAnimations()
    if not _G.AutoParryEnabled then return end
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local myPos = char.HumanoidRootPart.Position
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local pChar = plr.Character
            local pHum = pChar:FindFirstChildOfClass("Humanoid")
            local pRoot = pChar:FindFirstChild("HumanoidRootPart")
            if pHum and pRoot then
                local dist = (pRoot.Position - myPos).Magnitude
                if dist <= (_G.ParryRadius * _G.ParrySensitivity * 3) then
                    local animAnimator = pHum:FindFirstChildOfClass("Animator") or pChar:FindFirstChildOfClass("Animator")
                    if animAnimator then
                        local activeTracks = animAnimator:GetPlayingAnimationTracks()
                        for _, track in ipairs(activeTracks) do
                            if track and track.Animation then
                                local animId = tonumber(string.match(track.Animation.AnimationId, "%d+"))
                                if animId then
                                    for _, id in ipairs(killerAnimationIds) do
                                        if animId == id then
                                            triggerGameParryIcon()
                                            return
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- OPTIMIZED: Throttle Auto Parry to 0.1s
task.spawn(function()
    while task.wait(0.1) do
        checkKillerAnimations()
        updateParryVisualizer()
    end
end)

-- Gun AIM render stepped
RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    FovDrawing.Position = center
    FovDrawing.Radius = _G.GunSystem.FOV

    currentLockedTarget = nil

    if _G.GunSystem.Enabled or _G.GunSystem.Holding then
        local closest = nil
        local shortest = _G.GunSystem.FOV
        local anyModeActive = _G.SilentAim.TargetModes.Survivor or _G.SilentAim.TargetModes.Killer or _G.SilentAim.TargetModes.SCP
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local teamName = (p.Team and p.Team.Name:lower()) or ""
                local isKiller = teamName:find("killer") or p.Character:FindFirstChild("Killer")
                local isSurvivor = teamName:find("survivor") or not isKiller
                
                local matchValid = false
                if not anyModeActive then
                    matchValid = true
                else
                    if _G.SilentAim.TargetModes.Killer and isKiller then matchValid = true end
                    if _G.SilentAim.TargetModes.Survivor and isSurvivor and not isKiller then matchValid = true end
                end

                if matchValid then
                    local targetPart = p.Character:FindFirstChild(_G.GunSystem.AimPart) or p.Character:FindFirstChild("HumanoidRootPart")
                    if targetPart then
                        local pos, vis = cam:WorldToViewportPoint(targetPart.Position)
                        if vis then
                            local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if dist < shortest then
                                shortest = dist
                                closest = targetPart
                            end
                        end
                    end
                end
            end
        end

        if _G.SilentAim.TargetModes.SCP or (not anyModeActive) then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj.Name:lower():find("scp") then
                    local targetPart = obj:FindFirstChild(_G.GunSystem.AimPart) or obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                    if targetPart then
                        local pos, vis = cam:WorldToViewportPoint(targetPart.Position)
                        if vis then
                            local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if dist < shortest then
                                shortest = dist
                                closest = targetPart
                            end
                        end
                    end
                end
            end
        end

        currentLockedTarget = closest

        if closest then
            local targetPos = closest.Position
            if _G.GunSystem.PredictStrength > 0 then
                targetPos = targetPos + (closest.AssemblyLinearVelocity * _G.GunSystem.PredictStrength)
            end
            
            if _G.GunSystem.ShowBeam and Player.Character then
                local localPart = Player.Character:FindFirstChild("HumanoidRootPart") or cam
                local originPos = (localPart:IsA("BasePart") and localPart.Position) or cam.CFrame.Position
                local originScr, vis1 = cam:WorldToViewportPoint(originPos)
                local targetScr, vis2 = cam:WorldToViewportPoint(targetPos)
                if vis1 or vis2 then
                    AimBeamDrawing.From = Vector2.new(originScr.X, originScr.Y)
                    AimBeamDrawing.To = Vector2.new(targetScr.X, targetScr.Y)
                    AimBeamDrawing.Visible = true
                else
                    AimBeamDrawing.Visible = false
                end
            else
                AimBeamDrawing.Visible = false
            end

            if _G.GunSystem.Holding then
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, targetPos), 1)
            end
        else
            AimBeamDrawing.Visible = false
        end
    else
        AimBeamDrawing.Visible = false
    end
end)

-- ==========================================
-- 3. KILLER TAB
-- ==========================================
KillerTab:Section({ Title = "Stalker" })
local AutoStalk = { Enabled = false, StalkRange = 150 }
local StalkConnection = nil

local function getClosestSurvivorForStalk()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then 
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= AutoStalk.StalkRange and dist < shortest then
                    shortest = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

KillerTab:Toggle({
    Title = "Auto Stalk",
    Default = false,
    Callback = function(v)
        AutoStalk.Enabled = v
        if v then
            if not StalkConnection then
                StalkConnection = RunService.Heartbeat:Connect(function()
                    if not AutoStalk.Enabled then return end
                    local target = getClosestSurvivorForStalk()
                    if not target or not target.Character then return end
                    pcall(function()
                        local stalkEvent = ReplicatedStorage:FindFirstChild("Remotes", true) and ReplicatedStorage.Remotes:FindFirstChild("Killers", true) and ReplicatedStorage.Remotes.Killers:FindFirstChild("Stalker", true) and ReplicatedStorage.Remotes.Killers.Stalker:FindFirstChild("StartStalking")
                        if stalkEvent then stalkEvent:FireServer(target) end
                    end)
                end)
            end
        else
            if StalkConnection then StalkConnection:Disconnect() StalkConnection = nil end
        end
    end
})

KillerTab:Section({ Title = "Auto Attack" })
local AutoAttackState = false

KillerTab:Toggle({
    Title = "Auto Basic Attack",
    Default = false,
    Callback = function(v) AutoAttackState = v end
})

task.spawn(function()
    while task.wait(0.2) do
        if AutoAttackState then
            pcall(function()
                local BasicAttackEvent = ReplicatedStorage:FindFirstChild("Remotes", true) and ReplicatedStorage.Remotes:FindFirstChild("Attacks", true) and ReplicatedStorage.Remotes.Attacks:FindFirstChild("BasicAttack")
                if BasicAttackEvent then BasicAttackEvent:FireServer() end
            end)
        end
    end
end)

KillerTab:Section({ Title = "Auto Carry & Hook" })

KillerTab:Toggle({
    Name = "Auto Carry",
    Default = false,
    Callback = function(v) _G.AutoCarry = v end
})

KillerTab:Toggle({
    Name = "Auto Hook",
    Default = false,
    Callback = function(v) _G.AutoHook = v end
})

local HyunjinKillerSettings = { antiLoopWindowExclusive = false }

local function applyAntiLoopWindow(enable)
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then return end
        local winRem = remotes:FindFirstChild("Window")
        if not winRem then return end
        local vaultEv = winRem:FindFirstChild("VaultEvent")
        if not vaultEv then return end
        
        if enable then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "Window" or v.Name == "VaultPoint" or v.Name:lower():find("window") then
                    pcall(function() vaultEv:FireServer(v, true) end)
                end
            end
        end
    end)
end

KillerTab:Section({ Title = "Anti Loop System" })
KillerTab:Toggle({
    Title = "Anti Loop Window",
    Default = false,
    Callback = function(v)
        HyunjinKillerSettings.antiLoopWindowExclusive = v
        if v then applyAntiLoopWindow(true) end
    end
})

KillerTab:Section({ Title = "Kill All" })
local KillAllState = false
local KillerTarget = nil

KillerTab:Toggle({
    Title = "Kill All",
    Default = false,
    Callback = function(v)
        KillAllState = v
        AutoAttackState = v
    end
})

local function GetNearestAliveSurvivor()
    local root = getRoot()
    if not root then return nil end
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 30 then
                local d = (hrp.Position - root.Position).Magnitude
                if d < shortest then shortest = d closest = plr.Character end
            end
        end
    end
    return closest
end

RunService.Heartbeat:Connect(function()
    if not KillAllState then return end
    local root = getRoot()
    if root then
        if not KillerTarget or not KillerTarget:FindFirstChild("Humanoid") or KillerTarget.Humanoid.Health <= 35 then
            KillerTarget = GetNearestAliveSurvivor()
        end
        if KillerTarget then
            local targetHRP = KillerTarget:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local velocity = targetHRP.AssemblyLinearVelocity
                local predict = velocity * 0.15
                local targetPos = targetHRP.Position + predict
                local behind = targetHRP.CFrame.LookVector * -3
                root.CFrame = CFrame.new(targetPos + behind, targetPos)
            end
            pcall(function()
                local attackEv = ReplicatedStorage:FindFirstChild("Remotes", true) and ReplicatedStorage.Remotes:FindFirstChild("Attacks", true) and (ReplicatedStorage.Remotes.Attacks:FindFirstChild("AttackEvent") or ReplicatedStorage.Remotes.Attacks:FindFirstChild("BasicAttack"))
                if attackEv then attackEv:FireServer(false) end
            end)
        end
    end
end)

KillerTab:Section({ Title = "Aim Lock Killer" })
local AttackAim = {
    Enabled = false,
    Holding = false,
    Strength = 1,
    Predict = true,
    PredictStrength = 0.12,
    FOV = 250,
    VisibilityCheck = true,
    AimPart = "HumanoidRootPart"
}

task.spawn(function()
    while task.wait(1.0) do
        pcall(function()
            local attackIcon = PlayerGui:FindFirstChild("Slasher-mob") and PlayerGui["Slasher-mob"].Controls.attack:FindFirstChild("icon")
            if attackIcon and attackIcon:IsA("GuiObject") then
                attackIcon.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        AttackAim.Holding = true
                    end
                end)
                attackIcon.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        AttackAim.Holding = false
                    end
                end)
            end
        end)
    end
end)

local KillerFovDrawing = Drawing.new("Circle")
KillerFovDrawing.Visible = false
KillerFovDrawing.Filled = false
KillerFovDrawing.Thickness = 1.5
KillerFovDrawing.Color = Color3.fromRGB(255, 45, 75)
KillerFovDrawing.NumSides = 64

KillerTab:Toggle({ Title = "Aim Lock Killer", Default = false, Callback = function(v) AttackAim.Enabled = v end })
KillerTab:Toggle({ Title = "Visibility Check (Wall Check)", Default = false, Callback = function(v) AttackAim.VisibilityCheck = v end })
KillerTab:Toggle({ Title = "Show Killer FOV Circle", Default = false, Callback = function(v) KillerFovDrawing.Visible = v end })

KillerTab:Slider({
    Title = "Killer FOV Size",
    Value = { Min = 50, Max = 500, Default = 250, Step = 1 },
    Callback = function(v) AttackAim.FOV = v end
})

local function getClosestAttackTarget()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    local closest, shortest = nil, AttackAim.FOV

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player and p.Team and p.Team.Name == "Survivors" and p.Character then
            local hrp = p.Character:FindFirstChild(AttackAim.AimPart)
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                if visible then
                    if AttackAim.VisibilityCheck then
                        local origin = cam.CFrame.Position
                        local rayParams = RaycastParams.new()
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        rayParams.FilterDescendantsInstances = {Player.Character, p.Character}
                        local result = workspace:Raycast(origin, hrp.Position - origin, rayParams)
                        if result then visible = false end
                    end
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then shortest = dist closest = hrp end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    KillerFovDrawing.Position = center
    KillerFovDrawing.Radius = AttackAim.FOV

    if AttackAim.Enabled and AttackAim.Holding then
        local target = getClosestAttackTarget()
        if target then
            local pos = target.Position
            if AttackAim.Predict then
                pos = pos + (target.AssemblyLinearVelocity * AttackAim.PredictStrength)
            end
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, pos), AttackAim.Strength)
        end
    end
end)

-- VEIL, SPEAR & ANTI BLIND SYSTEMS
KillerTab:Section({ Title = "Veil & Spear Systems" })

local VeilCamSettings = {
    Enabled = false,
    SnapLine = false,
    AimPart = "HumanoidRootPart"
}

local VeilSnapLineDrawing = Drawing.new("Line")
VeilSnapLineDrawing.Visible = false
VeilSnapLineDrawing.Color = Color3.fromRGB(225, 45, 75)
VeilSnapLineDrawing.Thickness = 1.5

KillerTab:Toggle({
    Title = "Camera Veil & SnapLine ESP",
    Default = false,
    Callback = function(v)
        VeilCamSettings.Enabled = v
        if not v then VeilSnapLineDrawing.Visible = false end
    end
})

KillerTab:Toggle({
    Title = "SnapLine ESP (Veil)",
    Default = false,
    Callback = function(v)
        VeilCamSettings.SnapLine = v
        if not v then VeilSnapLineDrawing.Visible = false end
    end
})

local SilentSpearSettings = {
    Enabled = false,
    FovVisible = false,
    FovRadius = 150,
}

local SpearFovDrawing = Drawing.new("Circle")
SpearFovDrawing.Visible = false
SpearFovDrawing.Filled = false
SpearFovDrawing.Thickness = 1.5
SpearFovDrawing.Color = Color3.fromRGB(80, 200, 255)
SpearFovDrawing.NumSides = 64

KillerTab:Toggle({
    Title = "Silent Spear (Veil)",
    Default = false,
    Callback = function(v) SilentSpearSettings.Enabled = v end
})

KillerTab:Toggle({
    Title = "Spear FOV Circle",
    Default = false,
    Callback = function(v)
        SilentSpearSettings.FovVisible = v
        SpearFovDrawing.Visible = v
    end
})

KillerTab:Slider({
    Title = "Spear FOV Radius",
    Value = { Min = 30, Max = 500, Default = 150, Step = 5 },
    Callback = function(v) SilentSpearSettings.FovRadius = v end
})

local AntiBlindEnabled = false
KillerTab:Toggle({
    Title = "Anti Blind",
    Default = false,
    Callback = function(v)
        AntiBlindEnabled = v
    end
})

-- OPTIMIZED: Throttle AntiBlind loop to 0.2s
task.spawn(function()
    while task.wait(0.2) do
        if AntiBlindEnabled then
            pcall(function()
                for _, guiName in ipairs({"FlashlightBlind", "BlindGui", "Blinded", "FlashbangGui"}) do
                    local blindGui = PlayerGui:FindFirstChild(guiName)
                    if blindGui then blindGui.Enabled = false end
                end
                local char = Player.Character
                if char then
                    for _, att in ipairs(char:GetAttributes()) do
                        if string.find(string.lower(att), "blind") then
                            char:SetAttribute(att, false)
                        end
                    end
                end
            end)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    
    SpearFovDrawing.Position = center
    SpearFovDrawing.Radius = SilentSpearSettings.FovRadius
    SpearFovDrawing.Visible = SilentSpearSettings.FovVisible and SilentSpearSettings.Enabled

    local closestTarget = nil
    local shortestDist = math.huge

    if VeilCamSettings.Enabled or SilentSpearSettings.Enabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Player and p.Team and p.Team.Name == "Survivors" and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local pos, vis = cam:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local screenDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        local activeRadius = SilentSpearSettings.Enabled and SilentSpearSettings.FovRadius or 500
                        if screenDist <= activeRadius and screenDist < shortestDist then
                            shortestDist = screenDist
                            closestTarget = hrp
                        end
                    end
                end
            end
        end
    end

    if VeilCamSettings.Enabled and closestTarget then
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, closestTarget.Position), 1)
        if VeilCamSettings.SnapLine then
            local pos, vis = cam:WorldToViewportPoint(closestTarget.Position)
            if vis then
                VeilSnapLineDrawing.From = center
                VeilSnapLineDrawing.To = Vector2.new(pos.X, pos.Y)
                VeilSnapLineDrawing.Visible = true
            else
                VeilSnapLineDrawing.Visible = false
            end
        else
            VeilSnapLineDrawing.Visible = false
        end
    else
        VeilSnapLineDrawing.Visible = false
    end

    if SilentSpearSettings.Enabled and closestTarget then
        pcall(function()
            local spearRemote = ReplicatedStorage:FindFirstChild("Remotes") 
                and ReplicatedStorage.Remotes:FindFirstChild("Items") 
                and ReplicatedStorage.Remotes.Items:FindFirstChild("Veil") 
                and ReplicatedStorage.Remotes.Items.Veil:FindFirstChild("Fire")
            if spearRemote and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                local char = Player.Character
                local spearTool = char and char:FindFirstChild("Veil")
                if spearTool then
                    spearRemote:FireServer(spearTool, (closestTarget.Position - cam.CFrame.Position).Unit)
                end
            end
        end)
    end
end)

KillerTab:Section({ Title = "Masked Power" })
local Masked = { CurrentPower = "Cobra" }
local MaskedPowers = {"Cobra", "Richter", "Brandon", "Rabbit", "Alex"}

local function ActivatePower()
    local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
        and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
        and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
        and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Activatepower")
    if Event then Event:FireServer(Masked.CurrentPower) end
end

local function DeactivatePower()
    local Event = ReplicatedStorage:FindFirstChild("Remotes", true)
        and ReplicatedStorage.Remotes:FindFirstChild("Killers", true)
        and ReplicatedStorage.Remotes.Killers:FindFirstChild("Masked", true)
        and ReplicatedStorage.Remotes.Killers.Masked:FindFirstChild("Deactivatepower")
    if Event then Event:FireServer() end
end

KillerTab:Dropdown({
    Title = "Select Power",
    Values = MaskedPowers,
    Default = "Cobra",
    Callback = function(v) Masked.CurrentPower = v end
})

KillerTab:Toggle({
    Title = "Activate Power",
    Default = false,
    Callback = function(v)
        if v then ActivatePower() else DeactivatePower() end
    end
})

-- ==========================================
-- 4. VISUAL TAB
-- ==========================================
local Config = {
    Players = {
        Killer = {Color = Color3.fromRGB(255, 93, 108)}, 
        Survivor = {Color = Color3.fromRGB(64, 224, 255)}
    },
    Objects = {
        Generator = {Color = Color3.fromRGB(255, 255, 255)}, 
        Gate = {Color = Color3.fromRGB(255, 255, 255)},
        Pallet = {Color = Color3.fromRGB(74, 255, 181)}, 
        Window = {Color = Color3.fromRGB(255, 223, 0)},
        Hook = {Color = Color3.fromRGB(252, 116, 116)},
        SCP = {Color = Color3.fromRGB(0, 0, 0)}
    }
}

local Settings = {
    killerShowName = false,
    killerShowOutline = true,
    killerOutlineOnly = false,
    killerColor = Color3.fromRGB(255, 93, 108),
    survivorShowName = false,
    survivorShowOutline = true,
    survivorOutlineOnly = false,
    survivorColor = Color3.fromRGB(64, 224, 255),
    maxDistance = 500,
    fillTransparency = 0.5,
    espGeneratorEnabled = false,
    espGeneratorProgressGen = true,
    espGeneratorColor = Color3.fromRGB(255, 255, 255),
    espWindowEnabled = false,
    espWindowColor = Color3.fromRGB(255, 223, 0),
    espPalletEnabled = false,
    espPalletColor = Color3.fromRGB(74, 255, 181),
    espHookEnabled = false,
    espHookColor = Color3.fromRGB(252, 116, 116),
    espGateEnabled = false,
    espGateColor = Color3.fromRGB(255, 255, 255),
    espItemEnabled = false,
    warnEnabled = false,
    warnDist1 = 99,
    silentAimFovRadius = 150,
}

local ESPFlags = {
    SCP = false,
    KillerChams = true,
    SurvivorChams = true,
    KillerTracer = false,
}

local VisualSettings = {
    Fullbright = false,
    NoShadow = false,
    CleanSky = false,
    Brightness = 4,
    ClockTime = 13,
    UnlimitedZoom = false
}

local CrosshairConfig = {
    Enabled = false,
    Size = 8,
    Thickness = 2,
    Color = Color3.fromRGB(255, 255, 255),
    Style = "Plus",
    OffsetX = 0,
    OffsetY = 0
}

VisualTab:Section({ Title = "Killer ESP" })
VisualTab:Toggle({ Title = "Show Killer Name", Default = Settings.killerShowName, Callback = function(v) Settings.killerShowName = v end })
VisualTab:Toggle({ Title = "Killer Chams", Default = ESPFlags.KillerChams, Callback = function(v) ESPFlags.KillerChams = v; Settings.killerShowOutline = v end })
VisualTab:Toggle({ Title = "Killer Tracer", Default = false, Callback = function(v) ESPFlags.KillerTracer = v end })
VisualTab:Toggle({ Title = "Show Killer Outline", Default = Settings.killerShowOutline, Callback = function(v) Settings.killerShowOutline = v end })
VisualTab:Toggle({ Title = "Killer Outline Only", Default = Settings.killerOutlineOnly, Callback = function(v) Settings.killerOutlineOnly = v end })
VisualTab:Colorpicker({ Title = "Killer Color", Default = Settings.killerColor, Callback = function(c) Settings.killerColor = c; Config.Players.Killer.Color = c end })

VisualTab:Section({ Title = "Survivor ESP" })
VisualTab:Toggle({ Title = "Show Survivor Name", Default = Settings.survivorShowName, Callback = function(v) Settings.survivorShowName = v end })
VisualTab:Toggle({ Title = "Survivor Chams", Default = ESPFlags.SurvivorChams, Callback = function(v) ESPFlags.SurvivorChams = v; Settings.survivorShowOutline = v end })
VisualTab:Toggle({ Title = "Show Survivor Outline", Default = Settings.survivorShowOutline, Callback = function(v) Settings.survivorShowOutline = v end })
VisualTab:Toggle({ Title = "Survivor Outline Only", Default = Settings.survivorOutlineOnly, Callback = function(v) Settings.survivorOutlineOnly = v end })
VisualTab:Colorpicker({ Title = "Survivor Color", Default = Settings.survivorColor, Callback = function(c) Settings.survivorColor = c; Config.Players.Survivor.Color = c end })

VisualTab:Section({ Title = "Object & Map ESP" })
VisualTab:Toggle({ Title = "Esp SCP", Default = false, Callback = function(v) ESPFlags.SCP = v end })
VisualTab:Toggle({ Title = "Esp Generator", Default = Settings.espGeneratorEnabled, Callback = function(v) Settings.espGeneratorEnabled = v end })
VisualTab:Toggle({ Title = "Progress Generator", Default = Settings.espGeneratorProgressGen, Callback = function(v) Settings.espGeneratorProgressGen = v end })
VisualTab:Toggle({ Title = "Esp Pallet", Default = Settings.espPalletEnabled, Callback = function(v) Settings.espPalletEnabled = v end })
VisualTab:Toggle({ Title = "Esp Window", Default = Settings.espWindowEnabled, Callback = function(v) Settings.espWindowEnabled = v end })
VisualTab:Toggle({ Title = "Esp Hook", Default = Settings.espHookEnabled, Callback = function(v) Settings.espHookEnabled = v end })
VisualTab:Toggle({ Title = "Esp Gate", Default = Settings.espGateEnabled, Callback = function(v) Settings.espGateEnabled = v end })

VisualTab:Section({ Title = "Extra Info" })
VisualTab:Toggle({
    Title = "Players Items",
    Default = false,
    Callback = function(v) Settings.espItemEnabled = v end
})

VisualTab:Toggle({ Title = "Unlimited Max Zoom", Default = false, Callback = function(v)
    VisualSettings.UnlimitedZoom = v
    pcall(function()
        if v then Player.CameraMaxZoomDistance = 999999 else Player.CameraMaxZoomDistance = 400 end
    end)
end })

VisualTab:Toggle({ Title = "Killer Warning", Default = false, Callback = function(v) Settings.warnEnabled = v end })

VisualTab:Slider({
    Title = "Jarak Warning Killer",
    Value = { Min = 10, Max = 200, Default = 99, Step = 1 },
    Callback = function(v) Settings.warnDist1 = v end
})

VisualTab:Section({ Title = "Ambient & Optimization" })
VisualTab:Toggle({ Title = "Fullbright", Default = false, Callback = function(v) VisualSettings.Fullbright = v end })
VisualTab:Toggle({ Title = "No Shadow", Default = false, Callback = function(v) VisualSettings.NoShadow = v end })
VisualTab:Toggle({ Title = "Clean Sky", Default = false, Callback = function(v) VisualSettings.CleanSky = v end })

VisualTab:Slider({
    Title = "Brightness",
    Value = { Min = 0, Max = 10, Default = 4, Step = 1 },
    Callback = function(v) VisualSettings.Brightness = v end
})

VisualTab:Slider({
    Title = "Clock Time",
    Value = { Min = 0, Max = 24, Default = 13, Step = 1 },
    Callback = function(v) VisualSettings.ClockTime = v end
})

VisualTab:Section({ Title = "Crosshair" })
VisualTab:Toggle({ Title = "Crosshair", Default = false, Callback = function(v) CrosshairConfig.Enabled = v end })
VisualTab:Dropdown({ Title = "Gaya Crosshair", Values = {"Plus", "Dot", "Circle"}, Default = "Plus", Callback = function(v) CrosshairConfig.Style = v end })

VisualTab:Colorpicker({
    Title = "Crosshair",
    Desc = "Choose crosshair color",
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Locked = false,
    Callback = function(color) CrosshairConfig.Color = color end
})

VisualTab:Slider({
    Title = "Crosshair Siza",
    Value = { Min = 2, Max = 30, Default = 8, Step = 1 },
    Callback = function(v) CrosshairConfig.Size = v end
})

VisualTab:Slider({
    Title = "Crosshair X Offsite",
    Value = { Min = -100, Max = 100, Default = 0, Step = 1 },
    Callback = function(v) CrosshairConfig.OffsetX = v end
})

VisualTab:Slider({
    Title = "Crosshair Y Offsite",
    Value = { Min = -100, Max = 100, Default = 0, Step = 1 },
    Callback = function(v) CrosshairConfig.OffsetY = v end
})

VisualTab:Section({ Title = "Object Color Pickers" })

VisualTab:Colorpicker({
    Title = "Esp SCP",
    Desc = "Color for SCP ESP",
    Default = Color3.fromRGB(0, 0, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color) Config.Objects.SCP.Color = color end
})

VisualTab:Colorpicker({
    Title = "Esp Generator",
    Desc = "Color for Generator ESP",
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Locked = false,
    Callback = function(color) Settings.espGeneratorColor = color; Config.Objects.Generator.Color = color end
})

VisualTab:Colorpicker({
    Title = "Esp Pallet",
    Desc = "Color for Pallet ESP",
    Default = Color3.fromRGB(74, 255, 181),
    Transparency = 0,
    Locked = false,
    Callback = function(color) Settings.espPalletColor = color; Config.Objects.Pallet.Color = color end
})

VisualTab:Colorpicker({
    Title = "Esp Window",
    Desc = "Color for Window ESP",
    Default = Color3.fromRGB(255, 223, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color) Settings.espWindowColor = color; Config.Objects.Window.Color = color end
})

VisualTab:Colorpicker({
    Title = "Esp Hook",
    Desc = "Color for Hook ESP",
    Default = Color3.fromRGB(252, 116, 116),
    Transparency = 0,
    Locked = false,
    Callback = function(color) Settings.espHookColor = color; Config.Objects.Hook.Color = color end
})

VisualTab:Colorpicker({
    Title = "Esp Gate",
    Desc = "Color for Gate ESP",
    Default = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
    Locked = false,
    Callback = function(color) Settings.espGateColor = color; Config.Objects.Gate.Color = color end
})

-- ADVANCED ESP ENGINE & MAP CACHE
local ESPFramesFolder = Instance.new("Folder")
ESPFramesFolder.Name = "__HyunjinESPEx__"
ESPFramesFolder.Parent = workspace

local ESPState = {
    espObjects = {},
    outlineObjects = {},
    playerRoles = {},
    playerTeamConns = {},
    cachedMapObjects = {Generators = {}, Pallets = {}, Hooks = {}, Gates = {}, Windows = {}},
    cachedPalletMeta = {},
    cachedHookMeshParts = {},
    completedGenerators = {},
    genIndices = {},
    nextGenIndex = 1,
    windowEspObjects = {},
    skipEndScreenConns = {},
    silentAimEnabled = false,
    silentAimTarget = nil,
    silentAimLookVector = nil,
    laserEspEnabled = true,
    triggerLaser = false,
    currentMuzzlePos = nil,
    currentTargetPos = nil,
    FOVCircle = nil,
    silentAimFovVisible = false,
}

local ItemIcons = {
    ["Adrenaline Shot"] = "rbxassetid://135388781922226",
    Bandage = "rbxassetid://97791520639443",
    Flashlight = "rbxassetid://103299939715311",
    Gate = "rbxassetid://131249244284700",
    ["Holy Water"] = "rbxassetid://86130208614143",
    ["Motion Tracker"] = "rbxassetid://92303584765773",
    ["Parrying Dagger"] = "rbxassetid://76822757630703",
    ["Riot Shield"] = "rbxassetid://95718705901699",
    ["Shadow Clone"] = "rbxassetid://134088840518889",
    ["Twist of Fate"] = "rbxassetid://98397448432071",
    ["WaxBound Candle"] = "rbxassetid://110413686590821",
}

local function getMatchingItemIcon(typeStr)
    if not typeStr or type(typeStr) ~= "string" then return nil end
    typeStr = typeStr:match("^%s*(.-)%s*$")
    if ItemIcons[typeStr] then return ItemIcons[typeStr] end
    for k, url in pairs(ItemIcons) do
        if k:lower() == typeStr:lower() then return url end
    end
    return nil
end

local function GetPlayerRole(player)
    local ok, team = pcall(function() return player.Team and player.Team.Name:lower() or "" end)
    if ok and (team:find("killer") or team:find("slayer")) then
        ESPState.playerRoles[player] = "KILLER"
        return "KILLER"
    elseif ok and (team:find("spectator") or team:find("lobby")) then
        ESPState.playerRoles[player] = "SPECTATOR"
        return "SPECTATOR"
    end
    ESPState.playerRoles[player] = "SURVIVOR"
    return "SURVIVOR"
end

local function Oqpmb(plr, char)
    local outline = ESPState.outlineObjects[plr]
    if not outline or not char or not char.Parent then return end
    local isKiller = (GetPlayerRole(plr) == "KILLER")
    local col = isKiller and Settings.killerColor or Settings.survivorColor
    local showOutline = isKiller and (Settings.killerShowOutline and ESPFlags.KillerChams) or (Settings.survivorShowOutline and ESPFlags.SurvivorChams)
    local outlineOnly = isKiller and Settings.killerOutlineOnly or Settings.survivorOutlineOnly

    outline.Adornee = char
    outline.FillColor = col
    outline.OutlineColor = col
    outline.FillTransparency = outlineOnly and 1 or Settings.fillTransparency
    outline.OutlineTransparency = 0
    outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    outline.Enabled = showOutline
end

local function esp27_func(plr, char)
    local espObj = ESPState.espObjects[plr]
    if not espObj then return end
    if not char or not char.Parent or plr.Character ~= char then return end
    local headOrTorso = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head")
    if not headOrTorso then return end
    
    if espObj.billboard then
        espObj.billboard.Adornee = headOrTorso
        espObj.billboard.Enabled = true
    end
    if espObj.itemBillboard then
        espObj.itemBillboard.Adornee = headOrTorso
        espObj.itemBillboard.Enabled = true
    end
    local isKiller = (GetPlayerRole(plr) == "KILLER")
    espObj.nameLabel.Visible = (isKiller and Settings.killerShowName) or (not isKiller and Settings.survivorShowName)
    espObj.nameLabel.Text = plr.Name
end

local function esp6_func(plr)
    if plr == LocalPlayer then return end
    GetPlayerRole(plr)

    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_BB_" .. plr.Name
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 150, 0, 18)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.MaxDistance = Settings.maxDistance
    bb.Parent = ESPFramesFolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = plr.Name
    local isKiller = (GetPlayerRole(plr) == "KILLER")
    nameLabel.Visible = (isKiller and Settings.killerShowName) or (not isKiller and Settings.survivorShowName)
    nameLabel.Parent = bb

    local itemBb = Instance.new("BillboardGui")
    itemBb.Name = "ESP_Item_" .. plr.Name
    itemBb.AlwaysOnTop = true
    itemBb.Size = UDim2.new(1.5, 0, 1.5, 0)
    itemBb.StudsOffset = Vector3.new(0, -5, 0)
    itemBb.MaxDistance = Settings.maxDistance
    itemBb.Parent = ESPFramesFolder

    local itemImg = Instance.new("ImageLabel")
    itemImg.Name = "ItemImage"
    itemImg.Size = UDim2.new(1, 0, 1, 0)
    itemImg.BackgroundTransparency = 1
    itemImg.Visible = false
    itemImg.Parent = itemBb

    ESPState.espObjects[plr] = {billboard = bb, nameLabel = nameLabel, itemBillboard = itemBb, itemImage = itemImg}

    local hl = Instance.new("Highlight")
    hl.Parent = ESPFramesFolder
    ESPState.outlineObjects[plr] = hl

    if plr.Character then
        esp27_func(plr, plr.Character)
        Oqpmb(plr, plr.Character)
    end

    if not ESPState.playerTeamConns[plr] then
        ESPState.playerTeamConns[plr] = plr:GetPropertyChangedSignal("Team"):Connect(function()
            GetPlayerRole(plr)
            if plr.Character then
                esp27_func(plr, plr.Character)
                Oqpmb(plr, plr.Character)
            end
        end)
    end
end

-- Killer Tracer ESP Implementation
local TracerSettings = {
    Color = Color3.fromRGB(255, 203, 138),
    Thickness = 1,
    Transparency = 1,
    AutoThickness = true,
    Length = 15,
    Smoothness = 0.2
}

local function SetupKillerTracer(plr)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = TracerSettings.Color
    line.Thickness = TracerSettings.Thickness
    line.Transparency = TracerSettings.Transparency

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if ESPFlags.KillerTracer and GetPlayerRole(plr) == "KILLER" and plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
            local headpos, OnScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            if OnScreen then
                local offsetCFrame = CFrame.new(0, 0, -TracerSettings.Length)
                local check = false
                line.From = Vector2.new(headpos.X, headpos.Y)
                if TracerSettings.AutoThickness then
                    local distance = (Player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    local value = math.clamp(1/distance*100, 0.1, 3)
                    line.Thickness = value
                end
                repeat
                    local dir = plr.Character.Head.CFrame:ToWorldSpace(offsetCFrame)
                    offsetCFrame = offsetCFrame * CFrame.new(0, 0, TracerSettings.Smoothness)
                    local dirpos, vis = Camera:WorldToViewportPoint(Vector3.new(dir.X, dir.Y, dir.Z))
                    if vis then
                        check = true
                        line.To = Vector2.new(dirpos.X, dirpos.Y)
                        line.Visible = true
                        offsetCFrame = CFrame.new(0, 0, -TracerSettings.Length)
                    end
                until check == true
            else 
                line.Visible = false
            end
        else 
            line.Visible = false
            if Players:FindFirstChild(plr.Name) == nil then
                connection:Disconnect()
                line:Remove()
            end
        end
    end)
end

for _, v in pairs(Players:GetPlayers()) do
    if v ~= Player then
        esp6_func(v)
        coroutine.wrap(SetupKillerTracer)(v)
    end
end

Players.PlayerAdded:Connect(function(newplr)
    if newplr ~= Player then
        esp6_func(newplr)
        coroutine.wrap(SetupKillerTracer)(newplr)
    end
end)

local function removePlayerESP(plr)
    if ESPState.espObjects[plr] then
        if ESPState.espObjects[plr].billboard then ESPState.espObjects[plr].billboard:Destroy() end
        if ESPState.espObjects[plr].itemBillboard then ESPState.espObjects[plr].itemBillboard:Destroy() end
        ESPState.espObjects[plr] = nil
    end
    if ESPState.outlineObjects[plr] then
        ESPState.outlineObjects[plr]:Destroy()
        ESPState.outlineObjects[plr] = nil
    end
    ESPState.playerRoles[plr] = nil
    if ESPState.playerTeamConns[plr] then
        ESPState.playerTeamConns[plr]:Disconnect()
        ESPState.playerTeamConns[plr] = nil
    end
end

Players.PlayerRemoving:Connect(removePlayerESP)

RunService.Heartbeat:Connect(function()
    for plr, espObj in pairs(ESPState.espObjects) do
        if plr and plr.Character then
            local isKiller = (GetPlayerRole(plr) == "KILLER")
            if espObj.billboard then
                espObj.billboard.MaxDistance = Settings.maxDistance
                espObj.nameLabel.Visible = (isKiller and Settings.killerShowName) or (not isKiller and Settings.survivorShowName)
            end
            if espObj.itemBillboard then
                espObj.itemBillboard.MaxDistance = Settings.maxDistance
            end
        end
    end

    for plr, outline in pairs(ESPState.outlineObjects) do
        if plr and plr.Character then
            local isKiller = (GetPlayerRole(plr) == "KILLER")
            local showOutline = isKiller and (Settings.killerShowOutline and ESPFlags.KillerChams) or (Settings.survivorShowOutline and ESPFlags.SurvivorChams)
            local outlineOnly = isKiller and Settings.killerOutlineOnly or Settings.survivorOutlineOnly
            local col = isKiller and Settings.killerColor or Settings.survivorColor

            outline.Adornee = plr.Character
            outline.FillColor = col
            outline.OutlineColor = col
            outline.Enabled = showOutline
            outline.FillTransparency = outlineOnly and 1 or Settings.fillTransparency
        end
    end
end)

local function ApplyBolongHighlight(targetObj, color)
    if not targetObj or not targetObj.Parent then return end
    local hl = targetObj:FindFirstChild("__HyunjinHL__")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "__HyunjinHL__"
        hl.Adornee = targetObj
        hl.FillTransparency = 0.8
        hl.OutlineTransparency = 0.2
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillColor = color
        hl.OutlineColor = color
        hl.Parent = targetObj
    else
        hl.FillColor = color
        hl.OutlineColor = color
        if not hl.Enabled then hl.Enabled = true end
    end
end

local function RemoveBolongHighlight(targetObj)
    if not targetObj then return end
    local hl = targetObj:FindFirstChild("__HyunjinHL__")
    if hl then hl:Destroy() end
end

local function UpdateGeneratorESP(genPart)
    if not genPart or not genPart.Parent then return true end
    if ESPState.completedGenerators[genPart] then return true end

    local progress = genPart:GetAttribute("RepairProgress") or genPart:GetAttribute("Progress") or 0
    local isCompleted = (progress >= 100) or (genPart:GetAttribute("Completed") == true) or (genPart:GetAttribute("IsCompleted") == true)
    
    local progressGui = genPart:FindFirstChild("__HyunjinGenProgress__")
    if isCompleted then
        if progressGui then progressGui:Destroy() end
        RemoveBolongHighlight(genPart)
        ESPState.completedGenerators[genPart] = true
        ESPState.genIndices[genPart] = nil
        return true
    end

    if Settings.espGeneratorEnabled then
        ApplyBolongHighlight(genPart, Settings.espGeneratorColor)
    else
        RemoveBolongHighlight(genPart)
    end

    if Settings.espGeneratorProgressGen then
        local genNum = ESPState.genIndices[genPart] or 1
        local color1 = math.clamp(progress, 0, 100)
        local color2 = (color1 < 50) and Settings.espGeneratorColor:Lerp(Color3.fromRGB(255, 200, 0), color1/50) or Color3.fromRGB(255, 200, 0):Lerp(Color3.fromRGB(100, 255, 80), (color1-50)/50)
        local hexColor = color2:ToHex()
        local genTitle = string.format("GEN%d", genNum)
        local pctText = string.format("%d%%", math.floor(progress + 0.5))
        
        local targetPart = genPart:FindFirstChild("GeneratorBody", true) or genPart:FindFirstChild("defaultMaterial", true) or (genPart:IsA("Model") and genPart.PrimaryPart) or genPart:FindFirstChildWhichIsA("BasePart", true)
        if not targetPart then return false end

        local textHtml = string.format("<font size=\"9\" color=\"#F4D03F\">%s</font> <font color=\"#555555\">│</font> <font color=\"#%s\">%s</font>", genTitle, hexColor, pctText)

        if not progressGui then
            progressGui = Instance.new("BillboardGui")
            progressGui.Name = "__HyunjinGenProgress__"
            progressGui.Adornee = targetPart
            progressGui.AlwaysOnTop = true
            progressGui.LightInfluence = 0
            progressGui.ResetOnSpawn = false
            progressGui.MaxDistance = 260
            progressGui.Size = UDim2.new(0, 100, 0, 14)
            progressGui.StudsOffset = Vector3.new(0, (targetPart.Size.Y / 2) + 3.5, 0)
            progressGui.Parent = genPart

            local lbl = Instance.new("TextLabel")
            lbl.Name = "Label"
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.RichText = true
            lbl.Text = textHtml
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.TextXAlignment = Enum.TextXAlignment.Center
            lbl.Parent = progressGui

            local stroke = Instance.new("UIStroke")
            stroke.Thickness = 0.8
            stroke.Transparency = 0.4
            stroke.Color = Color3.new(0, 0, 0)
            stroke.Parent = lbl
        else
            if progressGui.Adornee ~= targetPart then progressGui.Adornee = targetPart end
            local lbl = progressGui:FindFirstChild("Label")
            if lbl then lbl.Text = textHtml end
        end
    else
        if progressGui then progressGui:Destroy() end
    end
    return false
end

local function AddWindowESP(windowPart)
    if not windowPart or not windowPart.Parent or ESPState.windowEspObjects[windowPart] then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "WindowESP_Box"
    box.Adornee = windowPart
    box.Color3 = Settings.espWindowColor
    box.Transparency = 0.3
    box.Size = windowPart.Size
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Parent = ESPFramesFolder
    ESPState.windowEspObjects[windowPart] = box
end

local function RemoveWindowESP(windowPart)
    local box = ESPState.windowEspObjects[windowPart]
    if box then box:Destroy() end
    ESPState.windowEspObjects[windowPart] = nil
end

local function ProcessMapObject(obj)
    local name = obj.Name
    local nameLower = name:lower()

    if name == "Generator" then
        table.insert(ESPState.cachedMapObjects.Generators, obj)
        if not ESPState.genIndices[obj] then
            ESPState.genIndices[obj] = ESPState.nextGenIndex
            ESPState.nextGenIndex = ESPState.nextGenIndex + 1
        end
        UpdateGeneratorESP(obj)
    elseif name == "Hook" then
        table.insert(ESPState.cachedMapObjects.Hooks, obj)
        local mapParts = {}
        local modelChild = obj:FindFirstChild("Model")
        if modelChild then
            for _, child in ipairs(modelChild:GetDescendants()) do
                if child:IsA("MeshPart") then table.insert(mapParts, child) end
            end
        end
        ESPState.cachedHookMeshParts[obj] = mapParts
        if Settings.espHookEnabled then
            if #mapParts > 0 then
                for _, part in ipairs(mapParts) do ApplyBolongHighlight(part, Settings.espHookColor) end
            else
                ApplyBolongHighlight(obj, Settings.espHookColor)
            end
        end
    elseif name == "Gate" then
        table.insert(ESPState.cachedMapObjects.Gates, obj)
        if Settings.espGateEnabled then ApplyBolongHighlight(obj, Settings.espGateColor) end
    elseif name == "Pallet" or name == "Palletwrong" then
        table.insert(ESPState.cachedMapObjects.Pallets, obj)
        local palletPart = (obj:IsA("Model") and obj.PrimaryPart) or obj:FindFirstChildWhichIsA("BasePart", true) or (obj:IsA("BasePart") and obj)
        local isFake = nameLower:find("fake") or nameLower:find("broken") or nameLower:find("destroyed")
        ESPState.cachedPalletMeta[obj] = {part = palletPart, isFake = isFake and true or false}
        if Settings.espPalletEnabled and not isFake then
            ApplyBolongHighlight(obj, Settings.espPalletColor)
        end
    elseif nameLower == "window" and obj:IsA("Model") then
        local bottom = obj:FindFirstChild("Bottom", true)
        if bottom and bottom:IsA("BasePart") then
            table.insert(ESPState.cachedMapObjects.Windows, bottom)
            if Settings.espWindowEnabled then AddWindowESP(bottom) end
        end
    elseif nameLower == "bottom" and obj:IsA("BasePart") then
        if obj.Parent and obj.Parent.Name:lower() == "window" then
            table.insert(ESPState.cachedMapObjects.Windows, obj)
            if Settings.espWindowEnabled then AddWindowESP(obj) end
        end
    end
end

local function RemoveMapObject(obj)
    local name = obj.Name
    if name == "Generator" then
        for i, g in ipairs(ESPState.cachedMapObjects.Generators) do if g == obj then table.remove(ESPState.cachedMapObjects.Generators, i) break end end
        ESPState.genIndices[obj] = nil
        ESPState.completedGenerators[obj] = nil
        RemoveBolongHighlight(obj)
        local pGui = obj:FindFirstChild("__HyunjinGenProgress__")
        if pGui then pGui:Destroy() end
    elseif name == "Hook" then
        for i, h in ipairs(ESPState.cachedMapObjects.Hooks) do if h == obj then table.remove(ESPState.cachedMapObjects.Hooks, i) break end end
        local parts = ESPState.cachedHookMeshParts[obj]
        if parts then for _, p in ipairs(parts) do RemoveBolongHighlight(p) end else RemoveBolongHighlight(obj) end
        ESPState.cachedHookMeshParts[obj] = nil
    elseif name == "Gate" then
        for i, gt in ipairs(ESPState.cachedMapObjects.Gates) do if gt == obj then table.remove(ESPState.cachedMapObjects.Gates, i) break end end
        RemoveBolongHighlight(obj)
    elseif name == "Pallet" or name == "Palletwrong" then
        for i, p in ipairs(ESPState.cachedMapObjects.Pallets) do if p == obj then table.remove(ESPState.cachedMapObjects.Pallets, i) break end end
        RemoveBolongHighlight(obj)
        ESPState.cachedPalletMeta[obj] = nil
    else
        for win, box in pairs(ESPState.windowEspObjects) do
            if win == obj or not win.Parent then RemoveWindowESP(win) end
        end
    end
end

local function ScanMapFolder(folder)
    ESPState.cachedMapObjects = {Generators = {}, Pallets = {}, Hooks = {}, Gates = {}, Windows = {}}
    ESPState.cachedPalletMeta = {}
    ESPState.cachedHookMeshParts = {}
    ESPState.completedGenerators = {}
    ESPState.genIndices = {}
    ESPState.nextGenIndex = 1
    for win, box in pairs(ESPState.windowEspObjects) do box:Destroy() end
    ESPState.windowEspObjects = {}

    for _, desc in ipairs(folder:GetDescendants()) do
        ProcessMapObject(desc)
    end

    folder.DescendantAdded:Connect(ProcessMapObject)
    folder.DescendantRemoving:Connect(RemoveMapObject)
end

local mapFolder = workspace:FindFirstChild("Map") or workspace:FindFirstChild("WorkspaceMap")
if mapFolder then ScanMapFolder(mapFolder) end
workspace.ChildAdded:Connect(function(child)
    if child.Name == "Map" or child.Name == "WorkspaceMap" then
        task.wait(1)
        ScanMapFolder(child)
    end
end)

local function CreateFOVCircleGUI()
    local inst115 = Instance.new("ScreenGui")
    inst115.Name = "BolongFOV"
    inst115.ResetOnSpawn = false
    inst115.DisplayOrder = 999999
    pcall(function()
        inst115.Parent = (gethui and gethui() or CoreGui)
    end)
    if not inst115.Parent then
        inst115.Parent = PlayerGui
    end
    ESPState.FOVCircle = Instance.new("Frame")
    ESPState.FOVCircle.Size = UDim2.new(0, Settings.silentAimFovRadius * 2, 0, Settings.silentAimFovRadius * 2)
    ESPState.FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
    ESPState.FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    ESPState.FOVCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ESPState.FOVCircle.BackgroundTransparency = 1
    ESPState.FOVCircle.Visible = false
    ESPState.FOVCircle.Parent = inst115

    local inst116 = Instance.new("UICorner")
    inst116.CornerRadius = UDim.new(1, 0)
    inst116.Parent = ESPState.FOVCircle

    local inst117 = Instance.new("UIStroke")
    inst117.Color = Color3.fromRGB(255, 255, 255)
    inst117.Thickness = 2
    inst117.Transparency = 0.2
    inst117.Parent = ESPState.FOVCircle
end
CreateFOVCircleGUI()

local function DM_lMDIIqlpw(oxvvNv)
    if not oxvvNv then return nil end
    local inst118 = oxvvNv:FindFirstChild("UpperTorso")
    if inst118 and inst118:IsA("BasePart") then
        return inst118.Position
    end
    local char97 = oxvvNv:FindFirstChild("Torso")
    if char97 and char97:IsA("BasePart") then
        return char97.Position
    end
    local char98 = oxvvNv:FindFirstChild("HumanoidRootPart")
    if char98 then
        return char98.Position
    end
    return nil
end

local function lwHZx()
    local inst119 = Player.Character
    if not inst119 then return nil end
    local Inst5, HvlIxqz = pcall(function()
        return inst119:FindFirstChild("Twist of Fate"):FindFirstChild("Right Arm"):FindFirstChild("gun"):FindFirstChild("gun")
    end)
    if Inst5 and HvlIxqz and HvlIxqz:IsA("BasePart") then
        return HvlIxqz.Position
    end
    local inst120 = inst119:FindFirstChild("Right Arm") or inst119:FindFirstChild("RightHand")
    if inst120 then
        return inst120.Position
    end
    return nil
end

local TwistFireRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Items"):WaitForChild("Twist of Fate"):WaitForChild("Fire")
pcall(function()
    local origNamecall
    origNamecall = hookmetamethod(game, "__namecall", function(WqMm0W, ...)
        local remote12 = getnamecallmethod()
        if remote12 == "FireServer" and rawequal(WqMm0W, TwistFireRemote) then
            local flag18 = table.pack(...)
            if ESPState.silentAimEnabled and typeof(ESPState.silentAimLookVector) == "Vector3" then
                if flag18.n >= 3 and typeof(flag18[3]) == "Vector3" then
                    flag18[3] = ESPState.silentAimLookVector
                    if ESPState.laserEspEnabled then ESPState.triggerLaser = true end
                elseif flag18.n >= 2 and typeof(flag18[2]) == "Vector3" then
                    flag18[2] = ESPState.silentAimLookVector
                    if ESPState.laserEspEnabled then ESPState.triggerLaser = true end
                end
            end
            return origNamecall(WqMm0W, table.unpack(flag18, 1, flag18.n))
        end
        return origNamecall(WqMm0W, ...)
    end)
end)

local CrosshairDrawings = {}
local crosshairCreated = false
local lastCrosshairStyle = CrosshairConfig.Style

local espUpdateTick = 0

RunService.Heartbeat:Connect(function()
    if VisualSettings.Fullbright then
        Lighting.Brightness = VisualSettings.Brightness
        Lighting.ClockTime = VisualSettings.ClockTime
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    else
        Lighting.Brightness = VisualSettings.Brightness
        Lighting.ClockTime = VisualSettings.ClockTime
    end
    Lighting.GlobalShadows = not VisualSettings.NoShadow

    if VisualSettings.CleanSky then
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then v:Destroy() end
        end
    end

    espUpdateTick = espUpdateTick + 1
    if espUpdateTick >= 12 then
        espUpdateTick = 0

        for _, gen in ipairs(ESPState.cachedMapObjects.Generators) do
            if gen and gen.Parent then
                UpdateGeneratorESP(gen)
            end
        end

        for _, pallet in ipairs(ESPState.cachedMapObjects.Pallets) do
            if pallet and pallet.Parent then
                local meta = ESPState.cachedPalletMeta[pallet]
                if Settings.espPalletEnabled and meta and not meta.isFake then
                    ApplyBolongHighlight(pallet, Settings.espPalletColor)
                else
                    RemoveBolongHighlight(pallet)
                end
            end
        end

        for _, hook in ipairs(ESPState.cachedMapObjects.Hooks) do
            if hook and hook.Parent then
                local parts = ESPState.cachedHookMeshParts[hook]
                if Settings.espHookEnabled then
                    if parts and #parts > 0 then
                        for _, p in ipairs(parts) do ApplyBolongHighlight(p, Settings.espHookColor) end
                    else
                        ApplyBolongHighlight(hook, Settings.espHookColor)
                    end
                else
                    if parts then for _, p in ipairs(parts) do RemoveBolongHighlight(p) end else RemoveBolongHighlight(hook) end
                end
            end
        end

        for _, gate in ipairs(ESPState.cachedMapObjects.Gates) do
            if gate and gate.Parent then
                if Settings.espGateEnabled then
                    ApplyBolongHighlight(gate, Settings.espGateColor)
                else
                    RemoveBolongHighlight(gate)
                end
            end
        end

        for win, box in pairs(ESPState.windowEspObjects) do
            if win and win.Parent and box and box.Parent then
                if Settings.espWindowEnabled then
                    box.Color3 = Settings.espWindowColor
                    box.Size = win.Size
                    box.Visible = true
                else
                    box.Visible = false
                end
            else
                RemoveWindowESP(win)
            end
        end
        if Settings.espWindowEnabled then
            for _, win in ipairs(ESPState.cachedMapObjects.Windows) do
                if win and win.Parent and not ESPState.windowEspObjects[win] then
                    AddWindowESP(win)
                end
            end
        end
    end

    if ESPState.FOVCircle then
        ESPState.FOVCircle.Visible = ESPState.silentAimFovVisible
        local gui44 = Settings.silentAimFovRadius * 2
        if ESPState.FOVCircle.Size.X.Offset ~= gui44 then
            ESPState.FOVCircle.Size = UDim2.new(0, gui44, 0, gui44)
        end
    end

    if not ESPState.silentAimEnabled then
        ESPState.silentAimTarget = nil
        ESPState.silentAimLookVector = nil
    else
        local char99 = Player.Character
        if char99 then
            local char100 = char99:FindFirstChild("HumanoidRootPart")
            local cam13 = Camera
            if char100 and cam13 then
                local char101 = nil
                local char102 = math.huge
                for _, Bw0M_ in ipairs(Players:GetPlayers()) do
                    if Bw0M_ ~= Player and GetPlayerRole(Bw0M_) == "KILLER" then
                        local char103 = Bw0M_.Character
                        if char103 then
                            local char104 = char103:FindFirstChildOfClass("Humanoid")
                            local char105 = DM_lMDIIqlpw(char103)
                            if char104 and char104.Health > 0 and typeof(char105) == "Vector3" then
                                local char106 = (char105 - char100.Position).Magnitude
                                if char106 < char102 then
                                    char102 = char106
                                    char101 = Bw0M_
                                end
                            end
                        end
                    end
                end

                if char101 and char101.Character then
                    local cam14 = DM_lMDIIqlpw(char101.Character)
                    if typeof(cam14) == "Vector3" then
                        local flag19 = true
                        local Flag2, bDWoxolNOmnXz = cam13:WorldToViewportPoint(cam14)
                        if bDWoxolNOmnXz then
                            local cam15 = Vector2.new(cam13.ViewportSize.X / 2, cam13.ViewportSize.Y / 2)
                            local cam16 = (Vector2.new(Flag2.X, Flag2.Y) - cam15).Magnitude
                            if cam16 > Settings.silentAimFovRadius then
                                flag19 = false
                            end
                        else
                            flag19 = false
                        end

                        if flag19 then
                            local gui45 = lwHZx()
                            if typeof(gui45) ~= "Vector3" then
                                gui45 = cam13.CFrame.Position
                            end
                            local esp39 = cam14 - gui45
                            local esp40 = esp39.Magnitude
                            if esp40 > 0.1 then
                                ESPState.silentAimTarget = cam14
                                ESPState.silentAimLookVector = Vector3.new(esp39.X / esp40, esp39.Y / esp40, esp39.Z / esp40)
                                ESPState.currentMuzzlePos = gui45
                                ESPState.currentTargetPos = cam14
                            else
                                ESPState.silentAimTarget = nil
                                ESPState.silentAimLookVector = nil
                            end
                        else
                            ESPState.silentAimTarget = nil
                            ESPState.silentAimLookVector = nil
                        end
                    else
                        ESPState.silentAimTarget = nil
                        ESPState.silentAimLookVector = nil
                    end
                else
                    ESPState.silentAimTarget = nil
                    ESPState.silentAimLookVector = nil
                end
            end
        end
    end

    if ESPState.triggerLaser then
        ESPState.triggerLaser = false
        local inst121 = ESPState.currentMuzzlePos
        local inst122 = ESPState.currentTargetPos
        if typeof(inst121) == "Vector3" and typeof(inst122) == "Vector3" then
            local inst123 = (inst121 - inst122).Magnitude
            if inst123 >= 0.1 then
                local part19 = Instance.new("Part")
                part19.Name = "SilentLaser"
                part19.Anchored = true
                part19.CanCollide = false
                part19.Material = Enum.Material.Neon
                part19.Color = Color3.fromRGB(255, 0, 0)
                part19.Transparency = 0.3
                part19.Size = Vector3.new(0.15, 0.15, inst123)
                part19.CFrame = CFrame.new(inst121, inst122) * CFrame.new(0, 0, -inst123 / 2)
                part19.Parent = workspace
                task.delay(0.4, function()
                    if part19 then part19:Destroy() end
                end)
            end
        end
    end

    if CrosshairConfig.Enabled then
        if lastCrosshairStyle ~= CrosshairConfig.Style then
            for _, v in pairs(CrosshairDrawings) do if v and v.Remove then v:Remove() end end
            CrosshairDrawings = {}
            crosshairCreated = false
            lastCrosshairStyle = CrosshairConfig.Style
        end

        local cam = workspace.CurrentCamera
        local center = Vector2.new(cam.ViewportSize.X / 2 + CrosshairConfig.OffsetX, cam.ViewportSize.Y / 2 + CrosshairConfig.OffsetY)

        if not crosshairCreated then
            crosshairCreated = true
            if CrosshairConfig.Style == "Plus" then
                for i = 1, 4 do
                    local line = Drawing.new("Line")
                    line.Visible = true
                    table.insert(CrosshairDrawings, line)
                end
            elseif CrosshairConfig.Style == "Dot" then
                local dot = Drawing.new("Circle")
                dot.Filled = true
                dot.Visible = true
                table.insert(CrosshairDrawings, dot)
            elseif CrosshairConfig.Style == "Circle" then
                local circle = Drawing.new("Circle")
                circle.Filled = false
                circle.Visible = true
                table.insert(CrosshairDrawings, circle)
            end
        end

        if CrosshairConfig.Style == "Plus" then
            for _, line in pairs(CrosshairDrawings) do
                line.Color = CrosshairConfig.Color
                line.Thickness = CrosshairConfig.Thickness
                line.Visible = true
            end
            if CrosshairDrawings[1] then
                CrosshairDrawings[1].From = center + Vector2.new(-CrosshairConfig.Size, 0)
                CrosshairDrawings[1].To   = center + Vector2.new(-2, 0)
                CrosshairDrawings[2].From = center + Vector2.new(CrosshairConfig.Size, 0)
                CrosshairDrawings[2].To   = center + Vector2.new(2, 0)
                CrosshairDrawings[3].From = center + Vector2.new(0, -CrosshairConfig.Size)
                CrosshairDrawings[3].To   = center + Vector2.new(0, -2)
                CrosshairDrawings[4].From = center + Vector2.new(0, CrosshairConfig.Size)
                CrosshairDrawings[4].To   = center + Vector2.new(0, 2)
            end
        elseif CrosshairConfig.Style == "Dot" and CrosshairDrawings[1] then
            CrosshairDrawings[1].Position = center
            CrosshairDrawings[1].Radius = CrosshairConfig.Size / 2
            CrosshairDrawings[1].Color = CrosshairConfig.Color
            CrosshairDrawings[1].Visible = true
        elseif CrosshairConfig.Style == "Circle" and CrosshairDrawings[1] then
            CrosshairDrawings[1].Position = center
            CrosshairDrawings[1].Radius = CrosshairConfig.Size
            CrosshairDrawings[1].Color = CrosshairConfig.Color
            CrosshairDrawings[1].Thickness = CrosshairConfig.Thickness
            CrosshairDrawings[1].Visible = true
        end
    else
        for _, v in pairs(CrosshairDrawings) do if v and v.Visible then v.Visible = false end end
    end

    local myRoot = getRoot()
    local killerNearby = false

    if ESPFlags.SCP then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:lower():find("scp") then
                ApplyBolongHighlight(obj, Config.Objects.SCP.Color)
            end
        end
    else
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:lower():find("scp") then
                RemoveBolongHighlight(obj)
            end
        end
    end

    if myRoot and Settings.warnEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local root = p.Character:FindFirstChild("HumanoidRootPart")
                local isKiller = (GetPlayerRole(p) == "KILLER")
                if isKiller and root then
                    local dist = (root.Position - myRoot.Position).Magnitude
                    if dist < Settings.warnDist1 then killerNearby = true end
                end
            end
        end

        local warn = myRoot:FindFirstChild("KillerWarn")
        if killerNearby then
            if not warn then
                warn = Instance.new("BillboardGui")
                warn.Name = "KillerWarn"
                warn.Size = UDim2.new(0, 50, 0, 50)
                warn.StudsOffset = Vector3.new(0, 4, 0)
                warn.AlwaysOnTop = true
                warn.Adornee = myRoot
                local lbl = Instance.new("TextLabel", warn)
                lbl.Size = UDim2.new(1,0,1,0)
                lbl.BackgroundTransparency = 1
                lbl.Text = "!"
                lbl.TextColor3 = Color3.fromRGB(255, 0, 0)
                lbl.TextSize = 40
                lbl.Font = Enum.Font.GothamBold
                warn.Parent = myRoot
            end
        elseif warn then
            warn:Destroy()
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not Settings.espItemEnabled then
        for _, espObj in pairs(ESPState.espObjects) do
            if espObj and espObj.itemImage and espObj.itemImage.Visible then
                espObj.itemImage.Visible = false
            end
        end
        return
    end

    local myChar = Player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

    for plr, espObj in pairs(ESPState.espObjects) do
        if espObj and espObj.itemBillboard and espObj.itemBillboard.Parent then
            local char = plr.Character
            if not char then
                espObj.itemImage.Visible = false
                continue
            end
            local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            if head then
                espObj.itemBillboard.Adornee = head
                espObj.itemBillboard.Enabled = true
            end

            local eqItem = nil
            local eq1 = char:GetAttribute("EquippedItem") or char:GetAttribute("Equippedltem")
            if type(eq1) == "string" then eqItem = eq1
            elseif typeof(eq1) == "Instance" then eqItem = eq1.Name end

            if not eqItem then
                local eq2 = plr:GetAttribute("EquippedItem") or plr:GetAttribute("Equippedltem")
                if type(eq2) == "string" then eqItem = eq2
                elseif typeof(eq2) == "Instance" then eqItem = eq2.Name end
            end

            local iconUrl = getMatchingItemIcon(eqItem)
            if iconUrl then
                if espObj.itemImage.Image ~= iconUrl then espObj.itemImage.Image = iconUrl end
                if myRoot and char:FindFirstChild("HumanoidRootPart") then
                    local dist = (myRoot.Position - char.HumanoidRootPart.Position).Magnitude
                    local scale = math.clamp(1.5 + ((dist / 200) * 2), 1.5, 3.5)
                    espObj.itemBillboard.Size = UDim2.new(scale, 0, scale, 0)
                end
                espObj.itemImage.Visible = true
            else
                espObj.itemImage.Visible = false
            end
        end
    end
end)

-- ==========================================
-- 6. LOCATION TAB
-- ==========================================
LocationTab:Section({ Title = "Teleport Generator", Icon = "map-pin" })

LocationTab:Button({
    Title = "Teleport ke Generator Terdekat",
    Desc = "Memindahkan karakter Anda ke generator yang belum selesai.",
    Callback = function()
        pcall(function()
            local gen, point = GetNearestActiveGenerator()
            local root = getRoot()
            if root and point then
                root.CFrame = point.CFrame + Vector3.new(0, 3, 0)
                WindUI:Notify({ Title = "Location", Content = "Berhasil teleport ke generator!", Duration = 2 })
            else
                WindUI:Notify({ Title = "Location", Content = "Generator aktif tidak ditemukan!", Duration = 2 })
            end
        end)
    end
})

LocationTab:Section({ Title = "Firman", Icon = "skull" })

-- ==========================================
-- 7. MISC TAB
-- ==========================================
CheckTab:Section({ Title = "Game Emotes" })

local allEmotes = (getgenv().GetAllEmotes and getgenv().GetAllEmotes()) or {"No Emotes Found"}
local selectedEmote = allEmotes[1] or "No Emotes Found"

CheckTab:Dropdown({
    Title = "Select Emote",
    Values = allEmotes,
    Default = selectedEmote,
    Callback = function(v)
        if v and v ~= "No Emotes Found" then
            selectedEmote = v
            if getgenv().PlayEmoteByName then getgenv().PlayEmoteByName(v) end
        end
    end
})

CheckTab:Toggle({
    Title = "Start / Stop Emote",
    Default = false,
    Callback = function(v)
        if v then
            if selectedEmote and selectedEmote ~= "No Emotes Found" and getgenv().PlayEmoteByName then
                getgenv().PlayEmoteByName(selectedEmote)
            end
        else
            if getgenv().StopCurrentEmote then getgenv().StopCurrentEmote() end
        end
    end
})

CheckTab:Slider({
    Title = "Emote Speed",
    Value = { Min = 1, Max = 20, Default = 5, Step = 0.1 },
    Callback = function(v)
        if getgenv().SetAnimationSpeed then getgenv().SetAnimationSpeed(v) end
    end
})

CheckTab:Toggle({
    Title = "Sped Up Emote",
    Default = false,
    Callback = function(v)
        if getgenv().ToggleAnimationSpeed then getgenv().ToggleAnimationSpeed(v) end
    end
})

CheckTab:Section({ Title = "Custom Emotes" })

CheckTab:Button({ Title = "Stop Animation", Callback = function() if _G.StopAnimation then _G.StopAnimation() end end })
CheckTab:Button({ Title = "Arm Up", Callback = function() if _G.PlayAnimation then _G.PlayAnimation(117042998468241, "standing", false, "nonlooped") end end })
CheckTab:Button({ Title = "Attack", Callback = function() if _G.PlayAnimation then _G.PlayAnimation(133963973694098, "nonlooped") end end })
CheckTab:Button({ Title = "Attack 2", Callback = function() if _G.PlayAnimation then _G.PlayAnimation(78935059863801, "standing", false, "nonlooped") end end })
CheckTab:Button({ Title = "XZ", Callback = function() if _G.PlayAnimation then _G.PlayAnimation(80411309607666, "standing", false, "nonlooped") end end })
CheckTab:Button({ Title = "XZ2", Callback = function() if _G.PlayAnimation then _G.PlayAnimation(100092272524635, "standing", false, "nonlooped") end end })
CheckTab:Button({ Title = "LOL", Callback = function() if _G.PlayAnimation then _G.PlayAnimation(129967390, "standing", false, "nonlooped") end end })
CheckTab:Button({ Title = "Goida", Callback = function() if _G.PlayAnimation then _G.PlayAnimation(84440437648153, "nonlooped") end end })
CheckTab:Button({ Title = "Kick", Callback = function() if _G.PlayAnimation then _G.PlayAnimation(135181748009911, "standing", false, "nonlooped") end end })
CheckTab:Button({ Title = "Kick 2", Callback = function() if _G.PlayAnimation then _G.PlayAnimation(77210283630654, "standing", false, "nonlooped") end end })
CheckTab:Button({ Title = "Cracking", Callback = function() if _G.PlayAnimation then _G.PlayAnimation(91619171958082, "standing", true, "looped") end end })

CheckTab:Section({ Title = "Custom Animations" })

CheckTab:Toggle({
    Title = "Crawling",
    Default = false,
    Callback = function(v)
        if v then
            if _G.StopAnimation then _G.StopAnimation() end
            task.wait(1)
            if _G.PlayAnimation then _G.PlayAnimation(78719043959654, "walking", true, "looped") end
            task.wait(1)
            if _G.PlayAnimation then _G.PlayAnimation(126526181422628, "standing", true, "looped") end
        else
            if _G.StopAnimation then _G.StopAnimation() end
        end
    end
})

CheckTab:Toggle({
    Title = "Injured",
    Default = false,
    Callback = function(v)
        if v then
            if _G.StopAnimation then _G.StopAnimation() end
            task.wait(1)
            if _G.PlayAnimation then _G.PlayAnimation(135084204086504, "walking", true, "looped") end
            task.wait(1)
            if _G.PlayAnimation then _G.PlayAnimation(72208365305487, "standing", true, "looped") end
        else
            if _G.StopAnimation then _G.StopAnimation() end
        end
    end
})

CheckTab:Toggle({
    Title = "RUNNNN",
    Default = false,
    Callback = function(v)
        if v then
            if _G.StopAnimation then _G.StopAnimation() end
            task.wait(1)
            if _G.PlayAnimation then _G.PlayAnimation(116093934008204, "walking", true, "looped") end
            task.wait(1)
            if _G.PlayAnimation then _G.PlayAnimation(134758728973154, "standing", true, "looped") end
        else
            if _G.StopAnimation then _G.StopAnimation() end
        end
    end
})

CheckTab:Toggle({
    Title = "BUHOI",
    Default = false,
    Callback = function(v)
        if v then
            if _G.StopAnimation then _G.StopAnimation() end
            task.wait(1)
            if _G.PlayAnimation then _G.PlayAnimation(92098503722633, "walking", true, "looped") end
            task.wait(1)
            if _G.PlayAnimation then _G.PlayAnimation(96744338559260, "standing", true, "looped") end
        else
            if _G.StopAnimation then _G.StopAnimation() end
        end
    end
})

_G.EmoteFABEnabled = false

local EmoteFABGui = Instance.new("ScreenGui")
EmoteFABGui.Name = "HyunjinEmoteFAB"
EmoteFABGui.ResetOnSpawn = false
EmoteFABGui.Parent = CoreGui
EmoteFABGui.Enabled = false

local FABButton = Instance.new("TextButton")
FABButton.Name = "FABButton"
FABButton.Size = UDim2.new(0, 40, 0, 40)
FABButton.BackgroundColor3 = Color3.fromRGB(30, 18, 22)
FABButton.Text = "🎭"
FABButton.TextColor3 = Color3.fromRGB(245, 245, 245)
FABButton.TextSize = 18
FABButton.Font = Enum.Font.GothamBold
FABButton.Parent = EmoteFABGui
applyCorner(FABButton, 20)
applyStroke(FABButton, Color3.fromRGB(225, 45, 75), 1)

local EmoteWheelGui = Instance.new("ScreenGui")
EmoteWheelGui.Name = "HyunjinEmoteWheelGui"
EmoteWheelGui.ResetOnSpawn = false
EmoteWheelGui.Parent = CoreGui
EmoteWheelGui.Enabled = false

local WheelContainer = Instance.new("Frame")
WheelContainer.Size = UDim2.new(0, 320, 0, 320)
WheelContainer.AnchorPoint = Vector2.new(0.5, 0.5)
WheelContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
WheelContainer.BackgroundTransparency = 1
WheelContainer.Parent = EmoteWheelGui

local wheelItems = {
    {Name = "Arm Up", Func = function() if _G.PlayAnimation then _G.PlayAnimation(117042998468241, "standing", false, "nonlooped") end end},
    {Name = "Attack", Func = function() if _G.PlayAnimation then _G.PlayAnimation(133963973694098, "nonlooped") end end},
    {Name = "Attack 2", Func = function() if _G.PlayAnimation then _G.PlayAnimation(78935059863801, "standing", false, "nonlooped") end end},
    {Name = "XZ", Func = function() if _G.PlayAnimation then _G.PlayAnimation(80411309607666, "standing", false, "nonlooped") end end},
    {Name = "XZ2", Func = function() if _G.PlayAnimation then _G.PlayAnimation(100092272524635, "standing", false, "nonlooped") end end},
    {Name = "LOL", Func = function() if _G.PlayAnimation then _G.PlayAnimation(129967390, "standing", false, "nonlooped") end end},
    {Name = "Goida", Func = function() if _G.PlayAnimation then _G.PlayAnimation(84440437648153, "nonlooped") end end},
    {Name = "Kick", Func = function() if _G.PlayAnimation then _G.PlayAnimation(135181748009911, "standing", false, "nonlooped") end end},
    {Name = "Kick 2", Func = function() if _G.PlayAnimation then _G.PlayAnimation(77210283630654, "standing", false, "nonlooped") end end},
    {Name = "Cracking", Func = function() if _G.PlayAnimation then _G.PlayAnimation(91619171958082, "standing", true, "looped") end end},
    {Name = "Crawling", Func = function() if _G.StopAnimation then _G.StopAnimation() end task.wait(0.1) if _G.PlayAnimation then _G.PlayAnimation(78719043959654, "walking", true, "looped") end end},
    {Name = "Injured", Func = function() if _G.StopAnimation then _G.StopAnimation() end task.wait(0.1) if _G.PlayAnimation then _G.PlayAnimation(135084204086504, "walking", true, "looped") end end},
    {Name = "RUNNNN", Func = function() if _G.StopAnimation then _G.StopAnimation() end task.wait(0.1) if _G.PlayAnimation then _G.PlayAnimation(116093934008204, "walking", true, "looped") end end},
    {Name = "BUHOI", Func = function() if _G.StopAnimation then _G.StopAnimation() end task.wait(0.1) if _G.PlayAnimation then _G.PlayAnimation(92098503722633, "walking", true, "looped") end end},
}

local radius = 120
local totalItems = #wheelItems
for i, item in ipairs(wheelItems) do
    local angle = (i - 1) * (2 * math.pi / totalItems)
    local x = math.cos(angle) * radius
    local y = math.sin(angle) * radius

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 75, 0, 30)
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.Position = UDim2.new(0.5, x, 0.5, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 18, 22)
    btn.Text = item.Name
    btn.TextColor3 = Color3.fromRGB(245, 245, 245)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = WheelContainer
    applyCorner(btn, 6)
    applyStroke(btn, Color3.fromRGB(225, 45, 75), 1)

    btn.MouseButton1Click:Connect(function()
        pcall(item.Func)
        EmoteWheelGui.Enabled = false
    end)
end

local closeWheelBtn = Instance.new("TextButton")
closeWheelBtn.Size = UDim2.new(0, 50, 0, 50)
closeWheelBtn.AnchorPoint = Vector2.new(0.5, 0.5)
closeWheelBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
closeWheelBtn.BackgroundColor3 = Color3.fromRGB(225, 45, 75)
closeWheelBtn.Text = "X"
closeWheelBtn.TextColor3 = Color3.fromRGB(245, 245, 245)
closeWheelBtn.TextSize = 16
closeWheelBtn.Font = Enum.Font.GothamBold
closeWheelBtn.Parent = WheelContainer
applyCorner(closeWheelBtn, 25)
applyStroke(closeWheelBtn, Color3.fromRGB(255, 255, 255), 1)

closeWheelBtn.MouseButton1Click:Connect(function()
    EmoteWheelGui.Enabled = false
end)

FABButton.MouseButton1Click:Connect(function()
    EmoteWheelGui.Enabled = not EmoteWheelGui.Enabled
end)

task.spawn(function()
    while task.wait(0.2) do
        if _G.EmoteFABEnabled then
            pcall(function()
                local emotesFolder = PlayerGui:FindFirstChild("Emotes")
                local emotebut = emotesFolder and emotesFolder:FindFirstChild("emotebut")
                local emote = emotebut and emotebut:FindFirstChild("emote")
                local icon = emote and emote:FindFirstChild("icon")
                if icon and icon:IsA("GuiObject") and icon.Visible then
                    EmoteFABGui.Enabled = true
                    local pos = icon.AbsolutePosition
                    local size = icon.AbsoluteSize
                    FABButton.Position = UDim2.new(0, pos.X - size.X - 12, 0, pos.Y)
                    FABButton.Size = UDim2.new(0, size.X, 0, size.Y)
                else
                    EmoteFABGui.Enabled = true
                    FABButton.Position = UDim2.new(0, 15, 0, 220)
                    FABButton.Size = UDim2.new(0, 40, 0, 40)
                end
            end)
        else
            EmoteFABGui.Enabled = false
            EmoteWheelGui.Enabled = false
        end
    end
end)

CheckTab:Toggle({
    Title = "Toggle Emote Wheel FAB",
    Default = false,
    Callback = function(v)
        _G.EmoteFABEnabled = v
        if not v then EmoteWheelGui.Enabled = false end
    end
})

CheckTab:Section({ Title = "Skip Cutscene" })

local function Wb0x1XpWv()
    for _, conn in ipairs(ESPState.skipEndScreenConns) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(ESPState.skipEndScreenConns)
end

local function oqWmXqpHU(lWquoZN)
    lWquoZN = lWquoZN or false
    local cam11 = Workspace.CurrentCamera
    local conn18 = ESPState.skipEndScreenConns
    local tbl33 = false
    local cam12 = false
    local conn19 = false 
    pcall(function()
        local inst85 = ReplicatedStorage:FindFirstChild("Remotes")
        if not inst85 then return end
        local function vXqQwb_N(BlxbvHpU)
            if BlxbvHpU and BlxbvHpU:IsA("RemoteEvent") then
                for _, QoDbHvpw1b in ipairs(getconnections(BlxbvHpU.OnClientEvent)) do
                    QoDbHvpw1b:Disable()
                    QoDbHvpw1b:Disconnect()
                end
            end
        end
        local inst86 = inst85:FindFirstChild("Game")
        if inst86 then
            for _, qvlZuZZQUwOX in ipairs({"cutscene", "cutsceneEnd", "cutsceneEnd2", "endscreencutscene", "cutsceneEndwithownchar", "shake"}) do
                vXqQwb_N(inst86:FindFirstChild(qvlZuZZQUwOX))
            end
        end
        local inst87 = inst85:FindFirstChild("Killers")
        if inst87 then
            vXqQwb_N(inst87:FindFirstChild("Startmori"))
        end
        if lWquoZN then
            vXqQwb_N(inst85:FindFirstChild("Darkness2"))
        end
    end)

    local function WvxNv0n()
        if not cam11 then return end
        if cam11.CameraType == Enum.CameraType.Scriptable then
            tbl33 = true
            cam11.CameraType = Enum.CameraType.Custom
            tbl33 = false
        end
    end

    if cam11 then
        WvxNv0n()
        table.insert(conn18, cam11:GetPropertyChangedSignal("CameraType"):Connect(function()
            if not tbl33 then WvxNv0n() end
        end))
        table.insert(conn18, cam11:GetPropertyChangedSignal("FieldOfView"):Connect(function()
            if cam12 or Settings.lockFovEnabled then return end
            if cam11.FieldOfView ~= 70 then
                cam12 = true
                cam11.FieldOfView = 70
                cam12 = false
            end
        end))
    end

    table.insert(conn18, Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        cam11 = Workspace.CurrentCamera
        if cam11 then WvxNv0n() end
    end))

    local function ONMOlOHl()
        local inst88 = Workspace:FindFirstChild("Map")
        if inst88 then
            local inst89 = inst88:FindFirstChild("endscreen")
            if inst89 then pcall(function() inst89.Parent = nil end) end
        end
        local inst90 = Workspace:FindFirstChild("BackgroundSounds")
        if inst90 then pcall(function() inst90:Destroy() end) end
    end
    ONMOlOHl()
    table.insert(conn18, Workspace.DescendantAdded:Connect(function(wzNnNH)
        if wzNnNH.Name == "endscreen" and wzNnNH.Parent and wzNnNH.Parent.Name == "Map" then
            task.wait(0.01)
            pcall(function() wzNnNH.Parent = nil end)
        elseif wzNnNH.Name == "BackgroundSounds" then
            pcall(function() wzNnNH:Destroy() end)
        end
    end))

    local function gui3_func(NMMoDNmv1Iz1o)
        if not NMMoDNmv1Iz1o or not NMMoDNmv1Iz1o.Parent then return end
        pcall(function()
            if lWquoZN and NMMoDNmv1Iz1o.Name == "Darkness" and NMMoDNmv1Iz1o:IsA("ScreenGui") then
                NMMoDNmv1Iz1o.Enabled = false
            end
            for _, WONuHmwUDU0O in ipairs(NMMoDNmv1Iz1o:GetDescendants()) do
                if WONuHmwUDU0O:IsA("VideoFrame") then
                    WONuHmwUDU0O:Destroy()
                elseif WONuHmwUDU0O:IsA("Frame") and (WONuHmwUDU0O.Name == "Frame2" or WONuHmwUDU0O.Name == "blackout") then
                    WONuHmwUDU0O.BackgroundTransparency = 1
                    if lWquoZN then
                        WONuHmwUDU0O.Visible = false
                        WONuHmwUDU0O:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
                            if WONuHmwUDU0O.BackgroundTransparency < 1 then WONuHmwUDU0O.BackgroundTransparency = 1 end
                        end)
                        WONuHmwUDU0O:GetPropertyChangedSignal("Visible"):Connect(function()
                            if WONuHmwUDU0O.Visible then WONuHmwUDU0O.Visible = false end
                        end)
                    end
                elseif WONuHmwUDU0O:IsA("ParticleEmitter") or WONuHmwUDU0O:IsA("Beam") or WONuHmwUDU0O:IsA("Trail") then
                    WONuHmwUDU0O.Enabled = false
                end
            end
        end)
    end

    for _, wozm_ in ipairs(PlayerGui:GetChildren()) do
        local tbl34 = wozm_.Name
        if tbl34 == "Darkness" or tbl34 == "EndScreen" or tbl34 == "Cutscene" or tbl34 == "Results" then
            gui3_func(wozm_)
        end
    end
    table.insert(conn18, PlayerGui.ChildAdded:Connect(function(uWzlDzNNHHXImM)
        local conn20 = uWzlDzNNHHXImM.Name
        if conn20 == "Darkness" or conn20 == "EndScreen" or conn20 == "Cutscene" or conn20 == "Results" then
            task.wait(0.05)
            gui3_func(uWzlDzNNHHXImM)
        end
    end))
end

CheckTab:Toggle({
    Title = "Skip End Screen",
    Default = false,
    Callback = function(v)
        if v then
            Wb0x1XpWv()
            oqWmXqpHU(false)
            WindUI:Notify({ Title = "Skip Cutscene", Content = "Skip End Screen Aktif!", Duration = 2 })
        else
            Wb0x1XpWv()
        end
    end
})

CheckTab:Toggle({
    Title = "Skip Loading & End Screen",
    Default = false,
    Callback = function(v)
        if v then
            Wb0x1XpWv()
            oqWmXqpHU(true)
            WindUI:Notify({ Title = "Skip Cutscene", Content = "Skip Loading & End Screen Aktif!", Duration = 2 })
        else
            Wb0x1XpWv()
        end
    end
})

CheckTab:Section({ Title = "Morph Avatar" })

CheckTab:Input({
    Title = "Target Username",
    Default = "",
    Placeholder = "Ketik username target...",
    Callback = function(val) AvatarStealer.TargetUsername = val end
})

CheckTab:Button({ Title = "Copy Avatar", Callback = function() vzImqwp(AvatarStealer.TargetUsername) end })
CheckTab:Button({ Title = "Reset to Original Skin", Callback = function() 
    local char = Player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ApplyDescriptionReset() end
    end
end })

-- ==========================================
-- UPDATE TAB (FAST HEAL SYSTEM - INSTANT SELF-HEAL)
-- ==========================================
UpdateTab:Section({ Title = "Rapid Healing System", Icon = "briefcase-medical" })

_G.FastHealSelf = false

UpdateTab:Toggle({
    Title = "Fast Heal (Instant Self-Heal)",
    Default = false,
    Callback = function(v)
        _G.FastHealSelf = v
        if v then
            WindUI:Notify({ Title = "Fast Heal", Content = "Fast Heal Instan Diaktifkan!", Duration = 2 })
        end
    end
})

-- Task background untuk memicu seluruh 10 RemoteEvent healing khusus untuk diri sendiri secara instan
task.spawn(function()
    while true do
        task.wait(0.2)
        if _G.FastHealSelf then
            pcall(function()
                local healingRemotes = ReplicatedStorage:FindFirstChild("Remotes") 
                    and ReplicatedStorage.Remotes:FindFirstChild("Healing")
                
                local char = Player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if healingRemotes and hrp and hum then
                    if hum.Health < hum.MaxHealth then
                        local displayBlood = healingRemotes:FindFirstChild("DisplayBlood")
                        local healAnim = healingRemotes:FindFirstChild("HealAnim")
                        local healAnimRec = healingRemotes:FindFirstChild("HealAnimRec")
                        local healEvent = healingRemotes:FindFirstChild("HealEvent")
                        local healdone = healingRemotes:FindFirstChild("Healdone")
                        local scEvent = healingRemotes:FindFirstChild("SkillCheckEvent")
                        local scFail = healingRemotes:FindFirstChild("SkillCheckFailEvent")
                        local scResult = healingRemotes:FindFirstChild("SkillCheckResultEvent")
                        local scValid = healingRemotes:FindFirstChild("Skillcheckvalidated")

                        if displayBlood and displayBlood:IsA("RemoteEvent") then displayBlood:FireServer(hrp) end
                        if healAnim and healAnim:IsA("RemoteEvent") then healAnim:FireServer(hrp, true) end
                        if healAnimRec and healAnimRec:IsA("RemoteEvent") then healAnimRec:FireServer(hrp, true) end

                        if scEvent and scEvent:IsA("RemoteEvent") then scEvent:FireServer() end
                        if scValid and scValid:IsA("RemoteEvent") then scValid:FireServer(true) end
                        if scResult and scResult:IsA("RemoteEvent") then scResult:FireServer("success", 1) end

                        if healEvent and healEvent:IsA("RemoteEvent") then healEvent:FireServer(hrp, true) end
                        if healdone and healdone:IsA("RemoteEvent") then healdone:FireServer(hrp) end

                        char:SetAttribute("IsDowned", false)
                        char:SetAttribute("NeedsHelp", false)
                        char:SetAttribute("IsHealing", false)
                        char:SetAttribute("HealingProgress", 100)
                        
                        hum.Health = hum.MaxHealth
                    end
                end
            end)
        end
    end
end)

-- CONFIGURATION SYSTEM
CheckTab:Section({ Title = "Configuration / UI Settings" })

local ConfigFolder = "HyunjinConfigs"
if not isfolder or not isfolder(ConfigFolder) then
    pcall(function() makefolder(ConfigFolder) end)
end

local inputConfigName = "default"
local selectedConfigDropdown = "default"

CheckTab:Input({
    Title = "Config Name",
    Default = "default",
    Placeholder = "Ketik nama config...",
    Callback = function(val)
        if val and val ~= "" then
            inputConfigName = val
        end
    end
})

local function getSavedConfigsList()
    local list = {}
    pcall(function()
        if listfiles and isfolder(ConfigFolder) then
            for _, file in ipairs(listfiles(ConfigFolder)) do
                local name = file:match("([^/]+)$"):gsub("%.json$", "")
                table.insert(list, name)
            end
        end
    end)
    if #list == 0 then table.insert(list, "default") end
    return list
end

local configDropdownElement
configDropdownElement = CheckTab:Dropdown({
    Title = "Select Config",
    Values = getSavedConfigsList(),
    Default = "default",
    Callback = function(v)
        if v then selectedConfigDropdown = v end
    end
})

local function SaveConfiguration()
    pcall(function()
        if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
        local fileName = (inputConfigName ~= "" and inputConfigName) or selectedConfigDropdown or "default"
        local filePath = ConfigFolder .. "/" .. fileName .. ".json"
        
        local configData = {
            WalkSpeed = Movement.WalkSpeedValue,
            JumpPower = Movement.JumpPowerValue,
            MaxDistance = Settings.maxDistance,
            KillerColor = {Settings.killerColor.R, Settings.killerColor.G, Settings.killerColor.B},
            SurvivorColor = {Settings.survivorColor.R, Settings.survivorColor.G, Settings.survivorColor.B},
        }
        if writefile then
            writefile(filePath, HttpService:JSONEncode(configData))
            WindUI:Notify({ Title = "Configuration", Content = "Berhasil menyimpan config: " .. fileName, Duration = 2 })
            
            if configDropdownElement and configDropdownElement.Refresh then
                configDropdownElement:Refresh(getSavedConfigsList(), true)
            end
        end
    end)
end

local function LoadConfiguration()
    pcall(function()
        local fileName = selectedConfigDropdown ~= "" and selectedConfigDropdown or inputConfigName or "default"
        local filePath = ConfigFolder .. "/" .. fileName .. ".json"
        
        if readfile and isfile and isfile(filePath) then
            local content = readfile(filePath)
            local data = HttpService:JSONDecode(content)
            if data then
                if data.WalkSpeed then Movement.WalkSpeedValue = data.WalkSpeed end
                if data.JumpPower then Movement.JumpPowerValue = data.JumpPower end
                if data.MaxDistance then Settings.maxDistance = data.MaxDistance end
                WindUI:Notify({ Title = "Configuration", Content = "Berhasil memuat config: " .. fileName, Duration = 2 })
            end
        else
            WindUI:Notify({ Title = "Configuration", Content = "File config '" .. fileName .. "' tidak ditemukan!", Duration = 2 })
        end
    end)
end

local function DeleteConfiguration()
    pcall(function()
        local fileName = selectedConfigDropdown ~= "" and selectedConfigDropdown or inputConfigName or "default"
        local filePath = ConfigFolder .. "/" .. fileName .. ".json"
        
        if delfile and isfile and isfile(filePath) then
            delfile(filePath)
            WindUI:Notify({ Title = "Configuration", Content = "Berhasil menghapus config: " .. fileName, Duration = 2 })
            
            if configDropdownElement and configDropdownElement.Refresh then
                configDropdownElement:Refresh(getSavedConfigsList(), true)
            end
        else
            WindUI:Notify({ Title = "Configuration", Content = "Config tidak dapat ditemukan untuk dihapus!", Duration = 2 })
        end
    end)
end

local function RefreshConfigList()
    pcall(function()
        if configDropdownElement and configDropdownElement.Refresh then
            configDropdownElement:Refresh(getSavedConfigsList(), true)
            WindUI:Notify({ Title = "Configuration", Content = "Daftar config diperbarui!", Duration = 2 })
        end
    end)
end

CheckTab:Button({ Title = "Save Config", Callback = SaveConfiguration })
CheckTab:Button({ Title = "Load Config", Callback = LoadConfiguration })
CheckTab:Button({ Title = "Delete Config", Callback = DeleteConfiguration })
CheckTab:Button({ Title = "Refresh List", Callback = RefreshConfigList })

CheckTab:Button({
    Title = "Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/2Z63NGm9Q")
        WindUI:Notify({ Title = "Discord", Content = "Link Discord telah dicopy ke clipboard!", Duration = 3 })
    end
})

CheckTab:Button({ Title = "Unload Script", Callback = function() Window:Destroy() end })

-- ==========================================
-- 8. ABOUT TAB
-- ==========================================
HvHTab:Section({ Title = "Script Info" })

HvHTab:Paragraph({
    Title = "Violence District - Freemium",
    Desc = "Version: 1.0.0\nGame: Violence District\nDeveloper: Noellandxyza",
    Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Player.UserId .. "&width=150&height=150&format=png",
    ImageSize = 36,
})

HvHTab:Button({
    Title = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/2Z63NGm9Q")
        WindUI:Notify({ Title = "Discord", Content = "Discord link copied!", Duration = 3 })
    end
})

HvHTab:Section({ Title = "Credits" })

HvHTab:Paragraph({
    Title = "Credits & Support",
    Desc = "Developer: • Hyunjin\nLibrary: WindUI Edition\nSupport the Dev via Sociabuzz",
    Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Player.UserId .. "&width=150&height=150&format=png",
    ImageSize = 36,
})

HvHTab:Button({
    Title = "Copy Support Link",
    Callback = function()
        setclipboard("https://sociabuzz.com/amill_al/tribe")
        WindUI:Notify({ Title = "Support", Content = "Thanks for the support!", Duration = 3 })
    end
})

-- ==========================================
-- BACKGROUND LIVE UPDATERS
-- ==========================================
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local infoFolder = PlayerGui:FindFirstChild("Spectator") and PlayerGui.Spectator:FindFirstChild("Info")
            local yourFolder = infoFolder and infoFolder:FindFirstChild("Your")

            local levelObj = yourFolder and yourFolder:FindFirstChild("Border") and yourFolder.Border:FindFirstChild("Level")
            if not levelObj then
                levelObj = PlayerGui:FindFirstChild("Results") and PlayerGui.Results:FindFirstChild("Frame") and PlayerGui.Results.Frame:FindFirstChild("level") and PlayerGui.Results.Frame.level:FindFirstChild("Border") and PlayerGui.Results.Frame.level.Border:FindFirstChild("Level")
            end
            if levelObj and levelObj:IsA("TextLabel") and levelObj.Text ~= "" and levelObj.Text ~= "1" then
                cachedLevel = levelObj.Text
            end

            local gearsObj = yourFolder and yourFolder:FindFirstChild("Gears")
            if gearsObj and (gearsObj:IsA("TextLabel") or gearsObj:IsA("TextBox")) and gearsObj.Text ~= "" then
                cachedGears = gearsObj.Text
            end

            local screwsObj = yourFolder and yourFolder:FindFirstChild("Screws")
            if screwsObj and (screwsObj:IsA("TextLabel") or screwsObj:IsA("TextBox")) and screwsObj.Text ~= "" then
                cachedScrews = screwsObj.Text
            end

            local kcObj = yourFolder and yourFolder:FindFirstChild("KillerChance")
            if kcObj and (kcObj:IsA("TextLabel") or kcObj:IsA("TextBox")) and kcObj.Text ~= "" then
                local cleanKC = kcObj.Text:gsub("%%", ""):gsub("%s+", "")
                cachedKC = cleanKC
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local teamName = (Player.Team and Player.Team.Name:lower()) or ""
            local isLobby = teamName:find("spectator") or teamName:find("lobby")

            local completedGens = 0
            for _, obj in ipairs(ESPState.cachedMapObjects.Generators) do
                if obj and obj.Parent then
                    local isDone = false
                    if obj:GetAttribute("Completed") == true or obj:GetAttribute("Repaired") == true then 
                        isDone = true
                    elseif obj:FindFirstChild("Completed") and obj.Completed.Value == true then 
                        isDone = true 
                    end
                    if isDone then completedGens = completedGens + 1 end
                end
            end
            completedGens = math.clamp(completedGens, 0, 7)
            currentGenStr = completedGens .. " / 7"

            if isLobby then
                local players = Players:GetPlayers()
                table.sort(players, function(a, b)
                    local aA = GetGameValue(a, "AllowKiller") or false
                    local bA = GetGameValue(b, "AllowKiller") or false
                    if aA ~= bA then return aA == true end
                    return (GetGameValue(a, "KillerChance") or 0) > (GetGameValue(b, "KillerChance") or 0)
                end)
                local nk = players[1]
                if nk then
                    local killerName = tostring(GetGameValue(nk, "SelectedKiller") or "Slasher")
                    local playerName = nk.Name
                    local lvlText = "39"
                    pcall(function()
                        local lb = PlayerGui.Spectator.Info.Leaderboard.Leaderboard
                        local pNode = lb:FindFirstChild(nk.Name)
                        if pNode and pNode:FindFirstChild("Border") and pNode.Border:FindFirstChild("Level") then
                            lvlText = pNode.Border.Level.Text
                        end
                    end)
                    currentKillerStr = string.format("%s | %s | %s", killerName, playerName, lvlText)
                else
                    currentKillerStr = "Mencari..."
                end
            else
                local foundKiller = false
                for _, plr in ipairs(Players:GetPlayers()) do
                    local isKiller = false
                    if plr.Team and (plr.Team.Name:lower():find("killer") or plr.Team.Name:lower():find("slayer")) then 
                        isKiller = true
                    elseif plr.Character and (plr.Character:FindFirstChild("Killer") or plr.Character:FindFirstChildOfClass("Tool")) then 
                        isKiller = true 
                    end

                    if isKiller then
                        foundKiller = true
                        local killerName = tostring(GetGameValue(plr, "SelectedKiller") or "Slasher")
                        local lvlText = "39"
                        pcall(function()
                            local lb = PlayerGui.Spectator.Info.Leaderboard.Leaderboard
                            local pNode = lb:FindFirstChild(plr.Name)
                            if pNode and pNode:FindFirstChild("Border") and pNode.Border:FindFirstChild("Level") then
                                lvlText = pNode.Border.Level.Text
                            end
                        end)
                        currentKillerStr = string.format("%s | %s | %s", killerName, plr.Name, lvlText)
                        break
                    end
                end
                if not foundKiller then currentKillerStr = "Belum Ditentukan" end
            end

            if isLobby then
                MatchStatusParagraph:SetTitle("Match Status | Lobby")
                MatchStatusParagraph:SetDesc(string.format("Next Map : %s\nNext Killer : %s\nGenerators : %s", currentMapStr, currentKillerStr, currentGenStr))
            else
                MatchStatusParagraph:SetTitle("Match Status | Round Start")
                MatchStatusParagraph:SetDesc(string.format("Map : %s\nKiller : %s\nGenerators : %s", currentMapStr, currentKillerStr, currentGenStr))
            end

            local playerDataForCards = {}

            pcall(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    local pName = p.Name
                    local pLvl = (p == Player and cachedLevel) or "1"
                    local pKC = (p == Player and cachedKC) or "0"
                    local roleStr = "SURVIVOR"

                    local team = p.Team and p.Team.Name:lower() or ""
                    if team:find("killer") or team:find("slayer") then
                        roleStr = "KILLER"
                    elseif team:find("spectator") or team:find("lobby") then
                        roleStr = "SPECTATOR"
                    end

                    pcall(function()
                        local lb = PlayerGui.Spectator.Info.Leaderboard.Leaderboard
                        local pNode = lb:FindFirstChild(pName)
                        if pNode then
                            local bLevel = pNode:FindFirstChild("Border") and pNode.Border:FindFirstChild("Level")
                            if bLevel and bLevel:IsA("TextLabel") and bLevel.Text ~= "" then
                                pLvl = bLevel.Text
                            end

                            local kcContainer = pNode:FindFirstChild("kc")
                            local kcVal = kcContainer and (kcContainer:FindFirstChild("kc") or kcContainer:FindFirstChildOfClass("TextLabel"))
                            if kcVal and kcVal:IsA("TextLabel") and kcVal.Text ~= "" then
                                pKC = kcVal.Text:gsub("%%", ""):gsub("%s+", "")
                            end
                        end
                    end)

                    table.insert(playerDataForCards, {
                        Player = p,
                        Name = pName,
                        Level = pLvl,
                        KC = pKC,
                        Role = roleStr
                    })
                end
            end)

            if #playerDataForCards == 0 then
                for _, p in ipairs(Players:GetPlayers()) do
                    local roleStr = "SURVIVOR"
                    local team = p.Team and p.Team.Name:lower() or ""
                    if team:find("killer") or team:find("slayer") then roleStr = "KILLER"
                    elseif team:find("spectator") or team:find("lobby") then roleStr = "SPECTATOR" end
                    table.insert(playerDataForCards, {
                        Player = p,
                        Name = p.Name,
                        Level = (p == Player and cachedLevel) or "1",
                        KC = (p == Player and cachedKC) or "0",
                        Role = roleStr
                    })
                end
            end

            pcall(function()
                UpdatePlayerCards(playerDataForCards)
            end)
        end)
    end
end)

pcall(function()
    local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
    if Remotes then
        local Messages = Remotes:WaitForChild("Messages", 5)
        if Messages then
            local MapInfoError = Messages:WaitForChild("Mapinfo", 5)
            if MapInfoError then
                MapInfoError.OnClientEvent:Connect(function(mapName)
                    if mapName and type(mapName) == "string" then
                        currentMapStr = string.upper(mapName)
                        local lowerName = mapName:lower()
                        for k, _ in pairs(MapCoords) do
                            if lowerName:find(k) then currentMapKey = k break end
                        end
                    end
                end)
            end
        end
    end
end)

WindUI:Notify({
    Title = "Hyunjin GUI Loaded",
    Content = "Optimized & Lag-Free 🚀",
    Duration = 3
})
