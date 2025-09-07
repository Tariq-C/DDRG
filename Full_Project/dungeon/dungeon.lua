--  This is the dungeon generator, there will 
--
local Floor = require('dungeon.floor')
local City = require("dungeon.city")
local Hero = require("entities.hero")
local Hero_Party = require("groups.hero_party")


local Dungeon = {}
Dungeon.__index = Dungeon

function Dungeon:new()
    local self = setmetatable({}, Dungeon)
    self.parties      = {}
    self.dungeon      = {}
    self.cities       = {}
    self:init(9)
    self.turnCounter = 0
    self.complete = false
    return self
end

function Dungeon:init(num_floors)
    self.cities[1] = City:new(0)
    for i = 1, num_floors, 1 do
        self.dungeon[i] = Floor:new(i)
    end
end

function Dungeon:SummonHero()
    local hero = Hero:new(0)
    local party = Hero_Party:new(hero)
    hero:printSummary()
    party:printSummary()
    table.insert(self.parties,party)
end

function Dungeon:printDungeon(turnCounter)
    print ("Dungeon Update : \n Turn Count : ".. turnCounter)
    for i,floor in ipairs(self.dungeon) do
        print ("Floor "..floor.floor.." : ".. floor:getStatus())
    end
    print("--")
end

function Dungeon:update()
    self.turnCounter = self.turnCounter + 1
    for i,party in ipairs(self.parties) do
        local floor = party:getCurrentFloor()
        if (floor == 0) then
            self.cities[1]:Rest(party)
        elseif (floor < 10) then 
            self.dungeon[floor]:explore(party)
        else
            self.complete = true
        end
    end
end

function Dungeon:climbSummary()
    print ("Dungeon Summary : "..
        "\n\tNumber of Floors : ".. #self.dungeon..
        "\n\tTotal Turns : ".. self.turnCounter
    )
    for i,party in ipairs(self.parties) do
        print("--")
        party:printSummary()
    end

end

function Dungeon:completed()
    return self.complete
end

function Dungeon:isHero()
    for i,party in ipairs(self.parties) do
        if (party:isAlive()) then 
            return true
        end
    end
    return false
end

return Dungeon


