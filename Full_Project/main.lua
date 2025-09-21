

function love.load()
    seed = os.time()
    math.randomseed(seed)
    Dungeon = require("dungeon.dungeon")
    dungeon = Dungeon:new()
    turnCounter = 0
    paused = false
    layout = dungeon:getDungeon()
    total_events = getTotalEvents(layout)
    math.randomseed(os.time())

        -- Progress bar dimensions
    barX, barY, barW, barH = 50, 100, 700, 20
    dungeon:SummonHero(5)

end

-- Desired update interval in seconds (e.g., 0.5 = update every 0.5 seconds)
local updateInterval = 0.01
local updateTimer = 0

function love.update(dt)
    updateTimer = updateTimer + dt
    if updateTimer >= updateInterval then
            updateTimer = updateTimer - updateInterval

        if (not paused) then 
            turnCounter = turnCounter + 1
            if (not dungeon:isHero() or dungeon:completed()) then 
                paused = true
            end
            dungeon:update()
        end
    end
end

function love.draw()
    -- Background bar
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", barX, barY, barW, barH)

    -- Floor divisions
    local cumulativeEvents = 0
    for f, events in ipairs(layout) do
        local startX = barX + (cumulativeEvents / total_events) * barW
        cumulativeEvents = cumulativeEvents + events
        local endX = barX + (cumulativeEvents / total_events) * barW
        love.graphics.setColor(0.6, 0.6, 0.6)
        love.graphics.rectangle("line", startX, barY, endX-startX, barH)
        -- Optional: label floors
        love.graphics.setColor(1,1,1)
        love.graphics.print("F "..f, startX+5, barY - 20)
    end


        -- Draw heroes as colored rectangles on the bar 
        -- Text summary of hero progress below the bar
    local textY = barY + barH + 30
    local colour = {{0,0,1},{0,1,0},{1,1,0},{1,0,0},{1,1,1},{0,1,1}}
    for i,party in ipairs(dungeon:getParties()) do    -- Draw heroes on the bar
        local hero = party:getMember(1)
        local hero_f = party:getCurrentFloor()
        if (hero_f < 1) then hero_f = 1 end
        local hero_e = party:getCurrentEvent()
        local progress = getTotalEvents(layout,hero_f,hero_e) / total_events
        local heroX = barX + progress * barW
        local heroY = barY
        local heroW, heroH = 10, barH  -- width and height of marker

        -- Draw hero marker
        love.graphics.setColor(colour[i])
        love.graphics.rectangle("fill", heroX - heroW/2, heroY, heroW, heroH)

        -- Draw hero name above marker
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(hero.name, heroX - 15, heroY + 20)

        local progressPercent = math.floor(progress * 100)
        local summary = string.format("Floor %d Event %d - Progress: %d%% ||| Hp: %s / %s",
            hero_f, hero_e, progressPercent, hero:getCurrentHp(), hero:getMaxHp())
        local prefix = string.format("Level %s - %s - Status %s", hero.level, hero.name, party:getPartyStatus())

        love.graphics.setColor(colour[i])
        love.graphics.print(prefix, barX, textY - 15 + (i-1) * 40)
        love.graphics.setColor(1,1,1)
        love.graphics.print(summary, barX, textY + (i-1)*40)
    end

    -- Title
    love.graphics.setColor(1,1,1)
    love.graphics.print("Dungeon Progress | Turn ".. turnCounter, barX, barY - 50)
end

function getTotalEvents(layout, h_floor, h_event)
    local total = 0

    for floor,events in ipairs(layout) do
        if (h_floor == floor) then
            total = total + h_event
            return total
        end
        total = total + events
    end
    
    return total
end