-- Variables
local Stats = {}

local Server = require(script.Parent)
local Core, Player = Server:Core(), require(script.Parent.Player)

local Remotes, Config = Core:Remotes(), Core:Config()

-- Services and Paths
local Players, Update = game:GetService('Players'), Remotes:WaitForChild('UpdateStats')

-- Modules
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