local ServerStorage = game:GetService("ServerStorage")
local CrateClass = require(ServerStorage.Classes.CrateClass)
local UtensilClass = require(ServerStorage.Classes.UtensilClass)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UseItem = ReplicatedStorage.Remotes.UseItem
local CollectionService = game:GetService("CollectionService")
local Identifiers = {
	{tag = "Crate", class = CrateClass},
	{tag = "Utensil", class = UtensilClass},
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

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DropItem = ReplicatedStorage.Remotes.DropItem
local function findItemByGuid(guid: string): BasePart?
	for _, item in ipairs(workspace.Items:GetChildren()) do
		if item:IsA("BasePart") and item:GetAttribute("Guid") == guid then
			return item
		end
	end
	return nil
end

DropItem.OnServerEvent:Connect(function(player, item)
	local guid = player:GetAttribute("CarryingItem")
	if not guid then return end
	if item ~= findItemByGuid(guid) then return end
	
	player:SetAttribute("CarryingItem", nil)
	item:SetNetworkOwner(nil)
	item.FollowForce.Enabled = false
	item.RotationForce.Enabled = false
	item.Parent = workspace
end)
