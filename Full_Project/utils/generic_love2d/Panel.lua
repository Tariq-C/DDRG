UIElement = require("utils.generic_love2d.UIElement")

Panel = setmetatable({}, {__index = UIElement})
Panel.__index = Panel


function Panel:new(x, y, w, h)
    local self = UIElement.new(self, x, y, w, h)
    self.bg_colour      = {0.1, 0.1, 0.1, 0.2}  -- default semi-transparent gray
    self.border_colour   = {1, 1, 1, 0.2}
    self.corner_radius   = 10
    return self
end

function Panel:draw()
    if not self.visible then return end
    -- Draw background
    love.graphics.setColor(self.bg_colour)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, self.corner_radius, self.corner_radius)

    -- Draw border
    love.graphics.setColor(self.border_colour)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h, self.corner_radius, self.corner_radius)

    -- Draw children (relative to panel)
    UIElement.draw(self)
end

function Panel:setBackgroundColour(r,g,b,a)
    self.bg_colour = {r,g,b,a}
end

function Panel:setBoarderColour(r,g,b,a)
    self.boarder_colour = {r,g,b,a}
end

return Panel