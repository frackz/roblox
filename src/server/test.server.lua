local Players = game:GetService("Players")
local Player = require(script.Parent.Player)
local Config = require(script.Parent.Config)

Players.PlayerAdded:Connect(function(player)
    player = Player:Convert(player)
    player:Ready():Wait()
    player
    --[[player:Ready():Wait()

    print("After ready")

    player:SetTempKey('Plot', 1)
    player:SetKey('Cash', 250)

    -- new join
    player:GetKey('Cash')--]]
end)