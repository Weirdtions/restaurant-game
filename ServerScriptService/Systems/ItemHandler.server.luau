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
local InteractionConfig = require(ReplicatedStorage.Data.InteractionConfig)

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
