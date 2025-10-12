local Action = require("classes.Action")

local STA = setmetatable({}, {__index = Action})
STA.__index = STA

function STA:new(id)
    local self = setmetatable(Action:new(id), STA)
    return self
end

function STA:doAction(agent, target_party)

end

return STA