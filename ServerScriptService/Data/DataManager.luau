local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpdateNametag: BindableEvent = ReplicatedStorage:FindFirstChild("Bindables"):FindFirstChild("UpdateNametag")

local DataManager = {}
DataManager.Profiles = {}

function DataManager.AddPoints(player, points)
	local profile = DataManager.Profiles[player]
	print(profile)
	if not profile then
		return
	end
	local data = profile.Data
	data.Points += points
	player.leaderstats.Points.Value = data.Points
end

function DataManager.AddTag(player, tag, v)
	local profile = DataManager.Profiles[player]
	print(player, tag, v, profile)
	if not profile then
		return
	end
	local data = profile.Data
	if v == "Add" then
		if not table.find(data.Tags, tag) then
			table.insert(data.Tags, tag)
		end
	elseif v == "Sub" then
		local index = table.find(data.Tags, tag)

		if index then
			table.remove(data.Tags, index)
		end
	else
		return
	end
	UpdateNametag:Fire(player)
end

return DataManager
