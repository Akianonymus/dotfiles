return function()
  require("lspsaga").setup({
    ui = { border = "rounded", winblend = 0, colors = { normal_bg = "NONE" } },
    scroll_preview = { scroll_down = "<C-d>", scroll_up = "<C-u>" },
    request_timeout = 3000,
    outline = { auto_preview = false },
    symbol_in_winbar = { separator = "  " },
    code_action = { keys = { quit = { "q", "<Esc>" } } },
  })
end
