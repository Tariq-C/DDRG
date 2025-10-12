IC = {}
IC.__index = IC

--
-- Scale    : (int) multiplier
-- x        : (int) horizontal position
-- y        : (int) vertical position
-- Type     : (string) background, hero, ...
-- Template : (string) day_mountain

function IC:new(type, template, x, y, scale)
    ---@class IC
    local self    = setmetatable({}, IC)
    self.type     = type or "placeholder"
    self.template = template or "placeholder"
    self.position = { x = x or 0, y = y or 0 }
    self.scale    = scale or 1

    return self
end

function IC:initialize_image()
    local common_config   = require("database.art.common_config")
    local template_config = require(common_config[self.type].template_path)
    self.image_path       = common_config[self.type].art_path .. template_config[self.template].image
    self.palette          = template_config[self.template].palette
    self.image            = self:replaceShades(self.image_path, self.palette)
end

-- palette-swapping function
function IC:replaceShades(path, palette)
    local sourceColors = {
        { 45,  45,  45 },
        { 85,  85,  85 },
        { 125, 125, 125 },
        { 165, 165, 165 },
        { 215, 215, 215 },
        { 255, 255, 255 }
    }

    local imageData = love.image.newImageData(path, palette)

    local function isColorMatch(r1, g1, b1, src)
        return r1 == src[1] and g1 == src[2] and b1 == src[3]
    end

    imageData:mapPixel(function(x, y, r, g, b, a)
        local R, G, B = math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)

        for i = 1, #sourceColors do
            if isColorMatch(R, G, B, sourceColors[i]) then
                local dst = palette[i]
                return dst[1] / 255, dst[2] / 255, dst[3] / 255, (dst[4] or 255) / 255
            end
        end

        return r, g, b, a
    end)

    return love.graphics.newImage(imageData)
end

-- draw all layers
function IC:draw()
    love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.scale)
end

return IC
