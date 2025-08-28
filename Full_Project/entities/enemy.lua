local Agent = require("entities.agent")
local Enemy = setmetatable({}, {__index = Agent})
Enemy.__index = Enemy

function Enemy:new(name)
    local self = setmetatable({}, Enemy)
    self.name = name or "Globin"
    self.stats = Enemy:generateArray()
    self.currentHp = self.stats["vitality"]
    self.alive = true
    return self
end

function Enemy:generateArray()
    local array = {
        ["attack"] = math.random(0,5),
        ["defence"] = math.random(0,5),
        ["vitality"] = math.random(10,50),
        ["speed"] = math.random(0,3)
    }
    return array
end

return Enemy