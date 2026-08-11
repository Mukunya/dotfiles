--[[
  hyprland.lua — rewritten from the classic hyprlang hyprland.conf
  into the new Lua config format shipped with Hyprland 0.55+.

  A few notes before you use this:

  1. The Lua config API (hl.*) is very new and still moving fast. I've built
     this from the current official docs/example (wiki.hypr.land + the
     hyprwm/Hyprland example/hyprland.lua), but a handful of dispatcher
     names below (marked with "VERIFY") aren't 100% nailed down in the
     public docs yet — double check them with:
         hyprctl repl
         > hl.dsp   -- tab-complete to explore available dispatchers
  2. Save this as ~/.config/hypr/hyprland.lua. If that file exists,
     Hyprland loads it INSTEAD of hyprland.conf (checked once at startup).
  3. exec-once has no direct keyword anymore — it's replaced by hooking
     the "hyprland.start" event, see the AUTOSTART section below.
  4. source = becomes require(...) if you want to split this file up.
--]]

------------------------------------------------------------
---- VARIABLES ----
------------------------------------------------------------

local mainMod    = "SUPER"
local HYPRSCRIPTS = os.getenv("HOME") .. "/.config/hypr/scripts"
local SCRIPTS      = os.getenv("HOME") .. "/.config/ml4w/scripts"

-- Material You palette (plain Lua locals instead of $var)
local background                    = "rgba(121318ff)"
local error_                        = "rgba(ffb4abff)"
local error_container               = "rgba(93000aff)"
local inverse_on_surface            = "rgba(2f3036ff)"
local inverse_primary                = "rgba(485d92ff)"
local inverse_surface                = "rgba(e2e2e9ff)"
local on_background                 = "rgba(e2e2e9ff)"
local on_error                      = "rgba(690005ff)"
local on_error_container            = "rgba(ffdad6ff)"
local on_primary                    = "rgba(172e60ff)"
local on_primary_container          = "rgba(dae2ffff)"
local on_primary_fixed              = "rgba(001847ff)"
local on_primary_fixed_variant      = "rgba(304578ff)"
local on_secondary                  = "rgba(2a3042ff)"
local on_secondary_container        = "rgba(dce2f9ff)"
local on_secondary_fixed            = "rgba(151b2cff)"
local on_secondary_fixed_variant    = "rgba(404659ff)"
local on_surface                    = "rgba(e2e2e9ff)"
local on_surface_variant            = "rgba(c5c6d0ff)"
local on_tertiary                   = "rgba(412742ff)"
local on_tertiary_container         = "rgba(fed7f9ff)"
local on_tertiary_fixed             = "rgba(2a122cff)"
local on_tertiary_fixed_variant     = "rgba(5a3d59ff)"
local outline                       = "rgba(8f9099ff)"
local outline_variant               = "rgba(44464fff)"
local primary                       = "rgba(b1c5ffff)"
local primary_container             = "rgba(304578ff)"
local primary_fixed                 = "rgba(dae2ffff)"
local primary_fixed_dim             = "rgba(b1c5ffff)"
local scrim                         = "rgba(000000ff)"
local secondary                     = "rgba(c0c6ddff)"
local secondary_container           = "rgba(404659ff)"
local secondary_fixed               = "rgba(dce2f9ff)"
local secondary_fixed_dim           = "rgba(c0c6ddff)"
local shadow                        = "rgba(000000ff)"
local source_color                  = "rgba(0e1933ff)"
local surface                       = "rgba(121318ff)"
local surface_bright                = "rgba(38393fff)"
local surface_container             = "rgba(1e1f25ff)"
local surface_container_high        = "rgba(282a2fff)"
local surface_container_highest     = "rgba(33343aff)"
local surface_container_low         = "rgba(1a1b21ff)"
local surface_container_lowest      = "rgba(0d0e13ff)"
local surface_dim                   = "rgba(121318ff)"
local surface_tint                  = "rgba(b1c5ffff)"
local surface_variant               = "rgba(44464fff)"
local tertiary                      = "rgba(e1bbddff)"
local tertiary_container            = "rgba(5a3d59ff)"
local tertiary_fixed                = "rgba(fed7f9ff)"
local tertiary_fixed_dim            = "rgba(e1bbddff)"

------------------------------------------------------------
---- MONITORS ----
------------------------------------------------------------
-- https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
    output   = "desc:LG Electronics LG HDR 4K 0x0004B7BD",
    mode     = "3840x2160@60.0",
    position = "0x0",
    scale    = 1.5,
    bitdepth = 10,
    vrr      = true,
    cm       = "dcip3",
})

hl.monitor({
    output   = "desc:Samsung Electric Company S24F350 H4ZN800216",
    mode     = "1920x1080@72.0",
    position = "2560x180",
    scale    = 1.0,
    bitdepth = 10,
    vrr      = true,
    cm       = "dcip3",
})

hl.monitor({
    output   = "desc:Samsung Electric Company S24F350 H4ZN718035",
    mode     = "1920x1080@72.0",
    position = "-1920x180",
    scale    = 1.0,
    bitdepth = 10,
    vrr      = true,
    cm       = "dcip3",
})

hl.monitor({
    output   = "vnc",
    mode     = "1920x1080@60",
    position = "0x-2000",
    scale    = 1,
})

-- Fallback rule for anything unmatched above
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

------------------------------------------------------------
---- INPUT ----
------------------------------------------------------------

hl.config({
    input = {
        kb_layout        = "hu",
        kb_variant       = "",
        kb_model         = "",
        kb_options       = "",
        numlock_by_default = true,
        follow_mouse       = 1,
        mouse_refocus      = false,
        sensitivity        = 0,
        accel_profile = "flat",
        touchpad = {
            natural_scroll       = false,
            scroll_factor        = 1.0,
            disable_while_typing = false,
        },
        tablet = {
            output = "current"
        }
    },
})

------------------------------------------------------------
---- AUTOSTART ----
------------------------------------------------------------
-- https://wiki.hypr.land/Configuring/Basics/Autostart/
-- exec-once -> hook the "hyprland.start" event, fires once per session.
-- Inside the callback, use hl.exec_cmd(...) directly (not through hl.dispatch).

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
    hl.exec_cmd("uwsm app -- ~/.config/ml4w/listeners.sh --startall")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("uwsm app -- ~/.config/ml4w/scripts/ml4w-wallpaper-app --restore")
    hl.exec_cmd("uwsm app -- ~/.config/ml4w/scripts/ml4w-autostart")
    hl.exec_cmd("uwsm app -- ~/.config/hypr/scripts/gtk.sh")
    hl.exec_cmd("uwsm app -- hypridle")
    hl.exec_cmd("uwsm app -- wl-paste --watch cliphist store")
    hl.exec_cmd("uwsm app -- ~/.config/ml4w/scripts/ml4w-autostart.sh")
    hl.exec_cmd("uwsm app -- ~/.config/hypr/scripts/cleanup.sh")
    hl.exec_cmd("uwsm app -- wayle shell")
    hl.exec_cmd("uwsm app -- hyprctl output create headless vnc")
    hl.exec_cmd("uwsm app -- wayvnc -g -o vnc 0.0.0.0")
    hl.exec_cmd("uwsm app -- ~/.config/wayvnc/event-watcher.sh")
    hl.exec_cmd("ulauncher")
    hl.exec_cmd("uwsm app -- ~/.config/pipewire/scripts/volumecontrol.py")
    hl.exec_cmd("uwsm app -- hyprpm reload")
    hl.exec_cmd("sunshine")
    hl.exec_cmd("pidof hyprlock || hyprlock")
end)

-- Plain `exec` (re-run on every config reload, unlike exec-once):
hl.exec_cmd("~/.config/com.ml4w.hyprlandsettings/hyprctl.sh")
hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"')

------------------------------------------------------------
---- LOOK AND FEEL ----
------------------------------------------------------------
-- https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    general = {
        gaps_in    = 4,
        gaps_out   = 4,
        border_size = 3,
        col = {
            active_border   = { colors = { primary, on_primary }, angle = 90 },
            inactive_border = on_primary,
        },
        layout          = "dwindle",
        resize_on_border = true,
        allow_tearing = true,
    },

    decoration = {
        rounding          = 10,
        active_opacity    = 1.0,
        inactive_opacity  = 0.9,
        fullscreen_opacity = 1.0,
        dim_around        = 0.6,

        blur = {
            enabled            = true,
            size               = 4,
            passes             = 4,
            new_optimizations  = true,
            ignore_opacity     = true,
            xray               = true,
        },

        shadow = {
            enabled      = true,
            range        = 32,
            render_power = 2,
            color        = "rgba(00000050)",
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    binds = {
        workspace_back_and_forth = false,
        allow_workspace_cycles   = true,
        pass_mouse_when_bound    = false,
    },

    misc = {
        disable_hyprland_logo      = true,
        disable_splash_rendering   = true,
        initial_workspace_tracking = 1,
        on_focus_under_fullscreen  = 1,
        allow_session_lock_restore = true,
        vrr                        = 1,
    },

    cursor = {
        min_refresh_rate = 40
    },

    render = {
        direct_scanout = 1,
        cm_auto_hdr    = 1,
        send_content_type = false,

    },

    debug = {
        full_cm_proto = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

------------------------------------------------------------
---- ANIMATIONS / BEZIER CURVES ----
------------------------------------------------------------
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- hl.curve() replaces `bezier = name, x1, y1, x2, y2`

hl.curve("linear",        { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("md3_standard",  { type = "bezier", points = { {0.2, 0}, {0, 1} } })
hl.curve("md3_decel",     { type = "bezier", points = { {0.05, 0.7}, {0.1, 1} } })
hl.curve("md3_accel",     { type = "bezier", points = { {0.3, 0}, {0.8, 0.15} } })
hl.curve("overshot",      { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.1} } })
hl.curve("crazyshot",     { type = "bezier", points = { {0.1, 1.5}, {0.76, 0.92} } })
hl.curve("hyprnostretch", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0} } })
hl.curve("menu_decel",    { type = "bezier", points = { {0.1, 1}, {0, 1} } })
hl.curve("menu_accel",    { type = "bezier", points = { {0.38, 0.04}, {1, 0.07} } })
hl.curve("easeInOutCirc", { type = "bezier", points = { {0.85, 0}, {0.15, 1} } })
hl.curve("easeOutCirc",   { type = "bezier", points = { {0, 0.55}, {0.45, 1} } })
hl.curve("easeOutExpo",   { type = "bezier", points = { {0.16, 1}, {0.3, 1} } })
hl.curve("softAcDecel",   { type = "bezier", points = { {0.26, 0.26}, {0.15, 1} } })
hl.curve("md2",           { type = "bezier", points = { {0.4, 0}, {0.2, 1} } })

-- animation = name, onoff, speed, curve, [style]
hl.animation({ leaf = "windows",         enabled = true, speed = 3,   bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "windowsIn",       enabled = true, speed = 3,   bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "windowsOut",      enabled = true, speed = 3,   bezier = "md3_accel", style = "popin 60%" })
hl.animation({ leaf = "border",          enabled = true, speed = 10,  bezier = "default" })
hl.animation({ leaf = "fade",            enabled = true, speed = 3,   bezier = "md3_decel" })
hl.animation({ leaf = "layersIn",        enabled = true, speed = 3,   bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "layersOut",       enabled = true, speed = 1.6, bezier = "menu_accel" })
hl.animation({ leaf = "fadeLayersIn",    enabled = true, speed = 2,   bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut",   enabled = true, speed = 4.5, bezier = "menu_accel" })
hl.animation({ leaf = "workspaces",      enabled = true, speed = 7,   bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3,  bezier = "md3_decel", style = "slidevert" })

------------------------------------------------------------
---- WORKSPACE RULES ----
------------------------------------------------------------
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.workspace_rule({ workspace = 1,  monitor = "desc:LG Electronics LG HDR 4K 0x0004B7BD", default = true })
hl.workspace_rule({ workspace = 2,  monitor = "desc:LG Electronics LG HDR 4K 0x0004B7BD" })
hl.workspace_rule({ workspace = 3,  monitor = "desc:LG Electronics LG HDR 4K 0x0004B7BD" })
hl.workspace_rule({ workspace = 4,  monitor = "desc:Samsung Electric Company S24F350 H4ZN718035", default = true })
hl.workspace_rule({ workspace = 5,  monitor = "desc:Samsung Electric Company S24F350 H4ZN800216", default = true })
hl.workspace_rule({ workspace = 10, monitor = "desc:LG Electronics LG HDR 4K 0x0004B7BD" })

-- "Smart gaps" / no gaps when only one window
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })

------------------------------------------------------------
---- PLUGINS ----
------------------------------------------------------------
-- NOTE: plugin config surfaces (like hyprbars) may expose their own Lua
-- API rather than a bare hl.config({ plugin = ... }) table now that config
-- is Turing-complete Lua — check the plugin's own docs/README if this
-- section doesn't take effect after `hyprpm reload`.

hl.config({
    plugin = {
        hyprbars = {
            bar_height            = 30,
            bar_buttons_alignment = "left",
            bar_blur              = true,
            icon_on_hover         = true,
            bar_padding           = 7,
            inactive_button_color = "rgba(00000040)",
            on_double_click       = "hyprctl dispatch fullscreen 1",
        },
    },
})

hl.plugin.hyprbars.add_button({
    bg_color = "rgb(ff4040)",
    fg_color = "rgb(000000)",
    size     = 13,
    icon     = "󰖭",
    action = "hyprctl dispatch 'hl.dsp.window.close()'"
})

hl.plugin.hyprbars.add_button({
    bg_color = "rgb(eeee11)",
    fg_color = "rgb(000000)",
    size     = 13,
    icon     = "━",
    action   = "hyprctl dispatch exec ~/.config/hypr/scripts/specialworkspace.sh",
})

hl.plugin.hyprbars.add_button({
    bg_color = "rgb(40ff40)",
    fg_color = "rgb(000000)",
    size     = 13,
    icon     = "⛶",
    action = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']]
})

------------------------------------------------------------
---- KEYBINDINGS ----
------------------------------------------------------------
-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- https://wiki.hypr.land/Configuring/Basics/Dispatchers/

hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("uwsm app -- ~/.config/ml4w/settings/terminal.sh"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("uwsm app -- ~/.config/ml4w/settings/browser.sh"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("uwsm app -- ~/.config/ml4w/settings/filemanager"))
hl.bind(mainMod .. " + CTRL + E", hl.dsp.exec_cmd("uwsm app -- ~/.config/ml4w/settings/emojipicker.sh"))
hl.bind(mainMod .. " + CTRL + C", hl.dsp.exec_cmd("uwsm app -- ~/.config/ml4w/settings/calculator.sh"))

-- Cursor zoom in/out — kept as raw hyprctl calls since these read the
-- current zoom_factor at runtime (shell arithmetic, not something the
-- Lua config layer resolves for you at parse time).
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.exec_cmd(
    [[hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}")]]
))
hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.exec_cmd(
    [[hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}")]]
))
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1"))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(
    "hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"
))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-toggle-allfloat"))
hl.bind(mainMod .. " + ALT + T", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-toggle-float-pin"))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({x = 100, y = 0, relative = true } ))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({x = -100, y = 0, relative = true } ))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({x = 0, y = 100, relative = true } ))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({x = 0, y = -100, relative = true } ))

hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + K", hl.dsp.layout("swapsplit"))

hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.swap({ direction = "down" }))

hl.bind("ALT + Tab", hl.dsp.window.cycle_next(), { repeating = true })
hl.bind("ALT + Tab", hl.dsp.window.bring_to_top(), { repeating = true })

hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/toggle-animations.sh"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("uwsm app -- " .. HYPRSCRIPTS .. "/screenshot.sh"))
hl.bind(mainMod .. " + ALT + F", hl.dsp.exec_cmd("uwsm app -- " .. HYPRSCRIPTS .. "/screenshot.sh --instant"))
hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("uwsm app -- " .. HYPRSCRIPTS .. "/screenshot.sh --instant-area"))
hl.bind(mainMod .. " + ALT + A", hl.dsp.exec_cmd("uwsm app -- " .. HYPRSCRIPTS .. "/text-extractor.sh"))
hl.bind(mainMod .. " + CTRL + Q", hl.dsp.exec_cmd("uwsm app -- qs ipc call power toggle"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("uwsm app -- " .. SCRIPTS .. "/ml4w-wallpaper-app --random"))
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd("uwsm app -- " .. SCRIPTS .. "/ml4w-wallpaper-app"))
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd("uwsm app -- " .. SCRIPTS .. "/ml4w-wallpaper-automation"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("ulauncher-toggle"))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.exec_cmd("uwsm app -- " .. HYPRSCRIPTS .. "/keybindings.sh"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("uwsm app -- " .. HYPRSCRIPTS .. "/loadconfig.sh"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("uwsm app -- " .. SCRIPTS .. "/ml4w-cliphist"))
hl.bind(mainMod .. " + CTRL + T", hl.dsp.exec_cmd("uwsm app -- ~/.config/waybar/themeswitcher.sh"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("uwsm app -- ~/.config/ml4w/scripts/ml4w-toggle-theme"))
hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/gamemode.sh"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.exec_cmd(SCRIPTS .. "/ml4w-toggle-hyprsunset"))
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("qs -p uwsm app -- $HOME/.config/quickshell/overview ipc call overview toggle"))
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd("uwsm app -- ~/.config/ml4w/themes/themes.sh"))

-- Workspaces 1-9, 0 -> workspace 10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + X", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + Y", hl.dsp.workspace.toggle_special("spcleft"))
hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.window.move({ workspace = "special:spcleft" }))

hl.bind("XF86Calculator", function()
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "toggle", monitor = "HDMI-A-3" }))
        hl.dispatch(hl.dsp.dpms({ action = "toggle", monitor = "HDMI-A-4" }))
    end, { timeout = 1000, type = "oneshot" })
end)

------------------------------------------------------------
---- WINDOW RULES ----
------------------------------------------------------------
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
    name = "pavucontrol",
    match = { class = "(.*org.pulseaudio.pavucontrol.*)" },
    float = true, center = true, pin = true, size = "700 600",
})

hl.window_rule({
    name = "waypaper",
    match = { class = "(.*waypaper.*)" },
    float = true, center = true, pin = true, size = "900 700",
})

hl.window_rule({
    name = "newelle",
    match = { class = "(io.github.qwersyk.Newelle)" },
    float = true, center = true, pin = true, size = "1000 700",
})

hl.window_rule({
    name = "ml4w-calendar",
    match = { class = "(com.ml4w.calendar)" },
    float = true, move = "21 76", pin = true, size = "400 400",
})

hl.window_rule({
    name = "ml4w-sidebar",
    match = { class = "(com.ml4w.sidebar)" },
    float = true, move = "monitor_w-window_w-21 76", pin = true, size = "400 660",
})

hl.window_rule({
    name = "ml4w-welcome",
    match = { class = "(com.ml4w.welcome)" },
    float = true, center = true, pin = true, size = "700 600",
})

hl.window_rule({
    name = "ml4w-welcome-app",
    match = { title = "(ML4W Welcome)" },
    float = true, center = true, pin = true, size = "700 600",
})

hl.window_rule({
    name = "ml4w-settings",
    match = { class = "(com.ml4w.settings)" },
    float = true, move = "monitor_w*0.5-window_w*0.5 86", pin = true, size = "900 600",
})

hl.window_rule({
    name = "ml4w-settings-app",
    match = { title = "(ML4W Dotfiles Settings)" },
    float = true, move = "monitor_w*0.5-window_w*0.5 86", pin = true, size = "900 600",
})

hl.window_rule({
    name = "blueman-manager",
    match = { class = "(blueman-manager)" },
    float = true, center = true, size = "800 600",
})

hl.window_rule({
    name = "nwg-look",
    match = { class = "(nwg-look)" },
    float = true, center = true, size = "700 600",
})

hl.window_rule({
    name = "nwg-displays",
    match = { class = "(nwg-displays)" },
    float = true, center = true, size = "900 600",
})

hl.window_rule({
    name = "missioncenter",
    match = { class = "(io.missioncenter.MissionCenter)" },
    float = true, center = true, pin = true, size = "900 600",
})

hl.window_rule({
    name = "gnome-calculator",
    match = { class = "(org.gnome.Calculator)" },
    float = true, center = true, size = "700 600",
})

hl.window_rule({
    name = "hyprland-share-picker",
    match = { class = "(hyprland-share-picker)" },
    float = true, pin = true, center = true, size = "600 400",
})

hl.window_rule({
    name = "nm-connection-editor",
    match = { class = "(nm-connection-editor)" },
    float = true, center = true, size = "800 700",
})

hl.window_rule({
    name = "Picture-in-Picture",
    match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
    float = true, pin = true, center = true,
})

hl.window_rule({
    name = "dotfiles-floating",
    match = { class = "(dotfiles-floating)" },
    float = true, center = true, size = "1000 700",
})

hl.window_rule({
    name = "dotfiles-sidepad",
    match = { class = "(dotfiles-sidepad)" },
    float = true, pin = true, center = true, size = "1000 700",
})

-- No border/rounding on the "solo tiled window" special workspaces
hl.window_rule({
    name = "no-gaps-wtv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0, rounding = 0,
})
hl.window_rule({
    name = "no-gaps-f1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0, rounding = 0,
})

hl.window_rule({
    name = "waydroid",
    match = { class = "Waydroid" },
    float = true, size = "562 1000",
})

hl.window_rule({
    name = "ulauncher",
    match = { class = "ulauncher" },
    float = true, pin = true, stay_focused = true, decorate = false,
    no_blur = true, xray = true, no_shadow = true, dim_around = true, center = true,
})

hl.window_rule({
    name = "steam",
    match = { class = "steam" },
    workspace = 2, no_initial_focus = true,
})

hl.window_rule({
    name = "tearing",
    match = { fullscreen },
    immediate = 1
})