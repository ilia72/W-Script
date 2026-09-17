-- =============================================================================
-- CORE: Main loops (RenderStepped, Stepped, Heartbeat)
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
	end

	if S.Disco then Lighting.Ambient=rainbow Lighting.OutdoorAmbient=rainbow Lighting.ColorShift_Top=rainbow end
	if S.AutoTime then Lighting.ClockTime=(t*0.35)%24 end
	if S.NoFog then Lighting.FogEnd=1e9 Lighting.FogStart=1e9 end

	local ecol = S.RGBEsp and rainbow or S.EspColor
	if S.Tracer then TracerFolder:ClearAllChildren() end

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
