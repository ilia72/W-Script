-- =============================================================================
-- FEATURE: SILENT AIM + FOV CIRCLE
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

local rawIndex, rawNewIndex
local silentTarget = nil

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

return {
	FOVDraw = FOVDraw,
	FOVStroke = FOVStroke,
	getClosestInFOV = getClosestInFOV,
	silentTarget = function() return silentTarget end,
	setSilentTarget = function(v) silentTarget = v end,
}
