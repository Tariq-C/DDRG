local config = {

    background = {
        order = {
            "sky",
            "back",
            "mid",
            "fore",
            "game",
            "grid"
        },
        y_offset = {
            sky     = 0,
            back    = 0,
            mid     = 0,
            fore    = 0,
            game    = 160,
            grid    = 160
        },
        art_path = "art/background/",
        template_path = "database/art/template/background"
    },
    hero = {
        order = {
            "off_hand",
            "face",
            "hair",
            "clothing",
            "main_hand"
        },
        art_path = "art/hero/",
        template_path = "database/art/template/hero"
    },
    button = {
        art_path = "art/gui/button/",
        template_path = "database/art/template/button"
    },
    panel = {
        art_path = "art/gui/panel/",
        template_path = "database/art/template/panel"
    }
}

return config