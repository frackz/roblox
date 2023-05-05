-- Modules
local Client = require(script.Parent)

-- Variables
local Remotes = Client:Core():Remotes()
local Stats = {}

-- Paths
local UpdateStats = Remotes:WaitForChild('UpdateStats') :: RemoteEvent
local StatsGui = Client:Gui():WaitForChild('Stats')

function Stats:Update(name: string, value: any)
    local text = StatsGui:FindFirstChild(name) :: TextLabel | nil

    if text then
        text.Text = value
    end
end

UpdateStats.OnClientEvent:Connect(function(name, value)
    Stats:Update(name, value)
end)

return Stats