local M = {}

M.options = {
  nvChad = {
    -- update_url = "https://github.com/Akianonymus/NvChad",
    update_url = "https://github.com/NvChad/NvChad",
    update_branch = "main",
  },
}

M.ui = {
  theme = "tokyodark", -- default theme
}

M.plugins = {
  remove = {
    "folke/which-key.nvim",
    "kyazdani42/nvim-tree.lua",
    "neovim/nvim-lspconfig",
    "NvChad/nvterm",
  },
  user = require "custom.plugins",
}

M.plugins.override = {
  ["max397574/better-escape.nvim"] = { mapping = { "jk", "JK", "Jk" } },
  ["windwp/nvim-autopairs"] = { check_ts = true },
  ["NvChad/nvim-colorizer.lua"] = require("custom.plugins.common").colorizer(),
  ["nvim-telescope/telescope.nvim"] = require("custom.plugins.common").telescope(),
  ["NvChad/ui"] = { tabufline = { enabled = false }, statusline = { separator_style = "arrow" } },
}

M.mappings = {
  telescope = require("custom.mappings").telescope,
  disabled = require("custom.mappings").disabled,
}

return M
