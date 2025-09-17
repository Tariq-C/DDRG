local HS = {}
HS.__index = HS


local Heroes = require("entities.hero")


function HS:new(seed)
    local self = setmetatable({}, HS)
    self.seed = seed or 1234567890
    self.hero_template = require("database.hero_template")
    
    return self
end

function HS:summonHero(hero_id)

    local hero = Hero:new(id,name)
    
    
    return Hero

end

function HS:generateBaseArray()
    
end



return HS