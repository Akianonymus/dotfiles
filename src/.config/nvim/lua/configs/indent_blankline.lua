return function()
  local options = {
    filetype_exclude = {
      "help",
      "terminal",
      "packer",
      "lspinfo",
      "TelescopePrompt",
      "TelescopeResults",
      "mason",
      "neo-tree",
      "Trouble",
      "lazy",
      "",
    },
    buftype_exclude = { "nofile", "fzf", "terminal" },
    show_trailing_blankline_indent = false,
    show_current_context = true,
    show_current_context_start = false,
  }

  require("indent_blankline").setup(options)
end
