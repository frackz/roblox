local HttpService = game:GetService('HttpService')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local DataStoreService = game:GetService('DataStoreService')

local PlayerStore = DataStoreService:GetDataStore("PlayerData")

local Bind = require(script.Parent.Bind)

local Player = {
    Players = {}
}

local function Wrap(Object, Interface)
    local Proxy = newproxy(true)
    local Meta = getmetatable(Proxy)

    function Meta:__index(Key)
        return Interface[Key] or Object[Key]
    end

    function Meta:__newindex(Key, Value)
        Object[Key] = Value
    end

    return Proxy
end

function Player:test(): string
    print("wthuwant")
    return "hey"
end

function Player.Added(player: Player)
    player = Player:Convert(player)    
    local Ready = player:CreateEvent('Ready')
    local Changed = player:CreateEvent('Changed')

    local success, data = pcall(function()
        return PlayerStore:GetAsync(tostring(player.Player.UserId))
    end)

    data = data or {}

    if not success then
        player:Print('Failed to load data!', data)
        return player.Player:Kick("Failed to load data!")
    end

    Player.Players[player.Player.UserId] = data
    player:Print('Loaded data!', player:Stringify())

    player:SetKey('__temp', {})

    Ready:Fire()
    print("FIRE")
end

function Player.Removing(player: Player)
    player = Player:Convert(player)

    player:SetKey('__temp', nil)

    player:Dump()
end

function Player:Convert(player)
    player = {
        Player = player :: Player
    }

    function player:Print(init: string, ...)
        print(
            string.format('[%s] %s', player.Player.Name, init)
        )

        for _, v in pairs((if type(... or nil) == "table" then ... else {...}) or {}) do
            print(
                string.format('- %s', v)
            )
        end
    end

    function player:GetEvent(name: string): table | nil
        local changed = self.Player:WaitForChild(name) :: BindableEvent

        local data = {}
        function data:Fire(...)
            changed:Fire(...)
        end

        return Wrap(changed.Event, data)
    end

    function player:Changed(): table | nil
        return self:GetEvent('Changed')
    end

    function player:Ready(): table | nil
        return self:GetEvent('Ready')
    end

    function player:SetKey(key: string, value: any)
        self:Get()[key] = value
        
        self:Changed():Fire(key, value)
    end

    function player:GetKey(key: string)
        return self:Get()[key]
    end

    function player:GetTempKey(key: string)
        return (self:GetKey('__temp') or {})[key]
    end

    function player:SetTempKey(key: string, value: any)
        local temp = self:GetKey('__temp')
        temp[key] = value

        self:SetKey('__temp', temp)
    end

    function player:Get(): table | nil
        return Player.Players[player.Player.UserId] or {}
    end

    function player:Stringify(): string
        return HttpService:JSONEncode(self:Get() or {})
    end

    function player:Dump()
        print("DUMP")
        local success, err = pcall(function()
            print(self:Get())
            PlayerStore:SetAsync(tostring(self.Player.UserId), self:Get())
            print("set")
        end)

        print("HEY")
        if not success then
            return self:Print('Failed to save data!', err)
        end

        self:Print('Saved data!', self:Stringify())
    end

    function player:CreateEvent(name)
        local instance = Instance.new('BindableEvent', player.Player)
        instance.Name = name
        return instance
    end

    return player
end

Players.PlayerAdded:Connect(Player.Added)
Players.PlayerRemoving:Connect(Player.Removing)

game:BindToClose(function()
    if not RunService:IsStudio() then
        for _, v in pairs(Players:GetPlayers()) do
            Player.Added(v)
        end
    end
end)

return Player