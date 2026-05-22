-- Weirdtions

local Placeholder = require(script.Parent.Placeholders)
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
	["NametagGui"] = {
		["BillboardGui"] = {
			["AlwaysOnTop"] = false,
			["Size"] = UDim2.new(4, 0, 2, 0),
			["StudsOffset"] = Vector3.new(0, 2.5, 0),
		},
		["MainFrame"] = {
			["Visible"] = true,
			["Size"] = UDim2.new(1, 0, 1, 0),
			["Position"] = UDim2.new(0, 0, 0, 0),
			["BackgroundColor"] = Color.White,
			["BackgroundTransparency"] = 1,

			-- UICorner
			["CornerRadius"] = UDim.new(0.2, 0),

			-- UIStroke
			["BorderColor"] = Color.Orange,
			["BorderThickness"] = 0,

			-- UIPadding
			["PaddingTop"] = UDim.new(0.05, 0),
			["PaddingBottom"] = UDim.new(0.05, 0),
			["PaddingLeft"] = UDim.new(0.05, 0),
			["PaddingRight"] = UDim.new(0.05, 0),

			-- UIListLayout
			["ListPadding"] = UDim.new(0.025, 0),
			["ListFillDirection"] = Enum.FillDirection.Vertical,
			["ListSortOrder"] = Enum.SortOrder.LayoutOrder,
			["ListHorizontalAlignment"] = Enum.HorizontalAlignment.Center,
			["ListVerticalAlignment"] = Enum.VerticalAlignment.Center,

			-- Title label
			["TitleLabel"] = {
				["Visible"] = true,
				["Size"] = UDim2.new(1, 0, 0.125, 0),
				["Position"] = UDim2.new(0, 0, 0.875, 0),
				["Color"] = Color.White,
				["AlignmentX"] = Enum.TextXAlignment.Center,
				["AlignmentY"] = Enum.TextYAlignment.Center,
			},

			-- Player name label
			["NameLabel"] = {
				["Visible"] = true,
				["Size"] = UDim2.new(1, 0, 0.2, 0),
				["Position"] = UDim2.new(0, 0, 0.65, 0),
				["Color"] = Color.White,
				["AlignmentX"] = Enum.TextXAlignment.Center,
				["AlignmentY"] = Enum.TextYAlignment.Center,
			},

			-- TagsFrame
			["TagsFrame"] = {
				["Visible"] = true,
				["Size"] = UDim2.new(1, 0, 0.6, 0),
				["Position"] = UDim2.new(0.5, 0, 0, 0),
				["ListPadding"] = UDim.new(0.025, 0),
				["ListFillDirection"] = Enum.FillDirection.Vertical,
				["ListSortOrder"] = Enum.SortOrder.LayoutOrder,
				["ListHorizontalAlignment"] = Enum.HorizontalAlignment.Center,
				["ListVerticalAlignment"] = Enum.VerticalAlignment.Bottom,
			},
		},
		["Tag"] = {
			["Visible"] = true,
			["Size"] = UDim2.new(1, 0, 0.5, 0),
			["Position"] = UDim2.new(0, 0, 0, 0),
			["BackgroundTransparency"] = 1,

			-- UICorner
			["CornerRadius"] = UDim.new(0.5, 0),

			-- UIStroke
			["BorderColor"] = Color.Black,
			["BorderThickness"] = 0,

			-- UIPadding
			["PaddingTop"] = UDim.new(0.05, 0),
			["PaddingBottom"] = UDim.new(0.05, 0),
			["PaddingLeft"] = UDim.new(0.05, 0),
			["PaddingRight"] = UDim.new(0.05, 0),

			-- UIListLayout
			["ListPadding"] = UDim.new(0.025, 0),
			["ListFillDirection"] = Enum.FillDirection.Vertical,
			["ListSortOrder"] = Enum.SortOrder.LayoutOrder,
			["ListHorizontalAlignment"] = Enum.HorizontalAlignment.Center,
			["ListVerticalAlignment"] = Enum.VerticalAlignment.Bottom,

			-- TextLabel
			["TextLabel"] = {
				["Visible"] = true,
				["Size"] = UDim2.new(1, 0, 1, 0),
				["Position"] = UDim2.new(0, 0, 0, 0),
				["AlignmentX"] = Enum.TextXAlignment.Center,
				["AlignmentY"] = Enum.TextYAlignment.Center,
			},
		},
	},
	["FoodGui"] = { -- ui displayed when hovering over ingredient
		["BillboardGui"] = {
			["AlwaysOnTop"] = true,
			["Size"] = UDim2.new(3, 0, 1.5, 0),
			["StudsOffset"] = Vector3.new(-3, 0, 0),
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
	["InstructionGui"] = {
		["Frame"] = {
			["Visible"] = true,
			["Size"] = UDim2.new(0.1, 0, 0.1, 0),
			["Position"] = UDim2.new(0.8, 0, 0.8, 0),
			["BackgroundColor"] = Color.Dark_Blue,

			-- UIListLayout
			["ListPadding"] = UDim.new(0, 0.025),
			["ListFillDirection"] = Enum.FillDirection.Vertical,
			["ListSortOrder"] = Enum.SortOrder.Name,
			["ListHorizontalAlignment"] = Enum.HorizontalAlignment.Center,
			["ListVerticalAlignment"] = Enum.VerticalAlignment.Top,
		},

		-- InstructionLabel
		["InstructionFrame"] = {
			["Visible"] = true,
			["Size"] = UDim2.new(0.5, 0, 0.5, 0),
			["BackgroundColor"] = Color.White,
			["AlignmentX"] = Enum.TextXAlignment.Center,
			["AlignmentY"] = Enum.TextYAlignment.Center,

			-- UIListLayout
			["ListPadding"] = UDim.new(0, 0.025),
			["ListFillDirection"] = Enum.FillDirection.Vertical,
			["ListSortOrder"] = Enum.SortOrder.Name,
			["ListHorizontalAlignment"] = Enum.HorizontalAlignment.Center,
			["ListVerticalAlignment"] = Enum.VerticalAlignment.Top,

			-- TextLabel
			["TextLabel"] = {
				["Visible"] = true,
				["Size"] = UDim2.new(0.5, 0, 1, 0),
				["Color"] = Color.White,
				["AlignmentX"] = Enum.TextXAlignment.Center,
				["AlignmentY"] = Enum.TextYAlignment.Center,
			},
			-- HotkeyLabel
			["Hotkey"] = {
				["Visible"] = true,
				["Size"] = UDim2.new(0.5, 0, 1, 0),
				["Color"] = Color.White,
				["AlignmentX"] = Enum.TextXAlignment.Center,
				["AlignmentY"] = Enum.TextYAlignment.Center,
			},
		},
	},
}

function UI.FoodGui(parent: BasePart)
	local Config = UI.Properties.FoodGui

	local billboard: BillboardGui = Placeholder.BillboardGui(
		"FoodGui",
		parent,
		Config.BillboardGui.AlwaysOnTop,
		Config.BillboardGui.Size,
		Config.BillboardGui.StudsOffset,
		{
			Placeholder.Frame(
				"NameFrame",
				Config.NameFrame.Visible,
				Config.NameFrame.Size,
				Config.NameFrame.Position,
				Config.NameFrame.BackgroundColor,
				2,
				{
					Placeholder.TextLabel(
						"NameLabel",
						Config.NameFrame.NameLabel.Visible,
						Config.NameFrame.NameLabel.Size,
						nil,
						2,
						Config.NameFrame.NameLabel.Color,
						Config.NameFrame.NameLabel.AlignmentX,
						Config.NameFrame.NameLabel.AlignmentY,
						{
							Placeholder.UIAspectRatioConstraint(2),
						}
					),
					Placeholder.ImageLabel(
						"ImageLabel",
						Config.NameFrame.ImageLabel.Visible,
						Config.NameFrame.ImageLabel.Size,
						nil,
						2,
						Config.NameFrame.ImageLabel.Image,
						{
							Placeholder.UIAspectRatioConstraint(1),
						}
					),
					Placeholder.UIAspectRatioConstraint(6),
					Placeholder.UICorner(Config.NameFrame.CornerRadius),
					Placeholder.UIListLayout(
						Config.NameFrame.ListPadding,
						Config.NameFrame.ListFillDirection,
						Config.NameFrame.ListSortOrder,
						Config.NameFrame.ListHorizontalAlignment,
						Config.NameFrame.ListVerticalAlignment
					),
					Placeholder.UIPadding(
						Config.NameFrame.PaddingTop,
						Config.NameFrame.PaddingBottom,
						Config.NameFrame.PaddingLeft,
						Config.NameFrame.PaddingRight
					),
					Placeholder.UIStroke(Color.Dark_Blue, Config.NameFrame.BorderThickness),
				}
			),
			Placeholder.Frame(
				"DetailFrame",
				Config.DetailFrame.Visible,
				Config.DetailFrame.Size,
				Config.DetailFrame.Position,
				Config.DetailFrame.BackgroundColor,
				1,
				{
					Placeholder.TextLabel(
						"DetailLabel",
						Config.DetailFrame.DetailLabel.Visible,
						Config.DetailFrame.DetailLabel.Size,
						nil,
						1,
						Config.DetailFrame.DetailLabel.Color,
						Config.DetailFrame.DetailLabel.AlignmentX,
						Config.DetailFrame.DetailLabel.AlignmentY,
						nil
					),
					Placeholder.UIAspectRatioConstraint(3),
					Placeholder.UICorner(Config.DetailFrame.CornerRadius),
					Placeholder.UIListLayout(
						Config.DetailFrame.ListPadding,
						Config.DetailFrame.ListFillDirection,
						Config.DetailFrame.ListSortOrder,
						Config.DetailFrame.ListHorizontalAlignment,
						Config.DetailFrame.ListVerticalAlignment
					),
					Placeholder.UIPadding(
						Config.DetailFrame.PaddingTop,
						Config.DetailFrame.PaddingBottom,
						Config.DetailFrame.PaddingLeft,
						Config.DetailFrame.PaddingRight
					),
					Placeholder.UIStroke(Config.DetailFrame.BorderColor, Config.DetailFrame.BorderThickness),
				}
			),
		}
	)
	billboard.Enabled = false
	local nameLabel: TextLabel = billboard:WaitForChild("NameFrame"):WaitForChild("NameLabel")
	local detailLabel: TextLabel = billboard:WaitForChild("DetailFrame"):WaitForChild("DetailLabel")
	nameLabel.Text = parent.Name
	detailLabel.Text = "• " .. parent.Name

	return billboard
end

function UI.NametagGui(parent: Instance, player: Player)
	local Config = UI.Properties.NametagGui

	local billboard: BillboardGui = Placeholder.BillboardGui(
		"Nametag",
		parent,
		Config.BillboardGui.AlwaysOnTop,
		Config.BillboardGui.Size,
		Config.BillboardGui.StudsOffset,
		{
			Placeholder.Frame(
				"MainFrame",
				Config.MainFrame.Visible,
				Config.MainFrame.Size,
				Config.MainFrame.Position,
				Config.MainFrame.BackgroundColor,
				1,
				{
					Placeholder.Frame(
						"Tags",
						Config.MainFrame.TagsFrame.Visible,
						Config.MainFrame.TagsFrame.Size,
						Config.MainFrame.TagsFrame.Position,
						Color.White,
						1,
						{
							Placeholder.UIListLayout(
								Config.MainFrame.TagsFrame.ListPadding,
								Config.MainFrame.TagsFrame.ListFillDirection,
								Config.MainFrame.TagsFrame.ListSortOrder,
								Config.MainFrame.TagsFrame.ListHorizontalAlignment,
								Config.MainFrame.TagsFrame.ListVerticalAlignment
							),
						}
					),
					Placeholder.TextLabel(
						"TitleLabel",
						Config.MainFrame.TitleLabel.Visible,
						Config.MainFrame.TitleLabel.Size,
						nil,
						1,
						Config.MainFrame.TitleLabel.Color,
						Config.MainFrame.TitleLabel.AlignmentX,
						Config.MainFrame.TitleLabel.AlignmentY,
						nil
					),
					Placeholder.TextLabel(
						"NameLabel",
						Config.MainFrame.NameLabel.Visible,
						Config.MainFrame.NameLabel.Size,
						nil,
						1,
						Config.MainFrame.NameLabel.Color,
						Config.MainFrame.NameLabel.AlignmentX,
						Config.MainFrame.NameLabel.AlignmentY,
						nil
					),
					Placeholder.UICorner(Config.MainFrame.CornerRadius),
					Placeholder.UIListLayout(
						Config.MainFrame.ListPadding,
						Config.MainFrame.ListFillDirection,
						Config.MainFrame.ListSortOrder,
						Config.MainFrame.ListHorizontalAlignment,
						Config.MainFrame.ListVerticalAlignment
					),
					Placeholder.UIPadding(
						Config.MainFrame.PaddingTop,
						Config.MainFrame.PaddingBottom,
						Config.MainFrame.PaddingLeft,
						Config.MainFrame.PaddingRight
					),
					Placeholder.UIStroke(Config.MainFrame.BorderColor, Config.MainFrame.BorderThickness),
				}
			),
		}
	)

	local mainFrame = billboard:FindFirstChild("MainFrame")
	if mainFrame then
		mainFrame.BackgroundTransparency = Config.MainFrame.BackgroundTransparency
	end
	local tagsFrame = mainFrame:FindFirstChild("Tags")
	if tagsFrame then
		tagsFrame.BackgroundTransparency = 1
	end

	local titleLabel = mainFrame:FindFirstChild("TitleLabel")
	local nameLabel = mainFrame:FindFirstChild("NameLabel")
	if nameLabel then
		nameLabel.LayoutOrder = 1
	end
	if titleLabel then
		titleLabel.LayoutOrder = 2
	end

	billboard.ResetOnSpawn = false
	nameLabel.Text = player.Name
	titleLabel.Text = player:GetRoleInGroupAsync(458948512) or "Guest"

	return billboard
end
function UI.Tag(tagName, data)
	local Config = UI.Properties.NametagGui.Tag
	local tag: Frame =
		Placeholder.Frame(tagName, Config.Visible, Config.Size, Config.Position, data.BackgroundColor, 1, {
			Placeholder.TextLabel(
				"TextLabel",
				Config.TextLabel.Visible,
				Config.TextLabel.Size,
				Config.TextLabel.Position,
				1,
				data.TextColor,
				Config.TextLabel.AlignmentX,
				Config.TextLabel.AlignmentY,
				{}
			),
			Placeholder.UICorner(Config.CornerRadius),
			Placeholder.UIPadding(Config.PaddingTop, Config.PaddingBottom, Config.PaddingLeft, Config.PaddingRight),
		})

	tag.BackgroundTransparency = Config.BackgroundTransparency
	tag.LayoutOrder = data.Priority
	tag.TextLabel.Text = data.Text

	return tag
end

function UI.InstructionGui(player: Player, instructions: {})
	UI.CleanInstructions(player)
	local Config = UI.Properties.InstructionGui.Frame

	local function generateLabels(parent: Instance)
		Config = UI.Properties.InstructionGui.InstructionFrame
		for i, instruction in instructions do
			local frame: Frame = Placeholder.Frame(
				"Instruction" .. i,
				Config.Visible,
				Config.Size,
				Config.Position,
				Config.BackgroundColor,
				1,
				{
					Placeholder.TextLabel(
						"TextLabel",
						Config.TextLabel.Visible,
						Config.TextLabel.Size,
						nil,
						1,
						Config.TextLabel.Color,
						Config.TextLabel.AlignmentX,
						Config.TextLabel.AlignmentY,
						{}
					),
					Placeholder.UIListLayout(
						Config.ListPadding,
						Config.ListFillDirection,
						Config.ListSortOrder,
						Config.ListHorizontalAlignment,
						Config.ListVerticalAlignment
					),
				}
			)

			local keyLabel
			local label: TextLabel = frame.TextLabel
			label.LayoutOrder = i
			label.Text = instruction.text
			label.Parent = parent
			if typeof(instruction.value) == "string" then
				keyLabel = Placeholder.ImageLabel("Key", Config.Hotkey.Visible, Config.Hotkey.Size, nil, 1, nil, {
					Placeholder.TextLabel(
						"TextLabel",
						Config.Hotkey.Visible,
						nil,
						nil,
						1,
						Config.Hotkey.Color,
						Config.Hotkey.AlignmentX,
						Config.Hotkey.AlignmentY,
						{}
					),
				})
				keyLabel.Parent = parent
				keyLabel.TextLabel.Text = instruction.value
			else
				keyLabel = Placeholder.ImageLabel(
					"Key",
					Config.Hotkey.Visible,
					Config.Hotkey.Size,
					nil,
					1,
					instruction.value,
					{}
				)
				keyLabel.Parent = parent
			end
			keyLabel.LayoutOrder = i + 1
		end
	end

	local screenGui: ScreenGui = Placeholder.ScreenGui("Instruction", player:WaitForChild("PlayerGui"), {
		Placeholder.Frame("Frame", Config.Visible, Config.Size, Config.Position, Config.BackgroundColor, 1, {
			Placeholder.UIListLayout(
				Config.ListPadding,
				Config.ListFillDirection,
				Config.ListSortOrder,
				Config.ListHorizontalAlignment,
				Config.ListVerticalAlignment
			),
		}),
	})

	local frame = screenGui.Frame
	frame.BackgroundTransparency = 1
	generateLabels(frame)

	return screenGui
end
function UI.CleanInstructions(player: Player)
	local playerGui = player:WaitForChild("PlayerGui")
	local instructionGui = playerGui:FindFirstChild("Instruction")
	if instructionGui then
		instructionGui:Destroy()
	end
end

return UI
