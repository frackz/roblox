local Extension = {}

function Extension:New(player: Player)
    local Cash = {
        Player = player
    }

    function Cash:Get()
        
    end

    return Cash
end

return Extension