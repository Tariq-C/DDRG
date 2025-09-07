local Floor = {}
Floor.__index = Floor

local battle = require('events.battle')
local skill_check = require('events.skill_check')
local safe_space = require('events.safe_space')

function Floor:new(floor_num)
    local self = setmetatable({}, Floor)
    self.stats = {}
    self.stats['attempts'] = 0
    self.events = {}
    self.floor = floor_num
    self.status = "Undiscovered"
    self:init(floor_num)
    return self
end

function Floor:init(floor_num)
    local rand = math.random(1,3)
    local section_floor_num = floor_num % 10
    if section_floor_num % 3 == 0 then 
        rand = 1
    end

    local floor_template = require("database.floor_template")
    
    print ('Constructing Floor '.. floor_num .. " Version "..rand )

    for i,event in ipairs(floor_template[floor_num][rand]) do 
        local push = {}
        if event == 'b' then 
            push = battle:new()
        elseif event == 'sc' then 
            push = skill_check:new()
        elseif event == 'ss' then 
            push = safe_space:new()
        elseif event == 'bb' then 
            push = battle:new()
        end
        table.insert(self.events, push)
    end
end

-- Go through each of the events in the floor
-- At the end of each floor allow the party to return to the city

function Floor:explore(party)

    self.stats['attempts'] = self.stats['attempts'] + 1
    party:printSummary()
    local event_index = party:getCurrentEvent()
    -- If over the last event 
    if (event_index > #self.events) then
        party:ascend()
        self.status = "Completed"
        return true
    end

    if (not (self.events[event_index].type == 'safe_space')) then
        if  party:ReturnDebate() then 
            party:ReturnToCity()
            return false
        end
    end
    local event = self.events[event_index]
    local pass =  event:resolve(party)
    if (pass) then 
        party:nextEvent()
        return true
    end
    return false
end

function Floor:getStatus()
    return self.status
end

return Floor