local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Core = ReplicatedStorage:WaitForChild('Core')
local Items = require(Core:WaitForChild('Items'))

local Extension = {}

function Extension:New(player )
    local Inventory = {
        Categories = Items:Get(),
        Items = Items:GetItems(),
        Player = player
    }

    function Inventory:Set(data)
        return self.Player:SetKey('Inventory', data)
    end

    function Inventory:GetAll()
        return self.Player:GetKey('Inventory') or {}
    end

    function Inventory:Give(item, amount)
        amount = amount or 1

        if not self.Items[item] then
            return false, "invalid_item"
        end

        local items = self:GetAll()
        if self:Has(item) then
            items[item] += amount
        else
            items[item] = amount
        end
        
        self:Set(items)
    end

    function Inventory:Remove(item, amount)
        if not self:Has(item) or self:Get(item) < amount then
            return false, "not_enough_items"
        end

        local items = self:GetAll()
        if self:Get(item) - amount ~= 0 then
            items[item] -= amount         
        end

        items[item] = nil

        self:Set(items)
    end

    function Inventory:Clear()
        self:Set({})
    end

    function Inventory:Get(item)
        return self:GetAll()[item]
    end

    function Inventory:Has(item)
        return self:Get(item) ~= nil
    end

    return Inventory
end

return Extension