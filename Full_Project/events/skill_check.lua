local Event = require('events.event')
local SC = setmetatable({}, {__index = Event})
SC.__index = SC


function SC:new()
    local self = setmetatable({}, SC)
    self.stats = {}
    self.status = "Active"
    self.attemptTurnCost = 10
    self.attempt = 0
    self:init()
    return self
end

function SC:init()
    self.type   = 'skill_check'
    self.status = "Active"
    self.completed = false
    self.skill = "speed" -- TODO: Connect to dungeon generator
    self.value = math.random(5,25)      -- TODO: Connect to dungeon generator
    self.remaining_value = self.value
    self.cost  = 2       -- TODO: Connect to dungeon generator
    self.event_exp = 5
    self.partyStatus = 'Attempting Skill Check'
end


-- TODO: Change to fit party system
function SC:resolve(party)
    if (self.attempt <= 0) then 
        self.remaining_value = self.remaining_value - party:attemptSkillCheck(self.skill)
        if (self.remaining_value <= 0) then
            self.remaining_value = 0
            self.completed = true
            self:reset()
            return true
        end
    else
        self.attempt = self.attempt - 1
    end
    return false
end

function SC:reset()
    self.status = "Active"
    self.completed = false
    self.remaining_value = self.value
    self.attempt = self.attemptTurnCost
    return true
end

return SC