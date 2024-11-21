local surfaces = {}

surfaces.name = "surfaces"

surfaces.default = {}
surfaces.default.weights = {}
surfaces.default.min_spawn_ticks = 3600
surfaces.default.max_spawn_ticks = 3600 * 4
surfaces.default.next_spawn_tick = surfaces.default.min_spawn_ticks
surfaces.default.min_amount = 1
surfaces.default.min_pollution_multiplier = 1
surfaces.default.max_amount = 10
surfaces.default.max_pollution_multiplier = 1
surfaces.default.do_pollution_scaling = false
surfaces.default.pollution_scaling = "linear"
surfaces.default.version = 1.0
surfaces.default.double_chunk_map = {{0, 0}, {-1, 0}, {0, -1}, {-1, -1}}

surfaces.on_init = function ()
    surfaces.initialize_table()
end

surfaces.on_configuration_changed = function ()
    surfaces.initialize_table()

    for surface_name, v in pairs(storage.meteor_surfaces) do
        surfaces.verify_table(surface_name)
    end

end

surfaces.initialize_table = function ()
    storage.meteor_surfaces = storage.meteor_surfaces or {}
end

surfaces.register_surface = function (surface_name, parameters)
    if game.surfaces[surface_name] and game.surfaces[surface_name].valid then
        local surface_table = storage.meteor_surfaces[surface_name] or {}
        
        for parameter, value in pairs(surfaces.default) do
            if not surface_table[parameter] then --fill out default values if they aren't present
                surface_table[parameter] = value
            end

            if parameters[parameter] then
                surface_table[parameter] = parameters[parameter]

                if parameter == "weights" then
                    local total = 0
                    local cumulative_indices = {}
                    for k, v in pairs(surface_table[parameter]) do
                        if k ~= "total_weight" or k ~= "cumulative_indices" then
                            for i=i, v do
                            
                            end
                            total = total + v
                            -- cumulative_indices 
                        end
                    end
                    surface_table[parameter]["total_weight"] = total
                end
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
    storage.meteor_surfaces[surface_name]["total_weight"] = total
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
        
        -- table.insert(result)
    end
end

surfaces.on_tick = function (event)
    
end

surfaces.events = {
    [defines.events.on_tick] = surfaces.on_tick,
    on_init = surfaces.on_init,
    on_configuration_changed = surfaces.on_configuration_changed,
}

return surfaces