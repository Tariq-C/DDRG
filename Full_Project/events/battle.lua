local Battle = {}
Battle.__index = Battle

Enemy = require("entities.enemy")

function Battle:new(enemy)
    local self = setmetatable({}, Battle)
    self.stats = {}
    self.stats["hero_dmg"] = 0
    self.stats["enemy_dmg"] = 0
    self.status = "Active"
    self.enemy = enemy or Enemy:new()
    return self
end

-- Battle Occurs, damage is permanent
-- Ends when either the enemy dies or the hero dies
function Battle:resolve(hero)
    local turnCounter = 0;
    while (hero:isAlive() or self.enemy:isAlive()) do
        if hero:isTurn(turnCounter) then
            local dmg = hero:attack()
            self.stats["hero_dmg"] = dmg + self.stats["hero_dmg"]
            self.enemy:recieveDmg(dmg)
        end
        if not self.enemy:isAlive() then 
            hero:monsterDefeated()
            self.status = "Resolved"
            self.stats["turnCounter"] = turnCounter
            return true
        elseif (self.enemy:isTurn(turnCounter)) then
            local dmg = self.enemy:attack()
            self.stats["enemy_dmg"] = dmg + self.stats["enemy_dmg"]
            hero:recieveDmg(dmg)
        end
        turnCounter = turnCounter + 1
    end 
    self.status = "Resolved"
    self.stats["turnCounter"] = turnCounter
    return false
end

function Battle:getStats()
    return self.stats
end


return Battle