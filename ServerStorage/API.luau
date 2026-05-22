local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local newInstance = require(ReplicatedStorage.Assets.Default.Instances)
local API = {}

local Settings = {
	["MaxItemsPerPlayer"] = 1, -- max items you can select
}

function API:GetSettings()
	return Settings
end

function API.getOwnedParts(player)
	local ownedParts = {}
	for _, v in workspace.Items:GetChildren() do
		if v:GetAttribute("CurrentPlayer") == player.Name then
			table.insert(ownedParts, v)
		end
	end

	return ownedParts
end

function API.getItem(folder: Folder, name: string)
	return folder:FindFirstChild(name)
end

function API.findItemByGuid(guid: string): BasePart?
	for _, item in workspace.Items:GetChildren() do
		if item:IsA("BasePart") and item:GetAttribute("Guid") == guid then
			return item
		end
	end
	return nil
end

function API.cleanChildren(part)
	for _, v in part:GetChildren() do
		v:Destroy()
	end
end

function API.setupMovableItem(parent: BasePart, config: {})
	local attachment = newInstance.Attachment(parent, nil, nil)
	attachment.Name = "CenterAttachment"
	local alignPosition = newInstance.AlignPosition(
		parent,
		Enum.PositionAlignmentMode.OneAttachment,
		attachment,
		nil,
		config.MaxForce,
		config.Responsiveness
	)
	alignPosition.Enabled = false
	alignPosition.Name = "FollowForce"
	local alignOrientation = newInstance.AlignOrientation(
		parent,
		Enum.OrientationAlignmentMode.OneAttachment,
		attachment,
		nil,
		config.MaxTorque,
		config.Responsiveness
	)
	alignOrientation.Enabled = false
	alignOrientation.Name = "RotationForce"
end

function API.rainbowText(label: TextLabel)
	local gradient = Instance.new("UIGradient")
	gradient.Parent = label

	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
	})

	local tweenInfo = TweenInfo.new(
		10, -- duration
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.InOut,
		-1, -- -1 for infinite
		false, -- reverse
		-1 -- delay
	)

	gradient.Offset = Vector2.new(-1, 0)
	local rainbowTween = TweenService:Create(gradient, tweenInfo, {
		Offset = Vector2.new(1, 0),
	})

	rainbowTween:Play()
end

function API.rainbowNametag(player: Player)
	local character = player.Character or player.CharacterAdded:Wait()
	local head = character:FindFirstChild("Head")
	local label = head.Nametag.MainFrame.NameLabel
	local gradient = Instance.new("UIGradient")
	gradient.Parent = label

	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
	})

	local tweenInfo = TweenInfo.new(
		10, -- duration
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.InOut,
		-1, -- -1 for infinite
		false, -- reverse
		-1 -- delay
	)

	gradient.Offset = Vector2.new(-1, 0)
	local rainbowTween = TweenService:Create(gradient, tweenInfo, {
		Offset = Vector2.new(1, 0),
	})

	rainbowTween:Play()
end

return API
