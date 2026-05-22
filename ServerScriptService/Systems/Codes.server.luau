local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RedeemCode: RemoteFunction = ReplicatedStorage.Remotes.RedeemCode
local ServerScriptService = game:GetService("ServerScriptService")
local ProfileStore = require(ServerScriptService.Packages.ProfileStore)
local DataManager = require(ServerScriptService.Data.DataManager)
local ServerStorage = game:GetService("ServerStorage")
local API = require(ServerStorage.API)

local activeCodes = {
	["WEIRD"] = {Points = 100},
	["RAINBOW"] = {Other = "rainbow"},
	["HEART"] = {Tag = "❤️"},
}

RedeemCode.OnServerInvoke = function(player, code)
	if type(code) ~= "string" then return end
	local profile = DataManager.Profiles[player]
	if not profile then return false, "Try again" end
	
	local reward = activeCodes[code]
	print(reward)
	if not reward then return false, "Invalid code" end
	
	if table.find(profile.Data.RedeemedCodes, code) then return false, "Code already redeemed" end
	
	if reward.Points then
		DataManager.AddPoints(player, reward.Points)
	end
	
	if reward.Other then
		if reward.Other == "rainbow" then
			API.rainbowNametag(player)
		end
	end
	
	if reward.Tag then
		DataManager.AddTag(player, reward.Tag, "Add")
	end
	
	table.insert(profile.Data.RedeemedCodes, code)

	return true, "Code redeemed successfully!"
end