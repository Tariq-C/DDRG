local Palettes = require('database.art.palettes')

local Template = {
    background = {
        day_mountain = {
            layers = {
                sky = "Sky2.png",
                back = "Mountains.png",
                mid = "Forest.png",
                fore = "Plain.png",
                game = "Beach.png",
                grid = "Raid.png"
            },
            palettes = {
                sky = Palettes.day.sky,
                back = Palettes.day.mountain,
                mid = Palettes.day.forest,
                fore = Palettes.day.plain,
                game = Palettes.day.beach,
                grid = Palettes.day.grid
            }
        }
    },
}

return Template
