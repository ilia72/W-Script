-- =============================================================================
-- THEME (colors, accent system, corner, drag)
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
return {
	C = C,
	markAccent = markAccent,
	setAccent = setAccent,
	corner = corner,
	drag = drag,
}
