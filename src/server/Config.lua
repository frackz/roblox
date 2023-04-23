local Configs = script.Parent:WaitForChild('Configs')

local Config = {
    Configs = {}
}

for _, v in pairs(Configs:GetChildren()) do
    Config.Configs[v.Name] = require(v)
end

local function Split(text, sep)
    local list = {}
    string.gsub(text, '[^'..sep..']+', function(w)
        table.insert(list, w)
    end)
    return list
end

function Config:Get(name: string, ...)
    local splitted = Split(name, '.')
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
    end

    return nil
end

return Config