UIElements = require("utils.generic_love2d.UIElement")

Button = setmetatable({}, {__index = UIElement})
Button.__index = Button

function Button:new(x, y, w, h, text, onClick)
    local obj = UIElement.new(self, x, y, w, h)
    obj.text = text or "Button"
    obj.onClick = onClick
    return obj
end

function Button:draw()
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 6, 6)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(self.text, self.x, self.y + 10, self.w, "center")
end

function Button:mousepressed(x, y, button)
    if button == 1 and x >= self.x and x <= self.x + self.w
                    and y >= self.y and y <= self.y + self.h then
        if self.onClick then self.onClick() end
    end
end

return Button