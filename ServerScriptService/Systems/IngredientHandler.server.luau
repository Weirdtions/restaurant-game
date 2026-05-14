local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpawnItem: BindableEvent = ReplicatedStorage.Bindables.SpawnItem
local ServerStorage = game:GetService("ServerStorage")
local IngredientClass = require(ServerStorage.Classes.IngredientClass)

SpawnItem.Event:Connect(function(itemName: string, position: Vector3, folder: Folder)
	local choppedPart = folder:FindFirstChild(itemName):Clone()
	local choppedIngredient = IngredientClass.new(choppedPart)
	choppedIngredient.Chopped = true
	choppedIngredient:Init()
	choppedIngredient.Part.Parent = workspace
	choppedIngredient.Part.Position = position
end)
