local colors = {
    rose_pine = {
        night           = "rgba(000000ff)",
        base            = "rgba(000000ff)",
        base_alt        = "rgba(191724ff)",
        surface         = "rgba(110d12ff)",
        overlay         = "rgba(121212ff)",
        surface_alt     = "rgba(1f1d2eff)",
        overlay_alt     = "rgba(26233aff)",
        muted           = "rgba(6e6a86ff)",
        subtle          = "rgba(908caaff)",
        text            = "rgba(e0def4ff)",
        love            = "rgba(eb6f92ff)",
        gold            = "rgba(f6c177ff)",
        rose            = "rgba(ebbcbaff)",
        pine            = "rgba(31748fff)",
        foam            = "rgba(9ccfd8ff)",
        iris            = "rgba(c4a7e7ff)",
        highlight_low   = "rgba(21202eff)",
        highlight_med   = "rgba(403d52ff)",
        highlight_high  = "rgba(110d12ff)",
    }
}

local app_runner  = "app2unit"
local terminal    = app_runner.." kitty"
local browser     = app_runner.." zen-browser"
local google      = app_runner.." chromium"
local menu        = "rofi -show drun -run-command \""..app_runner.." {cmd}\""
local colorpicker = "hyprpicker -a"
local webapp      = google .. " --new-window --app"

local screenshot_edit = "$HOME/.config/hypr/scripts/screenshot_edit.sh"
local screenshot_full = "$HOME/.config/hypr/scripts/screenshot_full.sh"
local powermenu       = "$HOME/.config/hypr/scripts/powermenu.sh"

hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = "1.2",
})

hl.on("hyprland.start", function()
    -- hl.exec_cmd("hyprpaper")
    hl.exec_cmd(terminal, {
        workspace = "1 silent",
    })
    hl.exec_cmd(browser, {
        workspace = "2 silent",
    })
    hl.exec_cmd("systemctl --user start plasma-polkit-agent")
end)

hl.config({
    xwayland = {
        force_zero_scaling = true
    },
    general = {
        gaps_in  = 5,
        gaps_out = 10,
        border_size = 2,
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
        snap = {
            enabled = true,
            respect_gaps = true,
        },
        col = {
            active_border = colors.rose_pine.highlight_high,
            inactive_border = colors.rose_pine.surface,
        },
    },

    decoration = {
        rounding       = 12,
        rounding_power = 4.0,
        dim_strength   = .2,
        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = false,
            color = colors.rose_pine.highlight_high,
        },
        blur = {
            enabled = false,
            size = 2,
            passes = 2,
        },
    },
    dwindle = {
        force_split = 2,
        preserve_split = true, -- You probably want this
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
        disable_splash_rendering = false,
        splash_font_family = "ZxProto, Sans",
        font_family = "ZxProto, Sans",
        force_default_wallpaper = 0,
        disable_hyprland_logo   = false,
        focus_on_activate = false
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
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/

hl.curve("myBezier",       { type = "bezier", points = { {0.15, 0.9},  {0.1, 1}    } })
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1  },  {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 5,    bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 2.39, bezier = "linear" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 1.5,  bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 1.5,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.5,  bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 2.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 2.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 3,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1,    bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 2,    bezier = "quick" })
-- hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })


hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

local mod = "SUPER"
-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd(powermenu))
hl.bind(mod .. " + SHIFT + X", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + E", hl.dsp.window.move({ workspace = "empty" }))
hl.bind(mod .. " + I", hl.dsp.exec_cmd(colorpicker))
hl.bind(mod .. " + A", hl.dsp.exec_cmd(webapp.." https://chatgpt.com"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(webapp.." https://excalidraw.com"))
hl.bind(mod .. " + O", hl.dsp.workspace.toggle_special())
hl.bind(mod .. " + semicolon", hl.dsp.layout("togglesplit"))    -- dwindle only

hl.bind("F11", hl.dsp.window.fullscreen())    -- dwindle only
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprctl dispatch focuswindow \"title:^(Picture-in-Picture)$\""))

hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))


for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mod .. " + S", hl.dsp.exec_cmd(screenshot_full))
hl.bind("Print", hl.dsp.exec_cmd(screenshot_full))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshot_edit))
hl.bind(mod .. " + Print", hl.dsp.exec_cmd(screenshot_edit))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mod .. " + bracketright", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + bracketleft",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mod .. " + SHIFT + bracketleft",  hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mod .. " + mouse_down",   hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 1.5) | if . > 5 then 5 else . end')"))
hl.bind(mod .. " + mouse_up", hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor 1"))
hl.bind(mod .. " + escape",   hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor 1"))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name = "GDK Portal",
    match = {
        class = "^(xdg-desktop-portal-gtk)$"
    },
    float = true,
    center = true,
    size  = {"(monitor_w*0.5)", "(monitor_h*0.5)"}
})

hl.window_rule({
    name = "Dialogs",
    match = {
        class = "^(file_progress|dialogs|confirm)$"
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
    workspace = "4 silent"
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
        class = "^(Picture-in-Picture)$"
    },
    float = true,
    pin   = true,
    move = {"(monitor_w-window_w-20)", "(monitor_h-window_h-20)"},
    border_size = 0,
})

hl.window_rule({
    name = "Floating",
    match = {
        float = true,
    },
    border_size = 2,
    size  = {"(window_w*1)", "(window_h*1)"},
    border_color = colors.rose_pine.surface_alt,
})

hl.window_rule({
    name = "Steam Floating",
    match = {
        class = "^(steam)$",
        float = true,
    },
    center = false,
    border_size = 2,
    size  = {"(window_w*1)", "(window_h*1)"},
    workspace = "5 silent",
})

hl.window_rule({
    name = "Steam Tiled",
    match = {
        title = "^(Steam)$",
    },
    tile = true,
})
