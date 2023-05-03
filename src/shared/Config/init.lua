-- Modules
local Utililty = require(script.Parent.Utility)


local Config = { Configs = {} }

for _, v in pairs(script:GetChildren()) do
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

        return if #(... or {}) > 0 then ((if type(path) == "string" then path else "")):format(...) else path
    end
    
    return self.Configs[name]
end

return Config