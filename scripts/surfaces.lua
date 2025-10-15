local surfaces = {}

surfaces.name = "surfaces"

surfaces.default = {
    weights = {meteor = 10},
    min_spawn_ticks = 3600,
    max_spawn_ticks = 3600 * 4,
    next_spawn_tick = 3600,
    min_amount = 1,
    min_pollution_multiplier = 10,
    max_amount = 10,
    max_pollution_multiplier = 10,
    do_pollution_scaling = false,
    pollution_scaling = "linear",
    version = 1.0,
    chunk_map = {{0, 0}, {-1, 0}, {0, -1}, {-1, -1}}
}
-- surfaces.default.weights = {meteor = 10, dingaling = 20}
-- surfaces.default.min_spawn_ticks = 3600
-- surfaces.default.max_spawn_ticks = 3600 * 4
-- surfaces.default.next_spawn_tick = surfaces.default.min_spawn_ticks
-- surfaces.default.min_amount = 1
-- surfaces.default.min_pollution_multiplier = 1
-- surfaces.default.max_amount = 10
-- surfaces.default.max_pollution_multiplier = 1
-- surfaces.default.do_pollution_scaling = false
-- surfaces.default.pollution_scaling = "linear"
-- surfaces.default.version = 1.0
-- surfaces.default.double_chunk_map = {{0, 0}, {-1, 0}, {0, -1}, {-1, -1}}

surfaces.on_init = function ()
    surfaces.initialize_table()
end

surfaces.on_configuration_changed = function ()
    surfaces.initialize_table()

    for surface_name, v in pairs(storage.meteor_surfaces) do
        surfaces.verify_registry(surface_name)
    end

end

surfaces.initialize_table = function ()
    storage.meteor_surfaces = storage.meteor_surfaces or {}
end

surfaces.register_surface = function (surface_name, parameters, override)
    if game.surfaces[surface_name] and game.surfaces[surface_name].valid then
        local surface_table = storage.meteor_surfaces[surface_name] or {}
        
        parameters = parameters or {}

        for parameter, value in pairs(surfaces.default) do
            if not surface_table[parameter] then --fill out default values if they aren't present
                surface_table[parameter] = value
            end
            
            if override then
                --game.print("overriding parameter ".. parameter)
                surface_table[parameter] = value
            end

            if parameters[parameter] then
                surface_table[parameter] = parameters[parameter]
            end

            if parameter == "weights" then
                local total = 0
                local cumulative_indices = {}
                for k, v in pairs(surface_table[parameter]) do
                    if k ~= "total_weight" and k ~= "cumulative_indices" then
                        for i=1, v do
                            total = total + 1
                            cumulative_indices[total] = k
                        end
                        
                        -- cumulative_indices 
                    end
                end
                --game.print("we got a total of ".. total)
                surface_table[parameter]["total_weight"] = total
                surface_table[parameter]["cumulative_indices"] = cumulative_indices
            end
        end

        storage.meteor_surfaces[surface_name] = surface_table
    end
end

surfaces.unregister_surface = function (surface_name)
    if storage.meteor_surfaces[surface_name] then
        table.remove(storage.meteor_surfaces, surface_name)
    end
end

surfaces.get_surface_registration = function (surface_name)
    return storage.meteor_surfaces[surface_name]
end

surfaces.set_surface_registration = function (surface_name, parameters)
    storage.meteor_surfaces[surface_name] = parameters
end

surfaces.calculate_weights = function (surface_name)
    total = 0
    for _, v in pairs(storage.meteor_surfaces[surface_name]["weights"]) do
        total = total + v
    end
    game.print(serpent.block(storage.meteor_surfaces[surface_name]["weights"]))
    local total = 0
    local cumulative_indices = {}
    for k, v in pairs(storage.meteor_surfaces[surface_name]["weights"]) do
        if k ~= "total_weight" or k ~= "cumulative_indices" then
            for i=1, v do
                total = total + 1
                cumulative_indices[total] = k
            end
        end
    end
    game.print(total)
    storage.meteor_surfaces[surface_name]["weights"]["total_weight"] = total
    storage.meteor_surfaces[surface_name]["weights"]["cumulative_indices"] = cumulative_indices
end

surfaces.add_meteor_type = function (surface_name, meteor_name, weight)
    storage.meteor_surfaces[surface_name][meteor_name] = weight
    surfaces.calculate_weights(surface_name)
end

surfaces.verify_registry = function (surface_name)
    local current_table = storage.meteor_surfaces[surface_name]
    if current_table.version ~= surfaces.default.version then
        
    else
        for parameter, value in pairs(surfaces.default) do
            if not current_table[parameter] then --fill out default values if they aren't present
                current_table[parameter] = value
            end
        end
    end

    storage.meteor_surfaces[surface_name] = current_table
end

surfaces.get_meteor_pull = function (surface_name, amount)
    result = {}
    if not amount then
        amount = 1
    end

    for i=1, amount do
        index = math.random(1, storage.meteor_surfaces[surface_name].weights["total_weight"])
        table.insert(result, storage.meteor_surfaces[surface_name].weights.cumulative_indices[index])
    end

    return result
end

surfaces.print_registered_surfaces = function ()
    surfaces.initialize_table()

    game.print("Registered surfaces:")
    for k, _ in pairs(storage.meteor_surfaces) do
        game.print(k)
    end

end

surfaces.on_tick = function (event)

end

commands.add_command("rm-print-registered-surfaces", "idek", function (command)
    surfaces.print_registered_surfaces()
end)

commands.add_command("rm-recalculate-meteor-weights", "idek", function (command)
    if command.parameter then
        game.print("Recalculating weights for ".. command.parameter)
        surfaces.calculate_weights(command.parameter)
    else
        game.print("Please include a surface name.")
    end
end)

commands.add_command("rm-demo-meteor-pull", "idek", function (command)
    local amount
    if command.parameter then
        amount = tonumber(command.parameter)
    end
    game.print("Grabbing pull of " .. amount .. " meteors.")
    local result = surfaces.get_meteor_pull("nauvis", amount)
    game.print(serpent.block(result))

    for _, v in pairs(result) do
        meteor.queue_meteor(game.surfaces["nauvis"], {math.random(-100, 100), math.random(-100, 100)}, v, game.tick + math.random(60 * 20))
    end
end)

surfaces.events = {
    [defines.events.on_tick] = surfaces.on_tick,
    on_init = surfaces.on_init,
    on_configuration_changed = surfaces.on_configuration_changed,
}

return surfaces