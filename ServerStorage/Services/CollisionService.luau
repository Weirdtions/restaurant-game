-- Weirdtions

local CollisionService = {}

local Params = OverlapParams.new()
Params.FilterType = Enum.RaycastFilterType.Exclude
Params.MaxParts = 50

function CollisionService.getCollidingParts(sourcePart: BasePart, excludeList: {Instance}): {BasePart}
	local params = Params
	if excludeList then
		params.FilterDescendantsInstances = excludeList
	end

	local results = workspace:GetPartsInPart(sourcePart, params)

	local validParts: {BasePart} = {}
	for _, instance in ipairs(results) do
		if instance:IsA("BasePart") then
			table.insert(validParts, instance)
		end
	end

	return validParts
end

function CollisionService.getCollidingCharacters(sourcePart: BasePart, ignoreList: {Instance}?): {Model}
	local parts = CollisionService.getCollidingParts(sourcePart, ignoreList)
	local characters = {}
	local checked = {}

	for _, part in ipairs(parts) do
		local model = part:FindFirstAncestorOfClass("Model")
		if model and model:FindFirstChildOfClass("Humanoid") and not checked[model] then
			table.insert(characters, model)
			checked[model] = true
		end
	end

	return characters
end

return CollisionService
