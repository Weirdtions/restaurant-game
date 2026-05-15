local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local ServerStorage = game:GetService("ServerStorage")
local API = require(ServerStorage.API)
local Settings = API:GetSettings()

local Config = {
	MaxInteractDistance = 8,
	["Interactable"] = true,
	["HighlightItem"] = true, -- highlight the item?
	["HighlightColor"] = Color3.fromRGB(255, 255, 255), -- color of the highlight
	["HighlightTransparency"] = 1, -- transparency of the highlight

	PackageSize = Vector3.new(2, 1.5, 2),
	PackageColor = Color3.fromRGB(139, 90, 43),
	PackageMaterial = Enum.Material.WoodPlanks,

	MaxForce = 1000,
	MaxTorque = 1000000,
	Responsiveness = 100,
}

local SupplyBoxClass = {}
SupplyBoxClass.__index = SupplyBoxClass

function SupplyBoxClass.new(part: BasePart)
	local self = setmetatable({}, SupplyBoxClass)
	self.Part = part
	self.Instances = {
		Highlight = nil,
		ClickDetector = nil,
	}
	
	self:ApplyConfig()
	return self
end

function SupplyBoxClass:ApplyConfig()
	if Config.HighlightItem then
		local highlight = Instance.new("Highlight")
		highlight.Enabled = false
		highlight.FillTransparency = Config.HighlightTransparency
		highlight.FillColor = Config.HighlightColor
		highlight.Parent = self.Part
		self.Instances.Highlight = highlight
	end

	if Config.Interactable then
		local clickDetector = Instance.new("ClickDetector")
		clickDetector.MaxActivationDistance = Config.MaxInteractDistance
		clickDetector.Parent = self.Part
		self.Instances.ClickDetector = clickDetector
	end
end

function SupplyBoxClass:CreatePackage(player: Player): BasePart
	local package = Instance.new("Part")
	package.Name = "RestockPackage"
	package.Size = Config.PackageSize
	package.Color = Config.PackageColor
	package.Material = Config.PackageMaterial
	package.Anchored = false
	package.CanCollide = true

	CollectionService:AddTag(package, "RestockPackage")

	local guid = HttpService:GenerateGUID(false)
	package:SetAttribute("Guid", guid)
	package:SetAttribute("CurrentPlayer", player.Name)

	local attachment = Instance.new("Attachment")
	attachment.Name = "CenterAttachment"
	attachment.Parent = package

	local alignPosition = Instance.new("AlignPosition")
	alignPosition.Name = "FollowForce"
	alignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
	alignPosition.Attachment0 = attachment
	alignPosition.MaxForce = Config.MaxForce
	alignPosition.Responsiveness = Config.Responsiveness
	alignPosition.Enabled = false
	alignPosition.Parent = package

	local alignOrientation = Instance.new("AlignOrientation")
	alignOrientation.Name = "RotationForce"
	alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	alignOrientation.Attachment0 = attachment
	alignOrientation.MaxTorque = Config.MaxTorque
	alignOrientation.Responsiveness = Config.Responsiveness
	alignOrientation.Enabled = false
	alignOrientation.Parent = package

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart") :: BasePart
	package.Position = if root
		then root.Position + Vector3.new(0, 3, 0)
		else self.Part.Position + Vector3.new(0, 3, 0)

	package.Parent = workspace.Items

	package:SetNetworkOwner(player)
	player:SetAttribute("CarryingItem", guid)
	package.FollowForce.Enabled = true
	package.RotationForce.Enabled = true

	return package
end

function SupplyBoxClass:Init()
	local highlight: Highlight = self.Instances.Highlight
	local clickDetector: ClickDetector = self.Instances.ClickDetector
	clickDetector.MaxActivationDistance = Config.MaxInteractDistance
	clickDetector.Parent = self.Part

	clickDetector.MouseClick:Connect(function(player: Player)
		if player:GetAttribute("CarryingItem") then return end
		if #API.getOwnedParts(player) >= Settings.MaxItemsPerPlayer then return end

		local character = player.Character
		if not character then return end
		local root = character:FindFirstChild("HumanoidRootPart") :: BasePart
		if not root then return end
		if (root.Position - self.Part.Position).Magnitude > Config.MaxInteractDistance + 2 then return end

		self:CreatePackage(player)
	end)
	
	clickDetector.MouseHoverEnter:Connect(function(player: Player)
		if highlight then
			highlight.Enabled = true
		end
	end)
	
	clickDetector.MouseHoverLeave:Connect(function(player: Player)
		if highlight then
			highlight.Enabled = false
		end
	end)
end

return SupplyBoxClass
