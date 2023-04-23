local HttpService = game:GetService('HttpService')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local DataStoreService = game:GetService('DataStoreService')
local Util = require(script.Parent.Util)

local PlayerStore = DataStoreService:GetDataStore("PlayerData")

local Player = {
    Players = {}
}

function Player.Added(player: Player)
    local Functions = Player:Get(player)
    local Ready = Functions:CreateEvent('Ready'), Functions:CreateEvent('Changed')

    local success, data = pcall(function()
        return PlayerStore:GetAsync(tostring(player.UserId))
    end)

    data = data or {}

    if not success then
        Functions:Print('Failed to load data!', data)
        return player:Kick("Failed to load data!")
    end

    Player.Players[player.UserId] = data
    Functions:Print('Loaded data!', Functions:Stringify())

    Functions:SetKey('__temp', {})

    Ready:Fire()
end

function Player.Removing(player: Player)
    player = Player:Get(player)

    player:SetKey('__temp', nil)
    player:Dump()
end

function Player:Get(player)
    player = setmetatable({}, {__service = player, __index = Util.Wrap})

    function player:Print(init: string, ...)
        print(
            string.format('[%s] %s', self.Name, init)
        )

        for _, v in pairs((if type(... or nil) == "table" then ... else {...}) or {}) do
            print(
                string.format('- %s', v)
            )
        end
    end

    function player:GetEvent(name: string, isRunnable: boolean | nil): table | nil
        local event = self:WaitForChild(name)
        return if isRunnable then event else event.Event
    end

    function player:Changed(): RBXScriptSignal | BindableEvent | nil
        return self:GetEvent('Changed', false)
    end

    function player:Ready(): RBXScriptSignal | BindableEvent | nil
        return self:GetEvent('Ready', false)
    end

    function player:SetKey(key: string, value: any)
        self:Get()[key] = value
        
        if key ~= "__temp" then
            self:GetEvent('Changed', true):Fire(key, value, false)
        end
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
        self:GetEvent('Changed', true):Fire(key, value, true)
    end

    function player:Get(): table | nil
        return Player.Players[self.UserId] or {}
    end

    function player:Stringify(): string
        return HttpService:JSONEncode(self:Get() or {})
    end

    function player:Dump()
        local success, err = pcall(function()
            PlayerStore:SetAsync(tostring(self.UserId), self:Get())
        end)

        if not success then
            return self:Print('Failed to save data!', err)
        end

        self:Print('Saved data!', self:Stringify())
    end

    function player:Instance()
        return Players:GetPlayerByUserId(self.UserId)
    end

    function player:CreateEvent(name)
        local instance = Instance.new('BindableEvent', self:Instance())
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