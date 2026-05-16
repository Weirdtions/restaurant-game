-- Weirdtions

local Placeholder = require(script.Placeholders)
local UI = {}

UI.Colors = {
	["Black"] = Color3.fromRGB(0, 0, 0),
	["White"] = Color3.fromRGB(255, 255, 255),
	["Dark_Blue"] = Color3.fromRGB(5, 0, 25),
	["Orange"] = Color3.fromRGB(200, 150, 0),
}
local Color = UI.Colors

UI.Sounds = {} -- not yet


UI.Properties = {
	["FoodGui"] = {		-- ui displayed when hovering over ingredient
		["BillboardGui"] = {
			["AlwaysOnTop"] = true,
			["Size"] = UDim2.new(0, 200, 0, 100),
			["StudsOffset"] = Vector3.new(-4, 0, 0),
		},
		["NameFrame"] = {
			["Visible"] = true,
			["Size"] = UDim2.new(1, 0, 1, 0),
			["Position"] = UDim2.new(0, 0, 0, 0),
			["BackgroundColor"] = Color.Orange,

			-- NameLabel
			["NameLabel"] = {
				["Visible"] = true,
				["Size"] = UDim2.new(1, 0, 1, 0),
				["Color"] = Color.White,
				["AlignmentX"] = Enum.TextXAlignment.Center,
				["AlignmentY"] = Enum.TextYAlignment.Center,
			},

			-- ImageLabel
			["ImageLabel"] = {
				["Visible"] = true,
				["Size"] = UDim2.new(1, 0, 1, 0),
				["Image"] = nil,
			},

			-- UICorner
			["CornerRadius"] = UDim.new(0.25, 0),

			-- UIListLayout
			["ListPadding"] = UDim.new(0.025, 0),
			["ListFillDirection"] = Enum.FillDirection.Horizontal,
			["ListSortOrder"] = Enum.SortOrder.Name,
			["ListHorizontalAlignment"] = Enum.HorizontalAlignment.Center,
			["ListVerticalAlignment"] = Enum.VerticalAlignment.Center,

			-- UIPadding
			["PaddingTop"] = UDim.new(0.05, 0),
			["PaddingBottom"] = UDim.new(0.05, 0),
			["PaddingLeft"] = UDim.new(0.1, 0),
			["PaddingRight"] = UDim.new(0.1, 0),

			-- UIStroke
			["BorderColor"] = Color.Dark_Blue,
			["BorderThickness"] = 2.5,
		},
		["DetailFrame"] = {
			["Visible"] = true,
			["Size"] = UDim2.new(0.9, 0, 0.9, 0),
			["Position"] = UDim2.new(0.05, 0, 0.25, 0),
			["BackgroundColor"] = Color.Dark_Blue,

			-- NameLabel
			["DetailLabel"] = {
				["Visible"] = true,
				["Size"] = UDim2.new(0.5, 0, 0.5, 0),
				["Color"] = Color.White,
				["AlignmentX"] = Enum.TextXAlignment.Left,
				["AlignmentY"] = Enum.TextYAlignment.Center,
			},

			-- UICorner
			["CornerRadius"] = UDim.new(0.125, 0),

			-- UIListLayout
			["ListPadding"] = UDim.new(0.025, 0),
			["ListFillDirection"] = Enum.FillDirection.Vertical,
			["ListSortOrder"] = Enum.SortOrder.LayoutOrder,
			["ListHorizontalAlignment"] = Enum.HorizontalAlignment.Left,
			["ListVerticalAlignment"] = Enum.VerticalAlignment.Center,

			-- UIPadding
			["PaddingTop"] = UDim.new(0.45, 0),
			["PaddingBottom"] = UDim.new(0.05, 0),
			["PaddingLeft"] = UDim.new(0.05, 0),
			["PaddingRight"] = UDim.new(0.05, 0),

			-- UIStroke
			["BorderColor"] = Color.Dark_Blue,
			["BorderThickness"] = 2.5,
		},
	},
}

function UI.FoodGui(parent: BasePart)
	local Config = UI.Properties.FoodGui
	
	local billboard: BillboardGui = Placeholder.BillboardGui("FoodGui", parent, Config.BillboardGui.AlwaysOnTop, Config.BillboardGui.Size, Config.BillboardGui.StudsOffset,
		{Placeholder.Frame("NameFrame", Config.NameFrame.Visible, Config.NameFrame.Size, Config.NameFrame.Position, Config.NameFrame.BackgroundColor, 2, {
			Placeholder.TextLabel("NameLabel", Config.NameFrame.NameLabel.Visible, Config.NameFrame.NameLabel.Size, nil, 2, Config.NameFrame.NameLabel.Color, Config.NameFrame.NameLabel.AlignmentX, Config.NameFrame.NameLabel.AlignmentY,{
				Placeholder.UIAspectRatioConstraint(2)}),
			Placeholder.ImageLabel("ImageLabel", Config.NameFrame.ImageLabel.Visible, Config.NameFrame.ImageLabel.Size, nil, 2, Config.NameFrame.ImageLabel.Image, {
				Placeholder.UIAspectRatioConstraint(1)}),
			Placeholder.UIAspectRatioConstraint(6),
			Placeholder.UICorner(Config.NameFrame.CornerRadius),
			Placeholder.UIListLayout(Config.NameFrame.ListPadding, Config.NameFrame.ListFillDirection, Config.NameFrame.ListSortOrder, Config.NameFrame.ListHorizontalAlignment, Config.NameFrame.ListVerticalAlignment),
			Placeholder.UIPadding(Config.NameFrame.PaddingTop, Config.NameFrame.PaddingBottom, Config.NameFrame.PaddingLeft, Config.NameFrame.PaddingRight),
			Placeholder.UIStroke(Color.Dark_Blue, Config.NameFrame.BorderThickness)}),
		Placeholder.Frame("DetailFrame", Config.DetailFrame.Visible, Config.DetailFrame.Size, Config.DetailFrame.Position, Config.DetailFrame.BackgroundColor, 1, {
			Placeholder.TextLabel("DetailLabel", Config.DetailFrame.DetailLabel.Visible, Config.DetailFrame.DetailLabel.Size, nil, 1, Config.DetailFrame.DetailLabel.Color, Config.DetailFrame.DetailLabel.AlignmentX, Config.DetailFrame.DetailLabel.AlignmentY, nil),
			Placeholder.UIAspectRatioConstraint(3),
			Placeholder.UICorner(Config.DetailFrame.CornerRadius),
			Placeholder.UIListLayout(Config.DetailFrame.ListPadding, Config.DetailFrame.ListFillDirection, Config.DetailFrame.ListSortOrder, Config.DetailFrame.ListHorizontalAlignment, Config.DetailFrame.ListVerticalAlignment),
			Placeholder.UIPadding(Config.DetailFrame.PaddingTop, Config.DetailFrame.PaddingBottom, Config.DetailFrame.PaddingLeft, Config.DetailFrame.PaddingRight),
			Placeholder.UIStroke(Config.DetailFrame.BorderColor, Config.DetailFrame.BorderThickness)})}
	)
	billboard.Enabled = false
	
	return billboard
end

return UI
