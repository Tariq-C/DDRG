local Event = require('events.event')
local SPR = setmetatable({}, {__index = Event})
SPR.__index = SPR

local EP = require('groups.enemy_party')

function SPR:new()
    local self = setmetatable({}, SPR)
    self.stats = {}
    self.status = "Active"
    self.turn_counter = 0
    self:init()
    return self
end

function SPR:init()
    self.type = 'SPR'
    self.event_exp = 10
    self.stats["hero_dmg"] = 0
    self.stats["enemy_dmg"] = 0
    -- TODO Make into an array and assign hero party an index to know who they are fighting
    self.mob_count  = 0             -- Number of mob parties on the floor
    self.enemy_party = EP:new()     -- Change to be an array
    self.partyStatus = "Battling Enemy Party"
end

-- SPR Occurs, damage is permanent
-- Ends when either the enemy dies or the hero dies
function SPR:resolve(party)

    self.turn_counter = self.turn_counter + 1
    -- SPR Updates
    party:SPRUpdate()
    self.enemy_party:SPRUpdate()

    
    -- Check if Hero Party is on this turn
    local hero = party:isTurn(self.turn_counter)
    -- Check if Enemy Party is on this turn
    local enemy = self.enemy_party:isTurn(self.turn_counter)
    
    if hero then
        local SPR_pkg = hero:attack(self.enemy_party)
        local target    = SPR_pkg[2]
        local dmg       = SPR_pkg[1]
        if not self.enemy_party:attackMember(target, dmg) then 
            local enemy = self.enemy_party:getMember(target)
            hero:obtainExp(enemy:dropExp())
        end
        -- If Hero Party Wins
        if not self.enemy_party:isAlive() then 
            party:DistributeExperience(self.event_exp)
            self.status = "Resolved"
            return true
        end
    end

    
    
    if enemy then
        local SPR_pkg = enemy:attack(party)
        local target    = SPR_pkg[2]
        local dmg       = SPR_pkg[1]
        party:attackMember(target,dmg)

        -- If Hero Party Dies
        if not party:isAlive() then 
            self.status = "Resolved"
            return false
        end
    end
    
    return false
end

function SPR:reset()
    self.enemy_party = EP:new()
end

return SPR