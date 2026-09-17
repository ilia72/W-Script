-- =============================================================================
-- CORE: Input handling (binds, menu, dash, anti-AFK)
-- =============================================================================
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
