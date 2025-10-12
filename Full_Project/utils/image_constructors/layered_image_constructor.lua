local IC = require('utils.image_constructors.image_constructor')
---@class LIC: IC
LIC = setmetatable({}, { __index = IC })
LIC.__index = LIC

---@param type string
---@param template string
---@param x number
---@param y number
---@param scale number
---@return LIC
function LIC:new(type, template, x, y, scale)
    ---@type LIC
    local self       = setmetatable(IC:new(type, template, x, y, scale), LIC)
    self.layers      = {} -- Background Layers
    return self
end

function LIC:initialize_image()
    local common_config   = require("database.art.common_config")
    local template_config = require(common_config[self.type].template_path)
    self.layer_order      = common_config[self.type].order
    self.base_path        = common_config[self.type].art_path
    self.layer_paths      = template_config[self.template].layers
    self.layer_palettes   = template_config[self.template].palettes
    self.y_offsets        = common_config[self.type].y_offset
    self:generateImage()
end

-- generate background from floor object
function LIC:generateImage()
    self.layers = {} -- reset layers

    for _, layer in ipairs(self.layer_order) do
        if (self.layer_paths[layer]) then
            local path = self.base_path.."/"..layer.."/"..self.layer_paths[layer]
            local palette   = self.layer_palettes[layer]
            local img       = self:replaceShades(path, palette)
            table.insert(self.layers, { image = img, scale = self.scale, yOffset = self.y_offsets[layer]})
        end
    end
end

-- draw all layers
function LIC:draw()
    for _, layer in ipairs(self.layers) do
        if layer.image then
            love.graphics.draw(layer.image, self.position.x, self.position.y + layer.yOffset * layer.scale, 0,
                layer.scale, layer.scale)
        end
    end
end

return LIC
