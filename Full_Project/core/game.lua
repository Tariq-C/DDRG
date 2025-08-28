local Hero = require("entities.hero")
local EventGenerator = require("events.event_generator")
local MobBattle = require("scenes.mob_battle")
local Temple = require("scenes.temple")
local BossBattle = require("scenes.boss_battle")

local Game = {}
Game.__index = Game

function Game:load()
    self.hero = Hero:new(400, 300)
    self.generator = EventGenerator:new(5)
    self.eventY = 200
    self.eventSpacing = 150
    self.animationX = 800
    self.currentScene = nil
end

function Game:chooseScene()
    local currentIndex = self.generator.currentIndex - 1
    local totalEvents = #self.generator.events

    if currentIndex == totalEvents then
        return BossBattle:new(self.hero)
    end

    -- randomly select MobBattle or Temple
    local rand = math.random()
    if rand < 0.5 then
        return MobBattle:new(self.hero)
    else
        return Temple:new(self.hero)
    end
end

function Game:update(dt)
    if self.currentScene then
        self.currentScene:update(dt)
        if self.currentScene:isFinished() then
            self.currentScene = nil
            self.animationX = 800
        end
        return
    end

    local current = self.generator:getCurrentEvent()
    if current then
        self.animationX = self.animationX - 200 * dt
        if self.animationX <= self.hero.x then
            current.triggered = true
            self.currentScene = self:chooseScene()
            self.generator:advance()
        end
    end
end

function Game:draw()
    self.hero:draw()

    if self.currentScene then
        self.currentScene:draw()
        return
    end

    local current = self.generator:getCurrentEvent()
    if current then
        current:draw(self.animationX, self.eventY)
    else
        love.graphics.printf("All events completed!", 0, 200, love.graphics.getWidth(), "center")
    end
end

function Game:mousepressed(x, y, button)
    if self.currentScene then
        self.currentScene:mousepressed(x, y, button)
    end
end

return Game
