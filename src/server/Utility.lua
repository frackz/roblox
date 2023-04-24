local Utility = {}

--- Wrap services together
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

function Utility:Split(text: string, sep: string)
    local list = {}
    string.gsub(text, '[^'..sep..']+', function(w)
        table.insert(list, w)
    end)
    return list
end

return Utility