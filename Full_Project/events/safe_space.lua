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
    self.short_rest_length = 100
    self.partyStatus = "Short Resting"
end

-- Change to accomodate party system
function SS:resolve(party)
    if (party:inShortRest()) then
        party:shortRest()
    elseif (party:willShortRest()) then     
        party:shortRest(self.short_rest_length)
    end
    party:DistributeExperience(self.event_exp)
    return true
end

return SS