-- Paths
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Core = ReplicatedStorage:WaitForChild('Core')

-- Modules
local Items = require(Core:WaitForChild('Items'))

-- Variables
local Extension = {}

function Extension:New(player: Player)
    local Inventory = {
        Categories = Items:Get(),
        Items = Items:GetItems(),
        Player = player
    }

    --- Set the inventory data
    function Inventory:Set(data: table)
        return self.Player:SetKey('Inventory', data)
    end

    --- Get all the items from the inventory
    function Inventory:GetAll()
        return self.Player:GetKey('Inventory') or {}
    end

    --- Give a item to the player, can also specifiy a amount
    function Inventory:Give(item: string, amount: number?)
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

    --- Remove a item from the player, you can also use a amount
    function Inventory:Remove(item: string, amount: number?)
        amount = amount or 1

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

    --- Clear the inventory
    function Inventory:Clear()
        return self:Set({})
    end

    --- Get a item
    function Inventory:Get(item: string)
        return self:GetAll()[item]
    end

    --- Check if the player has a item
    function Inventory:Has(item: string)
        return self:Get(item) ~= nil
    end

    return Inventory
end

return Extension