local Colours = require("database.art.colours.background")

local Palettes = {
    day = {
        sky = {
            Colours.blue_light,
            Colours.blue_iceberg,
            Colours.blue_sky_light,
            Colours.blue_sky,
            Colours.blue_azure,
            Colours.blue_deep_sky
        },
        mountain = {
            Colours.gray_charcoal,
            Colours.gray_dark,
            Colours.gray_iron,
            Colours.gray_dim,
            Colours.gray_ash,
            Colours.gray_mist_light
        },
        forest = {
            Colours.green_dark,
            Colours.green_forest,
            Colours.green_pine,
            Colours.green_lush,
            Colours.green_fern,
            Colours.green_hunter
        },
        plain = {
            Colours.green_hunter,
            Colours.brown_coffee,
            Colours.green_fern,
            Colours.brown_sand,
            Colours.gray_iron,
            Colours.gray_cloud_light
        },
        beach = {
            Colours.brown_sand,
            Colours.yellow_wheat,
            Colours.yellow_lemon,
            Colours.blue_ocean,
            Colours.blue_cerulean,
            Colours.blue_cyan_light  
        },
        grid = {
            Colours.brown_chestnut,
            Colours.brown_coffee,
            Colours.yellow_gold_light,
            Colours.brown_umber,
            Colours.brown_sand,
            Colours.green_leaf
        }
    }
}

return Palettes