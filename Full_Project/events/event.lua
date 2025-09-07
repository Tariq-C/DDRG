local Event = {}
Event.__index = Event

function Event:new()
    local self = setmetatable({}, Event)
    self.type = 'template'
    self.stats = {}
    self.status = "Active"
    return self
end

function Event:getStats()
    return self.stats
end

function Event:getStatus()
    return self.status
end

function Event:updateStatus(value)
    self.status = value
    return true
end


return Event