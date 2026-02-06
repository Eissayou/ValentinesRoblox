--[[
	Valentine's Day Environment Server Script
	Creates a large romantic venue with a red carpet leading to a cute white dog.
]]

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")
local TweenService = game:GetService("TweenService")

---------------------------------------------------------------
-- STEP 1: Remove default spawn locations ONLY (not Terrain/Camera)
---------------------------------------------------------------
for _, child in pairs(Workspace:GetChildren()) do
	if child:IsA("SpawnLocation") then
		child:Destroy()
	end
	-- Remove any default baseplate
	if child:IsA("Part") and (child.Name == "Baseplate" or child.Name == "Base") then
		child:Destroy()
	end
end

---------------------------------------------------------------
-- STEP 2: Create our SpawnLocation FIRST so players always have
--         somewhere valid to spawn (directly in Workspace).
---------------------------------------------------------------
local FLOOR_Y = 1 -- top of floor will be at Y=2

local spawnLocation = Instance.new("SpawnLocation")
spawnLocation.Name = "ValentineSpawn"
spawnLocation.Anchored = true
spawnLocation.Size = Vector3.new(12, 1, 12)
spawnLocation.Position = Vector3.new(0, FLOOR_Y + 1.5, 50) -- on top of floor, near entrance end
spawnLocation.Transparency = 1
spawnLocation.CanCollide = false -- so it doesn't block walking
spawnLocation.Neutral = true -- IMPORTANT: lets any player spawn here
spawnLocation.Duration = 0
spawnLocation.Enabled = true
spawnLocation.TopSurface = Enum.SurfaceType.Smooth
spawnLocation.BottomSurface = Enum.SurfaceType.Smooth
spawnLocation.Parent = Workspace -- parent directly to Workspace so it works immediately

print("SpawnLocation created at:", spawnLocation.Position)

---------------------------------------------------------------
-- STEP 3: Lighting
---------------------------------------------------------------
Lighting.Ambient = Color3.fromRGB(80, 55, 65)
Lighting.Brightness = 0.8
Lighting.ClockTime = 15
Lighting.GlobalShadows = true
Lighting.OutdoorAmbient = Color3.fromRGB(70, 50, 60)

---------------------------------------------------------------
-- HELPER
---------------------------------------------------------------
local function makePart(parent, name, size, position, color, material)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.Position = position
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

---------------------------------------------------------------
-- COLORS
---------------------------------------------------------------
local PINK       = Color3.fromRGB(255, 182, 193)
local DEEP_PINK  = Color3.fromRGB(255, 105, 140)
local SOFT_PINK  = Color3.fromRGB(255, 200, 210)
local RED        = Color3.fromRGB(200, 30, 30)
local CARPET_RED = Color3.fromRGB(140, 20, 30)
local WHITE      = Color3.fromRGB(255, 255, 255)
local CREAM      = Color3.fromRGB(255, 245, 238)
local LIGHT_PINK = Color3.fromRGB(255, 220, 230)
local WALL_PINK  = Color3.fromRGB(255, 200, 215)
local GOLD       = Color3.fromRGB(255, 200, 80)
local NOSE_BLACK = Color3.fromRGB(30, 30, 30)
local EYE_COLOR  = Color3.fromRGB(50, 30, 20)
local ROSE_RED   = Color3.fromRGB(180, 20, 50)
local STEM_GREEN = Color3.fromRGB(60, 100, 50)
local DARK_PINK  = Color3.fromRGB(180, 80, 100)

---------------------------------------------------------------
-- ROOM DIMENSIONS
---------------------------------------------------------------
local ROOM_W = 100
local ROOM_L = 150
local ROOM_H = 35
local WALL_T = 3

---------------------------------------------------------------
-- STEP 4: Build the venue
---------------------------------------------------------------
local building = Instance.new("Model")
building.Name = "ValentineVenue"

-- FLOOR (top surface at Y = FLOOR_Y + 1 = 2)
makePart(building, "Floor",
	Vector3.new(ROOM_W, 2, ROOM_L),
	Vector3.new(0, FLOOR_Y, 0),
	CREAM, Enum.Material.Marble)

-- CEILING
makePart(building, "Ceiling",
	Vector3.new(ROOM_W, 2, ROOM_L),
	Vector3.new(0, FLOOR_Y + ROOM_H, 0),
	LIGHT_PINK)

-- WALLS
makePart(building, "BackWall",
	Vector3.new(ROOM_W, ROOM_H, WALL_T),
	Vector3.new(0, FLOOR_Y + ROOM_H/2, -ROOM_L/2),
	WALL_PINK)

makePart(building, "FrontWall",
	Vector3.new(ROOM_W, ROOM_H, WALL_T),
	Vector3.new(0, FLOOR_Y + ROOM_H/2, ROOM_L/2),
	WALL_PINK)

makePart(building, "LeftWall",
	Vector3.new(WALL_T, ROOM_H, ROOM_L),
	Vector3.new(-ROOM_W/2, FLOOR_Y + ROOM_H/2, 0),
	WALL_PINK)

makePart(building, "RightWall",
	Vector3.new(WALL_T, ROOM_H, ROOM_L),
	Vector3.new(ROOM_W/2, FLOOR_Y + ROOM_H/2, 0),
	WALL_PINK)

-- WHITE BASEBOARDS
makePart(building, "BaseboardL",
	Vector3.new(1, 3, ROOM_L),
	Vector3.new(-ROOM_W/2 + WALL_T + 0.5, FLOOR_Y + 2.5, 0),
	WHITE)

makePart(building, "BaseboardR",
	Vector3.new(1, 3, ROOM_L),
	Vector3.new(ROOM_W/2 - WALL_T - 0.5, FLOOR_Y + 2.5, 0),
	WHITE)

-- CEILING MOLDING
makePart(building, "MoldL", Vector3.new(3, 4, ROOM_L), Vector3.new(-ROOM_W/2+1.5, FLOOR_Y+ROOM_H-2, 0), WHITE)
makePart(building, "MoldR", Vector3.new(3, 4, ROOM_L), Vector3.new(ROOM_W/2-1.5, FLOOR_Y+ROOM_H-2, 0), WHITE)
makePart(building, "MoldB", Vector3.new(ROOM_W, 4, 3), Vector3.new(0, FLOOR_Y+ROOM_H-2, -ROOM_L/2+1.5), WHITE)
makePart(building, "MoldF", Vector3.new(ROOM_W, 4, 3), Vector3.new(0, FLOOR_Y+ROOM_H-2, ROOM_L/2-1.5), WHITE)

-- FLOOR BORDER
makePart(building, "FloorBorderL", Vector3.new(4, 2.05, ROOM_L), Vector3.new(-ROOM_W/2+2, FLOOR_Y, 0), SOFT_PINK, Enum.Material.Marble)
makePart(building, "FloorBorderR", Vector3.new(4, 2.05, ROOM_L), Vector3.new(ROOM_W/2-2, FLOOR_Y, 0), SOFT_PINK, Enum.Material.Marble)

print("Walls and floor done.")

---------------------------------------------------------------
-- RED CARPET
---------------------------------------------------------------
local CARPET_W = 14
local CARPET_L = ROOM_L - 30
local CARPET_Y = FLOOR_Y + 2.1 -- just above floor surface

makePart(building, "RedCarpet",
	Vector3.new(CARPET_W, 0.2, CARPET_L),
	Vector3.new(0, CARPET_Y, 0),
	CARPET_RED, Enum.Material.Fabric)

makePart(building, "TrimL", Vector3.new(1, 0.25, CARPET_L), Vector3.new(-CARPET_W/2-0.5, CARPET_Y, 0), GOLD)
makePart(building, "TrimR", Vector3.new(1, 0.25, CARPET_L), Vector3.new(CARPET_W/2+0.5, CARPET_Y, 0), GOLD)

print("Carpet done.")

---------------------------------------------------------------
-- HEARTS (on walls)
---------------------------------------------------------------
local function makeHeart(parent, pos, size, color)
	local m = Instance.new("Model")
	m.Name = "Heart"

	local function ball(p, s)
		local b = Instance.new("Part")
		b.Shape = Enum.PartType.Ball
		b.Size = Vector3.new(s, s, s*0.6)
		b.Position = p
		b.Color = color
		b.Anchored = true
		b.Material = Enum.Material.Neon
		b.Parent = m
		return b
	end

	local lb = ball(pos + Vector3.new(-size*0.25, size*0.2, 0), size)
	ball(pos + Vector3.new(size*0.25, size*0.2, 0), size)

	local bottom = Instance.new("Part")
	bottom.Size = Vector3.new(size*0.9, size*0.7, size*0.4)
	bottom.CFrame = CFrame.new(pos + Vector3.new(0, -size*0.15, 0)) * CFrame.Angles(0, 0, math.rad(45))
	bottom.Color = color
	bottom.Anchored = true
	bottom.Material = Enum.Material.Neon
	bottom.Parent = m

	local light = Instance.new("PointLight")
	light.Color = color
	light.Brightness = 0.15
	light.Range = size * 3
	light.Parent = lb

	m.Parent = parent
end

for i = 1, 8 do
	local z = -ROOM_L/2 + 15 + (i-1)*18
	makeHeart(building, Vector3.new(-ROOM_W/2+4, FLOOR_Y+20, z), 4, DEEP_PINK)
	makeHeart(building, Vector3.new(ROOM_W/2-4, FLOOR_Y+20, z), 4, DEEP_PINK)
end

-- Big heart behind dog
makeHeart(building, Vector3.new(0, FLOOR_Y+25, -ROOM_L/2+4), 8, RED)

-- Smaller hearts lower
for i = 1, 5 do
	local z = -ROOM_L/2 + 30 + (i-1)*28
	makeHeart(building, Vector3.new(-ROOM_W/2+4, FLOOR_Y+10, z), 2.5, PINK)
	makeHeart(building, Vector3.new(ROOM_W/2-4, FLOOR_Y+10, z), 2.5, PINK)
end

print("Hearts done.")

---------------------------------------------------------------
-- ROSE PEDESTALS
---------------------------------------------------------------
local function makeRosePedestal(parent, pos, tall)
	local h = tall and 5 or 3.5
	local col = Instance.new("Part")
	col.Shape = Enum.PartType.Cylinder
	col.Size = Vector3.new(h, 1.8, 1.8)
	col.CFrame = CFrame.new(pos + Vector3.new(0, h/2, 0)) * CFrame.Angles(0, 0, math.rad(90))
	col.Color = WHITE
	col.Material = Enum.Material.Marble
	col.Anchored = true
	col.Parent = parent

	local rose = Instance.new("Part")
	rose.Shape = Enum.PartType.Ball
	rose.Size = Vector3.new(1.6, 1.6, 1.6)
	rose.Position = pos + Vector3.new(0, h + 1, 0)
	rose.Color = ROSE_RED
	rose.Anchored = true
	rose.Parent = parent

	local stem = makePart(parent, "Stem", Vector3.new(0.25, 2, 0.25), pos + Vector3.new(0, h, 0), STEM_GREEN)

	local gl = Instance.new("PointLight")
	gl.Color = PINK
	gl.Brightness = 0.15
	gl.Range = 12
	gl.Parent = rose
end

for i = 0, 6 do
	local z = ROOM_L/2 - 20 - i*20
	makeRosePedestal(building, Vector3.new(-CARPET_W/2-6, FLOOR_Y+2, z), i%2==0)
	makeRosePedestal(building, Vector3.new(CARPET_W/2+6, FLOOR_Y+2, z), i%2==0)
end

print("Pedestals done.")

---------------------------------------------------------------
-- CHANDELIERS
---------------------------------------------------------------
local function makeChandelier(parent, pos, size)
	local center = Instance.new("Part")
	center.Shape = Enum.PartType.Ball
	center.Size = Vector3.new(size*0.4, size*0.4, size*0.4)
	center.Position = pos
	center.Color = Color3.fromRGB(255, 240, 200)
	center.Material = Enum.Material.Neon
	center.Transparency = 0.2
	center.Anchored = true
	center.Parent = parent

	local ml = Instance.new("PointLight")
	ml.Color = Color3.fromRGB(255, 225, 210)
	ml.Brightness = 0.35
	ml.Range = 45
	ml.Parent = center

	local ring = Instance.new("Part")
	ring.Shape = Enum.PartType.Cylinder
	ring.Size = Vector3.new(2, size, size)
	ring.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
	ring.Color = GOLD
	ring.Anchored = true
	ring.Parent = parent

	for angle = 0, 300, 60 do
		local rad = math.rad(angle)
		local cp = pos + Vector3.new(math.cos(rad)*size/2*0.8, -2, math.sin(rad)*size/2*0.8)
		local crystal = Instance.new("Part")
		crystal.Size = Vector3.new(0.5, 2, 0.5)
		crystal.Position = cp
		crystal.Color = LIGHT_PINK
		crystal.Material = Enum.Material.Glass
		crystal.Transparency = 0.4
		crystal.Anchored = true
		crystal.Parent = parent

		local sp = Instance.new("PointLight")
		sp.Color = PINK
		sp.Brightness = 0.1
		sp.Range = 10
		sp.Parent = crystal
	end

	local chain = makePart(parent, "Chain", Vector3.new(0.5, 6, 0.5), pos + Vector3.new(0, 4, 0), GOLD)
end

for i = 1, 5 do
	local z = -ROOM_L/2 + 25 + (i-1)*30
	makeChandelier(building, Vector3.new(0, FLOOR_Y+ROOM_H-8, z), 12)
end

for i = 1, 4 do
	local z = -ROOM_L/2 + 35 + (i-1)*35
	makeChandelier(building, Vector3.new(-ROOM_W/4, FLOOR_Y+ROOM_H-10, z), 8)
	makeChandelier(building, Vector3.new(ROOM_W/4, FLOOR_Y+ROOM_H-10, z), 8)
end

print("Chandeliers done.")

---------------------------------------------------------------
-- ARCHES along walls
---------------------------------------------------------------
for i = 1, 4 do
	local z = -ROOM_L/2 + 30 + (i-1)*35
	-- Left wall arches
	makePart(building, "ArchPillarLL"..i, Vector3.new(2, 20, 2), Vector3.new(-ROOM_W/2+8, FLOOR_Y+11, z-4), WHITE, Enum.Material.Marble)
	makePart(building, "ArchPillarLR"..i, Vector3.new(2, 20, 2), Vector3.new(-ROOM_W/2+8, FLOOR_Y+11, z+4), WHITE, Enum.Material.Marble)
	makePart(building, "ArchTopL"..i, Vector3.new(2, 3, 10), Vector3.new(-ROOM_W/2+8, FLOOR_Y+22, z), WHITE, Enum.Material.Marble)
	-- Right wall arches
	makePart(building, "ArchPillarRL"..i, Vector3.new(2, 20, 2), Vector3.new(ROOM_W/2-8, FLOOR_Y+11, z-4), WHITE, Enum.Material.Marble)
	makePart(building, "ArchPillarRR"..i, Vector3.new(2, 20, 2), Vector3.new(ROOM_W/2-8, FLOOR_Y+11, z+4), WHITE, Enum.Material.Marble)
	makePart(building, "ArchTopR"..i, Vector3.new(2, 3, 10), Vector3.new(ROOM_W/2-8, FLOOR_Y+22, z), WHITE, Enum.Material.Marble)
end

print("Arches done.")

---------------------------------------------------------------
-- STAGE for the dog
---------------------------------------------------------------
makePart(building, "Stage",
	Vector3.new(30, 2, 20),
	Vector3.new(0, FLOOR_Y+2, -ROOM_L/2+20),
	CREAM, Enum.Material.Marble)

makePart(building, "StageStep1",
	Vector3.new(CARPET_W+4, 1, 3),
	Vector3.new(0, FLOOR_Y+1.5, -ROOM_L/2+32),
	CREAM, Enum.Material.Marble)

makePart(building, "StageCarpet",
	Vector3.new(20, 0.2, 12),
	Vector3.new(0, FLOOR_Y+3.15, -ROOM_L/2+18),
	CARPET_RED, Enum.Material.Fabric)

print("Stage done.")

---------------------------------------------------------------
-- COCO THE DOG (loaded from Toolbox model)
---------------------------------------------------------------
local DOG_POS = Vector3.new(0, FLOOR_Y + 3.2, -ROOM_L/2 + 16)

-- Load the dog model from the asset
local dogModel = nil
local success, dogAsset = pcall(function()
	return InsertService:LoadAsset(18912181105)
end)

if success and dogAsset then
	-- Find the model inside the container and clone it out
	for _, child in ipairs(dogAsset:GetChildren()) do
		if child:IsA("Model") or child:IsA("BasePart") then
			dogModel = child:Clone()
			break
		end
	end
	dogAsset:Destroy() -- destroy the locked container
	
	if dogModel then
		dogModel.Name = "Coco"
		
		-- Position the dog
		if dogModel:IsA("Model") then
			if not dogModel.PrimaryPart then
				dogModel.PrimaryPart = dogModel:FindFirstChildWhichIsA("BasePart", true)
			end
			if dogModel.PrimaryPart then
				-- Position and rotate to face forward (180 degrees)
				dogModel:PivotTo(CFrame.new(DOG_POS) * CFrame.Angles(0, math.rad(180), 0))
			else
				dogModel:MoveTo(DOG_POS)
			end
			-- Scale the dog to be slightly bigger
			dogModel:ScaleTo(1.5)
		elseif dogModel:IsA("BasePart") then
			dogModel.Position = DOG_POS
			dogModel.CFrame = dogModel.CFrame * CFrame.Angles(0, math.rad(180), 0)
		end
		
		dogModel.Parent = building
		print("✓ Loaded Coco the dog from Toolbox")
	else
		warn("No model found inside dog asset")
	end
else
	warn("Failed to load dog model: " .. tostring(dogAsset))
end

-- If model failed to load, create a simple fallback
if not dogModel then
	dogModel = Instance.new("Model")
	dogModel.Name = "Coco"
	local fallbackBody = makePart(building, "Body", Vector3.new(3, 2, 2), DOG_POS, WHITE)
	dogModel.PrimaryPart = fallbackBody
	fallbackBody.Parent = dogModel
	dogModel.Parent = building
end

-- Spotlight on dog
local spotMount = makePart(building, "SpotMount",
	Vector3.new(2, 2, 2),
	DOG_POS + Vector3.new(0, 22, 0),
	DARK_PINK)
spotMount.Transparency = 1
local spot = Instance.new("SpotLight")
spot.Brightness = 1
spot.Color = Color3.fromRGB(255, 235, 225)
spot.Range = 35
spot.Angle = 40
spot.Face = Enum.NormalId.Bottom
spot.Parent = spotMount

-- ProximityPrompt to trigger the Valentine dialog
local promptPart = Instance.new("Part")
promptPart.Name = "DialogPart"
promptPart.Size = Vector3.new(3, 3, 3)
promptPart.Position = DOG_POS + Vector3.new(0, 4, 0) -- above her head
promptPart.Transparency = 1
promptPart.CanCollide = false
promptPart.Anchored = true
promptPart.Parent = building -- parent to building instead of model

local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Talk"
prompt.ObjectText = "Coco 🐾"
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.HoldDuration = 0
prompt.MaxActivationDistance = 15
prompt.RequiresLineOfSight = false
prompt.Parent = promptPart

-- RemoteEvent for client dialog
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dialogEvent = Instance.new("RemoteEvent")
dialogEvent.Name = "ValentineDialogEvent"
dialogEvent.Parent = ReplicatedStorage

local celebEvent = Instance.new("RemoteEvent")
celebEvent.Name = "ValentineCelebEvent"
celebEvent.Parent = ReplicatedStorage

-- Fire dialog to the player who interacts
prompt.Triggered:Connect(function(player)
	print(player.Name .. " is talking to Coco!")
	dialogEvent:FireClient(player)
	-- Disable prompt so they can't retrigger during dialog
	prompt.Enabled = false
	task.delay(30, function()
		prompt.Enabled = true
	end)
end)

dogModel.Parent = building

print("Dog done.")

---------------------------------------------------------------
-- PETAL PARTICLES
---------------------------------------------------------------
local emitter = Instance.new("Part")
emitter.Name = "PetalEmitter"
emitter.Size = Vector3.new(ROOM_W - 10, 1, ROOM_L - 10)
emitter.Position = Vector3.new(0, FLOOR_Y + ROOM_H - 5, 0)
emitter.Transparency = 1
emitter.CanCollide = false
emitter.Anchored = true
emitter.Parent = building

local pe = Instance.new("ParticleEmitter")
pe.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, PINK),
	ColorSequenceKeypoint.new(0.5, DEEP_PINK),
	ColorSequenceKeypoint.new(1, LIGHT_PINK),
})
pe.Size = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.4),
	NumberSequenceKeypoint.new(0.5, 0.7),
	NumberSequenceKeypoint.new(1, 0.3),
})
pe.Lifetime = NumberRange.new(6, 12)
pe.Rate = 12
pe.Speed = NumberRange.new(0.3, 1)
pe.SpreadAngle = Vector2.new(180, 0)
pe.RotSpeed = NumberRange.new(-30, 30)
pe.Rotation = NumberRange.new(0, 360)
pe.EmissionDirection = Enum.NormalId.Bottom
pe.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.2),
	NumberSequenceKeypoint.new(0.5, 0),
	NumberSequenceKeypoint.new(1, 0.5),
})
pe.Parent = emitter

---------------------------------------------------------------
-- BANNER
---------------------------------------------------------------
local banner = makePart(building, "Banner",
	Vector3.new(30, 6, 0.5),
	Vector3.new(0, FLOOR_Y + 25, ROOM_L/2 - 10),
	DEEP_PINK, Enum.Material.Fabric)

local gui = Instance.new("SurfaceGui")
gui.Face = Enum.NormalId.Back
gui.Parent = banner
local txt = Instance.new("TextLabel")
txt.Size = UDim2.new(1,0,1,0)
txt.BackgroundTransparency = 1
txt.Text = "💕 Welcome 💕"
txt.TextColor3 = WHITE
txt.TextScaled = true
txt.Font = Enum.Font.GothamBold
txt.Parent = gui

local gui2 = Instance.new("SurfaceGui")
gui2.Face = Enum.NormalId.Front
gui2.Parent = banner
local txt2 = Instance.new("TextLabel")
txt2.Size = UDim2.new(1,0,1,0)
txt2.BackgroundTransparency = 1
txt2.Text = "💕 Welcome 💕"
txt2.TextColor3 = WHITE
txt2.TextScaled = true
txt2.Font = Enum.Font.GothamBold
txt2.Parent = gui2

---------------------------------------------------------------
-- STEP 5: Parent building to Workspace (everything appears)
---------------------------------------------------------------
building.Parent = Workspace

print("=== Valentine's environment ready! ===")
print("Total descendants:", #building:GetDescendants())

---------------------------------------------------------------
-- STEP 6: Force-respawn any players who loaded before the
--         building was ready (fixes falling-through-void)
---------------------------------------------------------------
task.wait(1)
for _, player in pairs(Players:GetPlayers()) do
	local char = player.Character
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			-- If they're below the floor, teleport them onto the spawn
			if hrp.Position.Y < FLOOR_Y then
				hrp.CFrame = CFrame.new(0, FLOOR_Y + 5, 50)
				print("Teleported", player.Name, "onto the floor")
			end
		end
	end
end

---------------------------------------------------------------
-- GANGNAM STYLE PARTY (triggered when player says YES)
---------------------------------------------------------------
local gangnamActive = false
local dancerModels = {}

local InsertService = game:GetService("InsertService")
local DANCER_MODEL_ID = 13738820581 -- Gangnam Style dancer model from Toolbox

local function spawnDancer(pos)
	-- Load the actual Gangnam Style dancer model
	local success, asset = pcall(function()
		return InsertService:LoadAsset(DANCER_MODEL_ID)
	end)
	
	if not success or not asset then
		warn("Failed to load dancer model: " .. tostring(asset))
		return nil
	end
	
	-- The model is inside the returned container
	local dancer = nil
	for _, child in ipairs(asset:GetChildren()) do
		if child:IsA("Model") then
			dancer = child
			break
		end
	end
	
	-- If no Model found, grab the first meaningful child
	if not dancer then
		for _, child in ipairs(asset:GetChildren()) do
			if child:IsA("BasePart") or child:IsA("Model") or child:IsA("Folder") then
				dancer = child
				break
			end
		end
	end
	
	if not dancer then
		warn("No dancer model found in loaded asset")
		asset:Destroy()
		return nil
	end

	-- Position the dancer at the target location
	dancer.Name = "GangnamDancer"
	
	-- Parent to workspace first
	dancer.Parent = Workspace
	
	-- Unanchor all parts so the Humanoid can animate
	for _, part in ipairs(dancer:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = false
		end
	end
	
	-- Move the model to the target position and rotate to face inward
	if dancer:IsA("Model") then
		-- Calculate rotation: dancers on left side face right (90°), right side face left (-90°)
		local rotation = 0
		if pos.X < 0 then
			rotation = math.rad(-90) -- left side, face right toward carpet
		else
			rotation = math.rad(90) -- right side, face left toward carpet
		end
		
		-- Position and rotate using PivotTo
		if dancer.PrimaryPart or dancer:FindFirstChildWhichIsA("BasePart") then
			if not dancer.PrimaryPart then
				dancer.PrimaryPart = dancer:FindFirstChildWhichIsA("BasePart")
			end
			dancer:PivotTo(CFrame.new(pos) * CFrame.Angles(0, rotation, 0))
		else
			dancer:MoveTo(pos)
		end
	else
		if dancer:IsA("BasePart") then
			dancer.Position = pos
		end
	end
	
	table.insert(dancerModels, dancer)
	
	-- Clean up the asset container
	asset:Destroy()
	
	-- Play the Gangnam Style animation using the published Animation ID
	local humanoid = dancer:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		-- Get or create Animator
		local animator = humanoid:FindFirstChildWhichIsA("Animator")
		if not animator then
			animator = Instance.new("Animator")
			animator.Parent = humanoid
		end
		
		-- Create Animation object with the published Gangnam Style dance
		local gangnamAnim = Instance.new("Animation")
		gangnamAnim.AnimationId = "rbxassetid://114433437268561"
		gangnamAnim.Name = "GangnamStyleDance"
		
		local success, track = pcall(function()
			return animator:LoadAnimation(gangnamAnim)
		end)
		
		if success and track then
			track.Looped = true
			track.Priority = Enum.AnimationPriority.Action
			track:Play()
			print("✓ GANGNAM STYLE DANCING!")
		else
			warn("Failed to load Gangnam animation: " .. tostring(track))
		end
	else
		warn("No Humanoid found in dancer model!")
	end

	return dancer
end

local function spawnFireworkBurst(pos)
	local emitPart = Instance.new("Part")
	emitPart.Size = Vector3.new(1, 1, 1)
	emitPart.Position = pos
	emitPart.Transparency = 1
	emitPart.CanCollide = false
	emitPart.Anchored = true
	emitPart.Parent = Workspace

	local colors = {
		Color3.fromRGB(255, 50, 80),
		Color3.fromRGB(255, 200, 50),
		Color3.fromRGB(100, 200, 255),
		Color3.fromRGB(255, 100, 255),
		Color3.fromRGB(80, 255, 80),
	}
	local c = colors[math.random(1, #colors)]

	local fw = Instance.new("ParticleEmitter")
	fw.Color = ColorSequence.new(c, Color3.fromRGB(255, 255, 200))
	fw.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.5), NumberSequenceKeypoint.new(1, 0)})
	fw.Lifetime = NumberRange.new(0.8, 1.5)
	fw.Rate = 0
	fw.Speed = NumberRange.new(20, 50)
	fw.SpreadAngle = Vector2.new(180, 180)
	fw.Drag = 4
	fw.LightEmission = 1
	fw.LightInfluence = 0
	fw.Brightness = 3
	fw.Parent = emitPart

	fw:Emit(80)

	local fwLight = Instance.new("PointLight")
	fwLight.Color = c
	fwLight.Brightness = 5
	fwLight.Range = 60
	fwLight.Parent = emitPart

	task.delay(0.3, function() fwLight.Brightness = 2 end)
	task.delay(0.6, function() fwLight:Destroy() end)
	task.delay(3, function() emitPart:Destroy() end)
end

local function startGangnamParty()
	if gangnamActive then return end
	gangnamActive = true
	print("=== GANGNAM STYLE PARTY STARTED ===")

	-- Play Jason's two audio tracks in sequence:
	-- Track 1 first, then Track 2 loops after
	task.spawn(function()
		-- TRACK 1: Plays first (intro/short clip)
		local music1 = Instance.new("Sound")
		music1.Name = "GangnamTrack1"
		music1.SoundId = "rbxassetid://108709108822851"
		music1.Volume = 1
		music1.Looped = false -- plays once then moves to track 2
		music1.PlayOnRemove = false
		music1.Parent = Workspace
		
		-- Wait for it to load
		local startWait = tick()
		while not music1.IsLoaded and (tick() - startWait) < 10 do
			task.wait(0.1)
		end
		
		if music1.IsLoaded then
			print("Track 1 loaded! Playing...")
			music1:Play()
			-- Wait for track 1 to finish
			music1.Ended:Wait()
			print("Track 1 finished, switching to Track 2...")
			music1:Destroy()
		else
			warn("Track 1 failed to load, skipping to Track 2...")
			music1:Destroy()
		end
		
		-- TRACK 2: Loops forever after Track 1
		local music2 = Instance.new("Sound")
		music2.Name = "GangnamTrack2"
		music2.SoundId = "rbxassetid://86468479687169"
		music2.Volume = 1
		music2.Looped = true -- loops forever
		music2.PlayOnRemove = false
		music2.Parent = Workspace
		
		local startWait2 = tick()
		while not music2.IsLoaded and (tick() - startWait2) < 10 do
			task.wait(0.1)
		end
		
		if music2.IsLoaded then
			print("Track 2 loaded! Playing (looped)...")
			music2:Play()
		else
			warn("Track 2 failed to load!")
		end
	end)

	-- Firework bursts
	task.spawn(function()
		for i = 1, 30 do
			local fwPos = Vector3.new(
				math.random(-ROOM_W/2 + 10, ROOM_W/2 - 10),
				FLOOR_Y + math.random(15, ROOM_H - 5),
				math.random(-ROOM_L/2 + 10, ROOM_L/2 - 10)
			)
			spawnFireworkBurst(fwPos)
			task.wait(0.4)
		end
		-- Keep occasional fireworks going
		while gangnamActive do
			local fwPos = Vector3.new(
				math.random(-ROOM_W/2 + 10, ROOM_W/2 - 10),
				FLOOR_Y + math.random(15, ROOM_H - 5),
				math.random(-ROOM_L/2 + 10, ROOM_L/2 - 10)
			)
			spawnFireworkBurst(fwPos)
			task.wait(math.random(10, 25) / 10)
		end
	end)

	-- Spawn dancers along both sides of the carpet
	local dancerPositions = {}
	for i = 0, 5 do
		local z = 40 - i * 18
		table.insert(dancerPositions, Vector3.new(-CARPET_W/2 - 10, FLOOR_Y + 2, z))
		table.insert(dancerPositions, Vector3.new(CARPET_W/2 + 10, FLOOR_Y + 2, z))
	end
	-- On the stage
	table.insert(dancerPositions, Vector3.new(-10, FLOOR_Y + 4.2, -ROOM_L/2 + 18))
	table.insert(dancerPositions, Vector3.new(10, FLOOR_Y + 4.2, -ROOM_L/2 + 18))
	-- Random spots around the room
	for i = 1, 6 do
		table.insert(dancerPositions, Vector3.new(
			math.random(-ROOM_W/2 + 15, ROOM_W/2 - 15),
			FLOOR_Y + 2,
			math.random(-ROOM_L/2 + 30, ROOM_L/2 - 15)
		))
	end

	-- Spawn in waves for dramatic effect
	for i, dpos in ipairs(dancerPositions) do
		task.delay(i * 0.2, function()
			if gangnamActive then
				spawnDancer(dpos)
			end
		end)
	end
end

-- Listen for YES from client
celebEvent.OnServerEvent:Connect(function(player)
	print(player.Name .. " said YES! GANGNAM STYLE!")
	startGangnamParty()
end)
