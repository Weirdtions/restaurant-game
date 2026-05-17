local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()

mouse.Icon = "http://www.roblox.com/asset/?id=11232270592"
local isFirstPerson = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.V then
		local head = character:WaitForChild("Head")
		local nametag = head:WaitForChild("Nametag")
		if isFirstPerson then
			player.CameraMode = Enum.CameraMode.Classic
			player.CameraMinZoomDistance = 15
			nametag.Enabled = true
		else
			player.CameraMode = Enum.CameraMode.LockFirstPerson
			nametag.Enabled = false
		end
		isFirstPerson = not isFirstPerson
	end
end)