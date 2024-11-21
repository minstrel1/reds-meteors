debug_mode = true

event_handler = require("lib/events.lua")

surfaces = require("scripts/surfaces")
meteor = require("scripts/meteor")
spawner = require("scripts/spawner")
defense = require("scripts/defense")

event_handler.add_libraries({
    surfaces,
    meteor,
    spawner,
    defense
})

function register_defaults ()
    game.print("registering defaults")
    surfaces.register_surface("nauvis", {}, true)
end

event_handler.listen("on_configuration_changed", function ()
    register_defaults()
end)

event_handler.listen("on_init", function ()
    register_defaults()
end)

commands.add_command("rm-register-defaults", "idek", function (command)
    register_defaults()
end)



