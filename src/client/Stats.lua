local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UpdateStats = ReplicatedStorage:WaitForChild('UpdateStats') :: RemoteEvent
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local StatsGui = PlayerGui:WaitForChild('Stats')

local Stats = {
    Cash = 0
}

function Stats:Update(name: string, value: any)
    local text = StatsGui:FindFirstChild(name) :: TextLabel | nil
    if text then
        self[name] = value

        text.Text = value
    end
end

UpdateStats.OnClientEvent:Connect(function(name, value)
    Stats:Update(name, value)
end)

return Stats