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
    self.inShortRestBool    = false
    self.shortRestLength    = 0
    self.partyStatus        = 'Summoned'
end


-- For Now we will use democracy to determine if the party will short rest
function HP:willShortRest()
    local passCount = #self.members / 2
    local wantToRestCount = 0
    for i, member in ipairs(self.members) do 
        if (member:wantToShortRest()) then
            wantToRestCount = wantToRestCount + 1
        end
    end

    if (wantToRestCount > passCount) then
        return true
    else
        return false
    end
end

-- Returns whether the party is currently resting
function HP:inShortRest()
    return self.inShortRestBool
end

-- If not resting it will start the rest
-- If resting and no more turns available then end rest and heal
-- If resting then count down
function HP:shortRest(InitialRestLength)
    self:updatePartyStatus("Short Resting")
    if (not self:inShortRest()) then
        self.shortRestLength = InitialRestLength - 1
        self.inShortRestBool = true
        return false
    elseif (self:inShortRest() and self.shortRestLength == 0) then
        self.inShortRestBool = false
        for i,member in ipairs(self.members) do
            if (member:canShortRest()) then
                member:short_rest()
            end
        end
        return true
    elseif (self:inShortRest()) then
        self.shortRestLength = self.shortRestLength - 1
        return false
    end
end

function HP:longRest()
    self:updatePartyStatus("Long Resting")
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
    self:updatePartyStatus("Ascending to "..self.currentFloor + 1)
    self.currentFloor = self.currentFloor + 1
    for i,member in ipairs(self.members) do
        member:recordFloor(self.currentFloor)
    end
    self.currentEvent = 1
    return self.currentFloor
end

function HP:nextEvent()
    self:updatePartyStatus("Moving through dungoen floor")
    self.currentEvent = self.currentEvent + 1
    return self.currentEvent
end

-- Currently set to stay out as long as there are
-- short rests available and hp is over 50%
function HP:ReturnToCity()
    self:updatePartyStatus("Returning to City")
    self.currentFloor = 0
    self.currentEvent = 1 
    self.inCity = true
end

function HP:ReturnDebate()
    
    self:updatePartyStatus("Debating Returning to City")
    local low = 0
    local high = 0
    
    for i,member in ipairs(self.members) do
        local mem_avg_hp = member:getCurrentHp() / member:getMaxHp()

        if (mem_avg_hp > 0.5) then 
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
    self:updatePartyStatus("Returning to Dungeon")
    self.currentFloor = 1
    self.inCity = false
end
-- Determine which member will do the skill check
-- Currently set to highest value, but will update to personality based later
function HP:attemptSkillCheck(stat, remaining_value)
    self:updatePartyStatus("Attempting Skill Check")
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

function HP:updatePartyStatus(value)
    self.partyStatus = value
end

function HP:getPartyStatus()
    return self.partyStatus
end

function HP:battleUpdate()
    self.partyStatus = "Currently in Battle"
end


-- Returns the table containing all the heros
function HP:getParty()
    return self.members
end

-- Returns the number of members in the party
function HP:getPartySize()
    return #self.members
end


-- Returns the member if removed, returns nothing if failed
function HP:removeMember(index)
    if (self.members[index]) then
        return table.remove(self.members,index)
    end
    return nil
end


-- Returns True if the member was added, returns false if not
function HP:addMember(member)
    table.insert(self.members, member)
end

return HP