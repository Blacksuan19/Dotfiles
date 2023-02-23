-- touchscreen and mouse gestures for mpv.
-- in order to use this, you have to set

-- to configure create a configuration under script-opts, following keys are respected

local OPTS = {
    -- general
    autostart = 0,
    deadzone = 50,
    sample_rate_ms = 48,
    input_delay = mp.get_property_native("input-doubleclick-time"),
    -- seeking / volume controller
    seek_volume_button = "MOUSE_BTN0",
    -- seeking
    pixels_per_second = 10,
    inertia_tick_ms = 16, -- lower values achieve smoother inertia at the cost of performance
    inertia_lower_bound_pixels = 10,
    -- volume
    volume_modifier = 50,
    -- speed
    speed_enabled = 1,
    speed_button = "MBTN_MID",
    pps = 1000,
}
(require 'mp.options').read_options(OPTS)

local mp = require 'mp'
local msg = require 'mp.msg'
math.randomseed(mp.get_time()); math.random(); math.random(); math.random()

local function noop()
end

local function if_enabled(enable) return function(wrappee) if enable then
    local wrap = wrappee();
    return { start = function() wrap.start() end, stop = function() wrap.stop() end }
else
    return { start = noop, stop = noop }
end end end

local function drag_handler(onDrag, onStart, onEnd, options)
    if onStart == nil then onStart = noop end
    if onEnd == nil then onEnd = noop end
    if options == nil then options = {} end
    if options.deadzone == nil then options.deadzone = false end
    if options.deadzone_reset == nil then options.deadzone_reset = "auto" end
    if options.tick_ms == nil then options.tick_ms = 48 end
    if options.button == nil then options.button = "MOUSE_BTN0" end
    if options.input_delay == nil then options.input_delay = mp.get_property_native("input-doubleclick-time") end

    local mouse = "up"
    local state = 0 -- 0: off, 1: drag
    local startx, starty = -1
    local startw, starth = -1;
    local x, y = -1

    local haste = false; -- whether there is a latency (for eg doubleclick) before acting on input, can be controlled externally via set_haste
    local active_deadzone = false;

    local ticker -- hoist timer
    local drag_start_deferrer -- hoist timer

    local function reset()
        drag_start_deferrer:kill();
        ticker:kill();
        if options.deadzone_reset ~= "manual" then active_deadzone = false end
        state = 0
        startx, starty = -1
        x, y = -1
    end

    ticker = mp.add_periodic_timer(options.tick_ms / 1000, function()
        if mouse == "down" and state == 1 then -- in drag
            local w, h = mp.get_osd_size();
            if (w ~= startw or h ~= starth) then -- window size invalidated (ex fullscreen), bail
                reset()
                msg.trace("bailed")
                return
            end

            x, y = mp.get_mouse_pos()
            msg.trace("dragging")
            local diffx, diffy = x - startx, y - starty

            if not options.deadzone then
                onDrag(diffx, diffy)
            else
                if not active_deadzone then
                    local abdiffx, abdiffy = math.abs(diffx), math.abs(diffy)
                    if options.deadzone > abdiffx and options.deadzone > abdiffy then -- both inside deadzone, no active
                        active_deadzone = false;
                    else
                        if abdiffy >= abdiffx then
                            active_deadzone = "y"
                        else
                            active_deadzone = "x"
                        end
                    end
                end

                if active_deadzone then -- a deadzone has been breached, act
                    if active_deadzone == "y" then
                        onDrag(false, diffy)
                    elseif active_deadzone == "x" then
                        onDrag(diffx, false)
                    else
                        msg.warn("unspecified active deadzone value")
                    end
                end
            end
        end
    end); ticker:kill() -- don't run unless initiated

    local function drag_start()
        onStart()
        state = 1
        ticker:resume()
        msg.trace("start drag")
    end
    drag_start_deferrer = mp.add_timeout(options.input_delay / 1000, function()
        drag_start()
    end); drag_start_deferrer:kill();

    local bindingname = "a-" .. math.random(1, 1000000) .. "-b";
    local binding = function(t)
        mouse = t.event

        if mouse == "down" and state == 0 then -- start dragging
            startx, starty = mp.get_mouse_pos()
            startw, starth = mp.get_osd_size()
            x, y = startx, starty
            if haste then drag_start() else drag_start_deferrer:resume() end
        elseif mouse == "up" then -- drag stopped
            local ostate = state
            reset()
            if ostate == 1 then
                msg.trace("end drag")
                onEnd()
            end
        end
    end

    return { start = function()
        mp.remove_key_binding(bindingname)
        mp.add_forced_key_binding(options.button, bindingname, binding, {complex = true, repeatable = true})
    end, stop = function()
        mp.remove_key_binding(bindingname)
        reset();
    end, set_haste = function(h)
        haste = h
    end, reset_deadzone = function()
        active_deadzone = false
    end}
end

local function seek_n_volume()
    local time
    local inertia_start;
    local x
    local dx
    local init_pos
    local init_vol
    local max_vol
    local osd_height
    local control_pos
    local control_vol

    local drag

    local function speedup(x)
        -- in dire need of refactoring, do not expose those as opts yet as it's too finnicky
        local elapsed = (time - inertia_start)/10 + 1
        local speedup = math.max(math.abs(x), 250) * (elapsed)
        if x > 0 then return -speedup else return speedup end
    end

    local function set_pos()
        local setpos = init_pos + x/OPTS.pixels_per_second
        if setpos < 0 then setpos = 0 end
        mp.command("seek " .. setpos .. " absolute exact")
    end

    local function digestX(newx)
        if not control_pos then return end
        local delta = mp.get_time() - time;
        time = delta + time;
        dx = (newx - x) / delta
        x = newx

        set_pos()
    end

    local function digestY(y)
        if not control_vol then return end
        y = -y
        local vol = OPTS.volume_modifier*(y / (osd_height / 2))

        mp.command("set volume " .. math.min(max_vol, math.max(0, init_vol + vol)))
    end

    local function calculX()
        if not control_pos then return end
        local delta = mp.get_time() - time;
        time = delta + time;
        dx = dx + speedup(dx)*delta
        x = x + dx*delta

        set_pos()
    end

    local inertia; inertia = mp.add_periodic_timer(OPTS.inertia_tick_ms / 1000, function()
        msg.trace("on inertia", dx, x)
        calculX()
        if math.abs(dx) < OPTS.inertia_lower_bound_pixels then
            msg.trace("end inertia")
            inertia:kill()
            drag.set_haste(false)
            drag.reset_deadzone()
        end
    end); inertia:kill();


    drag = drag_handler(function(newx, y)
        msg.trace("on drag")
        inertia:kill()
        if newx ~= false then
            control_pos = true
        else
            control_pos = false
        end
        if y ~= false then
            control_vol = true
        else
            control_vol = false
        end

        digestX(newx)
        digestY(y)
    end, function()
        msg.trace("start drag")
        drag.set_haste(true)
        inertia:kill()

        init_pos = mp.get_property_native("time-pos")
        init_vol = mp.get_property_native("volume")
        max_vol = mp.get_property_native("volume-max")
        local _w; w, osd_height = mp.get_osd_size()
        time = mp.get_time()
        x = 0
        dx = 0
    end, function()
        msg.trace("end drag / start inertia")
        inertia_start = mp.get_time()
        inertia:resume()
    end, { deadzone = OPTS.deadzone, deadzone_reset = "manual",
        button = OPTS.seek_volume_button, tick_ms = OPTS.sample_rate_ms, input_delay = OPTS.input_delay })

    return {
    start = function() drag.start() end,
        stop = function() drag.stop() end
    }
end

local function speed()
    local init_speed

    local drag = drag_handler(function(x, y)
        if y ~= false then
            mp.command("set speed 1.0")
            return
        end
        if x ~= false then
            mp.command("set speed " .. math.max(0.01, init_speed + x/OPTS.pps))
            return
        end
    end, function()
        init_speed = mp.get_property_native("speed")
    end, nil, { button = OPTS.speed_button, deadzone = OPTS.deadzone })

    return {
        start = function() drag.start() end,
        stop = function() drag.stop() end
    }
end

local ctl1 = seek_n_volume();
local ctl2 = if_enabled(OPTS.speed_enabled)(speed);

local state = OPTS.autostart;
if state then
    ctl1.start()
    ctl2.start()
end

function toggle_gestures()
    if state == 1 then
        state = 0
        ctl1.stop()
        ctl2.stop()
    else
        state = 1
        ctl1.start()
        ctl2.start()
    end
end

mp.add_key_binding(nil, "toggle", toggle_gestures)
