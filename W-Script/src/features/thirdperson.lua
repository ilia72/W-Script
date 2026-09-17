-- =============================================================================
-- FEATURE: 3RD PERSON (force visible + camera lock)
-- =============================================================================
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

return {
	forceVisibleCharacter = forceVisibleCharacter,
	enableThirdPerson = enableThirdPerson,
	disableThirdPerson = disableThirdPerson,
}
