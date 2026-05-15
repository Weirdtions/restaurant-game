local API = {}

local Settings = {
	["MaxItemsPerPlayer"] = 1, -- max items you can select
}

function API:GetSettings()
	return Settings
end

function API.getOwnedParts(player)
	local ownedParts = {}
	for _, v in workspace.Items:GetChildren() do
		if v:GetAttribute("CurrentPlayer") == player.Name then
			table.insert(ownedParts, v)
		end
	end

	return ownedParts
end

function API.findItemByGuid(guid: string): BasePart?
	for _, item in workspace.Items:GetChildren() do
		if item:IsA("BasePart") and item:GetAttribute("Guid") == guid then
			return item
		end
	end
	return nil
end

function API.cleanChildren(part)
	for _, v in part:GetChildren() do
		v:Destroy()
	end
end

return API
