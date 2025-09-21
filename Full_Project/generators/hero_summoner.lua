local HS = {}
HS.__index = HS


local Hero = require("entities.hero")


function HS:new()
    local self = setmetatable({}, HS)
    self.hero_prefabs = require("database.hero_prefabs")
    self.hero_template = require("database.hero_template")
    self.potential_table = require("database.rarity_to_stat")
    self.summonOrder = {}
    self:generate_summon_order()
    self.summonIndex = math.random(1,#self.summonOrder)
    return self
end


-- Use a seed to generate the order in which the heroes will appear in the dungeon
function HS:generate_summon_order ()
    -- Populate the list with the numbers
    for i=0,#self.hero_prefabs,1 do 
        table.insert(self.summonOrder, i)
    end

    -- Shuffle the deck using a Fisher-Yates shuffle
    for i = #self.summonOrder,2,-1 do
        local j = math.random(i)
        self.summonOrder[i], self.summonOrder[j] = self.summonOrder[j], self.summonOrder[i]
    end
end

-- summon a hero and and update the index
function HS:summonHero()
    
    local hero = Hero:new(self.hero_prefabs[self.summonIndex])
    hero:setInitialStats(self:generateBaseArray())
    self.summonIndex = self.summonIndex + 1

    if (self.summonIndex > #self.summonOrder) then 
        self.summonIndex = 1
    end

    return hero

end

-- Using the template in database generate a stat array for the hero
function HS:generateBaseArray()
    
    local gen_array = {}

    for category,attributes in pairs(self.hero_template) do
        if type(attributes) == "table" and self.hero_template.scale[category] then 
            local range     = self.hero_template.scale[category]
            local min_val   = range[1]
            local max_val   = range[2]
            local scale     = max_val - min_val

            gen_array[category] = {}

            for _ , stat in ipairs(attributes) do
                local value = 0
                local random = min_val + math.random() * (max_val - min_val)
                if category == 'potential' then 
                    for index,rarity in ipairs(self.potential_table) do
                        if random < rarity.rarity then
                            value = rarity.potential
                            break
                        end
                    end
                else
                    value = math.floor(random)
                end    
                gen_array[category][stat] = value
            end
        end
    end
    return gen_array
end



return HS