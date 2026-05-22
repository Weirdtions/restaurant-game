local ServerStorage = game:GetService("ServerStorage")
local API = require(ServerStorage.API)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UI = require(ReplicatedStorage.Assets.Default.UI)
local newInstance = require(ReplicatedStorage.Assets.Default.Instances)
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
}

local CupClass = {}
CupClass.__index = CupClass

function CupClass.new(part)
	local self = setmetatable({}, CupClass)

	self.Part = part
	self.Instances = {
		Highlight = nil,
		ClickDetector = nil,
		BillboardGui = nil,
		StockLabel = nil,
	}

	self:ApplyConfig()

	return self
end

function CupClass:ApplyConfig()
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

function CupClass:Init(player)
	local clickDetector, billboard, highlight =
		self.Instances.ClickDetector, self.Instances.BillboardGui, self.Instances.Highlight
	local tool = newInstance.Tool(player.Backpack, self.Part, nil, nil, false)
	tool.Parent = player.Character

	if clickDetector then
		clickDetector.MouseClick:Connect(function(player)
			if #API.getOwnedParts(player) >= Settings.MaxItemsPerPlayer then
				return
			end
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

return CupClass
