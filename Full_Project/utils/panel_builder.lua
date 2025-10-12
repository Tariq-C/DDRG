PanelBuilder = {}
PanelBuilder.__index = PanelBuilder

function PanelBuilder:new()
    local self = setmetatable({}, PanelBuilder)
    self.base_path      = "art/Panels/"
    self.panel_paths = {
        bun     =   self.base_path..    "Horizontal.png",
        side    =   self.base_path..    "Side.png"
    }
    return self
end

-- palette-swapping function
function PanelBuilder:replaceShades(imagePath, targetColors)
    local sourceColors = {
        {45, 45, 45},
        {85, 85, 85},
        {125, 125, 125}
    }

    local imageData = love.image.newImageData(imagePath)

    local function isColorMatch(r1, g1, b1, src)
        return r1 == src[1] and g1 == src[2] and b1 == src[3]
    end

    imageData:mapPixel(function(x, y, r, g, b, a)
        local R, G, B = math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)

        for i = 1, #sourceColors do
            if isColorMatch(R, G, B, sourceColors[i]) then
                local dst = targetColors[i]
                return dst[1]/255, dst[2]/255, dst[3]/255, (dst[4] or 255)/255
            end
        end

        return r, g, b, a
    end)

    return love.graphics.newImage(imageData)
end

-- generate background from floor object
function PanelBuilder:generate_background(style)
    self.bg_layers = {} -- reset layers

    -- Apply the same style to all panels
    for _,palette in ipairs(style) do
        local path = "art/Backgrounds/Sky/" .. floor.layers.sky
        local img = self:replaceShades(path, floor.palettes.sky)
        table.insert(self.bg_layers, {image = img, scale = 3, yOffset = 0})
    end

end

-- draw all layers
function PanelBuilder:draw()
    for _, layer in ipairs(self.bg_layers) do
        if layer.image then
            love.graphics.draw(layer.image, 0, layer.yOffset, 0, layer.scale, layer.scale)
        end
    end
    for _, layer in ipairs(self.gm_layers) do
        if layer.image then
            love.graphics.draw(layer.image, 0, layer.yOffset, 0, layer.scale, layer.scale)
        end
    end
end

return PanelBuilder