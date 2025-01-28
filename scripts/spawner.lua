spawner = {}

spawner.name = "spawner"

spawner.on_init = function () 
    spawner.initialize_table()
end

spawner.on_configuration_changed = function ()
    spawner.initialize_table()
end

spawner.initialize_table = function ()
    storage.meteor_schedules = storage.meteor_schedules or {}
end

spawner.on_tick = function (event)
    
end

spawner.events = {
    [defines.events.on_tick] = spawner.on_tick,
    on_init = spawner.on_init,
    on_configuration_changed = spawner.on_configuration_changed,
}

return spawner