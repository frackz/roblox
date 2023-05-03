-- Variables
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Core = ReplicatedStorage:WaitForChild('Core')

-- Variables
local Init = {}

function Init:Core()
    return require(Core)
end

function Init:Inventory()
    return require(script:WaitForChild('Inventory'))
end

function Init:Notifications()
    return require(script:WaitForChild('Notifications'))
end

function Init:Stats()
    return require(script:WaitForChild('Stats'))
end

function Init:Cash()
    return require(script:WaitForChild('Cash'))
end

return Init