Hero = require("entities.hero")

local HeroGen = {}
HeroGen.__index = HeroGen


function HeroGen:new()
    local self = setmetatable({}, HeroGen)
    self.stats = {}
    self.active_heros = {}
    self.inactive_heros = {}
    return self
end

-- Todo increase stats based on hero generator
function HeroGen:printStats()
    print ("Hero Generator Statistics")
    print ("Number of Heros Summoned : ".. self.stats['NumSummoned'])
end

function HeroGen:SummonHero(id)
    local hero = Hero:new(id)
    self.active_heros[id] = hero
    return self.active_heros[id]
end

return HeroGen