local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Core = ReplicatedStorage:WaitForChild('Core')

local Init = {}

function Init:Core()
    return require(Core)
end

return Init