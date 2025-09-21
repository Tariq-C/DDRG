--  This is the dungeon generator, there will 
--
local Floor = require('dungeon.floor')
local City = require("dungeon.city")
local Hero = require("entities.hero")
local Hero_Party = require("groups.hero_party")
local Hero_Manager = require("managers.party_manager")


local Dungeon = {}
Dungeon.__index = Dungeon

function Dungeon:new()
    local self = setmetatable({}, Dungeon)
    self.partyManager    = Hero_Manager:new()
    self.dungeon      = {}
    self.layout       = {}
    self.cities       = {}
    self:init(10)
    self.turnCounter = 0
    self.complete = false
    return self
end

function Dungeon:init(num_floors)
    self.cities[1] = City:new(0)
    for i = 1, num_floors, 1 do
        self.dungeon[i] = Floor:new(i)
        self.layout[i] = self.dungeon[i]:getNumEvents()
    end
end

function Dungeon:SummonHero(hero_count)
    if not hero_count then hero_count = 1 end
    for i = 0,hero_count,1 do
        self.partyManager:summon_hero()
    end
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
    for i,party in ipairs(self.partyManager:get_parties()) do
        local floor = party:getCurrentFloor()
        if (floor == 0) then
            -- print("\n"..party.name .." In City")
            self.cities[1]:Rest(party)
        elseif (floor < 10) then 
            -- print("\n"..party.name.." on Floor "..party:getCurrentFloor().." Event "..party:getCurrentEvent())
            self.dungeon[floor]:explore(party)
        else
            self.complete = true
        end
    end
end

function Dungeon:climbSummary()
    print ("\n\n\t\t Dungeon Defeated\n\nDungeon Summary : "..
        "\n\tNumber of Floors : ".. #self.dungeon..
        "\n\tTotal Turns : ".. self.turnCounter
    )
    for i,party in ipairs(self.partyManager:get_parties()) do
        print("--")
        party:printSummary()
    end

end

function Dungeon:completed()
    return self.complete
end

function Dungeon:isHero()
    for i,party in ipairs(self.partyManager:get_parties()) do
        if (party:isAlive()) then 
            return true
        end
    end
    return false
end

function Dungeon:getParties()
    return self.partyManager:get_parties()
end

function Dungeon:getDungeon()
    return self.layout
end

return Dungeon


