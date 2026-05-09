local player, mouse
local Config = {
	["HighlightItem"] = true, -- highlight the item?
	["HighlightColor"] = Color3.fromRGB(255, 255, 255), -- color of the highlight
	["HighlightTransparency"] = 1, -- transparency of the highlight

	["MaxForce"] = 1000, 
	["MaxTorque"] = 1000000, 
	["Responsiveness"] = 100, 
}

local IngredientClass = {}
IngredientClass.__index = IngredientClass

function IngredientClass.new(part)
	local self = setmetatable({}, IngredientClass)

	self.Part = part
	
	self.TargetAttachment = Instance.new("Attachment")
	self:Setup()

	return self
end

function IngredientClass:Setup()
	self.Part.CanCollide = true
	self.Part.Anchored = false

	local attachment0 = Instance.new("Attachment")
	attachment0.Parent = self.Part

	self.TargetAttachment.Parent = self.Part
	self.TargetAttachment.Name = "TargetAttachment_" .. self.Part.Name
	self.TargetAttachment.Parent = workspace.Terrain

	local alignPosition = Instance.new("AlignPosition")
	alignPosition.Attachment0 = attachment0
	alignPosition.Attachment1 = self.TargetAttachment
	alignPosition.MaxForce = Config.MaxForce
	alignPosition.Responsiveness = Config.Responsiveness
	alignPosition.Mode = Enum.PositionAlignmentMode.TwoAttachment
	alignPosition.Parent = self.Part

	local alignOrientation = Instance.new("AlignOrientation")
	alignOrientation.Attachment0 = attachment0
	alignOrientation.Attachment1 = self.TargetAttachment
	alignOrientation.MaxTorque = Config.MaxTorque
	alignOrientation.Responsiveness = Config.Responsiveness
	alignOrientation.Parent = self.Part

	if Config.HighlightItem then
		local highlight = Instance.new("Highlight")
		highlight.Enabled = true
		highlight.FillTransparency = Config.HighlightTransparency
		highlight.FillColor = Config.HighlightColor
		highlight.Parent = self.Part
	end
end

function IngredientClass:SetOwner(player)
	self.Part:SetNetworkOwner(player)
	self.Part:SetAttribute("TargetAttachment", self.TargetAttachment.Name)
	self.Part:SetAttribute("CurrentPlayer", player.Name)
end

function IngredientClass:GiveUpOwner()
	self.Part:SetNetworkOwner(nil)
	self.Part:SetAttribute("CurrentPlayer", "")
end

return IngredientClass
