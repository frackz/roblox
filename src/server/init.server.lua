local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Resources = ReplicatedStorage:WaitForChild('Resources')

local Init = {}

function Init:Core()
    return ReplicatedStorage:WaitForChild('Core')
end

return Init

--[[return {
    require(script.Player),
    require(script.Inventory),
    require(script.Cash),
    require(script.Stats)
}--]]