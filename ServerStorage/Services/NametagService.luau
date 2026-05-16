-- Weirdtions

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UI = require(ReplicatedStorage.UI.UI)

local NametagService = {}
local ActiveNametags: {[Player]: BillboardGui} = {}

export type NametagConfig = {
	Title: string?,
	TitleColor: Color3?,
	NameColor: Color3?,
	BackgroundColor: Color3?,
	BorderColor: Color3?,
	GradientStart: Color3?,
	GradientEnd: Color3?,
	GradientRotation: number?,
	Visible: boolean?
}

local DEFAULT_CONFIG: NametagConfig = {
	Title = "Title Example",
	TitleColor = Color3.fromRGB(255, 255, 255),
	NameColor = Color3.fromRGB(255, 255, 255),
	BackgroundColor = Color3.fromRGB(255, 255, 255),
	BorderColor = Color3.fromRGB(255, 255, 255),
	GradientStart = nil, -- no gradient by default
	GradientEnd = nil,
	GradientRotation = 0,
	Visible = true
}

local PlayerConfigs: {[Player]: NametagConfig} = {}

function NametagService.CreateNametag(player: Player, character: Model)
	NametagService.RemoveNametag(player)

	local head = character:WaitForChild("Head", 5)
	if not head then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end

	local billboard = UI.NametagGui(head)
	billboard.Parent = head
	ActiveNametags[player] = billboard

	local config = PlayerConfigs[player] or DEFAULT_CONFIG
	NametagService.UpdateNametag(player, config)
end

function NametagService.UpdateNametag(player: Player, config: NametagConfig)
	local currentConfig = PlayerConfigs[player] or table.clone(DEFAULT_CONFIG)

	if config then
		for k, v in config do
			currentConfig[k] = v
		end
	end

	PlayerConfigs[player] = currentConfig

	local billboard = ActiveNametags[player]
	if not billboard then return end

	local mainFrame = billboard:FindFirstChild("MainFrame")
	if not mainFrame then return end

	if currentConfig.BackgroundColor then
		mainFrame.BackgroundColor3 = currentConfig.BackgroundColor
	end

	local stroke = mainFrame:FindFirstChildOfClass("UIStroke")
	if stroke and currentConfig.BorderColor then
		stroke.Color = currentConfig.BorderColor
	end

	local titleLabel = mainFrame:FindFirstChild("TitleLabel")
	if titleLabel then
		if currentConfig.Title and currentConfig.Title ~= "" then
			titleLabel.Visible = true
			titleLabel.Text = currentConfig.Title
			if currentConfig.TitleColor then titleLabel.TextColor3 = currentConfig.TitleColor end
		else
			titleLabel.Visible = false
		end
	end

	local nameLabel = mainFrame:FindFirstChild("NameLabel")
	if nameLabel then
		nameLabel.Text = player.DisplayName
		if currentConfig.NameColor then nameLabel.TextColor3 = currentConfig.NameColor end
	end

	if currentConfig.Visible ~= nil then
		billboard.Enabled = currentConfig.Visible
	end
end 

function NametagService.RemoveNametag(player: Player)
	local billboard = ActiveNametags[player]
	if billboard then
		billboard:Destroy()
		ActiveNametags[player] = nil
	end
end

function NametagService.ClearConfig(player: Player)
	PlayerConfigs[player] = nil
end

return NametagService
