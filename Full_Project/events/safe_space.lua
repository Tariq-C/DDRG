local Event = require('events.event')
local SS = setmetatable({}, {__index = Event})
SS.__index = SS

function SS:new()
    local self = setmetatable({}, SS)
    self.stats = {}
    self.status = "Active"
    self:init()
    return self
end

function SS:init()
    self.type = 'safe_space'
    self.options = {}
    self.options['short_rest'] = true
    self.event_exp = 1
end

-- Change to accomodate party system
function SS:resolve(party)
    party:shortRest()
    party:DistributeExperience(self.event_exp)
    return true
end

return SS