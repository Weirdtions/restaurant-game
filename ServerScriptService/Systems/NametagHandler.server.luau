local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local NametagService = require(ServerStorage.Services.NametagService)

local function onCharacterAdded(player: Player, character: Model)
	task.defer(function()
		if not player.Parent then return end
		NametagService.CreateNametag(player, character)
	end)
end

local function onPlayerAdded(player: Player)
	if player.Character then
		onCharacterAdded(player, player.Character)
	end

	player.CharacterAdded:Connect(function(character)
		onCharacterAdded(player, character)
	end)
end

local function onPlayerRemoving(player: Player)
	NametagService.RemoveNametag(player)
	NametagService.ClearConfig(player)
end

for _, player in Players:GetPlayers() do
	task.spawn(onPlayerAdded, player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
