local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GamepassConfig = require(ReplicatedStorage.Data.GamepassConfig)

local GamepassService = {}
local Cache = {}

function GamepassService.HasGamepass(player: Player, gamepassName: string): boolean
	local gamepassId = GamepassConfig[gamepassName]
	if not gamepassId or gamepassId == 0 then
		return false
	end

	local userId = player.UserId
	local cacheKey = userId .. "_" .. gamepassId

	if Cache[cacheKey] ~= nil then
		return Cache[cacheKey]
	end

	local success, owns = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(userId, gamepassId)
	end)

	if success then
		Cache[cacheKey] = owns
		return owns
	end

	return false
end

function GamepassService.ClearCache(player: Player)
	local userId = player.UserId
	for key, _ in Cache do
		if string.find(key, tostring(userId) .. "_") == 1 then
			Cache[key] = nil
		end
	end
end

return GamepassService
