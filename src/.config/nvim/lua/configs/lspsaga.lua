return function()
  require("lspsaga").setup({
    beacon = { enable = true, frequency = 500 },
    ui = { border = "rounded", winblend = 0, colors = { normal_bg = "NONE" } },
    scroll_preview = { scroll_down = "<C-d>", scroll_up = "<C-u>" },
    request_timeout = 4000,
    outline = { auto_preview = false },
    code_action = { keys = { quit = { "q", "<Esc>" } } },
    diagnostic = { on_insert = false },
  })
end
