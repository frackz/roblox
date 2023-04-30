-- Services
local Players = game:GetService('Players')

-- Variables
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local Stats = {
    Cash = 0
}

-- Paths
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpdateStats = ReplicatedStorage:WaitForChild('UpdateStats') :: RemoteEvent

local StatsGui = PlayerGui:WaitForChild('Stats')

-- Modules
local Notifications = require(script.Parent.Notifications)

function Stats:Update(name: string, value: any)
    local text = StatsGui:FindFirstChild(name) :: TextLabel | nil
    if text then
        self[name] = value

        text.Text = value
        Notifications:Set('Text', 'Success')
    end
end

UpdateStats.OnClientEvent:Connect(function(name, value)
    Stats:Update(name, value)
end)

return Stats