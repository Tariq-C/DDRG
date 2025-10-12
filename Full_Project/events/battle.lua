local Event = require('events.event')
local Battle = setmetatable({}, {__index = Event})
Battle.__index = Battle

local EP = require('groups.enemy_party')

function Battle:new()
    local self = setmetatable({}, Battle)
    self.stats = {}
    self.status = "Active"
    self.turn_counter = 0
    self.active_enemies_parties = {}
    self.hero_party_index = {}
    self:init()
    return self
end

function Battle:init()
    self.type = 'battle'
    self.event_exp = 10
    self.stats["hero_dmg"] = 0
    self.stats["enemy_dmg"] = 0
    self.num_enemy_parties = 25
    self.next_free_enemy = 1
end

-- Battle Occurs, damage is permanent
-- Ends when either the enemy dies or the hero dies
function Battle:resolve(party)
    
    local enemy_party = {}
    -- If Hero has an assigned enemy
    if (self.hero_party_index[party]) then
        enemy_party = self.hero_party_index[party]
    
    -- If Hero does have an enemy assigned and there is room to spawn one
    elseif (self.num_enemy_parties > 0) then 
        self.hero_party_index[party] = EP:new()
        self.num_enemy_parties = self.num_enemy_parties - 1
        if (self.num_enemy_parties < 1) then self.status = "Resolved" end
        enemy_party = self.hero_party_index[party]
    -- No Enemies left
    else
        return true
    end

    self.turn_counter = self.turn_counter + 1
    -- Battle Updates
    party:battleUpdate()
    enemy_party:battleUpdate()

    
    -- Check if Hero Party is on this turn
    local hero = party:isTurn(self.turn_counter)
    -- Check if Enemy Party is on this turn
    local enemy = enemy_party:isTurn(self.turn_counter)
    
    if hero then
        local battle_pkg = hero:attack(enemy_party)
        local target    = battle_pkg[2]
        local dmg       = battle_pkg[1]
        if not enemy_party:attackMember(target, dmg) then 
            local enemy = enemy_party:getMember(target)
            hero:obtainExp(enemy:dropExp())
        end
        -- If Hero Party Wins
        if not enemy_party:isAlive() then 
            party:DistributeExperience(self.event_exp)
            self.hero_party_index[party] = nil
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
            self.hero_party_index[party] = nil
            self.num_enemy_parties = self.num_enemy_parties + 1
            return false
        end
    end
    
    return false
end

function Battle:reset()
    self:init()
end

return Battle