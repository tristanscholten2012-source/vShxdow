
--==============================================================
-- VSHXDOW V7 FINAL | ULTIMATE EDITION
-- Roblox Studio LocalScript
-- Plaats in StarterPlayer > StarterPlayerScripts
--==============================================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==============================================================
-- CONFIGURATION
--==============================================================

local VERSION = "V7 FINAL"

local Themes = {
    Color3.fromRGB(151, 83, 255),
    Color3.fromRGB(45, 145, 255),
    Color3.fromRGB(255, 72, 145),
    Color3.fromRGB(35, 205, 155),
    Color3.fromRGB(255, 160, 55)
}

local ThemeIndex = 1
local Accent = Themes[ThemeIndex]

local BG = Color3.fromRGB(13, 13, 20)
local PANEL = Color3.fromRGB(22, 22, 32)
local CARD = Color3.fromRGB(31, 31, 44)
local WHITE = Color3.fromRGB(245, 245, 250)
local GREY = Color3.fromRGB(155, 155, 175)

local Config = {
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 55,
    SprintBonus = 10,

    Sprint = false,
    Fly = false,
    Noclip = false,
    InfiniteJump = false,
    DoubleJump = false,

    ESP = false,
    Tracers = false,
    HealthInfo = true,
    DistanceInfo = true,

    FullBright = false,
    Night = false,

    Notifications = true,
    CustomCursor = true,
    MusicVolume = 0.5,
    Transparency = 0
}

local Character
local Humanoid
local Root

local FlyAttachment
local FlyVelocity
local FlyOrientation
local FlyHumanoid

local NoclipParts = {}
local ESPObjects = {}

local SessionStart = os.clock()
local CurrentPage = "Home"
local MenuOpen = true
local SelectedPlayer

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows
}

--==============================================================
-- UTILITIES
--==============================================================

local function round(value)
    return math.floor(value + 0.5)
end

local function getCharacter()
    Character = Player.Character

    if not Character then
        return
    end

    Humanoid = Character:FindFirstChildOfClass("Humanoid")
    Root = Character:FindFirstChild("HumanoidRootPart")

    return Character
end

local function tween(object, properties, duration)
    local animation = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.2,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    )

    animation:Play()
    return animation
end

local function updateMovement()
    getCharacter()

    if not Humanoid then
        return
    end

    Humanoid.UseJumpPower = true
    Humanoid.WalkSpeed = Config.WalkSpeed
        + (Config.Sprint and Config.SprintBonus or 0)

    Humanoid.JumpPower = Config.JumpPower
end

--==============================================================
-- GUI ROOT
--==============================================================

local OldGui = PlayerGui:FindFirstChild("VSHXDOW_V7")
if OldGui then
    OldGui:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "VSHXDOW_V7"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 100
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Scale = Instance.new("UIScale")
Scale.Parent = Gui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(760, 520)
Main.Position = UDim2.new(0.5, -380, 0.5, -260)
Main.BackgroundColor3 = BG
Main.BackgroundTransparency = Config.Transparency
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = Gui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Accent
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

local function updateScale()
    local viewport = workspace.CurrentCamera.ViewportSize
    local scaleX = viewport.X / 790
    local scaleY = viewport.Y / 550

    Scale.Scale = math.clamp(math.min(scaleX, scaleY), 0.48, 1)
end

updateScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

--==============================================================
-- LOGO / HEADER
--==============================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 62)
Header.BackgroundColor3 = PANEL
Header.BorderSizePixel = 0
Header.Parent = Main

local Logo = Instance.new("Frame")
Logo.Size = UDim2.fromOffset(39, 39)
Logo.Position = UDim2.fromOffset(14, 11)
Logo.BackgroundColor3 = Accent
Logo.BorderSizePixel = 0
Logo.Parent = Header

Instance.new("UICorner", Logo).CornerRadius = UDim.new(0, 10)

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.fromScale(1, 1)
LogoText.BackgroundTransparency = 1
LogoText.Text = "V"
LogoText.TextColor3 = WHITE
LogoText.Font = Enum.Font.GothamBlack
LogoText.TextSize = 25
LogoText.Parent = Logo

local Title = Instance.new("TextLabel")
Title.Size = UDim2.fromOffset(260, 32)
Title.Position = UDim2.fromOffset(62, 8)
Title.BackgroundTransparency = 1
Title.Text = "VSHXDOW"
Title.TextColor3 = WHITE
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.fromOffset(260, 20)
Subtitle.Position = UDim2.fromOffset(63, 34)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "ULTIMATE CONTROL CENTER"
Subtitle.TextColor3 = GREY
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 9
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.fromOffset(90, 30)
Version.Position = UDim2.new(1, -175, 0, 16)
Version.BackgroundTransparency = 1
Version.Text = VERSION
Version.TextColor3 = Accent
Version.Font = Enum.Font.GothamBold
Version.TextSize = 12
Version.Parent = Header

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(32, 30)
Minimize.Position = UDim2.new(1, -75, 0, 16)
Minimize.BackgroundColor3 = CARD
Minimize.Text = "—"
Minimize.TextColor3 = WHITE
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 16
Minimize.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(32, 30)
Close.Position = UDim2.new(1, -37, 0, 16)
Close.BackgroundColor3 = Color3.fromRGB(125, 42, 58)
Close.Text = "X"
Close.TextColor3 = WHITE
Close.Font = Enum.Font.GothamBold
Close.TextSize = 13
Close.Parent = Header

for _, object in ipairs({Minimize, Close}) do
    Instance.new("UICorner", object).CornerRadius = UDim.new(0, 7)
end

local Reopen = Instance.new("TextButton")
Reopen.Size = UDim2.fromOffset(145, 42)
Reopen.Position = UDim2.new(0, 15, 0.5, 0)
Reopen.BackgroundColor3 = PANEL
Reopen.Text = "VSHXDOW  V7"
Reopen.TextColor3 = Accent
Reopen.Font = Enum.Font.GothamBold
Reopen.TextSize = 14
Reopen.Visible = false
Reopen.Parent = Gui

Instance.new("UICorner", Reopen).CornerRadius = UDim.new(0, 9)

local function setMenuVisible(value)
    MenuOpen = value

    if value then
        Main.Visible = true
        Reopen.Visible = false
        Main.Size = UDim2.fromOffset(720, 490)

        tween(Main, {
            Size = UDim2.fromOffset(760, 520)
        }, 0.22)
    else
        tween(Main, {
            Size = UDim2.fromOffset(720, 490)
        }, 0.16)

        task.delay(0.16, function()
            if not MenuOpen then
                Main.Visible = false
                Reopen.Visible = true
            end
        end)
    end
end

Minimize.MouseButton1Click:Connect(function()
    setMenuVisible(false)
end)

Close.MouseButton1Click:Connect(function()
    setMenuVisible(false)
end)

Reopen.MouseButton1Click:Connect(function()
    setMenuVisible(true)
end)

--==============================================================
-- DRAGGING
--==============================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--==============================================================
-- NOTIFICATIONS
--==============================================================

local function notify(title, message)
    if not Config.Notifications then
        return
    end

    local toast = Instance.new("Frame")
    toast.Size = UDim2.fromOffset(280, 72)
    toast.Position = UDim2.new(1, 300, 0, 20)
    toast.BackgroundColor3 = PANEL
    toast.BorderSizePixel = 0
    toast.ZIndex = 150
    toast.Parent = Gui

    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 9)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Accent
    stroke.Thickness = 1.5
    stroke.Parent = toast

    local heading = Instance.new("TextLabel")
    heading.Size = UDim2.new(1, -20, 0, 25)
    heading.Position = UDim2.fromOffset(10, 7)
    heading.BackgroundTransparency = 1
    heading.Text = title
    heading.TextColor3 = Accent
    heading.Font = Enum.Font.GothamBold
    heading.TextSize = 14
    heading.TextXAlignment = Enum.TextXAlignment.Left
    heading.ZIndex = 151
    heading.Parent = toast

    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, -20, 0, 30)
    body.Position = UDim2.fromOffset(10, 34)
    body.BackgroundTransparency = 1
    body.Text = message
    body.TextColor3 = WHITE
    body.Font = Enum.Font.Gotham
    body.TextSize = 12
    body.TextWrapped = true
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.ZIndex = 151
    body.Parent = toast

    tween(toast, {
        Position = UDim2.new(1, -295, 0, 20)
    }, 0.3)

    task.delay(3, function()
        if toast.Parent then
            tween(toast, {
                Position = UDim2.new(1, 300, 0, 20)
            }, 0.25)

            task.wait(0.3)
            toast:Destroy()
        end
    end)
end

--==============================================================
-- SIDEBAR AND CONTENT
--==============================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(165, 440)
Sidebar.Position = UDim2.fromOffset(10, 70)
Sidebar.BackgroundColor3 = PANEL
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 7)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)
SidebarPadding.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.fromOffset(565, 440)
Content.Position = UDim2.fromOffset(185, 70)
Content.BackgroundColor3 = PANEL
Content.BorderSizePixel = 0
Content.ClipsDescendants = true
Content.Parent = Main

Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 10)

local PageTitle = Instance.new("TextLabel")
PageTitle.Size = UDim2.new(1, -30, 0, 35)
PageTitle.Position = UDim2.fromOffset(15, 8)
PageTitle.BackgroundTransparency = 1
PageTitle.TextColor3 = WHITE
PageTitle.TextSize = 21
PageTitle.Font = Enum.Font.GothamBold
PageTitle.TextXAlignment = Enum.TextXAlignment.Left
PageTitle.Parent = Content

local PageDescription = Instance.new("TextLabel")
PageDescription.Size = UDim2.new(1, -30, 0, 25)
PageDescription.Position = UDim2.fromOffset(15, 42)
PageDescription.BackgroundTransparency = 1
PageDescription.TextColor3 = GREY
PageDescription.TextSize = 12
PageDescription.Font = Enum.Font.Gotham
PageDescription.TextXAlignment = Enum.TextXAlignment.Left
PageDescription.Parent = Content

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -80)
Scroll.Position = UDim2.fromOffset(10, 72)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Accent
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.CanvasSize = UDim2.new()
Scroll.Parent = Content

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

local Padding = Instance.new("UIPadding")
Padding.PaddingBottom = UDim.new(0, 12)
Padding.PaddingLeft = UDim.new(0, 5)
Padding.PaddingRight = UDim.new(0, 5)
Padding.Parent = Scroll

local PageConnections = {}

local function clearPage()
    for _, connection in ipairs(PageConnections) do
        connection:Disconnect()
    end

    table.clear(PageConnections)

    for _, child in ipairs(Scroll:GetChildren()) do
        if child ~= Layout and child ~= Padding then
            child:Destroy()
        end
    end
end

local function setPage(name, description)
    CurrentPage = name
    clearPage()
    PageTitle.Text = name
    PageDescription.Text = description
end

local function label(text, height)
    local object = Instance.new("TextLabel")
    object.Size = UDim2.new(1, -8, 0, height or 28)
    object.BackgroundTransparency = 1
    object.Text = text
    object.TextColor3 = WHITE
    object.TextSize = 13
    object.Font = Enum.Font.Gotham
    object.TextXAlignment = Enum.TextXAlignment.Left
    object.TextWrapped = true
    object.Parent = Scroll
    return object
end

local function button(text, callback)
    local object = Instance.new("TextButton")
    object.Size = UDim2.new(1, -8, 0, 40)
    object.BackgroundColor3 = CARD
    object.Text = text
    object.TextColor3 = WHITE
    object.TextSize = 13
    object.Font = Enum.Font.GothamMedium
    object.AutoButtonColor = false
    object.Parent = Scroll

    Instance.new("UICorner", object).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Accent
    stroke.Transparency = 0.78
    stroke.Parent = object

    object.MouseEnter:Connect(function()
        tween(object, {BackgroundColor3 = Accent}, 0.12)
    end)

    object.MouseLeave:Connect(function()
        tween(object, {BackgroundColor3 = CARD}, 0.12)
    end)

    object.MouseButton1Click:Connect(callback)
    return object
end

local function textBox(placeholder, initial)
    local object = Instance.new("TextBox")
    object.Size = UDim2.new(1, -8, 0, 40)
    object.BackgroundColor3 = BG
    object.Text = initial or ""
    object.PlaceholderText = placeholder
    object.PlaceholderColor3 = GREY
    object.TextColor3 = WHITE
    object.TextSize = 13
    object.Font = Enum.Font.Gotham
    object.ClearTextOnFocus = false
    object.Parent = Scroll

    Instance.new("UICorner", object).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Accent
    stroke.Transparency = 0.7
    stroke.Parent = object

    return object
end

local function slider(name, minValue, maxValue, initial, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -8, 0, 66)
    container.BackgroundColor3 = CARD
    container.BorderSizePixel = 0
    container.Parent = Scroll

    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

    local heading = Instance.new("TextLabel")
    heading.Size = UDim2.new(1, -100, 0, 26)
    heading.Position = UDim2.fromOffset(10, 4)
    heading.BackgroundTransparency = 1
    heading.Text = name
    heading.TextColor3 = WHITE
    heading.Font = Enum.Font.GothamBold
    heading.TextSize = 12
    heading.TextXAlignment = Enum.TextXAlignment.Left
    heading.Parent = container

    local valueText = Instance.new("TextLabel")
    valueText.Size = UDim2.fromOffset(75, 26)
    valueText.Position = UDim2.new(1, -85, 0, 4)
    valueText.BackgroundTransparency = 1
    valueText.Text = tostring(initial)
    valueText.TextColor3 = Accent
    valueText.Font = Enum.Font.GothamBold
    valueText.TextSize = 12
    valueText.Parent = container

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -24, 0, 8)
    bar.Position = UDim2.fromOffset(12, 44)
    bar.BackgroundColor3 = BG
    bar.BorderSizePixel = 0
    bar.Parent = container

    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Accent
    fill.BorderSizePixel = 0
    fill.Parent = bar

    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.BackgroundColor3 = WHITE
    knob.BorderSizePixel = 0
    knob.Parent = bar

    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 0, 0, 28)
    hitbox.Position = UDim2.fromOffset(0, -10)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.Parent = bar

    local current = initial
    local draggingSlider = false

    local function update(x)
        local percent = math.clamp(
            (x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1),
            0,
            1
        )

        current = round(minValue + (maxValue - minValue) * percent)

        local normalized = (current - minValue) / (maxValue - minValue)
        fill.Size = UDim2.fromScale(normalized, 1)
        knob.Position = UDim2.fromScale(normalized, 0.5)
        valueText.Text = tostring(current)

        callback(current)
    end

    local initialPercent = (initial - minValue) / (maxValue - minValue)
    fill.Size = UDim2.fromScale(initialPercent, 1)
    knob.Position = UDim2.fromScale(initialPercent, 0.5)

    table.insert(PageConnections, hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            draggingSlider = true
            update(input.Position.X)
        end
    end))

    table.insert(PageConnections, UIS.InputChanged:Connect(function(input)
        if draggingSlider and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            update(input.Position.X)
        end
    end))

    table.insert(PageConnections, UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end))
end

--==============================================================
-- MOVEMENT ENGINE
--==============================================================

local function stopFly()
    Config.Fly = false

    if FlyVelocity then
        FlyVelocity:Destroy()
        FlyVelocity = nil
    end

    if FlyOrientation then
        FlyOrientation:Destroy()
        FlyOrientation = nil
    end

    if FlyAttachment then
        FlyAttachment:Destroy()
        FlyAttachment = nil
    end

    if FlyHumanoid and FlyHumanoid.Parent then
        FlyHumanoid.PlatformStand = false
        FlyHumanoid.AutoRotate = true
        FlyHumanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end

    FlyHumanoid = nil
end

local function startFly()
    getCharacter()

    if not Root or not Humanoid then
        notify("Fly", "Character is not ready.")
        return
    end

    stopFly()
    getCharacter()

    if not Root or not Humanoid then
        return
    end

    Config.Fly = true
    FlyHumanoid = Humanoid

    Humanoid.AutoRotate = false
    Humanoid.PlatformStand = true

    FlyAttachment = Instance.new("Attachment")
    FlyAttachment.Name = "VSHXDOW_FlyAttachment"
    FlyAttachment.Parent = Root

    FlyVelocity = Instance.new("LinearVelocity")
    FlyVelocity.Attachment0 = FlyAttachment
    FlyVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    FlyVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    FlyVelocity.ForceLimitsEnabled = false
    FlyVelocity.VectorVelocity = Vector3.zero
    FlyVelocity.Parent = Root

    FlyOrientation = Instance.new("AlignOrientation")
    FlyOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    FlyOrientation.Attachment0 = FlyAttachment
    FlyOrientation.Responsiveness = 20
    FlyOrientation.MaxTorque = 1000000
    FlyOrientation.CFrame = Root.CFrame
    FlyOrientation.Parent = Root

    notify("Fly", "Fly enabled.")
end

local function restoreNoclip()
    for part, original in pairs(NoclipParts) do
        if part and part.Parent then
            part.CanCollide = original
        end
    end

    table.clear(NoclipParts)
end

local function teleportTo(target)
    if not target or target == Player then
        notify("Teleport", "Choose another player.")
        return
    end

    getCharacter()

    local targetCharacter = target.Character
    local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")

    if not Root or not targetRoot then
        notify("Teleport", "Character not ready.")
        return
    end

    Root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -4)
    notify("Teleport", "Teleported near " .. target.Name)
end

--==============================================================
-- ESP
--==============================================================

local function removeESP()
    for target, objects in pairs(ESPObjects) do
        for _, object in ipairs(objects) do
            if object and object.Parent then
                object:Destroy()
            end
        end

        ESPObjects[target] = nil
    end
end

local function teamColor(target)
    if target.Team then
        return target.TeamColor.Color
    end

    return Accent
end

local function addESP(target)
    if target == Player or ESPObjects[target] then
        return
    end

    local character = target.Character
    if not character then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "VSHXDOW_ESP"
    highlight.Adornee = character
    highlight.FillColor = teamColor(target)
    highlight.OutlineColor = WHITE
    highlight.FillTransparency = 0.65
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = Gui

    local head = character:FindFirstChild("Head")
    local billboard
    local info

    if head then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "VSHXDOW_PlayerInfo"
        billboard.Size = UDim2.fromOffset(170, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Adornee = head
        billboard.Parent = Gui

        info = Instance.new("TextLabel")
        info.Size = UDim2.fromScale(1, 1)
        info.BackgroundTransparency = 1
        info.TextColor3 = WHITE
        info.TextStrokeTransparency = 0.2
        info.Font = Enum.Font.GothamBold
        info.TextSize = 12
        info.TextWrapped = true
        info.Parent = billboard
    end

    ESPObjects[target] = {highlight, billboard, info}
end

local function refreshESP()
    removeESP()

    if not Config.ESP then
        return
    end

    for _, target in ipairs(Players:GetPlayers()) do
        addESP(target)
    end
end

--==============================================================
-- LIGHTING
--==============================================================

local function updateLighting()
    if Config.FullBright then
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    else
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
    end

    if Config.Night then
        Lighting.ClockTime = 0
    else
        Lighting.ClockTime = OriginalLighting.ClockTime
    end
end

--==============================================================
-- MUSIC PLAYER
--==============================================================

local Music = Instance.new("Sound")
Music.Name = "VSHXDOW_Music"
Music.Volume = Config.MusicVolume
Music.Looped = true
Music.Parent = Gui

local function playMusic(rawId)
    local id = tostring(rawId):match("%d+")

    if not id then
        notify("Music", "Enter a valid audio ID.")
        return
    end

    Music:Stop()
    Music.SoundId = "rbxassetid://" .. id
    Music.Volume = Config.MusicVolume
    Music:Play()

    notify("Music", "Playback requested.")
end

--==============================================================
-- DASHBOARD DATA
--==============================================================

local function getPing()
    local success, result = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)

    if success and type(result) == "number" then
        return round(result)
    end

    return 0
end

--==============================================================
-- CONFIG SYSTEM
--==============================================================

local function makeConfigExport()
    local data = {
        WalkSpeed = Config.WalkSpeed,
        JumpPower = Config.JumpPower,
        FlySpeed = Config.FlySpeed,
        SprintBonus = Config.SprintBonus,
        ThemeIndex = ThemeIndex,
        MusicVolume = Config.MusicVolume,
        Transparency = Config.Transparency,
        HealthInfo = Config.HealthInfo,
        DistanceInfo = Config.DistanceInfo,
        Notifications = Config.Notifications,
        CustomCursor = Config.CustomCursor
    }

    return HttpService:JSONEncode(data)
end

local function applyConfig(data)
    if type(data) ~= "table" then
        notify("Config", "Invalid configuration.")
        return
    end

    Config.WalkSpeed = math.clamp(tonumber(data.WalkSpeed) or 16, 0, 150)
    Config.JumpPower = math.clamp(tonumber(data.JumpPower) or 50, 0, 250)
    Config.FlySpeed = math.clamp(tonumber(data.FlySpeed) or 55, 10, 150)
    Config.SprintBonus = math.clamp(tonumber(data.SprintBonus) or 10, 0, 50)
    Config.MusicVolume = math.clamp(tonumber(data.MusicVolume) or 0.5, 0, 1)
    Config.Transparency = math.clamp(tonumber(data.Transparency) or 0, 0, 0.7)

    ThemeIndex = math.clamp(round(tonumber(data.ThemeIndex) or 1), 1, #Themes)
    Accent = Themes[ThemeIndex]

    if type(data.HealthInfo) == "boolean" then
        Config.HealthInfo = data.HealthInfo
    end

    if type(data.DistanceInfo) == "boolean" then
        Config.DistanceInfo = data.DistanceInfo
    end

    if type(data.Notifications) == "boolean" then
        Config.Notifications = data.Notifications
    end

    if type(data.CustomCursor) == "boolean" then
        Config.CustomCursor = data.CustomCursor
    end

    Main.BackgroundTransparency = Config.Transparency
    MainStroke.Color = Accent
    Version.TextColor3 = Accent
    Logo.BackgroundColor3 = Accent
    Reopen.TextColor3 = Accent
    updateMovement()
    updateLighting()
    refreshESP()

    notify("Config", "Configuration imported.")
end

-- Session presets: these are kept while this LocalScript is running.
local Presets = {}

--==============================================================
-- COMMAND CENTER
--==============================================================

local PageFunctions = {}

local function runCommand(raw)
    local command = tostring(raw):lower():gsub("^%s+", ""):gsub("%s+$", "")

    local commands = {
        fly = function()
            if Config.Fly then
                stopFly()
            else
                startFly()
            end
        end,

        sprint = function()
            Config.Sprint = not Config.Sprint
            updateMovement()
            notify("Sprint", Config.Sprint and "Enabled" or "Disabled")
        end,

        esp = function()
            Config.ESP = not Config.ESP
            refreshESP()
            notify("ESP", Config.ESP and "Enabled" or "Disabled")
        end,

        noclip = function()
            Config.Noclip = not Config.Noclip
            if not Config.Noclip then
                restoreNoclip()
            end
            notify("Noclip", Config.Noclip and "Enabled" or "Disabled")
        end,

        day = function()
            Config.Night = false
            updateLighting()
            notify("Lighting", "Day mode")
        end,

        night = function()
            Config.Night = true
            updateLighting()
            notify("Lighting", "Night mode")
        end,

        fullbright = function()
            Config.FullBright = not Config.FullBright
            updateLighting()
            notify("Lighting", "Full Bright toggled")
        end,

        reset = function()
            Config.WalkSpeed = 16
            Config.JumpPower = 50
            Config.FlySpeed = 55
            Config.Sprint = false
            stopFly()
            Config.Noclip = false
            restoreNoclip()
            updateMovement()
            notify("Movement", "Reset complete")
        end,

        menu = function()
            setMenuVisible(not MenuOpen)
        end,

        home = function()
            PageFunctions.Home()
        end,

        movement = function()
            PageFunctions.Movement()
        end,

        dashboard = function()
            PageFunctions.Dashboard()
        end,

        stopmusic = function()
            Music:Stop()
            notify("Music", "Stopped")
        end
    }

    if commands[command] then
        commands[command]()
        return true
    end

    notify("Command Center", "Unknown command: " .. command)
    return false
end

--==============================================================
-- PAGE: HOME
--==============================================================

PageFunctions.Home = function()
    setPage("Welcome to VSHXDOW", "Ultimate Edition | " .. VERSION)

    label("Welcome back, " .. Player.DisplayName .. "!", 35)
    label("Your personal Roblox control center.", 28)
    label("Username: " .. Player.Name)
    label("User ID: " .. Player.UserId)
    label("Players in server: " .. #Players:GetPlayers())
    label("Session started: " .. os.date("%H:%M:%S"), 28)

    button("Open Movement Pro", function()
        PageFunctions.Movement()
    end)

    button("Open Advanced ESP", function()
        PageFunctions.ESP()
    end)

    button("Open Performance Monitor", function()
        PageFunctions.Dashboard()
    end)

    button("Open Command Center", function()
        PageFunctions.Commands()
    end)
end

--==============================================================
-- PAGE: MOVEMENT
--==============================================================

PageFunctions.Movement = function()
    setPage("Movement Pro", "Character movement controls")

    slider("WalkSpeed", 0, 150, Config.WalkSpeed, function(value)
        Config.WalkSpeed = value
        updateMovement()
    end)

    slider("JumpPower", 0, 250, Config.JumpPower, function(value)
        Config.JumpPower = value
        updateMovement()
    end)

    slider("Fly Speed", 10, 150, Config.FlySpeed, function(value)
        Config.FlySpeed = value
    end)

    button("Toggle Sprint", function()
        Config.Sprint = not Config.Sprint
        updateMovement()
        notify("Sprint", Config.Sprint and "Enabled" or "Disabled")
    end)

    button("Toggle Fly [F]", function()
        if Config.Fly then
            stopFly()
            notify("Fly", "Disabled")
        else
            startFly()
        end
    end)

    button("Toggle Noclip", function()
        Config.Noclip = not Config.Noclip
        if not Config.Noclip then
            restoreNoclip()
        end
        notify("Noclip", Config.Noclip and "Enabled" or "Disabled")
    end)

    button("Toggle Infinite Jump", function()
        Config.InfiniteJump = not Config.InfiniteJump
        notify("Infinite Jump", Config.InfiniteJump and "Enabled" or "Disabled")
    end)

    button("Toggle Double Jump", function()
        Config.DoubleJump = not Config.DoubleJump
        notify("Double Jump", Config.DoubleJump and "Enabled" or "Disabled")
    end)

    button("Super Jump", function()
        getCharacter()
        if Root then
            Root.AssemblyLinearVelocity = Vector3.new(
                Root.AssemblyLinearVelocity.X,
                90,
                Root.AssemblyLinearVelocity.Z
            )
            notify("Super Jump", "Activated")
        end
    end)

    button("Reset Movement", function()
        Config.WalkSpeed = 16
        Config.JumpPower = 50
        Config.FlySpeed = 55
        Config.Sprint = false
        stopFly()
        Config.Noclip = false
        restoreNoclip()
        updateMovement()
        notify("Movement", "Defaults restored")
        PageFunctions.Movement()
    end)
end

--==============================================================
-- PAGE: ESP
--==============================================================

PageFunctions.ESP = function()
    setPage("Advanced ESP", "Player highlights and information")

    button("Toggle ESP", function()
        Config.ESP = not Config.ESP
        refreshESP()
        notify("ESP", Config.ESP and "Enabled" or "Disabled")
    end)

    button("Toggle Tracers", function()
        Config.Tracers = not Config.Tracers
        notify("Tracers", Config.Tracers and "Enabled" or "Disabled")
    end)

    button("Toggle Health Information", function()
        Config.HealthInfo = not Config.HealthInfo
        notify("ESP", "Health information updated")
    end)

    button("Toggle Distance Information", function()
        Config.DistanceInfo = not Config.DistanceInfo
        notify("ESP", "Distance information updated")
    end)

    button("Refresh ESP", function()
        refreshESP()
        notify("ESP", "Refreshed")
    end)

    label("ESP is visible only to your local client.", 40)
end

--==============================================================
-- PAGE: PLAYERS / TELEPORT
--==============================================================

PageFunctions.Players = function()
    setPage("Player Teleport", "Choose a player in your own experience")

    label("Teleport moves your character near the selected player.", 40)

    local targets = Players:GetPlayers()

    table.sort(targets, function(a, b)
        return a.Name:lower() < b.Name:lower()
    end)

    for _, target in ipairs(targets) do
        if target ~= Player then
            button(target.DisplayName .. "  @" .. target.Name, function()
                SelectedPlayer = target
                teleportTo(target)
            end)
        end
    end

    button("Refresh Player List", function()
        PageFunctions.Players()
    end)
end

--==============================================================
-- PAGE: PERFORMANCE MONITOR
--==============================================================

PageFunctions.Dashboard = function()
    setPage("Performance Monitor", "Live client and player statistics")

    local fpsLabel = label("FPS: --")
    local pingLabel = label("Ping: --")
    local speedLabel = label("WalkSpeed: --")
    local healthLabel = label("Health: --")
    local playersLabel = label("Players: --")
    local sessionLabel = label("Session: --")

    local graph = Instance.new("Frame")
    graph.Size = UDim2.new(1, -8, 0, 95)
    graph.BackgroundColor3 = BG
    graph.BorderSizePixel = 0
    graph.Parent = Scroll

    Instance.new("UICorner", graph).CornerRadius = UDim.new(0, 8)

    local graphTitle = Instance.new("TextLabel")
    graphTitle.Size = UDim2.new(1, -16, 0, 20)
    graphTitle.Position = UDim2.fromOffset(8, 5)
    graphTitle.BackgroundTransparency = 1
    graphTitle.Text = "FPS HISTORY"
    graphTitle.TextColor3 = GREY
    graphTitle.Font = Enum.Font.GothamBold
    graphTitle.TextSize = 10
    graphTitle.TextXAlignment = Enum.TextXAlignment.Left
    graphTitle.Parent = graph

    local bars = {}

    for i = 1, 35 do
        local bar = Instance.new("Frame")
        bar.Size = UDim2.fromOffset(8, 5)
        bar.Position = UDim2.fromOffset(10 + (i - 1) * 14, 78)
        bar.AnchorPoint = Vector2.new(0, 1)
        bar.BackgroundColor3 = Accent
        bar.BorderSizePixel = 0
        bar.Parent = graph

        Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)
        bars[i] = bar
    end

    local elapsed = 0
    local history = {}

    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        if CurrentPage ~= "Performance Monitor" then
            return
        end

        elapsed += dt

        if elapsed < 0.5 then
            return
        end

        elapsed = 0

        local fps = round(1 / math.max(dt, 0.001))
        table.insert(history, fps)

        if #history > 35 then
            table.remove(history, 1)
        end

        fpsLabel.Text = "FPS: " .. fps
        pingLabel.Text = "Ping: " .. getPing() .. " ms"

        getCharacter()

        speedLabel.Text = "WalkSpeed: " ..
            (Humanoid and round(Humanoid.WalkSpeed) or "--")

        healthLabel.Text = "Health: " ..
            (Humanoid and (round(Humanoid.Health) .. "/" .. round(Humanoid.MaxHealth)) or "--")

        playersLabel.Text = "Players: " .. #Players:GetPlayers()
        sessionLabel.Text = "Session: " .. round(os.clock() - SessionStart) .. " seconds"

        for i, bar in ipairs(bars) do
            local value = history[i] or 0
            local height = math.clamp(value / 120, 0.05, 1) * 55

            bar.Size = UDim2.fromOffset(8, height)
            bar.BackgroundColor3 = value < 25
                and Color3.fromRGB(255, 80, 80)
                or Accent
        end
    end)

    table.insert(PageConnections, connection)
end

--==============================================================
-- PAGE: MUSIC
--==============================================================

PageFunctions.Music = function()
    setPage("Music Player", "Play audio assets available to your experience")

    label("Enter an audio asset ID.", 25)

    local audioBox = textBox("Example: 1234567890")

    slider("Volume", 0, 100, round(Config.MusicVolume * 100), function(value)
        Config.MusicVolume = value / 100
        Music.Volume = Config.MusicVolume
    end)

    button("Play Music", function()
        local id = tostring(audioBox.Text):match("%d+")

        if not id then
            notify("Music", "Invalid audio ID")
            return
        end

        playMusic(id)
    end)

    button("Pause / Resume", function()
        if Music.IsPlaying then
            Music:Pause()
        elseif Music.SoundId ~= "" then
            Music:Resume()
        end
    end)

    button("Stop Music", function()
        Music:Stop()
        notify("Music", "Stopped")
    end)

    label("Audio permissions are controlled by Roblox.", 35)
end

--==============================================================
-- PAGE: COMMAND CENTER
--==============================================================

PageFunctions.Commands = function()
    setPage("Command Center", "Type a command and press Execute")

    local commandBox = textBox("Enter command...")

    button("Execute Command", function()
        runCommand(commandBox.Text)
    end)

    label("AVAILABLE COMMANDS", 25)

    for _, command in ipairs({
        "fly",
        "sprint",
        "esp",
        "noclip",
        "day",
        "night",
        "fullbright",
        "reset",
        "menu",
        "home",
        "movement",
        "dashboard",
        "stopmusic"
    }) do
        button("/" .. command, function()
            runCommand(command)
        end)
    end
end

--==============================================================
-- PAGE: SETTINGS / CONFIG
--==============================================================

PageFunctions.Settings = function()
    setPage("Settings & Config", "Customize and manage your session")

    button("Change Theme Color", function()
        ThemeIndex = ThemeIndex % #Themes + 1
        Accent = Themes[ThemeIndex]

        MainStroke.Color = Accent
        Version.TextColor3 = Accent
        Logo.BackgroundColor3 = Accent
        Reopen.TextColor3 = Accent
        Scroll.ScrollBarImageColor3 = Accent

        refreshESP()
        notify("Theme", "Theme changed")
        PageFunctions.Settings()
    end)

    slider("GUI Transparency", 0, 70, round(Config.Transparency * 100), function(value)
        Config.Transparency = value / 100
        Main.BackgroundTransparency = Config.Transparency
    end)

    button("Toggle Notifications", function()
        Config.Notifications = not Config.Notifications
        notify("Notifications", Config.Notifications and "Enabled" or "Disabled")
    end)

    button("Toggle Custom Cursor", function()
        Config.CustomCursor = not Config.CustomCursor
        notify("Cursor", Config.CustomCursor and "Enabled" or "Disabled")
    end)

    button("Save Session Preset", function()
        Presets.Default = makeConfigExport()
        notify("Config", "Preset saved for this session")
    end)

    button("Load Session Preset", function()
        if not Presets.Default then
            notify("Config", "No preset saved yet")
            return
        end

        local success, data = pcall(function()
            return HttpService:JSONDecode(Presets.Default)
        end)

        if success then
            applyConfig(data)
            PageFunctions.Settings()
        else
            notify("Config", "Could not load preset")
        end
    end)

    label("CONFIG EXPORT JSON", 25)

    local exportBox = textBox("Exported configuration")
    exportBox.Text = makeConfigExport()

    button("Refresh Export Text", function()
        exportBox.Text = makeConfigExport()
        notify("Config", "Export refreshed")
    end)

    label("Paste JSON into the box below to import.", 28)

    local importBox = textBox("Paste configuration JSON here")

    button("Import Configuration", function()
        local success, data = pcall(function()
            return HttpService:JSONDecode(importBox.Text)
        end)

        if not success then
            notify("Config", "Invalid JSON")
            return
        end

        applyConfig(data)
        PageFunctions.Settings()
    end)

    button("Reset All Settings", function()
        Config.WalkSpeed = 16
        Config.JumpPower = 50
        Config.FlySpeed = 55
        Config.Sprint = false
        Config.Fly = false
        Config.Noclip = false
        Config.ESP = false
        Config.Tracers = false
        Config.FullBright = false
        Config.Night = false
        Config.Transparency = 0

        stopFly()
        restoreNoclip()
        removeESP()
        updateMovement()
        updateLighting()

        Main.BackgroundTransparency = 0
        notify("Settings", "Defaults restored")
        PageFunctions.Settings()
    end)

    label("Presets last only while this LocalScript is running. Export JSON to keep a copy.", 45)
end

--==============================================================
-- NAVIGATION
--==============================================================

local Navigation = {
    {"Home", "Home"},
    {"Movement", "Movement"},
    {"Advanced ESP", "ESP"},
    {"Players", "Players"},
    {"Dashboard", "Dashboard"},
    {"Music Player", "Music"},
    {"Command Center", "Commands"},
    {"Settings", "Settings"}
}

for index, item in ipairs(Navigation) do
    local navButton = Instance.new("TextButton")
    navButton.Size = UDim2.new(1, 0, 0, 42)
    navButton.BackgroundColor3 = CARD
    navButton.Text = "   " .. item[1]
    navButton.TextColor3 = WHITE
    navButton.TextSize = 12
    navButton.Font = Enum.Font.GothamMedium
    navButton.TextXAlignment = Enum.TextXAlignment.Left
    navButton.AutoButtonColor = false
    navButton.LayoutOrder = index
    navButton.Parent = Sidebar

    Instance.new("UICorner", navButton).CornerRadius = UDim.new(0, 7)

    navButton.MouseButton1Click:Connect(function()
        local page = PageFunctions[item[2]]
        if page then
            page()
        end
    end)

    navButton.MouseEnter:Connect(function()
        tween(navButton, {BackgroundColor3 = Accent}, 0.12)
    end)

    navButton.MouseLeave:Connect(function()
        tween(navButton, {BackgroundColor3 = CARD}, 0.12)
    end)
end

--==============================================================
-- MOBILE BUTTONS
--==============================================================

local MobileControls = Instance.new("Frame")
MobileControls.Name = "MobileControls"
MobileControls.Size = UDim2.fromOffset(155, 110)
MobileControls.Position = UDim2.new(1, -170, 1, -130)
MobileControls.BackgroundTransparency = 1
MobileControls.Visible = UIS.TouchEnabled
MobileControls.Parent = Gui

local function mobileButton(text, x, y, callback)
    local object = Instance.new("TextButton")
    object.Size = UDim2.fromOffset(65, 42)
    object.Position = UDim2.fromOffset(x, y)
    object.BackgroundColor3 = PANEL
    object.Text = text
    object.TextColor3 = WHITE
    object.TextSize = 12
    object.Font = Enum.Font.GothamBold
    object.Parent = MobileControls

    Instance.new("UICorner", object).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Accent
    stroke.Parent = object

    object.Activated:Connect(callback)
    return object
end

mobileButton("MENU", 0, 0, function()
    setMenuVisible(not MenuOpen)
end)

mobileButton("FLY", 75, 0, function()
    if Config.Fly then
        stopFly()
        notify("Fly", "Disabled")
    else
        startFly()
    end
end)

mobileButton("SPRINT", 0, 50, function()
    Config.Sprint = not Config.Sprint
    updateMovement()
    notify("Sprint", Config.Sprint and "Enabled" or "Disabled")
end)

mobileButton("JUMP", 75, 50, function()
    getCharacter()

    if Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--==============================================================
-- JUMP SYSTEM
--==============================================================

local doubleJumpAvailable = false

UIS.JumpRequest:Connect(function()
    getCharacter()

    if not Humanoid then
        return
    end

    if Config.InfiniteJump then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        return
    end

    if Config.DoubleJump and doubleJumpAvailable then
        doubleJumpAvailable = false
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

        if Root then
            Root.AssemblyLinearVelocity = Vector3.new(
                Root.AssemblyLinearVelocity.X,
                65,
                Root.AssemblyLinearVelocity.Z
            )
        end
    end
end)

local function onCharacterAdded(character)
    task.wait(0.6)

    if Player.Character ~= character then
        return
    end

    if Config.Fly then
        stopFly()
    end

    Config.Noclip = false
    restoreNoclip()

    getCharacter()
    updateMovement()

    doubleJumpAvailable = false

    if Humanoid then
        Humanoid.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.Landed
                or newState == Enum.HumanoidStateType.Running then
                doubleJumpAvailable = true
            end
        end)
    end

    if Config.ESP then
        refreshESP()
    end
end

Player.CharacterAdded:Connect(onCharacterAdded)

if Player.Character then
    task.spawn(onCharacterAdded, Player.Character)
end

--==============================================================
-- KEYBINDS
--==============================================================

UIS.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if input.KeyCode == Enum.KeyCode.F4 then
        setMenuVisible(not MenuOpen)

    elseif input.KeyCode == Enum.KeyCode.F then
        if Config.Fly then
            stopFly()
            notify("Fly", "Disabled")
        else
            startFly()
        end

    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        Config.Sprint = true
        updateMovement()
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        Config.Sprint = false
        updateMovement()
    end
end)

--==============================================================
-- RENDER ENGINE
--==============================================================

local fpsFrames = 0
local fpsElapsed = 0
local currentFPS = 60

RunService.RenderStepped:Connect(function(dt)
    fpsFrames += 1
    fpsElapsed += dt

    if fpsElapsed >= 1 then
        currentFPS = round(fpsFrames / fpsElapsed)
        fpsFrames = 0
        fpsElapsed = 0
    end

    if Config.CustomCursor and not UIS.TouchEnabled then
        local mouse = UIS:GetMouseLocation()
        UIS.MouseIconEnabled = false
        -- Cursor is intentionally lightweight.
    else
        UIS.MouseIconEnabled = true
    end

    if Config.ESP then
        for target, objects in pairs(ESPObjects) do
            local character = target.Character
            local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = character and character:FindFirstChildOfClass("Humanoid")

            local highlight = objects[1]
            local billboard = objects[2]
            local info = objects[3]

            if targetRoot and targetHumanoid then
                if highlight then
                    highlight.Enabled = true
                    highlight.FillColor = teamColor(target)
                end

                if billboard then
                    billboard.Enabled = true
                end

                if info then
                    local details = {}

                    if Config.DistanceInfo and Root then
                        table.insert(details, round((Root.Position - targetRoot.Position).Magnitude) .. " studs")
                    end

                    if Config.HealthInfo then
                        table.insert(details, "HP " .. round(targetHumanoid.Health) .. "/" .. round(targetHumanoid.MaxHealth))
                    end

                    info.Text = target.DisplayName .. "\n" .. table.concat(details, " | ")
                end
            else
                if highlight then
                    highlight.Enabled = false
                end

                if billboard then
                    billboard.Enabled = false
                end
            end
        end
    end
end)

--==============================================================
-- PHYSICS ENGINE
--==============================================================

RunService.Heartbeat:Connect(function()
    if Config.Noclip then
        local character = Player.Character

        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if NoclipParts[part] == nil then
                        NoclipParts[part] = part.CanCollide
                    end

                    part.CanCollide = false
                end
            end
        end
    end

    if Config.Fly then
        if not Root or not Root.Parent or not FlyVelocity or not FlyOrientation then
            stopFly()
        else
            local camera = workspace.CurrentCamera
            local direction = Vector3.zero

            if UIS:IsKeyDown(Enum.KeyCode.W) then
                direction += camera.CFrame.LookVector
            end

            if UIS:IsKeyDown(Enum.KeyCode.S) then
                direction -= camera.CFrame.LookVector
            end

            if UIS:IsKeyDown(Enum.KeyCode.D) then
                direction += camera.CFrame.RightVector
            end

            if UIS:IsKeyDown(Enum.KeyCode.A) then
                direction -= camera.CFrame.RightVector
            end

            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                direction += Vector3.yAxis
            end

            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction -= Vector3.yAxis
            end

            if direction.Magnitude > 0 then
                FlyVelocity.VectorVelocity = direction.Unit * Config.FlySpeed
            else
                FlyVelocity.VectorVelocity = Vector3.zero
            end

            FlyOrientation.CFrame = CFrame.lookAt(
                Vector3.zero,
                camera.CFrame.LookVector
            )
        end
    end
end)

--==============================================================
-- PLAYER CONNECTIONS
--==============================================================

local function connectPlayer(target)
    target.CharacterAdded:Connect(function()
        task.wait(0.8)

        if Config.ESP then
            addESP(target)
        end
    end)

    if target.Character and Config.ESP then
        addESP(target)
    end
end

for _, target in ipairs(Players:GetPlayers()) do
    connectPlayer(target)
end

Players.PlayerAdded:Connect(connectPlayer)

Players.PlayerRemoving:Connect(function(target)
    local objects = ESPObjects[target]

    if objects then
        for _, object in ipairs(objects) do
            if object and object.Parent then
                object:Destroy()
            end
        end

        ESPObjects[target] = nil
    end
end)

--==============================================================
-- SPLASH SCREEN
--==============================================================

local Splash = Instance.new("Frame")
Splash.Size = UDim2.fromScale(1, 1)
Splash.BackgroundColor3 = BG
Splash.BorderSizePixel = 0
Splash.ZIndex = 200
Splash.Parent = Gui

local SplashLogo = Instance.new("TextLabel")
SplashLogo.Size = UDim2.fromOffset(300, 100)
SplashLogo.AnchorPoint = Vector2.new(0.5, 0.5)
SplashLogo.Position = UDim2.fromScale(0.5, 0.42)
SplashLogo.BackgroundTransparency = 1
SplashLogo.Text = "VSHXDOW"
SplashLogo.TextColor3 = Accent
SplashLogo.Font = Enum.Font.GothamBlack
SplashLogo.TextSize = 46
SplashLogo.ZIndex = 201
SplashLogo.Parent = Splash

local SplashSub = Instance.new("TextLabel")
SplashSub.Size = UDim2.fromOffset(300, 30)
SplashSub.AnchorPoint = Vector2.new(0.5, 0.5)
SplashSub.Position = UDim2.fromScale(0.5, 0.53)
SplashSub.BackgroundTransparency = 1
SplashSub.Text = "ULTIMATE EDITION  |  V7 FINAL"
SplashSub.TextColor3 = WHITE
SplashSub.Font = Enum.Font.Gotham
SplashSub.TextSize = 11
SplashSub.ZIndex = 201
SplashSub.Parent = Splash

local LoadingBack = Instance.new("Frame")
LoadingBack.Size = UDim2.fromOffset(230, 6)
LoadingBack.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingBack.Position = UDim2.fromScale(0.5, 0.62)
LoadingBack.BackgroundColor3 = CARD
LoadingBack.BorderSizePixel = 0
LoadingBack.ZIndex = 201
LoadingBack.Parent = Splash

Instance.new("UICorner", LoadingBack).CornerRadius = UDim.new(1, 0)

local LoadingFill = Instance.new("Frame")
LoadingFill.Size = UDim2.fromScale(0, 1)
LoadingFill.BackgroundColor3 = Accent
LoadingFill.BorderSizePixel = 0
LoadingFill.ZIndex = 202
LoadingFill.Parent = LoadingBack

Instance.new("UICorner", LoadingFill).CornerRadius = UDim.new(1, 0)

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.fromOffset(300, 25)
LoadingText.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingText.Position = UDim2.fromScale(0.5, 0.68)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "Initializing..."
LoadingText.TextColor3 = GREY
LoadingText.Font = Enum.Font.Gotham
LoadingText.TextSize = 11
LoadingText.ZIndex = 201
LoadingText.Parent = Splash

local loadingSteps = {
    "Loading interface...",
    "Preparing controls...",
    "Initializing dashboard...",
    "Preparing VSHXDOW...",
    "Almost ready..."
}

for index, text in ipairs(loadingSteps) do
    LoadingText.Text = text

    tween(LoadingFill, {
        Size = UDim2.fromScale(index / #loadingSteps, 1)
    }, 0.3)

    task.wait(0.22)
end

task.wait(0.3)

Main.Visible = true
Main.Size = UDim2.fromOffset(0, 0)

tween(Main, {
    Size = UDim2.fromOffset(760, 520)
}, 0.45)

tween(Splash, {
    BackgroundTransparency = 1
}, 0.35)

task.wait(0.4)
Splash:Destroy()

PageFunctions.Home()

notify("VSHXDOW V7", "Ultimate Edition loaded successfully!")

print("======================================")
print(" VSHXDOW V7 FINAL")
print(" Ultimate Edition loaded successfully")
print(" F4 = Show / Hide GUI")
print(" F  = Toggle Fly")
print(" Shift = Sprint")
print("======================================")
