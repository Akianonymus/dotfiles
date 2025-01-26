return {
  -- generic lsp plugins
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      "williamboman/mason.nvim",
      "ray-x/lsp_signature.nvim",
    },
    config = function()
      require("configs.lspconfig")
    end,
  },
  {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    cmd = "Mason",
    opts = {},
  },
  {
    "nvimtools/none-ls.nvim",
    event = { "VeryLazy" },
    dependencies = { "neovim/nvim-lspconfig", "gbprod/none-ls-shellcheck.nvim", "gbprod/none-ls-luacheck.nvim" },
    config = require("configs.null-ls"),
  },
  {
    "glepnir/lspsaga.nvim",
    cmd = "Lspsaga",
    dependencies = { "neovim/nvim-lspconfig" },
    config = require("configs.lspsaga"),
  },
  {
    "ray-x/lsp_signature.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = require("configs.lsp_signature"),
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({ auto_close = true, use_diagnostic_signs = true, padding = false })
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- require("lsp-file-operations").setup()
    end,
  },

  -- language specific lsp plugins
  {
    "folke/neodev.nvim",
    ft = "lua",
    config = function()
      require("neodev").setup({ library = { plugins = false }, experimental = { pathStrict = true } })
    end,
  },
  { "mfussenegger/nvim-jdtls" },
  {
    "yioneko/nvim-vtsls",
  },
}
