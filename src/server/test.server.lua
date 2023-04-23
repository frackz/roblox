local Players = game:GetService("Players")
local Player = require(script.Parent.Player)
local Config = require(script.Parent.Config)

Players.PlayerAdded:Connect(function(player)
    local plr = Player:Convert(player)
    plr:Ready():Wait()
    
    plr:Changed():Connect(function(key, value, temp)
        print(key,value,temp)
    end)

    plr:SetKey('Cash', 100)
    plr:SetTempKey('Plot', 1)
    
    --[[player:Ready():Wait()

    print("After ready")

    player:SetTempKey('Plot', 1)
    player:SetKey('Cash', 250)

    -- new join
    player:GetKey('Cash')--]]
end)