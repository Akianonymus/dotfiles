local wezterm = require("wezterm")
local mux = wezterm.mux

local config = wezterm.config_builder()

-- setup colors
config.color_schemes = require("akithemes")
config.color_scheme = "AKI DARK"

config.inactive_pane_hsb = { saturation = 1, brightness = 1 }

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font({ family = "FiraCode Nerd Font Mono", weight = "Bold" }),

	-- The size of the font in the tab bar.
	-- Default to 10.0 on Windows but 12.0 on other systems
	font_size = 12.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "#1a1b25",

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = "red",
}

config.use_fancy_tab_bar = false

config.window_padding = { left = 2, right = 1, top = 2, bottom = 2 }

config.hide_tab_bar_if_only_one_tab = false

config.tab_max_width = 20

config.font = wezterm.font("FiraCode Nerd Font Mono")

config.line_height = 1.6

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_key_table() or "")
end)

config.disable_default_key_bindings = true

config.keys = require("keys")

config.key_tables = require("key_tables")

config.animation_fps = 30
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.audible_bell = "Disabled"

config.switch_to_last_active_tab_when_closing_tab = true
config.window_decorations = "RESIZE"

local cache_dir = os.getenv("HOME") .. "/.cache/wezterm/"
local window_size_cache_path = cache_dir .. "window_size_cache.txt"

wezterm.on("gui-startup", function()
	os.execute("mkdir -p " .. cache_dir)

	local window_size_cache_file = io.open(window_size_cache_path, "r")
	local window, width, height
	if window_size_cache_file ~= nil then
		_, _, width, height = string.find(window_size_cache_file:read(), "(%d+),(%d+)")
		_, _, window = mux.spawn_window({ width = tonumber(width), height = tonumber(height) })
		window_size_cache_file:close()
	else
		_, _, window = mux.spawn_window({})
		window:gui_window():maximize()
	end
end)

wezterm.on("window-resized", function(_, pane)
	local tab_size = pane:tab():get_size()
	local cols = tab_size["cols"]
	local rows = tab_size["rows"] + 2 -- Without adding the 2 here, the window doesn't maximize
	local contents = string.format("%d,%d", cols, rows)

	local window_size_cache_file = io.open(window_size_cache_path, "w")
	-- Check if the file was successfully opened
	if window_size_cache_file then
		window_size_cache_file:write(contents)
		window_size_cache_file:close()
	else
		print("Error: Could not open file for writing: " .. window_size_cache_path)
	end
end)
return config
