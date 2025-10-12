local printer = require('utils.table_printer')
local RPM     = require('UI.RootPanelManager')

local gameWidth, gameHeight = 1920,1080
local scale = 3
local rootManager = RPM:new(gameWidth,gameHeight,scale)

function love.load()

    -- load the font at the size you want
    myPixelFont = love.graphics.newFont("art/font/PublicPixel.ttf", 16)
    love.graphics.setFont(myPixelFont)

    gameCanvas = love.graphics.newCanvas(gameWidth, gameHeight)

    -- Set a borderless window that fills the screen
    love.window.setMode(gameWidth, gameHeight, {
        fullscreen = false,      -- not exclusive fullscreen
        borderless = false,       -- no window borders
    })

    seed = os.time()
    math.randomseed(seed)
    Dungeon = require("dungeon.dungeon")
    dungeon = Dungeon:new()
    turnCounter = 0
    paused = true
    layout = dungeon:getDungeon()
    
    dungeon:SummonHero(5)

end

-- Desired update interval in seconds (e.g., 0.5 = update every 0.5 seconds)
local updateInterval = 0.01
local updateTimer = 0

function love.update(dt)
    updateTimer = updateTimer + dt
    if updateTimer >= updateInterval and not paused then
            updateTimer = updateTimer - updateInterval
            turnCounter = turnCounter + 1
            if (not dungeon:isHero() or dungeon:completed()) then 
                paused = true
            end
            dungeon:update()
    else
        updateTimer = updateTimer - dt
    end
end

function love.draw()
    love.graphics.setColor(1,1,1,1)
    rootManager:draw()
end

function love.mousepressed(x, y, button)
    rootManager:mousepressed(x, y, button)
end