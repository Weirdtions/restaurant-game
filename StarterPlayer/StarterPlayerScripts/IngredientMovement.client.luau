local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DropIngredient: RemoteEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DropIngredient")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local MAX_DISTANCE = 15 -- maximum distance in studs

RunService.RenderStepped:Connect(function()
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	local rootPos = character.HumanoidRootPart.Position

	for _, v in workspace.Ingredients:GetChildren() do
		if v:IsA("BasePart") and v:GetAttribute("CurrentPlayer") == player.Name then
			local targetAttachment = workspace.Terrain:FindFirstChild("TargetAttachment_" .. v.Name)

			if targetAttachment then
				local targetPos = mouse.Hit.Position
				local direction = (targetPos - rootPos)

				if direction.Magnitude > MAX_DISTANCE then
					targetPos = rootPos + (direction.Unit * MAX_DISTANCE)
				end

				targetAttachment.WorldPosition = targetPos + Vector3.new(0, 2, 0)
			end
		end
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local ownsIngredient = false

		for _, v in workspace.Ingredients:GetChildren() do
			if v:GetAttribute("CurrentPlayer") == player.Name then
				ownsIngredient = true
				break
			end
		end

		if ownsIngredient then
			DropIngredient:FireServer()
		end
	end
end)
