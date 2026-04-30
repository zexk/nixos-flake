local modkey = "Mod4"
local terminal = "alacritty"

-- https://github.com/tonybanters/oxwm/issues/53
local colors = {
	bg = "#ff181616",
	fg = "#ffc5c9c5",
	black = "#ff0d0c0c",
	blue = "#ff8ba4b0",
	cyan = "#ff8ea4a2",
	green = "#ff8a9a7b",
	magenta = "#ffa292a3",
	red = "#ffc4746e",
	white = "#ffc8c093",
	yellow = "#ffc4b28a",
}

local tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

local bar_font = "IosevkaTerm Nerd Font:style=Regular:size=14"

local blocks = {
	oxwm.bar.block.ram({
		format = "ram: {used}/{total}GB",
		interval = 5,
		color = colors.cyan,
		underline = true,
	}),
	oxwm.bar.block.static({
		text = "│",
		interval = 999999999,
		color = colors.fg,
		underline = false,
	}),
	oxwm.bar.block.datetime({
		format = "{}",
		date_format = "%Y/%m/%d %a - %H:%M:%S",
		interval = 1,
		color = colors.fg,
		underline = false,
	}),
};

-------------------------------------------------------------------------------
-- Basic Settings
-------------------------------------------------------------------------------
oxwm.set_terminal(terminal)
oxwm.set_modkey(modkey) -- This is for Mod + mouse binds, such as drag/resize
oxwm.set_tags(tags)

oxwm.set_floating_position("center")
-------------------------------------------------------------------------------
-- Layouts
-------------------------------------------------------------------------------
-- Set custom symbols for layouts (displayed in the status bar)
-- Available layouts: "tiling", "normie" (floating), "grid", "monocle", "tabbed"
oxwm.set_layout_symbol("tiling", "[t]")
oxwm.set_layout_symbol("normie", "[f]")
oxwm.set_layout_symbol("tabbed", "[=]")

-------------------------------------------------------------------------------
-- appearance
-------------------------------------------------------------------------------
oxwm.border.set_width(3)
oxwm.border.set_focused_color(colors.magenta)
oxwm.border.set_unfocused_color(colors.bg)

oxwm.gaps.set_smart(true)
oxwm.gaps.set_inner(12, 12)
oxwm.gaps.set_outer(12, 12)


-------------------------------------------------------------------------------
-- Window Rules
-------------------------------------------------------------------------------
-- Available properties: floating, tag, fullscreen, etc.

-- Examples (uncomment to use):
oxwm.rule.add({ instance = "drawy", tag = 6, fullscreen = true })
-- oxwm.rule.add({ class = "Alacritty", tag = 9, focus = true })
-- oxwm.rule.add({ class = "firefox", title = "Library", floating = true })
-- oxwm.rule.add({ class = "firefox", tag = 2 })
-- oxwm.rule.add({ instance = "mpv", floating = true })
--
oxwm.bar.set_font(bar_font)
oxwm.bar.set_blocks(blocks)

oxwm.bar.set_scheme_normal(colors.fg, colors.bg, "#444444")
oxwm.bar.set_scheme_occupied(colors.fg, colors.magenta, colors.cyan)
oxwm.bar.set_scheme_selected(colors.fg, colors.green, colors.magenta)
oxwm.bar.set_scheme_urgent(colors.fg, colors.red, colors.red)

oxwm.bar.set_hide_vacant_tags(true)

-------------------------------------------------------------------------------
-- Keybindings
-------------------------------------------------------------------------------
oxwm.key.bind({ modkey }, "p", oxwm.spawn({ "sh", "-c", "dmenu_run -l 10" }))
oxwm.key.bind({ modkey }, "s", oxwm.spawn({ "sh", "-c", "maim -s | xclip -selection clipboard -t image/png" }))

oxwm.key.bind({ modkey }, "q", oxwm.client.kill())
oxwm.key.bind({ modkey, "Shift" }, "Slash", oxwm.show_keybinds())

oxwm.key.bind({ modkey }, "f", oxwm.client.toggle_fullscreen())
oxwm.key.bind({ modkey, "Shift" }, "Space", oxwm.client.toggle_floating())

oxwm.key.bind({ modkey }, "n", oxwm.layout.cycle())

oxwm.key.bind({ modkey }, "h", oxwm.set_master_factor(-10))
oxwm.key.bind({ modkey }, "l", oxwm.set_master_factor(10))

oxwm.key.bind({ modkey, "Shift" }, "q", oxwm.quit())
oxwm.key.bind({ modkey, "Shift" }, "r", oxwm.restart())

-- Focus movement [1 for up in the stack, -1 for down]
oxwm.key.bind({ modkey }, "j", oxwm.client.focus_stack(1))
oxwm.key.bind({ modkey }, "k", oxwm.client.focus_stack(-1))
-- Window movement (swap position in stack)
oxwm.key.bind({ modkey, "Shift" }, "j", oxwm.client.move_stack(1))
oxwm.key.bind({ modkey, "Shift" }, "k", oxwm.client.move_stack(-1))

oxwm.key.bind({ modkey }, "Comma", oxwm.monitor.focus(-1))
oxwm.key.bind({ modkey }, "Period", oxwm.monitor.focus(1))
oxwm.key.bind({ modkey, "Shift" }, "Comma", oxwm.monitor.tag(-1))
oxwm.key.bind({ modkey, "Shift" }, "Period", oxwm.monitor.tag(1))

-- tag navigation
oxwm.key.bind({ modkey }, "1", oxwm.tag.view(0))
oxwm.key.bind({ modkey }, "2", oxwm.tag.view(1))
oxwm.key.bind({ modkey }, "3", oxwm.tag.view(2))
oxwm.key.bind({ modkey }, "4", oxwm.tag.view(3))
oxwm.key.bind({ modkey }, "5", oxwm.tag.view(4))
oxwm.key.bind({ modkey }, "6", oxwm.tag.view(5))
oxwm.key.bind({ modkey }, "7", oxwm.tag.view(6))
oxwm.key.bind({ modkey }, "8", oxwm.tag.view(7))
oxwm.key.bind({ modkey }, "9", oxwm.tag.view(8))
-- Move focused window to workspace N
oxwm.key.bind({ modkey, "Shift" }, "1", oxwm.tag.move_to(0))
oxwm.key.bind({ modkey, "Shift" }, "2", oxwm.tag.move_to(1))
oxwm.key.bind({ modkey, "Shift" }, "3", oxwm.tag.move_to(2))
oxwm.key.bind({ modkey, "Shift" }, "4", oxwm.tag.move_to(3))
oxwm.key.bind({ modkey, "Shift" }, "5", oxwm.tag.move_to(4))
oxwm.key.bind({ modkey, "Shift" }, "6", oxwm.tag.move_to(5))
oxwm.key.bind({ modkey, "Shift" }, "7", oxwm.tag.move_to(6))
oxwm.key.bind({ modkey, "Shift" }, "8", oxwm.tag.move_to(7))
oxwm.key.bind({ modkey, "Shift" }, "9", oxwm.tag.move_to(8))
-- Example: Mod+Ctrl+2 while on tag 1 will show BOTH tags 1 and 2
oxwm.key.bind({ modkey, "Control" }, "1", oxwm.tag.toggleview(0))
oxwm.key.bind({ modkey, "Control" }, "2", oxwm.tag.toggleview(1))
oxwm.key.bind({ modkey, "Control" }, "3", oxwm.tag.toggleview(2))
oxwm.key.bind({ modkey, "Control" }, "4", oxwm.tag.toggleview(3))
oxwm.key.bind({ modkey, "Control" }, "5", oxwm.tag.toggleview(4))
oxwm.key.bind({ modkey, "Control" }, "6", oxwm.tag.toggleview(5))
oxwm.key.bind({ modkey, "Control" }, "7", oxwm.tag.toggleview(6))
oxwm.key.bind({ modkey, "Control" }, "8", oxwm.tag.toggleview(7))
oxwm.key.bind({ modkey, "Control" }, "9", oxwm.tag.toggleview(8))
-- Multi tag (window on multiple tags)
oxwm.key.bind({ modkey, "Control", "Shift" }, "1", oxwm.tag.toggletag(0))
oxwm.key.bind({ modkey, "Control", "Shift" }, "2", oxwm.tag.toggletag(1))
oxwm.key.bind({ modkey, "Control", "Shift" }, "3", oxwm.tag.toggletag(2))
oxwm.key.bind({ modkey, "Control", "Shift" }, "4", oxwm.tag.toggletag(3))
oxwm.key.bind({ modkey, "Control", "Shift" }, "5", oxwm.tag.toggletag(4))
oxwm.key.bind({ modkey, "Control", "Shift" }, "6", oxwm.tag.toggletag(5))
oxwm.key.bind({ modkey, "Control", "Shift" }, "7", oxwm.tag.toggletag(6))
oxwm.key.bind({ modkey, "Control", "Shift" }, "8", oxwm.tag.toggletag(7))
oxwm.key.bind({ modkey, "Control", "Shift" }, "9", oxwm.tag.toggletag(8))
oxwm.key.chord({
	{ { modkey }, "Space" },
	{ {},         "t" }
}, oxwm.spawn_terminal())

-------------------------------------------------------------------------------
-- Autostart
-------------------------------------------------------------------------------
-- Commands to run once when OXWM starts
-- Uncomment and modify these examples, or add your own

-- oxwm.autostart("picom")
oxwm.autostart("feh --bg-scale ~/background-image")
-- oxwm.autostart("dunst")
-- oxwm.autostart("nm-applet")
