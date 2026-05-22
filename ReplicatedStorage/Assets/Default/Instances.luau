local Instances = {}

function Instances.Tool(parent, handle: BasePart, texture: Content, grip: CFrame, canBeDropped: boolean)
	local tool = Instance.new("Tool")
	tool.Parent = parent
	tool.Name = handle.Name
	handle.Parent = tool
	handle.Name = "Handle"
	if texture then
		tool.TextureContent = texture
	end
	tool.Grip = grip or CFrame.new(0, 0, 0)
	tool.CanBeDropped = canBeDropped
	return tool
end

function Instances.Highlight(parent: BasePart?, enabled: boolean, fillTransparency: number, fillColor: Color3)
	local highlight = Instance.new("Highlight")
	highlight.Parent = parent or workspace
	highlight.Adornee = parent
	highlight.Enabled = enabled
	highlight.FillTransparency = fillTransparency or 0.5
	highlight.FillColor = fillColor or Color3.new(1, 1, 1)
	return highlight
end

function Instances.ClickDetector(parent: BasePart?, maxActivationDistance: number)
	local clickDetector = Instance.new("ClickDetector")
	clickDetector.Parent = parent or workspace
	clickDetector.MaxActivationDistance = maxActivationDistance
	return clickDetector
end

function Instances.Attachment(parent: BasePart?, position: Vector3, orientation: Vector3)
	local attachment = Instance.new("Attachment")
	attachment.Parent = parent
	attachment.Position = position or Vector3.zero
	attachment.Orientation = orientation or Vector3.zero
	return attachment
end

function Instances.AlignPosition(
	parent: BasePart,
	mode: Enum.PositionAlignmentMode,
	attachment0: Attachment,
	attachment1: Attachment,
	maxForce: number,
	responsiveness: number
)
	local alignPosition = Instance.new("AlignPosition")
	alignPosition.Parent = parent or workspace
	alignPosition.Mode = mode or Enum.PositionAlignmentMode.TwoAttachment
	alignPosition.Attachment0 = attachment0
	if alignPosition.Mode == Enum.PositionAlignmentMode.TwoAttachment then
		alignPosition.Attachment1 = attachment1
	end
	alignPosition.MaxForce = maxForce or 10000
	alignPosition.Responsiveness = responsiveness or 10
	return alignPosition
end

function Instances.AlignOrientation(
	parent: BasePart,
	mode: Enum.PositionAlignmentMode,
	attachment0: Attachment,
	attachment1: Attachment,
	maxTorque: number,
	responsiveness: number
)
	local alignOrientation = Instance.new("AlignOrientation")
	alignOrientation.Parent = parent or workspace
	alignOrientation.Mode = mode or Enum.PositionAlignmentMode.TwoAttachment
	alignOrientation.Attachment0 = attachment0
	if alignOrientation.Mode == Enum.PositionAlignmentMode.TwoAttachment then
		alignOrientation.Attachment1 = attachment1
	end
	alignOrientation.MaxTorque = maxTorque or 10000
	alignOrientation.Responsiveness = responsiveness or 10
	return alignOrientation
end

return Instances
