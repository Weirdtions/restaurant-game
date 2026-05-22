local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local SpawnItem: BindableEvent = ReplicatedStorage.Bindables.SpawnItem
local InteractionConfig = require(ReplicatedStorage.Data.InteractionConfig)
local BeverageData = require(ReplicatedStorage.Data.BeverageData)

local StationClass = {}
StationClass.__index = StationClass

function StationClass.new(part, stationTag)
	local self = setmetatable({}, StationClass)

	self.Part = part
	self.Tag = stationTag
	self.Config = InteractionConfig.Stations[stationTag]

	self.Board = part.Parent and part.Parent:FindFirstChild("Board")
	self.Instances = {
		Highlight = nil,
		ClickDetector = nil,
	}

	self.IsOnCooldown = false

	self:ApplyConfig()

	return self
end

function StationClass:ApplyConfig()
	local highlight = Instance.new("Highlight")
	highlight.Enabled = false
	highlight.FillTransparency = 1
	highlight.FillColor = Color3.fromRGB(180, 255, 180)
	highlight.Parent = self.Part
	self.Instances.Highlight = highlight

	local clickDetector = Instance.new("ClickDetector")
	clickDetector.MaxActivationDistance = 10
	if self.Part.Parent then
		clickDetector.Parent = self.Part.Parent
	else
		clickDetector.Parent = self.Part
	end
	self.Instances.ClickDetector = clickDetector
end

function StationClass:GetSpawnPosition(): Vector3
	if self.Board then
		return self.Board.Position + Vector3.new(0, 1, 0)
	else
		return self.Part.Position + Vector3.new(0, 2, 0)
	end
end

function StationClass:ProcessIngredient(ingredientPart: BasePart)
	if self.IsOnCooldown then
		return
	end

	local isValid = false
	if self.Config.AcceptedItems then
		for _, item in ipairs(self.Config.AcceptedItems) do
			if item == ingredientPart.Name then
				isValid = true
				break
			end
		end
	end
	if self.Config.AcceptedTags then
		for _, tag in ipairs(self.Config.AcceptedTags) do
			if CollectionService:HasTag(ingredientPart, tag) then
				isValid = true
				break
			end
		end
	end

	if not isValid then
		return
	end

	self.IsOnCooldown = true

	if self.Config.DropItem then
		local ownerName = ingredientPart:GetAttribute("CurrentPlayer")
		if ownerName then
			local player = game.Players:FindFirstChild(ownerName)
			if player then
				player:SetAttribute("CarryingItem", nil)
			end
		end
	end

	if self.Config.Action == "Process" then
		ingredientPart:Destroy()
		local spawnPos = self:GetSpawnPosition()
		local folder = ReplicatedStorage.Assets:FindFirstChild(self.Config.OutputFolder)
		if folder then
			for i = 1, self.Config.OutputCount or 1 do
				SpawnItem:Fire(self.Config.OutputItem, spawnPos, folder)
			end
		else
			warn("Folder not found:", self.Config.OutputFolder)
		end
	elseif self.Config.Action == "Place" then
		ingredientPart:SetNetworkOwner(nil)
		if ingredientPart:FindFirstChild("FollowForce") then
			ingredientPart.FollowForce.Enabled = false
			ingredientPart.RotationForce.Enabled = false
		end

		ingredientPart.Position = self:GetSpawnPosition()
		ingredientPart.Parent = workspace
	elseif self.Config.Action == "Fill" then
		local beverageType
		if CollectionService:HasTag(self.Part, "Base") then
			beverageType = "Base"
		end
		local data = BeverageData[beverageType][self.Part.Name]

		local cup = ingredientPart.Handle
		local liquid = cup:FindFirstChild("Liquid")
		if liquid then
			liquid.Transparency = 0
			liquid.Color = data.Color
		end
	elseif self.Config.Action == "Destroy" then
		ingredientPart:Destroy()
	end

	task.delay(self.Config.Cooldown or 1, function()
		self.IsOnCooldown = false
	end)
end

function StationClass:Init()
	local highlight: Highlight = self.Instances.Highlight
	local clickDetector: ClickDetector = self.Instances.ClickDetector

	if highlight and clickDetector then
		clickDetector.MouseHoverEnter:Connect(function()
			highlight.Enabled = true
		end)
		clickDetector.MouseHoverLeave:Connect(function()
			highlight.Enabled = false
		end)
	end
end

function StationClass:Destroy() end

return StationClass
