local folder = script.Parent
local BindableInput = folder.BindableInput
local RemoteInput = folder.RemoteInput
local PlayContext = folder.PlayContext
local ToggleCameraView: InputAction = PlayContext.ToggleCameraView

ToggleCameraView.Pressed:Connect(function()
	BindableInput:Fire("ToggleCameraView")
end)
