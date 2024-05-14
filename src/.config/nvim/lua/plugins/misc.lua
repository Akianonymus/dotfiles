local leet_arg = "leetcode.nvim"
return {
  {
    "kawre/leetcode.nvim",
    lazy = leet_arg ~= vim.fn.argv()[1],
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",
      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- configuration goes here
    },
  },
  {
    "NStefan002/speedtyper.nvim",
    cmd = "Speedtyper",
    opts = {
      -- your config
    },
  },
  {
    "NStefan002/2048.nvim",
    cmd = "Play2048",
    config = true,
    opts = {
      keymaps = { up = "<Up>", down = "<Down>", right = "<Right>", left = "<Left>" },
    },
  },
}
