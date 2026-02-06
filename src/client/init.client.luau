print("Valentine's client loading...")

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

task.wait(2) -- Wait for server to build the venue

---------------------------------------------------------------
-- POST-PROCESSING (toned down to avoid oversaturation)
---------------------------------------------------------------
local bloom = Instance.new("BloomEffect")
bloom.Intensity = 0.15
bloom.Size = 14
bloom.Threshold = 2
bloom.Parent = Lighting

local cc = Instance.new("ColorCorrectionEffect")
cc.Brightness = 0
cc.Contrast = 0.03
cc.Saturation = -0.05  -- slightly desaturated to counter neon glow
cc.TintColor = Color3.fromRGB(255, 250, 252)
cc.Parent = Lighting

print("Client effects applied!")

---------------------------------------------------------------
-- VALENTINE DIALOG GUI SYSTEM
---------------------------------------------------------------

-- Wait for remote event from server
local dialogEvent = ReplicatedStorage:WaitForChild("ValentineDialogEvent", 30)
if not dialogEvent then
	warn("No dialog event found!")
	return
end

-- Dialog lines the dog "says"
local DIALOG_LINES = {
	"*wags tail* 🐾",
	"Woof! Hey, Kyoungmin!",
	"It's me, Coco! Jason asked me to help him with something...",
	"He's been really nervous about this, but here goes... 🌹",
	"Kyoungmin...",
	"Will you be Jason's Valentine? 💝",
}

local dialogActive = false

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ValentineDialog"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 10
screenGui.Enabled = false
screenGui.Parent = playerGui

-- Dark overlay
local overlay = Instance.new("Frame")
overlay.Name = "Overlay"
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.5
overlay.BorderSizePixel = 0
overlay.ZIndex = 1
overlay.Parent = screenGui

-- Dialog box at bottom
local dialogBox = Instance.new("Frame")
dialogBox.Name = "DialogBox"
dialogBox.Size = UDim2.new(0.7, 0, 0.2, 0)
dialogBox.Position = UDim2.new(0.15, 0, 0.72, 0)
dialogBox.BackgroundColor3 = Color3.fromRGB(60, 20, 30)
dialogBox.BackgroundTransparency = 0.15
dialogBox.BorderSizePixel = 0
dialogBox.ZIndex = 2
dialogBox.Parent = screenGui

local dialogCorner = Instance.new("UICorner")
dialogCorner.CornerRadius = UDim.new(0, 16)
dialogCorner.Parent = dialogBox

local dialogStroke = Instance.new("UIStroke")
dialogStroke.Color = Color3.fromRGB(255, 150, 180)
dialogStroke.Thickness = 3
dialogStroke.Parent = dialogBox

-- Speaker name label
local speakerLabel = Instance.new("TextLabel")
speakerLabel.Name = "Speaker"
speakerLabel.Size = UDim2.new(0.3, 0, 0.08, 0)
speakerLabel.Position = UDim2.new(0.02, 0, -0.09, 0)
speakerLabel.BackgroundColor3 = Color3.fromRGB(255, 105, 140)
speakerLabel.Text = "🐶 Coco"
speakerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speakerLabel.TextScaled = true
speakerLabel.Font = Enum.Font.GothamBold
speakerLabel.ZIndex = 3
speakerLabel.Parent = dialogBox

local speakerCorner = Instance.new("UICorner")
speakerCorner.CornerRadius = UDim.new(0, 10)
speakerCorner.Parent = speakerLabel

-- Dialog text
local dialogText = Instance.new("TextLabel")
dialogText.Name = "DialogText"
dialogText.Size = UDim2.new(0.9, 0, 0.7, 0)
dialogText.Position = UDim2.new(0.05, 0, 0.2, 0)
dialogText.BackgroundTransparency = 1
dialogText.Text = ""
dialogText.TextColor3 = Color3.fromRGB(255, 230, 240)
dialogText.TextScaled = true
dialogText.Font = Enum.Font.GothamMedium
dialogText.TextXAlignment = Enum.TextXAlignment.Left
dialogText.TextYAlignment = Enum.TextYAlignment.Top
dialogText.ZIndex = 3
dialogText.Parent = dialogBox

-- "Click to continue" hint
local continueHint = Instance.new("TextLabel")
continueHint.Name = "ContinueHint"
continueHint.Size = UDim2.new(0.4, 0, 0.2, 0)
continueHint.Position = UDim2.new(0.55, 0, 0.75, 0)
continueHint.BackgroundTransparency = 1
continueHint.Text = "▼ Click to continue"
continueHint.TextColor3 = Color3.fromRGB(255, 180, 200)
continueHint.TextScaled = true
continueHint.Font = Enum.Font.Gotham
continueHint.TextTransparency = 0.3
continueHint.ZIndex = 3
continueHint.Visible = false
continueHint.Parent = dialogBox

---------------------------------------------------------------
-- VALENTINE QUESTION BUTTONS (shown after dialog)
---------------------------------------------------------------
local questionFrame = Instance.new("Frame")
questionFrame.Name = "QuestionFrame"
questionFrame.Size = UDim2.new(0.6, 0, 0.3, 0)
questionFrame.Position = UDim2.new(0.2, 0, 0.35, 0)
questionFrame.BackgroundTransparency = 1
questionFrame.ZIndex = 2
questionFrame.Visible = false
questionFrame.Parent = screenGui

-- Question text
local questionLabel = Instance.new("TextLabel")
questionLabel.Name = "Question"
questionLabel.Size = UDim2.new(1, 0, 0.35, 0)
questionLabel.Position = UDim2.new(0, 0, 0, 0)
questionLabel.BackgroundTransparency = 1
questionLabel.Text = "💝 Will you be Jason's Valentine? 💝"
questionLabel.TextColor3 = Color3.fromRGB(255, 220, 230)
questionLabel.TextScaled = true
questionLabel.Font = Enum.Font.GothamBold
questionLabel.ZIndex = 3
questionLabel.Parent = questionFrame

local questionStroke = Instance.new("UIStroke")
questionStroke.Color = Color3.fromRGB(255, 100, 130)
questionStroke.Thickness = 2
questionStroke.Parent = questionLabel

-- YES button
local yesButton = Instance.new("TextButton")
yesButton.Name = "YesButton"
yesButton.Size = UDim2.new(0.35, 0, 0.4, 0)
yesButton.Position = UDim2.new(0.08, 0, 0.5, 0)
yesButton.BackgroundColor3 = Color3.fromRGB(255, 80, 120)
yesButton.Text = "💕 Yes! 💕"
yesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
yesButton.TextScaled = true
yesButton.Font = Enum.Font.GothamBold
yesButton.ZIndex = 4
yesButton.Parent = questionFrame

local yesCorner = Instance.new("UICorner")
yesCorner.CornerRadius = UDim.new(0, 14)
yesCorner.Parent = yesButton

local yesStroke = Instance.new("UIStroke")
yesStroke.Color = Color3.fromRGB(255, 200, 210)
yesStroke.Thickness = 3
yesStroke.Parent = yesButton

-- NO button (this one runs away!)
local noButton = Instance.new("TextButton")
noButton.Name = "NoButton"
noButton.Size = UDim2.new(0.35, 0, 0.4, 0)
noButton.Position = UDim2.new(0.57, 0, 0.5, 0)
noButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
noButton.Text = "No 😢"
noButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noButton.TextScaled = true
noButton.Font = Enum.Font.GothamBold
noButton.ZIndex = 4
noButton.Parent = questionFrame

local noCorner = Instance.new("UICorner")
noCorner.CornerRadius = UDim.new(0, 14)
noCorner.Parent = noButton

---------------------------------------------------------------
-- CELEBRATION FRAME (shown after Yes)
---------------------------------------------------------------
local celebrationFrame = Instance.new("Frame")
celebrationFrame.Name = "Celebration"
celebrationFrame.Size = UDim2.new(1, 0, 1, 0)
celebrationFrame.BackgroundTransparency = 1
celebrationFrame.ZIndex = 5
celebrationFrame.Visible = false
celebrationFrame.Parent = screenGui

local celebText = Instance.new("TextLabel")
celebText.Name = "CelebText"
celebText.Size = UDim2.new(0.8, 0, 0.3, 0)
celebText.Position = UDim2.new(0.1, 0, 0.2, 0)
celebText.BackgroundTransparency = 1
celebText.Text = "💖 Happy Valentine's Day, Kyoungmin 💖\n- Jason 🌹"
celebText.TextColor3 = Color3.fromRGB(255, 200, 220)
celebText.TextScaled = true
celebText.Font = Enum.Font.GothamBold
celebText.ZIndex = 6
celebText.Parent = celebrationFrame

local celebStroke = Instance.new("UIStroke")
celebStroke.Color = Color3.fromRGB(255, 100, 140)
celebStroke.Thickness = 3
celebStroke.Parent = celebText

-- X close button for celebration
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(80, 30, 40)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 220, 230)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.ZIndex = 8
closeButton.Parent = celebrationFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

local function dismissCelebration()
	screenGui.Enabled = false
	celebrationFrame.Visible = false
	dialogActive = false
end

closeButton.MouseButton1Click:Connect(dismissCelebration)

-- Floating hearts in celebration
local function spawnCelebHeart()
	local heart = Instance.new("TextLabel")
	heart.Size = UDim2.new(0, math.random(30, 70), 0, math.random(30, 70))
	heart.Position = UDim2.new(math.random() * 0.9, 0, 1.1, 0) -- start below screen
	heart.BackgroundTransparency = 1
	heart.Text = ({"💖", "💕", "❤️", "💝", "🌹", "💗", "💘"})[math.random(1, 7)]
	heart.TextScaled = true
	heart.ZIndex = 7
	heart.Parent = celebrationFrame

	local floatTween = TweenService:Create(heart, TweenInfo.new(
		math.random(20, 40) / 10,
		Enum.EasingStyle.Linear
	), {
		Position = UDim2.new(heart.Position.X.Scale + (math.random() - 0.5) * 0.3, 0, -0.2, 0)
	})
	floatTween:Play()
	floatTween.Completed:Connect(function()
		heart:Destroy()
	end)
end

---------------------------------------------------------------
-- TYPEWRITER EFFECT
---------------------------------------------------------------
local function typeText(label, text, speed)
	speed = speed or 0.04
	label.Text = ""
	for i = 1, #text do
		label.Text = string.sub(text, 1, i)
		task.wait(speed)
	end
end

---------------------------------------------------------------
-- NO BUTTON DODGE LOGIC
---------------------------------------------------------------
local dodgeCount = 0
local noTexts = {"No 😢", "Nope! 😜", "Try again!", "Can't click me!", "Too slow! 😝", "Hehe! 🐾", "Nuh uh!", "Nice try! 💨"}

local function dodgeNoButton()
	dodgeCount = dodgeCount + 1

	-- Make it smaller each time (but not too small to read)
	local shrink = math.max(0.18, 0.35 - dodgeCount * 0.025)
	noButton.Size = UDim2.new(shrink, 0, 0.4, 0)

	-- Random position within SAFE screen bounds (10-85% to avoid edges)
	local newX = math.random(10, 75) / 100
	local newY = math.random(15, 75) / 100

	-- Make sure it doesn't land on the Yes button area (left side, middle-bottom)
	if newX > 0.05 and newX < 0.5 and newY > 0.4 and newY < 0.95 then
		newX = newX + 0.4 -- push it to the right side
	end
	
	-- Clamp to safe bounds to prevent off-screen
	newX = math.clamp(newX, 0.12, 0.82)
	newY = math.clamp(newY, 0.2, 0.75)

	-- Tween to new position for smooth movement
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tween = TweenService:Create(noButton, tweenInfo, {
		Position = UDim2.new(newX, 0, newY, 0)
	})
	tween:Play()

	-- Change text for comedy (keep TextScaled enabled to prevent "...")
	noButton.Text = noTexts[((dodgeCount - 1) % #noTexts) + 1]
	noButton.TextScaled = true -- ensure text always scales to fit

	-- After enough dodges, make it smaller but still readable
	if dodgeCount >= 8 then
		noButton.Text = "Nope! 💕"
		noButton.Size = UDim2.new(0.15, 0, 0.25, 0)
	end
	if dodgeCount >= 12 then
		noButton.Text = "ok fine 💕"
		noButton.Size = UDim2.new(0.22, 0, 0.35, 0) -- bigger so text is readable
		task.wait(0.5)
		-- Auto-yes after they try enough times
		yesButton.Text = "💖 YES!!! 💖"
		local pulse = TweenService:Create(yesButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
			Size = UDim2.new(0.5, 0, 0.5, 0)
		})
		pulse:Play()
	end
end

-- Dodge when mouse enters the No button
noButton.MouseEnter:Connect(function()
	dodgeNoButton()
end)

-- Also dodge on touch (mobile)
noButton.TouchTap:Connect(function()
	dodgeNoButton()
end)

---------------------------------------------------------------
-- YES BUTTON CELEBRATION
---------------------------------------------------------------
local celebEvent = ReplicatedStorage:WaitForChild("ValentineCelebEvent", 30)

yesButton.MouseButton1Click:Connect(function()
	-- Hide question AND the No button
	questionFrame.Visible = false
	noButton.Visible = false
	noButton.Parent = questionFrame
	dialogBox.Visible = false

	-- === WHITE FLASH === --
	local flash = Instance.new("Frame")
	flash.Size = UDim2.new(1, 0, 1, 0)
	flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	flash.BackgroundTransparency = 0
	flash.BorderSizePixel = 0
	flash.ZIndex = 100
	flash.Parent = screenGui

	local flashTween = TweenService:Create(flash, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1
	})
	flashTween:Play()
	flashTween.Completed:Connect(function()
		flash:Destroy()
	end)

	-- Camera shake for impact
	task.spawn(function()
		local camera = game:GetService("Workspace").CurrentCamera
		if camera then
			for i = 1, 10 do
				local shakeX = (math.random() - 0.5) * 0.4
				local shakeY = (math.random() - 0.5) * 0.4
				camera.CFrame = camera.CFrame * CFrame.Angles(math.rad(shakeX), math.rad(shakeY), 0)
				task.wait(0.03)
			end
		end
	end)

	-- Fire server to start the Gangnam Style party!
	if celebEvent then
		celebEvent:FireServer()
	end

	-- Note: Music is handled server-side only to prevent doubling

	-- Show celebration after the flash
	task.delay(0.3, function()
		overlay.BackgroundTransparency = 0.6
		celebrationFrame.Visible = true

		-- Spawn lots of floating hearts
		for i = 1, 50 do
			task.delay(i * 0.1, spawnCelebHeart)
		end

		-- Keep spawning hearts
		task.spawn(function()
			for i = 1, 100 do
				task.wait(0.3)
				spawnCelebHeart()
			end
		end)

		-- After a moment, show Coco's reaction
		task.delay(3, function()
			local extraMsg = Instance.new("TextLabel")
			extraMsg.Size = UDim2.new(0.8, 0, 0.15, 0)
			extraMsg.Position = UDim2.new(0.1, 0, 0.55, 0)
			extraMsg.BackgroundTransparency = 1
			extraMsg.Text = "🐶 Coco approves!! *tail wagging intensifies* 🐾"
			extraMsg.TextColor3 = Color3.fromRGB(255, 230, 240)
			extraMsg.TextScaled = true
			extraMsg.Font = Enum.Font.GothamMedium
			extraMsg.ZIndex = 6
			extraMsg.Parent = celebrationFrame
		end)

		-- Auto-dismiss GUI after 10 seconds (party keeps going in the world)
		task.delay(10, function()
			if celebrationFrame.Visible then
				dismissCelebration()
			end
		end)
	end)
end)

---------------------------------------------------------------
-- DIALOG FLOW (triggered by ProximityPrompt on server)
---------------------------------------------------------------
local function startDialog()
	if dialogActive then return end
	dialogActive = true

	screenGui.Enabled = true
	dialogBox.Visible = true
	continueHint.Visible = false
	dialogText.Text = ""

	local lineIndex = 0
	local typing = false
	local waitingForClick = false

	local function showNextLine()
		lineIndex = lineIndex + 1

		if lineIndex > #DIALOG_LINES then
			-- Done with dialog lines, show the question!
			dialogBox.Visible = false
			questionFrame.Visible = true
			-- Reparent No button to screenGui so it can move freely
			noButton.Parent = screenGui
			return
		end

		typing = true
		continueHint.Visible = false
		typeText(dialogText, DIALOG_LINES[lineIndex], 0.045)
		typing = false
		waitingForClick = true
		continueHint.Visible = true
	end

	-- Click anywhere on dialog box or overlay to advance
	local clickConn
	clickConn = overlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if waitingForClick and not typing then
				waitingForClick = false
				showNextLine()
			end
		end
	end)

	local clickConn2
	clickConn2 = dialogBox.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if waitingForClick and not typing then
				waitingForClick = false
				showNextLine()
			end
		end
	end)

	-- Show first line
	showNextLine()
end

-- Listen for remote event from server (ProximityPrompt triggered)
dialogEvent.OnClientEvent:Connect(function()
	startDialog()
end)

print("Valentine dialog system ready!")
