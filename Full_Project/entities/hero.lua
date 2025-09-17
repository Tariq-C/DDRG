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

function Hero:new(id , name)
    local self = setmetatable({}, Hero)
    self.name = name or "John"
    self.level = 1
    self.currentExp    = 0
    self.nextLevelExp = 100 * (self.level ^ 2.2)
    self.highestFloor = 0
    self.stats = Hero:generateArray()
    self.currentHp = self.stats["vitality"]
    self.currentStamina = self.stats["stamina"]
    self.remainingShortRest = self.stats['shortRestCount']
    self.alive = true
    self.id = id
    return self
end

function Hero:recordFloor(floor_number)
    if (self.highestFloor < floor_number) then
        self.highestFloor = floor_number
    end
end

function Hero:generateArray()
    local array = {
        ["attack"] = math.random(5,10),
        ["defence"] = math.random(0,5),
        ["vitality"] = math.random(50,100),
        ["speed"] = math.random(0,5),
        ["stamina"] = math.random(10,25),
        ['shortRestCount'] = math.random(1,4)
    }
    return array
end

function Hero:defeatMessage()
    print ("Hero " .. self.name .. " defeated")
    print ("Final Hero Level : "..self.level)
    print ("Monsters Defeated : ".. self.monsterCount)
end

function Hero:checkStamina(stamina_cost)
    if stamina_cost < self.currentStamina then
        return true
    end
    return false
end

function Hero:attemptSkillCheck(skill, value)
    local remainder = value - self.stats[skill]
    if (remainder > 0) then
        return remainder
    else 
        return 0
    end
end

function Hero:wantToShortRest()
    if self:canShortRest() or self.stats['vitality'] * 2 / 3 > self.currentHp then
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
    self.currentStamina = self.currentStamina + math.ceil(self.stats['stamina'] / 10)
    if (self.currentStamina > self.stats['stamina']) then 
        self.currentStamina = self.stats['stamina']
    end
    self.currentHp      = self.currentHp + math.ceil(self.stats['vitality'] / 10)
    if (self.currentHp > self.stats['stamina']) then 
        self.currentHp = self.stats['vitality']
    end
    return true
end

function Hero:longRest()
    self.currentHp = self.stats['vitality']
    self.currentStamina = self.stats['stamina']
    self.remainingShortRest = self.stats['shortRestCount']
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
    
    self.stats['attack'] = self.stats['attack']       + math.random(0,2)
    self.stats["defence"] = self.stats["defence"]     + math.random(0,2)
    self.stats["vitality"] = self.stats["vitality"]   + math.random(5,15)
    self.stats["speed"] = self.stats["speed"]         + math.random(0,5)

end

function Hero:printSummary()
    print(self.name .. " summary :"..
    "\t Level : ".. self.level..
    "\t Current HP : ".. self.currentHp..
    "\t Total HP : ".. self.stats['vitality']
    )
end


return Hero