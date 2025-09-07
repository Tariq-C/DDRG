local BF = require("dungeon.boss_floor")
local city = require("dungeon.city")
local floor = require("dungeon.floor")


local Biome = {}
Biome.__index = Biome

function Biome:new(section_number)
    local self = setmetatable({}, Biome)
    self.section_number = section_number
    self.stats = {}
    self.standardFloors = {}
    self.city = {}
    self.bossFloor = {}

    return self
end

function Biome:init()
    self.bossFloor = BF:new(self.section_number)
end

function Biome:unlockFloor()

end

return Biome