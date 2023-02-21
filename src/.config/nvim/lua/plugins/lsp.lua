return {
  -- generic lsp plugins
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
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
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
    end,
  },
  { "smjonas/inc-rename.nvim", cmd = "IncRename", config = true },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "neovim/nvim-lspconfig" },
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
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("trouble").setup({ auto_close = true, use_diagnostic_signs = true, padding = false })
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
}
