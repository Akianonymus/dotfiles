local mappings = require("mappings")
return {
  { "folke/lazy.nvim", version = "*" },
  {
    "nmac427/guess-indent.nvim",
    event = "BufReadPost",
    config = function()
      require("guess-indent").setup()
    end,
  },
  {
    "max397574/better-escape.nvim",
    event = "VeryLazy",
    config = function()
      local maps = { j = { k = "<Esc>" }, J = { K = "<Esc>", k = "<Esc>" } }
      require("better_escape").setup({ mappings = { i = maps, c = maps, t = maps, v = maps, s = maps } })
    end,
  },
  {
    "0xAdk/full_visual_line.nvim",
    keys = "V",
    opts = {},
  },
  {
    "ggandor/lightspeed.nvim",
    keys = { "s", "S", "t", "T", "f", "F" },
    config = function()
      require("lightspeed").setup({ ignore_case = true, repeat_ft_with_target_char = true })
    end,
  },
  { "echasnovski/mini.bufremove", keys = mappings.bufremove },
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    config = function()
      require("numb").setup()
    end,
  },
  {
    "ethanholz/nvim-lastplace",
    event = "BufReadPost",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_open_folds = true,
			-- stylua: ignore
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "hgcommit", "help", "terminal", "packer", "lspinfo", "TelescopePrompt", "TelescopeResults", "mason", "lazy", "", },
        buftype_exclude = { "nofile", "quickfix", "nofile", "help", "fzf", "terminal" },
      })
    end,
  },
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },
  {
    "gbprod/yanky.nvim",
    keys = mappings.yanky,
    config = function()
      require("yanky").setup({ highlight = { timer = 200 } })
    end,
  },
}
