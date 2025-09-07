local Party = {}
Party.__index = Party

function Party:battleUpdate()
    local lowHP     = 1000000
    local lowIndex  = 1
    for i,member in ipairs(self.members) do
        if(member:isAlive()) then 
            local hp = member:getCurrentHP()
            if (hp < lowHP and hp > 0) then 
                lowHP = hp
                lowIndex = i
            end
        end
    end
    self.lowest_HP_index = lowIndex
end

function Party:addMember(member)
    table.insert(self.members, member)
end

function Party:getMember(index)
    return self.members[index]
end

function Party:removeMember(member_index)
    table.remove(self.members, member_index)
end

function Party:isTurn(turnCounter)
    for i,member in ipairs(self.members) do
        if member:isTurn(turnCounter) and member:isAlive() then 
            return member
        end
    end
    return false
end

function Party:isAlive()

    for i,member in ipairs(self.members) do
        local temp = member:isAlive()
        if (temp) then 
            return true
        end
    end
    return false
end

function Party:getParty()
    return self.members
end

-- Attacks a member at index, with dmg and returns whether the member is alive
function Party:attackMember(index, dmg)
    local hero = self.members[index]
    hero:recieveDmg(dmg)
    local result = hero:isAlive()
    return result
end



return Party