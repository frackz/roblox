-- This is just to start the initialized module-script
require(script.Parent)

-- Run all modules
for _,v in pairs(script.Parent:GetChildren()) do
    if v:IsA('ModuleScript') then
        require(v)
    end
end