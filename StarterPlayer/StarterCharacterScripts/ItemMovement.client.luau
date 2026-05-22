local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UI = require(ReplicatedStorage.Assets.Default.UI)
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local DropItem = Remotes:WaitForChild("DropItem") :: RemoteEvent
local UseItem = Remotes:WaitForChild("UseItem") :: RemoteEvent
local PlaceCup = Remotes:WaitForChild("PlaceCup") :: RemoteEvent
local InteractionConfig = require(ReplicatedStorage:WaitForChild("Data"):WaitForChild("InteractionConfig"))

local MAX_DISTANCE = 15
local VERTICAL_OFFSET = Vector3.new(0, 2, 0)
local ITEMS_FOLDER = workspace:WaitForChild("Items")
local USE_ROTATION = CFrame.Angles(math.rad(-90), 0, 0)

local currentItem: BasePart = nil
local renderConn: RBXScriptConnection = nil
local isFixedMode: boolean = false
local InstructionGui = nil

local isPlacingMode: boolean = false
local ghostPart: BasePart? = nil
local ghostHighlight: Highlight? = nil
local ghostRenderConn: RBXScriptConnection? = nil
local ghostValidPosition: Vector3? = nil
local GHOST_MAX_DISTANCE = 20
local GHOST_VALID_COLOR = Color3.fromRGB(80, 255, 80)
local GHOST_INVALID_COLOR = Color3.fromRGB(255, 80, 80)

local function findItemByGuid(guid: string): BasePart?
	for _, item in ipairs(ITEMS_FOLDER:GetChildren()) do
		if item:IsA("BasePart") and item:GetAttribute("Guid") == guid then
			return item
		end
	end
	return nil
end

local function destroyGhost()
	if ghostRenderConn then
		ghostRenderConn:Disconnect()
		ghostRenderConn = nil
	end
	if ghostPart then
		ghostPart:Destroy()
		ghostPart = nil
	end
	ghostHighlight = nil
	ghostValidPosition = nil
	isPlacingMode = false
end

local function createGhost(sourceTool: Tool)
	local handle = sourceTool:FindFirstChild("Handle") :: BasePart
	if not handle then return end

	local ghost = handle:Clone()
	ghost.Name = "GhostCup"
	ghost.Anchored = true
	ghost.CanCollide = false
	ghost.CanQuery = false
	ghost.CanTouch = false
	ghost.Transparency = 0.5

	for _, child in ghost:GetChildren() do
		if child:IsA("AlignPosition") or child:IsA("AlignOrientation") 
			or child:IsA("ClickDetector") or child:IsA("BillboardGui")
			or child:IsA("Attachment") or child:IsA("Script") 
			or child:IsA("LocalScript") then
			child:Destroy()
		end
	end

	for _, child in ghost:GetChildren() do
		if child:IsA("Highlight") then
			child:Destroy()
		end
	end

	local highlight = Instance.new("Highlight")
	highlight.Adornee = ghost
	highlight.FillTransparency = 0.3
	highlight.FillColor = GHOST_VALID_COLOR
	highlight.OutlineTransparency = 0.5
	highlight.OutlineColor = GHOST_VALID_COLOR
	highlight.Enabled = true
	highlight.Parent = ghost

	ghost.Parent = workspace
	ghostPart = ghost
	ghostHighlight = highlight
	isPlacingMode = true
end

local function onGhostRenderStep()
	if not ghostPart or not isPlacingMode then return end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart
	if not root then return end

	local camera = workspace.CurrentCamera
	local mouseLocation = UserInputService:GetMouseLocation()
	local ray = camera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = {
		ghostPart,
		character,
		workspace:FindFirstChild("Items"),
		workspace:FindFirstChild("Characters"),
	}

	local rayResult = workspace:Raycast(ray.Origin, ray.Direction * 100, rayParams)

	if rayResult then
		local hitPos = rayResult.Position
		local distFromPlayer = (hitPos - root.Position).Magnitude

		local cupHeight = ghostPart.Size.Y
		local placementPos = hitPos + Vector3.new(0, cupHeight / 2, 0)

		ghostPart.CFrame = CFrame.new(placementPos)

		if distFromPlayer <= GHOST_MAX_DISTANCE then
			ghostValidPosition = placementPos
			if ghostHighlight then
				ghostHighlight.FillColor = GHOST_VALID_COLOR
				ghostHighlight.OutlineColor = GHOST_VALID_COLOR
			end
		else
			ghostValidPosition = nil
			if ghostHighlight then
				ghostHighlight.FillColor = GHOST_INVALID_COLOR
				ghostHighlight.OutlineColor = GHOST_INVALID_COLOR
			end
		end
	else
		ghostValidPosition = nil
		if ghostHighlight then
			ghostHighlight.FillColor = GHOST_INVALID_COLOR
			ghostHighlight.OutlineColor = GHOST_INVALID_COLOR
		end
	end
end

local function onRenderStep(dt: number)
	if not currentItem or currentItem:IsA("Tool") then
		return
	end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart
	if not root then
		return
	end

	local alignPos = currentItem:FindFirstChild("FollowForce") :: AlignPosition
	local alignOri = currentItem:FindFirstChild("RotationForce") :: AlignOrientation
	if not alignPos or not alignOri then
		return
	end

	mouse.TargetFilter = currentItem

	local rootPos = root.Position
	local mousePos = mouse.Hit.Position
	local direction = (mousePos - rootPos)

	if direction.Magnitude > MAX_DISTANCE then
		mousePos = rootPos + (direction.Unit * MAX_DISTANCE)
	end

	local targetPos

	if currentItem.Name == "Knife" then
		targetPos = mousePos + Vector3.new(0, 1, 0)
	else
		targetPos = mousePos + Vector3.new(0, 2, 0)
	end
	alignPos.Position = targetPos

	if isFixedMode then
		alignOri.Enabled = true
		local baseRotation = CFrame.lookAt(targetPos, targetPos + root.CFrame.LookVector)
		alignOri.CFrame = baseRotation * USE_ROTATION
	else
		alignOri.Enabled = false
	end
end

local function setTargetItem(item: BasePart?)
	if renderConn then
		renderConn:Disconnect()
		renderConn = nil
	end

	currentItem = item

	isFixedMode = false

	if item then
		local alignPos = item:FindFirstChild("FollowForce") :: AlignPosition
		local alignOri = item:FindFirstChild("RotationForce") :: AlignOrientation

		if alignPos then
			alignPos.Enabled = true
		end
		if alignOri then
			alignOri.Enabled = false
		end

		renderConn = RunService.RenderStepped:Connect(onRenderStep)

		local highlight = item:FindFirstChild("Highlight") :: Highlight
		if highlight then
			highlight.Enabled = false
		end
	else
		mouse.TargetFilter = nil
	end
end

local character = player.Character or player.CharacterAdded:Wait()
character.ChildAdded:Connect(function(instance)
	if instance:IsA("Tool") then
		local handle = instance:FindFirstChild("Handle")
		local isCup = handle and CollectionService:HasTag(handle, "Cup")

		if isCup or CollectionService:HasTag(instance, "Cup") then
			setTargetItem(instance)
		end
	end
end)

character.ChildRemoved:Connect(function(instance)
	if currentItem == instance then
		setTargetItem(nil)
	end
end)

player:GetAttributeChangedSignal("CarryingItem"):Connect(function()
	local guid = player:GetAttribute("CarryingItem")
	if typeof(guid) == "string" and guid ~= "" then
		setTargetItem(findItemByGuid(guid))
	else
		if currentItem and currentItem:IsA("BasePart") then
			setTargetItem(nil)
		end
	end
end)

local isUsing = false
UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
	if gameProcessed then
		return
	end

	if input.KeyCode == Enum.KeyCode.Escape and isPlacingMode then
		destroyGhost()
		return
	end

	if not currentItem then
		return
	end

	if input.KeyCode == Enum.KeyCode.Q then
		if isPlacingMode then
			destroyGhost()
			return
		end

		if currentItem:IsA("Tool") then
			local handle = currentItem:FindFirstChild("Handle")
			if handle and CollectionService:HasTag(handle, "Cup") then
				createGhost(currentItem)
				ghostRenderConn = RunService.RenderStepped:Connect(onGhostRenderStep)
			end
		end
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if isPlacingMode and ghostValidPosition and currentItem and currentItem:IsA("Tool") then
			local toolRef = currentItem
			local pos = ghostValidPosition
			destroyGhost()
			PlaceCup:FireServer(pos, toolRef)
			return
		end

		if not isPlacingMode then
			local targetStation = nil
			local mouseTarget = mouse.Target

			if mouseTarget then
				local curr = mouseTarget
				while curr and curr ~= workspace do
					for stationTag, config in pairs(InteractionConfig.Stations) do
						if CollectionService:HasTag(curr, stationTag) then
							local isValid = false

							if config.AcceptedItems then
								for _, itemName in ipairs(config.AcceptedItems) do
									if itemName == currentItem.Name then
										isValid = true
										break
									end
								end
							end
							if config.AcceptedTags then
								for _, tag in ipairs(config.AcceptedTags) do
									if CollectionService:HasTag(currentItem, tag) then
										isValid = true
										break
									end
								end
							end

							if isValid then
								targetStation = curr
								break
							end
						end
					end

					if targetStation then
						break
					end
					curr = curr.Parent
				end
			end

			if targetStation then
				DropItem:FireServer(currentItem, targetStation)
			end
		end
	elseif input.KeyCode == Enum.KeyCode.E then
		if isPlacingMode then
			return
		end
		if not CollectionService:HasTag(currentItem, "Usable") then
			return
		end

		isFixedMode = not isFixedMode
		UseItem:FireServer(currentItem, isUsing)
		isUsing = not isUsing
	end
end)

character.ChildRemoved:Connect(function(instance)
	if isPlacingMode and currentItem == instance then
		destroyGhost()
	end
end)
