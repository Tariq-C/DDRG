local City = {}
City.__index = City

function City:new(floor_number)
    local self = setmetatable({}, City)
    self.name = "City ".. floor_number
    return self
end

function City:Rest(party)
    party:longRest()
    party:ReturnToDungeon()
end

return City