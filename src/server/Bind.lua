return function(func, ...)
    local args = ...
    return function ()
        return func(args)
    end
end