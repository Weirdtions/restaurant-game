local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local CupClass = require(ServerStorage.Classes.CupClass)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UI = require(ReplicatedStorage.Assets.Default.UI)
local newInstance = require(ReplicatedStorage.Assets.Default.Instances)
local API = require(ServerStorage.API)
local Settings = API:GetSettings()
local Config = {
	["Stockable"] = false, -- can the container be stocked?
	["MaxStock"] = 10, -- max stock of the container
	["RestockActionText"] = "Restock",
	["RestockMaxDistance"] = 10,

	["HighlightItem"] = true, -- highlight the item?
	["HighlightColor"] = Color3.fromRGB(255, 255, 255), -- color of the highlight
	["HighlightTransparency"] = 1, -- transparency of the highlight

	["Interactable"] = true, -- can the container be interacted with?
	["MaxInteractDistance"] = 10, -- max distance you can interact with the container

	["BillboardGui"] = false, -- show the billboard gui?
	["StockLabel"] = false, -- show the stock label?

	["Folder"] = ReplicatedStorage.Assets.Cups, -- folder of the items in the container
}

local CupContainerClass = {}
CupContainerClass.__index = CupContainerClass

function CupContainerClass.new(part)
	local self = setmetatable({}, CupContainerClass)

	self.Part = part
	self.MaxStock = Config.MaxStock
	self.CurrentStock = Config.MaxStock
	self.Instances = {
		Highlight = nil,
		ClickDetector = nil,
		BillboardGui = nil,
		Label = nil,
		StockLabel = nil,
		RestockPrompt = nil,
	}

	self:ApplyConfig()

	return self
end

function CupContainerClass:ApplyConfig()
	if Config.HighlightItem then
		local highlight = newInstance.Highlight(self.Part, false, Config.HighlightTransparency, Config.HighlightColor)
		self.Instances.Highlight = highlight
	end
	if Config.Interactable then
		local clickDetector = newInstance.ClickDetector(self.Part, Config.MaxInteractDistance)
		self.Instances.ClickDetector = clickDetector
	end
	if Config.BillboardGui then
		-- TO-DO
	end
	if Config.StockLabel then
		-- TO-DO
	end
end

function CupContainerClass:Init()
	local highlight: Highlight = self.Instances.Highlight
	local clickDetector: ClickDetector = self.Instances.ClickDetector
	local billboard: BillboardGui = self.Instances.BillboardGui

	if clickDetector then
		clickDetector.MouseClick:Connect(function(player)
			if #API.getOwnedParts(player) >= Settings.MaxItemsPerPlayer then
				return
			end

			local v: BasePart = API.getItem(Config.Folder, self.Part.Name):Clone()
			v.Parent = workspace.Items
			local cup = CupClass.new(v)
			cup:Init(player)
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

return CupContainerClass
