local ServerStorage = game:GetService("ServerStorage")
local API = require(ServerStorage.API)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChopIngredient: BindableEvent = ReplicatedStorage.Bindables.ChopIngredient
local SpawnItem: BindableEvent = ReplicatedStorage.Bindables.SpawnItem
local Settings = API:GetSettings()
local Config = {
	["HighlightItem"] = true, -- highlight the item?
	["HighlightColor"] = Color3.fromRGB(255, 255, 255), -- color of the highlight
	["HighlightTransparency"] = 1, -- transparency of the highlight

	["MaxForce"] = 1000, 
	["MaxTorque"] = 1000000, 
	["Responsiveness"] = 100, 

	["Interactable"] = true, -- can the crate be interacted with?
	["MaxInteractDistance"] = 10, -- max distance you can interact with the crate

	["BillboardGui"] = true, -- show the billboard gui?

	["ChoppedFolder"] = ReplicatedStorage.Assets.Chopped, -- folder of the chopped items

	["ChopCount"] = { -- how many parts an ingredient is split when chopped
		["Default"] = 3,
		["Tomato"] = 3,
	}
}

local IngredientClass = {}
IngredientClass.__index = IngredientClass

function IngredientClass.new(part)
	local self = setmetatable({}, IngredientClass)

	self.Part = part
	self.Highlight, self.ClickDetector, self.BillboardGui = self:ApplyConfig()
	self.Chopped = false

	self.TargetAttachment = Instance.new("Attachment")
	self:Setup()
	self:Init()
	self._connection = ChopIngredient.Event:Connect(function(part)
		if self.Chopped then return end
		if part ~= self.Part then return end
		self:OnChopped(part)
	end)

	return self
end

function IngredientClass:Setup()
	local attachment = Instance.new("Attachment")
	attachment.Name = "CenterAttachment"
	attachment.Parent = self.Part

	local alignPosition = Instance.new("AlignPosition")
	alignPosition.Name = "FollowForce"
	alignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
	alignPosition.Attachment0 = attachment
	alignPosition.Position = self.Part.Position 
	alignPosition.MaxForce = Config.MaxForce
	alignPosition.Responsiveness = Config.Responsiveness
	alignPosition.Enabled = false
	alignPosition.Parent = self.Part

	local alignOrientation = Instance.new("AlignOrientation")
	alignOrientation.Name = "RotationForce"
	alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	alignOrientation.Attachment0 = attachment
	alignOrientation.CFrame = self.Part.CFrame 
	alignOrientation.MaxTorque = Config.MaxTorque
	alignOrientation.Responsiveness = Config.Responsiveness
	alignOrientation.Enabled = false
	alignOrientation.Parent = self.Part
end

function IngredientClass:ApplyConfig()
	local highlight, clickDetector, billboard

	if Config.HighlightItem then
		highlight = Instance.new("Highlight")
		highlight.Enabled = true
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

	return highlight, clickDetector, billboard
end

function IngredientClass:Init()
	local clickDetector, billboard, highlight = self.ClickDetector, self.BillboardGui, self.Highlight

	if clickDetector then
		clickDetector.MouseClick:Connect(function(player)
			if #API.getOwnedParts(player) >= Settings.MaxItemsPerPlayer then return end
			self.Part.Parent = workspace.Items
			self:SetOwner(player)
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
	if not self.Part:GetAttribute("Guid") then
		self.Part:SetAttribute("Guid", game:GetService("HttpService"):GenerateGUID(false))
	end

	self.Part:SetNetworkOwner(player)
	player:SetAttribute("CarryingItem", self.Part:GetAttribute("Guid"))

	self.Part.FollowForce.Enabled = true
	self.Part.RotationForce.Enabled = true
end

function IngredientClass:Destroy()
	if self._connection then
		self._connection:Disconnect()
		self._connection = nil
	end

	if self.Part then
		self.Part:Destroy()
	end
end

function IngredientClass:OnChopped(part)
	if self.Chopped then return end

	if part == self.Part then
		local originalPosition = self.Part.Position
		for i=1, (Config.ChopCount[part.Name] or Config.ChopCount.Default) do
			SpawnItem:Fire(part.Name, originalPosition, Config.ChoppedFolder)
		end
		self:Destroy()
		return
	end

	self:Destroy()
end

return IngredientClass
