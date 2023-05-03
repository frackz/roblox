-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService('Players')

-- Variables
local Init = {}
local Core = require(ReplicatedStorage:WaitForChild('Core'))

-- Functions
function Init:Core() return Core end
function Init:Player() return Players.LocalPlayer end
function Init:Gui() return self:Player().PlayerGui end

return Init