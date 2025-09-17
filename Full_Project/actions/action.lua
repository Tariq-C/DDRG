local Action = {}
Action.__index = Action

function Action:new (id)
    local self = setmetatable({}, Action)
    self.id = id

    self:initialize()
    return self
end


function Action:initialize ()
    local id = self.id
    local action_data = require("database.actions")

    



end


return Action