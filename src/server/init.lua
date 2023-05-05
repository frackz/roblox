-- Variables
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Core = ReplicatedStorage:WaitForChild('Core')

-- Variables
local Init = {}

-- Replicated Storage Core
function Init:Core()
    return require(Core)
end

-- Files for requirement
function Init:Stats() return require(script.Stats) end
function Init:Cash() return require(script.Cash) end

return Init