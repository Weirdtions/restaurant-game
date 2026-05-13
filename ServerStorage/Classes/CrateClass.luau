local ServerStorage = game:GetService("ServerStorage")
local IngredientClass = require(ServerStorage.Classes.IngredientClass)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local API = require(ServerStorage.API)
local Settings = API:GetSettings()
local Config = {
	["MaxStock"] = 10, -- max stock of the crate

	["HighlightItem"] = true, -- highlight the item?
	["HighlightColor"] = Color3.fromRGB(255, 255, 255), -- color of the highlight
	["HighlightTransparency"] = 1, -- transparency of the highlight

	["Interactable"] = true, -- can the crate be interacted with?
	["MaxInteractDistance"] = 10, -- max distance you can interact with the crate

	["BillboardGui"] = true, -- show the billboard gui?
	["StockLabel"] = true, -- show the stock label?

	["Folder"] = ReplicatedStorage.Assets.Ingredients, -- folder of the items in the crate
}

local CrateClass = {}
CrateClass.__index = CrateClass

function CrateClass.new(part)
	local self = setmetatable({}, CrateClass)

	self.Part = part
	self.MaxStock = Config.MaxStock
	self.CurrentStock = Config.MaxStock
	self.Instances = {
		Highlight = nil,
		ClickDetector = nil,
		Billboard = nil,
		Label = nil,
		StockLabel = nil,
	}

	self:ApplyConfig()

	return self
end

function CrateClass:ApplyConfig()
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

	if Config.StockLabel then
		local stockLabel = self.Part:FindFirstChild("SurfaceGui"):FindFirstChild("TextLabel")
		stockLabel.Text = tostring(self.CurrentStock)
		self.Instances.StockLabel = stockLabel
	end
end

local function getIngredient(name)
	local folder = Config.Folder
	local ingredient = folder:FindFirstChild(name)

	if not ingredient then
		warn("Ingredient not found: " .. name)
		return
	end

	return ingredient
end

function CrateClass:AddStock(amount: number)
	self.CurrentStock = math.clamp(self.CurrentStock + amount, 0, self.MaxStock)
	self.Instances.StockLabel.Text = tostring(self.CurrentStock)
end

function CrateClass:Init()
	local highlight: Highlight = self.Instances.Highlight
	local clickDetector: ClickDetector = self.Instances.ClickDetector
	local billboard: BillboardGui = self.Instances.BillboardGui

	if clickDetector then
		clickDetector.MouseClick:Connect(function(player)

			if #API.getOwnedParts(player) >= Settings.MaxItemsPerPlayer then return end
			if self.CurrentStock <= 0 then return end

			local v: BasePart = getIngredient(self.Part.Name):Clone()
			self:AddStock(-1)
			v.Parent = workspace.Items
			local ingredient = IngredientClass.new(v)
			ingredient:SetOwner(player)

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

return CrateClass
