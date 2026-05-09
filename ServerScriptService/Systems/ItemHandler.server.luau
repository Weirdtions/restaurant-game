local ServerStorage = game:GetService("ServerStorage")
local CrateClass = require(ServerStorage.Classes.CrateClass)
local UtensilClass = require(ServerStorage.Classes.UtensilClass)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DropItem = ReplicatedStorage.Remotes.DropItem
local CollectionService = game:GetService("CollectionService")
local TAGS = {
	{ tag = "Crate", class = CrateClass },
	{ tag = "Utensil", class = UtensilClass },
}

for _, tag in TAGS do
	for _, part in CollectionService:GetTagged(tag.tag) do
		local class = tag.class
		local v
		
		if tag == "Utensil" then
			v = class.new(part, part.Name)
		else
			v = class.new(part)
		end
		
		if v then
			v:Init()
		end
	end
end

DropItem.OnServerEvent:Connect(function(player)
	for _, v in workspace.DraggableItems:GetChildren() do
		if v:IsA("BasePart") and v:GetAttribute("CurrentPlayer") == player.Name then
			v.Parent = workspace
			v:SetNetworkOwner(nil)
			v:SetAttribute("CurrentPlayer", "")
			v:SetAttribute("TargetAttachment", "")

			local alignPosition = v:FindFirstChildOfClass("AlignPosition")
			local alignOrientation = v:FindFirstChildOfClass("AlignOrientation")

			if alignPosition then alignPosition.Enabled = false end
			if alignOrientation then alignOrientation.Enabled = false end

			local targetAttachment = workspace.Terrain:FindFirstChild("TargetAttachment_" .. v.Name)
			if targetAttachment then
				targetAttachment:Destroy()
			end

			local highlight = v:FindFirstChildOfClass("Highlight")
			if highlight then
				highlight.Enabled = false
			end
			break
		end
	end
end)
