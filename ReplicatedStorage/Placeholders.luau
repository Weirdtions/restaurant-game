-- Weirdtions

local GlobalConfig = {
	["Text"] = Font.new(
		"rbxasset://fonts/families/Arimo.json", 
		Enum.FontWeight.Bold, 
		Enum.FontStyle.Normal
	),
	["Image"] = {
		["Default"] = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	}
}

local Placeholder = {}

function Placeholder.BillboardGui(name: string, parent: Instance, alwaysOnTop: boolean, size: UDim2, studsOffset: Vector3, children: {})
	local billboard = Instance.new("BillboardGui")
	billboard.Name = name
	if parent then billboard.Parent = parent end
	billboard.Adornee = parent
	billboard.AlwaysOnTop = alwaysOnTop
	billboard.Size = size
	billboard.StudsOffset = studsOffset
	
	if children then
		for _, child in children do
			child.Parent = billboard
		end
	end

	return billboard
end

function Placeholder.Frame(name: string, visible: boolean, size: UDim2, position: UDim2, backgroundColor: Color3, zIndex: number, children: {})
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Visible = visible
	frame.Size = size
	frame.Position = position or UDim2.new(0, 0, 0, 0)
	frame.BackgroundColor3 = backgroundColor
	frame.ZIndex = zIndex

	if children then
		for _, child in children do
			child.Parent = frame
		end
	end

	return frame
end

function Placeholder.TextLabel(name: string, visible: boolean, size: UDim2, position: UDim2, zIndex: number, color: Color3, alignmentX: Enum.TextXAlignment, alignmentY: Enum.TextYAlignment, children: {})
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Visible = visible
	label.Size = size
	label.Position = position or UDim2.new(0, 0, 0, 0)
	label.ZIndex = zIndex
	label.TextColor3 = color
	label.TextXAlignment = alignmentX
	label.TextYAlignment = alignmentY
	label.FontFace = GlobalConfig.Text
	label.TextScaled = true
	label.BackgroundTransparency = 1

	if children then
		for _, child in children do
			child.Parent = label
		end
	end

	return label
end

function Placeholder.ImageLabel(name: string, visible: boolean, size: UDim2, position: UDim2, zIndex: number, image: string, children: {})
	local label = Instance.new("ImageLabel")
	label.Name = name
	label.Visible = visible
	label.Size = size
	label.Position = position or UDim2.new(0, 0, 0, 0)
	label.ZIndex = zIndex
	label.Image = image or GlobalConfig.Image.Default
	label.ScaleType = Enum.ScaleType.Fit
	label.BackgroundTransparency = 1

	if children then
		for _, child in children do
			child.Parent = label
		end
	end

	return label
end

function Placeholder.UIAspectRatioConstraint(ratio: number)
	local ui = Instance.new("UIAspectRatioConstraint")
	ui.AspectRatio = ratio

	return ui
end

function Placeholder.UICorner(radius: UDim)
	local ui = Instance.new("UICorner")
	ui.CornerRadius = radius

	return ui
end

function Placeholder.UIListLayout(padding: UDim, fillDirection: Enum.FillDirection, sortOrder: Enum.SortOrder, horizontalAlignment: Enum.HorizontalAlignment, verticalAlignment: Enum.VerticalAlignment)
	local ui = Instance.new("UIListLayout")
	ui.Padding = padding
	ui.FillDirection = fillDirection
	ui.SortOrder = sortOrder
	ui.HorizontalAlignment = horizontalAlignment
	ui.VerticalAlignment = verticalAlignment

	return ui
end

function Placeholder.UIPadding(top: UDim, bottom: UDim, left: UDim, right: UDim)
	local ui = Instance.new("UIPadding")
	ui.PaddingTop = top
	ui.PaddingBottom = bottom
	ui.PaddingLeft = left
	ui.PaddingRight = right

	return ui
end

function Placeholder.UIStroke(color: Color3, thickness: number)
	local ui = Instance.new("UIStroke")
	ui.Color = color
	ui.Thickness = thickness

	return ui
end

return Placeholder
