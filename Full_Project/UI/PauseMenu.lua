PM = {}
PM.__index = PM

local Panel     = require('utils.generic_love2d.Panel')
local Button    = require('utils.generic_love2d.Button')

function PM:new(gameWidth, gameHeight, scale)
    local self = setmetatable({}, PM)

    self.visible = false
    
    self.panel_width   = 300 * scale
    self.panel_height  = 200 * scale

    self.panel_position_x = (gameWidth/2)-(self.panel_width/2)
    self.panel_position_y = (gameHeight/2)-(self.panel_height/2)

    self.panel = Panel:new(self.panel_position_x, self.panel_position_y, self.panel_width, self.panel_height)

    -- Add buttons
    local btn1 = Button:new(20*scale, 20*scale, 260*scale, 40*scale, "Resume Game", function()
        self.visible = false
    end)

    local btn2 = Button:new(20*scale, 80*scale, 260*scale, 40*scale, "Exit to Desktop", function()
        love.event.quit()
    end)

    self.panel:addChild(btn1)
    self.panel:addChild(btn2)

    return self
end

function PM:updateVisible(value)
    self.visible = value
end

function PM:draw()
    self.panel:draw()
end

function PM:mousepressed(x, y, button)
    self.panel:mousepressed(x, y, button)
end

return PM