local Init = {}

-- Folders
function Init:Resources() return script.Resources end
function Init:Remotes() return self:Resources().Remotes end

-- Files for requirement
function Init:Config() return require(script.Config) end
function Init:Items() return require(script.Items) end
function Init:Utility() return require(script.Utility) end

return Init