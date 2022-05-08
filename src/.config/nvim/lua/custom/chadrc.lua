local M = {}

M.options = {
   user = function()
      local opt = vim.opt
      -- local g = vim.g

      opt.tabstop = 4
      opt.undofile = false
   end,

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
   options = {
      statusline = {
         separator_style = "arrow",
      },
   },
   remove = {
      "neovim/nvim-lspconfig",
      "williamboman/nvim-lsp-installer",
   },
   user = "custom.plugins",
}

M.plugins.override = {
   ["max397574/better-escape.nvim"] = { mapping = { "jk", "JK", "Jk" } },
   ["akinsho/bufferline.nvim"] = { options = { custom_areas = false } },
   ["windwp/nvim-autopairs"] = { check_ts = true },
   ["NvChad/nvim-colorizer.lua"] = require("custom.plugins.common").colorizer(),
   ["neovim/nvim-lspconfig"] = require("custom.plugins.common").lspconfig(),
   ["ray-x/lsp_signature.nvim"] = require("custom.plugins.common").lsp_signature(),
   ["kyazdani42/nvim-tree.lua"] = require("custom.plugins.common").nvimtree(),
   ["nvim-treesitter/nvim-treesitter"] = require("custom.plugins.common").treesitter(),
   ["nvim-telescope/telescope.nvim"] = require("custom.plugins.common").telescope(),
}

M.mappings = { -- terminal related mappings
   misc = function()
      require("custom.mappings").misc()
   end,
}

return M
