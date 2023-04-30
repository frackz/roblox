-- Services
local Players = game:GetService('Players')

-- Paths
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Core = ReplicatedStorage:WaitForChild('Core')
local Update = ReplicatedStorage:WaitForChild('UpdateStats') :: RemoteEvent

-- Modules
local Player = require(script.Parent.Player)
local Config = require(Core:WaitForChild('Config'))

-- Variables
local Stats = {}

function Stats:Update(player, name, value)
    Update:FireClient(
        player:Instance(),
        name,
        Config:Get('Player.Cash', tostring(value))
    )
end

Players.PlayerAdded:Connect(function(player)
    player = Player:Get(player)
    player:Ready():Wait()

    Stats:Update(player, 'Cash', player:Cash():Get())

    player:Changed():Connect(function(name, value, temp)
        if not temp and name == "Cash" then
            Stats:Update(player, name, value)
        end
    end)
end)

return Stats