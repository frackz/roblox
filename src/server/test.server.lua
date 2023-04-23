local Players = game:GetService("Players")
local Player = require(script.Parent.Player)

Players.PlayerAdded:Connect(function(player)
    player = Player:Convert(player)
    player:Ready():Wait()

    print("After ready")

    player:SetTempKey('Plot', 1)
    player:SetKey('Cash', 250)

    -- new join
    player:GetKey('Cash')
end)