local ServerStorage = game:GetService("ServerStorage")
local API = require(ServerStorage.API)
local API_Config = API:GetConfig()
local player, mouse
local Config = {
	["HighlightItem"] = true, -- highlight the item?
	["HighlightColor"] = Color3.fromRGB(255, 255, 255), -- color of the highlight
	["HighlightTransparency"] = 1, -- transparency of the highlight

	["MaxForce"] = 1000, 
	["MaxTorque"] = 1000000, 
	["Responsiveness"] = 100, 

	["Interactable"] = true, -- can the crate be interacted with?
	["MaxInteractDistance"] = 10, -- max distance you can interact with the utensil

	["BillboardGui"] = true, -- show the billboard gui?

	["Folder"] = nil, -- folder of the tool, set to nil if you want to use the actual part in the workspace
}

local IngredientClass = {}
IngredientClass.__index = IngredientClass

function IngredientClass.new(part)
	local self = setmetatable({}, IngredientClass)

	self.Part = part
	self.Highlight, self.ClickDetector, self.BillboardGui = nil, nil, nil
	
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

	local highlight, clickDetector, billboard

	if Config.HighlightItem then
		highlight = Instance.new("Highlight")
		highlight.Enabled = false
		highlight.FillTransparency = Config.HighlightTransparency
		highlight.FillColor = Config.HighlightColor
		highlight.Parent = self.Part
	end

	if Config.Interactable then
		clickDetector = Instance.new("ClickDetector")
		clickDetector.MaxActivationDistance = Config.MaxInteractDistance
		clickDetector.Parent = self.Part
	end

	if Config.BillboardGui then
		billboard = Instance.new("BillboardGui")
		billboard.Enabled = false
		billboard.Parent = self.Part
		billboard.Size = UDim2.new(0, 100, 0, 50)
		billboard.StudsOffset = Vector3.new(-4, 0, 0)
		local frame = Instance.new("Frame")
		frame.Parent = billboard
		frame.Size = UDim2.new(1, 0, 1, 0)
		local textLabel = Instance.new("TextLabel")
		textLabel.Parent = frame
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.Text = self.Part.Name
	end

	self.Highlight = highlight
	self.ClickDetector = clickDetector
	self.BillboardGui = billboard
end

function IngredientClass:Init()
	local highlight: Highlight = self.Highlight
	local clickDetector: ClickDetector = self.ClickDetector
	local billboard: BillboardGui = self.BillboardGui

	if clickDetector then
		clickDetector.MouseClick:Connect(function(player)
			if #API:GetOwnedParts(player) >= API_Config.MaxIngredientsPerPlayer then return end
			self.Part.Parent = workspace.DraggableItems
			local utensil = IngredientClass.new(self.Part, self.Type)
			utensil:SetOwner(player)
		end)

		clickDetector.MouseHoverEnter:Connect(function()
			if highlight then
				highlight.Enabled = true
			end
			if billboard then
				billboard.Enabled = true
			end
		end)

		clickDetector.MouseHoverLeave:Connect(function()
			if highlight then
				highlight.Enabled = false
			end
			if billboard then
				billboard.Enabled = false
			end
		end)
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
