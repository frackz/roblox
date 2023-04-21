local HttpService = game:GetService('HttpService')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local DataStoreService = game:GetService('DataStoreService')

local PlayerStore = DataStoreService:GetDataStore("PlayerData")

local Bind = require(script.Parent.Bind)

local Player = {
    Players = {}
}

function Player.Added(player: Player)
    player = Player:Convert(player)
    
    local success, data = pcall(function()
        return PlayerStore:GetAsync(player.UserId)
    end)

    data = data or {}

    if not success then
        player:Print('Failed to load data!', data)
        return player:Kick("Failed to load data!")
    end

    Player.Players[player.UserId] = data
    player:Print('Loaded data!', player:Stringify())

    player:Ready():Fire()
end

function Player.Removing(player: Player)
    player = Player:Convert(player)

    player:Dump()
end

function Player:Convert(player: Player)
    player = setmetatable({}, {__index = player})
    local CreateEvent = Bind(Instance.new, 'BindableEvent')

    function player:Print(init: string, ...)
        print(
            string.format('[%s] %s', player.Name, init)
        )

        for _, v in pairs((if type(... or nil) == "table" then ... else {...}) or {}) do
            print(
                string.format('- %s', v)
            )
        end
    end

    function player:Changed(): RBXScriptSignal | nil
        return (self:Get()['Changed'] or {Event = nil}).Event
    end

    function player:Ready(): RBXScriptSignal | nil
        return (self:Get()['Ready'] or {Event = nil}).Event
    end

    function player:SetKey(key: string, value: any)
        self:Get()[key] = value
        print(self:Get())
    end

    function player:GetKey()
        
    end

    function player:Get(): table | nil
        return Player.Players[player.UserId]
    end

    function player:Stringify(): string
        return HttpService:JSONEncode(self:Get() or {})
    end

    function player:Dump()
        local success, err = pcall(function()
            PlayerStore:SetAsync(player.UserId, self:Get())
        end)

        if not success then
            return self:Print('Failed to save data!', err)
        end

        self:Print('Saved data!', self:Stringify())
    end

    if not player:FindFirstChild('Changed') then
        player:Get()['Changed'] = CreateEvent()
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