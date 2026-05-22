local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local BindableInput: BindableEvent = PlayerGui:WaitForChild("Inputs"):WaitForChild("BindableInput")
local character = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()

mouse.Icon = "http://www.roblox.com/asset/?id=11232270592"
local isFirstPerson = false

BindableInput.Event:Connect(function(action)
	print(action)
	if action == "ToggleCameraView" then
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
