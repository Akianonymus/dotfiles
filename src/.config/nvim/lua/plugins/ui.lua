local mappings = require("mappings")
return {
  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    config = require("configs.bufferline"),
    init = mappings.bufferline,
  },
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    config = require("configs.lualine"),
  },
  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    config = function()
      require("dressing").setup({ input = { mappings = { n = { ["q"] = "Close" } } } })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = require("configs.indent_blankline"),
  },
  -- noicer ui
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    keys = mappings.noice,
    config = require("configs.noice"),
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      vim.notify = require("notify")
      require("notify").setup({
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.60)
        end,
      })
    end,
  },
  {
    "mg979/vim-visual-multi",
    keys = { { "<A-n>", mode = { "" } } },
    init = mappings.vim_visual_multi,
  },
}
