local Party = require("groups.party")
local EP = setmetatable({}, {__index = Party})
EP.__index = EP

local Enemy = require("entities.Enemy")

function EP:new()
    local leader = Enemy:new()
    local self = setmetatable({}, EP)
    
    self.name = leader.name .. "'s party"
    self.members = {leader}
    self.num_members = math.random(1,3)
    self.event_exp = 1
    self.lowest_HP_index    = 1
    self.highest_Dmg_index  = 1
    self.leader_index       = 1

    self:init()
    return self
end

function EP:init()

    for i=0,self.num_members,1 do
        self:addMember(Enemy:new())
    end

end

function EP:printSummary()
    print (self.name .." Summary: ")
    for index,member in ipairs(self.members) do
        member:printSummary(index)
    end

end

return EP