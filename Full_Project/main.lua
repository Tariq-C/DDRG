HeroGen = require("generators.heroGenerator")
Enemy   = require("entities.enemy")
Battle  = require('events.battle')



function Main()
    
    -- First we are going to make a hero
    local heroGenerator = HeroGen:new()
    local hero = heroGenerator:SummonHero(1)

    print (hero:printStats())

    local battle_counter = 0
    while (hero:isAlive()) do
        Fight(hero)
        battle_counter = battle_counter + 1
    end

    hero:defeatMessage()
end 

-- return 0 if enemy wins
-- return 1 if hero wins
function Fight(hero)
    local battle = Battle:new()
    battle:resolve(hero)
end

function SpawnEnemy()
    return Enemy:new()
end





Main()