local config = {
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "css",
    "go",
    "javascript",
    "typescript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "vim",
  },
  highlight = { enable = true, use_languagetree = true, additional_vim_regex_highlighting = true },
  indent = { enable = true },
  matchup = { enable = true },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "windwp/nvim-ts-autotag" },
    build = ":TSUpdate",
    lazy = false,
    opts = config,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      })
    end,
  },
}
