local InteractionConfig = {
	Stations = {
		["PotatoCutter"] = {
			AcceptedItems = {"Potato"},
			Action = "Process",
			OutputFolder = "Chopped",
			Cooldown = 1,
		},
		["CuttingBoard"] = {
			AcceptedItems = {"Tomato"},
			Action = "Place",
			Cooldown = 1,
		},
		["TrashCan"] = {
			AcceptedTags = {"Ingredient"},
			Action = "Destroy",
			Cooldown = 0.5,
		}
	}
}

return InteractionConfig
