local Init = {}

function Init:Resources()
    return script:WaitForChild('Resources')
end

function Init:Remotes()
    return self:Resources():WaitForChild('Remotes')
end

function Init:Get(name: string)
    return script:WaitForChild(name)
end

return Init