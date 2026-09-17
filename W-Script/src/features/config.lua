-- =============================================================================
-- FEATURE: CFG SYSTEM (save/load/export/import)
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

return {
	exportConfig = exportConfig,
	applyConfig = applyConfig,
	saveConfig = saveConfig,
	loadConfig = loadConfig,
	listConfigs = listConfigs,
	ensureFolder = ensureFolder,
	canFS = canFS,
}
