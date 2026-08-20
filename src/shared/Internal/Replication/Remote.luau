local remote = (script.Parent:FindFirstChild("RemoteFunction") or Instance.new("RemoteFunction")) :: RemoteFunction
remote.Parent = script.Parent

return remote
