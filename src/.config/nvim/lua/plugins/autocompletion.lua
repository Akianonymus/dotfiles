return {
  -- snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    build = "make install_jsregexp",
    config = function()
      require("luasnip").setup({ history = true, delete_check_events = "TextChanged" })
    end,
  },
  -- generate documentation
  {
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("neogen").setup({ { snippet_engine = "luasnip" } })
    end,
    init = require("mappings").neogen,
  },
  {
    "windwp/nvim-autopairs",
    dependencies = { "nvim-cmp", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-autopairs").setup({ check_ts = true, disable_filetype = { "TelescopePrompt", "vim" } })
    end,
  },
  -- autocompletion
  {
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
      { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
      { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
      "https://codeberg.org/FelipeLema/cmp-async-path",
      "jcha0713/cmp-tw2css",
      "saadparwaiz1/cmp_luasnip",
    },
    config = require("configs.cmp"),
  },
  {
    "iguanacucumber/mag-cmdline",
    name = "cmp-cmdline",
    event = "CmdlineEnter",
    dependencies = { "nvim-cmp" },
    config = require("configs.cmp.cmdline"),
  },

  -- ai
}
