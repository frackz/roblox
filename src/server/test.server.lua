local Players = game:GetService("Players")
local Player = require(script.Parent.Player)

Players.PlayerAdded:Connect(function(player)
    player = Player:Convert(player)
    player:Ready()

    player:SetKey('test', 'bbo')
end)