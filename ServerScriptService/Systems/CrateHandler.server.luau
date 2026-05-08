local ServerStorage = game:GetService("ServerStorage")
local CrateClass = require(ServerStorage.Classes.CrateClass)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DropIngredient = ReplicatedStorage.Remotes.DropIngredient
local CollectionService = game:GetService("CollectionService")
local TAG = "Crate"

for _, part in CollectionService:GetTagged(TAG) do
	local crate = CrateClass.new(part)
	crate:Init()
end

DropIngredient.OnServerEvent:Connect(function(player)
	for _, v in workspace.Ingredients:GetChildren() do
		if v:IsA("BasePart") and v:GetAttribute("CurrentPlayer") == player.Name then
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
