return function()
  local options = {
    exclude = {
      buftypes = { "nofile", "fzf", "terminal" },
      filetypes = {
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
    },
  }

  require("ibl").setup(options)
end
