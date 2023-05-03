local Init = {}

function Init:Resources()
    return script:WaitForChild('Resources')
end

function Init:Remotes()
    return self:Resources():WaitForChild('Remotes')
end

function Init:Config()
    return require(script:WaitForChild('Config'))
end

function Init:Items()
    return require(script:WaitForChild('Items'))
end

function Init:Utility()
    return require(script:WaitForChild('Utility'))
end

return Init