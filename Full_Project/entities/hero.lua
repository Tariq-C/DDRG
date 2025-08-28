local Agent = require("entities.agent")
local Hero = setmetatable({}, {__index = Agent})
Hero.__index = Hero

function Hero:new(id)
    local self = setmetatable({}, Hero)
    self.name = "John"
    self.level = 0
    self.xp    = 0
    self.stats = Hero:generateArray()
    self.currentHp = self.stats["vitality"]
    self.alive = true
    self.monsterCount = 0
    self.id = id
    return self
end

function Hero:generateArray()
    local array = {
        ["attack"] = math.random(5,15),
        ["defence"] = math.random(0,5),
        ["vitality"] = math.random(50,150),
        ["speed"] = math.random(0,5)
    }
    return array
end

function Hero:monsterDefeated()
    self.monsterCount = self.monsterCount + 1
end

function Hero:defeatMessage()
    print ("Hero " .. self.name .. " defeated")
    print ("Final Hero Level : "..self.level)
    print ("Monsters Defeated : ".. self.monsterCount)
end

-- TODO : Once scalaing enemies and dungeons complete, add this
function Hero:levelUp()
    self.level = self.level + 1
    return 0
end


return Hero