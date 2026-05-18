hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = "1.2",
})

local app_runner  = "$APPRUNNER"
local terminal    = app_runner.." kitty"
local browser     = app_runner.." zen-browser"
local google      = app_runner.." chromium"
local menu        = "rofi -show drun -run-command \""..app_runner.." {cmd}\""
local colorpicker = "hyprpicker -a"
local webapp      = google .. " --new-window --app="
local zen_silent = true

hl.on("hyprland.start", function()
    hl.exec_cmd(terminal)
    hl.exec_cmd(browser, { workspace = "2 silent" })
    hl.exec_cmd("systemctl --user start plasma-polkit-agent")
end)

local themes = require("colorscheme").themes

-- local border_color = themes.rose_pine.highlight_high_alt
local border_color = {
    colors = {
        themes.rose_pine.rose,
        themes.rose_pine.pine,
        -- themes.rose_pine.rose,
    },
    angle = 225
}
hl.config({
    xwayland = {
        force_zero_scaling = true
    },
    cursor = {
        zoom_disable_aa  = true,
        -- zoom_rigid = true,
        -- zoom_detached_camera = false,
    },
    general = {
        gaps_in          = 5,
        gaps_out         = 10,
        border_size      = 2,
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
        snap = {
            enabled = true,
            respect_gaps = true,
        },
        col = {
            active_border = themes.rose_pine.night,
            inactive_border = themes.rose_pine.surface,
        },
    },

    decoration = {
        rounding         = 12,
        rounding_power   = 4.0,
        dim_strength     = .2,
        -- active_opacity   = 1.0,
        -- inactive_opacity = 1.0,
        shadow = {
            enabled = false,
            color   = themes.rose_pine.highlight_high,
        },
        blur = {
            enabled = false,
            size    = 0,
            passes  = 0,
            noise   = 0,
        },
    },
    dwindle = {
        force_split    = 2,
        preserve_split = true,
    },
    binds = {
        scroll_event_delay = 0
    },
    master = {
        new_status = "master",
    },
    scrolling = {
        fullscreen_on_one_column = true,
    },
    misc = {
        disable_splash_rendering = true,
        disable_hyprland_logo   = true,
        force_default_wallpaper = 0,
        splash_font_family = "ZxProto, Sans",
        font_family = "ZxProto, Sans",
        focus_on_activate = false,
        vrr = 1,
    },
    input = {
        kb_layout  = "us",
        kb_options = "caps:escape",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
    animations = {
        enabled = true,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
    quirks = {
        prefer_hdr = true,
    }
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1  },  {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
-- hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",           enabled = true,  speed = 5,    bezier = "default" })
hl.animation({ leaf = "border",           enabled = true,  speed = 1.25, bezier = "linear" })
hl.animation({ leaf = "windows",          enabled = true,  speed = 1.5,  bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",        enabled = true,  speed = 1.5,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",       enabled = true,  speed = 1.5,  bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",           enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",          enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",             enabled = true,  speed = 2.03, bezier = "quick" })
hl.animation({ leaf = "layers",           enabled = true,  speed = 2.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",         enabled = true,  speed = 3,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",        enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",     enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut",    enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",       enabled = true,  speed = 1,    bezier = "quick", style = "slide" })
hl.animation({ leaf = "zoomFactor",       enabled = true,  speed = 2,    bezier = "quick" })
hl.animation({ leaf = "specialWorkspace", enabled = true,  speed = 2,    bezier = "quick" , style = "fade"})

local screenshot_edit = "$HOME/.config/hypr/scripts/screenshot_edit.sh"
local screenshot_full = "$HOME/.config/hypr/scripts/screenshot_full.sh"
local powermenu       = "$HOME/.config/hypr/scripts/powermenu.sh"

local mod = "SUPER"
-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mod.." + B", hl.dsp.exec_cmd(browser))
hl.bind(mod.." + return", hl.dsp.exec_cmd(terminal))
hl.bind(mod.." + space", hl.dsp.exec_cmd(menu))
hl.bind(mod.." + SHIFT + Q", hl.dsp.exec_cmd(powermenu))
hl.bind(mod.." + SHIFT + X", hl.dsp.window.close())
hl.bind(mod.." + SHIFT + ALT + X", hl.dsp.window.kill())
hl.bind(mod.." + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mod.." + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod.." + E", hl.dsp.window.move({ workspace = "empty" }))
hl.bind(mod.." + I", hl.dsp.exec_cmd(colorpicker))
hl.bind(mod.." + A", hl.dsp.exec_cmd(webapp.."https://chatgpt.com"))
hl.bind(mod.." + D", hl.dsp.exec_cmd(webapp.."https://excalidraw.com"))
hl.bind(mod.." + O", hl.dsp.workspace.toggle_special())
hl.bind(mod.." + semicolon", hl.dsp.layout("togglesplit"))    -- dwindle only

hl.bind("F11", hl.dsp.window.fullscreen())    -- dwindle only
hl.bind(mod.. " + SHIFT + P", hl.dsp.focus({ window = "title:^(Picture-in-Picture)", }))
hl.bind(mod.." + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod.." + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod.." + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod.." + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod.." + tab", hl.dsp.window.cycle_next())

hl.bind(mod.." + SHIFT + H", hl.dsp.window.resize({ x = -50, y =   0,  relative = 0 }))
hl.bind(mod.." + SHIFT + L", hl.dsp.window.resize({ x =  50, y =   0,  relative = 0 }))
hl.bind(mod.." + SHIFT + K", hl.dsp.window.resize({ x =   0, y = -50,  relative = 0 }))
hl.bind(mod.." + SHIFT + J", hl.dsp.window.resize({ x =   0, y =  50,  relative = 0 }))

-- hl.bind(mod.." + SHIFT + semicolon", hl.dsp.exec_cmd("grim - | wayland-boomer -ms 1.2"))

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mod.." + S", hl.dsp.exec_cmd(screenshot_edit))
hl.bind("Print", hl.dsp.exec_cmd(screenshot_edit))
hl.bind(mod.." + SHIFT + S", hl.dsp.exec_cmd(screenshot_full))
hl.bind(mod.." + Print", hl.dsp.exec_cmd(screenshot_full))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mod.." + bracketright", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod.." + bracketleft",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod.." + SHIFT + bracketright", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mod.." + SHIFT + bracketleft",  hl.dsp.window.move({ workspace = "e-1" }))

local max_zoom = 6
local min_zoom = 1
local zoom_factor = 1.5
hl.bind(mod.." + mouse_down", function()
    local zoom = hl.get_config("cursor.zoom_factor") * zoom_factor
    if zoom > max_zoom then
        zoom = max_zoom
    end
    hl.config({
        cursor = {
            zoom_factor = zoom
        }
    })
end)

hl.bind(mod.." + mouse_up", function()
    local zoom = hl.get_config("cursor.zoom_factor") / zoom_factor
    if zoom < min_zoom then
        zoom = min_zoom
    end
    hl.config({
        cursor = {
            zoom_factor = zoom
        }
    })
end)

local function set_zoom_factor(zf)
    return function()
        hl.config({
            cursor = {
                zoom_factor = zf
            }
        })
    end
end

hl.bind(mod.." + SHIFT + mouse_down", set_zoom_factor(max_zoom))
hl.bind(mod.." + SHIFT + mouse_up",   set_zoom_factor(min_zoom))
hl.bind(mod.." + SHIFT + escape",     set_zoom_factor(min_zoom))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mod.." + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod.." + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
-- hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
-- hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

hl.window_rule({
    name  = "Border Highlight on 2 or more windows",
    match = {
        workspace = "w[t2-10]",
    },
    -- border_color = themes.rose_pine.highlight_high_alt,
    border_color = border_color,
    -- suppress_event = "maximize",
})


hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name = "Modal",
    match = {
        modal = true,
    },
    float = true,
    center = true,
    size  = {"(monitor_w*0.5)", "(monitor_h*0.5)"}
})

hl.window_rule({
    name = "Dialogs",
    match = {
        class = "^(file_progress|dialogs|confirm|xdg-desktop-portal-gtk)$"
    },
    float = true,
    center = true,
    size  = {"(monitor_w*0.5)", "(monitor_h*0.5)"}
})

hl.window_rule({
    name = "nm Connection Editor",
    match = {
        class = "^(nm-connection-editor)$"
    },
    float = true,
    center = true,
    size  = {"(monitor_w*0.5)", "(monitor_h*0.5)"},
})

hl.window_rule({
    name = "Blueman Manager",
    match = {
        class = "^(blueman-manager)$"
    },
    float = true,
    center = true,
    size  = {"(window_w*0.5)", "(window_h*0.5)"},
})

hl.window_rule({
    name = "Please Confirm",
    match = {
        class = "^(Please Confirm...)$"
    },
    center = true,
    size  = {"(window_w*0.5)", "(window_h*0.5)"},
})

hl.window_rule({
    name = "Pavucontrol",
    match = {
        class = "^(org.pulseaudio.pavucontrol)$"
    },
    float = true,
    center = true,
    size  = {"(monitor_w*0.5)", "(monitor_h*0.5)"},
    opacity = "0.9 override",
})

hl.window_rule({
    name = "Library",
    match = {
        title = "Library",
    },
    float = true,
    center = true,
    size  = {"(monitor_w*0.5)", "(monitor_h*0.5)"}
})

hl.window_rule({
    name = "Open/Save File windows",
    match = {
        title = "^(Open.*Files?|Save.*Files?)$",
    },
    float = true,
    center = true,
    size  = {"(monitor_w*0.5)", "(monitor_h*0.5)"}
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


hl.window_rule({
    name = "Nautilus",
    match = {
        class = "^(org.gnome.Nautilus)$",
    },
    float  = true,
    center = true,
    size   = { "(monitor_w*0.5)", "(monitor_h*0.6)"},
})

hl.window_rule({
    name = "Viber",
    match = {
        title = "^(ViberPC)$",
    },
    pin    = true,
    float  = true,
    center = true,
    move   = "onscreen 100% 0%",
    workspace = "10 silent",
    border_size = 0,
    no_initial_focus = true,
})

hl.window_rule({
    name = "Discord",
    match = {
        class = "^(discord)$"
    },
    workspace = "4"
})

hl.window_rule({
    name = "Opacity",
    match = {
        class = "^(discord|spotify|blueman-manager|org.gnome.Nautilus|org.gnome.Calculator)$"
    },
    opacity = ".95 override",
})

hl.window_rule({
    name = "Satty",
    match = {
        class = "com.gabm.satty"
    },
    float = true,
    size = { "(monitor_w*0.5)",  "(monitor_h*0.6)" }
})

hl.window_rule({
    name = "Aseprite",
    match = {
        class = "^(Aseprite)$"
    },
    tile = true,
})

hl.window_rule({
    name = "Calculator",
    match = {
        class = "^(Calculator)$"
    },
    float = true,
})

hl.window_rule({
    name = "Picture-in-Picture",
    match = {
        title = "^(Picture-in-Picture)$",
    },
    float = true,
    pin   = true,
    move = {"(monitor_w-window_w-20)", "(monitor_h-window_h-20)"},
    no_initial_focus = true,
    border_color = border_color,
    border_size = 0,
})

hl.window_rule({
    name = "Floating",
    match = {
        float = true,
        focus = true,
    },
    border_color = border_color, -- themes.rose_pine.hightlight_high_alt,
    size  = {"(window_w*1)", "(window_h*1)"},
})

hl.window_rule({
    name = "Steam Floating",
    match = {
        class = "^(steam)$",
        float = true,
    },
    rounding = 0,
    center = false,
    border_size = 0,
    size  = {"(window_w*1)", "(window_h*1)"},
})

hl.window_rule({
    name = "Steam Workspace",
    match = {
        class = "^(steam)$",
        title = "Steam",
        float = false,
    },
    workspace = "5",
})

hl.window_rule({
    name = "Steam Tile Border",
    match = {
        class = "^(steam)$",
        workspace = "w[t1]",
    },
    border_color = themes.rose_pine.night,
})

hl.window_rule({
    name = "Steam Windows",
    match = {
        class = "^(steam)$",
        title = "Friends List|Steam Settings|Sign in to Steam"
    },
    float = true,
    center = true,
    persistent_size = true,
    -- size  = {"(window_w*1)", "(window_h*1)"},
})

hl.window_rule({
    name = "Terminal on Special Workspace",
    match = {
        class = "^(kitty)$",
        workspace = "s[true]",
    },
    enabled = false,
    xray    = true,
    -- blur    = true,
    -- size  = {"(window_w*1)", "(window_h*1)"},
})

hl.window_rule({
    name = "Boomer",
    match = {
        title = "^(wayland-boomer)$"
    },
    fullscreen = true,
    monitor = 1,
    enabled = false,
    move   = { 0, 0 },
    no_anim = true,
    -- size  = {"(window_w*1)", "(window_h*1)"},
})

local wr_zen = hl.window_rule({
    name = "Zen Browser",
    match = {
        class = "^(zen)$",
    },
    workspace = "2 silent",
})

hl.on("window.open", function(w)
    if w.class == "zen" then
        wr_zen:set_enabled(false)
    end
end)
