local InteractionConfig = {
	Stations = {
		["PotatoCutter"] = {
			AcceptedItems = { "Potato" },
			Action = "Process",
			OutputFolder = "Chopped",
			OutputItem = "Potato",
			Cooldown = 1,
			DropItem = true,
		},
		["CuttingBoard"] = {
			AcceptedItems = { "Tomato" },
			Action = "Place",
			Cooldown = 1,
			DropItem = true,
		},
		["BeverageDispenser"] = {
			AcceptedItems = { "Cup" },
			Action = "Fill",
			OutputFolder = "Beverages",
			DropItem = false,
		},
		["TrashCan"] = {
			AcceptedTags = { "Ingredient", "Cup" },
			Action = "Destroy",
			Cooldown = 0.5,
			DropItem = true,
		},
	},
}

return InteractionConfig
