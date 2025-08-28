local Agent = {}
Agent.__index = Agent

function Agent:new(name)
    local self = setmetatable({}, Agent)
    self.name = name or "Name"
    self.stats = Agent:generateArray()
    self.currentHp = self.stats["vitality"]
    self.alive = true
    return self
end

function Agent:printStats()
    print ("Agent " .. self.name .. "'s stats")
    for key, value in pairs(self.stats) do
        print (key .. " = " .. value)
    end
end

function Agent:printStatus()
    print (self.name .. "is at " .. self.currentHp)
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

function Agent:attack()
    local dmg = self.stats["attack"]
    return dmg
end

function Agent:recieveDmg(dmg)
    local dmg = dmg or 0
    local totaldmg = dmg - self.stats["defence"]
    if totaldmg < 1 then
        totaldmg = 1
    end
    self.currentHp = self.currentHp - totaldmg
    if self.currentHp < 0 then 
        self.alive = false
    end
end

function Agent:isAlive()
    return self.alive
end

function Agent:isTurn(turnCounter)
    local true_speed = 10-self.stats["speed"]
    if (turnCounter % true_speed == 0) then
        return true
    else
        return false
    end
end


return Agent