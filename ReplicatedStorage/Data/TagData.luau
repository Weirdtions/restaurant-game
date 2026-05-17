local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UI = require(ReplicatedStorage.UI.UI)
local Color = UI.Colors

local TagData = {
	["❤️"] = {
		["ID"] = 1,
		["Text"] = "❤️",
		["TextColor"] = Color.White,
		["BackgroundColor"] = Color.Orange,
		["Priority"] = 1,
	},
}

return TagData
