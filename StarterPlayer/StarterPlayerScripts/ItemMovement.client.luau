local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local DropItem = Remotes:WaitForChild("DropItem") :: RemoteEvent
local UseItem = Remotes:WaitForChild("UseItem") :: RemoteEvent
local InteractionConfig = require(ReplicatedStorage:WaitForChild("Data"):WaitForChild("InteractionConfig"))


local MAX_DISTANCE = 15
local VERTICAL_OFFSET = Vector3.new(0, 2, 0)
local ITEMS_FOLDER = workspace:WaitForChild("Items")
local USE_ROTATION = CFrame.Angles(math.rad(-90), 0, 0)

local currentItem: BasePart = nil
local renderConn: RBXScriptConnection = nil
local isFixedMode: boolean = false

local function findItemByGuid(guid: string): BasePart?
	for _, item in ipairs(ITEMS_FOLDER:GetChildren()) do
		if item:IsA("BasePart") and item:GetAttribute("Guid") == guid then
			return item
		end
	end
	return nil
end

local function onRenderStep(dt: number)
	if not currentItem then return end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart
	if not root then return end

	local alignPos = currentItem:FindFirstChild("FollowForce") :: AlignPosition
	local alignOri = currentItem:FindFirstChild("RotationForce") :: AlignOrientation
	if not alignPos or not alignOri then return end

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

		if alignPos then alignPos.Enabled = true end
		if alignOri then alignOri.Enabled = false end

		renderConn = RunService.RenderStepped:Connect(onRenderStep)
		
		local highlight = item:FindFirstChild("Highlight") :: Highlight
		if highlight then
			highlight.Enabled = false
		end
	else
		mouse.TargetFilter = nil
	end
end

player:GetAttributeChangedSignal("CarryingItem"):Connect(function()
	local guid = player:GetAttribute("CarryingItem")
	if typeof(guid) == "string" and guid ~= "" then
		setTargetItem(findItemByGuid(guid))
	else
		setTargetItem(nil)
	end
end)

local isUsing = false
UserInputService.InputBegan:Connect(function(input: InputObject, processed: boolean)
	if processed or not currentItem then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local isFood = CollectionService:HasTag(currentItem, "Ingredient")
		local isChopped = currentItem:GetAttribute("Chopped")
		
		if not isFood or isChopped then
			-- Non-food items or chopped ingredients can be dropped anywhere
			DropItem:FireServer(currentItem)
		else
			-- Food items can ONLY be dropped on valid stations
			local targetStation = nil
			local mouseTarget = mouse.Target
			
			if mouseTarget then
				-- Check ancestors for station tags
				local curr = mouseTarget
				while curr and curr ~= workspace do
					for stationTag, config in pairs(InteractionConfig.Stations) do
						if CollectionService:HasTag(curr, stationTag) then
							-- Check if this station accepts this item
							local isValid = false
							if config.AcceptedItems then
								for _, item in ipairs(config.AcceptedItems) do
									if item == currentItem.Name then isValid = true break end
								end
							end
							if config.AcceptedTags then
								for _, tag in ipairs(config.AcceptedTags) do
									if CollectionService:HasTag(currentItem, tag) then isValid = true break end
								end
							end
							
							if isValid then
								targetStation = curr
								break
							end
						end
					end
					
					if targetStation then break end
					curr = curr.Parent
				end
			end
			
			if targetStation then
				-- We found a valid station to drop it on
				DropItem:FireServer(currentItem, targetStation)
			end
			-- If no valid target, do nothing (prevent dropping)
		end

	elseif input.KeyCode == Enum.KeyCode.E then
		if not CollectionService:HasTag(currentItem, "Usable") then return end

		isFixedMode = not isFixedMode
		UseItem:FireServer(currentItem, isUsing)
		isUsing = not isUsing
	end
end)
