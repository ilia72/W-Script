-- =============================================================================
-- HELPERS (character, resets, hardOff)
-- =============================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

local function char() return LP.Character end
local function hum() local c=char() return c and c:FindFirstChildOfClass("Humanoid") end
local function root() local c=char() return c and c:FindFirstChild("HumanoidRootPart") end

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
	elseif id=="Spin" or id=="Fling" then local r=root() if r then r.AssemblyAngularVelocity=Vector3.zero end
	elseif id=="FakeLag" then local r=root() if r then r.Anchored=false end
	elseif id=="Hitbox" or id=="Reach" then resetHit()
	elseif id=="ESP" or id=="Box" or id=="NameESP" or id=="HP" or id=="Tracer" then clearESP()
	elseif id=="Halo" or id=="Hat" or id=="Trail" or id=="Fire" or id=="Sparks" then clearFX()
	elseif id=="Fullbright" or id=="Disco" or id=="AutoTime" or id=="NoFog" then resetLight()
	elseif id=="XRay" then resetXray()
	elseif id=="NeonWorld" or id=="PlasticWorld" then resetMats()
	elseif id=="SilentAim" or id=="Aimbot" or id=="FOVCircle" then end
end

return {
	char = char, hum = hum, root = root,
	resetFly = resetFly, resetSpeed = resetSpeed, resetNoclip = resetNoclip,
	resetGhostFF = resetGhostFF, clearESP = clearESP, resetHit = resetHit,
	clearFX = clearFX, resetMats = resetMats, resetXray = resetXray,
	resetLight = resetLight, resetFOV = resetFOV, hardOff = hardOff,
}
