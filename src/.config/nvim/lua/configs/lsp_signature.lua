local config = {
  bind = false, -- This is mandatory, otherwise border config won't get registered.
  -- If you want to hook lspsaga or other signature handler, pls set to false

  max_width = 80,
  max_height = 5,
  wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long

  close_timeout = 2000, -- close floating window after ms when laster parameter is entered
  fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
  hint_enable = false, -- virtual hint enable
  handler_opts = {
    border = "rounded", -- double, rounded, single, shadow, none, or a table of borders
  },
  floating_window_above_cur_line = true,
  always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
  zindex = 40, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

  padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
  timer_interval = 100, -- default timer check interval set to lower value if you want to reduce latency
  toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
  move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
}

return function()
  require("lsp_signature").setup(config)
end
