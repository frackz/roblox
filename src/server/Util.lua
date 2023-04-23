local Utility = {}

function Utility:Wrap(key: string)
    local service = getmetatable(self).__service
	local success, output = pcall(function()
		return service[key]
	end)
	
	if not success then
		error(output)
	end
	
	if type(output) == "function" then
		return function(_, ...)
			return output(service, ...)
		end
	else
		return output
	end
end

return Utility