return {
	["AKI DARK"] = {
		foreground = "#c0caf5",
		background = "#1a1b25",

		cursor_fg = "#1a1b25",
		cursor_bg = "#B898CC",
		cursor_border = "#52ad70",

		selection_fg = "#c0caf5",
		selection_bg = "#33467C",

		scrollbar_thumb = "#222222",

		split = "#00ff00",

		ansi = {
			-- "black",
			-- "maroon",
			-- "green",
			-- "olive",
			-- "navy",
			-- "purple",
			-- "teal",
			-- "silver",
			"#15161E",
			"#f7768e",
			"#9ece6a",
			"#e0af68",
			"#7aa2f7",
			"#bb9af7",
			"#7dcfff",
			"#a9b1d6",
		},
		brights = {
			-- "grey",
			-- "red",
			-- "lime",
			-- "yellow",
			-- "blue",
			-- "fuchsia",
			-- "aqua",
			-- "white",
			"#414868",
			"#f7768e",
			"#9ece6a",
			"#e0af68",
			"#7aa2f7",
			"#bb9af7",
			"#7dcfff",
			"#c0caf5",
		},

		indexed = { [136] = "#af8700" },

		-- Since: 20220319-142410-0fcdea07
		-- When the IME, a dead key or a leader key are being processed and are effectively
		-- holding input pending the result of input composition, change the cursor
		-- to this color to give a visual cue about the compose state.
		compose_cursor = "orange",

		-- Colors for copy_mode and quick_select
		-- available since: 20220807-113146-c2fee766
		-- In copy_mode, the color of the active text is:
		-- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
		-- 2. selection_* otherwise
		copy_mode_active_highlight_bg = { Color = "#000000" },
		-- use `AnsiColor` to specify one of the ansi color palette values
		-- (index 0-15) using one of the names "Black", "Maroon", "Green",
		--  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
		-- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
		copy_mode_active_highlight_fg = { AnsiColor = "Black" },
		copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
		copy_mode_inactive_highlight_fg = { AnsiColor = "White" },

		quick_select_label_bg = { Color = "peru" },
		quick_select_label_fg = { Color = "#ffffff" },
		quick_select_match_bg = { AnsiColor = "Navy" },
		quick_select_match_fg = { Color = "#ffffff" },
		tab_bar = {
			-- The color of the strip that goes along the top of the window
			-- (does not apply when fancy tab bar is in use)
			background = "#1a1b25",

			-- The active tab is the one that has focus in the window
			active_tab = {
				bg_color = "#7aa2f7",
				fg_color = "#1f2335",
				intensity = "Bold",
				underline = "None",
				italic = true,
				strikethrough = false,
			},

			-- Inactive tabs are the tabs that do not have focus
			inactive_tab = {
				bg_color = "#292e42",
				fg_color = "#545c7e",
			},

			inactive_tab_hover = {
				bg_color = "#3b3052",
				fg_color = "#909090",
				italic = true,
			},

			new_tab = {
				bg_color = "#1b1032",
				fg_color = "#808080",
			},
			new_tab_hover = {
				bg_color = "#3b3052",
				fg_color = "#909090",
				italic = true,
			},
		},
	},
}
