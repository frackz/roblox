local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Screen = PlayerGui:WaitForChild('Notifactions') :: ScreenGui
local Label = Screen:WaitForChild('Notification') :: TextLabel

local Border = Label:WaitForChild('Border') :: UIStroke
local Contexual = Label:WaitForChild('Contexual') :: UIStroke

local Notifications = {
    Delay = 0,
    Text = nil,
    Colors = {
        Success = {
            Background = Color3.new(0.223529, 0.890196, 0.058823),
            Stroke = Color3.new(0.121568, 0.658823, 0.156862)
        },
        Info = {
            Background = Color3.new(1, 1, 1),
            Stroke = Color3.new(0.615686, 0.607843, 0.607843)
        },
        Error = {
            Background = Color3.new(0.913725, 0.031372, 0.031372),
            Stroke = Color3.new(0.811764, 0.180392, 0.180392)
        }
    }
}
function Notifications:Update(text: string, background: Color3, stroke: Color3)
    Border.Color = stroke
    Contexual.Color = stroke

    Label.BackgroundColor3 = background
    Label.Text = text
end

function Notifications:Set(text: string, type: string)
    local colors = self.Colors[type]
    if not colors then
        return
    end

    self:Update(colors.Background, colors.Stroke, text)

    self.Delay = 3
end

return Notifications