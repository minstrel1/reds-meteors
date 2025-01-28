local math2d = require("__core__/lualib/math2d")

local meteor = {}

meteor.name = "meteor"

meteor.default_meteors = {
    meteor = {
        name = "meteor",
        projectile = "rm-meteor-projectile",
        shadow = "rm-meteor-shadow",
    }
}

meteor.spawn_distance = 250
meteor.spawn_distance_deviation = 25
meteor.spawn_angle = 25
meteor.spawn_angle_deviation = 15
meteor.meteor_speed = 1.5
meteor.meteor_speed_deviation = 1
meteor.meteor_shadow_speed = 0.65

meteor.queue_limit = 5000


meteor.on_init = function ()
    meteor.intialize_table()
    meteor.add_defaults()
end

meteor.on_configuration_changed = function ()
    meteor.intialize_table(true)
    meteor.add_defaults()
end

meteor.kill_all_meteors = function (surface_name)
    -- if surface_name then
    --     if storage.active_meteors
    -- else

    -- end
end


meteor.intialize_table = function (override)
    if override then
        storage.meteor_table = nil
        storage.active_meteors = nil
        storage.meteor_queue = nil
    end

    storage.meteor_table = storage.meteor_table or {}
    storage.active_meteors = storage.active_meteors or {}
    storage.meteor_queue = storage.meteor_queue or {}
end

meteor.add_meteor = function (meteor_name, projectile_name, shadow_name)
    meteor.intialize_table()

    if not meteor_name then
        log("Red's Meteors: A meteor name was not specified. Skipping adding.")
    end

    if not projectile_name then
        log("Red's Meteors: A projectile was not specified when trying to add " .. meteor_name .. ". Skipping adding.")
    end

    storage.meteor_table[meteor_name] = {
        name = meteor_name,
        projectile = projectile_name,
        shadow = shadow_name,
    }
end

meteor.summon_meteor = function (surface, target_position, meteor_name)
    meteor.intialize_table()

    if storage.meteor_table[meteor_name] then
        if surface and surface.valid then
            local meteor_distance = meteor.spawn_distance + math.random(-meteor.spawn_distance_deviation, meteor.spawn_distance_deviation)
            local offset = {0, -meteor_distance}
            offset = math2d.position.rotate_vector(offset, meteor.spawn_angle + math.random(-meteor.spawn_angle_deviation, meteor.spawn_angle_deviation))

            local meteor_speed = meteor.meteor_speed + (math.random() - 0.5) * meteor.meteor_speed_deviation

            local spawned_meteor = surface.create_entity{
                name = storage.meteor_table[meteor_name].projectile,
                position = math2d.position.add(target_position, offset),
                target = target_position,
                speed = meteor_speed
            }
            
            local spawned_meteor_shadow

            if storage.meteor_table[meteor_name].shadow then
                spawned_meteor_shadow = surface.create_entity{
                    name = storage.meteor_table[meteor_name].shadow,
                    position = math2d.position.add(target_position, {meteor_distance * meteor.meteor_shadow_speed, 0}),
                    target = target_position,
                    speed = meteor_speed * meteor.meteor_shadow_speed
                }
            end

            -- game.print("Spawned " .. meteor_name .. " at " .. serpent.block(math2d.position.add(target_position, offset)))
            -- if spawned_meteor_shadow then
            --     game.print("also spawned a shadow lol!")
            -- end
            
        else
            game.print("that surface is invalid chud!")
        end
    else
        log("Red's Meteors: " .. meteor_name .. " does not exist in the meteor table. Skipping spawning.")
        game.print("that meteor doesn't exist chud!")
    end
end

meteor.queue_meteor = function (surface, target_position, meteor_name, tick)
    meteor.intialize_table()

    if storage.meteor_table[meteor_name] then
        if surface and surface.valid then
            table.insert(storage.meteor_queue, {surface = surface, target_position = target_position, meteor_name = meteor_name, tick = tick})
        end
    else
        log("Red's Meteors: " .. meteor_name .. " does not exist in the meteor table. Skipping spawning.")
    end
end

meteor.add_defaults = function ()
    meteor.intialize_table()
    
    for name, table in pairs(meteor.default_meteors) do
        storage.meteor_table[name] = table
    end
end

meteor.on_tick = function (event)
    if storage.meteor_queue then
        for k, v in pairs(storage.meteor_queue) do
            if v.tick == event.tick then
                meteor.summon_meteor(v.surface, v.target_position, v.meteor_name)
                table.remove(storage.meteor_queue, k)
            end
        end
    end
end

commands.add_command("rm-demo-spawn-meteor", "idek", function (command)
    meteor.summon_meteor(game.surfaces[1], {math.random(-20, 20), math.random(-20, 20)}, "meteor")
end)

commands.add_command("rm-add-meteor-defaults", "idek", function (command)
    meteor.add_defaults()
end)

commands.add_command("rm-demo-meteor-queue", "idek", function (command)
    local amount
    if command.parameter then
        amount = tonumber(command.parameter)
    end
    game.print("Queueing " .. amount .. " meteors.")
    for i=1, amount do
        meteor.queue_meteor(game.surfaces[1], {(math.random() - 0.5) * 400, (math.random() - 0.5) * 400}, "meteor", command.tick + math.random(1, 2000))
    end
end)


meteor.events = {
    [defines.events.on_tick] = meteor.on_tick,
    on_init = meteor.on_init,
    on_configuration_changed = meteor.on_configuration_changed,
}
return meteor