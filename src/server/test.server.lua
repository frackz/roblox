local Players = game:GetService("Players")
local Player = require(script.Parent.Player)

Players.PlayerAdded:Connect(function(player)
    player = Player:Get(player)
    player:Ready():Wait()

    player:Changed():Connect(function(key, value, temp)
        print(key,value,temp)
    end)

    player:SetKey('Cash', 100)
    player:SetTempKey('Plot', 1)
end)