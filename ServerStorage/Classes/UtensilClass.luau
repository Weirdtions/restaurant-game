local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local UseItem: RemoteEvent = ReplicatedStorage.Remotes.UseItem
local ChopIngredient: BindableEvent = ReplicatedStorage.Bindables.ChopIngredient
local ServerStorage = game:GetService("ServerStorage")
local CollisionService = require(ServerStorage.Services.CollisionService)
local API = require(ServerStorage.API)
local Settings = API:GetSettings()
local Config = {
	["IgnoreCollision"] = {workspace.Characters, workspace.Items},

	["HighlightItem"] = true, -- highlight the item?
	["HighlightColor"] = Color3.fromRGB(255, 255, 255), -- color of the highlight
	["HighlightTransparency"] = 1, -- transparency of the highlight

	["MaxForce"] = 1000, 
	["MaxTorque"] = 1000000, 
	["Responsiveness"] = 100, 

	["Interactable"] = true, -- can the crate be interacted with?
	["MaxInteractDistance"] = 10, -- max distance you can interact with the crate

	["BillboardGui"] = true, -- show the billboard gui?
}

local UtensilClass = {}
UtensilClass.__index = UtensilClass

function UtensilClass.new(part)
	local self = setmetatable({}, UtensilClass)

	self.Part = part
	self.Instances = {
		Highlight = nil,
		ClickDetector = nil,
		Billboard = nil,
		Label = nil,
	}

	self.IsUsing = false
	self._Connection = nil

	self.TargetAttachment = Instance.new("Attachment")
	self:Setup()
	self:ApplyConfig()

	return self
end

function UtensilClass:Setup()
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

function UtensilClass:ApplyConfig()
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

	if Config.BillboardGui then
		local billboard = Instance.new("BillboardGui")
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
		self.Instances.BillboardGui = billboard
		self.Instances.Label = textLabel
	end
end

function UtensilClass:Init()
	local highlight: Highlight, clickDetector: ClickDetector, billboard: BillboardGui = self.Instances.Highlight, self.Instances.ClickDetector, self.Instances.BillboardGui

	if clickDetector then

		clickDetector.MouseClick:Connect(function(player)
			local character = player.Character
			if not character or (character.PrimaryPart.Position - self.Part.Position).Magnitude > Config.MaxInteractDistance + 2 then return end
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

function UtensilClass:SetOwner(player)
	if not self.Part:GetAttribute("Guid") then
		self.Part:SetAttribute("Guid", game:GetService("HttpService"):GenerateGUID(false))
	end

	self.Part:SetNetworkOwner(player)
	player:SetAttribute("CarryingItem", self.Part:GetAttribute("Guid"))

	self.Part.FollowForce.Enabled = true
	self.Part.RotationForce.Enabled = true
end

function UtensilClass:StartUsing()
	if self._Connection then return end

	self.IsUsing = true

	self._Connection = RunService.Heartbeat:Connect(function(dt)
		if not self.IsUsing then 
			self:StopUsing()
			return 
		end

		local collidingParts = CollisionService.getCollidingParts(self.Part, Config.IgnoreCollision)

		for _, part in collidingParts do
			if CollectionService:HasTag(part, "Ingredient") then
				self.IsUsing = false 
				ChopIngredient:Fire(part)
				self:StopUsing() 
				break
			end
		end
	end)
end

function UtensilClass:StopUsing()
	self.IsUsing = false
	if self._Connection then
		self._Connection:Disconnect()
		self._Connection = nil
	end
end

return UtensilClass
