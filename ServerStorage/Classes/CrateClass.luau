local ServerStorage = game:GetService("ServerStorage")
local API = require(ServerStorage.API)
local API_Config = API:GetConfig()
local IngredientClass = require(ServerStorage.Classes.IngredientClass)
local Config = {
	["MaxStock"] = 25, -- max stock of the crate
	["MaxIngredientsPerPlayer"] = 1, -- max ingredients you can select

	["HighlightItem"] = true, -- highlight the item?
	["HighlightColor"] = Color3.fromRGB(255, 255, 255), -- color of the highlight
	["HighlightTransparency"] = 1, -- transparency of the highlight

	["Interactable"] = true, -- can the crate be interacted with?
	["MaxInteractDistance"] = 10, -- max distance you can interact with the crate

	["BillboardGui"] = true, -- show the billboard gui?

	["Folder"] = ServerStorage.Ingredients, -- folder of the items in the crate
}

local CrateClass = {}
CrateClass.__index = CrateClass

function CrateClass.new(part)
	local self = setmetatable({}, CrateClass)

	self.Part = part
	self.MaxStock = Config.MaxStock
	self.Highlight, self.ClickDetector, self.BillboardGui = self:ApplyConfig()

	return self
end

function CrateClass:ApplyConfig()
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

	return highlight, clickDetector, billboard
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

function CrateClass:Init()
	local highlight: Highlight = self.Highlight
	local clickDetector: ClickDetector = self.ClickDetector
	local billboard: BillboardGui = self.BillboardGui

	if clickDetector then
		clickDetector.MouseClick:Connect(function(player)
			if #API:GetOwnedParts(player) >= API_Config.MaxIngredientsPerPlayer then return end
			local v: BasePart = getIngredient(self.Part.Name):Clone()
			v.Parent = workspace.DraggableItems
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
