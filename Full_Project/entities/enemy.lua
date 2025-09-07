local Agent = require("entities.agent")
local Enemy = setmetatable({}, {__index = Agent})
Enemy.__index = Enemy

function Enemy:new(name)
    local self = setmetatable({}, Enemy)
    self.name = name or "Globin"
    self.stats = Enemy:generateArray()
    self.currentHp = self.stats["vitality"]
    self.alive = true
    self.exp    = 1
    return self
end

function Enemy:generateArray()
    local array = {
        ["attack"] = math.random(0,5),
        ["defence"] = math.random(0,1),
        ["vitality"] = math.random(10,20),
        ["speed"] = math.random(0,3)
    }
    return array
end

function Enemy:dropExp()
    return self.exp
end

return Enemy