local API = {}

local Config = {
	["MaxIngredientsPerPlayer"] = 1,
}

function API:GetConfig()
	return Config
end

function API:GetOwnedParts(player)
	local ownedParts = {}
	for _, v in workspace.DraggableItems:GetChildren() do
		if v:GetAttribute("CurrentPlayer") == player.Name then
			table.insert(ownedParts, v)
		end
	end
	
	return ownedParts
end

return API
