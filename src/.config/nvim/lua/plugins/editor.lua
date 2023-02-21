return {
  {
    "numToStr/Comment.nvim",
    init = require("mappings").comment,
  },
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    config = require("configs.fzf"),
    init = require("mappings").fzflua,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    "ziontee113/icon-picker.nvim",
    cmd = { "IconPickerNormal", "IconPickerInsert", "IconPickerYank" },
    config = function()
      require("icon-picker").setup({ disable_legacy_commands = true })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = require("configs.neotree"),
    init = require("mappings").neotree,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    config = require("configs.colorizer"),
  },
  {
    "windwp/nvim-spectre",
    command = "FindReplace",
    config = function()
      require("spectre").setup({ open_cmd = "vertical new", is_insert_mode = true })
    end,
    init = function()
      require("mappings").spectre()
      require("commands").spectre()
    end,
  },
  {
    "VonHeikemen/searchbox.nvim",
    command = "SearchBox",
    dependencies = { "MunifTanjim/nui.nvim" },
    init = require("mappings").searchbox,
    config = function()
      require("searchbox").setup({ popup = { zindex = 100 } })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    init = require("mappings").telescope,
    config = require("configs.telescope"),
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    config = require("configs.toggleterm"),
    init = require("mappings").toggleterm,
  },
}
