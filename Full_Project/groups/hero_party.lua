local Party = require("groups.party")
local HP = setmetatable({}, {__index = Party})
HP.__index = HP

function HP:new(leader)
    local self = setmetatable({}, HP)
    self.name = leader.name .. "'s party"
    self.members    = {leader}
    self:init()
    return self
end

function HP:init()
    self.party_size = 1
    self.lowest_HP_index    = 1
    self.highest_Dmg_index  = 1
    self.leader_index       = 1
    self.currentFloor       = 0
    self.currentEvent       = 1
    self.inCity             = 1
end

function HP:shortRest()
    for i,member in ipairs(self.members) do
        if (member:canShortRest()) then
            member:short_rest()
        end
    end
end

function HP:longRest()
    for i,member in ipairs(self.members) do
        member:longRest()
    end
end

function HP:DistributeExperience(experience)
    local exp_split = experience / #self.members
    for i,member in ipairs(self.members) do
        member:obtainExp(exp_split)
    end
end

function HP:ascend()
    self.currentFloor = self.currentFloor + 1
    for i,member in ipairs(self.members) do
        member:recordFloor(self.currentFloor)
    end
    self.currentEvent = 1
    return self.currentFloor
end

function HP:nextEvent()
    self.currentEvent = self.currentEvent + 1
    return self.currentEvent
end

-- Currently set to stay out as long as there are
-- short rests available and hp is over 50%
function HP:ReturnToCity()
    self.currentFloor = 0
    self.currentEvent = 1 
    self.inCity = true
end

function HP:ReturnDebate()
    local low = 0
    local high = 0
    
    for i,member in ipairs(self.members) do
        local mem_avg_hp = member:getCurrentHP() / member.stats['vitality']
        print (mem_avg_hp)

        if (mem_avg_hp > 0.8) then 
            high = high + 1
        else
            low = low + 1
        end
    end   

    if low >= high then 
        return true
    else
        return false
    end
end

function HP:ReturnToDungeon()
    self.currentFloor = 1
    self.inCity = false
end
-- Determine which member will do the skill check
-- Currently set to highest value, but will update to personality based later
function HP:attemptSkillCheck(stat, remaining_value)

    local highest_skill = 1
    local highest_index = 1
    for i,member in ipairs(self.members) do 
        local mem_stat = member:getStat(stat)
        if (highest_skill < mem_stat) then 
            highest_skill = mem_stat
            highest_index = i
        end
    end
    return highest_skill
end

function HP:getCurrentFloor()
    return self.currentFloor
end

function HP:getCurrentEvent()
    return self.currentEvent
end

function HP:printSummary()
    print (self.name .." Summary: "..
        "\nCurrent Floor | Event : ".. self.currentFloor .." | "..self.currentEvent ..      
        "\nNumber of Members : ".. #self.members

    )
    for index,member in ipairs(self.members) do
        member:printSummary()
    end

end
return HP