local UIElement = require("utils.generic_love2d.UIElement")
local IC = require("utils.image_constructors.image_constructor")

local Button = setmetatable({}, {__index = UIElement})
Button.__index = Button

function Button:new(type,x,y,scale,onClick)
    local self = setmetatable(UIElement:new(x, y, 32*scale, 32*scale),Button)
    self.ic         = IC:new("button", type, x, y, scale)
    self.ic:initialize_image()
    self.scale = scale
    self.onClick = onClick
    return self
end

function Button:draw()
    self.ic:draw()
end

function Button:mousepressed(x, y, button)

    if button == 1 and x >= self.x and x <= self.x + 32*self.scale
                    and y >= self.y and y <= self.y + 32*self.scale then
        if self.onClick then self.onClick() end
    end
end

return Button