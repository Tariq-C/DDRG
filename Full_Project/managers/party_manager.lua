local Party_Manager = {}
Party_Manager.__index = Party_Manager

HeroSummoner = require("generators.hero_summoner")
HeroParty    = require("groups.hero_party")


function Party_Manager:new()
    self = setmetatable({}, Party_Manager)
    self.parties = {}
    self.empty_party = {}
    self.heroSummoner = HeroSummoner:new()

    return self
end

function Party_Manager:get_num_parties()
    return #self.parties
end

function Party_Manager:get_parties()
    return self.parties
end

function Party_Manager:add_party(party)
    if (party) then 
        table.insert(self.parties, party)
        return true
    end
    return false
end

function Party_Manager:remove_party(index)
    if (self.parties[index]) then
        table.remove(self.parties, index)
        return true
    end
    return false
end

function Party_Manager:summon_hero()
    local new_party = HeroParty:new(self.heroSummoner:summonHero())
    table.insert(self.parties, new_party)
end

function Party_Manager:split_party(index)
    local splitting_party = self.parties[index]:get_party()
    local num_members     = splitting_party:getPartySize()

    for i=num_members,1,-1 do
        self:add_party(HeroParty:new(splitting_party:removeMember(i)))
    end
end


-- Merges two parties, party2 into party1. Only works if there is less than four members in party 1 and there is exactly 1 member in party 2
-- TODO: Separate the condition of a party to be its own determination as party size in the future might change depending on the city floor

function Party_Manager:merge_party(index1,  index2)
    local party1 = self.parties[index1]
    local party2 = self.parties[index2]

    if (party1:getPartySize() >= 4 or not party2:getPartySize() == 1) then
        return false
    end

    local member = party2:removeMember(0)
    party1:addMember(member)
    return true
end


return Party_Manager