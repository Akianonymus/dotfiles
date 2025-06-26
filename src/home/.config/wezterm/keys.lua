local act = require("wezterm").action
local wezterm = require("wezterm")

return {
	-- next tab previous tab
	{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "l", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(1) },
	{ key = "h", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },

	{ key = "n", mods = "SHIFT|CTRL", action = act.SpawnWindow },
	{ key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "Enter", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = act.ActivateKeyTable({
			name = "Resize Pane",
			one_shot = false,
		}),
	},
	{
		key = "P",
		mods = "CTRL",
		action = act.ActivateCommandPalette,
	},

	{ key = "X", mods = "CTRL", action = act.ActivateCopyMode },
	{
		key = "W",
		mods = "CTRL",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{ key = "{", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
	{ key = "}", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },

	{ key = "C", mods = "CTRL", action = act.CopyTo("ClipboardAndPrimarySelection") },
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "V", mods = "CTRL", action = act.PasteFrom("PrimarySelection") },

	{ key = "<", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1) },
	{ key = ">", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1) },

	{ key = "F11", action = act.ToggleFullScreen },

	{ key = "+", mods = "CTRL|SHIFT", action = act.IncreaseFontSize },
	{ key = "_", mods = "CTRL|SHIFT", action = act.DecreaseFontSize },
}
