-- Variables
local Extension = {}

function Extension:New(player: Player)
    local Cash = {
        Player = player
    }

    --- Get the players cash
    function Cash:Get()
        return self.Player:GetKey('Cash') or 0
    end

    --- Set the players cash
    function Cash:Set(amount: number)
        return self.Player:SetKey('Cash', amount)
    end

    --- Give the player some cash
    function Cash:Add(amount: number)
        self:Set(self:Get() + amount)
    end

    --- Remove some cash
    function Cash:Remove(amount: number)
        if Cash:Has(amount) then
            return true, self:Set(self:Get() - amount)
        end
    end

    --- Check if player has cash
    function Cash:Has(amount: number)
        return self:Get() >= amount
    end

    return Cash
end

return Extension