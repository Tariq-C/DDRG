local Action = require("classes.Action")

local PTA = setmetatable({}, {__index = Action})
PTA.__index = PTA

function PTA:new(id)
    local self = setmetatable(Action:new(id), PTA)
    return self
end

function PTA:doAction(agent, target_party)

end

return PTA