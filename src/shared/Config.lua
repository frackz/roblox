-- Modules
local Utililty = require(script.Parent.Utility)

local Configs = script.Parent:WaitForChild('Configs')

local Config = { Configs = {} }

for _, v in pairs(Configs:GetChildren()) do
    Config.Configs[v.Name] = require(v)
end

--- Get a config key by path
function Config:Get(name: string, ...)
    local splitted = Utililty:Split(name, '.')
    if #splitted > 1 then
        local path = self.Configs

        for _, v in pairs(splitted) do
            local nextPath = path[v]
            if not nextPath then
                return nil, error("Invalid path")
            end

            path = nextPath
        end

        return if #(... or {}) > 0 then string.format((if type(path) == "string" then path else ""), ...) else path
    else
        return self.Configs[name]
    end

    return nil
end

return Config