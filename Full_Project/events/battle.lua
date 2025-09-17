local Event = require('events.event')
local Battle = setmetatable({}, {__index = Event})
Battle.__index = Battle

local EP = require('groups.enemy_party')

function Battle:new()
    local self = setmetatable({}, Battle)
    self.stats = {}
    self.status = "Active"
    self.turn_counter = 0
    self:init()
    return self
end

function Battle:init()
    self.type = 'battle'
    self.event_exp = 10
    self.stats["hero_dmg"] = 0
    self.stats["enemy_dmg"] = 0
    -- TODO Make into an array and assign hero party an index to know who they are fighting
    self.mob_count  = 0             -- Number of mob parties on the floor
    self.enemy_party = EP:new()     -- Change to be an array
    self.partyStatus = "Battling Enemy Party"
end

-- Battle Occurs, damage is permanent
-- Ends when either the enemy dies or the hero dies
function Battle:resolve(party)

    self.turn_counter = self.turn_counter + 1
    -- Battle Updates
    party:battleUpdate()
    self.enemy_party:battleUpdate()

    
    -- Check if Hero Party is on this turn
    local hero = party:isTurn(self.turn_counter)
    -- Check if Enemy Party is on this turn
    local enemy = self.enemy_party:isTurn(self.turn_counter)
    
    if hero then
        local battle_pkg = hero:attack(self.enemy_party)
        local target    = battle_pkg[2]
        local dmg       = battle_pkg[1]
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
        local battle_pkg = enemy:attack(party)
        local target    = battle_pkg[2]
        local dmg       = battle_pkg[1]
        party:attackMember(target,dmg)

        -- If Hero Party Dies
        if not party:isAlive() then 
            self.status = "Resolved"
            return false
        end
    end
    
    return false
end

function Battle:reset()
    self.enemy_party = EP:new()
end

return Battle