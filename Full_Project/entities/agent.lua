local Agent = {}
Agent.__index = Agent

Party = require("groups.party")

function Agent:new(name)
    local self = setmetatable({}, Agent)
    self.name = name or "Name"
    self.stats = Agent:generateArray()
    self.currentHp = self.stats["vitality"]
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

function Agent:printSummary(index)

    if (self.alive) then
        print (self.name .." ["..index.."]".. " is  alive with " .. self.currentHp .. " hp")
    else 
        print (self.name .." ["..index.."]".. " has been slain")
    end
end

function Agent:generateArray()
    local array = {
        ["attack"] = math.random(5,15),
        ["defence"] = math.random(0,5),
        ["vitality"] = math.random(10,50),
        ["speed"] = math.random(0,5)
    }
    return array
end

function Agent:determineAction()
    return "attack"
end

-- Currently Targets the lowest HP enemy
function Agent:attack(party)
    local target = party.lowest_HP_index
    local dmg = self.stats["attack"]
    return {dmg,target}
end

function Agent:recieveDmg(dmg)
    local dmg = dmg or 0
    local totaldmg = dmg - self.stats["defence"]
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
    local true_speed = 100-self.stats["speed"]
    if (turnCounter % true_speed == 0) then
        return true
    else
        return false
    end
end

function Agent:getStat(stat)
    return self.stats[stat]
end

function Agent:getCurrentHP()
    return self.currentHp
end

return Agent