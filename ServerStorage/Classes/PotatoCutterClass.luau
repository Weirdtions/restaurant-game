local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CollisionService = require(ServerStorage.Services.CollisionService)
local SpawnItem: BindableEvent = ReplicatedStorage.Bindables.SpawnItem
local API = require(ServerStorage.API)

local Config = {
	["IgnoreCollision"] = {workspace.Characters},

	["HighlightItem"] = true,
	["HighlightColor"] = Color3.fromRGB(180, 255, 180),
	["HighlightTransparency"] = 0.8,

	["AcceptedIngredient"] = "Potato", -- only accepts potatos

	["ChoppedFolder"] = ReplicatedStorage.Assets.Chopped, -- folder of the chopped items

	["ChopCount"] = 1, -- how many chopped pieces to spawn

	["CooldownTime"] = 1, -- seconds between cuts to prevent spam

	["DetectionInterval"] = 0.2, -- seconds between collision checks (performance)
}

local PotatoCutterClass = {}
PotatoCutterClass.__index = PotatoCutterClass

function PotatoCutterClass.new(part)
	local self = setmetatable({}, PotatoCutterClass)

	self.Part = part
	self.Board = part.Parent:FindFirstChild("Board") -- where chopped items spawn
	self.Instances = {
		Highlight = nil,
		ClickDetector = nil,
	}

	self.IsOnCooldown = false
	self._Connection = nil

	self:ApplyConfig()

	return self
end

function PotatoCutterClass:ApplyConfig()
	if Config.HighlightItem then
		local highlight = Instance.new("Highlight")
		highlight.Enabled = false
		highlight.FillTransparency = Config.HighlightTransparency
		highlight.FillColor = Config.HighlightColor
		highlight.Parent = self.Part
		self.Instances.Highlight = highlight
		
		local clickDetector = Instance.new("ClickDetector")
		clickDetector.MaxActivationDistance = 10
		clickDetector.Parent = self.Parent
		self.Instances.ClickDetector = clickDetector
	end
end

function PotatoCutterClass:GetSpawnPosition(): Vector3
	if self.Board then
		return self.Board.Position + Vector3.new(0, 1, 0)
	else
		warn("No board found for potato cutter " .. self.Part.Name)
		return Vector3.zero
	end
end

function PotatoCutterClass:ProcessIngredient(ingredientPart: BasePart)
	print(self.IsOnCooldown, ingredientPart.Name == Config.AcceptedIngredient, CollectionService:HasTag(ingredientPart, "Ingredient"))
	if self.IsOnCooldown then return end
	if ingredientPart.Name ~= Config.AcceptedIngredient then return end
	if not CollectionService:HasTag(ingredientPart, "Ingredient") then return end

	self.IsOnCooldown = true

	local ownerName = ingredientPart:GetAttribute("CurrentPlayer")
	if ownerName then
		local player = game.Players:FindFirstChild(ownerName)
		if player then
			player:SetAttribute("CarryingItem", nil)
		end
	end

	ingredientPart:Destroy()

	local spawnPos = self:GetSpawnPosition()
	for i = 1, Config.ChopCount do
		SpawnItem:Fire(Config.AcceptedIngredient, spawnPos, Config.ChoppedFolder)
	end

	task.delay(Config.CooldownTime, function()
		self.IsOnCooldown = false
	end)
end

function PotatoCutterClass:Init()
	local highlight: Highlight = self.Instances.Highlight
	local clickDetector: ClickDetector = self.Instances.ClickDetector
	
	if highlight then
		clickDetector.MouseHoverEnter:Connect(function()
			self.Instances.Highlight.Enabled = true
		end)
		clickDetector.MouseHoverLeave:Connect(function()
			self.Instances.Highlight.Enabled = false
		end)
	end
	
	local elapsed = 0
	self._Connection = RunService.Heartbeat:Connect(function(deltaTime)
		elapsed += deltaTime
		if elapsed < Config.DetectionInterval then return end
		elapsed = 0

		if self.IsOnCooldown then return end

		local collidingParts = CollisionService.getCollidingParts(self.Part, Config.IgnoreCollision)

		for _, part in collidingParts do
			if part.Name == Config.AcceptedIngredient and CollectionService:HasTag(part, "Ingredient") then
				self:ProcessIngredient(part)
				break
			end
		end
	end)
end

function PotatoCutterClass:Destroy()
	if self._Connection then
		self._Connection:Disconnect()
		self._Connection = nil
	end
end

return PotatoCutterClass
