--[[
#_ __ ___   ___  __| (_) ___   ___ _ __ ___
| '_ ` _ \ / _ \/ _` | |/ _ \ / __| '__/ _ \
| | | | | |  __/ (_| | | (_) | (__| | |  __/
|_| |_| |_|\___|\__,_|_|\___/ \___|_|  \___|

--]]
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

--https://awesomewm.org/doc/api/documentation/05-awesomerc.md.html
-- Standard awesome library
local gears = require("gears") --Utilities such as color parsing and objects
local awful = require("awful") --Everything related to window managment
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
naughty.config.defaults["icon_size"] = 50

--local menubar       = require("menubar")

local lain = require("lain")
local freedesktop = require("freedesktop")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
        }
    )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            -- Make sure we don\'t go into an endless error loop
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = "Oops, an error happened!",
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end

-- Autostart windowless processes
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({"unclutter -root"}) -- entries must be comma-separated

-- Variable definitions

local themes = {
    "current-theme",
    "powerarrow-dark", -- 1
    "powerarrow-solarized-light", -- 2
    "powerarrow-modus-operandi", -- 3
    "powerarrow-nord", -- 4
    "powerarrow-wal", -- 5
    "powerarrow-blue", -- 6
    "powerarrow-tomorrow", -- 7
    "powerarrow", -- 8
    "multicolor", -- 9
    "blackburn", -- 10
    "copland", -- 11
    "dremora", -- 12
    "holo", -- 13
    "rainbow", -- 14
    "steamburn", -- 15
    "vertex", -- 16
    "macos-bright", -- 17
    "macos-dark" -- 18
}

-- choose your theme here
local chosen_theme = themes[1]

local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
beautiful.init(theme_path)

-- modkey or mod4 = super key
local modkey = "Mod4"
local altkey = "Mod1"
local modkey1 = "Control"

-- personal variables
--change these variables if you want
local browser = "brave"
local editor = os.getenv("EDITOR") or "nvim"
local HOME = os.getenv("HOME")
local editorgui = "Emacs"
local filemanager = "thunar"
local mailclient = "geary"
local mediaplayer = "mpv"
local scrlocker = "betterlockscreen"
local terminal = "alacritty"
local virtualmachine = "virtualbox"

-- awesome variables
awful.layout.layouts = {
    awful.layout.suit.tile,
    lain.layout.centerwork,
    awful.layout.suit.floating,
    lain.layout.centerwork.horizontal,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.magnifier
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.max,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.termfair,
    --lain.layout.termfair.center,
}

awful.util.terminal = terminal
-- awful.util.tagnames = {  "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  "  }
--awful.util.tagnames = { "⠐", "⠡", "⠲", "⠵", "⠻", "⠿" }
-- awful.util.tagnames = { "⌘", "♐", "⌥", "ℵ" }
-- awful.util.tagnames = {" WWW ", " DEV ", " TGRAM ", " DIS ", " SYS ", " ANME ", " GAME ", " TRSH "} -- Deprecated, use themes tagnames
-- Use this : https://fontawesome.com/cheatsheet
--awful.util.tagnames = { "", "", "", "", "" }

my_tags = {
    tags = {
        {
            names = {
                "   Ⅰ   ",
                "   Ⅱ   ",
                "   Ⅲ   ",
                "   Ⅳ   ",
                "   Ⅴ   ",
                "   Ⅵ   ",
                "   Ⅶ   ",
                "   Ⅷ   "
            },
            layout = {
                awful.layout.layouts[1],
                awful.layout.layouts[1],
                awful.layout.layouts[1],
                awful.layout.layouts[1],
                awful.layout.layouts[2],
                awful.layout.layouts[2],
                awful.layout.layouts[2],
                awful.layout.layouts[2]
            }
        },
        {
            names = {
                "   Ⅰ   ",
                "   Ⅱ   ",
                "   Ⅲ   ",
                "   Ⅳ   ",
                "   Ⅴ   ",
                "   Ⅵ   ",
                "   Ⅶ   ",
                "   Ⅷ   "
            },
            layout = {
                awful.layout.layouts[5],
                awful.layout.layouts[5],
                awful.layout.layouts[5],
                awful.layout.layouts[5],
                awful.layout.layouts[5],
                awful.layout.layouts[5],
                awful.layout.layouts[5],
                awful.layout.layouts[5]
            }
        },
        {
            names = {
                "   Ⅰ   ",
                "   Ⅱ   ",
                "   Ⅲ   ",
                "   Ⅳ   ",
                "   Ⅴ   ",
                "   Ⅵ   ",
                "   Ⅶ   ",
                "   Ⅷ   "
            },
            layout = {
                awful.layout.layouts[1],
                awful.layout.layouts[1],
                awful.layout.layouts[1],
                awful.layout.layouts[1],
                awful.layout.layouts[1],
                awful.layout.layouts[1],
                awful.layout.layouts[1],
                awful.layout.layouts[1]
            }
        }
    }
}

awful.layout.suit.tile.left.mirror = true
awful.util.taglist_buttons =
    my_table.join(
    awful.button(
        {},
        1,
        function(t)
            t:view_only()
        end
    ),
    awful.button(
        {modkey},
        1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button(
        {modkey},
        3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        {},
        4,
        function(t)
            awful.tag.viewnext(t.screen)
        end
    ),
    awful.button(
        {},
        5,
        function(t)
            awful.tag.viewprev(t.screen)
        end
    )
)

awful.util.tasklist_buttons =
    my_table.join(
    awful.button(
        {},
        1,
        function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate", "tasklist", {raise = true})
            end
        end
    ),
    awful.button(
        {},
        3,
        function()
            local instance = nil

            return function()
                if instance and instance.wibox.visible then
                    instance:hide()
                    instance = nil
                else
                    instance = awful.menu.clients({theme = {width = 250}})
                end
            end
        end
    ),
    awful.button(
        {},
        4,
        function()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button(
        {},
        5,
        function()
            awful.client.focus.byidx(-1)
        end
    )
)

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
lain.layout.cascade.tile.offset_x = 2
lain.layout.cascade.tile.offset_y = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster = 5
lain.layout.cascade.tile.ncol = 2

beautiful.init(string.format(gears.filesystem.get_configuration_dir() .. "/themes/%s/theme.lua", chosen_theme))

-- Menu
local myawesomemenu = {
    {
        "hotkeys",
        function()
            return false, hotkeys_popup.show_help
        end
    },
    {"manual", terminal .. " -e 'man awesome'"},
    {"edit config", terminal .. " vim /home/mediocre/.config/awesome/rc.lua"},
    {"arandr", "arandr"},
    {"restart", awesome.restart}
}

awful.util.mymainmenu =
    freedesktop.menu.build(
    {
        icon_size = beautiful.menu_height or 16,
        before = {
            {"Awesome", myawesomemenu, beautiful.awesome_icon}
            --{ "Atom", "atom" },
            -- other triads can be put here
        },
        after = {
            {"Terminal", terminal},
            {
                "Log out",
                function()
                    awesome.quit()
                end
            },
            {"Sleep", "systemctl suspend"},
            {"Restart", "systemctl reboot"},
            {"Exit", "systemctl poweroff"}
            -- other triads can be put here
        }
    }
)
--menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it

-- Screen
-- Re-set wallpaper when a screen\'s geometry changes (e.g. different resolution)
screen.connect_signal(
    "property::geometry",
    function(s)
        -- Wallpaper
        if beautiful.wallpaper then
            local wallpaper = beautiful.wallpaper
            -- If wallpaper is a function, call it with the screen
            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end
)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
    function(s)
        screen_index = s.index
        awful.tag(my_tags.tags[screen_index].names, s, my_tags.tags[screen_index].layout)
        beautiful.at_screen_connect(s)
    end
)

-- Mouse bindings
root.buttons(
    my_table.join(
        awful.button(
            {},
            3,
            function()
                awful.util.mymainmenu:toggle()
            end
        )
        -- awful.button({ }, 4, awful.tag.viewnext),
        -- awful.button({ }, 5, awful.tag.viewprev)
    )
)
-- m

local mpdmap = {
    {
        "s",
        function()
            awful.util.spawn("mpd")
        end,
        "start MPD"
    },
    {
        "S",
        function()
            awful.util.spawn("mpd --kill")
        end,
        "kill MPD"
    },
    {
        "u",
        function()
            awful.util.spawn("mpc update")
        end,
        "update MPD"
    },
    {
        "g",
        function()
            awful.util.spawn(terminal .. " -e ncmpc")
        end,
        "ncmpc"
    },
    {
        "G",
        function()
            awful.util.spawn(terminal .. " -e ncmpcpp")
        end,
        "ncmpcpp"
    },
    {"separator", "Playback"},
    {
        "m",
        function()
            awful.util.spawn("mpc toggle")
        end,
        "Toggle"
    },
    {
        ".",
        function()
            awful.util.spawn("mpc next")
        end,
        "Next"
    },
    {
        ",",
        function()
            awful.util.spawn("mpc prev")
        end,
        "Prev"
    },
    {"separator", "Volume"},
    {
        "k",
        function()
            awful.util.spawn("mpc volume +2")
        end,
        "+volume"
    },
    {
        "j",
        function()
            awful.util.spawn("mpc volume -2")
        end,
        "-volume"
    }
}

local utilsmap = {
    {"separator", "Packages"},
    {
        "u",
        function()
            awful.util.spawn(terminal .. " -e yay -Syu")
        end,
        "upd packages"
    },
    {
        "c",
        function()
            awful.util.spawn(terminal .. " -e yay -Sc")
        end,
        "clear packages cache"
    },
    {"separator", "Other"},
    {
        "p",
        function()
            awful.util.spawn("flameshot gui")
        end,
        "screenshot"
    },
    {
        "m",
        function()
            awful.util.spawn("mansplain")
        end,
        "read man"
    },
    {
        "r",
        function()
            awful.util.spawn("docread")
        end,
        "open book"
    },
    {
        "e",
        function()
            awful.util.spawn("dmenuunicode")
        end,
        "open emoji list"
    },
    {
        "s",
        function()
            awful.util.spawn(
                -- "passmenu -nb '#3b4252' -sf '#88c0d0' -sb '#4c566a' -nf '#a89984' -fn 'Mononoki Nerd Font:bold:pixelsize=13'"
                "keeclip -d " .. HOME .. "/passwrds/passwrds.kdbx"
            )
        end,
        "clip password or username"
    },
    {
        "g",
        function()
            awful.util.spawn("peek")
        end,
        "record gif"
    },
    {
        "k",
        function()
            awful.util.spawn("xkill")
        end,
        "kill window"
    }
}

local systemmap = {
    {
        "p",
        function()
            awful.util.spawn("systemctl poweroff")
        end,
        "power off"
    },
    {
        "r",
        function()
            awful.util.spawn("systemctl reboot")
        end,
        "reboot"
    },
    {
        "s",
        function()
            awful.util.spawn("systemctl suspend")
        end,
        "supend"
    },
    {"separator", "Lock screen"},
    {
        "l",
        function()
            awful.util.spawn("betterlockscreen -l")
        end,
        "lock"
    }
}

local appsmap = {
    {"separator", "Editors"},
    {
        "v",
        function()
            awful.util.spawn(terminal .. " -e nvim ")
        end,
        "nvim"
    },

    {
        "e",
        function()
            awful.util.spawn("emacs")
            -- awful.util.spawn("emacs")
        end,
        "keimacs"
    },
    {"separator", "Media"},
    {
        "d",
        function()
            awful.util.spawn("Discord")
        end,
        "discord-gui"
    },
    {
        "D",
        function()
            awful.util.spawn(terminal .. " -e cordless")
        end,
        "discord-tui"
    },
    {
        "t",
        function()
            awful.util.spawn("telegram-desktop")
        end,
        "telegram-gui"
    },
    {
        "T",
        function()
            awful.util.spawn(terminal .. " -e tg")
        end,
        "telegram-tui"
    },
    {
        "n",
        function()
            awful.util.spawn(terminal .. " -e newsboat")
        end,
        "newsboat"
    },
    {"separator", "File Managers"},
    {
        "f",
        function()
            awful.util.spawn("thunar")
        end,
        "thunar"
    },
    {
        "r",
        function()
            awful.util.spawn(terminal .. " -e ranger")
        end,
        "ranger"
    },
    {"separator", "Other"},
    {
        "j",
        function()
            awful.util.spawn(terminal .. " -e joplin")
        end,
        "joplin"
    },
    {
        "b",
        function()
            awful.util.spawn(browser)
        end,
        "browser"
    },
    {
        "B",
        function()
            awful.util.spawn(browser .. " --incognito")
            -- awful.util.spawn(browser .. " --private-window")
        end,
        "browser incognito"
    },
    {
        "s",
        function()
            awful.util.spawn("steam")
        end,
        "steam"
    },
    {
        "V",
        function()
            awful.util.spawn("VirtualBox")
        end,
        "VirtualBox"
    },
    {
        "K",
        function()
            awful.util.spawn("keepassxc")
        end,
        "Keepassxc"
    }
}

local volumemap = {
    {"separator", "ALSA"},
    {
        "k",
        -- { "XF86AudioRaiseVolume",
        function()
            os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        "+vol"
    },
    {
        "j",
        -- { "XF86AudioLowerVolume",
        function()
            os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        "-vol"
    },
    {
        "m",
        function()
            os.execute(
                string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel)
            )
            beautiful.volume.update()
        end,
        "toggle vol"
    },
    -- { "separator", "Other" },
    {
        "p",
        function()
            awful.util.spawn("pavucontrol")
        end,
        "pavucontrol"
    }
}

-- Modalbind
local modalbind = require("modalbind")
-- modalbind.set_opacity()
modalbind.init()

-- {{{ Key bindings
globalkeys =
    my_table.join(
    -- {{{ Personal keybindings

    -- System map
    awful.key(
        {modkey},
        "q",
        function()
            modalbind.grab {keymap = systemmap, name = "System", layout = 0, stay_in_mode = false}
        end
    ),
    -- MPD map
    awful.key(
        {modkey},
        "/",
        function()
            modalbind.grab {keymap = mpdmap, name = "MPD", layout = 0, stay_in_mode = true}
        end
    ),
    -- Apps map
    awful.key(
        {modkey},
        "p",
        function()
            modalbind.grab {keymap = appsmap, name = "Apps", layout = 0, stay_in_mode = false}
        end
    ),
    -- Volume map
    awful.key(
        {modkey},
        "v",
        function()
            modalbind.grab {keymap = volumemap, name = "Volume", layout = 0, stay_in_mode = true}
        end
    ),
    -- Utils map
    awful.key(
        {modkey},
        "y",
        function()
            modalbind.grab {keymap = utilsmap, name = "Utils", layout = 0, stay_in_mode = false}
        end
    ),
    -- dmenu
    awful.key(
        {modkey},
        "space",
        function()
            awful.spawn(
                string.format(
                 "dmenu_run",
                    beautiful.bg_normal,
                    beautiful.fg_normal,
                    beautiful.bg_focus,
                    beautiful.fg_focus
                )
            )
        end,
        {description = "show dmenu", group = "hotkeys"}
    ),
    -- Personal keybindings}}}

    -- Hotkeys Awesome

    awful.key({modkey}, "s", hotkeys_popup.show_help, {description = "show help", group = "awesome"}),
    -- Tag browsing with modkey
    awful.key({modkey}, "Left", awful.tag.viewprev, {description = "view previous", group = "tag"}),
    awful.key({modkey}, "Right", awful.tag.viewnext, {description = "view next", group = "tag"}),
    awful.key({altkey}, "Escape", awful.tag.history.restore, {description = "go back", group = "tag"}),
    -- Tag browsing modkey + tab
    awful.key({modkey}, "Tab", awful.tag.viewnext, {description = "view next", group = "tag"}),
    awful.key({modkey, "Shift"}, "Tab", awful.tag.viewprev, {description = "view previous", group = "tag"}),
    -- Default client focus
    -- awful.key({ altkey,           }, "j",
    -- function ()
    --   awful.client.focus.byidx( 1)
    -- end,
    -- {description = "focus next by index", group = "client"}
    -- ),
    -- awful.key({ altkey,           }, "k",
    -- function ()
    --   awful.client.focus.byidx(-1)
    -- end,
    -- {description = "focus previous by index", group = "client"}
    -- ),

    -- By direction client focus
    awful.key(
        {modkey},
        "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus down", group = "client"}
    ),
    awful.key(
        {modkey},
        "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus up", group = "client"}
    ),
    awful.key(
        {modkey},
        "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus left", group = "client"}
    ),
    awful.key(
        {modkey},
        "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus right", group = "client"}
    ),
    -- By direction client focus with arrows
    awful.key(
        {modkey1, modkey},
        "Down",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus down", group = "client"}
    ),
    awful.key(
        {modkey1, modkey},
        "Up",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus up", group = "client"}
    ),
    awful.key(
        {modkey1, modkey},
        "Left",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus left", group = "client"}
    ),
    awful.key(
        {modkey1, modkey},
        "Right",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus right", group = "client"}
    ),
    awful.key(
        {modkey},
        "w",
        function()
            awful.util.mymainmenu:show()
        end,
        {description = "show main menu", group = "awesome"}
    ),
    -- Layout manipulation
    awful.key(
        {modkey, "Shift"},
        "j",
        function()
            awful.client.swap.byidx(1)
        end,
        {description = "swap with next client by index", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "k",
        function()
            awful.client.swap.byidx(-1)
        end,
        {description = "swap with previous client by index", group = "client"}
    ),
    awful.key(
        {modkey},
        ".",
        function()
            awful.screen.focus_relative(1)
        end,
        {description = "focus the next screen", group = "screen"}
    ),
    awful.key(
        {modkey},
        ",",
        function()
            awful.screen.focus_relative(-1)
        end,
        {description = "focus the previous screen", group = "screen"}
    ),
    awful.key({modkey}, "u", awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}),
    awful.key(
        {modkey1},
        "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}
    ),
    -- Show/Hide Wibox
    awful.key(
        {modkey},
        "b",
        function()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "toggle wibox", group = "awesome"}
    ),
    -- On the fly useless gaps change
    awful.key(
        {altkey, "Control"},
        "h",
        function()
            lain.util.useless_gaps_resize(1)
        end,
        {description = "increment useless gaps", group = "tag"}
    ),
    awful.key(
        {altkey, "Control"},
        "l",
        function()
            lain.util.useless_gaps_resize(-1)
        end,
        {description = "decrement useless gaps", group = "tag"}
    ),
    -- Dynamic tagging
    awful.key(
        {modkey, "Shift"},
        "n",
        function()
            lain.util.add_tag()
        end,
        {description = "add new tag", group = "tag"}
    ),
    awful.key(
        {modkey, "Control"},
        "r",
        function()
            lain.util.rename_tag()
        end,
        {description = "rename tag", group = "tag"}
    ),
    awful.key(
        {modkey, "Shift"},
        "Left",
        function()
            lain.util.move_tag(-1)
        end,
        {description = "move tag to the left", group = "tag"}
    ),
    awful.key(
        {modkey, "Shift"},
        "Right",
        function()
            lain.util.move_tag(1)
        end,
        {description = "move tag to the right", group = "tag"}
    ),
    awful.key(
        {modkey, "Shift"},
        "d",
        function()
            lain.util.delete_tag()
        end,
        {description = "delete tag", group = "tag"}
    ),
    -- Standard program
    awful.key(
        {modkey, altkey},
        "Return",
        function()
            awful.spawn(terminal .. " -e bash ")
        end,
        {description = "term with bash", group = "super"}
    ),
    awful.key(
        {modkey},
        "Return",
        function()
            awful.spawn(terminal)
        end,
        {description = "term with zsh", group = "super"}
    ),
    awful.key({modkey, "Shift"}, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
    awful.key(
        {modkey, "Shift"},
        "q",
        function()
            awful.spawn.with_shell('~/.dmenu/prompt "are you sure?" "killall awesome"')
        end,
        {description = "quit awesome", group = "awesome"}
    ),
    awful.key(
        {altkey, "Shift"},
        "l",
        function()
            awful.tag.incmwfact(0.05)
        end,
        {description = "increase master width factor", group = "layout"}
    ),
    awful.key(
        {altkey, "Shift"},
        "h",
        function()
            awful.tag.incmwfact(-0.05)
        end,
        {description = "decrease master width factor", group = "layout"}
    ),
    awful.key(
        {altkey, "Shift"},
        "j",
        function()
            awful.client.incwfact(0.05)
        end,
        {description = "increase master height factor", group = "layout"}
    ),
    awful.key(
        {altkey, "Shift"},
        "k",
        function()
            awful.client.incwfact(-0.05)
        end,
        {description = "decrease master height factor", group = "layout"}
    ),
    awful.key(
        {modkey, "Shift"},
        "h",
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        {description = "increase the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey, "Shift"},
        "l",
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = "decrease the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey, "Control"},
        "h",
        function()
            awful.tag.incncol(1, nil, true)
        end,
        {description = "increase the number of columns", group = "layout"}
    ),
    awful.key(
        {modkey, "Control"},
        "l",
        function()
            awful.tag.incncol(-1, nil, true)
        end,
        {description = "decrease the number of columns", group = "layout"}
    ),
    awful.key(
        {altkey},
        "space",
        function()
            awful.layout.inc(1)
        end,
        {description = "select next", group = "layout"}
    ),
    awful.key(
        {altkey, "Shift"},
        "space",
        function()
            awful.layout.inc(-1)
        end,
        {description = "select previous", group = "layout"}
    ),
    awful.key(
        {modkey, "Control"},
        "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        {description = "restore minimized", group = "client"}
    ),
    -- Dropdown application
    awful.key(
        {modkey},
        "z",
        function()
            awful.screen.focused().quake:toggle()
        end,
        {description = "dropdown application", group = "super"}
    ),
    -- Widgets popups
    -- awful.key(
    --     {altkey},
    --     "c",
    --     function()
    --         lain.widget.cal().show(3)
    --     end,
    --     {description = "show calendar", group = "widgets"}
    -- ),
    -- awful.key(
    --     {altkey},
    --     "h",
    --     function()
    --         if beautiful.fs then
    --             beautiful.fs.show(7)
    --         end
    --     end,
    --     {description = "show filesystem", group = "widgets"}
    -- ),

    -- Brightness
     awful.key({ }, "XF86MonBrightnessUp", function () os.execute("xbacklight -inc 10") end,
               {description = "+10%", group = "hotkeys"}),
     awful.key({ }, "XF86MonBrightnessDown", function () os.execute("xbacklight -dec 10") end,
               {description = "-10%", group = "hotkeys"}),

    -- Spotify control from XM4
     awful.key({ }, "XF86AudioPlay", function () os.execute("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play") end,
               {description = "Play Spotify playback", group = "hotkeys"}),

     awful.key({ }, "XF86AudioPause", function () os.execute("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause") end,
               {description = "Pause Spotify playback", group = "hotkeys"}),

     awful.key({ }, "XF86AudioNext", function () os.execute("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next") end,
               {description = "Next Track", group = "hotkeys"}),

     awful.key({ }, "XF86AudioPrev", function () os.execute("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous") end,
               {description = "Pause Spotify playback", group = "hotkeys"}),


    -- Copy primary to clipboard (terminals to gtk)
    awful.key(
        {modkey},
        "c",
        function()
            awful.spawn.with_shell("xsel | xsel -i -b")
        end,
        {description = "copy terminal to gtk", group = "hotkeys"}
    ),
    -- Copy clipboard to primary (gtk to terminals)
    awful.key(
        {modkey},
        "v",
        function()
            awful.spawn.with_shell("xsel -b | xsel")
        end,
        {description = "copy gtk to terminal", group = "hotkeys"}
    ),
    -- Default
    -- [[ Menubar

    -- awful.key({ modkey }, "p", function() menubar.show() end,
    -- {description = "show the menubar", group = "super"}),

    --]]
    awful.key(
        {altkey, "Shift"},
        "x",
        function()
            awful.prompt.run {
                prompt = "Run Lua code: ",
                textbox = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {description = "lua execute prompt", group = "awesome"}
    )
    --]]
)

clientkeys =
    my_table.join(
    awful.key({altkey, "Shift"}, "m", lain.util.magnify_client, {description = "magnify client", group = "client"}),
    awful.key(
        {modkey},
        "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}
    ),
    awful.key(
        {modkey},
        "x",
        function(c)
            c:kill()
        end,
        {description = "close", group = "hotkeys"}
    ),
    awful.key(
        {modkey, "Shift"},
        "space",
        awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}
    ),
    awful.key(
        {modkey, "Control"},
        "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}
    ),
    awful.key(
        {modkey},
        "o",
        function(c)
            c:move_to_screen()
        end,
        {description = "move to screen", group = "client"}
    ),
    awful.key(
        {modkey},
        "t",
        function(c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}
    ),
    awful.key(
        {modkey},
        "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can\'t have the focus.
            c.minimized = true
        end,
        {description = "minimize", group = "client"}
    ),
    awful.key(
        {modkey},
        "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "maximize", group = "client"}
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys =
        my_table.join(
        globalkeys,
        -- View tag only.
        awful.key(
            {modkey},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            descr_view
        ),
        -- Toggle tag display.
        awful.key(
            {modkey, "Control"},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            descr_toggle
        ),
        -- Move client to tag.
        awful.key(
            {modkey, "Shift"},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            descr_move
        ),
        -- Toggle tag on focused client.
        awful.key(
            {modkey, "Control", "Shift"},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            descr_toggle_focus
        )
    )
end

clientbuttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    awful.button(
        {modkey},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        {modkey},
        3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
    )
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false
        }
    },
    -- Titlebars
    {
        rule_any = {type = {"dialog", "normal"}},
        properties = {titlebars_enabled = false}
    },
    -- Set applications to always map on the tag 1 on screen 1.
    -- find class or role via xprop command

    -- {
    --     rule = {class = "Opera"},
    --     properties = {screen = 1, tag = my_tags.tags[1].names[1]}
    -- },
    -- {
    -- rule = {class = editorgui},
    -- properties = {screen = 1, tag = my_tags.tags[1].names[2]}
    -- },
    {
        rule = {class = "TelegramDesktop"},
        properties = {screen = 2, tag = my_tags.tags[2].names[4]}
    },
    {
        rule = {name = "tg"},
        properties = {screen = 2, tag = my_tags.tags[2].names[4]}
    },
    {
        rule = {class = "discord"},
        properties = {screen = 2, tag = my_tags.tags[2].names[4]}
    },
    {
        rule = {name = "cordless"},
        properties = {screen = 2, tag = my_tags.tags[2].names[4]}
    },
    {
        rule = {class = "Steam"},
        properties = {screen = 3, tag = my_tags.tags[3].names[7]}
    },
    -- {
    --   rule = {class = "Sxiv"},
    --   properties = {screen = 1, tag = my_tags.tags[1].names[5]}
    -- },
    {
        rule = {class = "Barrier"},
        properties = {screen = 3, tag = my_tags.tags[3].names[6]}
    },
    -- {
    --   rule = {class = "Zathura"},
    --   properties = {screen = 1, tag = my_tags.tags[1].names[4]}
    -- },
    -- {
    --   rule = {class = mediaplayer},
    --   properties = {screen = 1, tag = my_tags.tags[1].names[6]}
    -- },
    -- Set applications to be maximized at startup.
    -- find class or role via xprop command
    -- {
    -- rule = {class = mediaplayer},
    -- properties = {maximized = true}
    -- },
    {
        rule = {class = "Vlc"},
        properties = {maximized = true}
    },
    {
        rule = {class = "Xfce4-settings-manager"},
        properties = {floating = false}
    },
    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq" -- Includes session name in class.
            },
            class = {
                "Arandr",
                "Blueberry",
                "Galculator",
                "Gnome-font-viewer",
                "Gpick",
                "Imagewriter",
                "Font-manager",
                "Kruler",
                "MessageWin", -- kalarm.
                "Oblogout",
                "Peek",
                "Skype",
                "System-config-printer.py",
                -- "Sxiv",
                "Unetbootin.elf",
                "Wpa_gui",
                -- "TelegramDesktop",
                "pinentry",
                "veromix",
                "xtightvncviewer",
                "Steam"
            },
            name = {
                "Media viewer",
                "Event Tester" -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
                "Preferences",
                "setup"
            }
        },
        properties = {floating = true}
    }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end
        -- if awesome.startup and
        -- not c.size_hints.user_position
        -- and not c.size_hints.program_position then
        -- -- Prevent clients from being unreachable after screen count changes.
        -- awful.placement.no_offscreen(c)
        -- end
        if not awesome.startup then
            awful.client.setslave(c)
        end
    end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
    "request::titlebars",
    function(c)
        -- Custom
        if beautiful.titlebar_fun then
            beautiful.titlebar_fun(c)
            return
        end

        -- Default
        -- buttons for the titlebar
        local buttons =
            my_table.join(
            awful.button(
                {},
                1,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.move(c)
                end
            ),
            awful.button(
                {},
                3,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.resize(c)
                end
            )
        )

        awful.titlebar(c, {size = 21}):setup {
            {
                -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout = wibox.layout.fixed.horizontal
            },
            {
                -- Middle
                {
                    -- Title
                    align = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout = wibox.layout.flex.horizontal
            },
            {
                -- Right
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end
)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal(
-- "mouse::enter",
-- function(c)
--   c:emit_signal("request::activate", "mouse_enter", {raise = true})
-- end
-- )

-- No border for maximized clients
function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal("focus", border_adjust)
client.connect_signal("property::maximized", border_adjust)
client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.border_normal
    end
)

-- }}}

-- Autostart applications
awful.spawn.with_shell("~/.config/awesome/autostart.sh")
-- awful.spawn.with_shell("picom --config  $HOME/.config/picom/picom.conf")
