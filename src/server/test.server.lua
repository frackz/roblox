local Players = game:GetService("Players")
local Player = require(script.Parent.Player)

Players.PlayerAdded:Connect(function(player)
    player = Player:Get(player)
    player:Ready():Wait()
end)
