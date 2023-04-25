local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')

local Config = require(script.Parent.Config)

local UpdateBlock = ReplicatedStorage:WaitForChild('UpdateBlock') :: RemoteEvent

local DefaultStats = Config:Get('Building.DefaultStats')

local Building = {
    Parts = {}
}

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Wait()

    for k, v in pairs(Building.Parts) do
        UpdateBlock:FireClient(player, k, v)
    end
end)

function Building:Set(instance : Instance, settings : table)
    self.Parts[instance] = settings
end

function Building:Get(instance : Instance)
    return self.Parts[instance]
end

function Building:Create(instance : Instance)
    self:Set(instance, DefaultStats)

    UpdateBlock:FireAllClients(instance, settings)
end

for _, v in pairs(game.Workspace:FindFirstChild("Parts"):GetChildren()) do
    Building:Create(v)
end

return Building