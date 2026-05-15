local ServerStorage = game:GetService("ServerStorage")
local CrateClass = require(ServerStorage.Classes.CrateClass)
local UtensilClass = require(ServerStorage.Classes.UtensilClass)
local SupplyBoxClass = require(ServerStorage.Classes.SupplyBoxClass)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UseItem = ReplicatedStorage.Remotes.UseItem
local CollectionService = game:GetService("CollectionService")
local API = require(ServerStorage.API)

local Identifiers = {
	{tag = "Crate", class = CrateClass},
	{tag = "Utensil", class = UtensilClass},
	{tag = "SupplyBox", class = SupplyBoxClass},
}

for _, identifier in Identifiers do
	for _, part in CollectionService:GetTagged(identifier.tag) do
		local class = identifier.class
		local instance = class.new(part)
		instance:Init()
		if CollectionService:HasTag(part, "Usable") then
			UseItem.OnServerEvent:Connect(function(player, item, isUsing)
				if item ~= part then return end
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

DropItem.OnServerEvent:Connect(function(player, item)
	local guid = player:GetAttribute("CarryingItem")
	if not guid then return end
	if item ~= API.findItemByGuid(guid) then return end

	player:SetAttribute("CarryingItem", nil)

	if CollectionService:HasTag(item, "RestockPackage") then
		item:Destroy()
		return
	end

	item:SetNetworkOwner(nil)
	item.FollowForce.Enabled = false
	item.RotationForce.Enabled = false
	item.Parent = workspace
end)
