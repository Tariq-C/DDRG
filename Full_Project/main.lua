local Dungeon = require("dungeon.dungeon")

function Main()
    
    -- Make a dungeon
    local dungeon = Dungeon:new()

    -- Summon a hero
    dungeon:SummonHero()
    dungeon:SummonHero()

    -- Run Game

    local turnCounter = 0

    while dungeon:isHero() and not dungeon:completed() do
        
        dungeon:update()

        if (turnCounter % 50 == 0) then 
            dungeon:printDungeon(turnCounter)
        end
        turnCounter = turnCounter + 1

    end
    
    dungeon:climbSummary()

end 

Main()