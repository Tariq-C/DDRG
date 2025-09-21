local Agent = require("entities.agent")
local Hero = setmetatable({}, {__index = Agent})
Hero.__index = Hero

-- We are going to define the Hero Stats Below
--
-- Base Stats
-- Strength
-- Agility
-- Constituation
-- Wisdom
-- Charisma

function Hero:new(prefab)
    local name              = prefab["Name"] or "John"
    local self              = setmetatable({}, Hero)
    self.name               = name
    self.stats              = {}
    self.level              = 1
    self.currentExp         = 0
    self.nextLevelExp       = 100 * (self.level ^ 2.2)
    self.highestFloor       = 0
    self.currentHp          = 0
    self.maxHp              = 0
    self.currentStamina     = 0
    self.remainingShortRest = 0
    self.alive              = true
    self.id                 = id
    return self
end

function Hero:recordFloor(floor_number)
    if (self.highestFloor < floor_number) then
        self.highestFloor = floor_number
    end
end

function Hero:checkStamina(stamina_cost)
    if stamina_cost < self.currentStamina then
        return true
    end
    return false
end

function Hero:attemptSkillCheck(skill, value)
    local remainder = value - self.stats.base[skill]
    if (remainder > 0) then
        return remainder
    else 
        return 0
    end
end

function Hero:wantToShortRest()
    if self:canShortRest() or self.maxHp * 2 / 3 > self.currentHp then
        return true
    else
        return false
    end

end

-- TODO: Make short rest decision wilder
function Hero:canShortRest()
    if self.remainingShortRest > 0 then 
        return true
    end
    return false
end

-- TODO: Change Values to reflect expanded stat blocks
function Hero:short_rest()
    self.remainingShortRest = self.remainingShortRest - 1
    self.currentHp      = self.currentHp + math.ceil(self.maxHp / 10)
    if (self.currentHp > self.maxHp) then 
        self.currentHp = self.maxHp
    end
    return true
end

function Hero:longRest()
    self.currentHp = self.maxHp
    self.currentStamina = self.stats.base['vitality']
    self.remainingShortRest = self.stats.base['vitality']
end

function Hero:obtainExp(exp)
    self.currentExp = self.currentExp + exp
    if self.currentExp > self.nextLevelExp then
        self:levelUp()
    end
end

function Hero:levelUp()
    self.level = self.level + 1
    self.nextLevelExp = 100 * (self.level ^ 2.2)
    for stat, value in pairs(self.stats.base) do
        
        local init_stat_ratio   = self.init_stats.base[stat] / 10
        local max_value         = 65536
        local potential_exp     = 1 + 4*self.stats.potential[stat]
        local level_ratio       = self.level / 250

        local new_value = (init_stat_ratio * max_value * (1 - ( 1 - level_ratio ^ potential_exp)))
        self.stats.base[stat] = math.floor(new_value)
    end   
    self.maxHp = math.floor(self.stats.base["vitality"] * 10)

end

function Hero:setInitialStats(stat_array)
    self.stats = stat_array
    self.init_stats = stat_array
    self.maxHp              = self.init_stats.base["vitality"] * 10
    self.currentHp          = self.maxHp
    self.currentStamina     = self.init_stats.base["vitality"]
    self.remainingShortRest = self.init_stats.base['vitality']
end

function Hero:getMaxHp()
   return self.maxHp
end

return Hero