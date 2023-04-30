-- Paths
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local Notification = ReplicatedStorage:WaitForChild('Notification') :: RemoteEvent
local Extension = {}

function Extension:New(player: Player)
    return function(text: string, color: string)
        Notification:FireClient(player, text, color)
    end
end

return Extension