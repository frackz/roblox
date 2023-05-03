-- Variables
local Server = require(script.Parent)

local Core = Server:Core()
local Remotes = Core:Remotes()

local Notification = Remotes:WaitForChild('Notification') :: RemoteEvent
local Extension = {}

function Extension:New(player: Player)
    return function(text: string, color: string)
        Notification:FireClient(player, text, color)
    end
end

return Extension