UIElement = {}
UIElement.__index = UIElement

function UIElement:new(x, y, w, h)
    local obj = {
        x = x or 0,
        y = y or 0,
        w = w or 0,
        h = h or 0,
        visible = true,
        active = true,
        children = {}
    }
    return setmetatable(obj, self)
end

function UIElement:addChild(child)
    table.insert(self.children, child)
end

function UIElement:update(dt)
    for _, child in ipairs(self.children) do
        if child.update then child:update(dt) end
    end
end

function UIElement:draw()
    for _, child in ipairs(self.children) do
        if child.visible and child.draw then
            love.graphics.push()
            love.graphics.translate(self.x, self.y)
            child:draw()
            love.graphics.pop()
        end
    end
end

function UIElement:mousepressed(x, y, button)
    for _, child in ipairs(self.children) do
        if child.mousepressed and child.visible then
            local relX, relY = x - self.x, y - self.y
            child:mousepressed(relX, relY, button)
        end
    end
end

function UIElement:containsPoint(px, py)
    return px >= self.x and px <= self.x + self.w and
           py >= self.y and py <= self.y + self.h
end

function UIElement:show() self.visible = true end
function UIElement:hide() self.visible = false end

return UIElement