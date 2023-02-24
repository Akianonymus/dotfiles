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
    dependencies = { "hrsh7th/nvim-cmp", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-autopairs").setup({ check_ts = true, disable_filetype = { "TelescopePrompt", "vim" } })
    end,
  },
  -- cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "jcha0713/cmp-tw2css",
      "saadparwaiz1/cmp_luasnip",
    },
    config = require("configs.cmp"),
  },
  {
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter",
    dependencies = { "nvim-cmp" },
    config = require("configs.cmp.cmdline"),
  },
}
