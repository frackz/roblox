-- Modules
local Client = require(script.Parent)
local Core = Client:Core()

local Config = Core:Config()
local Remotes = Core:Remotes()

-- Required
local Notification = Remotes:WaitForChild('Notification') :: RemoteEvent

-- Variables
local Notifications = {
    Delay = 0,
    Text = nil,
    Colors = Config:Get('Notifications')
}

-- GUIS
local Screen = Client:Gui():WaitForChild('Notifications') :: ScreenGui
local Label = Screen:WaitForChild('Notification') :: TextLabel

local Border = Label:WaitForChild('Border') :: UIStroke
local Contexual = Label:WaitForChild('Contexual') :: UIStroke

coroutine.resume(coroutine.create(function()
    while wait(1) do
        local delay = Notifications.Delay
        if delay <= 0 then
            return
        end

        delay -= 1
        if delay == -1 then
            Label.Visible = false
        end

        Notifications.Delay = delay
    end
end))

--- Update the colors / and text
function Notifications:Update(text: string, background: Color3, stroke: Color3)
    Border.Color = stroke
    Contexual.Color = stroke

    Label.BackgroundColor3 = background
    Label.Text = text
    Label.Visible = true
end

--- Set the notification label
function Notifications:Set(text: string, color: string)
    local colors = self.Colors[color]
    if not colors then
        return
    end

    self:Update(text, colors.Background, colors.Stroke)
    self.Delay = 3
end

Notification.OnClientEvent:Connect(function(text, color)
    Notifications:Set(text, color)
end)

return Notifications