--local smoke_animations = require("__base__/prototypes.entity.smoke-animations")

data:extend{
    {
        type = "damage-type",
        name = "meteor-strike"
    },
    {
        name = "rm-meteor-crater",
        type = "optimized-decorative",
        order = "a[nauvis]-b[decorative]",
        collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
        collision_mask = {layers={water_tile=true}, colliding_with_tiles_only=true},
        render_layer = "decals",
        tile_layer =  255,
        pictures = {
            sheet = {
                filename = "__reds-meteors__/graphics/meteor/meteor-crater.png",
                width = 512,
                height = 512,
                variation_count = 1,
                scale = 0.5,
            }
        }
    },
    {
        type = "simple-entity",
        name = "rm-meteor-entity",
        flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
        icon = "__reds-meteors__/graphics/icons/meteor.png",
        icon_size = 64,
        max_health = 500,
        resistances = {
            {type = "fire", percent = 100},
            {type = "poison", percent = 100},
            {type = "physical", percent = 75}
        },
        collision_box = {{-1, -1}, {1, 1}},
        collison_mask = {"item-layer", "object-layer", "player-layer", "water-tile", "train-layer"},
        selection_box = {{-1, -1}, {1, 1}},
        picture = {
            sheet = {
                filename = "__reds-meteors__/graphics/meteor/meteor-entity.png",
                width = 188,
                height = 127,
                variation_count = 1,
                frames = 1,
                scale = 0.5,
            }
        },
        render_layer = "object",
        count_as_rock_for_filtered_deconstruction = true,
    },
    {
        type = "projectile",
        name = "rm-meteor-projectile",

        flags = { "not-on-map" },

        animation = {
            filename = "__reds-meteors__/graphics/meteor/meteor.png",
            frame_count = 1,
            width = 188,
            height = 127,
            line_length = 1,
            scale = 0.8,
            priority = "extra-high",
        },
        rotatable = false,
        
        acceleration = 0,

        smoke = {
            {
                name = "fire-smoke-without-glow",
                frequency = 0.6,
                position = {0.5, -0.5},
                starting_frame = 2,
                starting_frame_deviation = 3,
                starting_vertical_speed_deviation = 0.20,
                
                deviation = { 0.1, 0.1 },

            }
        },
    
        action = {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    {
                        type = "nested-result",
                        action = {
                            type = "area",
                            radius = 1.5,
                            action_delivery = {
                                type = "instant",
                                target_effects = {
                                    {
                                        type = "damage",
                                        damage = {
                                            type = "meteor-strike",
                                            amount = 100000,
                                        }
                                    }
                                }
                            }
                        }
                    },
                    {
                        type = "nested-result",
                        action = {
                            type = "area",
                            radius = 3,
                            action_delivery = {
                                type = "instant",
                                target_effects = {
                                    {
                                        type = "damage",
                                        damage = {
                                            type = "meteor-strike",
                                            amount = 150,
                                        }
                                    }
                                }
                            }
                        }
                    },
                    {
                        type = "nested-result",
                        action = {
                            type = "area",
                            radius = 5,
                            action_delivery = {
                                type = "instant",
                                target_effects = {
                                    {
                                        type = "damage",
                                        damage = {
                                            type = "meteor-strike",
                                            amount = 100,
                                        }
                                    }
                                }
                            }
                        }
                    },
                    {
                        type = "create-entity",
                        entity_name = "big-explosion"
                    },
                    {
                        type = "create-entity",
                        entity_name = "rm-meteor-entity"
                    },
                    {
                        type = "create-decorative",
                        decorative = "rm-meteor-crater",
                        spawn_max = 1,
                        spawn_min = 1,
                        spawn_min_radius = 0.01,
                        spawn_max_radius = 0.02
                    }
                }
            }
        }
    }
}