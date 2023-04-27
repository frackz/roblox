-- Modules
local Utililty = require(script.Parent.Utility)

-- Services
local HttpService = game:GetService('HttpService')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local DataStoreService = game:GetService('DataStoreService')

local PlayerStore = DataStoreService:GetDataStore("PlayerData")
local Player = { Players = {} }

function Player.Added(player: Player)
    player = Player:Get(player)
    local Ready = player:CreateEvent('Ready'), player:CreateEvent('Changed')

    local success, data = pcall(function()
        return PlayerStore:GetAsync(tostring(player.UserId))
    end)

    data = data or {}

    if not success then
        player:Print('Failed to load data!', data)
        return player:Kick("Failed to load data!")
    end

    Player.Players[player.UserId] = data
    player:Print('Loaded data!', player:Stringify())

    player:SetKey('__temp', {})

    Ready:Fire()
end

function Player.Removing(player: Player)
    player = Player:Get(player)

    player:SetKey('__temp', nil)
    player:Dump()
end

--- Convert the player to add the methods...
function Player:Get(player)
    player = setmetatable({}, {__service = player, __index = Utililty.Wrap})

    --- Print something with the player's name on it, mostly used for debugging
    function player:Print(init: string, ...)
        print(
            ('[%s] %s'):format(self.Name, init)
        )

        for _, v in pairs((if type(... or nil) == "table" then ... else {...}) or {}) do
            print(
                ('- %s'):format(v)
            )
        end
    end

    --- Get a event by name, either a BindableEvent or a RBXScriptSignal
    function player:GetEvent(name: string, isRunnable: boolean | nil): BindableEvent | RBXScriptSignal
        local event = self:WaitForChild(name)
        return if isRunnable then event else event.Event
    end

    --- Get the changed event, this will get fired whenever a key get changed
    function player:Changed(): RBXScriptSignal | nil
        return self:GetEvent('Changed', false)
    end

    --- Get the ready event, use this for PlayerAdded() and stuff
    function player:Ready(): RBXScriptSignal  | nil
        return self:GetEvent('Ready', false)
    end

    --- Set a key to a value, this will be saved (like Cash, etc)
    function player:SetKey(key: string, value: any)
        self:Get()[key] = value
        
        if key ~= "__temp" then
            self:GetEvent('Changed', true):Fire(key, value, false)
        end
    end

    --- Get a saved-key's value (like Cash, etc)
    function player:GetKey(key: string): any
        return self:Get()[key]
    end

    --- Get a temporary key, so this data won't save (like Plot, etc)
    function player:GetTempKey(key: string): any
        return (self:GetKey('__temp') or {})[key]
    end

    --- set a temporary key, this will not save (like Plot, etc)
    function player:SetTempKey(key: string, value: any)
        local temp = self:GetKey('__temp')
        temp[key] = value

        self:SetKey('__temp', temp)
        self:GetEvent('Changed', true):Fire(key, value, true)
    end

    --- Get all player data
    function player:Get(): table | nil
        return Player.Players[self.UserId] or {}
    end

    --- Stringify the player data, mostly used to print data
    function player:Stringify(): string
        return HttpService:JSONEncode(self:Get() or {})
    end

    --- Dump the player's data inside the Datastore.
    function player:Dump(): boolean | nil
        local success, err = pcall(function()
            PlayerStore:SetAsync(tostring(self.UserId), self:Get())
        end)

        if not success then
            return false, self:Print('Failed to save data!', err)
        end

        self:Print('Saved data!', self:Stringify())
    end

    --- Get the instance of the player, because Roblox recognizes this as a table and not a instance
    function player:Instance(): Player
        return Players:GetPlayerByUserId(self.UserId)
    end

    --- Create a BindableEvent by name
    function player:CreateEvent(name: string)
        local instance = Instance.new('BindableEvent', self:Instance())
        instance.Name = name
        return instance
    end

    return player
end

Players.PlayerAdded:Connect(Player.Added)
Players.PlayerRemoving:Connect(Player.Removing)

-- When a server closes, it will save everyone's data
game:BindToClose(function()
    if not RunService:IsStudio() then
        for _, v in pairs(Players:GetPlayers()) do
            Player.Removing(v)
        end
    end
end)

return Player