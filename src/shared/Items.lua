local Config = require(script.Parent.Config)

local Items = {
    Items = Config:Get('Items')
}

function Items:Get()
    return self.Items
end

function Items:Items()
    local items = self:Get()
    local data = {}
    for k,v in pairs(items) do
        for name, value in pairs(v) do
            value['Category'] = k
            data[name] = value
        end
    end

    return data
end

return Items