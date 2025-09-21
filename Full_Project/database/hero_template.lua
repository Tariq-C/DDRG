local template = {
    base = {
        "vitality",
        "strength",
        "agility",
        "intelligent",
        "charisma"
    },
    potential = {
        "vitality",
        "strength",
        "agility",
        "intelligent",
        "charisma"
    },
    personality = {
        "openness",
        "conscientiousness",
        "extraversion",
        "agreeableness",
        "neuroticism"
    },
    energy = {
        "magic",
        "spirit",
        "cosmic",
        "aura",
        "divinity"
    },
    scale = {
        base        = {1,10},
        potential   = {0,1024},
        personality = {-1,1},
        energy      = {0,1}
    }
}
return template