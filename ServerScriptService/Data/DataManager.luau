local DataManager = {}

DataManager.Profiles = {}

function DataManager.AddPoints(player, points)
	local profile = DataManager.Profiles[player]
	if not profile then
		return
	end
	local data = profile.Data
	data.Points += points
	player.leaderstats.Points.Value = data.Points
end

return DataManager
