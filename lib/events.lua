event_handler = { listeners = {} }

event_handler.virtual_events = {
    on_init = true,
    on_load = true,
    on_boner = true,
}

event_handler.real_events = {
    
}

event_handler.listen = function (event_name, callback_to_add, virtual)
    if event_handler.listeners[event_name] then
        for index, callback in pairs(event_handler.listeners[event_name].callbacks) do
            if callback == callback_to_add then return end
        end

        table.insert(event_handler.listeners[event_name].callbacks, callback_to_add)
    else
        event_handler.listeners[event_name] = {}
        event_handler.listeners[event_name].callbacks = {}
        event_handler.listeners[event_name].sound = function (event_data)
            for _, callback in pairs(event_handler.listeners[event_name].callbacks) do
                -- log("callback " .. tostring(_) .. " with val " .. tostring(callback))
                callback(event_data)
            end
        end

        if string.find(event_name, "on_nth_tick_", 1, true) then
            local number = tonumber(string.gsub(event_name, "on_nth_tick_", ""))
            script.on_nth_tick(number, event_handler.listeners[event_name].sound)
        else
            if not virtual then
                log("adding " .. event_name .. " with callback " .. tostring(callback_to_add))
                script.on_event({event_name}, event_handler.listeners[event_name].sound)
            end
        end
        table.insert(event_handler.listeners[event_name].callbacks, callback_to_add)
    end
end

event_handler.deafen = function (event_name, callback_to_remove)
    if event_handler.listeners[event_name] then
        for index, callback in pairs(event_handler.listeners[event_name].callbacks) do
            if callback == callback_to_remove then
                event_handler.listeners[event_name].callbacks[index] = nil
            end
        end
    end
end

event_handler.fire = function (event_name, event_data)
    --log("firing event " .. tostring(event_name))
    if event_handler.listeners[event_name] then
        event_handler.listeners[event_name].sound(event_data)
    end 
end

event_handler.add_libraries = function (input_table)
    for _, library in pairs(input_table) do
        --log("adding events for " .. library.name)
        for event_name, callback in pairs(library.events) do
            if event_handler.virtual_events[event_name] then
                --log("adding virtual event " .. event_name)
                event_handler.listen(event_name, callback, true)
            else
                event_handler.listen(event_name, callback, false)
            end
        end
    end
end

script.on_init(function (event) event_handler.fire("on_init", event) end)
script.on_load(function (event) event_handler.fire("on_load", event) end)
script.on_configuration_changed(function (event) event_handler.fire("on_configuration_changed", event) end)

return event_handler