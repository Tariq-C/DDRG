UIElement = require("utils.generic_love2d.UIElement")

Panel = setmetatable({}, {__index = UIElement})
Panel.__index = Panel


function Panel:new(img, x, y, scale)
    local self = UIElement.new(self, x, y, w, h)
    self.image_path = "art/gui/panel/".. img ..".png"
    self.image      = love.graphics.newImage(love.image.newImageData(self.image_path))
    self.scale = scale
    return self
end

function Panel:draw()
    if not self.visible then return end 
    love.graphics.draw(self.image, self.x, self.y,0, self.scale)

    -- Draw children (relative to panel)
    UIElement.draw(self)
end

return Panel