local TextChatService = game:GetService("TextChatService")
local CommandsFolder = TextChatService.Commands
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local DataManager = require(ServerScriptService.Data.DataManager)
local ServerStorage = game:GetService("ServerStorage")
local API = require(ServerStorage.API)

local Points = CommandsFolder.Points
local Tags = CommandsFolder.Tags
local Rainbow = CommandsFolder.Rainbow

local function getTarget(executor, inputName)
	if not inputName or inputName == "me" then
		return executor
	end
	return Players:FindFirstChild(inputName)
end

local Commands = {
	["add"] = function(player, args)
		local targetPlayer = getTarget(player, args[1])
		local amount = tonumber(args[2])

		if targetPlayer and amount then
			DataManager.AddPoints(targetPlayer, amount)
		end
	end,

	["sub"] = function(player, args)
		local targetPlayer = getTarget(player, args[1])
		local amount = tonumber(args[2])

		if targetPlayer and amount then
			DataManager.AddPoints(targetPlayer, -amount)
		end
	end,

	["addtag"] = function(player, args)
		local targetPlayer = getTarget(player, args[1])
		local tag = args[2]

		if targetPlayer and tag then
			DataManager.AddTag(targetPlayer, tag, "Add")
		end
	end,

	["subtag"] = function(player, args)
		local targetPlayer = getTarget(player, args[1])
		local tag = args[2]

		if targetPlayer and tag then
			DataManager.AddTag(targetPlayer, tag, "Sub")
		end
	end,

	["rainbow"] = function(player, args)
		local targetPlayer = getTarget(player, args[1])

		if targetPlayer then
			API.rainbowNametag(targetPlayer)
		end
	end,
}

local function triggerCommand(textSource, text)
	print(tostring(textSource) .. " used command " .. tostring(text))
	local player = Players:GetPlayerByUserId(textSource.UserId)
	if not player then
		return
	end

	local cleanText = string.match(text, "^%s*(.*)%s*$")
	if cleanText == "" then
		return
	end

	local args = string.split(cleanText, " ")
	local commandName = table.remove(args, 1):lower()

	local action = Commands[string.sub(commandName, 2)]
	if action then
		action(player, args)
	else
		warn("Command " .. commandName .. " does not exist")
	end
end

Points.Triggered:Connect(triggerCommand)
Tags.Triggered:Connect(triggerCommand)
Rainbow.Triggered:Connect(triggerCommand)
