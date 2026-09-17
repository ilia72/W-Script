-- =============================================================================
-- LOADER MENU (config load/save/delete GUI)
-- =============================================================================
local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "WScriptLoader"
LoaderGui.ResetOnSpawn = false
LoaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoaderGui.Parent = guiParent

local open = false

local Main = Instance.new("Frame", LoaderGui)
Main.Size = UDim2.new(0, 420, 0, 380)
Main.Position = UDim2.new(0.5, -210, 0.5, -190)
Main.BackgroundColor3 = C.bg
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = true
corner(Main, 8)
Main.Visible = false

local noise = Instance.new("ImageLabel", Main)
noise.Size = UDim2.new(1, 0, 1, 0)
noise.BackgroundTransparency = 1
noise.ImageTransparency = 0.94
noise.ScaleType = Enum.ScaleType.Tile
noise.TileSize = UDim2.new(0, 48, 0, 48)
noise.Image = "rbxassetid://6372755229"
noise.ZIndex = 0

local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 30)
Top.BackgroundColor3 = C.panel
Top.BorderSizePixel = 0
corner(Top, 8)
drag(Main, Top)

local Title = Instance.new("TextLabel", Top)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "w-script  //  loader"
Title.Font = Enum.Font.Code
Title.TextSize = 13
Title.TextColor3 = C.dim
Title.TextXAlignment = Enum.TextXAlignment.Left

local XBtn = Instance.new("TextButton", Top)
XBtn.Size = UDim2.new(0, 30, 0, 30)
XBtn.Position = UDim2.new(1, -30, 0, 0)
XBtn.BackgroundTransparency = 1
XBtn.Text = "x"
XBtn.Font = Enum.Font.Code
XBtn.TextSize = 16
XBtn.TextColor3 = C.dim
XBtn.Modal = true

local ListFrame = Instance.new("ScrollingFrame", Main)
ListFrame.Size = UDim2.new(1, -20, 0, 240)
ListFrame.Position = UDim2.new(0, 10, 0, 40)
ListFrame.BackgroundColor3 = C.elem
ListFrame.BorderSizePixel = 0
ListFrame.ScrollBarThickness = 3
ListFrame.ScrollBarImageColor3 = C.off
ListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListFrame.CanvasSize = UDim2.new()
Instance.new("UIListLayout", ListFrame).Padding = UDim.new(0, 4)

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 18)
StatusLabel.Position = UDim2.new(0, 10, 0, 290)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 11
StatusLabel.TextColor3 = C.dim
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Text = "no configs"

local SaveFrame = Instance.new("Frame", Main)
SaveFrame.Size = UDim2.new(1, -20, 0, 40)
SaveFrame.Position = UDim2.new(0, 10, 1, -50)
SaveFrame.BackgroundColor3 = C.elem
SaveFrame.BorderSizePixel = 0
corner(SaveFrame, 5)

local SaveInput = Instance.new("TextBox", SaveFrame)
SaveInput.Size = UDim2.new(1, -100, 0, 28)
SaveInput.Position = UDim2.new(0, 10, 0, 6)
SaveInput.BackgroundColor3 = C.bg
SaveInput.PlaceholderText = "config name..."
SaveInput.Font = Enum.Font.Code
SaveInput.TextSize = 12
SaveInput.TextColor3 = C.text
SaveInput.PlaceholderColor3 = C.dim

local SaveBtn = Instance.new("TextButton", SaveFrame)
SaveBtn.Size = UDim2.new(0, 80, 0, 28)
SaveBtn.Position = UDim2.new(1, -90, 0, 6)
SaveBtn.BackgroundColor3 = C.accent
SaveBtn.Text = "Save"
SaveBtn.Font = Enum.Font.Code
SaveBtn.TextSize = 12
SaveBtn.TextColor3 = C.bg
corner(SaveBtn, 5)

local RefreshBtn = Instance.new("TextButton", Main)
RefreshBtn.Size = UDim2.new(0, 80, 0, 24)
RefreshBtn.Position = UDim2.new(1, -90, 1, -55)
RefreshBtn.BackgroundColor3 = C.elem
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Text = "Refresh"
RefreshBtn.Font = Enum.Font.Code
RefreshBtn.TextSize = 11
RefreshBtn.TextColor3 = C.text
corner(RefreshBtn, 4)

local function refreshList()
	for _, child in ipairs(ListFrame:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	if not canFS() then
		StatusLabel.Text = "no filesystem"
		return
	end
	ensureFolder()
	local configs = listConfigs()
	if #configs == 0 then
		StatusLabel.Text = "no configs saved"
		return
	end
	StatusLabel.Text = "# configs: " .. #configs
	table.sort(configs)
	for i, name in ipairs(configs) do
		local card = Instance.new("Frame", ListFrame)
		card.Size = UDim2.new(1, 0, 0, 32)
		card.BackgroundColor3 = C.elem
		card.BorderSizePixel = 0
		card.LayoutOrder = i
		corner(card, 5)

		local nm = Instance.new("TextLabel", card)
		nm.Size = UDim2.new(1, -100, 1, 0)
		nm.Position = UDim2.new(0, 10, 0, 0)
		nm.BackgroundTransparency = 1
		nm.Font = Enum.Font.Code
		nm.TextSize = 12
		nm.TextColor3 = C.text
		nm.TextXAlignment = Enum.TextXAlignment.Left
		nm.Text = name

		local loadBtn = Instance.new("TextButton", card)
		loadBtn.Size = UDim2.new(0, 50, 0, 22)
		loadBtn.Position = UDim2.new(1, -105, 0.5, -11)
		loadBtn.BackgroundColor3 = C.green
		loadBtn.Text = "Load"
		loadBtn.Font = Enum.Font.Code
		loadBtn.TextSize = 11
		loadBtn.TextColor3 = C.bg
		corner(loadBtn, 4)

		local delBtn = Instance.new("TextButton", card)
		delBtn.Size = UDim2.new(0, 50, 0, 22)
		delBtn.Position = UDim2.new(1, -50, 0.5, -11)
		delBtn.BackgroundColor3 = C.red
		delBtn.Text = "Del"
		delBtn.Font = Enum.Font.Code
		delBtn.TextSize = 11
		delBtn.TextColor3 = C.bg
		corner(delBtn, 4)

		loadBtn.MouseButton1Click:Connect(function()
			loadConfig(name)
			StatusLabel.Text = "loaded: " .. name
		end)
		delBtn.MouseButton1Click:Connect(function()
			if isfile and isfile(CFG_FOLDER .. "/" .. name .. ".json") then
				os.remove(CFG_FOLDER .. "/" .. name .. ".json")
				refreshList()
				StatusLabel.Text = "deleted: " .. name
			end
		end)
	end
end

SaveBtn.MouseButton1Click:Connect(function()
	local name = SaveInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
	if name == "" then Notify("enter name", 2, C.red) return end
	saveConfig(name)
	SaveInput.Text = ""
	refreshList()
end)

RefreshBtn.MouseButton1Click:Connect(function()
	refreshList()
	Notify("refreshed", 1.5, C.accent)
end)

local function toggleLoader()
	open = not open
	Main.Visible = open
	if open then refreshList() end
end

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Insert then
		toggleLoader()
	end
end)

Notify("loader: Insert key", 2, C.accent)
