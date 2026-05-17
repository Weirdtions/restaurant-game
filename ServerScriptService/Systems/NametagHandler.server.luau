local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local DataManager = require(ServerScriptService.Data.DataManager)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpdateNametag: BindableEvent = ReplicatedStorage.Bindables.UpdateNametag
local UI = require(ReplicatedStorage.UI.UI)
local TagData = require(ReplicatedStorage.Data.TagData)

local ActiveNametags: {[Player]: BillboardGui} = {}

local function createNametag(player: Player, character: Model)
	local profile = DataManager.Profiles[player]
	if not profile then warn("No profile found for", player.Name) return end
	
	local head = character:FindFirstChild("Head")
	if not head then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end
	local billboard = UI.NametagGui(head, player)
	billboard.Parent = head
	ActiveNametags[player] = billboard
	
	if profile.Data.Tags then
		for _, tag in profile.Data.Tags do
			local t = UI.Tag(tag, TagData[tag])
			t.Parent = billboard.MainFrame.Tags
		end
	end
end

local function removeNametag(player: Player)
	local billboard = ActiveNametags[player]
	if billboard then
		billboard:Destroy()
		ActiveNametags[player] = nil
	end
end

local function onCharacterAdded(player: Player, character: Model)
	task.defer(function()
		if not player.Parent then return end
		createNametag(player, character)
	end)
end

local function onPlayerAdded(player: Player)
	task.wait(1)
	local profile = DataManager.Profiles[player]
	if not profile then warn("No profile found for", player.Name) return end
	
	if player.Character then
		onCharacterAdded(player, player.Character)
	end

	player.CharacterAdded:Connect(function(character)
		onCharacterAdded(player, character)
	end)
end

local function onPlayerRemoving(player: Player)
	removeNametag(player)
end

for _, player in Players:GetPlayers() do
	task.spawn(onPlayerAdded, player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

UpdateNametag.Event:Connect(function(player: Player)
	removeNametag(player)
	createNametag(player, player.Character)
end)