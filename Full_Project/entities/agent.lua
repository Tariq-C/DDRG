local Agent = {}
Agent.__index = Agent

Party = require("groups.party")

function Agent:new(name)
    local self = setmetatable({}, Agent)
    self.name = name or "Name"
    self.stats = {}
    self.currentHp = 0
    self.alive = true
    self.id = 0
    return self
end

function Agent:printStats()
    print ("Agent " .. self.name .. "'s stats")
    for key, value in pairs(self.stats) do
        print (key .. " = " .. value)
    end
end

function Agent:determineAction()
    return "attack"
end

-- Currently Targets the lowest HP enemy
function Agent:attack(party)
    local target = party.lowest_HP_index
    local dmg = self.stats.base["strength"]
    return {dmg,target}
end

function Agent:recieveDmg(dmg)
    local dmg = dmg or 0
    local totaldmg = dmg
    if totaldmg < 1 then
        totaldmg = 1
    end
    self.currentHp = self.currentHp - totaldmg
    if self.currentHp <= 0 then 
        self.alive = false
    end
end

function Agent:isAlive()
    return self.alive
end

function Agent:isTurn(turnCounter)
    local true_speed = 100-self.stats.base["agility"]
    if (turnCounter % true_speed == 0) then
        return true
    else
        return false
    end
end

function Agent:getStat(stat)
    return self.stats.base[stat]
end

function Agent:getCurrentHp()
    return self.currentHp
end

return Agent