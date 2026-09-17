--==============================================================================
-- W-SCRIPT // FIXED 3RD PERSON + CFG + SILENT AIM + RMB CUSTOMIZE
--==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

local guiParent
pcall(function() guiParent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not guiParent then guiParent = LP:WaitForChild("PlayerGui") end
for _, p in ipairs({guiParent, LP:FindFirstChild("PlayerGui")}) do
	if p and p:FindFirstChild("WScript_CFG") then p.WScript_CFG:Destroy() end
end

-- =============================================================================
-- THEME
-- =============================================================================
local C = {
	bg = Color3.fromRGB(16,16,20), panel = Color3.fromRGB(24,24,30), elem = Color3.fromRGB(32,32,40),
	accent = Color3.fromRGB(110,130,240), off = Color3.fromRGB(50,50,62),
	text = Color3.fromRGB(235,235,242), dim = Color3.fromRGB(125,125,140),
	red = Color3.fromRGB(235,65,65), green = Color3.fromRGB(65,215,115), orange = Color3.fromRGB(255,165,50),
}
local accentObjs = {}
local function markAccent(o,p) table.insert(accentObjs,{o=o,p=p}) o[p]=C.accent end
local function setAccent(col)
	C.accent = col
	for _,a in ipairs(accentObjs) do if a.o and a.o.Parent then pcall(function() a.o[a.p]=col end) end end
end

local function corner(o,r) Instance.new("UICorner",o).CornerRadius=UDim.new(0,r or 4) end
local function drag(frame, handle)
	local on,s0,p0
	handle.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then on=true s0=i.Position p0=frame.Position end end)
	UIS.InputChanged:Connect(function(i) if on and i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-s0 frame.Position=UDim2.new(p0.X.Scale,p0.X.Offset+d.X,p0.Y.Scale,p0.Y.Offset+d.Y) end end)
	UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then on=false end end)
end

local Gui = Instance.new("ScreenGui")
Gui.Name="WScript_CFG" Gui.ResetOnSpawn=false Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling Gui.Parent=guiParent

-- =============================================================================
-- NOTIFY
-- =============================================================================
local NHold = Instance.new("Frame", Gui)
NHold.Size=UDim2.new(0,260,1,-20) NHold.Position=UDim2.new(1,-270,0,10) NHold.BackgroundTransparency=1
Instance.new("UIListLayout", NHold).Padding=UDim.new(0,6)
local nI=0
local function Notify(msg,dur,col)
	dur=dur or 2.2 col=col or C.accent nI+=1
	local card=Instance.new("Frame",NHold)
	card.Size=UDim2.new(1,0,0,28) card.BackgroundColor3=C.panel card.BackgroundTransparency=1 card.BorderSizePixel=0 card.LayoutOrder=nI
	corner(card,4)
	local bar=Instance.new("Frame",card) bar.Size=UDim2.new(0,3,1,-6) bar.Position=UDim2.new(0,3,0,3) bar.BackgroundColor3=col bar.BorderSizePixel=0 corner(bar,2)
	local l=Instance.new("TextLabel",card) l.Size=UDim2.new(1,-16,1,0) l.Position=UDim2.new(0,12,0,0) l.BackgroundTransparency=1
	l.Text=msg l.Font=Enum.Font.Code l.TextSize=11 l.TextColor3=C.text l.TextXAlignment=Enum.TextXAlignment.Left l.TextTransparency=1
	TweenService:Create(card,TweenInfo.new(0.15),{BackgroundTransparency=0.05}):Play()
	TweenService:Create(l,TweenInfo.new(0.15),{TextTransparency=0}):Play()
	task.delay(dur,function()
		TweenService:Create(card,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
		TweenService:Create(l,TweenInfo.new(0.2),{TextTransparency=1}):Play()
		task.wait(0.22) card:Destroy()
	end)
end

-- =============================================================================
-- STATE + PER-FEATURE CUSTOM
-- =============================================================================
local S = {
	Fly=false, FlySpeed=60, VehFly=false, Float=false,
	WS=false, WSVal=50, JP=false, JPVal=100, CF=false, CFVal=3,
	InfJump=false, Bhop=false, Spider=false, Noclip=false, Ghost=false,
	Spin=false, SpinSpd=25, ClickTP=false, DashDist=25,
	FakeLag=false, LagSec=0.12, _lagT=0, AutoStrafe=false, EdgeBug=false, EdgeJump=false,

	Aimbot=false, SilentAim=false, AimRange=250, AimPart="Head", FOVCircle=false, FOVSize=120,
	Hitbox=false, HitSize=12, Reach=false, Fling=false, AntiFling=false,
	TriggerBot=false, TriggerDelay=0, TriggerTarget="Head", AutoShoot=false, WallBang=false,
	Resolver=false, Prediction=false, PredictionValue=0.08,

	FOV=false, FOVVal=100, ThirdP=false, ThirdDist=14, Bob=false,

	ESP=false, Box=false, NameESP=false, HP=false, Tracer=false, RGBEsp=false,
	EspColor = Color3.fromRGB(255,75,75),
	Skeleton=false, DistanceESP=false, AntiAim=false, AntiAimYaw=180, Invisible=false, NameHP=false,
	BoxLines=false, TopInfo=false, BottomInfo=false,
	ScreenGlitch=false, ScreenChroma=false, ScreenVignette=false,

	Halo=false, Hat=false, Trail=false, Fire=false, Sparks=false, FF=false,
	FXColor = Color3.fromRGB(110,130,240),

	Fullbright=false, Disco=false, AutoTime=false, NoFog=false, XRay=false,
	NeonWorld=false, PlasticWorld=false, CustomSky=false, SkyColor=Color3.fromRGB(135,206,235),
	WeatherRain=false, WeatherSnow=false, TerrainColor=Color3.fromRGB(139,69,19),

	Camp=false, CampDist=12, AntiTeleport=false, AntiKick=false, AutoPickup=false,
	AutoSteal=false, AutoStealDelay=0.2, FakeName=false, FakeLatency=false,
	_triggerT=0, _stealT=0, _triggerDelay=0,

	RGBUI=false, Cross=false, WM=false, Stats=false, BindList=true, AntiAFK=true,
}

local Feat = {}
local function ensureFeat(id)
	if not Feat[id] then Feat[id] = { color = C.accent, bind = nil } end
	return Feat[id]
end

local Def = {
	WS=16, JP=50, FOV=70, MinZ=0.5, MaxZ=400,
	Amb=Lighting.Ambient, OAmb=Lighting.OutdoorAmbient, Bri=Lighting.Brightness,
	FogE=Lighting.FogEnd, FogS=Lighting.FogStart, Clock=Lighting.ClockTime,
	Shift=Lighting.ColorShift_Top, Sh=Lighting.GlobalShadows,
}

local hitSave, matSave, xraySave = {}, {}, {}
local FX = {halo=nil,hat=nil,trail=nil,a0=nil,a1=nil}
local TracerFolder = Instance.new("Folder", Gui) TracerFolder.Name="Tracers"

local function char() return LP.Character end
local function hum() local c=char() return c and c:FindFirstChildOfClass("Humanoid") end
local function root() local c=char() return c and c:FindFirstChild("HumanoidRootPart") end

local function grabDef()
	local h=hum()
	if h then if not S.WS then Def.WS=h.WalkSpeed end if not S.JP then Def.JP=h.JumpPower end end
	local cam=workspace.CurrentCamera
	if cam and not S.FOV then Def.FOV=cam.FieldOfView end
end
LP.CharacterAdded:Connect(function() task.wait(0.4) grabDef() end)
task.defer(grabDef)

-- =============================================================================
-- HARD RESET: 3RD PERSON (THE ACTUAL FIX)
-- =============================================================================
local thirdConn = nil

local function forceVisibleCharacter()
	local c = char()
	if not c then return end
	for _,p in ipairs(c:GetDescendants()) do
		if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
			p.LocalTransparencyModifier = 0
		elseif p:IsA("Decal") or p:IsA("Texture") then
			if p.Transparency >= 1 then p.Transparency = 0 end
		end
	end
end

local function enableThirdPerson(dist)
	S.ThirdP = true
	S.ThirdDist = dist or S.ThirdDist
	Def.MinZ = LP.CameraMinZoomDistance
	Def.MaxZ = LP.CameraMaxZoomDistance
	LP.CameraMode = Enum.CameraMode.Classic
	local d = S.ThirdDist
	LP.CameraMinZoomDistance = d
	LP.CameraMaxZoomDistance = d + 0.001
	pcall(function()
		LP.CameraMinZoomDistance = d
		LP.CameraMaxZoomDistance = d + 0.001
	end)
	forceVisibleCharacter()
end

local function disableThirdPerson()
	S.ThirdP = false
	LP.CameraMode = Enum.CameraMode.Classic
	LP.CameraMinZoomDistance = 0.5
	LP.CameraMaxZoomDistance = 400
	local cam = workspace.CurrentCamera
	if cam then
		cam.CameraType = Enum.CameraType.Custom
		local h = hum()
		if h then cam.CameraSubject = h end
	end
	forceVisibleCharacter()
	task.defer(function()
		LP.CameraMinZoomDistance = 0.5
		LP.CameraMaxZoomDistance = 400
		forceVisibleCharacter()
	end)
	task.delay(0.05, function()
		LP.CameraMinZoomDistance = 0.5
		LP.CameraMaxZoomDistance = 400
		forceVisibleCharacter()
	end)
	task.delay(0.15, function()
		if not S.ThirdP then
			LP.CameraMinZoomDistance = 0.5
			LP.CameraMaxZoomDistance = 400
			forceVisibleCharacter()
		end
	end)
end

local function resetFly()
	local r=root() if r then r.AssemblyLinearVelocity=Vector3.zero r.AssemblyAngularVelocity=Vector3.zero r.Anchored=false end
	local h=hum() if h then h.PlatformStand=false pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
end
local function resetSpeed()
	local h=hum() if h then h.WalkSpeed=Def.WS h.JumpPower=Def.JP h.UseJumpPower=true end
end
local function resetNoclip()
	local c=char() if not c then return end
	for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=(p.Name~="HumanoidRootPart") end end
end
local function resetGhostFF()
	local c=char() if not c then return end
	for _,p in ipairs(c:GetDescendants()) do
		if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
			p.LocalTransparencyModifier=0
			if p.Material==Enum.Material.ForceField then p.Material=Enum.Material.Plastic end
		end
	end
end
local function clearESP()
	for _,p in ipairs(Players:GetPlayers()) do
		if p.Character then
			for _,n in ipairs({"W_HL","W_BOX","W_NAME","W_HP"}) do local o=p.Character:FindFirstChild(n) if o then o:Destroy() end end
		end
	end
	TracerFolder:ClearAllChildren()
end
local function resetHit()
	for p,sz in pairs(hitSave) do if p and p.Parent then p.Size=sz p.Transparency=1 p.CanCollide=true p.Massless=false end end
	hitSave={}
end
local function clearFX()
	if FX.halo then FX.halo:Destroy() FX.halo=nil end
	if FX.hat then FX.hat:Destroy() FX.hat=nil end
	if FX.trail then FX.trail:Destroy() FX.trail=nil end
	if FX.a0 then FX.a0:Destroy() FX.a0=nil end
	if FX.a1 then FX.a1:Destroy() FX.a1=nil end
	local r=root() if r then if r:FindFirstChild("W_Fire") then r.W_Fire:Destroy() end if r:FindFirstChild("W_Spark") then r.W_Spark:Destroy() end end
end
local function resetMats() for o,m in pairs(matSave) do if o and o.Parent then o.Material=m end end matSave={} end
local function resetXray() for o,v in pairs(xraySave) do if o and o.Parent then o.LocalTransparencyModifier=v end end xraySave={} end
local function resetLight()
	Lighting.Ambient=Def.Amb Lighting.OutdoorAmbient=Def.OAmb Lighting.Brightness=Def.Bri
	Lighting.GlobalShadows=Def.Sh Lighting.ColorShift_Top=Def.Shift
	Lighting.FogEnd=Def.FogE Lighting.FogStart=Def.FogS Lighting.ClockTime=Def.Clock
end
local function resetFOV()
	local cam=workspace.CurrentCamera if cam then cam.FieldOfView=Def.FOV end
end

local function hardOff(id)
	if id=="ThirdP" then disableThirdPerson()
	elseif id=="FOV" then resetFOV()
	elseif id=="Fly" or id=="VehFly" or id=="Float" then if not(S.Fly or S.VehFly or S.Float) then resetFly() end
	elseif id=="WS" or id=="JP" then resetSpeed()
	elseif id=="Noclip" then resetNoclip()
	elseif id=="Ghost" or id=="FF" then resetGhostFF()
	elseif id=="Invisible" then
		local c=char() if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.LocalTransparencyModifier=0 end end end
	elseif id=="Spin" or id=="Fling" then local r=root() if r then r.AssemblyAngularVelocity=Vector3.zero end
	elseif id=="FakeLag" then local r=root() if r then r.Anchored=false end
	elseif id=="Hitbox" or id=="Reach" then resetHit()
	elseif id=="ESP" or id=="Box" or id=="NameESP" or id=="HP" or id=="Tracer" or id=="Skeleton" or id=="DistanceESP" or id=="NameHP" then
		if skeletonDraw then
			for _,lines in pairs(skeletonDraw) do
				for _,line in pairs(lines) do
					if line then line:Remove() end
				end
			end
			skeletonDraw = {}
		end
		for _,p in ipairs(Players:GetPlayers()) do
			if p.Character then
				local df=p.Character:FindFirstChild("W_DIST")
				if df then df:Destroy() end
			end
		end
		clearESP()
	elseif id=="Halo" or id=="Hat" or id=="Trail" or id=="Fire" or id=="Sparks" then clearFX()
	elseif id=="Fullbright" or id=="Disco" or id=="AutoTime" or id=="NoFog" then resetLight()
	elseif id=="XRay" then resetXray()
	elseif id=="NeonWorld" or id=="PlasticWorld" then resetMats()
	elseif id=="CustomSky" or id=="WeatherRain" or id=="WeatherSnow" then
		local sky = Lighting:FindFirstChildOfClass("Sky")
		if sky then sky:Destroy() end
		resetLight()
	elseif id=="ScreenGlitch" then end
	elseif id=="Camp" then end
	elseif id=="AntiTeleport" then local h=hum() if h then h.WalkSpeed=Def.WS end end
	elseif id=="AutoSteal" or id=="FakeLatency" then local r=root() if r then r.Anchored=false end end
	elseif id=="FakeName" then end
	elseif id=="AutoPickup" then end
	elseif id=="TriggerBot" or id=="AutoShoot" or id=="WallBang" or id=="Resolver" or id=="Prediction" then end
	elseif id=="BoxLines" or id=="TopInfo" or id=="BottomInfo" or id=="ScreenChroma" or id=="ScreenVignette" then end
	elseif id=="SilentAim" or id=="Aimbot" or id=="FOVCircle" then end
end

-- =============================================================================
-- FOV CIRCLE (for silent aim)
-- =============================================================================
local FOVDraw = Instance.new("Frame", Gui)
FOVDraw.AnchorPoint=Vector2.new(0.5,0.5)
FOVDraw.Position=UDim2.new(0.5,0,0.5,0)
FOVDraw.Size=UDim2.new(0,240,0,240)
FOVDraw.BackgroundTransparency=1
FOVDraw.Visible=false
local FOVStroke = Instance.new("UIStroke", FOVDraw)
FOVStroke.Thickness=1.5 FOVStroke.Color=C.accent FOVStroke.Transparency=0.25
markAccent(FOVStroke,"Color")
local FOVCorner = Instance.new("UICorner", FOVDraw) FOVCorner.CornerRadius=UDim.new(1,0)

-- =============================================================================
-- SILENT AIM (hook mouse.Hit / mouse.Target via mt)
-- =============================================================================
local rawIndex, rawNewIndex
local silentTarget = nil
local skeletonDraw = {}

local function getClosestInFOV()
	local cam = workspace.CurrentCamera
	if not cam then return nil end
	local center = cam.ViewportSize / 2
	local best, bestD = nil, S.FOVSize
	local myRoot = root()
	if not myRoot then return nil end
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			local part = p.Character:FindFirstChild(S.AimPart) or p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
			local h = p.Character:FindFirstChildOfClass("Humanoid")
			if part and h and h.Health > 0 then
				local sp, onScreen = cam:WorldToViewportPoint(part.Position)
				if onScreen and sp.Z > 0 then
					local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
					local wd = (myRoot.Position - part.Position).Magnitude
					if d <= bestD and wd <= S.AimRange then
						bestD = d
						best = part
					end
				end
			end
		end
	end
	return best
end

pcall(function()
	local mt = getrawmetatable(game)
	local oldNamecall
	if mt then
		local ok = pcall(function() setreadonly(mt, false) end)
		rawIndex = mt.__index
		mt.__index = newcclosure and newcclosure(function(self, key)
			if S.SilentAim and silentTarget then
				if self == Mouse and (key == "Hit" or key == "hit") then return silentTarget.CFrame end
				if self == Mouse and (key == "Target" or key == "target") then return silentTarget end
			end
			return rawIndex(self, key)
		end) or function(self, key)
			if S.SilentAim and silentTarget then
				if self == Mouse and (key == "Hit" or key == "hit") then return silentTarget.CFrame end
				if self == Mouse and (key == "Target" or key == "target") then return silentTarget end
			end
			return rawIndex(self, key)
		end
		pcall(function() setreadonly(mt, true) end)
	end
end)

-- =============================================================================
-- CFG SYSTEM
-- =============================================================================
local CFG_FOLDER = "WScriptCFG"
local CFG_FILE = "WScriptCFG/autoload.json"

local function canFS()
	return (writefile and readfile and isfolder and makefolder and listfiles) and true or false
end

local function ensureFolder()
	if not canFS() then return false end
	if not isfolder(CFG_FOLDER) then makefolder(CFG_FOLDER) end
	return true
end

local function serializeColor(c) return {r=c.R, g=c.G, b=c.B} end
local function deserializeColor(t)
	if typeof(t)=="table" and t.r then return Color3.new(t.r,t.g,t.b) end
	return C.accent
end

local function exportConfig()
	local data = {
		state = {}, feat = {}, binds = {},
		accent = serializeColor(C.accent),
		espColor = serializeColor(S.EspColor),
		fxColor = serializeColor(S.FXColor),
		aimPart = S.AimPart, fovSize = S.FOVSize,
	}
	for k,v in pairs(S) do
		local t = typeof(v)
		if t=="boolean" or t=="number" or t=="string" then data.state[k]=v end
	end
	for id,f in pairs(Feat) do data.feat[id] = { color = serializeColor(f.color) } end
	return HttpService:JSONEncode(data)
end

local function applyConfig(json)
	local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
	if not ok or type(data)~="table" then Notify("cfg corrupt",2,C.red) return end
	if data.accent then setAccent(deserializeColor(data.accent)) end
	if data.espColor then S.EspColor = deserializeColor(data.espColor) end
	if data.fxColor then S.FXColor = deserializeColor(data.fxColor) end
	if data.aimPart then S.AimPart = data.aimPart end
	if data.fovSize then S.FOVSize = data.fovSize end
	if data.feat then
		for id,f in pairs(data.feat) do
			local ft = ensureFeat(id)
			if f.color then ft.color = deserializeColor(f.color) end
		end
	end
	if data.state then
		for k,v in pairs(data.state) do
			if S[k] ~= nil and typeof(S[k]) == typeof(v) then S[k] = v end
		end
	end
	for id, tog in pairs(Registry and Registry.Toggles or {}) do
		if data.state and data.state[id] ~= nil then
			local want = data.state[id] and true or false
			if tog.Get() ~= want then tog.Set(want, false) end
		end
	end
	if data.state and data.state.ThirdP then enableThirdPerson(S.ThirdDist) else disableThirdPerson() end
	Notify("config loaded", 2, C.green)
end

local function saveConfig(name)
	if not ensureFolder() then
		local json = exportConfig()
		pcall(function() setclipboard(json) end)
		Notify("no filesystem — cfg copied to clipboard", 3, C.orange)
		return
	end
	name = name or "default"
	local path = CFG_FOLDER .. "/" .. name .. ".json"
	writefile(path, exportConfig())
	Notify("saved cfg: "..name, 2, C.green)
end

local function loadConfig(name)
	if not canFS() then Notify("executor has no file api",2,C.red) return end
	ensureFolder()
	name = name or "default"
	local path = CFG_FOLDER .. "/" .. name .. ".json"
	if isfile and not isfile(path) then Notify("cfg not found: "..name,2,C.red) return end
	local json = readfile(path)
	applyConfig(json)
end

local function listConfigs()
	if not canFS() then return {} end
	ensureFolder()
	local out = {}
	for _,f in ipairs(listfiles(CFG_FOLDER)) do
		local n = f:match("([^/\\]+)%.json$")
		if n then table.insert(out, n) end
	end
	return out
end

-- =============================================================================
-- UI SHELL
-- =============================================================================
local Main = Instance.new("Frame", Gui)
Main.Size=UDim2.new(0,600,0,460) Main.Position=UDim2.new(0.5,-300,0.5,-230)
Main.BackgroundColor3=C.bg Main.BorderSizePixel=0 Main.Active=true Main.ClipsDescendants=true corner(Main,8)

local noise=Instance.new("ImageLabel",Main)
noise.Size=UDim2.new(1,0,1,0) noise.BackgroundTransparency=1 noise.ImageTransparency=0.94
noise.ScaleType=Enum.ScaleType.Tile noise.TileSize=UDim2.new(0,48,0,48) noise.Image="rbxassetid://6372755229" noise.ZIndex=0

local Top=Instance.new("Frame",Main)
Top.Size=UDim2.new(1,0,0,30) Top.BackgroundColor3=C.panel Top.BorderSizePixel=0 corner(Top,8) drag(Main,Top)

local Title=Instance.new("TextLabel",Top)
Title.Size=UDim2.new(1,-40,1,0) Title.Position=UDim2.new(0,12,0,0) Title.BackgroundTransparency=1
Title.Text="w-script  //  cfg + silent" Title.Font=Enum.Font.Code Title.TextSize=13 Title.TextColor3=C.dim Title.TextXAlignment=Enum.TextXAlignment.Left

local XBtn=Instance.new("TextButton",Top)
XBtn.Size=UDim2.new(0,30,0,30) XBtn.Position=UDim2.new(1,-30,0,0) XBtn.BackgroundTransparency=1
XBtn.Text="x" XBtn.Font=Enum.Font.Code XBtn.TextSize=16 XBtn.TextColor3=C.dim XBtn.Modal=true

local Side=Instance.new("Frame",Main)
Side.Size=UDim2.new(0,118,1,-30) Side.Position=UDim2.new(0,0,0,30) Side.BackgroundColor3=C.panel Side.BorderSizePixel=0
Instance.new("UIListLayout",Side).Padding=UDim.new(0,2)

local Content=Instance.new("Frame",Main)
Content.BackgroundTransparency=1 Content.Position=UDim2.new(0,124,0,36) Content.Size=UDim2.new(1,-132,1,-44)

local tabs={}
local function makeTab(name)
	local btn=Instance.new("TextButton",Side)
	btn.Size=UDim2.new(1,-8,0,30) btn.Position=UDim2.new(0,4,0,0)
	btn.BackgroundColor3=C.elem btn.BackgroundTransparency=1 btn.BorderSizePixel=0
	btn.Text="  "..name btn.Font=Enum.Font.Code btn.TextSize=12 btn.TextColor3=C.dim btn.TextXAlignment=Enum.TextXAlignment.Left corner(btn,5)
	local page=Instance.new("ScrollingFrame",Content)
	page.Size=UDim2.new(1,0,1,0) page.BackgroundTransparency=1 page.BorderSizePixel=0
	page.ScrollBarThickness=3 page.ScrollBarImageColor3=C.off
	page.AutomaticCanvasSize=Enum.AutomaticSize.Y page.CanvasSize=UDim2.new() page.Visible=false
	Instance.new("UIListLayout",page).Padding=UDim.new(0,4)
	local t={btn=btn,page=page} table.insert(tabs,t)
	btn.MouseButton1Click:Connect(function()
		for _,x in ipairs(tabs) do x.page.Visible=false x.btn.BackgroundTransparency=1 x.btn.TextColor3=C.dim end
		page.Visible=true btn.BackgroundTransparency=0.15 btn.TextColor3=C.text
	end)
	return t
end

local function section(tab, text)
	local f=Instance.new("Frame",tab.page) f.Size=UDim2.new(1,-4,0,18) f.BackgroundTransparency=1
	local l=Instance.new("TextLabel",f) l.Size=UDim2.new(1,0,1,0) l.BackgroundTransparency=1
	l.Text="— "..text l.Font=Enum.Font.Code l.TextSize=11 l.TextColor3=C.dim l.TextXAlignment=Enum.TextXAlignment.Left
end

local Ctx = Instance.new("Frame", Gui)
Ctx.Size=UDim2.new(0,200,0,0) Ctx.BackgroundColor3=C.panel Ctx.BorderSizePixel=0 Ctx.Visible=false Ctx.ZIndex=50
Ctx.AutomaticSize=Enum.AutomaticSize.Y corner(Ctx,6)
local CtxStroke=Instance.new("UIStroke",Ctx) CtxStroke.Color=C.off CtxStroke.Thickness=1
local CtxList=Instance.new("UIListLayout",Ctx) CtxList.Padding=UDim.new(0,2)
local CtxPad=Instance.new("UIPadding",Ctx) CtxPad.PaddingTop=UDim.new(0,6) CtxPad.PaddingBottom=UDim.new(0,6) CtxPad.PaddingLeft=UDim.new(0,6) CtxPad.PaddingRight=UDim.new(0,6)

local function hideCtx() Ctx.Visible=false end

local function ctxBtn(text, fn)
	local b=Instance.new("TextButton",Ctx)
	b.Size=UDim2.new(1,0,0,26) b.BackgroundColor3=C.elem b.BorderSizePixel=0
	b.Text=text b.Font=Enum.Font.Code b.TextSize=12 b.TextColor3=C.text corner(b,4)
	b.MouseButton1Click:Connect(function() fn() hideCtx() end)
end

local function openCustomize(featureId, label, anchorFrame)
	hideCtx()
	for _,ch in ipairs(Ctx:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
	local ft = ensureFeat(featureId)
	local title=Instance.new("TextLabel",Ctx)
	title.Size=UDim2.new(1,0,0,20) title.BackgroundTransparency=1
	title.Text="customize: "..label title.Font=Enum.Font.Code title.TextSize=11 title.TextColor3=C.dim title.TextXAlignment=Enum.TextXAlignment.Left
	ctxBtn("color: red", function() ft.color=Color3.fromRGB(255,70,70) if featureId=="ESP" or featureId=="Box" then S.EspColor=ft.color end if featureId=="Halo" or featureId=="Trail" then S.FXColor=ft.color end Notify("color red",1.2,ft.color) end)
	ctxBtn("color: blue", function() ft.color=Color3.fromRGB(80,140,255) if featureId=="ESP" or featureId=="Box" then S.EspColor=ft.color end if featureId=="Halo" or featureId=="Trail" then S.FXColor=ft.color end Notify("color blue",1.2,ft.color) end)
	ctxBtn("color: green", function() ft.color=Color3.fromRGB(70,220,120) if featureId=="ESP" or featureId=="Box" then S.EspColor=ft.color end if featureId=="Halo" or featureId=="Trail" then S.FXColor=ft.color end Notify("color green",1.2,ft.color) end)
	ctxBtn("color: purple", function() ft.color=Color3.fromRGB(170,90,255) if featureId=="ESP" or featureId=="Box" then S.EspColor=ft.color end if featureId=="Halo" or featureId=="Trail" then S.FXColor=ft.color end Notify("color purple",1.2,ft.color) end)
	ctxBtn("color: white", function() ft.color=Color3.fromRGB(255,255,255) if featureId=="ESP" or featureId=="Box" then S.EspColor=ft.color end if featureId=="Halo" or featureId=="Trail" then S.FXColor=ft.color end Notify("color white",1.2,ft.color) end)
	ctxBtn("color: accent/rgb", function() ft.color=C.accent if featureId=="ESP" or featureId=="Box" then S.EspColor=ft.color end Notify("color accent",1.2,C.accent) end)
	if featureId=="SilentAim" or featureId=="Aimbot" then
		ctxBtn("aim part: Head", function() S.AimPart="Head" Notify("aim Head",1.2,C.green) end)
		ctxBtn("aim part: HumanoidRootPart", function() S.AimPart="HumanoidRootPart" Notify("aim HRP",1.2,C.green) end)
		ctxBtn("aim part: UpperTorso", function() S.AimPart="UpperTorso" Notify("aim Torso",1.2,C.green) end)
	end
	ctxBtn("close", function() end)
	local ap = anchorFrame.AbsolutePosition
	local as = anchorFrame.AbsoluteSize
	Ctx.Position = UDim2.new(0, math.min(ap.X + as.X + 6, workspace.CurrentCamera.ViewportSize.X - 210), 0, math.min(ap.Y, workspace.CurrentCamera.ViewportSize.Y - 280))
	Ctx.Visible = true
end

UIS.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 and Ctx.Visible then task.defer(hideCtx) end
end)

Registry = { Toggles={}, Binds={}, BindUI={} }
local waitingBind=nil

local function Toggle(tab, label, id, default, onSet)
	local f=Instance.new("Frame",tab.page)
	f.Size=UDim2.new(1,-4,0,28) f.BackgroundColor3=C.elem f.BorderSizePixel=0 corner(f,5)
	local l=Instance.new("TextLabel",f)
	l.BackgroundTransparency=1 l.Position=UDim2.new(0,10,0,0) l.Size=UDim2.new(1,-50,1,0)
	l.Font=Enum.Font.Code l.TextSize=12 l.TextColor3=C.text l.TextXAlignment=Enum.TextXAlignment.Left l.Text=label
	local tip=Instance.new("TextLabel",f)
	tip.Size=UDim2.new(0,28,1,0) tip.Position=UDim2.new(1,-78,0,0) tip.BackgroundTransparency=1
	tip.Text="RMB" tip.Font=Enum.Font.Code tip.TextSize=9 tip.TextColor3=C.dim tip.TextXAlignment=Enum.TextXAlignment.Right
	local sw=Instance.new("TextButton",f)
	sw.Size=UDim2.new(0,30,0,15) sw.Position=UDim2.new(1,-40,0.5,-7) sw.BackgroundColor3=C.off sw.Text="" corner(sw,8)
	local dot=Instance.new("Frame",sw) dot.Size=UDim2.new(0,11,0,11) dot.Position=UDim2.new(0,2,0,2) dot.BackgroundColor3=C.text corner(dot,6)
	local state=false
	local function apply(v, viaBind)
		v = v and true or false
		state=v
		if id then S[id]=v end
		TweenService:Create(sw,TweenInfo.new(0.12),{BackgroundColor3=state and C.accent or C.off}):Play()
		TweenService:Create(dot,TweenInfo.new(0.12),{Position=state and UDim2.new(1,-13,0,2) or UDim2.new(0,2,0,2)}):Play()
		if id=="ThirdP" then
			if state then enableThirdPerson(S.ThirdDist) else disableThirdPerson() end
		else
			onSet(state)
			if not state and id then hardOff(id) end
		end
		if viaBind then Notify(label:lower()..": "..(state and "ON" or "OFF"),1.2, state and C.green or C.red) end
	end
	if id then Registry.Toggles[id]={set=apply,get=function() return state end} end
	sw.MouseButton1Click:Connect(function() apply(not state,false) end)
	f.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton2 then openCustomize(id or label, label, f) end
	end)
	if default then task.defer(function() apply(true,false) end) end
end

local function Slider(tab, label, min, max, default, cb)
	local f=Instance.new("Frame",tab.page)
	f.Size=UDim2.new(1,-4,0,40) f.BackgroundColor3=C.elem f.BorderSizePixel=0 corner(f,5)
	local l=Instance.new("TextLabel",f) l.BackgroundTransparency=1 l.Position=UDim2.new(0,10,0,3) l.Size=UDim2.new(1,-60,0,16)
	l.Font=Enum.Font.Code l.TextSize=11 l.TextColor3=C.text l.TextXAlignment=Enum.TextXAlignment.Left l.Text=label
	local v=Instance.new("TextLabel",f) v.BackgroundTransparency=1 v.Position=UDim2.new(1,-50,0,3) v.Size=UDim2.new(0,42,0,16)
	v.Font=Enum.Font.Code v.TextSize=11 v.TextColor3=C.accent v.TextXAlignment=Enum.TextXAlignment.Right v.Text=tostring(default) markAccent(v,"TextColor3")
	local bar=Instance.new("Frame",f) bar.Size=UDim2.new(1,-20,0,6) bar.Position=UDim2.new(0,10,0,24) bar.BackgroundColor3=C.off bar.BorderSizePixel=0 corner(bar,3)
	local fill=Instance.new("Frame",bar) fill.Size=UDim2.new((default-min)/(max-min),0,1,0) fill.BackgroundColor3=C.accent fill.BorderSizePixel=0 corner(fill,3) markAccent(fill,"BackgroundColor3")
	local dragging=false
	local function upd(i)
		local rel=math.clamp((i.Position.X-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
		local val=math.floor(min+rel*(max-min))
		fill.Size=UDim2.new(rel,0,1,0) v.Text=tostring(val) cb(val)
	end
	bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true upd(i) end end)
	UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i) end end)
	UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
end

local function Btn(tab, label, cb)
	local b=Instance.new("TextButton",tab.page)
	b.Size=UDim2.new(1,-4,0,28) b.BackgroundColor3=C.elem b.BorderSizePixel=0
	b.Text=label b.Font=Enum.Font.Code b.TextSize=12 b.TextColor3=C.text corner(b,5)
	b.MouseButton1Click:Connect(cb)
end

local function BindRow(tab, label, id)
	local b=Instance.new("TextButton",tab.page)
	b.Size=UDim2.new(1,-4,0,28) b.BackgroundColor3=C.elem b.BorderSizePixel=0 b.Font=Enum.Font.Code b.TextSize=12 b.TextColor3=C.text corner(b,5)
	local function refresh()
		local k=Registry.Binds[id]
		b.Text=string.format("%s   [%s]", label, k and tostring(k):gsub("Enum.KeyCode.","") or "NONE")
		b.TextColor3=C.text
	end
	refresh() Registry.BindUI[id]=refresh
	b.MouseButton1Click:Connect(function()
		if waitingBind then return end
		waitingBind=id b.Text=label.."   [press key]" b.TextColor3=C.orange
		Notify("press key...",1.5,C.orange)
	end)
end

local Stats=Instance.new("Frame",Gui)
Stats.Size=UDim2.new(0,158,0,72) Stats.Position=UDim2.new(0.5,-79,0,10) Stats.BackgroundColor3=C.bg Stats.BorderSizePixel=0 Stats.Visible=false Stats.Active=true corner(Stats,6) drag(Stats,Stats)
local sTop=Instance.new("Frame",Stats) sTop.Size=UDim2.new(1,0,0,20) sTop.BackgroundColor3=C.panel sTop.BorderSizePixel=0 corner(sTop,6)
local sT=Instance.new("TextLabel",sTop) sT.Size=UDim2.new(1,0,1,0) sT.BackgroundTransparency=1 sT.Text="[ metrics ]" sT.Font=Enum.Font.Code sT.TextSize=11 sT.TextColor3=C.accent markAccent(sT,"TextColor3")
local sL=Instance.new("TextLabel",Stats) sL.Size=UDim2.new(1,-14,1,-26) sL.Position=UDim2.new(0,8,0,24) sL.BackgroundTransparency=1 sL.Font=Enum.Font.Code sL.TextSize=12 sL.TextColor3=C.text sL.TextXAlignment=Enum.TextXAlignment.Left sL.TextYAlignment=Enum.TextYAlignment.Top

local WM=Instance.new("TextLabel",Gui)
WM.Size=UDim2.new(0,420,0,18) WM.Position=UDim2.new(0,14,0,12) WM.BackgroundTransparency=1 WM.Font=Enum.Font.Code WM.TextSize=12 WM.TextXAlignment=Enum.TextXAlignment.Left WM.TextColor3=C.accent WM.Visible=false WM.Text="w-script" markAccent(WM,"TextColor3")

local Cross=Instance.new("Frame",Gui)
Cross.Size=UDim2.new(0,18,0,18) Cross.Position=UDim2.new(0.5,-9,0.5,-9) Cross.BackgroundTransparency=1 Cross.Visible=false
local function ch(sz,pos) local f=Instance.new("Frame",Cross) f.BorderSizePixel=0 f.Size=sz f.Position=pos markAccent(f,"BackgroundColor3") end
ch(UDim2.new(0,2,0,6),UDim2.new(0.5,-1,0,0)) ch(UDim2.new(0,2,0,6),UDim2.new(0.5,-1,1,-6))
ch(UDim2.new(0,6,0,2),UDim2.new(0,0,0.5,-1)) ch(UDim2.new(0,6,0,2),UDim2.new(1,-6,0.5,-1))

-- =============================================================================
-- TABS
-- =============================================================================
local tMove=makeTab("movement")
local tExp=makeTab("exploits")
local tCombat=makeTab("combat")
local tVis=makeTab("visuals")
local tWorld=makeTab("world")
local tCam=makeTab("camera")
local tOpt=makeTab("optimize")
local tCfg=makeTab("config")
local tBind=makeTab("binds")
local tMisc=makeTab("misc")

section(tMove,"flight")
Toggle(tMove,"fly","Fly",false,function(v) S.Fly=v end)
Toggle(tMove,"vehicle fly","VehFly",false,function(v) S.VehFly=v end)
Slider(tMove,"fly speed",10,400,60,function(v) S.FlySpeed=v end)
Toggle(tMove,"float","Float",false,function(v) S.Float=v end)
section(tMove,"speed")
Toggle(tMove,"walkspeed","WS",false,function(v) S.WS=v if v then local h=hum() if h then Def.WS=h.WalkSpeed end end end)
Slider(tMove,"speed value",16,300,50,function(v) S.WSVal=v end)
Toggle(tMove,"cframe speed","CF",false,function(v) S.CF=v end)
Slider(tMove,"cframe force",1,40,3,function(v) S.CFVal=v end)
Toggle(tMove,"jumppower","JP",false,function(v) S.JP=v if v then local h=hum() if h then Def.JP=h.JumpPower end end end)
Slider(tMove,"jump value",50,400,100,function(v) S.JPVal=v end)
Toggle(tMove,"infinite jump","InfJump",false,function(v) S.InfJump=v end)
Toggle(tMove,"bunny hop","Bhop",false,function(v) S.Bhop=v end)
Toggle(tMove,"spider climb","Spider",false,function(v) S.Spider=v end)
section(tMove,"advanced")
Toggle(tMove,"auto-strafe","AutoStrafe",false,function(v) S.AutoStrafe=v end)
Toggle(tMove,"edge bug","EdgeBug",false,function(v) S.EdgeBug=v end)
Toggle(tMove,"edge jump","EdgeJump",false,function(v) S.EdgeJump=v end)

section(tExp,"physics")
Toggle(tExp,"noclip","Noclip",false,function(v) S.Noclip=v end)
Toggle(tExp,"click tp","ClickTP",false,function(v) S.ClickTP=v end)
Toggle(tExp,"fake lag","FakeLag",false,function(v) S.FakeLag=v end)
Slider(tExp,"lag ms",50,400,120,function(v) S.LagSec=v/1000 end)
Toggle(tExp,"spinbot","Spin",false,function(v) S.Spin=v end)
Toggle(tExp,"ghost","Ghost",false,function(v) S.Ghost=v end)

section(tCombat,"aim")
Toggle(tCombat,"camera aimbot","Aimbot",false,function(v) S.Aimbot=v end)
Toggle(tCombat,"silent aim","SilentAim",false,function(v) S.SilentAim=v end)
Toggle(tCombat,"fov circle","FOVCircle",false,function(v) S.FOVCircle=v FOVDraw.Visible=v end)
Slider(tCombat,"fov size",40,400,120,function(v) S.FOVSize=v FOVDraw.Size=UDim2.new(0,v*2,0,v*2) end)
Slider(tCombat,"aim range",50,600,250,function(v) S.AimRange=v end)
section(tCombat,"hitbox")
Toggle(tCombat,"hitbox expander","Hitbox",false,function(v) S.Hitbox=v end)
Toggle(tCombat,"tool reach","Reach",false,function(v) S.Reach=v end)
Slider(tCombat,"size",2,60,12,function(v) S.HitSize=v end)
section(tCombat,"troll")
Toggle(tCombat,"fling aura","Fling",false,function(v) S.Fling=v end)
Toggle(tCombat,"anti fling","AntiFling",false,function(v) S.AntiFling=v end)
section(tCombat,"legit")
Toggle(tCombat,"trigger bot","TriggerBot",false,function(v) S.TriggerBot=v end)
Slider(tCombat,"trigger delay",0,30,0,function(v) S.TriggerDelay=v end)
Toggle(tCombat,"auto shoot","AutoShoot",false,function(v) S.AutoShoot=v end)
Toggle(tCombat,"wallbang","WallBang",false,function(v) S.WallBang=v end)
section(tCombat,"advanced")
Toggle(tCombat,"resolver","Resolver",false,function(v) S.Resolver=v end)
Toggle(tCombat,"prediction","Prediction",false,function(v) S.Prediction=v end)
Slider(tCombat,"prediction %",0,100,8,function(v) S.PredictionValue=v/1000 end)

section(tVis,"esp  (RMB = color)")
Toggle(tVis,"highlight esp","ESP",false,function(v) S.ESP=v end)
Toggle(tVis,"box esp","Box",false,function(v) S.Box=v end)
Toggle(tVis,"name esp","NameESP",false,function(v) S.NameESP=v end)
Toggle(tVis,"health bar","HP",false,function(v) S.HP=v end)
Toggle(tVis,"tracers","Tracer",false,function(v) S.Tracer=v end)
Toggle(tVis,"rainbow esp","RGBEsp",false,function(v) S.RGBEsp=v end)
Toggle(tVis,"skeleton esp","Skeleton",false,function(v) S.Skeleton=v end)
Toggle(tVis,"distance esp","DistanceESP",false,function(v) S.DistanceESP=v end)
Toggle(tVis,"anti aim","AntiAim",false,function(v) S.AntiAim=v end)
Slider(tVis,"anti aim yaw",0,360,180,function(v) S.AntiAimYaw=v end)
Toggle(tVis,"invisible","Invisible",false,function(v) S.Invisible=v end)
Toggle(tVis,"name with hp","NameHP",false,function(v) S.NameHP=v end)
Toggle(tVis,"box lines","BoxLines",false,function(v) S.BoxLines=v end)
Toggle(tVis,"top info","TopInfo",false,function(v) S.TopInfo=v end)
Toggle(tVis,"bottom info","BottomInfo",false,function(v) S.BottomInfo=v end)
section(tVis,"screen effects")
Toggle(tVis,"glitch","ScreenGlitch",false,function(v) S.ScreenGlitch=v end)
Toggle(tVis,"chroma","ScreenChroma",false,function(v) S.ScreenChroma=v end)
Toggle(tVis,"vignette","ScreenVignette",false,function(v) S.ScreenVignette=v end)
section(tVis,"body fx  (RMB = color)")
Toggle(tVis,"neon halo","Halo",false,function(v) S.Halo=v end)
Toggle(tVis,"china hat","Hat",false,function(v) S.Hat=v end)
Toggle(tVis,"trail","Trail",false,function(v) S.Trail=v end)
Toggle(tVis,"fire","Fire",false,function(v) S.Fire=v end)
Toggle(tVis,"sparkles","Sparks",false,function(v) S.Sparks=v end)
Toggle(tVis,"forcefield","FF",false,function(v) S.FF=v end)

section(tWorld,"lighting")
Toggle(tWorld,"fullbright","Fullbright",false,function(v)
	S.Fullbright=v
	if v then Lighting.Ambient=Color3.new(1,1,1) Lighting.OutdoorAmbient=Color3.new(1,1,1) Lighting.Brightness=3 Lighting.GlobalShadows=false end
end)
Toggle(tWorld,"disco sky","Disco",false,function(v) S.Disco=v end)
Toggle(tWorld,"auto time","AutoTime",false,function(v) S.AutoTime=v end)
Toggle(tWorld,"no fog","NoFog",false,function(v) S.NoFog=v end)
Toggle(tWorld,"xray","XRay",false,function(v) S.XRay=v end)
section(tWorld,"map")
Toggle(tWorld,"neon world","NeonWorld",false,function(v) S.NeonWorld=v if v then S.PlasticWorld=false end end)
Toggle(tWorld,"plastic world","PlasticWorld",false,function(v) S.PlasticWorld=v if v then S.NeonWorld=false end end)
section(tWorld,"atmosphere")
Toggle(tWorld,"custom sky","CustomSky",false,function(v) S.CustomSky=v end)
Slider(tWorld,"sky r",0,255,135,function(v) S.SkyColor=Color3.fromRGB(v,S.SkyColor.G,S.SkyColor.B) end)
Slider(tWorld,"sky g",0,255,206,function(v) S.SkyColor=Color3.fromRGB(S.SkyColor.R,v,S.SkyColor.B) end)
Slider(tWorld,"sky b",0,255,235,function(v) S.SkyColor=Color3.fromRGB(S.SkyColor.R,S.SkyColor.G,v) end)
Toggle(tWorld,"rain","WeatherRain",false,function(v) S.WeatherRain=v end)
Toggle(tWorld,"snow","WeatherSnow",false,function(v) S.WeatherSnow=v end)
Toggle(tCam,"custom fov","FOV",false,function(v) S.FOV=v if v then local cam=workspace.CurrentCamera if cam then Def.FOV=cam.FieldOfView end end end)
Slider(tCam,"fov value",30,120,100,function(v) S.FOVVal=v end)
Toggle(tCam,"force 3rd person","ThirdP",false,function(v) end)
Slider(tCam,"3rd person distance",5,150,14,function(v)
	S.ThirdDist=v
	if S.ThirdP then enableThirdPerson(v) end
end)
Toggle(tCam,"camera bob","Bob",false,function(v) S.Bob=v end)
Slider(tCam,"dash distance",5,80,25,function(v) S.DashDist=v end)

section(tOpt,"fps")
Toggle(tOpt,"potato mode",nil,false,function(v)
	settings().Rendering.QualityLevel = v and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
	Lighting.GlobalShadows = not v
end)
Toggle(tOpt,"no shadows",nil,false,function(v) Lighting.GlobalShadows=not v end)
Toggle(tOpt,"no particles",nil,false,function(v)
	for _,o in ipairs(workspace:GetDescendants()) do
		if (o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Fire") or o:IsA("Smoke")) and not tostring(o.Name):find("W_") then o.Enabled=not v end
	end
end)
Toggle(tOpt,"hide decals",nil,false,function(v)
	for _,o in ipairs(workspace:GetDescendants()) do if o:IsA("Decal") or o:IsA("Texture") then o.Transparency=v and 1 or 0 end end
end)

section(tCfg,"save / load")
Btn(tCfg,"save config: default", function() saveConfig("default") end)
Btn(tCfg,"load config: default", function() loadConfig("default") end)
Btn(tCfg,"save config: pvp", function() saveConfig("pvp") end)
Btn(tCfg,"load config: pvp", function() loadConfig("pvp") end)
Btn(tCfg,"save config: legit", function() saveConfig("legit") end)
Btn(tCfg,"load config: legit", function() loadConfig("legit") end)
Btn(tCfg,"copy cfg to clipboard", function()
	local j=exportConfig() pcall(function() setclipboard(j) end) Notify("cfg copied",2,C.green)
end)
Btn(tCfg,"list configs (notify)", function()
	local list=listConfigs()
	if #list==0 then Notify("no cfgs / no fs",2,C.orange) else Notify("cfgs: "..table.concat(list,", "),3,C.green) end
end)

section(tBind,"rebind")
Registry.Binds.Menu=Enum.KeyCode.K
Registry.Binds.Fly=Enum.KeyCode.F
Registry.Binds.Noclip=Enum.KeyCode.V
Registry.Binds.WS=Enum.KeyCode.X
Registry.Binds.InfJump=Enum.KeyCode.J
Registry.Binds.ESP=Enum.KeyCode.E
Registry.Binds.Aimbot=Enum.KeyCode.R
Registry.Binds.SilentAim=Enum.KeyCode.Z
Registry.Binds.ClickTP=Enum.KeyCode.T
Registry.Binds.Dash=Enum.KeyCode.Q
Registry.Binds.Fullbright=Enum.KeyCode.B
Registry.Binds.ThirdP=Enum.KeyCode.Three

local bindMap = {
	Fly="Fly", Noclip="Noclip", WS="WS", InfJump="InfJump", ESP="ESP",
	Aimbot="Aimbot", SilentAim="SilentAim", ClickTP="ClickTP", Fullbright="Fullbright", ThirdP="ThirdP"
}

BindRow(tBind,"menu","Menu")
BindRow(tBind,"fly","Fly")
BindRow(tBind,"noclip","Noclip")
BindRow(tBind,"walkspeed","WS")
BindRow(tBind,"inf jump","InfJump")
BindRow(tBind,"esp","ESP")
BindRow(tBind,"aimbot","Aimbot")
BindRow(tBind,"silent aim","SilentAim")
BindRow(tBind,"click tp","ClickTP")
BindRow(tBind,"dash","Dash")
BindRow(tBind,"fullbright","Fullbright")
BindRow(tBind,"third person","ThirdP")

section(tMisc,"ui")
Toggle(tMisc,"rgb ui","RGBUI",false,function(v) S.RGBUI=v if not v then setAccent(Color3.fromRGB(110,130,240)) end end)
Toggle(tMisc,"watermark","WM",false,function(v) S.WM=v WM.Visible=v end)
Toggle(tMisc,"stats","Stats",false,function(v) S.Stats=v Stats.Visible=v end)
Toggle(tMisc,"crosshair","Cross",false,function(v) S.Cross=v Cross.Visible=v end)
Toggle(tMisc,"anti afk","AntiAFK",true,function(v) S.AntiAFK=v end)
section(tMisc,"anti-cheat")
Toggle(tMisc,"antiglare","Camp",false,function(v) S.Camp=v end)
Slider(tMisc,"camp distance",8,20,12,function(v) S.CampDist=v end)
Toggle(tMisc,"anti teleport","AntiTeleport",false,function(v) S.AntiTeleport=v end)
Toggle(tMisc,"anti kick","AntiKick",false,function(v) S.AntiKick=v end)
section(tMisc,"combat")
Toggle(tMisc,"auto-steal","AutoSteal",false,function(v) S.AutoSteal=v end)
Slider(tMisc,"steal delay",0,100,20,function(v) S.AutoStealDelay=v/100 end)
Toggle(tMisc,"fake name","FakeName",false,function(v) S.FakeName=v end)
Toggle(tMisc,"auto pickup","AutoPickup",false,function(v) S.AutoPickup=v end)
Toggle(tMisc,"fake latency","FakeLatency",false,function(v) S.FakeLatency=v end)
section(tMisc,"actions")
Btn(tMisc,"dash now", function() local r=root() local cam=workspace.CurrentCamera if r and cam then r.CFrame += cam.CFrame.LookVector*S.DashDist end end)
Btn(tMisc,"give btools", function()
	for _,bt in ipairs({Enum.BinType.Clone,Enum.BinType.Hammer,Enum.BinType.Grab}) do local h=Instance.new("HopperBin") h.BinType=bt h.Parent=LP.Backpack end
	Notify("btools",2,C.green)
end)
Btn(tMisc,"rejoin", function() TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP) end)
Btn(tMisc,"server hop", function() TeleportService:Teleport(game.PlaceId,LP) end)
section(tMisc,"panic")
Btn(tMisc,"DISABLE ALL", function()
	for _,tog in pairs(Registry.Toggles) do if tog.get() then tog.set(false,false) end end
	disableThirdPerson() resetFly() resetSpeed() resetNoclip() resetGhostFF() resetHit() clearESP() clearFX() resetMats() resetXray() resetLight() resetFOV()
	Notify("all off",2.5,C.orange)
end)

tabs[1].page.Visible=true tabs[1].btn.BackgroundTransparency=0.15 tabs[1].btn.TextColor3=C.text

-- =============================================================================
-- LOADER MENU (config load/save/delete GUI)
-- =============================================================================
local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "WScriptLoader"
LoaderGui.ResetOnSpawn = false
LoaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoaderGui.Parent = guiParent

local lopen = false

local LMain = Instance.new("Frame", LoaderGui)
LMain.Size = UDim2.new(0, 420, 0, 380)
LMain.Position = UDim2.new(0.5, -210, 0.5, -190)
LMain.BackgroundColor3 = C.bg
LMain.BorderSizePixel = 0
LMain.Active = true
LMain.ClipsDescendants = true
corner(LMain, 8)
LMain.Visible = false

local lnoise = Instance.new("ImageLabel", LMain)
lnoise.Size = UDim2.new(1, 0, 1, 0)
lnoise.BackgroundTransparency = 1
lnoise.ImageTransparency = 0.94
lnoise.ScaleType = Enum.ScaleType.Tile
lnoise.TileSize = UDim2.new(0, 48, 0, 48)
lnoise.Image = "rbxassetid://6372755229"
lnoise.ZIndex = 0

local LTop = Instance.new("Frame", LMain)
LTop.Size = UDim2.new(1, 0, 0, 30)
LTop.BackgroundColor3 = C.panel
LTop.BorderSizePixel = 0
corner(LTop, 8)
drag(LMain, LTop)

local LTitle = Instance.new("TextLabel", LTop)
LTitle.Size = UDim2.new(1, -40, 1, 0)
LTitle.Position = UDim2.new(0, 12, 0, 0)
LTitle.BackgroundTransparency = 1
LTitle.Text = "w-script  //  loader"
LTitle.Font = Enum.Font.Code
LTitle.TextSize = 13
LTitle.TextColor3 = C.dim
LTitle.TextXAlignment = Enum.TextXAlignment.Left

local LXBtn = Instance.new("TextButton", LTop)
LXBtn.Size = UDim2.new(0, 30, 0, 30)
LXBtn.Position = UDim2.new(1, -30, 0, 0)
LXBtn.BackgroundTransparency = 1
LXBtn.Text = "x"
LXBtn.Font = Enum.Font.Code
LXBtn.TextSize = 16
LXBtn.TextColor3 = C.dim
LXBtn.Modal = true

local LList = Instance.new("ScrollingFrame", LMain)
LList.Size = UDim2.new(1, -20, 0, 240)
LList.Position = UDim2.new(0, 10, 0, 40)
LList.BackgroundColor3 = C.elem
LList.BorderSizePixel = 0
LList.ScrollBarThickness = 3
LList.ScrollBarImageColor3 = C.off
LList.AutomaticCanvasSize = Enum.AutomaticSize.Y
LList.CanvasSize = UDim2.new()
Instance.new("UIListLayout", LList).Padding = UDim.new(0, 4)

local LStatus = Instance.new("TextLabel", LMain)
LStatus.Size = UDim2.new(1, -20, 0, 18)
LStatus.Position = UDim2.new(0, 10, 0, 290)
LStatus.BackgroundTransparency = 1
LStatus.Font = Enum.Font.Code
LStatus.TextSize = 11
LStatus.TextColor3 = C.dim
LStatus.TextXAlignment = Enum.TextXAlignment.Left
LStatus.Text = "no configs"

local LSaveFrame = Instance.new("Frame", LMain)
LSaveFrame.Size = UDim2.new(1, -20, 0, 40)
LSaveFrame.Position = UDim2.new(0, 10, 1, -50)
LSaveFrame.BackgroundColor3 = C.elem
LSaveFrame.BorderSizePixel = 0
corner(LSaveFrame, 5)

local LSaveInput = Instance.new("TextBox", LSaveFrame)
LSaveInput.Size = UDim2.new(1, -100, 0, 28)
LSaveInput.Position = UDim2.new(0, 10, 0, 6)
LSaveInput.BackgroundColor3 = C.bg
LSaveInput.PlaceholderText = "config name..."
LSaveInput.Font = Enum.Font.Code
LSaveInput.TextSize = 12
LSaveInput.TextColor3 = C.text
LSaveInput.PlaceholderColor3 = C.dim

local LSaveBtn = Instance.new("TextButton", LSaveFrame)
LSaveBtn.Size = UDim2.new(0, 80, 0, 28)
LSaveBtn.Position = UDim2.new(1, -90, 0, 6)
LSaveBtn.BackgroundColor3 = C.accent
LSaveBtn.Text = "Save"
LSaveBtn.Font = Enum.Font.Code
LSaveBtn.TextSize = 12
LSaveBtn.TextColor3 = C.bg
corner(LSaveBtn, 5)

local LRefreshBtn = Instance.new("TextButton", LMain)
LRefreshBtn.Size = UDim2.new(0, 80, 0, 24)
LRefreshBtn.Position = UDim2.new(1, -90, 1, -55)
LRefreshBtn.BackgroundColor3 = C.elem
LRefreshBtn.BorderSizePixel = 0
LRefreshBtn.Text = "Refresh"
LRefreshBtn.Font = Enum.Font.Code
LRefreshBtn.TextSize = 11
LRefreshBtn.TextColor3 = C.text
corner(LRefreshBtn, 4)

local function refreshList()
	for _, child in ipairs(LList:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	if not canFS() then
		LStatus.Text = "no filesystem"
		return
	end
	ensureFolder()
	local configs = listConfigs()
	if #configs == 0 then
		LStatus.Text = "no configs saved"
		return
	end
	LStatus.Text = "# configs: " .. #configs
	table.sort(configs)
	for i, name in ipairs(configs) do
		local card = Instance.new("Frame", LList)
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
			LStatus.Text = "loaded: " .. name
		end)
		delBtn.MouseButton1Click:Connect(function()
			if isfile and isfile(CFG_FOLDER .. "/" .. name .. ".json") then
				os.remove(CFG_FOLDER .. "/" .. name .. ".json")
				refreshList()
				LStatus.Text = "deleted: " .. name
			end
		end)
	end
end

LSaveBtn.MouseButton1Click:Connect(function()
	local name = LSaveInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
	if name == "" then Notify("enter name", 2, C.red) return end
	saveConfig(name)
	LSaveInput.Text = ""
	refreshList()
end)

LRefreshBtn.MouseButton1Click:Connect(function()
	refreshList()
	Notify("refreshed", 1.5, C.accent)
end)

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Insert then
		lopen = not lopen
		LMain.Visible = lopen
		if lopen then refreshList() end
	end
end)

-- =============================================================================
-- MAIN LOOPS
-- =============================================================================
local fps,acc,xrayT=0,0,0

RunService.RenderStepped:Connect(function(dt)
	fps+=1 acc+=dt
	local t=tick()
	local rainbow=Color3.fromHSV((t*0.2)%1,1,1)
	local cam=workspace.CurrentCamera

	if S.RGBUI then setAccent(rainbow) end

	if acc>=1 then
		local ping=0 pcall(function() ping=math.floor(LP:GetNetworkPing()*1000) end)
		if S.Stats then sL.Text=string.format("FPS  %d\nPing %d ms\n%s",fps,ping,os.date("%H:%M:%S")) end
		if S.WM then WM.Text=string.format("w-script | fps %d | ping %d | %s",fps,ping,os.date("%H:%M")) end
		fps=0 acc=0
	end

	if S.SilentAim or S.FOVCircle then
		silentTarget = getClosestInFOV()
		FOVDraw.Visible = S.FOVCircle
		if S.FOVCircle then
			FOVDraw.Size = UDim2.new(0, S.FOVSize*2, 0, S.FOVSize*2)
			FOVStroke.Color = silentTarget and C.green or C.accent
		end
	else
		silentTarget=nil
		if not S.FOVCircle then FOVDraw.Visible=false end
	end

	local c,h,r = char(),hum(),root()

	if h then
		if S.WS then h.WalkSpeed=S.WSVal end
		if S.JP then h.JumpPower=S.JPVal h.UseJumpPower=true end
		if S.Bhop and h.FloorMaterial~=Enum.Material.Air then h.Jump=true end
	end

	if r and h then
		if S.CF and h.MoveDirection.Magnitude>0 then r.CFrame += h.MoveDirection*(S.CFVal/10) end
		local flyRoot, doFly = r, S.Fly
		if S.VehFly and h.SeatPart then doFly=true flyRoot=h.SeatPart.AssemblyRootPart or h.SeatPart end
		if doFly and cam then
			local f=(UIS:IsKeyDown(Enum.KeyCode.W) and 1 or 0)+(UIS:IsKeyDown(Enum.KeyCode.S) and -1 or 0)
			local s=(UIS:IsKeyDown(Enum.KeyCode.D) and 1 or 0)+(UIS:IsKeyDown(Enum.KeyCode.A) and -1 or 0)
			local u=(UIS:IsKeyDown(Enum.KeyCode.Space) and 1 or 0)+(UIS:IsKeyDown(Enum.KeyCode.LeftControl) and -1 or 0)
			local dir=cam.CFrame.LookVector*f + cam.CFrame.RightVector*s + Vector3.yAxis*u
			if dir.Magnitude>0 then dir=dir.Unit end
			flyRoot.AssemblyLinearVelocity = dir * S.FlySpeed
			if not h.SeatPart then h:ChangeState(Enum.HumanoidStateType.Freefall) end
		end
		if S.Float and not doFly then
			local v=r.AssemblyLinearVelocity r.AssemblyLinearVelocity=Vector3.new(v.X,0.55,v.Z)
		end
		if S.Spin then r.CFrame *= CFrame.Angles(0,math.rad(S.SpinSpd),0) end
		if S.Fling then r.AssemblyAngularVelocity=Vector3.new(1e5,1e5,1e5) end
		if S.Spider then
			local rp=RaycastParams.new() rp.FilterDescendantsInstances={c} rp.FilterType=Enum.RaycastFilterType.Exclude
			if workspace:Raycast(r.Position, r.CFrame.LookVector*2.2, rp) then
				r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,42,r.AssemblyLinearVelocity.Z)
			end
		end
		if S.FakeLag then
			S._lagT += dt
			if S._lagT >= S.LagSec then S._lagT=0 r.Anchored=not r.Anchored end
		end
		if S.Ghost then
			for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.LocalTransparencyModifier=0.75 end end
		end
		if S.AutoStrafe and h and cam and not doFly then
			local moveDir = h.MoveDirection
			if moveDir.Magnitude > 0 then
				local look = cam.CFrame.LookVector
				local right = cam.CFrame.RightVector
				local vel = r.AssemblyLinearVelocity
				local f = moveDir:Dot(look)
				local s = moveDir:Dot(right)
				r.CFrame = CFrame.new(r.Position, r.Position + look*f + right*s + Vector3.new(0,vel.Y,0))
			end
		end
		if S.EdgeBug and h then
			local vv = r.AssemblyLinearVelocity
			if math.abs(vv.Y) > 120 then
				r.Velocity = Vector3.new(0,0,0)
			end
		end
		if S.EdgeJump and h and h.FloorMaterial ~= Enum.Material.Air then
			h.Jump = true
		end
	end

	if cam then
		if S.FOV and cam.FieldOfView ~= S.FOVVal then cam.FieldOfView=S.FOVVal end
		if S.ThirdP then
			LP.CameraMode = Enum.CameraMode.Classic
			local d = S.ThirdDist
			if LP.CameraMinZoomDistance ~= d then LP.CameraMinZoomDistance = d end
			if LP.CameraMaxZoomDistance ~= d+0.001 then LP.CameraMaxZoomDistance = d+0.001 end
			forceVisibleCharacter()
		end
		if S.Bob and h and h.MoveDirection.Magnitude>0 and not S.Fly then
			local bt=t*11 cam.CFrame *= CFrame.new(math.sin(bt)*0.07, math.abs(math.cos(bt))*0.07, 0)
		end
		if S.Aimbot and r then
			local best,bd=nil,S.AimRange
			for _,p in ipairs(Players:GetPlayers()) do
				if p~=LP and p.Character then
					local part=p.Character:FindFirstChild(S.AimPart) or p.Character:FindFirstChild("Head")
					local hh=p.Character:FindFirstChildOfClass("Humanoid")
					if part and hh and hh.Health>0 then
						local dist=(r.Position-part.Position).Magnitude
						if dist<bd then bd=dist best=part end
					end
				end
			end
			if best then cam.CFrame=CFrame.new(cam.CFrame.Position,best.Position) end
		end
		if S.AntiAim and r then
			local yaw = math.rad(S.AntiAimYaw)
			cam.CFrame = CFrame.new(cam.CFrame.Position) * CFrame.Angles(0, yaw, 0)
		end
		-- trigger bot
		if S.TriggerBot and r then
			local camera = workspace.CurrentCamera
			local unit = camera.CFrame.LookVector
			for _,p in ipairs(Players:GetPlayers()) do
				if p~=LP and p.Character then
					local part = p.Character:FindFirstChild(S.AimPart) or p.Character:FindFirstChild("Head")
					local hh = p.Character:FindFirstChildOfClass("Humanoid")
					if part and hh and hh.Health>0 then
						local origin = camera.CFrame.Position
						local direction = (part.Position - origin)
						local dist = direction.Magnitude
						if dist <= S.AimRange then
							local unitDir = direction.Unit
							local dot = unit:Dot(unitDir)
							local angle = math.deg(math.acos(math.clamp(dot,-1,1)))
							if angle <= S.FOVSize/2 then
								if tick() - (S._triggerT or 0) >= S.TriggerDelay/1000 then
									S._triggerT = tick()
									local tool = char() and char():FindFirstChildOfClass("Tool")
									if tool then
										tool:Activate()
									end
								end
							end
						end
					end
				end
			end
		end
		-- auto shoot
		if S.AutoShoot and r then
			local tool = char() and char():FindFirstChildOfClass("Tool")
			if tool then
				local best = nil
				for _,p in ipairs(Players:GetPlayers()) do
					if p~=LP and p.Character then
						local part = p.Character:FindFirstChild(S.AimPart) or p.Character:FindFirstChild("Head")
						local hh = p.Character:FindFirstChildOfClass("Humanoid")
						if part and hh and hh.Health>0 then
							local dist = (r.Position - part.Position).Magnitude
							if dist <= S.AimRange then
								best = part
							end
						end
					end
				end
				if best then tool:Activate() end
			end
		end
		-- resolver
		if S.Resolver and r then
			for _,p in ipairs(Players:GetPlayers()) do
				if p~=LP and p.Character then
					local hrp = p.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						local hrpPos = hrp.Position
						if hitSave[hrp] then hrp.Size = hitSave[hrp] end
					end
				end
			end
		end
	end

	if S.Disco then Lighting.Ambient=rainbow Lighting.OutdoorAmbient=rainbow Lighting.ColorShift_Top=rainbow end
	if S.AutoTime then Lighting.ClockTime=(t*0.35)%24 end
	if S.NoFog then Lighting.FogEnd=1e9 Lighting.FogStart=1e9 end
	if S.CustomSky then
		Lighting.Brightness = 1
		Lighting.EnvironmentDiffuseScale = 0.8
		Lighting.EnvironmentSpecularScale = 0.5
		local sky = Lighting:FindFirstChildOfClass("Sky")
		if not sky then
			sky = Instance.new("Sky")
			sky.SkyboxBk = "rbxassetid://2786"
			sky.SkyboxDn = "rbxassetid://2786"
			sky.SkyboxLf = "rbxassetid://2786"
			sky.SkyboxRt = "rbxassetid://2786"
			sky.SkyboxTl = "rbxassetid://2786"
			sky.SkyboxFt = "rbxassetid://"..(S.SkyColor.R*1000000+S.SkyColor.G*1000+S.SkyColor.B)
			sky.Parent = Lighting
		end
	end
	if S.ScreenGlitch then
		local cam = workspace.CurrentCamera
		if cam then cam.CFrame *= CFrame.new(0,0,0) * CFrame.Angles(0, t*50, 0) end
	end
	if S.ScreenChroma and cam then
		-- placeholder: would require Drawing API or GUI overlay for chromatic aberration
	end
	if S.ScreenVignette and cam then
		-- placeholder: would require Drawing API for vignette
	end

	local ecol = S.RGBEsp and rainbow or S.EspColor
	if S.Tracer then TracerFolder:ClearAllChildren() end
	if not S.Skeleton then
		if skeletonDraw then
			for _,lines in pairs(skeletonDraw) do
				for _,line in pairs(lines) do
					if line then line:Remove() end
				end
			end
			skeletonDraw = {}
		end
	end
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LP then
			local pc=p.Character
			if pc then
				local df=pc:FindFirstChild("W_DIST")
				if df and not S.DistanceESP then df:Destroy() end
			end
		end
	end
	if not S.Invisible and c then
		for _,p in ipairs(c:GetDescendants()) do
			if p:IsA("BasePart") then p.LocalTransparencyModifier=0 end
		end
	end

	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local pc,hrp,head,ph = p.Character, p.Character.HumanoidRootPart, p.Character:FindFirstChild("Head"), p.Character:FindFirstChildOfClass("Humanoid")
			if S.ESP then
				local hl=pc:FindFirstChild("W_HL")
				if not hl then hl=Instance.new("Highlight",pc) hl.Name="W_HL" hl.FillTransparency=0.55 hl.OutlineTransparency=0 end
				hl.FillColor=ecol hl.OutlineColor=ecol
			end
			if S.Box then
				local box=pc:FindFirstChild("W_BOX")
				if not box then
					box=Instance.new("BillboardGui",pc) box.Name="W_BOX" box.Adornee=hrp box.Size=UDim2.new(4,0,5.4,0) box.StudsOffset=Vector3.new(0,0.4,0) box.AlwaysOnTop=true
					local fr=Instance.new("Frame",box) fr.Size=UDim2.new(1,0,1,0) fr.BackgroundTransparency=1
					local st=Instance.new("UIStroke",fr) st.Name="S" st.Thickness=1.6
				end
				local st=box.Frame:FindFirstChild("S") if st then st.Color=ecol end
			end
			if S.NameESP and head then
				local nm=pc:FindFirstChild("W_NAME")
				if not nm then
					nm=Instance.new("BillboardGui",pc) nm.Name="W_NAME" nm.Adornee=head nm.Size=UDim2.new(0,140,0,18) nm.StudsOffset=Vector3.new(0,2.3,0) nm.AlwaysOnTop=true
					local tl=Instance.new("TextLabel",nm) tl.Size=UDim2.new(1,0,1,0) tl.BackgroundTransparency=1 tl.Font=Enum.Font.Code tl.TextSize=12 tl.TextStrokeTransparency=0.4 tl.Text=p.DisplayName
				end
				local tl=nm:FindFirstChildOfClass("TextLabel") if tl then tl.TextColor3=ecol end
			end
			if S.HP and head and ph then
				local hp=pc:FindFirstChild("W_HP")
				if not hp then
					hp=Instance.new("BillboardGui",pc) hp.Name="W_HP" hp.Adornee=head hp.Size=UDim2.new(0,42,0,4) hp.StudsOffset=Vector3.new(0,2.8,0) hp.AlwaysOnTop=true
					local bg=Instance.new("Frame",hp) bg.Size=UDim2.new(1,0,1,0) bg.BackgroundColor3=Color3.fromRGB(30,30,30) bg.BorderSizePixel=0
					local fill=Instance.new("Frame",bg) fill.Name="F" fill.Size=UDim2.new(1,0,1,0) fill.BorderSizePixel=0
				end
				local fill=hp.Frame:FindFirstChild("F")
				if fill then local pct=math.clamp(ph.Health/math.max(ph.MaxHealth,1),0,1) fill.Size=UDim2.new(pct,0,1,0) fill.BackgroundColor3=Color3.fromRGB(255*(1-pct),220*pct,60) end
			end
			if S.Tracer and r then
				local a0=r:FindFirstChild("W_TA0") or Instance.new("Attachment",r) a0.Name="W_TA0"
				local a1=hrp:FindFirstChild("W_TA1") or Instance.new("Attachment",hrp) a1.Name="W_TA1"
				local beam=TracerFolder:FindFirstChild(p.Name) or Instance.new("Beam",TracerFolder)
				beam.Name=p.Name beam.Attachment0=a0 beam.Attachment1=a1 beam.Width0=0.05 beam.Width1=0.05 beam.FaceCamera=true beam.LightEmission=1
				beam.Color=ColorSequence.new(ecol)
			end
			if S.Skeleton and pc then
				if not skeletonDraw then skeletonDraw = {} end
				if not skeletonDraw[p.Name] then skeletonDraw[p.Name] = {} end
				local bones = {"Head","UpperTorso","LowerTorso","LeftArm","RightArm","LeftLeg","RightLeg"}
				local positions = {}
				for _,boneName in ipairs(bones) do
					local bone = pc:FindFirstChild(boneName)
					if bone then positions[boneName] = bone.Position end
				end
				local connections = {
					{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
					{"UpperTorso","LeftArm"},{"UpperTorso","RightArm"},
					{"LowerTorso","LeftLeg"},{"LowerTorso","RightLeg"},
				}
				local cam = workspace.CurrentCamera
				for _,conn in ipairs(connections) do
					local from, to = positions[conn[1]], positions[conn[2]]
					if from and to then
						local sf = cam:WorldToViewportPoint(from)
						local st = cam:WorldToViewportPoint(to)
						if sf.Z > 0 and st.Z > 0 then
							local key = conn[1].."_"..conn[2]
							local line = skeletonDraw[p.Name][key]
							if not line then
								line = Drawing.new("Line")
								line.Thickness = 2
								skeletonDraw[p.Name][key] = line
							end
							line.Color = ecol
							line.From = Vector2.new(sf.X, sf.Y)
							line.To = Vector2.new(st.X, st.Y)
							line.Visible = true
						end
					end
				end
			end
			if S.DistanceESP and hrp then
				local dist = math.floor((r.Position - hrp.Position).Magnitude)
				local df = pc:FindFirstChild("W_DIST")
				if not df then
					df = Instance.new("BillboardGui",pc) df.Name="W_DIST" df.Adornee=hrp df.Size=UDim2.new(0,80,0,18) df.StudsOffset=Vector3.new(0,4,0) df.AlwaysOnTop=true
					local dl = Instance.new("TextLabel",df) dl.Size=UDim2.new(1,0,1,0) dl.BackgroundTransparency=1 dl.Font=Enum.Font.Code dl.TextSize=12 dl.TextColor3=C.orange
				end
				local dl = df:FindFirstChildOfClass("TextLabel")
				if dl then dl.Text = dist .. "m" end
			end
			if S.NameHP and head and ph then
				local nm=pc:FindFirstChild("W_NAME")
				if not nm then
					nm=Instance.new("BillboardGui",pc) nm.Name="W_NAME" nm.Adornee=head nm.Size=UDim2.new(0,160,0,18) nm.StudsOffset=Vector3.new(0,2.3,0) nm.AlwaysOnTop=true
					local tl=Instance.new("TextLabel",nm) tl.Size=UDim2.new(1,0,1,0) tl.BackgroundTransparency=1 tl.Font=Enum.Font.Code tl.TextSize=12 tl.TextStrokeTransparency=0.4 tl.Text=p.DisplayName
				end
				local tl=nm:FindFirstChildOfClass("TextLabel")
				if tl then
					local pct=math.clamp(ph.Health/math.max(ph.MaxHealth,1),0,1)
					tl.Text = p.DisplayName .. " [" .. math.floor(pct*100) .. "%]"
					tl.TextColor3 = Color3.fromRGB(255*(1-pct),220*pct,60)
				end
			end
			if S.Invisible then
				for _,part in ipairs(pc:GetDescendants()) do
					if part:IsA("BasePart") then
						part.LocalTransparencyModifier = 1
					end
				end
			end
		end
	end

	local fxCol = S.RGBEsp and rainbow or S.FXColor
	if c and r then
		if S.Halo and c:FindFirstChild("Head") then
			if not FX.halo then
				FX.halo=Instance.new("Part",workspace) FX.halo.Size=Vector3.new(1.55,0.12,1.55) FX.halo.Shape=Enum.PartType.Cylinder
				FX.halo.Material=Enum.Material.Neon FX.halo.Anchored=true FX.halo.CanCollide=false FX.halo.CastShadow=false
			end
			FX.halo.Color=fxCol
			FX.halo.CFrame=c.Head.CFrame*CFrame.new(0,1.25+math.sin(t*3)*0.12,0)*CFrame.Angles(math.rad(90),t*2,0)
		end
		if S.Hat and c:FindFirstChild("Head") then
			if not FX.hat then
				FX.hat=Instance.new("Part",workspace) FX.hat.Anchored=true FX.hat.CanCollide=false FX.hat.Material=Enum.Material.Neon FX.hat.Transparency=0.25
				local m=Instance.new("SpecialMesh",FX.hat) m.MeshType=Enum.MeshType.FileMesh m.MeshId="rbxassetid://1778999" m.Scale=Vector3.new(1.15,0.55,1.15)
			end
			FX.hat.Color=fxCol FX.hat.CFrame=c.Head.CFrame*CFrame.new(0,0.85,0)
		end
		if S.Trail then
			if not FX.trail then
				FX.a0=Instance.new("Attachment",r) FX.a0.Position=Vector3.new(0,1.1,0)
				FX.a1=Instance.new("Attachment",r) FX.a1.Position=Vector3.new(0,-1.1,0)
				FX.trail=Instance.new("Trail",r) FX.trail.Attachment0=FX.a0 FX.trail.Attachment1=FX.a1 FX.trail.Lifetime=0.5 FX.trail.FaceCamera=true
				FX.trail.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,1)})
				FX.trail.WidthScale=NumberSequence.new(1,0)
			end
			FX.trail.Color=ColorSequence.new(fxCol)
		end
		if S.Fire and not r:FindFirstChild("W_Fire") then local f=Instance.new("Fire",r) f.Name="W_Fire" f.Size=7 end
		if S.Sparks and not r:FindFirstChild("W_Spark") then local s=Instance.new("Sparkles",r) s.Name="W_Spark" end
		if S.FF then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.Material=Enum.Material.ForceField p.Color=fxCol end end end
	end
end)

RunService.Stepped:Connect(function()
	local c=char() if not c then return end
	if S.Noclip then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
	if S.AntiFling then
		for _,p in ipairs(Players:GetPlayers()) do
			if p~=LP and p.Character then for _,bp in ipairs(p.Character:GetDescendants()) do if bp:IsA("BasePart") then bp.CanCollide=false bp.Massless=true end end end
		end
	end
	if S.AntiTeleport and c then
		local h = hum()
		if h then h.WalkSpeed = Def.WS end
	end
	if S.AntiKick and c then
		pcall(function() LP:Kick() end)
	end
	if S.Camp and r then
		local cam = workspace.CurrentCamera
		if cam then
			cam.CFrame = r.CFrame * CFrame.new(0, S.CampDist, 0) * CFrame.new(0,0,0) + Vector3.new(0,r.Position.Y,0)
		end
	end
	if S.AutoSteal then
		S._stealT = S._stealT or 0
		if tick() - S._stealT >= S.AutoStealDelay then
			S._stealT = tick()
			for _,p in ipairs(Players:GetPlayers()) do
				if p~=LP and p.Character then
					local hrp = p.Character:FindFirstChild("HumanoidRootPart")
					local h = p.Character:FindFirstChildOfClass("Humanoid")
					if hrp and h and h.Health > 0 then
						hrp.CFrame = hrp.CFrame + Vector3.new(0, -500, 0)
					end
				end
			end
		end
	end
	if S.FakeName and c then
		local nameLabel = c:FindFirstChild("NameDisplay") or Instance.new("BillboardGui")
		for _,p in ipairs(c:GetDescendants()) do
			if p:IsA("BillboardGui") and p.Name == "NameDisplay" then
			end
		end
	end
	if S.FakeLatency and r then
		r.Anchored = not r.Anchored
	end
end)

RunService.Heartbeat:Connect(function(dt)
	if S.Hitbox then
		for _,p in ipairs(Players:GetPlayers()) do
			if p~=LP and p.Character then
				local hrp=p.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					if not hitSave[hrp] then hitSave[hrp]=hrp.Size end
					hrp.Size=Vector3.new(S.HitSize,S.HitSize,S.HitSize) hrp.Transparency=0.55 hrp.CanCollide=false hrp.Massless=true
				end
			end
		end
	end
	if S.Reach then
		local tool=char() and char():FindFirstChildOfClass("Tool")
		if tool and tool:FindFirstChild("Handle") then
			if not hitSave[tool.Handle] then hitSave[tool.Handle]=tool.Handle.Size end
			tool.Handle.Size=Vector3.new(S.HitSize,S.HitSize,S.HitSize) tool.Handle.Massless=true tool.Handle.Transparency=0.45
		end
	end
	if S.NeonWorld or S.PlasticWorld then
		local mat = S.NeonWorld and Enum.Material.Neon or Enum.Material.SmoothPlastic
		for _,o in ipairs(workspace:GetDescendants()) do
			if o:IsA("BasePart") and not o:IsDescendantOf(char() or nil) then
				if not matSave[o] then matSave[o]=o.Material end
				o.Material=mat
			end
		end
	end
	if S.XRay then
		xrayT+=dt
		if xrayT>0.35 then
			xrayT=0
			local cam=workspace.CurrentCamera
			if cam then
				for _,part in ipairs(workspace:GetPartBoundsInRadius(cam.CFrame.Position,45)) do
					if part:IsA("BasePart") and not part:IsDescendantOf(char() or nil) then
						if not xraySave[part] then xraySave[part]=part.LocalTransparencyModifier end
						part.LocalTransparencyModifier=0.7
					end
				end
			end
		end
	end
end)

UIS.JumpRequest:Connect(function()
	if S.InfJump then local h=hum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
end)

Mouse.Button1Down:Connect(function()
	if S.ClickTP and Mouse.Hit then local r=root() if r then r.CFrame=CFrame.new(Mouse.Hit.Position+Vector3.new(0,4,0)) end end
end)

pcall(function()
	LP.Idled:Connect(function()
		if not S.AntiAFK then return end
		local vu=game:GetService("VirtualUser") vu:CaptureController() vu:ClickButton2(Vector2.new())
	end)
end)

local open=true
local function setMenu(v) open=v Main.Visible=v XBtn.Modal=v end
setMenu(true)
XBtn.MouseButton1Click:Connect(function() setMenu(false) end)

UIS.InputBegan:Connect(function(input, gp)
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	if waitingBind then
		local id=waitingBind waitingBind=nil
		Registry.Binds[id]=input.KeyCode
		if Registry.BindUI[id] then Registry.BindUI[id]() end
		Notify("bound "..tostring(input.KeyCode):gsub("Enum.KeyCode.",""),2,C.green)
		return
	end
	local key=input.KeyCode
	if key==Registry.Binds.Menu then setMenu(not open) return end
	if gp then return end
	if key==Registry.Binds.Dash then
		local r=root() local cam=workspace.CurrentCamera
		if r and cam then r.CFrame += cam.CFrame.LookVector * S.DashDist Notify("dash",0.8,C.green) end
		return
	end
	for bindId, toggleId in pairs(bindMap) do
		if Registry.Binds[bindId]==key then
			local tog=Registry.Toggles[toggleId]
			if tog then tog.set(not tog.get(), true) end
		end
	end
end)

Notify("loaded | K menu | RMB customize | cfg tab", 3.5, C.green)