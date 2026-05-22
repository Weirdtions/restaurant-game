local ServerStorage = game:GetService("ServerStorage")
local CrateClass = require(ServerStorage.Classes.CrateClass)
local UtensilClass = require(ServerStorage.Classes.UtensilClass)
local SupplyBoxClass = require(ServerStorage.Classes.SupplyBoxClass)
local CupContainerClass = require(ServerStorage.Classes.CupContainerClass)
local StationClass = require(ServerStorage.Classes.StationClass)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UseItem = ReplicatedStorage.Remotes.UseItem
local CollectionService = game:GetService("CollectionService")
local API = require(ServerStorage.API)
local newInstance = require(ReplicatedStorage.Assets.Default.Instances)
local InteractionConfig = require(ReplicatedStorage.Data.InteractionConfig)
local Settings = API:GetSettings()

local StationInstances = {}

local Identifiers = {
	{ tag = "Crate", class = CrateClass },
	{ tag = "Utensil", class = UtensilClass },
	{ tag = "SupplyBox", class = SupplyBoxClass },
	{ tag = "CupContainer", class = CupContainerClass },
}

for _, identifier in Identifiers do
	for _, part in CollectionService:GetTagged(identifier.tag) do
		local class = identifier.class
		local instance = class.new(part)
		instance:Init()
		if CollectionService:HasTag(part, "Usable") then
			UseItem.OnServerEvent:Connect(function(player, item, isUsing)
				if item ~= part then
					return
				end
				if isUsing then
					instance:StopUsing()
				else
					instance:StartUsing()
				end
			end)
		end
	end
end

for stationTag, _ in pairs(InteractionConfig.Stations) do
	for _, part in CollectionService:GetTagged(stationTag) do
		local instance = StationClass.new(part, stationTag)
		instance:Init()
		StationInstances[part] = instance

		if CollectionService:HasTag(part, "Usable") then
			UseItem.OnServerEvent:Connect(function(player, item, isUsing)
				if item ~= part then
					return
				end
				if isUsing then
					instance:StopUsing()
				else
					instance:StartUsing()
				end
			end)
		end
	end
end

local DropItem = ReplicatedStorage.Remotes.DropItem

DropItem.OnServerEvent:Connect(function(player, item, targetStation)
	if item:IsA("Tool") then
		if targetStation and StationInstances[targetStation] then
			StationInstances[targetStation]:ProcessIngredient(item)
			return
		end
	else
		local guid = player:GetAttribute("CarryingItem")
		if not guid then
			return
		end
		if item ~= API.findItemByGuid(guid) then
			return
		end

		if targetStation and StationInstances[targetStation] then
			StationInstances[targetStation]:ProcessIngredient(item)
			return
		end

		local isFood = CollectionService:HasTag(item, "Ingredient")
		local isChopped = item:GetAttribute("Chopped")
		if isFood and not isChopped then
			return
		end

		player:SetAttribute("CarryingItem", nil)
		item:SetAttribute("CurrentPlayer", nil)

		if CollectionService:HasTag(item, "RestockPackage") then
			item:Destroy()
			return
		end

		item:SetNetworkOwner(nil)
		item.FollowForce.Enabled = false
		item.RotationForce.Enabled = false
		item.Parent = workspace
	end
end)

local PlaceCup = ReplicatedStorage.Remotes:WaitForChild("PlaceCup")
local MAX_PLACE_DISTANCE = 25

PlaceCup.OnServerEvent:Connect(function(player, position: Vector3, tool: Tool)
	if typeof(position) ~= "Vector3" then return end
	if not tool or not tool:IsA("Tool") then return end

	local character = player.Character
	if not character then return end
	if tool.Parent ~= character then return end

	local handle = tool:FindFirstChild("Handle")
	if not handle or not handle:IsA("BasePart") then return	end
	if not CollectionService:HasTag(handle, "Cup") then return end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	if (root.Position - position).Magnitude > MAX_PLACE_DISTANCE then return end

	handle.Parent = workspace
	handle.CFrame = CFrame.new(position)
	handle.Anchored = true
	handle.CanCollide = true

	local followForce = handle:FindFirstChild("FollowForce")
	if followForce then
		followForce.Enabled = false
	end
	local rotationForce = handle:FindFirstChild("RotationForce")
	if rotationForce then
		rotationForce.Enabled = false
	end

	tool:Destroy()

	local oldclickDetector = handle:FindFirstChild("ClickDetector")
	if oldclickDetector then oldclickDetector:Destroy() end

	local clickDetector = Instance.new("ClickDetector")
	clickDetector.MaxActivationDistance = 10
	clickDetector.Parent = handle

	clickDetector.MouseClick:Connect(function(clickPlayer)
		if #API.getOwnedParts(clickPlayer) >= Settings.MaxItemsPerPlayer then
			return
		end
		handle.Anchored = false
		handle.CanCollide = false
		clickDetector:Destroy()
		local newTool = newInstance.Tool(clickPlayer.Backpack, handle, nil, nil, false)
		newTool.Parent = clickPlayer.Character
	end)
end)
