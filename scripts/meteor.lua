local meteor = {}

meteor.name = "meteor"

meteor.default_meteors = {
    meteor = {
        name = "meteor",
        projectile = "meteor",
        shadow = "meteor-shadow",
        land_entity = "meteor-remnant"
    }
}



meteor.on_init = function ()
    meteor.intialize_table()
end

meteor.on_configuration_changed = function ()
    meteor.intialize_table(true)
end

meteor.intialize_table = function (override)
    if override then
        storage.meteor_table = nil
    end

    storage.meteor_table = storage.meteor_table or {}
end

meteor.events = {

}

return meteor