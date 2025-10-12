RPM = {}
RPM.__index = RPM

local Panel             = require('utils.generic_love2d.Panel')
local Button            = require('utils.generic_love2d.Button')
local Button_img        = require('utils.generic_love2d.Button_img')
local LIC               = require('utils.image_constructors.layered_image_constructor')
local PauseMenu         = require('UI.PauseMenu')

function RPM:new(gw, gh, scale)
    local self = setmetatable({}, RPM)
    self.gameWidth      = gw
    self.gameHeight     = gh
    self.scale          = scale
    self.floor          = "day_mountain"

    self.lic = LIC:new("background", self.floor, 0,0, 3)
    self.lic:initialize_image()

    self.UIElements = {}
    self.UIElements["pause"] = PauseMenu:new(self.gameWidth, self.gameHeight, self.scale)

    self.UIElements['pause_button'] = Button_img:new(
                                                    "main_menu",
                                                    self.gameWidth - 42 * self.scale,
                                                    10 * self.scale,
                                                    self.scale,
                                                    function()
                                                        self.UIElements["pause"]:updateVisible(true)
                                                    end
                                                )


    return self
end

function RPM:draw()
    self.lic:draw()
    for _,element in pairs(self.UIElements) do
        if element.visible then 
            element:draw()
        end
    end
end

function RPM:mousepressed(x, y, button)
    for _, child in pairs(self.UIElements) do
        child:mousepressed(x, y, button)
    end
end

return RPM