local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')

local UpdateBlock = ReplicatedStorage:WaitForChild('UpdateBlock') :: RemoteEvent
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local PartStats = PlayerGui:WaitForChild('PartStats') :: ScreenGui
local Title = PartStats:WaitForChild('Title') :: TextLabel
local Health = PartStats:WaitForChild('Health') :: TextLabel

local Mouse = Player:GetMouse()

local Building = { Parts = {} }
local Current

function Building:Update(instance : Instance)
    self:Set(true)
    if instance ~= Current then
        local part = self.Parts[instance]
        Current = instance

        Title.Text = instance.Name
        Health.Text = part.Health
    end
end

function Building:Set(bool)
    if Title.Visible ~= bool then
        Title.Visible = bool
        Health.Visible = bool
    end
end

UpdateBlock.OnClientEvent:Connect(function(instance : Instance, settings)
    Building.Parts[instance] = settings
end)

Mouse.Move:Connect(function()
    local part = Mouse.Target
    local target = Building.Parts[part]
    
    if target then
        Building:Update(part)
    else
        Building:Set(false)
    end
end)

return Building