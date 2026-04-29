local theme_assets              = require("beautiful.theme_assets")
local xresources                = require("beautiful.xresources")
local dpi                       = xresources.apply_dpi

local gfs                       = require("gears.filesystem")
local themes_path               = gfs.get_themes_dir()

local theme                     = {}

theme.font                      = "IosevkaTermNF 14"

theme.bg_normal                 = "#181616"
theme.bg_focus                  = "#535d6c"
theme.bg_urgent                 = "#e46876"

theme.bg_systray                = theme.bg_normal
theme.fg_systray                = theme.fg_normal

theme.fg_normal                 = "#c5c9c5"
theme.fg_focus                  = theme.fg_normal
theme.fg_urgent                 = theme.fg_normal

theme.useless_gap               = dpi(6)
theme.gap_single_client         = false
theme.border_width              = dpi(3)
theme.border_normal             = "#0d0c0c"
theme.border_focus              = "#938aa9"
theme.border_marked             = "#91231c"

theme.taglist_bg_focus = theme.border_focus
theme.taglist_fg_focus = theme.fg_normal
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_fg_urgent = theme.fg_normal

theme.tasklist_bg_focus = theme.border_focus
theme.tasklist_bg_urgent = theme.bg_urgent
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"


-- Variables set for theming notifications:
theme.notification_font         = theme.font

-- notification_[bg|fg]
theme.notification_width        = dpi(300)
theme.notification_height       = dpi(100)
theme.notification_border_width = theme.border_width
theme.notification_border_color = theme.bg_focus

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon         = themes_path .. "default/submenu.png"
theme.menu_height               = dpi(32)
theme.menu_width                = dpi(200)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.wallpaper                 = gfs.get_configuration_dir() .. "background-image"

-- You can use your own layout icons like this:
theme.layout_fairh              = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv              = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating           = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier          = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max                = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen         = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom         = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft           = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile               = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop            = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral             = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle            = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw           = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne           = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw           = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse           = themes_path .. "default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon              = theme_assets.awesome_icon(
	theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme                = nil

return theme
